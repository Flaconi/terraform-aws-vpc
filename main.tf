# -------------------------------------------------------------------------------------------------
# VPC Resources
# -------------------------------------------------------------------------------------------------
module "aws_vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.11.0"

  cidr            = var.vpc_cidr
  azs             = var.vpc_subnet_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway   = var.vpc_enable_nat_gateway
  enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  reuse_nat_ips       = var.vpc_reuse_nat_ips
  external_nat_ip_ids = local.ids_of_eips_for_natgws

  customer_gateways = var.vpc_customer_gateways

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

  source = "github.com/Flaconi/terraform-aws-elb?ref=v1.1.0"

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

data "template_file" "user_data" {
  count = var.vpc_enable_bastion_host ? 1 : 0

  template = file("${path.module}/user_data.sh")

  vars = {
    ssh_user = "ec2-user"
    ssh_keys = join("\n", var.bastion_ssh_keys)
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

resource "aws_launch_configuration" "bastion" {
  count = var.vpc_enable_bastion_host ? 1 : 0

  name_prefix       = local.bastion_lc_name
  image_id          = data.aws_ami.bastion[0].image_id
  instance_type     = var.bastion_instance_type
  user_data         = data.template_file.user_data[0].rendered
  security_groups   = [aws_security_group.bastion[0].id]
  enable_monitoring = false

  associate_public_ip_address = false

  root_block_device {
    volume_size = "8"
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
  launch_configuration      = aws_launch_configuration.bastion[0].name

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

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = local.bastion_asg_name
        "propagate_at_launch" = true
      }
    ],
    local.tags_asg_format,
  )

  lifecycle {
    create_before_destroy = true
  }
}
