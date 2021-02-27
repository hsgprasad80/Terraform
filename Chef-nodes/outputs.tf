# output values

output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform-state-storage-s3.id
  description = "The NAME of the S3 bucket"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform-state-storage-s3.arn
  description = "The ARN of the S3 bucket"
}

output "s3_bucket_region" {
  value       = aws_s3_bucket.terraform-state-storage-s3.region
  description = "The REGION of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.dynamodb-terraform-state-lock.name
  description = "The ARN of the DynamoDB table"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.dynamodb-terraform-state-lock.arn
  description = "The ARN of the DynamoDB table"
}
output "private_ip" {
  value       = aws_instance.Chef-node.*.private_ip
  description = "The private IP address of the chef nodes"
}
output "public_dns" {
  value       = aws_instance.Chef-node.*.public_dns
  description = "The public dns of chef nodes"
}