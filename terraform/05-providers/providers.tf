# this is the example of create resource on multiple region
terraform   {
    required_version = "~> 1.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    
}

provider "aws" {
    region = "us-east-2"

}

provider "aws" {
    region = "us-east-1"
    alias = us-east
}

resource "aws_s3_bucket" "my_bucket" {
    bucket = "test-random-bucket"
}

resource "aws_s3_bucket" "my_bucket" {
    bucket = "test-random-bucket"
    provider = aws.us-east
}  