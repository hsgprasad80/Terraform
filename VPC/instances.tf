# Demo Amazon Linux Server(t2.micro)

resource "aws_instance" "Bastion_server" {
  count                  = 1
  ami                    = var.ubuntuami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = element(aws_subnet.Public_subnets.*.id, count.index)
  # key_name               = aws_key_pair.key-pair.key_name
  key_name               = var.Privkey_name
  user_data              = file("~/Desktop/terraform/init_ubuntu.sh")

  tags = {
    Name = "Bastion_server"
    Type = "Linux-2"
  }
}