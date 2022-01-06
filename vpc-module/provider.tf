# Provider
provider "aws" {
  region = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "guru"

  default_tags {
      tags = {
          createdby = "terraform"
      }
  }
}

terraform {
  backend "s3" {
    bucket  = "terraform-bkend-guru16"
    key     = "vpc-module/terraform.tfstate"
    region  = "us-east-1"
    profile = "guru"

    #dynamodb_table = "terraform-locks-guru16"
    #encrypt        = true
  }
}