# terraform-module-template
Template for Terraform modules

<!-- Uncomment and replace with your module name
[![lint](https://github.com/flaconi/<MODULENAME>/workflows/lint/badge.svg)](https://github.com/flaconi/<MODULENAME>/actions?query=workflow%3Alint)
[![test](https://github.com/flaconi/<MODULENAME>/workflows/test/badge.svg)](https://github.com/flaconi/<MODULENAME>/actions?query=workflow%3Atest)
[![Tag](https://img.shields.io/github/tag/flaconi/<MODULENAME>.svg)](https://github.com/flaconi/<MODULENAME>/releases)
-->
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

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
