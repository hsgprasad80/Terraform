#create instance
resource "aws_instance" "SonarQube_Server" {
  ami             = var.redhatami
  instance_type   = var.instance_type_medium
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = file("~/Desktop/terraform/init_script.sh")
 
  tags = {
    Name = "SonarQube_Server"
  }
}

resource "null_resource" "copy_execute-2" {

  connection {
    type        = "ssh"
    host        = aws_instance.SonarQube_Server.public_ip
    user        = "ec2-user"
    private_key = file("~/Desktop/terraform/private-key.pem")
  }

  provisioner "file" {
    source      = "~/Desktop/terraform/sonar/Sonar.sh"
    destination = "/tmp/Sonar.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/Sonar.sh",
      "sh /tmp/Sonar.sh",
    ]
  }

  depends_on = [aws_instance.SonarQube_Server]

}