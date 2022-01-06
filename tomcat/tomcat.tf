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
  ami             = var.redhatami
  instance_type   = var.instance_type_micro
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = file("~/Desktop/terraform/init_script.sh")
  tags = {
    Name = "Tomcat_Server"
  }
}

resource "null_resource" "copy_execute-3" {

  connection {
    type        = "ssh"
    host        = aws_instance.Tomcat_Server.public_ip
    user        = "ec2-user"
    private_key = file("~/Desktop/terraform/private-key.pem")
  }

  provisioner "file" {
    source      = "~/Desktop/terraform/tomcat/Tomcat.sh"
    destination = "/tmp/Tomcat.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/Tomcat.sh",
      "sh /tmp/Tomcat.sh",
    ]
  }

  depends_on = [aws_instance.Tomcat_Server]

}