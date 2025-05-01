variable "aws_region" {
  default = "ap-south-1"
}

variable "environment" {
  default = "prod"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  default = "10.0.11.0/24"
}

variable "private_subnet_2_cidr" {
  default = "10.0.12.0/24"
}

variable "az1" {
  default = "ap-south-1a"
}

variable "az2" {
  default = "ap-south-1b"
}

variable "db_username" {
  description = "The database master username"
  type        = string
}

variable "db_password" {
  description = "The database master password"
  type        = string
  sensitive   = true
}

variable "ecr_backend_name" {
  description = "ECR repository name for backend"
  default     = "buddywise-backend"
}

variable "ecr_frontend_name" {
  description = "ECR repository name for frontend"
  default     = "buddywise-frontend"
}




