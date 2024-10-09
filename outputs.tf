# -------------------------------------------------------------------------------------------------
# VPC
# -------------------------------------------------------------------------------------------------
output "name" {
  description = "The name of the VPC"
  value       = module.aws_vpc.name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.aws_vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.aws_vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.aws_vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.aws_vpc.private_subnets_cidr_blocks
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.aws_vpc.private_route_table_ids
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.aws_vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.aws_vpc.public_subnets_cidr_blocks
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.aws_vpc.public_route_table_ids
}

output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value       = module.aws_vpc.vgw_id
}

output "cgw_ids" {
  description = "List of IDs of Customer Gateway"
  value       = module.aws_vpc.cgw_ids
}

# -------------------------------------------------------------------------------------------------
# EC2
# -------------------------------------------------------------------------------------------------
output "bastion_asg_name" {
  description = "Autoscaling group name of the bastion host. (or empty string if bastion host is disabled)"
  value       = join(",", aws_autoscaling_group.bastion.*.name)
}

output "bastion_launch_template_name" {
  description = "Launch template name of the bastion host. (or empty string if bastion host is disabled)"
  value       = join(",", aws_launch_template.bastion.*.name)
}

# -------------------------------------------------------------------------------------------------
# Security Groups
# -------------------------------------------------------------------------------------------------
output "bastion_elb_security_group_id" {
  description = "The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. (or empty string if bastion host is disabled)"
  value       = join(",", module.aws_elb.security_group_ids)
}

output "bastion_security_group_id" {
  description = "The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. (or empty string if bastion host is disabled)"
  value       = join(",", aws_security_group.bastion.*.id)
}

# -------------------------------------------------------------------------------------------------
# DNS names
# -------------------------------------------------------------------------------------------------
output "bastion_elb_fqdn" {
  description = "The auto-generated FQDN of the bastion ELB."
  value       = module.aws_elb.fqdn
}

output "bastion_route53_public_dns_name" {
  description = "The route53 public dns name of the bastion ELB if set."
  value       = module.aws_elb.route53_public_dns_name
}
