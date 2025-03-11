


# Output - EC2 instanec public ip for toset() function
output "for_output_toset1" {
  description = "Public_ips for ec2 instnaces"
  #value = {for instance in aws_instance.myec2vm: instance.id => instance.public_dns}
  value = toset([for instance in aws_instance.myec2vm: instance.public_ip])
}

#Output - EC2 instance public dns for toset()function
output "for_output_toset2" {
  description = "public_dns for instnaces"
  #value = {for instance in aws_instance.myec2vm: instance.id => instance.public_dns}
  value = toset([for instance in aws_instance.myec2vm: instance.public_dns])
}

#Output - EC2 instance public_dns for tomap() function
output "for_output_tomap" {
  description = "public_dns for instnaces tomap"
  #value = {for instance in aws_instance.myec2vm: instance.id => instance.public_dns}
  value = tomap({for az, instance in aws_instance.myec2vm: az => instance.public_dns})
}
