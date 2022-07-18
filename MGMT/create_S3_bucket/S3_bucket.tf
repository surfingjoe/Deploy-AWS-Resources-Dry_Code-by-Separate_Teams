provider "aws" {
  region = "<your_region>"
}
# ----- Create an S3 bucket for remote state ----------
resource "aws_s3_bucket" "terraform-state" {
  bucket = "<unique_name>-terraform-states"
  lifecycle { prevent_destroy = true }

  tags = {
    Name = "Remote State Bucket"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "Encryption" {
  bucket = aws_s3_bucket.terraform-state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}