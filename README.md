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
  bastion_subdomain               = "bastion-host"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3 |

<!-- TFDOCS_PROVIDER_END -->

<!-- TFDOCS_REQUIREMENTS_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3 |

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

### <a name="input_vpc_one_nat_gateway_per_az"></a> [vpc\_one\_nat\_gateway\_per\_az](#input\_vpc\_one\_nat\_gateway\_per\_az)

Description: Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`

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

### <a name="input_vpc_customer_gateways"></a> [vpc\_customer\_gateways](#input\_vpc\_customer\_gateways)

Description: Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)

Type: `map(map(any))`

Default: `{}`

### <a name="input_vpc_enable_bastion_host"></a> [vpc\_enable\_bastion\_host](#input\_vpc\_enable\_bastion\_host)

Description: A boolean that enables or disables the deployment of a bastion host in the private subnet with an ELB in front of it

Type: `bool`

Default: `false`

### <a name="input_vpc_secondary_cidr_blocks"></a> [vpc\_secondary\_cidr\_blocks](#input\_vpc\_secondary\_cidr\_blocks)

Description: List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool

Type: `list(string)`

Default: `[]`

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

### <a name="input_bastion_ssh_user"></a> [bastion\_ssh\_user](#input\_bastion\_ssh\_user)

Description: User name used for SSH-connections.

Type: `string`

Default: `"ec2-user"`

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

### <a name="input_bastion_ami"></a> [bastion\_ami](#input\_bastion\_ami)

Description: EC2 AMI ID for bastion host.

Type: `string`

Default: `null`

### <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type)

Description: EC2 instance type of bastion host.

Type: `string`

Default: `"t2.micro"`

### <a name="input_bastion_cluster_size"></a> [bastion\_cluster\_size](#input\_bastion\_cluster\_size)

Description: The number of Bastion host server nodes to deploy.

Type: `number`

Default: `1`

### <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group)

Description: Should be true to adopt and manage default security group

Type: `bool`

Default: `true`

### <a name="input_default_security_group_name"></a> [default\_security\_group\_name](#input\_default\_security\_group\_name)

Description: Name to be used on the default security group

Type: `string`

Default: `null`

### <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress)

Description: List of maps of ingress rules to set on the default security group

Type: `list(map(string))`

Default:

```json
[
  {
    "from_port": 0,
    "protocol": -1,
    "self": true,
    "to_port": 0
  }
]
```

### <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress)

Description: List of maps of egress rules to set on the default security group

Type: `list(map(string))`

Default:

```json
[
  {
    "from_port": 0,
    "protocol": "-1",
    "self": true,
    "to_port": 0
  }
]
```

<!-- TFDOCS_INPUTS_END -->

<!-- TFDOCS_OUTPUTS_START -->
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_asg_name"></a> [bastion\_asg\_name](#output\_bastion\_asg\_name) | Autoscaling group name of the bastion host. (or empty string if bastion host is disabled) |
| <a name="output_bastion_elb_fqdn"></a> [bastion\_elb\_fqdn](#output\_bastion\_elb\_fqdn) | The auto-generated FQDN of the bastion ELB. |
| <a name="output_bastion_elb_security_group_id"></a> [bastion\_elb\_security\_group\_id](#output\_bastion\_elb\_security\_group\_id) | The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. (or empty string if bastion host is disabled) |
| <a name="output_bastion_launch_template_name"></a> [bastion\_launch\_template\_name](#output\_bastion\_launch\_template\_name) | Launch template name of the bastion host. (or empty string if bastion host is disabled) |
| <a name="output_bastion_route53_public_dns_name"></a> [bastion\_route53\_public\_dns\_name](#output\_bastion\_route53\_public\_dns\_name) | The route53 public dns name of the bastion ELB if set. |
| <a name="output_bastion_security_group_id"></a> [bastion\_security\_group\_id](#output\_bastion\_security\_group\_id) | The ID of the SSH security group of the bastion host that can be attached to any other private instance in order to ssh into it. (or empty string if bastion host is disabled) |
| <a name="output_cgw_ids"></a> [cgw\_ids](#output\_cgw\_ids) | List of IDs of Customer Gateway |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPC |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_vgw_id"></a> [vgw\_id](#output\_vgw\_id) | The ID of the VPN Gateway |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

<!-- TFDOCS_OUTPUTS_END -->

## License

[Apache 2.0](LICENSE)

Copyright (c) 2018-2021 [Flaconi GmbH](https://github.com/Flaconi)
