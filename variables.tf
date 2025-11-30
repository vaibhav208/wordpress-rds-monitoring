variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A short name used for tagging and resource naming"
  type        = string
  default     = "wordpress-rds-monitoring"
}

variable "environment" {
  description = "Environment name (e.g. dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "Initial database name for WordPress"
  type        = string
  default     = "wordpressdb"
}

variable "db_username" {
  description = "Master username for RDS MySQL"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS MySQL"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = "wordpress-rds-key"
}
