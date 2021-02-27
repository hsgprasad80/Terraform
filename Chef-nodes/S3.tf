# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "887791561963-tfstate-storage"

  force_destroy = true

  versioning {
    enabled    = true
    mfa_delete = false
  }

  lifecycle {
    /* in production this needs to be true */
    prevent_destroy = false
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}
