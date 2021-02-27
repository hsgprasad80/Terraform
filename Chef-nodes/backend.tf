terraform {
  backend "s3" {
    bucket         = "887791561963-tfstate-storage"
    dynamodb_table = "887791561963-tfstate-dynamo"
    region         = "us-east-1"
    key            = "tfstates"
    profile        = "guru"
  }
}