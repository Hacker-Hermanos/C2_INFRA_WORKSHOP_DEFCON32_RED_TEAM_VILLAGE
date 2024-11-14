# Este recurso crea una distribución de CloudFront, que es un servicio de entrega de contenido (CDN) de AWS
# El nombre del recurso se basa en el dominio del redirector
resource "aws_cloudfront_distribution" "<REDIRECTOR_DOMAIN_TLD>_cdn_1" {
  # Habilita la distribución de CloudFront
  enabled = true
  
  # Configura el origen del contenido que CloudFront distribuirá
  origin {
    # El nombre de dominio del servidor de origen (redirector)
    domain_name = "<REDIRECTOR_DOMAIN.TLD>"
    # Un identificador único para este origen
    origin_id   = "<REDIRECTOR_DOMAIN.TLD>"
    
    # Configuración personalizada para el origen
    custom_origin_config {
      # Mantener en 80 si el redirector HTTP escucha en este puerto y permite tráfico entrante
      http_port              = 80
      # Mantener en 443 si el redirector HTTPS escucha en este puerto y permite tráfico entrante  
      https_port             = 443
      # Define cómo CloudFront se comunica con el origen - match-viewer hace que use el mismo protocolo que el visitante
      origin_protocol_policy = "match-viewer"
      # Versiones de SSL/TLS permitidas para la comunicación con el origen
      origin_ssl_protocols   = ["TLSv1.1"]
    }
  }

  # Configura el comportamiento predeterminado del caché
  default_cache_behavior {
    # Métodos HTTP permitidos para las solicitudes
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    # Métodos HTTP que serán cacheados
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    # Debe coincidir con el origin_id definido arriba
    target_origin_id = "<REDIRECTOR_DOMAIN.TLD>"

    # Configura qué valores se reenvían al origen
    forwarded_values {
      # Reenvía los parámetros de consulta al origen
      query_string = true
      # Configuración para el manejo de cookies
      cookies {
        # Reenvía todas las cookies al origen
        forward = "all"
      }
      # Cabeceras HTTP específicas que se reenviarán al origen
      headers = ["Authorization", "User-Agent", "Hacker-Hermanos-Rocks"]
    }

    # Política de protocolo para los visitantes - permite tanto HTTP como HTTPS
    viewer_protocol_policy = "allow-all"
    # Configuración de tiempos de vida del caché (en segundos)
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    # Desactiva la compresión del contenido
    compress               = false
  }

  # Clase de precio que determina en qué regiones de AWS se distribuirá el contenido
  price_class = "PriceClass_100"

  # Configura restricciones geográficas
  restrictions {
    geo_restriction {
      # Solo permite acceso desde ubicaciones específicas
      restriction_type = "whitelist"
      # Lista de países permitidos (usando códigos de país) en formato ISO 3166-1 alpha-2 (https://www.iso.org/obp/ui/#search
      locations = ["PR"]
    }
  }

  # Configuración del certificado SSL/TLS
  viewer_certificate {
    # Usa el certificado predeterminado de CloudFront
    cloudfront_default_certificate = true
  }

  # Versión del protocolo HTTP a utilizar
  http_version    = "http2"
  # Desactiva el soporte para IPv6
  is_ipv6_enabled = false

  # Descripción de la distribución de CloudFront
  comment = "CF Distribution a <REDIRECTOR_DOMAIN.TLD> para <OPERATIONYEAR-MONTH-OPERATIONNAME-OPERATIONTYPE>"
}
