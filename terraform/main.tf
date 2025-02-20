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


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCulyTEu3/ByEQcnHoSFmO/EddIMXEOsJ+jEHp4lL1Bz1tfTIysiQpqnI8Jj+2L1nAthMx9Cq5aw8feQtTsxe6Ipjqifzk/K3raPIBRcZpwTu0FvhpgeK4hNQPfKemfo5aavz8F79cN2+BbcLf1gVf9pazmyEV4Vqi/enHsYvZkxW4rUBkodXvSBmYeYMnJ2ALt9m2mACB4Af/2YcGuYIqCoyRwydYEHVMnmBZkCwPDt2/VaUVkGfBYTAFIFZdKByN81OEN8nNzkSRjcxQtAuJ3hFBJWQCevo8ftr0pjBrEoLuuiIqescCCdw71FD8fZkUuzhn5XlbqQdVnA6+zhC7H ta@jomamas.csl"
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
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

variable "configuration" {
  description = "EC2 configuration"
  default = [{}]
}

locals {
  serverconfig = [
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances+1) : {
        instance_name = "${srv.application_name}-${i}"
        instance_type = srv.instance_type
        ami = srv.ami
      }
    ]
  ]
}

locals {
  instances = flatten(local.serverconfig)
}

/*
resource "aws_instance" "my_vm_1" {
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "tugasakhir"
  security_groups             = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "my_vm_1"
  }
}
*/

resource "aws_instance" "example_server" {
  for_each = {for server in local.instances: server.instance_name =>  server}

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  associate_public_ip_address = true
  # key_name                    = aws_key_pair.deployer.key_name
  key_name                    = "tugasakhir"
  security_groups             = [aws_security_group.allow_ssh.name]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              curl -fsSl https://get.docker.com -o get-docker.sh
              sudo sh ./get-docker.sh
              sudo usermod -aG docker $USER
              newgrp docker
              EOF

  tags = {
    Name = "${each.value.instance_name}"
  }
}

output "instances" {
  value       = "${aws_instance.example_server}"
  description = "EC2 details"
}