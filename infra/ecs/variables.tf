variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "container_image" {
  description = "Docker image URL from Docker Hub"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for ECS service"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "role_attachment_id" {
  description = "Role policy attachment (for depends_on)"
  type        = string
}

variable "newrelic_license_key" {
  description = "New Relic ingest license key for FireLens logging"
  type        = string
}

variable "newrelic_secret_arn" {
  description = "ARN of the New Relic API key stored in Secrets Manager"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

