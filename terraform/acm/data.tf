data "aws_route53_zone" "naked" {
  name = var.domain_name
}