variable "region" {
  default = "eu-north-1"
}

variable "app_name" {
  default = "hello-node-app"
}

variable "container_image" {
  description = "Docker image from Docker Hub"
}

variable "container_port" {
  default = 3000
}

variable "newrelic_license_key" {
  description = "New Relic license key for FireLens logging"
  type        = string
}