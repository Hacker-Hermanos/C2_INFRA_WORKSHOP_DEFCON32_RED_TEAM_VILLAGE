# Este bloque define la configuración básica de Terraform
# Terraform es una herramienta que nos permite crear y administrar infraestructura como código
terraform {
  # Aquí especificamos los proveedores necesarios para trabajar con servicios específicos
  # Los proveedores son plugins que permiten a Terraform interactuar con diferentes plataformas cloud
  required_providers {
    # Configuramos el proveedor de AWS que nos permitirá crear recursos en Amazon Web Services
    aws = {
      # La fuente indica de dónde se descargará el proveedor
      source  = "hashicorp/aws"
      # La versión específica del proveedor que queremos usar
      # Es importante fijar una versión para evitar cambios inesperados
      version = "5.57.0"
    }
  }

  # Este bloque backend está comentado pero muestra cómo configurar el almacenamiento del estado en S3
  # El estado de Terraform guarda información sobre la infraestructura que has creado
  #  backend "s3" {
  #    # El nombre del bucket S3 donde se guardará el archivo de estado
  #    # Genera una cadena aleatoria en https://randomkeygen.com y conviértela a minúsculas en https://convertcase.net/
  #    bucket = "<YOUR_S3_BUCKET_FOR_TERRAFORM_STATE_FILE_GOES_HERE>"
  #    # La ruta dentro del bucket donde se guardará el archivo
  #    key    = "terraform-state-file-for-exercise-1"
  #    # La región de AWS donde está el bucket
  #    # Asegúrate de que el bucket exista en la región seleccionada antes de usar este backend
  #    region = "us-east-1"
  #  }
}
