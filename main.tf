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

# Upload sample data
resource "aws_s3_object" "sample_data" {
  for_each = fileset("${path.module}/sample_data", "*")

  bucket = aws_s3_bucket.data_bucket.id
  key    = each.value
  source = "${path.module}/sample_data/${each.value}"
}

