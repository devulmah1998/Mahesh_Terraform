resource "aws_instance" "my_ec2" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = "terraform_key"

  tags = {
    Name = "my_ec2"
  }
}
