# -------------------------------------------------------------------------------------------------
# VPC Resources
# -------------------------------------------------------------------------------------------------
module "aws_vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v5.16.0"

  cidr            = var.vpc_cidr
  azs             = var.vpc_subnet_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  map_public_ip_on_launch = true

  secondary_cidr_blocks = var.vpc_secondary_cidr_blocks

  enable_nat_gateway   = var.vpc_enable_nat_gateway
  enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az
  reuse_nat_ips          = var.vpc_reuse_nat_ips
  external_nat_ip_ids    = local.ids_of_eips_for_natgws

  customer_gateways = var.vpc_customer_gateways

  manage_default_route_table     = false
  manage_default_network_acl     = false
  manage_default_security_group  = var.manage_default_security_group
  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress

  name     = var.name
  tags     = var.tags
  vpc_tags = var.vpc_tags

  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}

# -------------------------------------------------------------------------------------------------
# Bastion ELB
# -------------------------------------------------------------------------------------------------
module "aws_elb" {
  enable = var.vpc_enable_bastion_host

  source = "github.com/Flaconi/terraform-aws-elb?ref=v2.0.0"

  name       = local.bastion_elb_name
  vpc_id     = module.aws_vpc.vpc_id
  subnet_ids = module.aws_vpc.public_subnets

  # Listener
  lb_port       = 22
  instance_port = 22

  # Security
  inbound_cidr_blocks  = var.bastion_ssh_cidr_blocks
  security_group_names = var.bastion_security_group_names

  # DNS
  route53_public_dns_name = var.bastion_route53_public_dns_name

  tags = var.tags
}

# -------------------------------------------------------------------------------------------------
# Bastion Host
# -------------------------------------------------------------------------------------------------
data "aws_ami" "bastion" {
  count = var.vpc_enable_bastion_host ? 1 : 0

  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "bastion" {
  count = var.vpc_enable_bastion_host ? 1 : 0

  name_prefix = local.bastion_sg_name
  description = "Security group for the ${local.bastion_lc_name} launch configuration"
  vpc_id      = module.aws_vpc.vpc_id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = module.aws_elb.security_group_ids
    description     = "External SSH. Allow SSH access to bastion instances from this security group (by ELB or instance)."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "AWS default egress rule"
  }

  revoke_rules_on_delete = true

  # Ensure a new sg is in place before destroying the current one.
  # This will/should prevent any race-conditions.
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      "Name" = local.bastion_asg_name
    },
  )
}

resource "aws_launch_template" "bastion" {
  count = var.vpc_enable_bastion_host ? 1 : 0

  name_prefix            = local.bastion_lc_name
  image_id               = var.bastion_ami != null ? var.bastion_ami : data.aws_ami.bastion[0].image_id
  instance_type          = var.bastion_instance_type
  vpc_security_group_ids = [aws_security_group.bastion[0].id]
  user_data = length(var.bastion_ssh_keys) > 0 ? base64encode(templatefile("${path.module}/user_data.sh.tftpl",
    {
      ssh_user = "ec2-user"
      ssh_keys = join("\n", var.bastion_ssh_keys)
    }
  )) : null

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = "8"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  count = var.vpc_enable_bastion_host ? 1 : 0

  name_prefix = local.bastion_asg_name

  vpc_zone_identifier = module.aws_vpc.private_subnets

  desired_capacity          = var.bastion_cluster_size
  min_size                  = var.bastion_cluster_size
  max_size                  = var.bastion_cluster_size
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_template {
    id      = aws_launch_template.bastion[0].id
    version = aws_launch_template.bastion[0].latest_version
  }

  load_balancers = [module.aws_elb.id]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  dynamic "tag" {
    for_each = concat(
      [
        {
          key                 = "Name"
          value               = local.bastion_asg_name
          propagate_at_launch = true
        }
      ],
      local.tags_asg_format,
    )
    content {
      key                 = tag.value["key"]
      value               = tag.value["value"]
      propagate_at_launch = tag.value["propagate_at_launch"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
