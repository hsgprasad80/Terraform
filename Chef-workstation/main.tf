#provider
provider "aws" {
  region = "us-east-1"
  #shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

# backend S3 and dynamoDb lock table for maintaining the state file. 
terraform {
  backend "s3" {
    bucket  = "terraform-bkend-guru16"
    key     = "CW/terraform.tfstate"
    region  = "us-east-1"
    profile = "guru"

    #dynamodb_table = "terraform-locks-guru16"
    #encrypt        = true
  }
}

# Name of the instance is being fetched from SSM parameter store
data "aws_ssm_parameter" "instance_name" {
  # our SSM parameter's name
  name            = "secure-instance-name" 
  # defaults to true, but just to be explicit...
  with_decryption = true              
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["Cost Centre"] 
  }
}

data "aws_subnet" "pub_sub" {
  filter {
    name = "tag:Name"
    values = ["BU01-Prod-PublicSN-1a"] 
  }
}

data "aws_security_group" "my_sg" {

 vpc_id = data.aws_vpc.selected.id 

  tags =  {
    Name = "Bastion-SG"
  }  
}

#create instance
resource "aws_instance" "Chef-workstation" {
  ami              = var.redhatami
  #ami 		         = var.ubuntuami	
  instance_type    = var.instance_type
  subnet_id        = data.aws_subnet.pub_sub.id
  vpc_security_group_ids = ["${data.aws_security_group.my_sg.id}"]
  key_name         = var.Privkey_name
  user_data        = file("~/Desktop/terraform/init_script.sh")
  tags = {
    Name = data.aws_ssm_parameter.instance_name.value
  }
}

# SSH into newly launched instance, copies the shell script file from source to newly 
# launched inistance and executes the shell script
resource "null_resource" "copy_execute" {

  connection {
    type        = "ssh"
    host        = aws_instance.Chef-workstation.public_ip
    user        = "ec2-user"
    private_key = file("~/Desktop/terraform/private-key.pem")
  }

  provisioner "file" {
    source      = "~/Desktop/terraform/chef-workstation/httpd.sh"
    destination = "/tmp/httpd.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/httpd.sh",
      "sh /tmp/httpd.sh",
    ]
  }

  depends_on = [aws_instance.Chef-workstation]

}