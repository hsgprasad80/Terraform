#provider
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

# backend S3 and dynamoDb lock table for maintaining the state file. 
terraform {
  backend "s3" {
    bucket  = "terraform-bkend-guru16"
    key     = "Kube/terraform.tfstate"
    region  = "us-east-1"
    profile = "guru"

    #dynamodb_table = "terraform-locks-guru16"
    #encrypt        = true
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Cost Centre"]
  }
}

data "aws_subnet" "pub_sub" {
  filter {
    name   = "tag:Name"
    values = ["BU01-Prod-PublicSN-1a"]
  }
}

data "aws_security_group" "my_sg" {

  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = "Bastion-SG"
  }
}

#create t2 medium instance
resource "aws_instance" "Kube-master" {
  #ami              = var.redhatami
  ami                    = var.ubuntuami
  instance_type          = var.instance_type1
  subnet_id              = data.aws_subnet.pub_sub.id
  vpc_security_group_ids = [data.aws_security_group.my_sg.id]
  key_name               = var.Privkey_name 
  user_data              = file("~/Desktop/terraform/kubernetes/init_script.sh")
  tags = {
    Name = "Kube-master"
  }
}

# SSH into newly launched instance, copies the shell script file from source to newly 
# launched inistance and executes the shell script
resource "null_resource" "copy_execute" {

  connection {
    type        = "ssh"
    host        = aws_instance.Kube-master.public_ip
    user        = "ubuntu"
    private_key = file("~/Desktop/terraform/private-key.pem")
  }

  provisioner "file" {
    source      = "~/Desktop/terraform/kubernetes/config.sh"
    destination = "/home/ubuntu/config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/config.sh",
      "sudo sh /home/ubuntu/config.sh",
    ]
  }
 
}
/*
#create t2 micro instance
resource "aws_instance" "Kube-worker" {
  count                  = var.number   
  ami                    = var.ubuntuami
  instance_type          = var.instance_type1
  subnet_id              = data.aws_subnet.pub_sub.id
  vpc_security_group_ids = [data.aws_security_group.my_sg.id]
  key_name               = var.Privkey_name
  user_data              = file("~/Desktop/terraform/kubernetes/init_script.sh")
  tags = {
    Name = "Kube-worker_${count.index + 1}"
  }
}

resource "null_resource" "copy_execute_worker" {

  connection {
    type        = "ssh"
    host        = aws_instance.Kube-worker.*.public_ip
    user        = "ubuntu"
    private_key = file("~/Desktop/terraform/private-key.pem")
  }

  provisioner "file" {
    source      = "~/Desktop/terraform/kubernetes/config.sh"
    destination = "/tmp/config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/config.sh",
      "sh /tmp/config.sh",
    ]
  }

  depends_on = [aws_instance.Kube-worker]

}
*/