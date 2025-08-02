variable "app_name" {
  description = "Name of the app used for resource naming"
  type        = string
}

variable "container_port" {
  description = "Port that the app container listens on"
  type        = number
}
