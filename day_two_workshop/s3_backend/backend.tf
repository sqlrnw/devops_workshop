provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "task2-s3bucket-123"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
