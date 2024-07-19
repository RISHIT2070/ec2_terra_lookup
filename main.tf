terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "access_key" {
  description = "AWS access key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "environment" {
  description = "Environment type (dev or prod)"
  type        = string
  default     = "dev"
}

variable "instance_count" {
  description = "Number of AWS EC2 instances to create"
  type        = number
  default     = 2  
}

locals {
  instance_types = {
    dev  = "t2.micro"
    prod = "t3.medium"
  }

  instance_type = lookup(local.instance_types, var.environment, "t2.micro")
}
locals {
  instance_names = [for idx in range(var.instance_count) : "${var.environment}-ec2-instance-${idx + 1}"]
}
resource "aws_instance" "Infrasity" {
  for_each = { for idx, name in local.instance_names : idx => name }

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = local.instance_type

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}

