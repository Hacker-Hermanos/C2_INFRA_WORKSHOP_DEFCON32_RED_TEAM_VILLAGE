# Este bloque 'terraform' es el bloque principal de configuración que define los requisitos básicos
# para ejecutar este código de Terraform
terraform {
  # El bloque 'required_providers' especifica qué proveedores de servicios necesitamos
  # y sus versiones específicas para este proyecto
  required_providers {
    # Configuramos AWS como nuestro proveedor principal
    # Un proveedor en Terraform es un plugin que permite interactuar con servicios como AWS
    aws = {
      # 'source' indica de dónde descargar el proveedor
      # hashicorp/aws significa que es el proveedor oficial de AWS mantenido por HashiCorp
      source = "hashicorp/aws"
      # 'version' especifica la versión exacta del proveedor que queremos usar
      # Esto es importante para mantener la consistencia y evitar problemas de compatibilidad
      version = "5.75.1"
    }
  }

  # Configuración del backend S3 (actualmente comentado)
  # Este bloque define dónde se almacenará el archivo de estado de Terraform
  #  backend "s3" {
  #    # El nombre del bucket debe ser único globalmente en AWS
  #    # Genera una cadena aleatoria en https://randomkeygen.com y conviértela a minúsculas en https://convertcase.net/
  #    bucket = "<AQUI_VA_TU_BUCKET_S3_PARA_EL_ARCHIVO_DE_ESTADO_DE_TERRAFORM>"
  #    
  #    # La ruta donde se guardará el archivo de estado dentro del bucket
  #    key    = "terraform-state-file-for-exercise-1"
  #    
  #    # La región de AWS donde se encuentra el bucket
  #    # IMPORTANTE: Asegúrate de que el bucket exista en la región seleccionada antes de descomentar este bloque
  #    # Pendiente: Reemplazar este valor con una referencia al archivo variables.tf
  #    region = "us-east-1"
  #  }
}
