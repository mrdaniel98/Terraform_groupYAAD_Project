# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }

  min_size         = 1
  max_size         = 4
  desired_capacity = 2
  vpc_zone_identifier = [
    aws_subnet.public_subnets["0"].id,
    aws_subnet.public_subnets["2"].id
  ]

  target_group_arns = [aws_lb_target_group.web_target_group.arn]

  # Use "tag" blocks instead of the deprecated "tags" argument
  tag {
    key                 = "Name"
    value               = "WebASGInstance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "FinalProject"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in-policy"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name                = "HighCPUUtilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 70
  alarm_actions             = [aws_autoscaling_policy.scale_out_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_utilization" {
  alarm_name                = "LowCPUUtilization"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 20
  alarm_actions             = [aws_autoscaling_policy.scale_in_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
