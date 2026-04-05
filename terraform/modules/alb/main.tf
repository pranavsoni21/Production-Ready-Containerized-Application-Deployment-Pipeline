# Create target groups
resource "aws_lb_target_group" "app-tg" {
  name        = "app-tg"
  port        = var.alb_port
  protocol    = "HTTP"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  health_check {
    path = "/health"
  }

}

# Create Application load balancer
resource "aws_lb" "app-alb" {
  name               = "app-alb"
  load_balancer_type = var.load_balancer_type
  internal           = false
  security_groups    = var.security_group
  subnets            = var.public_subnets
  tags = {
    Environment = "Production"
  }
}

# Create application load balancer listener
resource "aws_alb_listener" "app-lsn" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = var.alb_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}