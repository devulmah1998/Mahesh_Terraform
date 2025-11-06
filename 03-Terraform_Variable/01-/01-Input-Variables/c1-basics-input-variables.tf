variable "ec2_ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0b0ea68c435eb488d"

}
variable "ec2_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

