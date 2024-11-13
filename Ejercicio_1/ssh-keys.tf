# ADVERTENCIA: La clave privada generada por este recurso se almacenará sin cifrar en tu archivo de estado de Terraform.
# No se recomienda usar este recurso para despliegues en producción. En su lugar, genera un archivo de clave privada 
# fuera de Terraform y distribúyelo de forma segura al sistema donde se ejecutará Terraform.
# Ver: https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key

# Este recurso genera un par de claves SSH usando el algoritmo RSA
# Es importante para acceder de forma segura a las instancias EC2 que crearemos
resource "tls_private_key" "ssh-key" {
  # Especificamos RSA como el algoritmo de cifrado para la clave
  algorithm = "RSA"
  # Definimos el tamaño de la clave en bits - 4096 proporciona un alto nivel de seguridad
  rsa_bits = 4096
}

# Este recurso crea un par de claves en AWS usando la clave pública generada anteriormente
resource "aws_key_pair" "key_pair" {
  # Generamos un nombre único para la clave usando una cadena aleatoria
  key_name = "SSH-Key-${random_string.resource_code.result}"
  # Usamos la clave pública generada en formato OpenSSH
  public_key = tls_private_key.ssh-key.public_key_openssh
}

# Este recurso guarda la clave privada en un archivo local con extensión .pem
resource "local_file" "ssh_key" {
  # El nombre del archivo será el mismo que el par de claves en AWS con extensión .pem
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  # Guardamos la clave privada en formato PEM
  content = tls_private_key.ssh-key.private_key_pem
  # Establecemos permisos 0600 (solo lectura/escritura para el propietario) por seguridad
  file_permission = "0600"
}

# Este recurso guarda la clave pública en un archivo local con extensión .pub
resource "local_file" "ssh_key_pub" {
  # El nombre del archivo será el mismo que el par de claves en AWS con extensión .pub
  filename = "${aws_key_pair.key_pair.key_name}.pub"
  # Guardamos la clave pública en formato OpenSSH
  content = tls_private_key.ssh-key.public_key_openssh
  # Establecemos permisos 0600 (solo lectura/escritura para el propietario) por seguridad
  file_permission = "0600"
}