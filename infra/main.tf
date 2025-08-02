provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "./vpc"
  app_name        = var.app_name
  container_port  = var.container_port
}

module "iam" {
  source   = "./iam"
  app_name = var.app_name
}

# ECS module: Includes Cluster, Task Definition, Service
module "ecs" {
  source             = "./ecs"
  app_name           = var.app_name
  container_image    = var.container_image
  container_port     = var.container_port
  subnet_ids         = module.vpc.subnet_ids
  security_group_id  = module.vpc.security_group_id
  execution_role_arn = module.iam.execution_role_arn
  role_attachment_id = module.iam.role_attachment_id
  region               = var.region
  newrelic_license_key = var.newrelic_license_key
  newrelic_secret_arn  = "arn:aws:secretsmanager:eu-north-1:730335547532:secret:newrelic-logging-api-key-Nsv1th"
}
