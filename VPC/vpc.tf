# Provider
provider "aws" {
  region = var.aws_region
  //*shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
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

# Public Subnets in demo_vpc
resource "aws_subnet" "Public_subnets" {
  count                   = length(var.pub_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pub_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "demo_Public_subnet_${count.index + 1}"
  }
}

# Private Subnets in demo_vpc
resource "aws_subnet" "Private_subnets" {
  count                   = length(var.priv_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.priv_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "demo_Private_subnet_${count.index + 1}"
  }
}

# Public Route table for demo_vpc
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    Name = "demo_vpc_public_rt"
  }
}

# Private Route table for demo_vpc
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_vpc_private_rt"
  }
}

# Route table and subnets assocation for public
resource "aws_route_table_association" "rt_sub_association1" {
  count          = length(var.pub_subnets_cidr)
  subnet_id      = element(aws_subnet.Public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

# Route table and subnets assocation for private
resource "aws_route_table_association" "rt_sub_association2" {
  count          = length(var.priv_subnets_cidr)
  subnet_id      = element(aws_subnet.Private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
