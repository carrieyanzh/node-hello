variable "repository_owner" {
     description = "GitHub repository owner name"
     type        = string
}

variable "new_relic_license_key" {
  type      = string
  sensitive = true
}

variable "image_tag" {
  type    = string
  default = "latest"
}

locals {
  image = "ghcr.io/${var.repository_owner}/node-hello:latest"
}

resource "docker_image" "app_image" {
  name = local.image
  keep_locally = false
  pull_triggers = [var.image_tag]
}

resource "docker_container" "app" {
  name  = "node-hello"
  image = docker_image.app_image.image_id
  ports {
    internal = 3000
    external = 3000
  }
  env = [
    "NODE_ENV=production",
    "NEW_RELIC_LICENSE_KEY=${var.new_relic_license_key}"
  ]

  log_driver = "json-file"
  log_opts = {
    tag = "{{.Name}}"
  }
}

output "container_id" {
  description = "The ID of the deployed Docker container"
  value       = docker_container.app.id
}

output "container_name" {
  description = "The name of the deployed Docker container"
  value       = docker_container.app.name
}

output "container_ports" {
  description = "Ports exposed by the container"
  value       = docker_container.app.ports
}
