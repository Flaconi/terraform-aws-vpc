# -------------------------------------------------------------------------------------------------
# VPC Resources
# -------------------------------------------------------------------------------------------------
module "aws_vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v1.46.0"

  cidr            = "${var.vpc_cidr}"
  azs             = "${var.vpc_subnet_azs}"
  private_subnets = "${var.vpc_private_subnets}"
  public_subnets  = "${var.vpc_public_subnets}"

  enable_nat_gateway = "${var.vpc_enable_nat_gateway}"
  enable_vpn_gateway = "${var.vpc_enable_vpn_gateway}"

  name                = "${var.name}"
  tags                = "${var.tags}"
  vpc_tags            = "${var.vpc_tags}"
  public_subnet_tags  = "${var.public_subnet_tags}"
  private_subnet_tags = "${var.private_subnet_tags}"
}

data "aws_vpc" "this" {
  id = "${module.aws_vpc.vpc_id}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.this.id}"
  tags   = "${var.private_subnet_tags}"
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.this.id}"
  tags   = "${var.public_subnet_tags}"
}

# -------------------------------------------------------------------------------------------------
# Bastion Host ELB Security Groups
# -------------------------------------------------------------------------------------------------
resource "aws_security_group" "bastion_elb" {
  name_prefix = "${var.name}-bastion-elb-ssh"
  vpc_id      = "${data.aws_vpc.this.id}"
  description = "ELB bastion host security group (only SSH inbound access is allowed)"
  tags        = "${merge(map("Name", "${var.name}-bastion-elb"), "${var.tags}")}"

  revoke_rules_on_delete = true

  # Ensure a new sg is in place before destroying the current one.
  # This will/should prevent any race-conditions.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "bastion_elb_ssh_ingress" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = "${var.bastion_ssh_cidr_blocks}"
  security_group_id = "${aws_security_group.bastion_elb.id}"
}

resource "aws_security_group_rule" "bastion_elb_all_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_elb.id}"
}

# -------------------------------------------------------------------------------------------------
# Bastion Host Security Groups
# -------------------------------------------------------------------------------------------------
resource "aws_security_group" "bastion" {
  name_prefix = "${var.name}-bastion-ssh-from-elb"
  vpc_id      = "${data.aws_vpc.this.id}"
  description = "Bastion host security group (only SSH inbound access from ELB is allowed)"
  tags        = "${merge(map("Name", "${var.name}-bastion"), "${var.tags}")}"

  revoke_rules_on_delete = true

  # Ensure a new sg is in place before destroying the current one.
  # This will/should prevent any race-conditions.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion_elb.id}"
  security_group_id        = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion.id}"
}

# -------------------------------------------------------------------------------------------------
# Bastion Host ELB
# -------------------------------------------------------------------------------------------------
resource "aws_elb" "bastion" {
  name            = "${var.name}-bastion-elb"
  subnets         = ["${data.aws_subnet_ids.public.ids}"]
  security_groups = ["${aws_security_group.bastion_elb.id}"]

  listener {
    instance_port     = 22
    instance_protocol = "TCP"
    lb_port           = 22
    lb_protocol       = "TCP"
  }
}

data "aws_route53_zone" "bastion" {
  name         = "${var.bastion_host_route53_public_zone_name}."
  private_zone = false
}

resource "aws_route53_record" "bastion" {
  count   = "${var.bastion_create_dns ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.bastion.zone_id}"
  name    = "bastion-${var.name}.${data.aws_route53_zone.bastion.name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.bastion.dns_name}"
    zone_id                = "${aws_elb.bastion.zone_id}"
    evaluate_target_health = false
  }
}

# -------------------------------------------------------------------------------------------------
# Bastion Host
# -------------------------------------------------------------------------------------------------
data "aws_ami" "bastion" {
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
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    ssh_user = "ec2-user"
    ssh_keys = "${join("\n", "${var.bastion_ssh_keys}")}"
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix       = "${var.name}-bastion-lc"
  image_id          = "${data.aws_ami.bastion.image_id}"
  instance_type     = "${var.bastion_instance_type}"
  user_data         = "${data.template_file.user_data.rendered}"
  security_groups   = ["${aws_security_group.bastion.id}"]
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
  name = "${var.name}-bastion-asg"

  vpc_zone_identifier = ["${data.aws_subnet_ids.private.ids}"]

  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.bastion.name}"

  load_balancers = ["${aws_elb.bastion.name}"]

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

  tags = ["${concat(
    list(map("key", "Name", "value", "${var.name}-bastion-asg", "propagate_at_launch", true)),
    local.tags_asg_format
	)}"]

  lifecycle {
    create_before_destroy = true
  }
}
