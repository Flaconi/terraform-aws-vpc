# -------------------------------------------------------------------------------------------------
# VPC (required)
# -------------------------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "The VPC CIDR to use for this VPC."
  type        = string
}

variable "vpc_subnet_azs" {
  description = "A list of AZ's to use to spawn subnets over"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "A list of private subnet CIDR's"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "A list of public subnet CIDR's"
  type        = list(string)
}

variable "name" {
  description = "The name(-prefix) to prepend/apply to all Name tags on all VPC resources"
  type        = string
}

# -------------------------------------------------------------------------------------------------
# VPC (optional)
# -------------------------------------------------------------------------------------------------
variable "vpc_enable_nat_gateway" {
  description = "A boolean that enables or disables NAT gateways for private subnets"
  type        = bool
  default     = true
}

variable "vpc_reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "vpc_external_nat_ip_names" {
  description = <<EOF
"List of names used to select the allocated EIP(s) that will be associated with the NAT GW(s). These EIPs can be managed outside of this module but they should be with Terraform and should be part of the same state as this module's resources. In case you have an uneven distribution of subnets in your AZs (i.e. you use 2 AZs but create 3 private subnets) and you want to use externally managed EIPs with one NAT GW per AZ, you have to provide as many EIPs as NAT GWs. Otherwise you will see this in the EIPs state message: Elastic IP address [eipalloc-xxx] is already associated."
EOF
  type        = list(string)
  default     = []
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_vpn_gateway" {
  description = "A boolean that enables or disables a VPN gateways for the VPC"
  type        = bool
  default     = false
}

variable "vpc_customer_gateways" {
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  type        = map(map(any))
  default     = {}
}

variable "vpc_enable_bastion_host" {
  description = "A boolean that enables or disables the deployment of a bastion host in the private subnet with an ELB in front of it"
  type        = bool
  default     = false
}

# -------------------------------------------------------------------------------------------------
# Resource Tagging (optional)
# -------------------------------------------------------------------------------------------------
variable "tags" {
  description = "A map of additional tags to apply to all VPC resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "A map of additional tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "A map of additional tags to apply to all public subnets"
  type        = map(string)

  default = {
    Visibility = "public"
  }
}

variable "private_subnet_tags" {
  description = "A map of additional tags to apply to all private subnets"
  type        = map(string)

  default = {
    Visibility = "private"
  }
}

# -------------------------------------------------------------------------------------------------
# Bastion Host (optional)
# -------------------------------------------------------------------------------------------------
variable "bastion_name" {
  description = "If not empty will overwrite the bastion host name specified by 'name'"
  type        = string
  default     = ""
}

variable "bastion_ssh_keys" {
  description = "A list of public ssh keys to add to authorized_keys file"
  type        = list(string)
  default     = []
}

variable "bastion_ssh_cidr_blocks" {
  description = "A list of CIDR's from which one can connect to the bastion host ELB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_security_group_names" {
  description = "List of one or more security groups to be added to the load balancer"
  type        = list(string)
  default     = []
}

variable "bastion_route53_public_dns_name" {
  description = "If set, the bastion ELB will be assigned this public DNS name via Route53."
  type        = string
  default     = ""
}

variable "bastion_instance_type" {
  description = "EC2 instance type of bastion host."
  type        = string
  default     = "t2.micro"
}

variable "bastion_cluster_size" {
  description = "The number of Bastion host server nodes to deploy."
  type        = number
  default     = 1
}
