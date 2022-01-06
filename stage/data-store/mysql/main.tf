provider "aws" {
  region                  = var.aws_region
  profile                 = "guru"
  shared_credentials_file = "~/.aws/credentials"
}

terraform {
  backend "s3" {
    bucket  = "terraform-bkend-guru16"
    region  = "us-east-1"
    profile = "guru"

    dynamodb_table = "terraform-locks-guru16"
    encrypt        = true

    key = "stage/data-store/mysql/terraform-tfstate"
  }
}

# Db password id being fetched from SSM parameter store
data "aws_ssm_parameter" "db_insatnce" {
  name            = "admin-demodb-password" # our SSM parameter's name
  with_decryption = true                    # defaults to true, but just to be explicit...
}

resource "aws_db_instance" "mysql" {
  identifier        = "terraform-example"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"
  password          = data.aws_ssm_parameter.db_insatnce.value

  final_snapshot_identifier = "mysql"
  skip_final_snapshot       = true
  
  # Database Deletion Protection
  deletion_protection = false
}