# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-yuma-ito-bd-pragmatic-terraform"
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_lifecycle_configuration
resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id     = "expire-after-180-days"
    status = "Enabled"
    expiration {
      days = 180
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
resource "aws_s3_bucket_versioning" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  versioning_configuration {
    status = "Enabled"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_server_side_encryption_configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.alb_log.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"] # Asia Pacific (Tokyo)のELBのAWSアカウントID
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.77.0/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}
