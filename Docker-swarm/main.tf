/*resource "aws_key_pair" "default" {
  key_name   = "clusterkp"
  public_key = ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCQocYEFMudby46RwoV9osNtJ8QVFRseNBzhdhSUXPzKhjQo6lLfKoParr5NMqmCq4d05BHVxHZnryKE6goAxfrwrz+KUfdlIOeCACclPxEatDOK9NO5bwFWID5sv5qpatdbu/kA0BVN6pTas0X3ivqd9+MBygJTjWXkO9ZuOQHg+pUutBsXG0yZLlndSdZYQmPkb9Gh3zlad1OthjY7V34b4JTPfjo7KTtndu51Mo+6p5a44sEaIX4yLqiyE0kkjJlL3Bx28iQBmLautML61AI4UWEVuH/SK3fDeP6BUIB562/22ZBOkuKxA+m2wmH6Vv/eg9RlHMT+RxgjTaf1gnL private-key''
}
*/
resource "aws_instance" "master" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
# key_name        = "aws_key_pair.default.id" 
# user_data       = var.bootstrap_path
# user_data       = file ("install-docker.sh")
  user_data       = <<-EOF
    #!/bin/bash
    sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo yum install epel-release-latest-7.noarch.rpm -y
    sudo yum update -y
		sudo yum install git httpd docker python python-level python-pip openssl ansible -y
		sudo service httpd start
    sudo service docker start
    sudo usermod -aG docker ec2-user
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
 EOF

  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker2" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = <<-EOF
    #!/bin/bash
    sudo yum update -y
		sudo yum install httpd docker -y
		sudo service httpd start
    sudo service docker start
    sudo usermod -aG docker ec2-user
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
 EOF

  tags = {
    Name = "worker 2"
  }
}

*/

resource "aws_instance" "worker1" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
#user_data       = var.bootstrap_path
  user_data       = <<-EOF
    #!/bin/bash
    sudo yum update -y
		sudo yum install httpd docker -y
		sudo service httpd start
    sudo service docker start
    sudo usermod -aG docker ec2-user
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
 EOF
 
  tags = {
    Name = "worker 1"
  }
}