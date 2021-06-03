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

resource "aws_security_group" "web" {
  name        = format("%s-alb-web-security-group", var.vpc_name)
  description = "The ALB web security group."
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow all secure web traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all non-secure web traffic temporarily"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from local network."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-alb-web-security-group", var.vpc_name)
  }
}
