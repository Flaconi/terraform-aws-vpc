# -------------------------------------------------------------------------------------------------
# Locals
# -------------------------------------------------------------------------------------------------

# The following example converts key/val maps into AWS ASG 3er tuple maps.
# Credits: https://github.com/terraform-aws-modules/terraform-aws-autoscaling/blob/master/locals.tf
locals {
  tags_asg_format = ["${null_resource.tags_as_list_of_maps.*.triggers}"]
}

resource "null_resource" "tags_as_list_of_maps" {
  count = "${length(keys(var.tags))}"

  triggers = "${map(
    "key", "${element(keys(var.tags), count.index)}",
    "value", "${element(values(var.tags), count.index)}",
    "propagate_at_launch", "true"
  )}"
}

locals {
  bastion_asg_name = "${var.name}-bastion-asg"
  bastion_elb_name = "${var.name}-bastion-elb"
  bastion_lc_name  = "${var.name}-bastion-lc"
}
