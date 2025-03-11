output "instance_publicip" {
    description = "publicip of the instance"
    value = aws_instance.myec2vm.public_ip
  
}
output "instance_pubicdns" {
    description = "publicdns of the instance"
    value = aws_instance.myec2vm.public_dns
}
output "aws_security_group" {
    description = "security group id"
    value = aws_security_group.vpc-ssh.id
}