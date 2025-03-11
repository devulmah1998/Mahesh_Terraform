resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amazon_linux.id
  #instance_type = var.instance_type
  instance_type = var.instance_list-type[1]
  #instance_type = var.instance_map-list["prod"]
  key_name = "terraform-key"
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id  ]
   for_each =  toset(keys({
    for az, details in data.aws_ec2_instance_type_offerings.my_instances_type1 :
     az => details.instance_types if length(details.instance_types) !=0 
  }))
   availability_zone = each.value
  tags = {
    "Name" = "EC2-${each.key}"
  }
}
