data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_host     = var.rds_endpoint
  })
}

resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.wordpress_sg_id]
  key_name               = var.key_name

  associate_public_ip_address = true

  user_data                  = local.user_data
  user_data_replace_on_change = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-wordpress-ec2"
    Project     = var.project_name
    Environment = var.environment
    Role        = "wordpress"
  }
}
