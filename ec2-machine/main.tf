


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_security_group" "allow_tls" {
  name        = "ec2_sg"
  description = "Allow SSH and HTTP"
  
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
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


resource "aws_instance" "example" {
  ami           = "ami-00ca32bbc84273381"
  instance_type = "t3.micro"

  key_name = "ansible-key"

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "HandsOn-First-Machine"
  }
}



output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.example.public_dns
}