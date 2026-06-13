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

provider "aws" {
    region = "us-east-2"
}
