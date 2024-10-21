
resource "aws_acm_certificate" "cert" {
  provider                  = aws.app
  domain_name               = var.domainname
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domainname}", "*.cms.${var.domainname}" ]
  lifecycle {
    create_before_destroy = true
  }
  tags = var.network_tags
}

resource "aws_route53_record" "validation" {
  provider = aws.management

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : "${dvo.domain_name}_validation_record" => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id         = data.aws_route53_zone.defcon.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  allow_overwrite = true
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.app
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}