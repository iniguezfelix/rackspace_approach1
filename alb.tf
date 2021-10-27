#Application Loadbalancer
resource "aws_alb" "web_alb" {
  name = "ALB"
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb_http.id
  ]
  subnets = [
    aws_subnet.public_us_east_1a.id,
    aws_subnet.public_us_east_1b.id
  ]

  tags = {
    "Name" = "Aplication Load Balancer"
  }

}
#Target group for ALB
resource "aws_lb_target_group" "tg_alb" {
  name     = "TargetGroupalb"
  depends_on = [aws_vpc.vpc_approach1]
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_approach1.id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60 
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}
#ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb.arn
  }
}