//TODO: Pass this as a variable
data "aws_route53_zone" "defcon" {
  provider = aws.management
  name     = var.domainname
}
//TODO: Pass this as a variable
data "aws_caller_identity" "current" {
  provider = aws.app
}

resource "aws_lb" "lb_public" {
  name                       = replace("publicfacing-${var.label}", "_", "-")
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sshhttps.id, aws_security_group.http_only.id]
  subnets                    = aws_subnet.public_subnet.*.id
  enable_deletion_protection = var.enable_lb_delete_protection
  provider                   = aws.app
  drop_invalid_header_fields = true

  access_logs {
    bucket  = aws_s3_bucket.alb_log_bucket.id
    prefix  = "access"
    enabled = true
  }
  connection_logs {
    bucket  = aws_s3_bucket.alb_log_bucket.id
    prefix  = "connection"
    enabled = true
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb_public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn
  provider          = aws.app
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
  tags = var.network_tags
}

## We use Cloudfront on an S3 bucket
# resource "aws_route53_record" "hostname" {
#   zone_id = data.aws_route53_zone.defcon.zone_id
#   name    = data.aws_route53_zone.defcon.name
#   type    = "A"
#
#   alias {
#     name                   = aws_lb.lb_public.dns_name
#     zone_id                = aws_lb.lb_public.zone_id
#     evaluate_target_health = true
#   }
#   //allow_overwrite = true
#   provider = aws.management
# }

resource "aws_s3_bucket" "alb_log_bucket" {
  bucket        = "${var.domainname}-lb-logs-20240508"
  provider      = aws.app
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_log_bucket_encryption" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  provider = aws.app
}

resource "aws_s3_bucket_policy" "alb_log_bucket_bucket_policy" {
  bucket   = aws_s3_bucket.alb_log_bucket.id
  provider = aws.app

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::127311923021:root"
        },
        "Action" : "s3:PutObject",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.alb_log_bucket.bucket}/access/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
          "arn:aws:s3:::${aws_s3_bucket.alb_log_bucket.bucket}/connection/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        ]
      }
    ]
  })
}
