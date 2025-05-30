resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "hello-world-high-cpu"
  alarm_description   = "Alarm if CPU > 80% for 5 minutes"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    ClusterName = aws_ecs_cluster.app.name
    ServiceName = aws_ecs_service.app.name
  }
}
