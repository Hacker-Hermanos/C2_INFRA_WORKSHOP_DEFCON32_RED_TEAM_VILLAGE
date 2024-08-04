resource "aws_cloudfront_distribution" "<REDIRECTOR_DOMAIN_TLD>_cdn_1" {
  enabled = true
  origin {
    domain_name = "<REDIRECTOR_DOMAIN.TLD>"
    origin_id   = "<REDIRECTOR_DOMAIN.TLD>"
    custom_origin_config {
      http_port              = 80  # Leave at "80" if HTTP redirector is listening on this port and allows ingress traffic on this port
      https_port             = 443 # Leave at "443" if HTTPS redirector is listening on this port and allows ingress traffic on this port
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.1"]
    }
  }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "<REDIRECTOR_DOMAIN.TLD>"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["Authorization", "User-Agent", "Hacker-Hermanos-Rocks"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = false
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  http_version    = "http2"
  is_ipv6_enabled = false

  # Add a meaningful description
  comment = "CF Distribution to <REDIRECTOR_DOMAIN.TLD> for <OPERATIONYEAR-MONTH-OPERATIONNAME-OPERATIONTYPE>"
}