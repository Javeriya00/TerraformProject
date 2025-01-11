# variables.tf

# AWS Configuration
variable "aws_region" {
  default = "us-east-1"
}

# VPC Configuration
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

# Subnet Configuration
variable "public_subnet_cidr" {
  default = "172.16.10.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

# Security Group Configuration
variable "ssh_port" {
  default = 22
}

variable "app_port" {
  default = 8080
}

# EC2 Configuration
variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0e2c8caa4b6378d8c" # Ubuntu 22.04 LTS
}

variable "key_name" {}

variable "public_key_file" {}

variable "git_repo_url" {
  default = "https://github.com/Javeriya00/java-app.git"
}


