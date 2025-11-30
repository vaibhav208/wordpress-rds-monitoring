output "wordpress_sg_id" {
  value = aws_security_group.wordpress_sg.id
}

output "monitoring_sg_id" {
  value = aws_security_group.monitoring_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
