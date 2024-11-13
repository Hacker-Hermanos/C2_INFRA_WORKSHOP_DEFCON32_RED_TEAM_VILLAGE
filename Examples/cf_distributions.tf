# This resource creates a CloudFront distribution, which is a content delivery network (CDN) service from AWS
# The resource name is based on the redirector's domain
resource "aws_cloudfront_distribution" "test_robertepimentel_com_cdn_1" {
  # Enables the CloudFront distribution
  enabled = true

  # Configures the origin of the content that CloudFront will distribute
  origin {
    # The domain name of the origin server (redirector)
    domain_name = "test.robertepimentel.com"
    # A unique identifier for this origin
    origin_id = "test.robertepimentel.com"

    # Custom configuration for the origin
    custom_origin_config {
      # Keep at 80 if the HTTP redirector listens on this port and allows incoming traffic
      http_port = 80
      # Keep at 443 if the HTTPS redirector listens on this port and allows incoming traffic
      https_port = 443
      # Defines how CloudFront communicates with the origin - match-viewer makes it use the same protocol as the visitor
      origin_protocol_policy = "match-viewer"
      # SSL/TLS versions allowed for communication with the origin
      origin_ssl_protocols = ["TLSv1.1"]
    }
  }

  # Configures the default cache behavior
  default_cache_behavior {
    # HTTP methods allowed for requests
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    # HTTP methods that will be cached
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    # Must match the origin_id defined above
    target_origin_id = "test.robertepimentel.com"

    # Configures what values are forwarded to the origin
    forwarded_values {
      # Forwards query parameters to the origin
      query_string = true
      # Configuration for cookie handling
      cookies {
        # Forwards all cookies to the origin
        forward = "all"
      }
      # Specific HTTP headers that will be forwarded to the origin
      headers = ["Authorization", "User-Agent", "Hacker-Hermanos-Rocks"]
    }

    # Protocol policy for visitors - allows both HTTP and HTTPS
    viewer_protocol_policy = "allow-all"
    # Cache lifetime settings (in seconds)
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
    # Disables content compression
    compress = false
  }

  # Price class that determines in which AWS regions the content will be distributed
  price_class = "PriceClass_100"

  # Configures geographic restrictions
  restrictions {
    geo_restriction {
      # Only allows access from specific locations
      restriction_type = "whitelist"
      # List of allowed countries (using country codes)
      locations = ["US"]
    }
  }

  # SSL/TLS certificate configuration
  viewer_certificate {
    # Uses CloudFront's default certificate
    cloudfront_default_certificate = true
  }

  # HTTP protocol version to use
  http_version = "http2"
  # Disables support for IPv6
  is_ipv6_enabled = false

  # Description of the CloudFront distribution
  comment = "CF Distribution to test.robertepimentel.com for 2024-NOV-ITPR-OP"
}
