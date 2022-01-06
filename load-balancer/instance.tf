resource "aws_instance" "Node" {
  count                  = var.number
  ami                    = var.redhatami
  instance_type          = var.instance_type
  subnet_id              = element(aws_subnet.Public_subnets.*.id, count.index)
  key_name               = var.Privkey_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
		sudo yum install httpd -y
		echo "<h1>Deployed via Terraform $HOSTNAME</h1>" | sudo tee /var/www/html/index.html
    sudo service httpd start
    sudo chkconfig httpd on
 EOF
  tags = {
    Name = "Node_${count.index + 1}"
  }
}
