resource "aws_instance" "Node" {
  count           = 1
  ami             = "ami-02354e95b39ca8dec"
  instance_type   = "t2.micro"
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = "private-key"
  user_data       = file("~/Desktop/terraform/init_script.sh")

  tags = {
    Name = "Node_${count.index + 1}"
  }
}