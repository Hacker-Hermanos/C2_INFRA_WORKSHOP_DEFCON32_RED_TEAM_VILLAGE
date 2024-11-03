# Bloque del proveedor AWS para usar cuando configuras las claves de Acceso y Secreta usando awscli
# Para principiantes: Este bloque define cómo Terraform se conectará a AWS usando las credenciales 
# que configuraste previamente con el comando 'aws configure'
# Para más información visita: https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html

# Este bloque 'provider' es la configuración más básica y segura para conectar con AWS
# Solo necesita la región donde desplegaremos nuestros recursos
provider "aws" {
  # La región de AWS donde se crearán todos los recursos
  # El valor se obtiene de una variable llamada AWS_REGION definida en otro archivo
  region = var.AWS_REGION
}

# Bloque alternativo del proveedor AWS para cuando necesitas declarar las claves explícitamente
# ADVERTENCIA - NO SUBAS ESTAS CLAVES AL REPOSITORIO
# Para principiantes: Esta es una forma alternativa pero menos segura de configurar AWS
# ya que expone tus credenciales directamente en el código

# Configuración del Proveedor AWS
# Este bloque está comentado por seguridad
# ----------------------------------

# provider "aws" {
#   # La región de AWS donde se crearán los recursos
#   region     = "${var.AWS_REGION}"
#   # Tu clave de acceso de AWS (¡nunca la subas a un repositorio!)
#   access_key = "${var.AWS_ACCESS_KEY}"
#   # Tu clave secreta de AWS (¡nunca la subas a un repositorio!)
#   secret_key = "${var.AWS_SECRET_KEY}"
# }
