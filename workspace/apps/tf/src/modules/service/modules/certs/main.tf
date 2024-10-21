data "aws_route53_zone" "defcon" {
  provider = aws.management
  name     = var.domainname
}

resource "aws_acm_certificate" "service" {
  provider                  = aws.app
  domain_name               = var.hostname
  validation_method         = "DNS"
  subject_alternative_names = ["${var.service_hostname}","*.${var.service_hostname}"]
  lifecycle {
    create_before_destroy = true
  }
  tags = var.cert_tags
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.management

  for_each = {
    for dvo in aws_acm_certificate.service.domain_validation_options : "${dvo.domain_name}_validation_record" => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.defcon.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  allow_overwrite = true
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws.app
  certificate_arn         = aws_acm_certificate.service.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
