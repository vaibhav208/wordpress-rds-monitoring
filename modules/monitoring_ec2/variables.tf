variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where Monitoring EC2 will be placed"
  type        = string
}

variable "monitoring_sg_id" {
  description = "Security group ID for Monitoring EC2"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Monitoring"
  type        = string
  default     = "t3.micro"
}

variable "wordpress_private_ip" {
  description = "Private IP of WordPress EC2 (for Prometheus node_exporter target)"
  type        = string
}
