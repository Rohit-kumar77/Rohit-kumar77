# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for ${var.project_name} application"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# EC2 Instance(s)
resource "aws_instance" "app_server" {
  count                = var.instance_count
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  monitoring           = var.enable_monitoring

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project = var.project_name
  }))

  tags = merge(
    var.tags,
    {
      Name = count.index == 0 ? var.instance_name : "${var.instance_name}-${count.index + 1}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
