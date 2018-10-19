# -------------------------------------------------------------------------------------------------
# VPC (required)
# -------------------------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "The VPC CIDR to use for this VPC."
}

variable "vpc_subnet_azs" {
  description = "A list of AZ's to use to spawn subnets over"
  type        = "list"
}

variable "vpc_private_subnets" {
  description = "A list of private subnet CIDR's"
  type        = "list"
}

variable "vpc_public_subnets" {
  description = "A list of public subnet CIDR's"
  type        = "list"
}

variable "vpc_enable_nat_gateway" {
  description = "A boolean that enables or disables NAT gateways for private subnets"
}

variable "vpc_enable_vpn_gateway" {
  description = "A boolean that enables or disables a VPN gateways for the VPC"
}

variable "name" {
  description = "The name(-prefix) tag to apply to all VPC resources"
}

# -------------------------------------------------------------------------------------------------
# Resource Tagging (optional)
# -------------------------------------------------------------------------------------------------
variable "tags" {
  description = "A map of additional tags to apply to all VPC resources"
  type        = "map"
  default     = {}
}

variable "vpc_tags" {
  description = "A map of additional tags to apply to the VPC"
  type        = "map"
  default     = {}
}

variable "public_subnet_tags" {
  description = "A map of additional tags to apply to all public subnets"
  type        = "map"

  default = {
    Visibility = "public"
  }
}

variable "private_subnet_tags" {
  description = "A map of additional tags to apply to all private subnets"
  type        = "map"

  default = {
    Visibility = "private"
  }
}

# -------------------------------------------------------------------------------------------------
# Bastion Host (required)
# -------------------------------------------------------------------------------------------------
variable "bastion_ssh_keys" {
  description = "A list of public ssh keys to add to authorized_keys file"
  type        = "list"
}

# -------------------------------------------------------------------------------------------------
# Bastion Host (optional)
# -------------------------------------------------------------------------------------------------
variable "bastion_ssh_cidr_blocks" {
  description = "A list of CIDR's from which one can connect to the bastion host ELB"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "bastion_create_dns" {
  description = "A boolean to indicate whether or not we should assign a custom DNS record to the bastion hosts ELB."
  default     = false
}

variable "bastion_host_route53_public_zone_name" {
  description = "The Route53 public zone DNS name to use for bastion host DNS. This only needs to be specified if bastion_create_dns is set to true."
  default     = ""
}

variable "bastion_instance_type" {
  description = "EC2 instance type of bastion host."
  default     = "t2.micro"
}
