terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "configuration" {
  description = "EC2 configuration"
  type = list(object({
    application_name = string
    ami              = string
    no_of_instances  = number
    instance_type    = string
    script_path      = string
    params           = list(string)
    healthcheck_cmd  = string
  }))
  default = []
}

variable "copy_files" {
  description = "Files to be copied from local to remote"
  type = list(object({
    local_path          = string
    remote_path         = string
    instance_name_regex = string
  }))
  default = []
}

variable "public_key" {
  description = "Public key information"
  type = object({
    name = string
    key  = string
  })
}

variable "private_key_location" {
  description = "Private key location"
  type        = string
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_key_pair" "deployer" {
  key_name   = var.public_key.name
  public_key = var.public_key.key
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  instances = flatten([
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances + 1) : {
        instance_name   = "${srv.application_name}-${i}"
        instance_type   = srv.instance_type
        ami             = srv.ami
        script_path     = srv.script_path
        params          = srv.params
        healthcheck_cmd = srv.healthcheck_cmd
      }
    ]
  ])
}

resource "aws_instance" "example_server" {
  for_each = { for server in local.instances : server.instance_name => server }

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [aws_security_group.allow_ssh.name]
  user_data                   = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              curl -fsSl https://get.docker.com -o get-docker.sh
              sudo sh ./get-docker.sh
              sudo usermod -aG docker $USER
              newgrp docker
              echo "Installation Complete" > /tmp/docker-installation-complete
              EOF

  tags = {
    Name = "${each.value.instance_name}"
  }
}

resource "terraform_data" "container_setup" {
  for_each = { for server in local.instances : server.instance_name => server }

  depends_on = [aws_instance.example_server]

  provisioner "file" {
    source      = each.value.script_path
    destination = "/tmp/${basename(each.value.script_path)}"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.example_server[each.value.instance_name].public_ip
      private_key = file(var.private_key_location)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/docker-installation-complete ]; do sleep 10; done",
      "chmod +x /tmp/${basename(each.value.script_path)}",
      "cd /tmp && ./${basename(each.value.script_path)} ${join(" ", [
        for param in each.value.params : regex("ip:", param) != null
        ? aws_instance.example_server[substr(param, 3, length(param) - 3)].private_ip
        : param
      ])}",
      lookup(each.value, "healthcheck_cmd", "echo 'No healthcheck specified'")
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.example_server[each.value.instance_name].public_ip
      private_key = file(var.private_key_location)
    }
  }
}

resource "terraform_data" "transfer_files" {
  for_each = {
    for pairs in flatten([
      for file in var.copy_files : [
        for server in local.instances : {
          local_path    = file.local_path
          remote_path   = file.remote_path
          instance_name = server.instance_name
        }
        if can(regex(file.instance_name_regex, server.instance_name))
      ]
    ]) : "${pairs.instance_name}-${pairs.local_path}" => pairs
  }

  depends_on = [aws_instance.example_server]

  provisioner "file" {
    source      = each.value.local_path
    destination = each.value.remote_path

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.example_server[each.value.instance_name].public_ip
      private_key = file(var.private_key_location)
    }
  }
}

output "instances" {
  value       = aws_instance.example_server
  description = "EC2 details"
}
