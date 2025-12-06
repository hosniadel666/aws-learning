terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.data_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object" "sample_data" {
  for_each = { for f in fileset("${path.module}/sample_data", "*") : f => f }

  bucket = aws_s3_bucket.data_bucket.id
  key    = each.value
  source = "${path.module}/sample_data/${each.value}"

  # Optional: re-upload if file changes
  etag = filemd5("${path.module}/sample_data/${each.value}")

  depends_on = [aws_s3_bucket.data_bucket]
}

