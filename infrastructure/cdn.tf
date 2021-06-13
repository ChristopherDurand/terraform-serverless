resource "aws_s3_bucket" "frontend" {
  bucket = var.s3_bucket
  acl    = "private"

  tags = {
    Name = "My bucket"
  }

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset("../front-end/build/", "**")
  bucket = aws_s3_bucket.frontend.id
  key = each.value
  source = "../front-end/build/${each.value}"
  etag = filemd5("../front-end/build/${each.value}")
  content_type = lookup(var.mime_types,regex("\\.[^\\.]+$",each.value), null)
}

locals {
  s3_origin_id = "myS3Origin"
}
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "2",
        "Effect": "Allow",
        "Principal": {
          "AWS": "${aws_cloudfront_origin_access_identity.frontend.iam_arn}"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  }
  EOF
}


resource "aws_cloudfront_origin_access_identity" "frontend" {
  comment = "OAID for static origin"
}

resource "aws_cloudfront_distribution" "frontend" {
  aliases             = [var.domain]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = "BUCKET_ORIGIN"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = trimprefix(aws_apigatewayv2_api.backend.api_endpoint, "https://")
    origin_path = "/production"
    origin_id = "API_GATEWAY"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "BUCKET_ORIGIN"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 86400
    default_ttl            = 86400
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "API_GATEWAY"
    path_pattern = "/api/*"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 1
    default_ttl            = 1
    max_ttl                = 60
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.validation.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method = "sni-only"
  }

}
