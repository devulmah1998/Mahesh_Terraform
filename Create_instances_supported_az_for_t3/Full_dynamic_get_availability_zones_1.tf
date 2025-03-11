#data source to get the list of avaialbility zones from aws
data "aws_availability_zones" "avaiability_zones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "my_instances_type1" { 
    for_each =  toset(data.aws_availability_zones.avaiability_zones.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}


#output for mapset()

output "availability_zones_for_t3_micro_1" {
  value = tomap({
    for az, details in data.aws_ec2_instance_type_offerings.my_instances_type1 : az => details.instance_types
  })
}
#output the values only which az supported for t3.micro
output "availability_zones_for_t3_micro-1" {
  value = tomap({
    for az, details in data.aws_ec2_instance_type_offerings.my_instances_type1 :
     az => details.instance_types if length(details.instance_types) !=0 
  })
}
# if you want only list of avaialability zones instaed of az and instance types
#key:value
#get the keys only by using kyes function it will provide the list of availability zones supported by the instnace_type is t3.micro

output "availability_zones_for_t3_micro01" {
  value = keys({
    for az, details in data.aws_ec2_instance_type_offerings.my_instances_type1 :
     az => details.instance_types if length(details.instance_types) !=0 
  })
}
#to get the specific az valueamong all set of az we get by using index number[0, 1, 3, 4, 5]

output "availability_zones_for_t3_micro2" {
  value = keys({
    for az, details in data.aws_ec2_instance_type_offerings.my_instances_type1 :
     az => details.instance_types if length(details.instance_types) !=0 
  }) [0] # if i mention [0] at the last we will get the 1 az in the set of values or [1] [2] like that
}

