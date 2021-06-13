data "aws_route53_zone" "zone" {
  name         = var.domain
  private_zone = false
}

resource "aws_acm_certificate" "validation" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.zone.zone_id
  type = "A"
  name = var.domain
  alias {
    name = aws_cloudfront_distribution.frontend.domain_name
    zone_id = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "validation" {
  for_each = {
    for validation in aws_acm_certificate.validation.domain_validation_options : validation.domain_name => {
      name   = validation.resource_record_name
      record = validation.resource_record_value
      type   = validation.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.validation.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}