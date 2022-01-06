provider "aws" {
  region                  = "us-east-1"
  profile                 = "guru"
  shared_credentials_file = "~/.aws/credentials"
}

module "web_cluster" {
  source = "/Users/guruprasad/desktop/terraform/modules/services/web-cluster"

  cluster_name           = "webserver_stage"
  db_remote_state_bucket = "terraform-bkend-guru16"
  web_remote_state_lock  = "terraform-locks-guru16"
  web_remote_state_key   = "stage/data-store/mysql/terraform-tfstate"
  db_remote_state_key    = "stage/data-store/mysql/terraform-tfstate"

  instance_type      = "t2.micro"
  ami                = "ami-042e8287309f5df03"
  max_size           = 3
  min_size           = 1
  desired_size       = 1
  enable_autoscaling = false
  give_neo_cloudwatch_full_acess = false

  custom_tags = {
    owner      = "team-foo"
    DeployedBy = "terraform"
  }
}
