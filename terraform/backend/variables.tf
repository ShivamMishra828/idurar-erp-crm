variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "ap-south-1"
}

variable "s3_bucket_name" {
  description = "Unique S3 bucket name for Terraform remote state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "terraform_locks"
}