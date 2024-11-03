# Este bloque de output define una salida que mostrará el ID único de la distribución CloudFront
# Los outputs son valores que Terraform mostrará después de crear la infraestructura
# Son útiles para obtener información importante sobre los recursos creados
output "<REDIRECTOR_DOMAIN_TLD>_cdn_1_CDN_ID" {
  # El valor será el ID de la distribución CloudFront que creamos
  # Usamos la referencia al recurso aws_cloudfront_distribution seguido de .id para obtener su identificador
  value = aws_cloudfront_distribution.<REDIRECTOR_DOMAIN_TLD>_cdn_1.id
}

# Este bloque de output define una salida que mostrará el nombre de dominio de la distribución CloudFront
# Este dominio es el que usaremos para acceder al contenido distribuido por CloudFront
output "<REDIRECTOR_DOMAIN_TLD>_cdn_1_URL" {
  # El valor será el nombre de dominio asignado por CloudFront a esta distribución
  # Este dominio terminará en cloudfront.net y es generado automáticamente por AWS
  value = aws_cloudfront_distribution.<REDIRECTOR_DOMAIN_TLD>_cdn_1.domain_name
}