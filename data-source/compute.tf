data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "region"
        values = ["us-east-1"]
    }
    owners = ["099720109477"]
}

output "test" {
  value = data.aws_ami.ubuntu
}
   

data "aws_caller_identity" "current"{ }

data "aws_region" "current" {
    provider = aws.us_east
}

data "aws_vpc" "prod_vpc" {
    tags = {
        Env = "Prod"
    }
}

output "prod_vpc_id" {
    value = data.aws_vpc.prod_vpc.id 
}

output "ubuntu_ami_data" {
    value = data.aws_ami.ubuntu.id
}
