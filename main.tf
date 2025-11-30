terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  environment  = var.environment
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
}

module "rds_mysql" {
  source = "./modules/rds_mysql"

  project_name          = var.project_name
  environment           = var.environment
  private_db_subnet_ids = module.network.private_db_subnet_ids
  rds_sg_id             = module.security.rds_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "wordpress_ec2" {
  source = "./modules/wordpress_ec2"

  project_name     = var.project_name
  environment      = var.environment
  public_subnet_id = module.network.public_subnet_ids[0]
  wordpress_sg_id  = module.security.wordpress_sg_id
  key_name         = var.key_name

  rds_endpoint = module.rds_mysql.rds_endpoint
  db_name      = var.db_name
  db_username  = var.db_username
  db_password  = var.db_password
}

module "monitoring_ec2" {
  source = "./modules/monitoring_ec2"

  project_name         = var.project_name
  environment          = var.environment
  public_subnet_id     = module.network.public_subnet_ids[1]
  monitoring_sg_id     = module.security.monitoring_sg_id
  key_name             = var.key_name
  wordpress_private_ip = module.wordpress_ec2.private_ip
}
