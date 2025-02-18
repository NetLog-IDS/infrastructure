terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "netlog_network"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "netlog_subnet_1"
  }
}

resource "aws_instance" "my_vm_1" {
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "my_vm_1"
  }
}
