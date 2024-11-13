### Región del Proveedor AWS
# Esta variable define la región de AWS donde se desplegarán todos los recursos
# Para principiantes: La región es una ubicación geográfica donde AWS tiene sus centros de datos
variable "AWS_REGION" {
  # 'type = string' indica que esta variable debe ser texto
  type = string
  # 'default' establece el valor predeterminado como la región este de EE.UU.
  default = "us-east-1"
}

### Claves de Acceso y Secreta de AWS
# IMPORTANTE: Estas variables son sensibles y no deberían tener valores por defecto en producción
# Para principiantes: Estas son las credenciales que AWS usa para autenticar tus solicitudes

variable "AWS_ACCESS_KEY" {
  type    = string
  default = "AKIXXXXXXXXX"
}

variable "AWS_SECRET_KEY" {
  type    = string
  default = "M5XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

### ID de AMI para Instancia EC2
# AMI (Amazon Machine Image) es una plantilla que contiene el sistema operativo y software preconfigurado
variable "use1_ami_kali_234" {
  type    = string
  default = "ami-061b17d332829ab1c"
  # Para Kali AMI Alias: /aws/service/marketplace/prod-tsqyof4l3a3aa/kali-linux-2023.2 en https://aws.amazon.com/marketplace/pp/prodview-fznsw3f7mq7to
  # Para Ubuntu: ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230216 - ami-01fb4901e7405cd3d - us-west-1 (N. California) en https://cloud-images.ubuntu.com/locator/ec2/
}

### Tamaño del Volumen de la Instancia EC2 en GB
# Esta variable define el tamaño del disco duro virtual para el servidor redirector
variable "volume_size_C2_redirector" {
  type    = string
  default = "32" # Tamaño del disco en GB para el redirector C2
}

### Tamaño del Volumen de la Instancia EC2 en GB
# Esta variable define el tamaño del disco duro virtual para el servidor principal
variable "volume_size_C2_teamserver" {
  type    = string
  default = "64" # Tamaño del disco en GB para el servidor C2
}

### Tipo de Instancia EC2 de AWS 
# Para principiantes: El tipo de instancia determina los recursos de hardware (CPU, RAM, etc.)
# Visita https://aws.amazon.com/ec2/instance-types/ para más información
variable "instance_type_C2_redirector" {
  type    = string
  default = "i3.large" # https://aws.amazon.com/ec2/instance-types/i3/ - 4 vCPU, 16GB RAM, 10GBPs Red
}

### Tipo de Instancia EC2 de AWS
variable "instance_type_C2_server" {
  type    = string
  default = "i3.large" # https://aws.amazon.com/ec2/instance-types/i3/ - 4 vCPU, 16GB RAM, 10GBPs Red
}

# Lista de IPs privadas para las instancias del servidor de equipo C2
variable "list_private_ips_C2_teamservers" {
  description = "Lista de IPs Privadas para las instancias del Servidor de Equipo C2"
  type        = list(string)
  default = [
    "172.31.16.80"
  ]
}

### IP Privada de EC2 de AWS "IPv4"
# Asegúrate de que existe en la subred antes de ejecutar terraform
variable "list_private_ips_C2_Redirectors" {
  description = "Lista de IPs Privadas para las instancias del Redirector C2"
  type        = list(string)
  default = [
    "172.31.16.82",
    "172.31.16.83"
  ]
}

# Variable de Zona de Disponibilidad
# La zona de disponibilidad es una ubicación física dentro de una región de AWS
variable "AVAILABILITY_ZONE" {
  description = "La zona de disponibilidad de AWS"
  type        = string
  default     = "us-east-1a" # Puedes establecer un valor predeterminado o eliminar esta línea para requerir una asignación explícita

  # Esta validación asegura que solo se usen zonas de disponibilidad válidas
  validation {
    condition     = contains(["us-east-1a", "us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"], var.AVAILABILITY_ZONE)
    error_message = "La zona de disponibilidad debe ser una de: us-west-2a, us-west-2b, us-west-2c, us-west-2d."
  }
}

# Definición de Recursos
# Estos recursos generan cadenas aleatorias para usar como identificadores únicos
resource "random_string" "random1" {
  length           = 16
  special          = true
  override_special = "_+"
}

resource "random_string" "resource_code" {
  length  = 10
  special = false
  upper   = false
}

# Variable para permitir acceso desde Internet
variable "allowlist_open_inet" {
  type    = string
  default = "0.0.0.0/0" # IP de origen (permite todo el tráfico de Internet)
}

# Variable para permitir acceso desde una IP específica
variable "allowlist_cidr" {
  type    = string
  default = "X.X.X.X/32" # IP de origen específica
}
## Variable para permitir acceso desde una IP específica
#variable "allowlist_cidr" {
#  type    = string
#  default = "139.60.187.197/32" # IP de origen específica
#}

# # Variable para permitir acceso desde una IP específica
# variable "allowlist_cidr" {
#   type    = string
#   default = "173.215.0.0/16" # IP de origen específica
# }

# Variable para la contraseña de elevación de privilegios en Ansible
variable "ansible_become" {
  description = "Contraseña de Kali para Ansible Become"
  type        = string
  default     = "kali"
}

# Variable para el usuario de Ansible en Ubuntu
variable "ubuntu_ansible_become_user" {
  description = "Usuario de Ansible Become - usuario con privilegios bajos del SO"
  type        = string
  default     = "ubuntu"
}

# Variable para el usuario de Ansible en Kali
variable "kali_ansible_become_user" {
  description = "Usuario de Ansible Become - usuario con privilegios bajos del SO"
  type        = string
  default     = "kali"
}
