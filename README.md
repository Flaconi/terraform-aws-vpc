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

  bastion_ssh_keys                  = ["ssh-ed25519 AAAAC3Nznte5aaCdi1a1Lzaai/tX6Mc2E+S6g3lrClL09iBZ5cW2OZdSIqomcMko 2 mysshkey"]
  bastion_create_dns                = true
  bastion_route53_public_zone_name" = "my-project.example.com"
  bastion_subdomain"                = "bastion-host"
}
```

## Examples

* [VPC with bastion](examples/vpc-with-bastion/)

## Testing

Todo

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bastion_create_dns | A boolean to indicate whether or not we should assign a custom DNS record to the bastion hosts ELB. | string | `false` | no |
| bastion_route53_public_zone_name | The Route53 public zone DNS name to use for bastion host DNS. This only needs to be specified if bastion_create_dns is set to true. | string | `` | no |
| bastion_instance_type | EC2 instance type of bastion host. | string | `t2.micro` | no |
| bastion_ssh_cidr_blocks | A list of CIDR's from which one can connect to the bastion host ELB | list | `<list>` | no |
| bastion_ssh_keys | A list of public ssh keys to add to authorized_keys file | list | - | yes |
| bastion_subdomain | The subdomain name for the Bastion host. The domain part will be taken from bastion_route53_public_zone_name. This only needs to be specified if bastion_create_dns is set to true. | string | `bastion` | no |
| name | The name(-prefix) tag to apply to all VPC resources | string | - | yes |
| private_subnet_tags | A map of additional tags to apply to all private subnets | map | `<map>` | no |
| public_subnet_tags | A map of additional tags to apply to all public subnets | map | `<map>` | no |
| tags | A map of additional tags to apply to all VPC resources | map | `<map>` | no |
| vpc_cidr | The VPC CIDR to use for this VPC. | string | - | yes |
| vpc_enable_nat_gateway | A boolean that enables or disables NAT gateways for private subnets | string | - | yes |
| vpc_enable_vpn_gateway | A boolean that enables or disables a VPN gateways for the VPC | string | - | yes |
| vpc_private_subnets | A list of private subnet CIDR's | list | - | yes |
| vpc_public_subnets | A list of public subnet CIDR's | list | - | yes |
| vpc_subnet_azs | A list of AZ's to use to spawn subnets over | list | - | yes |
| vpc_tags | A map of additional tags to apply to the VPC | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| vpc_id | The ID of the VPC |

## License

Todo

