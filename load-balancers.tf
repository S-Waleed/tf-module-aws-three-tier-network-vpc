# Charges may occur

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

# ALB for the web servers
resource "aws_lb" "web_servers" {
  name               = format("%s-alb", var.vpc_name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = true

  tags = {
    Name = format("%s-alb", var.vpc_name)
  }
}

# NLB
