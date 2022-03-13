resource "aws_cloudwatch_metric_alarm" "iac-cloudwatch-ec2-cpu-usage" {
  alarm_name                = "iac-cloudwatch-ec2-cpu-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" // seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors iac-ec2 cpu usage"
  insufficient_data_actions = []

  alarm_actions             = [aws_sns_topic.iac-sns-topic.arn]
  ok_actions                = [aws_sns_topic.iac-sns-topic.arn]

  dimensions = {
    InstanceId              = aws_instance.iac-ec2.id
  }
}
