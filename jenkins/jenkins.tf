#create instance
resource "aws_instance" "Jenkins_Server" {
  ami             = var.redhatami
  instance_type   = var.instance_type_medium
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = file("~/Desktop/terraform/init_script.sh")
  tags = {
    Name = "Jenkins_Server"
  }
}   

resource "null_resource" "copy_execute-0" {

  connection {
    type        = "ssh"
    host        = aws_instance.Jenkins_Server.public_ip
    user        = "ec2-user"
    private_key = file("~/Desktop/terraform/private-key.pem")
  }

  provisioner "file" {
    source      = "~/Desktop/terraform/jenkins/jenkins.sh"
    destination = "/tmp/Jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/Jenkins.sh",
      "sh /tmp/Jenkins.sh",
    ]
  }

  depends_on = [aws_instance.Jenkins_Server]

}