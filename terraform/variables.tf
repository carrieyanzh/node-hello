variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "image_name" {
  description = "Container image (e.g. ghcr.io/<OWNER>/<REPO>:<TAG>)"
  type        = string
}

variable "cpu" {
  description = "Fargate CPU units"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Fargate memory (MB)"
  type        = string
  default     = "512"
}
