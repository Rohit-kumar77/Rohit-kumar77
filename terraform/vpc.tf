terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws"{
    region = "us-east-2"
}

resource "aws_vpc" "demo_vpc"{
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet"{
    vpc_id= aws_vpc.demo_vpc.id
    cidr_block = "10.10.0.0/24"    
}

resource "aws_subnet" "private_subnet" {
    vpc_id= aws_vpc.demo_vpc.id
    cidr_block = "10.10.1.0/24"
}

resource "aws_internet_gateway" "igw"{
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
} 


resource "aws_route_table_association" "public_subnet"{
    subnet_id = aws_public_table.public_rtb.id
}