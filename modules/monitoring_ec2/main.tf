resource "aws_instance" "monitoring" {
  ami = var.ami_id
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [var.monitoring_sg_id]
  key_name = var.key_name
  user_data = file("${path.module}/userdata.sh")
}
