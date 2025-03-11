# Data source to check instance type offerings in specific AZs
data "aws_ec2_instance_type_offerings" "my_instances_type1" {
  for_each = toset(["us-east-1a", "us-east-1b", "us-east-1e"])

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

# Output the availability zones where t3.micro is supported
#tomap() map function pass the set values
output "availability_zones_for_t3_micro1" {
  value = tomap({
    for az, details in data.aws_ec2_instance_type_offerings.my_instances_type1 : az => details.instance_types
  })
}
#toset() function pass the set values
output "availability_zones_for_t3_micro2" {
value = toset([for types in data.aws_ec2_instance_type_offerings.my_instance_type1: types.instances_types])
}
 #toset() prepares the input for iteration.

#tomap() ensures the output is properly structured.
#The for expression iterates over the data source (data.aws_ec2_instance_type_offerings.my_instances_type1).

#For each availability zone (az), it extracts the instance_types.

#The result is a map-like structure, but to ensure Terraform treats it as a map, you wrap it in tomap().

#Without tomap(), Terraform might treat the result as a generic object. With tomap(), it’s explicitly a map.