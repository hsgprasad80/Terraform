# Demo Amazon Linux Server(t2.micro)

resource "aws_instance" "Bastion_server" {
  count                  = 1
  ami                    = var.redhatami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = element(aws_subnet.Public_subnets.*.id, count.index)
  key_name               = var.Privkey_name
  //user_data            = file("init_script.sh")
  user_data = <<-EOF
   #!/bin/bash
	   sudo yum update -y
	   sudo yum install httpd -y
	   sudo yum service httpd start
	   echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF	 
  tags = {
    Name = "Bastion_server"
    Type = "Linux-2"
  }
}