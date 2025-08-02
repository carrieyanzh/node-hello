output "execution_role_arn" {
  description = "IAM Role ARN for ECS task execution"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "role_attachment_id" {
  description = "Attachment ID (used for depends_on)"
  value       = aws_iam_role_policy_attachment.ecs_task_exec_attach.id
}