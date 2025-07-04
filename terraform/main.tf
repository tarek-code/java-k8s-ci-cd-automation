provider "aws" {
  region = "eu-west-1"
}

# مفتاح SSH علشان تقدر تدخل الـ EC2
resource "aws_key_pair" "assignment_key" {
  key_name   = "assignment-key"
  public_key = file("~/.ssh/id_rsa.pub") # غيّر المسار لو المفتاح عندك في مكان تاني
}

# Security Group: تفتح SSH و NodePort
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

# EC2: Master Node
resource "aws_instance" "control_plane" {
  ami                    = "ami-052e6b9b2e1f0c8a4" # Ubuntu 22.04 (eu-west-1)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.assignment_key.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  tags = {
    Name = "k3s-master"
    Role = "controlplane"
  }
}

# EC2: Worker Node
resource "aws_instance" "worker" {
  ami                    = "ami-052e6b9b2e1f0c8a4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.assignment_key.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  tags = {
    Name = "k3s-worker"
    Role = "worker"
  }
}

# ECR Repo
resource "aws_ecr_repository" "app_repo" {
  name = "springboot-app"
}
