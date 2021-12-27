resource "aws_eip" "nat_gateway" {
  for_each = toset(local.names_of_eips_for_natgws)
  tags = {
    Name = each.key
  }
}
