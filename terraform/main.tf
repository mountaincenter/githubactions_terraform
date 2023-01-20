module "acm_cloudfront" {
  domain_name = var.domain_name
  source      = "./acm"
  fqdn_name   = local.fqdn.web_name
  providers = {
    aws = aws.virginia
  }
}

module "s3" {
  source          = "./s3"
  fqdn_name       = local.fqdn.web_name
  bucket_name     = local.bucket.name
  aws_region      = var.aws_region
  certificate_arn = module.acm_cloudfront.api_acm_id
}