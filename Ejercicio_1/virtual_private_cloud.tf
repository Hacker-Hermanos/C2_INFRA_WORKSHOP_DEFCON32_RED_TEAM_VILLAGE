# Creación de una VPC (Virtual Private Cloud)
# Una VPC es una red virtual aislada en la nube de AWS donde puedes lanzar tus recursos
# Es como crear tu propia red privada dentro de AWS
resource "aws_vpc" "prod-vpc" {
  # El bloque CIDR define el rango de direcciones IP disponibles para tu VPC
  # 172.31.0.0/16 permite aproximadamente 65,536 direcciones IP
  cidr_block           = "172.31.0.0/16"
  # Habilita el soporte DNS para resolver nombres de dominio dentro de la VPC
  enable_dns_support   = "true"
  # Permite que las instancias EC2 reciban nombres DNS públicos
  enable_dns_hostnames = "true"
  # Define cómo se asignan las instancias EC2 al hardware subyacente
  # "default" significa que múltiples clientes pueden compartir el mismo hardware
  instance_tenancy     = "default"

  # Etiquetas para identificar fácilmente la VPC
  tags = {
    Name = "VPC Predeterminada (prod-vpc)"
  }
}

# Crear un Internet Gateway (IGW)
# Un IGW es como un "router virtual" que permite que tu VPC se conecte a Internet
resource "aws_internet_gateway" "prod-igw" {
  # Asocia el IGW con nuestra VPC
  vpc_id = aws_vpc.prod-vpc.id

  # Etiqueta para identificar el IGW
  tags = {
    Name = "prod-igw"
  }
}

# Crear una subred pública
# Una subred es una porción de la VPC donde puedes colocar recursos como servidores
resource "aws_subnet" "prod-subnet-public-1" {
  # Asocia la subred con nuestra VPC
  vpc_id                  = aws_vpc.prod-vpc.id
  # Define el rango de IPs para esta subred
  cidr_block              = "172.31.0.0/16"
  # Hace que esta subred sea pública asignando IPs públicas automáticamente
  map_public_ip_on_launch = "true"
  # Define en qué zona de disponibilidad se creará la subred
  availability_zone       = var.AVAILABILITY_ZONE
  # Etiquetas para identificar la subred
  tags = {
    Name = "/16 subred en VPC Predeterminada (prod-subnet-public-1)"
  }
}

# Crear una tabla de rutas personalizada para subredes públicas
# Una tabla de rutas determina cómo se dirige el tráfico de red dentro de la VPC
resource "aws_route_table" "prod-public-crt" {
  # Asocia la tabla de rutas con nuestra VPC
  vpc_id = aws_vpc.prod-vpc.id
  # Define una ruta que permite el acceso a Internet
  route {
    # 0.0.0.0/0 significa "todo el tráfico de Internet"
    cidr_block = "0.0.0.0/0"
    # Dirige el tráfico a través de nuestro Internet Gateway
    gateway_id = aws_internet_gateway.prod-igw.id
  }

  # Etiqueta para identificar la tabla de rutas
  tags = {
    Name = "prod-public-crt"
  }
}

# Asociar la tabla de rutas con la subred pública
# Esta asociación permite que la subred use las rutas definidas en la tabla
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  # ID de la subred que queremos asociar
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  # ID de la tabla de rutas que queremos asociar
  route_table_id = aws_route_table.prod-public-crt.id
}
