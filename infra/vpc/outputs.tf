output "subnet_ids" {
  description = "List of default subnet IDs"
  value       = data.aws_subnets.default.ids
}

output "security_group_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs_sg.id
}
