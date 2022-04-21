# -------------------------------------------------------------------------------------------------
# AWS Settings
# -------------------------------------------------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

# -------------------------------------------------------------------------------------------------
# VPC
# -------------------------------------------------------------------------------------------------
module "aws_vpc" {
  source = "../.."

  vpc_cidr            = "10.10.0.0/16"
  vpc_subnet_azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_private_subnets = []
  vpc_public_subnets  = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

  vpc_enable_nat_gateway  = false
  vpc_enable_vpn_gateway  = false
  vpc_enable_bastion_host = false

  name = "ci-vpc"

  # AWS resource tags to add to all created resources
  tags = {
    Environment = "ci"
    Owner       = "terraform"
    Project     = "terraform-module-vpc"
  }
}
