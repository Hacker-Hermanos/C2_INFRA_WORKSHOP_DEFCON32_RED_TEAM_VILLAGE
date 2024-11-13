# Definición del grupo de seguridad para el servidor C2 TeamServer
# Un grupo de seguridad actúa como un firewall virtual que controla el tráfico entrante y saliente
resource "aws_security_group" "C2_TeamServer_SG" {
  # Nombre descriptivo del grupo de seguridad que incluye el año, mes y tipo de operación
  name = "C2 TeamServer Security Groups for YYYY-MO-OPERATION_NAME-OPERATION_TYPE"
  # Asociamos el grupo de seguridad con nuestra VPC creada anteriormente
  vpc_id = aws_vpc.prod-vpc.id
  # Etiquetas para identificar el propósito de las reglas (en este caso VPN)
  tags = {
    VPN = "for Tailscale VPN 1194/tcp-udp"
  }
  # Regla de entrada para permitir conexiones TCP en el puerto 1194 (usado por Tailscale VPN)
  # desde cualquier dirección IP (0.0.0.0/0)
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Regla de entrada para permitir conexiones UDP en el puerto 1194 (usado por Tailscale VPN)
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Regla de entrada que permite todo el tráfico (-1 significa todos los protocolos)
  # pero solo desde las IPs específicas definidas en la variable allowlist_cidr
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_cidr]
  }
  # Regla de salida que permite todo el tráfico hacia Internet
  # El 0.0.0.0/0 en egress permite conexiones salientes a cualquier destino
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_open_inet]
  }
}

# Definición del grupo de seguridad para el servidor Redirector
# El redirector actúa como intermediario entre Internet y el servidor C2
resource "aws_security_group" "C2_Redirector_SG" {
  # Nombre descriptivo para el grupo de seguridad del redirector
  name = "C2 Redirectors Security Groups for YYYY-MO-OPERATION_NAME-OPERATION_TYPE"
  # Asociamos el grupo de seguridad con nuestra VPC
  vpc_id = aws_vpc.prod-vpc.id
  # Etiquetas que describen los servicios permitidos: VPN, DNS y HTTP/HTTPS
  tags = {
    VPN    = "for Tailscale VPN 1194/tcp-udp"
    DNS    = "for C2 DNS listener 53/udp"
    HTTP_S = "for C2 http and https listeners 80, 443/tcp"
  }
  # Regla para permitir conexiones TCP de Tailscale VPN
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = [var.allowlist_open_inet]
  }
  # Regla para permitir conexiones UDP de Tailscale VPN
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = [var.allowlist_open_inet]
  }
  # Regla para permitir tráfico DNS (puerto 53 UDP)
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.allowlist_open_inet]
  }
  # Regla para permitir tráfico HTTPS (puerto 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowlist_open_inet, var.allowlist_cidr]
  }
  # Regla para permitir tráfico HTTP (puerto 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowlist_open_inet, var.allowlist_cidr]
  }
  # Regla que permite todo el tráfico desde las IPs en allowlist_cidr
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_cidr]
  }
  # Regla que permite todo el tráfico saliente hacia Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_open_inet]
  }
}
