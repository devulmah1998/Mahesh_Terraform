#==============================================================================
# OUTPUTS
#==============================================================================
# Output values to display after terraform apply
#==============================================================================

#------------------------------------------------------------------------------
# Workspace Information
#------------------------------------------------------------------------------

output "workspace_name" {
  description = "Current Terraform workspace name"
  value       = terraform.workspace
}

output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = var.aws_region
}

#------------------------------------------------------------------------------
# EC2 Instance Outputs
#------------------------------------------------------------------------------

output "instance_count" {
  description = "Total number of instances created"
  value       = length(aws_instance.web)
}

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.web[*].id
}

output "instance_public_ips" {
  description = "List of public IP addresses for instances"
  value       = aws_instance.web[*].public_ip
}

output "instance_details" {
  description = "Detailed information about each instance"
  value = [
    for idx, instance in aws_instance.web : {
      name        = instance.tags["Name"]
      id          = instance.id
      public_ip   = instance.public_ip
      private_ip  = instance.private_ip
      type        = instance.instance_type
      az          = instance.availability_zone
    }
  ]
}

output "web_urls" {
  description = "URLs to access the web servers"
  value       = [for ip in aws_instance.web[*].public_ip : "http://${ip}"]
}

#------------------------------------------------------------------------------
# Security Group Outputs
#------------------------------------------------------------------------------

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.workspace_sg.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.workspace_sg.name
}

#------------------------------------------------------------------------------
# S3 Bucket Outputs
#------------------------------------------------------------------------------

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.workspace_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.workspace_bucket.arn
}

output "s3_bucket_versioning" {
  description = "Versioning status of the S3 bucket"
  value       = aws_s3_bucket_versioning.workspace_bucket_versioning.versioning_configuration[0].status
}

#------------------------------------------------------------------------------
# Summary Output
#------------------------------------------------------------------------------

output "deployment_summary" {
  description = "Summary of the deployment"
  value = <<-EOT
    ╔════════════════════════════════════════════════════════════════╗
    ║           TERRAFORM WORKSPACE DEPLOYMENT SUMMARY               ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ Workspace:        ${terraform.workspace}
    ║ Region:           ${var.aws_region}
    ║ Instances:        ${length(aws_instance.web)} x ${lookup(var.instance_type, terraform.workspace, "t2.micro")}
    ║ Security Group:   ${aws_security_group.workspace_sg.name}
    ║ S3 Bucket:        ${aws_s3_bucket.workspace_bucket.id}
    ╚════════════════════════════════════════════════════════════════╝
  EOT
}
