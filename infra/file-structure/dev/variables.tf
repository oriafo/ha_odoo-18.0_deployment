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
