data "aws_availability_zone" "name" {
    state = "available"
}

output "azs" {
    value = data.aws_availability_zones.available[*].id
}