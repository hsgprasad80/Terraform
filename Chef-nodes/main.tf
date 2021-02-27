#provider
provider "aws" {
  region = var.aws_region
  #shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

#create 2 nodes
resource "aws_instance" "Chef-node" { 
  count           = var.number
  ami             = var.redhatami
  instance_type   = var.instance_type
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = <<-EOF
    #!/bin/bash
    sudo yum update -y
		sudo yum install httpd -y
		sudo service httpd start
    echo "* * * * * root chef-client" | sudo tee /etc/crontab
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
 EOF
  tags = {
    Name = "Chef-node_${count.index + 1}"
  }
}