# Modify the default security group
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self        = lookup(ingress.value, "self", null)
      cidr_blocks = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      description = lookup(ingress.value, "description", null)
      from_port   = lookup(ingress.value, "from_port", 0)
      to_port     = lookup(ingress.value, "to_port", 0)
      protocol    = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self        = lookup(egress.value, "self", null)
      cidr_blocks = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      description = lookup(egress.value, "description", null)
      from_port   = lookup(egress.value, "from_port", 0)
      to_port     = lookup(egress.value, "to_port", 0)
      protocol    = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    {
      Name = format("%s-default-security-group", var.vpc_name)
    },
    var.additional_tags
  )
}
