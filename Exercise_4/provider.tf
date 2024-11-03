# Bloque de proveedor para usar cuando se configuran las claves de Acceso y Secreta usando awscli
# Para principiantes: awscli es una herramienta de línea de comandos que permite configurar las credenciales de AWS de forma segura
# Para más información visita: https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html

# Este bloque define la configuración básica del proveedor de AWS
# El proveedor es el plugin que permite a Terraform comunicarse con AWS
provider "aws" {
  # Especifica la región de AWS donde se crearán los recursos
  # La región se obtiene de una variable llamada AWS_REGION
  region = var.AWS_REGION
}

# Bloque de proveedor alternativo para cuando necesitas declarar las claves de Acceso y Secreta explícitamente
# ADVERTENCIA - NO COMETAS EL ERROR DE SUBIR ESTAS CLAVES AL REPOSITORIO
# Este método no es recomendado para producción por razones de seguridad

# Configuración del Proveedor AWS
# Este bloque está comentado porque es un ejemplo de cómo configurar las credenciales manualmente
# Solo descomenta este bloque si realmente necesitas especificar las credenciales de esta manera
# ----------------------------------

# provider "aws" {
#   # La región de AWS donde se crearán los recursos
#   region     = "${var.AWS_REGION}"
#   # Tu clave de acceso de AWS - MANTÉN ESTO SEGURO
#   access_key = "${var.AWS_ACCESS_KEY}"
#   # Tu clave secreta de AWS - MANTÉN ESTO SEGURO
#   secret_key = "${var.AWS_SECRET_KEY}"
# }
