### Región del Proveedor AWS
# Este bloque define una variable que especifica la región de AWS donde se crearán los recursos
# Para principiantes: Una región de AWS es una ubicación geográfica donde AWS tiene centros de datos
# Por ejemplo, us-east-1 está ubicada en Virginia del Norte, Estados Unidos

# Declaramos una variable llamada "AWS_REGION" que almacenará la región de AWS
variable "AWS_REGION" {
  # El tipo "string" indica que esta variable debe contener texto
  # Para principiantes: Los tipos de variables ayudan a Terraform a validar los valores
  type = string
  # El valor predeterminado es "us-east-1" si no se especifica otro
  # Este es uno de los centros de datos más comunes y económicos de AWS
  default = "us-east-1"
}
