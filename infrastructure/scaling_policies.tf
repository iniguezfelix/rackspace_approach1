#Autoscaling Policy Increase in One instance
resource "aws_autoscaling_policy" "webserver_policy_increase" {
  name = "webserver_policy_increase"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 240
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}

#Cloudwatch alert to trigger autoscaling policy webserver_policy_increase when CPU utilization of ASG is greater that 50%
resource "aws_cloudwatch_metric_alarm" "webservers_cpu_alarm_high" {
  alarm_name = "webservers_cpu_alarm_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
  }

  alarm_description = "This metric monitor Web Servers CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.webserver_policy_increase.arn ]
}

#Autoscaling Policy Decrease in One instance
resource "aws_autoscaling_policy" "webserver_policy_decrease" {
  name = "webserver_policy_decrease"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 240
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}

#Cloudwatch alert to trigger autoscaling policy webserver_policy_increase when CPU utilization of ASG is less that 10%
resource "aws_cloudwatch_metric_alarm" "webserver_cpu_alarm_low" {
  alarm_name = "webserver_cpu_alarm_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
  }

  alarm_description = "This metric monitor Web Servers CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.webserver_policy_decrease.arn ]
}