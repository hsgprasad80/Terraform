provider "aws" {
  region                  = "us-east-1"
  profile                 = "guru"
  shared_credentials_file = "~/.aws/credentials"
}

#create 2 nodes
resource "aws_instance" "Chef-node" {
  count           = var.number
  ami             = var.redhatami
  instance_type   = var.instance_type
  security_groups = ["sg-0b960783f63a19067"]
  subnet_id       = "subnet-03b5034a84bdcec1f"
  key_name        = var.Privkey_name
  user_data       = file("~/Desktop/terraform/init_script.sh")

  tags = {
    Name = "Chef-node_${count.index + 1}"
  }
}

/*
module "aws-ec2" {
  source = "/Users/guruprasad/desktop/terraform/simple-module/modules/ec2"
}
*/
terraform {
  backend "s3" {
    bucket  = "terraform-bkend-guru16"
    key     = "test/terraform.tfstate"
    region  = "us-east-1"
    profile = "guru"

    dynamodb_table = "terraform-locks-guru16"
    encrypt        = true
  }
}