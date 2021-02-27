#provider
provider "aws" {
  region = "us-east-1"
  #shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

# Name of the instance is being fetched from SSM parameter store
 data "aws_ssm_parameter" "instance_name" {
  name            = "secure-instance-name" # our SSM parameter's name
  with_decryption = true                   # defaults to true, but just to be explicit...
}

#create instance
resource "aws_instance" "Chef-workstation" {
  count           = var.number
  ami             = var.redhatami
 # ami 		        = var.ubuntuami	
  instance_type   = var.instance_type
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = <<-EOF
      #!/bin/bash
        sudo yum update -y
		#sudo wget https://packages.chef.io/files/stable/chef-workstation/20.7.96/el/7/chef-workstation-20.7.96-1.el7.x86_64.rpm
		#sudo yum install chef-workstation-20.7.96-1.el7.x86_64.rpm -y
        sudo yum install tree -y
        sudo yum install httpd -y
        sudo service httpd start 
        echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
 EOF
  tags = {
    Name = data.aws_ssm_parameter.instance_name.value
  }
}
