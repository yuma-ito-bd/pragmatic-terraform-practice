# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket
resource "aws_s3_bucket" "public" {
  bucket = "public-makoto-pragmatic-terraform"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
resource "aws_s3_bucket_acl" "public" {
  bucket = aws_s3_bucket.public.id

  acl = "public-read"
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_cors_configuration
resource "aws_s3_bucket_cors_configuration" "public" {
  bucket = aws_s3_bucket.public.id

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
resource "aws_s3_bucket_versioning" "public" {
  bucket = aws_s3_bucket.public.id
  versioning_configuration {
    status = "Enabled"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_server_side_encryption_configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "public" {
  bucket = aws_s3_bucket.public.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.private.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
