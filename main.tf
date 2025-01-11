provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "spring-app-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "spring-app-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "spring-app-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "spring-app-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for Spring Boot application
resource "aws_security_group" "app_sg" {
  name        = "spring-app-sg"
  description = "Security group for Spring Boot application"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Spring Boot application port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "spring-app-sg"
  }
}

# Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_file)
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update system packages
              sudo apt update -y
              sudo apt upgrade -y

              # Install Java 17
              sudo apt install openjdk-17-jdk -y

              # Install Git
              sudo apt install git -y

              # Clone your application
              git clone ${var.git_repo_url} /home/ubuntu/java-app

              # Install Maven
              sudo apt install maven -y

              # Ensure target directory is clean 
              TARGET_DIR="/home/ubuntu/java-app/target"
              if [ -d "$TARGET_DIR" ]; then
                  echo "Cleaning target directory..."
                  sudo rm -rf "$TARGET_DIR" && break
              fi

              # Build and run the application
              cd /home/ubuntu/java-app
              mvn clean package || { 
                  # If mvn clean package fails, ensure target is cleaned up and retry
                  echo "Build failed, cleaning target and retrying..."
                  sudo rm -rf "$TARGET_DIR" && mvn clean package
              }
              nohup java -jar target/*.jar > /home/ubuntu/application.log 2>&1 &
              EOF

  tags = {
    Name = "spring-boot-app-server"
  }
}
