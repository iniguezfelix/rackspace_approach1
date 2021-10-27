#Auto Scaling Group Properties for Web Servers
resource "aws_autoscaling_group" "webserver_asg" {
  name = "webserver_asg"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 3
  force_delete = true
  depends_on = [aws_alb.web_alb]
  target_group_arns = [aws_lb_target_group.tg_alb.arn]
  health_check_type = "EC2"

  launch_configuration = aws_launch_configuration.web_servers.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    aws_subnet.private_us_east_1a.id,
    aws_subnet.private_us_east_1b.id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web_asg"
    propagate_at_launch = true
  }

}