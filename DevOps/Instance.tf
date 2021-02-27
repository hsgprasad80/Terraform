provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  //*shared_credentials_file = "~/.aws/credentials" for linux
  profile = "guru"
}

resource "aws_instance" "Devops-instance" {
  ami                  = var.redhatami
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}" 
  instance_type        = "t2.micro"
  security_groups      = [ "sg-0b960783f63a19067" ]
  subnet_id            = "subnet-03b5034a84bdcec1f"
  key_name             = "Bastion-Key"
  user_data            = <<-EOF
      #!/bin/bash
        sudo yum update -y
		    sudo yum install httpd ruby wget -y
        sudo wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
        sudo chmod +x ./install
        sudo ./install auto
        sudo service httpd start 
        sudo service codedeploy-agent start
        sudo service codedeploy-agent status
        echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
 EOF

 tags = {
    Name        = "Devops-instance"
    Environment = "Development"
  }
}

# output values

  output "private_ip" {
  value       = ["${aws_instance.Devops-instance.*.private_ip}"]
  description = "The private IP address of the chef nodes"
    }
  output "public_ip" {
  value       = ["${aws_instance.Devops-instance.*.public_ip}"]
  description = "The private IP address of the chef nodes"
    }
  output "public_dns" {
  value       = ["${aws_instance.Devops-instance.*.public_dns}"]
  description = "The public dns of chef nodes"
    }