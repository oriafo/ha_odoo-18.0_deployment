variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  # default     = "dev"
}


variable "secret_aws_access_key" {
  description = "SAK"
  type        = string
}

variable "access_key_id" {
  description = "AK"
  type        = string
}