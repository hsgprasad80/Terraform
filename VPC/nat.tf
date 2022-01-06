# Creating a NAT Gateway!
resource "aws_nat_gateway" "NAT_GATEWAY" {
  
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]
  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.Public_subnets.*.id[0]
  tags = {
    Name = "Nat-Gateway_demo"
  }

}