terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "node-hello-terraform-state-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "node-hello-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
}