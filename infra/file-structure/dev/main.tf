terraform {
  backend "s3" {
    bucket         = "abraham-oriafo-tf-state"
    key            = "dev/terraform.tfstate"
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

module "web_app" {
  source = "../../web-app-module"

  # Input Variables
  # bucket_prefix    = "web-app-data-${local.environment_name}"
  # domain           = "devopsdeployed.com"
  environment_name = var.environment_name
  instance_type    = "t3.micro"
  # create_dns_zone  = false
  # db_name          = "${local.environment_name}mydb"
  # db_user          = "foo"
  # db_pass          = var.db_pass
}
