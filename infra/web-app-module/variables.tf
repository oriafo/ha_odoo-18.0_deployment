# General Variables

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}

variable "key_pair" {
  description = "instance Key"
  type        = string
  default     = "tooplate-key"
}


variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "worker-node"
}

variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  # default     = "dev"
}

# variable "secret_aws_access_key" {
#   description = "SAK"
#   type        = string
# }

# variable "access_key_id" {
#   description = "AK"
#   type        = string
# }

# variable "run_number" {
#   description = "GitHub run number"
#   type        = string
# }

# variable "REGISTRY" {
#   description = "ECR registry"
#   type        = string
# }

# variable "REPOSITORY" {
#   description = "ECR repository"
#   type        = string
# }

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-0866a3c8686eaeeba" # Ubuntu 20.04 LTS // us-east-1
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "my_cluster" {
  description = "cluster name"
  type        = string
}

# S3 Variables

# variable "bucket_prefix" {
#   description = "prefix of s3 bucket for app data"
#   type        = string
# }

# Route 53 Variables

# variable "create_dns_zone" {
#   description = "If true, create new route53 zone, if false read existing route53 zone"
#   type        = bool
#   default     = false
# }

# variable "domain" {
#   description = "Domain for website"
#   type        = string
# }

# RDS Variables

# variable "db_name" {
#   description = "Name of DB"
#   type        = string
# }

# variable "db_user" {
#   description = "Username for DB"
#   type        = string
# }

# variable "db_pass" {
#   description = "Password for DB"
#   type        = string
#   sensitive   = true
# }


