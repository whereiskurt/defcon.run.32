resource "aws_s3_bucket" "asset-bucket" {
  bucket        = var.bucket_name
  provider      = aws.app
  force_destroy = true

}

resource "aws_s3_bucket_cors_configuration" "corsallow" {
  provider = aws.app
  bucket   = aws_s3_bucket.asset-bucket.bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://*.${var.domainname}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-s3-cloudfront"
  description                       = "OAC for accessing S3 from CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4" # Typically sigv4 for AWS services
  provider                          = aws.app
}

resource "aws_s3_bucket_policy" "oac_bucket_policy" {
  provider = aws.app
  bucket   = aws_s3_bucket.asset-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.asset-bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.s3_distribution.arn}"
          }
        }
      },
      {
        Sid    = "AllowECSAndIAMRoleAccess"
        Effect = "Allow"
        Principal = {
          AWS :[
            var.role_arn,
            "${aws_iam_user.s3-bucketuser.arn}"
          ]
        },
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ],
        Resource = [
          "${aws_s3_bucket.asset-bucket.arn}/*",
          "${aws_s3_bucket.asset-bucket.arn}"
        ]
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.asset-bucket.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.asset-bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.asset-bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  aliases = var.bucket_cnames # Add your custom domain names here

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn # Replace with your ACM certificate ARN
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021" ## "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags     = var.bucket_tags
  provider = aws.app
}

resource "aws_route53_record" "cname_aliases" {
  count   = length(var.bucket_cnames)
  zone_id = var.zone_id
  name    = element(var.bucket_cnames, count.index)
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  provider = aws.management
}

resource "aws_iam_user" "s3-bucketuser" {
  name     = "s3-bucketuser"
  provider = aws.app
}

resource "aws_iam_access_key" "s3-bucketuser-key" {
  user     = aws_iam_user.s3-bucketuser.name
  provider = aws.app
}

resource "aws_ssm_parameter" "access_key" {
  name     = "/${var.domainname}/${var.label}/s3/${aws_s3_bucket.asset-bucket.bucket}/access_key"
  type     = "String"
  value    = aws_iam_access_key.s3-bucketuser-key.id
  provider = aws.app
}
resource "aws_ssm_parameter" "secret_key" {
  name     = "/${var.domainname}/${var.label}/s3/${aws_s3_bucket.asset-bucket.bucket}/secret_key"
  type     = "SecureString"
  value    = aws_iam_access_key.s3-bucketuser-key.secret
  provider = aws.app
}
resource "aws_ssm_parameter" "bucketname" {
  name     = "/${var.domainname}/${var.label}/s3/bucketname"
  type     = "String"
  value    = aws_s3_bucket.asset-bucket.bucket
  provider = aws.app
}
resource "aws_ssm_parameter" "cdnurl" {
  name     = "/${var.domainname}/${var.label}/s3/cdnurl"
  type     = "String"
  value    = "https://${element(var.bucket_cnames, 0)}"
  provider = aws.app
}
resource "aws_ssm_parameter" "cdnroot" {
  name     = "/${var.domainname}/${var.label}/s3/cdnroot"
  type     = "String"
  value    = "None"
  provider = aws.app
}