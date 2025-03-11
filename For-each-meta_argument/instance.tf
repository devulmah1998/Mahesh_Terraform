data "aws_availability_zones" "avaiability_zones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amazon_linux.id
  #instance_type = var.instance_type
  instance_type = var.instance_list-type[1]
  #instance_type = var.instance_map-list["prod"]
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id  ]
   for_each =  toset(data.aws_availability_zones.avaiability_zones.names)
   availability_zone = each.value
  tags = {
    "Name" = "EC2-${each.key}"
  }
}
