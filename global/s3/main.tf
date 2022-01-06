provider "aws" {
  region   = "us-east-1"
  profile  = "guru"
  shared_credentials_file = "~/.aws/credentials"
  
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-bkend-guru16"

  #prevent accidental deletion of bucket
  lifecycle {
    prevent_destroy = true
  }
  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-guru16"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
  }
}
