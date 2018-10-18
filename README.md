# Terraform Module VPC

A Terraform module that creates a customizable VPC and a privately deployed bastion host in an ASG
behind an ELB with optionally a CNAME for it.

## Usage example

```hcl
module "vpc" {
  source  = "github.com/Flaconi/terraform-modules-vpc?ref=v0.0.1"

  vpc_cidr            = "12.0.0.0/16"
  vpc_subnet_azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_private_subnets = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
  vpc_public_subnets  = ["12.0.101.0/24", "12.0.102.0/24", "12.0.103.0/24"]

  vpc_enable_nat_gateway = true
  vpc_enable_vpn_gateway = false

  name = "my-project"

  bastion_host_ssh_keys = ["ssh-ed25519 AAAAC3Nznte5aaCdi1a1Lzaai/tX6Mc2E+S6g3lrClL09iBZ5cW2OZdSIqomcMko 2 mysshkey"]
  bastion_host_create_dns = true
  bastion_host_route53_public_zone_name" = "my-project.example.com"
}
```

## Testing

Todo

## Inputs

Todo

## Outputs

Todo

## License

Todo

