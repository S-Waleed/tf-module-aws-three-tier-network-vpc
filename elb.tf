# ALB for the web servers
resource "aws_lb" "web_servers" {
  name               = format("%s-alb", var.vpc_name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = aws_subnet.public.*.id
  enable_http2       = false

  # enable_deletion_protection = true

  tags = {
    Name = format("%s-alb", var.vpc_name)
  }
}

# Target group for the web servers
resource "aws_lb_target_group" "web_servers" {
  name     = "sharepoint-web-servers-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

# todo: Improve by adding certs
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_servers.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}
