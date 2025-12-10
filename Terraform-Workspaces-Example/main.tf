#==============================================================================
# TERRAFORM CONFIGURATION
#==============================================================================
# This configuration demonstrates Terraform Workspaces for managing multiple
# environments (dev, staging, prod) with different resource configurations
#==============================================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

#==============================================================================
# PROVIDER CONFIGURATION
#==============================================================================

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Workspace   = terraform.workspace
      ManagedBy   = "Terraform"
      CreatedDate = timestamp()
    }
  }
}

#==============================================================================
# DATA SOURCES
#==============================================================================

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#==============================================================================
# SECURITY GROUP
#==============================================================================
# Creates a workspace-specific security group with SSH and HTTP access
#==============================================================================

resource "aws_security_group" "workspace_sg" {
  name        = "${terraform.workspace}-sg"
  description = "Security group for ${terraform.workspace} workspace"

  # SSH Access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${terraform.workspace}-security-group"
    Environment = terraform.workspace
  }
}

#==============================================================================
# EC2 INSTANCES
#==============================================================================
# Number of instances varies by workspace:
# - dev: 1 instance (t2.micro)
# - staging: 2 instances (t2.small)
# - prod: 3 instances (t2.medium)
#==============================================================================

resource "aws_instance" "web" {
  count = lookup(var.instance_count, terraform.workspace, 1)
  
  # AMI and Instance Type
  ami           = data.aws_ami.amazon_linux.id
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")

  # Security
  vpc_security_group_ids = [aws_security_group.workspace_sg.id]

  # User data script
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from ${terraform.workspace} - Instance ${count.index + 1}</h1>" > /var/www/html/index.html
              EOF

  # Tags
  tags = {
    Name        = "${terraform.workspace}-instance-${count.index + 1}"
    Environment = terraform.workspace
    InstanceNum = count.index + 1
  }
}

#==============================================================================
# S3 BUCKET
#==============================================================================
# Creates a workspace-specific S3 bucket with unique naming
#==============================================================================

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "workspace_bucket" {
  bucket = "${var.project_name}-${terraform.workspace}-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${terraform.workspace}-bucket"
    Environment = terraform.workspace
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "workspace_bucket_versioning" {
  bucket = aws_s3_bucket.workspace_bucket.id

  versioning_configuration {
    status = terraform.workspace == "prod" ? "Enabled" : "Suspended"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "workspace_bucket_pab" {
  bucket = aws_s3_bucket.workspace_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
