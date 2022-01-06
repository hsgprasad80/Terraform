provider "aws" {
  region  = "us-east-1"
  profile = "guru"
  shared_credentials_file = "~/.aws/credentials"
}

module "web_cluster" {
  source = "/Users/guruprasad/desktop/terraform/modules/services/web-cluster"

  cluster_name           = "webserver_prod"
  db_remote_state_bucket = "terraform-bkend-guru16"
  web_remote_state_lock  = "terraform-locks-guru16"
  web_remote_state_key   = "prod/data-store/mysql/terraform-tfstate"
  db_remote_state_key    = "prod/data-store/mysql/terraform-tfstate"

  instance_type = "t2.medium"
  ami           = "ami-042e8287309f5df03"
  server_text   = "New Server Text"
  max_size      = 4
  min_size      = 1
  desired_size  = 2
  enable_autoscaling = true
  give_neo_cloudwatch_full_acess = true

  custom_tags = {
    owner      = "team-foo"
    DeployedBy = "terraform"
  }
}
