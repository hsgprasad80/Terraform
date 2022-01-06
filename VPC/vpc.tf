# Provider
provider "aws" {
  region = var.aws_region
  //*shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

terraform {
  backend "s3" {
    bucket  = "terraform-bkend-guru16"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "guru"

    #dynamodb_table = "terraform-locks-guru16"
    #encrypt        = true
  }
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "demo_vpc"
  }
}

# IGW for demo_vpc
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_vpc_igw"
  }
}