# -------------------------------------------------------------------------------------------------
# Locals
# -------------------------------------------------------------------------------------------------

# The following example converts key/val maps into AWS ASG 3er tuple maps.
# Credits: https://github.com/terraform-aws-modules/terraform-aws-autoscaling/blob/master/locals.tf
locals {
  tags_asg_format = null_resource.tags_as_list_of_maps.*.triggers

  ids_of_eips_for_natgws = [for eip in data.aws_eip.nat_gateway : eip.id]
}

resource "null_resource" "tags_as_list_of_maps" {
  count = length(keys(var.tags))

  triggers = {
    "key"                 = element(keys(var.tags), count.index)
    "value"               = element(values(var.tags), count.index)
    "propagate_at_launch" = true
  }
}

locals {
  bastion_asg_name = var.bastion_name == "" ? "${var.name}-bastion" : var.bastion_name
  bastion_elb_name = var.bastion_name == "" ? "${var.name}-bastion" : var.bastion_name
  bastion_lc_name  = var.bastion_name == "" ? "${var.name}-bastion" : var.bastion_name
  bastion_sg_name  = var.bastion_name == "" ? "${var.name}-bastion" : var.bastion_name
}
