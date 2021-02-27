provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  //*shared_credentials_file = "~/.aws/credentials" for linux
  profile = "guru"
}

data "aws_ssm_parameter" "instance_name" {  
  name            = "secure-instance-name" # our SSM parameter's name
  with_decryption = true # defaults to true, but just to be explicit...
}

resource "aws_instance" "tf_instance" {  
  ami           = "ami-0b898040803850657"
  instance_type = "t2.micro"
  tags = {
    Name = data.aws_ssm_parameter.instance_name.value
  }
}