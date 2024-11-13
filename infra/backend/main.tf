terraform {
  #   backend "s3" {
  #   bucket         = "abraham-oriafo-tf-state"
  #   key            = "backend.tfstate"
  #   region         = "us-east-1"         
  #   dynamodb_table = "abraham-terraform_lock"
  #   encrypt        = true                  
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1" # Change to your desired region
  profile = "dikodin_profile"
}

# Create an S3 bucket
resource "aws_s3_bucket" "state_bucket" {
  bucket = "abraham-oriafo-tf-state" # Ensure this is globally unique
  force_destroy = true
}

# Configure versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled" # Enable versioning
  }
}

# Configure server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # You can also use "aws:kms" for KMS encryption
    }
  }
}

output "bucket_name" {
  value       = aws_s3_bucket.state_bucket.bucket
  description = "The name of the S3 bucket"
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "ab-terraform_lock" {
  name         = "abraham-terraform_lock"  # Name of the table
  billing_mode = "PAY_PER_REQUEST"   # On-demand pricing

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"
}



