data "aws_eip" "nat_gateway" {
  for_each = toset(var.vpc_external_nat_ip_names)
  tags = {
    Name = each.key
  }
}
