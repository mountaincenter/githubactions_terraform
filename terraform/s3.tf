resource "aws_s3_bucket" "static_website" {
  bucket_prefix = "static-website"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.static_website.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "index.html"
  source       = "../index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.allow_cloudfront_service_principal_s3_readonly.json
}

data "aws_iam_policy_document" "allow_cloudfront_service_principal_s3_readonly" {
  statement {
    sid     = "AllowCloudFrontServicePrincipalReadOnly"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.static_website.arn]
    }

    resources = ["${aws_s3_bucket.static_website.arn}/*"]
  }
}