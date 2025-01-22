terraform {
  backend "s3" {
    bucket         = "abraham-oriafo-tf-state"
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

module "web_app" {
  source = "../../web-app-module"

  # Input Variables
  # bucket_prefix    = "web-app-data-${local.environment_name}"
  # domain           = "devopsdeployed.com"
  environment_name =  module.web_app.environment_name
  instance_type    =  module.web_app.instance_type
  #create_dns_zone  = false
  # db_name          = "${local.environment_name}mydb"
  # db_user          = "foo"
  # db_pass          = var.db_pass
}
