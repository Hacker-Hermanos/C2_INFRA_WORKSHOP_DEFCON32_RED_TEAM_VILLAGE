resource "aws_security_group" "C2_TeamServer_SG" {
  name   = "C2 TeamServer Security Groups for YYYY-MO-OPERATION_NAME-OPERATION_TYPE"
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    VPN = "for Tailscale VPN 1194/tcp-udp"
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_open_inet]
  }
}

resource "aws_security_group" "C2_Redirector_SG" {
  name   = "C2 Redirectors Security Groups for YYYY-MO-OPERATION_NAME-OPERATION_TYPE"
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    VPN    = "for Tailscale VPN 1194/tcp-udp"
    DNS    = "for C2 DNS listener 53/udp"
    HTTP_S = "for C2 http and https listeners 80, 443/tcp"
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = [var.allowlist_open_inet]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = [var.allowlist_open_inet]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.allowlist_open_inet]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowlist_open_inet, var.allowlist_cidr]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowlist_open_inet, var.allowlist_cidr]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowlist_open_inet]
  }
}
