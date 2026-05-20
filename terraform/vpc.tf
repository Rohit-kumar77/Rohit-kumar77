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
    vpc_id = aws_vpc.demo_vpc
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet"{
    vpc_id = aws_vpc.demo_vpc
    cidr_block = "10.10.0.0/24"    
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.demo_vpc
    cidr_block = "10.10.1.0/24"
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.demo_vpc
}

resource "aws_route_table" "public_rtb"{
  vpc_id= aws_vpc.demo_vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  } 
}

resource "aws_route_table_association" "public_subnet"{
    subnet_id = aws_public_table.public_rtb.id
}