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

#aws EC2 Instance Type -list
variable "instance_list-type" {
    description = "aws_instance_type-list"
    type = list(string)
    default = [ "t3.micro", "t3.small", "t3.large" ]
}

#aws EC2 Instance Type - map
variable "instance_map-list" {
    description = "aws_instance_map-list"
    type = map(string)
    default = {
      "dev" = "t3.micro"
      "qa"  = "t3.small"
      "prod" = "t3.large"
    }
}




