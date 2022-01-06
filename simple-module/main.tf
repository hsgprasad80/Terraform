provider "aws" {
	region = "us-east-1"
    profile                 = "guru"
    shared_credentials_file = "~/.aws/credentials"
}

module "aws-ec2" {
  source = "/Users/guruprasad/desktop/terraform/simple-module/modules/ec2"
}

module "aws-s3" {
  source = "/Users/guruprasad/desktop/terraform/simple-module/modules/s3"
}
