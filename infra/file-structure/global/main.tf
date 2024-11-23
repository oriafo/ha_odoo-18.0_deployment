# terraform {
#   backend "s3" {
#     bucket         = "abraham-oriafo-tf-state"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "abraham-terraform_lock"
#     encrypt        = true
#   }

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# # Route53 zone is shared across staging and production
# # resource "aws_route53_zone" "primary" {
# #   name = "devopsdeployed.com"
# # }
