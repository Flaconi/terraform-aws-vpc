# VPC with bastion

Configuration in this directory creates one VPC with three private and three public subnet, three
NAT gateways (one in each public subnet) and an autoscaled bastion host behind an ELB.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run terraform destroy when you don't need these resources.
