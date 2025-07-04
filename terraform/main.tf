provider "aws" {
  region = var.aws_region
}

# SSH Key
resource "aws_key_pair" "assignment_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Security Group
resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Allow SSH and NodePort access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort access"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Master Node
resource "aws_instance" "control_plane" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.assignment_key.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-master"
    Role = "controlplane"
  }
}

# Worker Node
resource "aws_instance" "worker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.assignment_key.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-worker"
    Role = "worker"
  }
}

# ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repo_name
}
