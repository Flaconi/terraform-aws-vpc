# Terraform Module VPC

[![lint](https://github.com/flaconi/terraform-aws-vpc/workflows/lint/badge.svg)](https://github.com/flaconi/terraform-aws-vpc/actions?query=workflow%3Alint)
[![test](https://github.com/flaconi/terraform-aws-vpc/workflows/test/badge.svg)](https://github.com/flaconi/terraform-aws-vpc/actions?query=workflow%3Atest)
[![Tag](https://img.shields.io/github/tag/flaconi/terraform-aws-vpc.svg)](https://github.com/flaconi/terraform-aws-vpc/releases)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Terraform module that creates a customizable VPC (based on the official [VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws)) and optionally allows to provision a ELB protected bastion host with route53 controlled DNS name and unlimited number of SSH keys.

## Usage example

```hcl
module "vpc" {
  source  = "github.com/Flaconi/terraform-modules-vpc?ref=v2.1.0"

  vpc_cidr            = "12.0.0.0/16"
  vpc_subnet_azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_private_subnets = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
  vpc_public_subnets  = ["12.0.101.0/24", "12.0.102.0/24", "12.0.103.0/24"]

  vpc_enable_nat_gateway  = true
  vpc_enable_vpn_gateway  = false
  vpc_enable_bastion_host = true

  name = "my-project"

  bastion_ssh_keys                = ["ssh-ed25519 AAAAC3Nznte5aaCdi1a1Lzaai/tX6Mc2E+S6g3lrClL09iBZ5cW2OZdSIqomcMko 2 mysshkey"]
  bastion_route53_public_dns_name = "my-project.example.com"
  bastion_subdomain"              = "bastion-host"
}
```

## Examples

* [VPC with bastion](examples/vpc-with-bastion/)
* [VPC without bastion and only public subnets](examples/vpc-public-without-bastion/)

<!-- TFDOCS_HEADER_START -->


<!-- TFDOCS_HEADER_END -->

<!-- TFDOCS_PROVIDER_START -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

<!-- TFDOCS_PROVIDER_END -->

<!-- TFDOCS_REQUIREMENTS_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3 |

<!-- TFDOCS_REQUIREMENTS_END -->

<!-- TFDOCS_INPUTS_START -->
## Required Inputs

The following input variables are required:

### <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr)

Description: The VPC CIDR to use for this VPC.

Type: `string`

### <a name="input_vpc_subnet_azs"></a> [vpc\_subnet\_azs](#input\_vpc\_subnet\_azs)

Description: A list of AZ's to use to spawn subnets over

Type: `list(string)`

### <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets)

Description: A list of private subnet CIDR's

Type: `list(string)`

### <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets)

Description: A list of public subnet CIDR's

Type: `list(string)`

### <a name="input_name"></a> [name](#input\_name)

Description: The name(-prefix) to prepend/apply to all Name tags on all VPC resources

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway)

Description: A boolean that enables or disables NAT gateways for private subnets

Type: `bool`

Default: `true`

### <a name="input_vpc_reuse_nat_ips"></a> [vpc\_reuse\_nat\_ips](#input\_vpc\_reuse\_nat\_ips)

Description: Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external\_nat\_ip\_ids' variable

Type: `bool`

Default: `false`

### <a name="input_vpc_external_nat_ip_names"></a> [vpc\_external\_nat\_ip\_names](#input\_vpc\_external\_nat\_ip\_names)

Description: "List of names used to select the allocated EIP(s) that will be associated with the NAT GW(s). These EIPs can be managed outside of this module but they should be with Terraform and should be part of the same state as this module's resources. In case you have an uneven distribution of subnets in your AZs (i.e. you use 2 AZs but create 3 private subnets) and you want to use externally managed EIPs with one NAT GW per AZ, you have to provide as many EIPs as NAT GWs. Otherwise you will see this in the EIPs state message: Elastic IP address [eipalloc-xxx] is already associated."

Type: `list(string)`

Default: `[]`

### <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc\_enable\_dns\_hostnames)

Description: Should be true to enable DNS hostnames in the VPC

Type: `bool`

Default: `false`

### <a name="input_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#input\_vpc\_enable\_dns\_support)

Description: Should be true to enable DNS support in the VPC

Type: `bool`

Default: `true`

### <a name="input_vpc_enable_vpn_gateway"></a> [vpc\_enable\_vpn\_gateway](#input\_vpc\_enable\_vpn\_gateway)

Description: A boolean that enables or disables a VPN gateways for the VPC

Type: `bool`

Default: `false`

### <a name="input_vpc_enable_bastion_host"></a> [vpc\_enable\_bastion\_host](#input\_vpc\_enable\_bastion\_host)

Description: A boolean that enables or disables the deployment of a bastion host in the private subnet with an ELB in front of it

Type: `bool`

Default: `false`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of additional tags to apply to all VPC resources

Type: `map(string)`

Default: `{}`

### <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags)

Description: A map of additional tags to apply to the VPC

Type: `map(string)`

Default: `{}`

### <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags)

Description: A map of additional tags to apply to all public subnets

Type: `map(string)`

Default:

```json
{
  "Visibility": "public"
}
```

### <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags)

Description: A map of additional tags to apply to all private subnets

Type: `map(string)`

Default:

```json
{
  "Visibility": "private"
}
```

### <a name="input_bastion_name"></a> [bastion\_name](#input\_bastion\_name)

Description: If not empty will overwrite the bastion host name specified by 'name'

Type: `string`

Default: `""`

### <a name="input_bastion_ssh_keys"></a> [bastion\_ssh\_keys](#input\_bastion\_ssh\_keys)

Description: A list of public ssh keys to add to authorized\_keys file

Type: `list(string)`

Default: `[]`

### <a name="input_bastion_ssh_cidr_blocks"></a> [bastion\_ssh\_cidr\_blocks](#input\_bastion\_ssh\_cidr\_blocks)

Description: A list of CIDR's from which one can connect to the bastion host ELB

Type: `list(string)`

Default:

```json
[
  "0.0.0.0/0"
]
```

### <a name="input_bastion_security_group_names"></a> [bastion\_security\_group\_names](#input\_bastion\_security\_group\_names)

Description: List of one or more security groups to be added to the load balancer

Type: `list(string)`

Default: `[]`

### <a name="input_bastion_route53_public_dns_name"></a> [bastion\_route53\_public\_dns\_name](#input\_bastion\_route53\_public\_dns\_name)

Description: If set, the bastion ELB will be assigned this public DNS name via Route53.

Type: `string`

Default: `""`

### <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type)

Description: EC2 instance type of bastion host.

Type: `string`

Default: `"t2.micro"`

### <a name="input_bastion_cluster_size"></a> [bastion\_cluster\_size](#input\_bastion\_cluster\_size)

Description: The number of Bastion host server nodes to deploy.

Type: `number`

Default: `1`

<!-- TFDOCS_INPUTS_END -->

<!-- TFDOCS_OUTPUTS_START -->
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_asg_name"></a> [bastion\_asg\_name](#output\_bastion\_asg\_name) | Autoscaling group name of the bastion host. (or empty string if bastion host is disabled) |
| <a name="output_bastion_elb_fqdn"></a> [bastion\_elb\_fqdn](#output\_bastion\_elb\_fqdn) | The auto-generated FQDN of the bastion ELB. |
| <a name="output_bastion_elb_security_group_id"></a> [bastion\_elb\_security\_group\_id](#output\_bastion\_elb\_security\_group\_id) | The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. (or empty string if bastion host is disabled) |
| <a name="output_bastion_launch_config_name"></a> [bastion\_launch\_config\_name](#output\_bastion\_launch\_config\_name) | Launch configuration name of the bastion host. (or empty string if bastion host is disabled) |
| <a name="output_bastion_route53_public_dns_name"></a> [bastion\_route53\_public\_dns\_name](#output\_bastion\_route53\_public\_dns\_name) | The route53 public dns name of the bastion ELB if set. |
| <a name="output_bastion_security_group_id"></a> [bastion\_security\_group\_id](#output\_bastion\_security\_group\_id) | The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. (or empty string if bastion host is disabled) |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

<!-- TFDOCS_OUTPUTS_END -->

## License

[Apache 2.0](LICENSE)

Copyright (c) 2018-2021 [Flaconi GmbH](https://github.com/Flaconi)
