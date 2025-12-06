variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

