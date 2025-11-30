output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_db_subnet_ids" {
  value = module.network.private_db_subnet_ids
}

output "wordpress_sg_id" {
  value = module.security.wordpress_sg_id
}

output "monitoring_sg_id" {
  value = module.security.monitoring_sg_id
}

output "rds_sg_id" {
  value = module.security.rds_sg_id
}

output "rds_endpoint" {
  description = "RDS endpoint for MySQL"
  value       = module.rds_mysql.rds_endpoint
}

output "db_name" {
  value = module.rds_mysql.db_name
}

output "db_username" {
  value = module.rds_mysql.db_username
}

output "wordpress_instance_id" {
  value = module.wordpress_ec2.instance_id
}

output "wordpress_public_ip" {
  value = module.wordpress_ec2.public_ip
}

output "wordpress_public_dns" {
  value = module.wordpress_ec2.public_dns
}

output "wordpress_private_ip" {
  value = module.wordpress_ec2.private_ip
}

output "monitoring_instance_id" {
  value = try(module.monitoring_ec2.instance_id, null)
}

output "monitoring_public_ip" {
  value = try(module.monitoring_ec2.public_ip, null)
}

output "monitoring_public_dns" {
  value = try(module.monitoring_ec2.public_dns, null)
}
