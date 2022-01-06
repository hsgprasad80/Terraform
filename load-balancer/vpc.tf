provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "Nbrown_VPC"
  }
}

# IGW for Nbrown vpc
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Nbrown_VPC_igw"
  }
}

# Public Subnets in Nbrown vpc
resource "aws_subnet" "Public_subnets" {
  count                   = length(var.pub_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pub_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Nbrown_Public_subnet_${count.index + 1}"
  }
}

# Public Route table for Nbrown_VPC
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    Name = "Nbrown_VPC_public_rt"
  }
}
# Route table and subnets assocation for public
resource "aws_route_table_association" "rt_sub_association" {
  count          = length(var.pub_subnets_cidr)
  subnet_id      = element(aws_subnet.Public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}