terraform {
  backend "s3" {
    bucket         = "idurar-erp-crm-s3-bucket"
    key            = "ec2-instance/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "idurar-erp-crm-dynamo-db"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}