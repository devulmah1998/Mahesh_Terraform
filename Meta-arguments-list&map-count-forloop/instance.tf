resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amazon_linux.id
  #instance_type = var.instance_type
  instance_type = var.instance_list-type[1]
  #instance_type = var.instance_map-list["prod"]
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id  ]
  count = 3
  tags = {
    "Name" = "EC2-${count.index}"
  }
}
