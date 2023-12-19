terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # region = "us-east-1"
  region = "ap-southeast-1"
}

resource "tls_private_key" "training-terraform-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.aws_key_pair_name
  public_key = tls_private_key.training-terraform-key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = var.aws_key_pair_name
  content         = tls_private_key.training-terraform-key.private_key_pem
  file_permission = "0400"
}

resource "aws_security_group" "web_instance_sg" {
  name        = "web-instance-sg"
  description = "Allow inbound traffic SSH and HTTP traffic and outbound internet traffic"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  # ami                    = "ami-0fc5d935ebf8bc3bc"
  ami                    = "ami-078c1149d8ad719a7"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.web_instance_sg.id]

  tags = {
    Name = "web_instance"
  }
}
