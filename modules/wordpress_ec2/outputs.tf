output "instance_id" {
  value = aws_instance.wordpress.id
}

output "public_ip" {
  value = aws_instance.wordpress.public_ip
}

output "public_dns" {
  value = aws_instance.wordpress.public_dns
}

output "private_ip" {
  value = aws_instance.wordpress.private_ip
}
