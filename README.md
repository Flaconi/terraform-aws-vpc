# Terraform Module VPC

[![Tag](https://img.shields.io/github/tag/Flaconi/terraform-aws-vpc.svg)](https://github.com/Flaconi/terraform-aws-vpc/releases)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Terraform module that creates a customizable VPC and a privately deployed bastion host in an ASG
behind an ELB with optionally a CNAME for it.

## Usage example

```hcl
module "vpc" {
  source  = "github.com/Flaconi/terraform-modules-vpc?ref=v0.1.0"

  vpc_cidr            = "12.0.0.0/16"
  vpc_subnet_azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_private_subnets = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
  vpc_public_subnets  = ["12.0.101.0/24", "12.0.102.0/24", "12.0.103.0/24"]

  vpc_enable_nat_gateway = true
  vpc_enable_vpn_gateway = false

  name = "my-project"

  bastion_ssh_keys                = ["ssh-ed25519 AAAAC3Nznte5aaCdi1a1Lzaai/tX6Mc2E+S6g3lrClL09iBZ5cW2OZdSIqomcMko 2 mysshkey"]
  bastion_route53_public_dns_name = "my-project.example.com"
  bastion_subdomain"              = "bastion-host"
}
```

## Examples

* [VPC with bastion](examples/vpc-with-bastion/)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_cidr | The VPC CIDR to use for this VPC. | string | - | yes |
| vpc_subnet_azs | A list of AZ's to use to spawn subnets over | list | - | yes |
| vpc_private_subnets | A list of private subnet CIDR's | list | - | yes |
| vpc_public_subnets | A list of public subnet CIDR's | list | - | yes |
| name | The name(-prefix) to prepend/apply to all Name tags on all VPC resources | string | - | yes |
| vpc_enable_nat_gateway | A boolean that enables or disables NAT gateways for private subnets | string | `true` | no |
| vpc_enable_vpn_gateway | A boolean that enables or disables a VPN gateways for the VPC | string | `false` | no |
| tags | A map of additional tags to apply to all VPC resources | map | `<map>` | no |
| vpc_tags | A map of additional tags to apply to the VPC | map | `<map>` | no |
| public_subnet_tags | A map of additional tags to apply to all public subnets | map | `<map>` | no |
| private_subnet_tags | A map of additional tags to apply to all private subnets | map | `<map>` | no |
| bastion_name | If not empty will overwrite the bastion host name specified by 'name' | string | `` | no |
| bastion_ssh_keys | A list of public ssh keys to add to authorized_keys file | list | - | yes |
| bastion_ssh_cidr_blocks | A list of CIDR's from which one can connect to the bastion host ELB | list | `<list>` | no |
| bastion_route53_public_dns_name | If set, the bastion ELB will be assigned this public DNS name via Route53. | string | `` | no |
| bastion_instance_type | EC2 instance type of bastion host. | string | `t2.micro` | no |
| bastion_cluster_size | The number of Bastion host server nodes to deploy. | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| bastion_asg_name | Autoscaling group name of the bastion host |
| bastion_launch_config_name | Launch configuration name of the bastion host |
| bastion_elb_security_group_id | The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. |
| bastion_security_group_id | The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. |
| bastion_elb_fqdn | The auto-generated FQDN of the bastion ELB. |
| bastion_route53_public_dns_name | The route53 public dns name of the bastion ELB if set. |

## License

[Apache 2.0](LICENSE)

Copyright (c) 2018 [Flaconi GmbH](https://github.com/Flaconi)
