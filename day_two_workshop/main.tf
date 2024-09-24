provider "aws" {
  region = "us-east-1"
}

variable "Environment" {}
variable "owner" {}


resource "aws_s3_bucket" "task2_s3bucket" {
  bucket              = "task2-s3bucket-123"
  force_destroy       = true
  object_lock_enabled = false

  tags = {
    Name        = "task2_s3bucket"
    Environment = var.Environment
    owner       = var.owner
  }
}

resource "aws_s3_bucket_versioning" "task2_versioning" {
  bucket = aws_s3_bucket.task2_s3bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "task2_object" {
  bucket = aws_s3_bucket.task2_s3bucket.id
  key    = "logs/"
}
data "aws_iam_user" "task2_iam_user" {
  user_name = "MORAGAP"
}


data "aws_iam_policy_document" "upload_object_to_logs" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_user.task2_iam_user.arn]
    }

    actions = [
      "s3:GetObject"
      , "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.task2_s3bucket.arn,
      "${aws_s3_bucket.task2_s3bucket.arn}/logs/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.task2_s3bucket.id
  policy = data.aws_iam_policy_document.upload_object_to_logs.json
}

