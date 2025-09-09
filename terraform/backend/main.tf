provider "aws" {
  region = var.aws_region
}

# S3 bucket to store remote Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = var.s3_bucket_name

  tags = {
    Name = var.s3_bucket_name
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = var.dynamodb_table_name
  }
}