# -------------------------------------------------------------------------------------------------
# AWS Settings
# -------------------------------------------------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

# -------------------------------------------------------------------------------------------------
locals {
  names_of_eips_for_natgws = [
    "test-subnet-1a",
    "test-subnet-1b",
    "test-subnet-1c",
  ]
  ids_of_eips_for_natgws = [for eip in aws_eip.nat_gateway : eip.id]
}

# VPC
module "aws_vpc" {
  source = "../.."

  vpc_cidr            = "10.10.0.0/16"
  vpc_subnet_azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  vpc_public_subnets  = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

  vpc_enable_nat_gateway  = true
  vpc_enable_vpn_gateway  = false
  vpc_enable_bastion_host = true

  vpc_reuse_nat_ips         = true
  vpc_external_nat_ip_names = local.ids_of_eips_for_natgws

  name = "ci-vpc"

  # AWS resource tags to add to all created resources
  tags = {
    Environment = "ci"
    Owner       = "terraform"
    Project     = "terraform-module-vpc"
  }

  # A list of public SSH keys to add to authorized_keys inside the bastion host
  bastion_ssh_keys = ["ssh-ed25519 AAAAC3Nznte5aaCdi1a1Lzaai/tX6Mc2E+S6g3lrClL09iBZ5cW2OZdSIqomcMko my-public-sshkey"]
}
