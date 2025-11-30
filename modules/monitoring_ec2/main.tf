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

# IAM role for monitoring EC2 (Prometheus + YACE)
resource "aws_iam_role" "monitoring_role" {
  name = "${var.project_name}-${var.environment}-monitoring-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "monitoring_yace_policy" {
  name = "${var.project_name}-${var.environment}-yace-cloudwatch"
  role = aws_iam_role.monitoring_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:DescribeAlarms",
        "tag:GetResources"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "monitoring_profile" {
  name = "${var.project_name}-${var.environment}-monitoring-profile"
  role = aws_iam_role.monitoring_role.name
}

locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    wordpress_private_ip = var.wordpress_private_ip
  })
}

resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.monitoring_sg_id]
  key_name               = var.key_name

  associate_public_ip_address = true

  iam_instance_profile        = aws_iam_instance_profile.monitoring_profile.name

  user_data                   = local.user_data
  user_data_replace_on_change = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-monitoring-ec2"
    Project     = var.project_name
    Environment = var.environment
    Role        = "monitoring"
  }
}
