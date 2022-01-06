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
  depends_on = [aws_nat_gateway.NAT_GATEWAY]

  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY.id
  }
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

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "Nat-Gateway-EIP" {
  vpc        = true
}
