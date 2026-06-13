resource "aws_vpc" "dev"{
    cidr_block = "10.0.0.0/16"

    tags = {
        Name      = "vpc-test"
        ManagedBy = "Terraform"
        Project = "Terraform"

    }
}

resource "aws_subnet" "pubic"{
    vpc_id = aws.vpc.main.vpc_id
    cidr_block = "10.0.0.0/24"

    tags = {
        Name  = "06-resource"
        ManagedBy = "Terraform"
        Project   = "06-resource"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.vpc_id

    tags = {
        Name  = "06-resource-main"
        ManagedBy = "Terraform"
        Project   = "06-resource"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.vpc_id

    tags = {
        Name  = "06-resource-main"
        ManagedBy = "Terraform"
        Project   = "06-resource"
      }
    }
}

resource "aws_route_table_association" "public"{
    subnet_id = aws_subnet.pubic.vpc_id
    route_table_id = aws_route_table.public.id 
}