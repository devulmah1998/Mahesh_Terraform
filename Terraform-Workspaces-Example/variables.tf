#==============================================================================
# VARIABLES CONFIGURATION
#==============================================================================
# Variables that control workspace-specific resource configurations
#==============================================================================

#------------------------------------------------------------------------------
# General Configuration
#------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., us-east-1)."
  }
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "myproject"
  
  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 20
    error_message = "Project name must be between 1 and 20 characters."
  }
}

#------------------------------------------------------------------------------
# Workspace-Specific Instance Configuration
#------------------------------------------------------------------------------

variable "instance_count" {
  description = <<-EOT
    Number of EC2 instances to create per workspace
    - dev: 1 instance for development
    - staging: 2 instances for testing
    - prod: 3 instances for production
  EOT
  type        = map(number)
  
  default = {
    dev     = 1
    staging = 2
    prod    = 3
  }
}

variable "instance_type" {
  description = <<-EOT
    EC2 instance type per workspace
    - dev: t2.micro (1 vCPU, 1 GB RAM) - Free tier eligible
    - staging: t2.small (1 vCPU, 2 GB RAM)
    - prod: t2.medium (2 vCPU, 4 GB RAM)
  EOT
  type        = map(string)
  
  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t2.medium"
  }
}
