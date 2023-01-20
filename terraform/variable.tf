variable "domain_name" {}
variable "aws_region" {}
variable "bucket_prefix" {}

locals {
  name_prefix = "test-"
  fqdn = {
    web_name = "web.${var.domain_name}"
  }
  bucket = {
    name = local.fqdn.web_name
  }
}