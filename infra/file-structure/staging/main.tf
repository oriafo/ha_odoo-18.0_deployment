terraform {
  backend "s3" {
    bucket         = "abraham-oriafo-tf-state-staging"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "abraham-terraform_lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# variable "db_pass" {
#   description = "password for database"
#   type        = string
#   sensitive   = true
# }

variable "environment_name" {
  type        = string
}

variable "run_number" {
  description = "GitHub run number"
  type        = string
}

variable "secret_aws_access_key" {
  description = "SAK"
  type        = string
}

variable "access_key_id" {
  description = "AK"
  type        = string
}

# variable "REGISTRY" {
#   description = "ECR registry"
#   type        = string
# }

# variable "REPOSITORY" {
#   description = "ECR repository"
#   type        = string
# }

module "web_app" {
  source = "../../web-app-module"

  # Input Variables
  # bucket_prefix    = "web-app-data-${local.environment_name}"
  # domain           = "devopsdeployed.com"
  environment_name = var.environment_name
  instance_type    = "t3.micro"
   access_key_id    = var.access_key_id
  secret_aws_access_key = var.secret_aws_access_key
  run_number  = var.run_number

  # REGISTRY  = var.REGISTRY
  # REPOSITORY = var.REPOSITORY

  #create_dns_zone  = false
  # db_name          = "${local.environment_name}mydb"
  # db_user          = "foo"
  # db_pass          = var.db_pass
}
