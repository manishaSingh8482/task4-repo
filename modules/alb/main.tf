resource "aws_lb" "this" {
  name               = "strapi-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg]
}

resource "aws_lb_target_group" "this" {
  name     = "strapi-tg"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/admin"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}



resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
