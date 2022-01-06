
data "aws_availability_zones" "all" {}

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

