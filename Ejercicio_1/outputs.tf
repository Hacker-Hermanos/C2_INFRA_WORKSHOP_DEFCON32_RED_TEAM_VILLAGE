# Este bloque 'output' define una salida que mostrará la dirección IP pública del servidor C2
# Los bloques 'output' en Terraform son muy útiles para mostrar información importante después de crear la infraestructura
output "C2_TeamServer_IPv4" {
  # 'value' especifica qué información queremos mostrar
  # En este caso, obtenemos la IP pública de la IP elástica (EIP) asignada al servidor C2
  # Usamos '*.public_ip' porque estamos trabajando con múltiples instancias (definidas con count)
  # El asterisco (*) nos permite acceder a todas las IPs públicas de las instancias creadas
  value = aws_eip.C2_TeamServer_eip.*.public_ip
}

# Este bloque 'output' define una salida que mostrará la dirección IP pública del servidor redirector
# Similar al bloque anterior, pero para el servidor redirector que ayudará a ocultar el servidor C2
output "C2_Redirector_IPv4" {
  # Obtenemos la IP pública de la IP elástica asignada al servidor redirector
  # La sintaxis es la misma que en el bloque anterior porque también manejamos múltiples instancias
  value = aws_eip.C2_Redirector_eip.*.public_ip
}
