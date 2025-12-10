#aws region

variable "aws_region" {
    description  = "Region in which aws resource is creating"
    type = string
    default = "us-east-1"
}

#aws instance type
variable "instance_type" {
    description = "instance type of the aws ec2"
    type = string
    default = "t2.micro"
}

#aws key_pair
variable "instance_keypair" {
    description = "key pair of the ec2 instance associated"
    type = string
    default = "terraform-key"
}




