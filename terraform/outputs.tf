output "cluster_arn" {
  description = "ECS Cluster ARN"
  value       = aws_ecs_cluster.app.arn
}

output "service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.app.name
}

output "log_group" {
  description = "CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.app.name
}
