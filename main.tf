provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "rds" {
  source          = "./modules/rds_mysql"
  private_subnets = module.network.private_subnets
  db_username     = var.db_username
  db_password     = var.db_password
  rds_sg_id       = module.security.rds_sg_id
}

module "wordpress" {
  source           = "./modules/wordpress_ec2"
  public_subnet_id = module.network.public_subnets[0]
  wp_sg_id         = module.security.wp_sg_id
  db_endpoint      = module.rds.db_endpoint
  key_name         = var.key_name
  ami_id           = var.ami_id
}

module "monitoring" {
  source           = "./modules/monitoring_ec2"
  public_subnet_id = module.network.public_subnets[1]
  monitoring_sg_id = module.security.monitoring_sg_id
  key_name         = var.key_name
  ami_id           = var.ami_id
}
