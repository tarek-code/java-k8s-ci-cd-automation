variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI for us-east-1"
  default     = "ami-07d9b9ddc6cd8dd30"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "assignment-key"
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  default     = "C:/Users/Unlimited/.ssh/id_rsa.pub" # غيّر حسب جهازك
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  default     = "springboot-app"
}
