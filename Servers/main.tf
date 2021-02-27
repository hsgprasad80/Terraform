#provider
provider "aws" {
  region = var.aws_region
  #shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"
}

# Name of the instance is being fetched from SSM parameter store
/*data "aws_ssm_parameter" "instance_name" {  
  name            = "secure-instance-name" # our SSM parameter's name
  with_decryption = true # defaults to true, but just to be explicit...
}
*/

#create instance
resource "aws_instance" "Tomcat_Server" {
  count           = 1
  ami             = var.redhatami
  instance_type   = var.instance_type_micro
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  /*user_data              = file("init_script.sh") */
  user_data = <<-EOF
      #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        sudo yum service httpd start
        
      EOF
  tags = {
    Name = "Tomcat_Server"
  }
}

#create instance
resource "aws_instance" "SonarQube_Server" {
  count           = 1
  ami             = var.redhatami
  instance_type   = var.instance_type_medium
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = <<-EOF
      #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        sudo yum service httpd start
      EOF
  tags = {
    Name = "SonarQube_Server"
  }
}

#create instance
resource "aws_instance" "Nexus_Server" {
  count           = 1
  ami             = var.redhatami
  instance_type   = var.instance_type_medium
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = <<-EOF
      #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        sudo yum service httpd start
        
      EOF
  tags = {
    Name = "Nexus_Server"
  }
}

#create instance
resource "aws_instance" "Jenkins_Server" {
  count           = 1
  ami             = var.redhatami
  instance_type   = var.instance_type_medium
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = <<-EOF
      #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        sudo yum service httpd start

      EOF
  tags = {
    Name = "Jenkins_Server"
  }
}       