output "instance_id" {
  value = aws_instance.monitoring.id
}

output "public_ip" {
  value = aws_instance.monitoring.public_ip
}

output "public_dns" {
  value = aws_instance.monitoring.public_dns
}
