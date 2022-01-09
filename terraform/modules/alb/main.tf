resource "aws_lb" "alb" {
  name               = "${var.Application}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = [for subnet in var.subnets : subnet]

  enable_deletion_protection = true

  tags = {
    Name = "${var.Application}-alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.Application}-alb-tg"
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}