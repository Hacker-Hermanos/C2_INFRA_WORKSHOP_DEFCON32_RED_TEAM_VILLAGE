output "<REDIRECTOR_DOMAIN_TLD>_cdn_1_CDN_ID" {
  value = aws_cloudfront_distribution.<REDIRECTOR_DOMAIN_TLD>_cdn_1.id
}
output "<REDIRECTOR_DOMAIN_TLD>_cdn_1_URL" {
  value = aws_cloudfront_distribution.<REDIRECTOR_DOMAIN_TLD>_cdn_1.domain_name
}