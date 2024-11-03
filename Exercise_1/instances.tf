# Crear un archivo local que contiene un script de shell para actualizar los nombres de host de las instancias EC2 de AWS. 
# Esto es necesario porque todas las máquinas virtuales EC2 terminarían llamándose "kali" por defecto, ya que ese es el 
# nombre de host predeterminado de la imagen AMI de Kali Linux que estamos utilizando.
resource "local_file" "update_aws_ec2_hostnames" {
  # El contenido del script que se creará usando la sintaxis heredoc (<<-EOT)
  # EOT permite escribir texto multilínea de forma más legible
  content  = <<-EOT
  #!/bin/bash

  # Verifica si el script se ejecuta como root (administrador)
  if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." 
    exit 1
  fi

  # Verifica si se proporcionaron los dos nombres de host como argumentos
  if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <nombre_host_antiguo> <nombre_host_nuevo>"
    exit 1
  fi

  old_hostname="$1"
  new_hostname="$2"

  # Actualiza el archivo /etc/hosts
  sed -i "s/$old_hostname/$new_hostname/g" /etc/hosts

  # Actualiza el archivo /etc/hostname
  echo "$new_hostname" > /etc/hostname

  # Actualiza el nombre de host actual
  hostnamectl set-hostname "$new_hostname"

  echo "Nombre de host actualizado de $old_hostname a $new_hostname."

  # Reinicia el sistema (opcional)
  # Descomenta la siguiente línea si deseas reiniciar el sistema después de actualizar el nombre de host
  # reboot now

  EOT
  # Ruta donde se guardará el script
  filename = "${path.root}/update_aws_ec2_hostnames.sh"
}

# Crear una instancia EC2 de AWS que funcionará como servidor de comando y control (C2)
# Esta es la máquina principal que controlará todas las operaciones
resource "aws_instance" "C2_TeamServer" {
  # Configuramos Kali Linux usando una Imagen de Máquina Amazon (AMI)
  # Una AMI es como una plantilla que contiene el software necesario para crear una nueva instancia EC2
  # Es similar a una ISO de instalación, pero ya está preconfigurada y optimizada para AWS
  ami = var.use1_ami_kali_234

  # El tipo de instancia determina el hardware virtual que se asignará (CPU, memoria, red, etc.)
  # Este valor se define en el archivo variables.tf para mayor flexibilidad
  instance_type = var.instance_type_C2_server

  # Nombre del par de claves SSH que se usará para conectarse a la instancia
  # Las claves SSH son necesarias para acceder de forma segura a la instancia
  key_name = aws_key_pair.key_pair.key_name

  # Los grupos de seguridad son como un firewall virtual que controla el tráfico entrante y saliente
  # Aquí especificamos qué grupo de seguridad se aplicará a esta instancia
  vpc_security_group_ids = [aws_security_group.C2_TeamServer_SG.id]

  # Número de instancias a crear. Si necesitas más servidores, aumenta este número
  count = 1

  # ID de la subred donde se creará la instancia
  # La subred es una parte de la red virtual (VPC) donde se desplegará la instancia
  subnet_id = aws_subnet.prod-subnet-public-1.id

  # Dirección IP privada que se asignará a la instancia
  # Esta IP debe estar dentro del rango de la subred especificada
  private_ip = var.list_private_ips_C2_teamservers[count.index]

  # Determina si la instancia debe tener una IP pública
  # true significa que la instancia será accesible desde Internet
  associate_public_ip_address = true

  # Configuración del servicio de metadatos de la instancia
  # Esta configuración mejora la seguridad al requerir tokens para acceder a los metadatos
  metadata_options {
    # Requiere el uso de IMDSv2, que es más seguro que IMDSv1
    # IMDSv2 usa tokens de sesión para acceder a los metadatos de la instancia
    http_tokens = "required"
    
    # Limita el número de saltos de red permitidos para acceder al servicio de metadatos
    # El valor 1 significa que solo la propia instancia puede acceder a sus metadatos
    http_put_response_hop_limit = 1
  }

  # Configuración del disco principal de la instancia
  # Especifica el tamaño del disco duro virtual
  root_block_device {
    volume_size = var.volume_size_C2_teamserver
  }

  # Etiquetas para identificar la instancia
  # El ${count.index + 0} agrega un número al nombre cuando hay múltiples instancias
  tags = {
    Name = "C2-TeamServer-${count.index + 0}"
  }

  # Comando de ansible comentado para referencia futura:
  # "sleep 90; export ANSIBLE_HOST_KEY_CHECKING=false; ansible-playbook -i 'IPv4,' --private-key [Ambiente]_[Aplicación]_[Región]_[Rol]_[Fecha]_[IDÚnico] 'ansible/C2_TeamServer_playbook.yml' --extra-vars 'kali' "

  # Provisioner para copiar el script de actualización de hostname a la instancia
  provisioner "file" {
    source      = local_file.update_aws_ec2_hostnames.filename
    destination = "/tmp/update_aws_ec2_hostnames.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    }
  }

  # Provisioner para ejecutar el script y actualizar el hostname
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update_aws_ec2_hostnames.sh",
      "new_hostname=\"C2-TeamServer-${count.index + 0}\"",
      "sudo /tmp/update_aws_ec2_hostnames.sh $(cat /etc/hostname) $new_hostname"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    }
  }
}

# Asignar una dirección IP elástica (EIP) al servidor C2
# Una IP elástica es una dirección IPv4 pública que permanece fija aunque la instancia se reinicie
# Esto es útil para mantener una dirección IP constante incluso si la instancia se detiene y reinicia
resource "aws_eip" "C2_TeamServer_eip" {
  # Número de IPs elásticas a crear
  count    = 1
  # Asociar la IP elástica con la instancia correspondiente
  instance = aws_instance.C2_TeamServer[count.index].id
}

# Crear una instancia EC2 que funcionará como redirector
# El redirector actúa como intermediario entre Internet y el servidor C2 para mayor seguridad
resource "aws_instance" "C2_Redirector" {
  # Usar la misma imagen Kali Linux que el servidor C2
  ami = var.use1_ami_kali_234

  # Tipo de instancia que define los recursos de hardware
  instance_type = var.instance_type_C2_redirector

  # Aplicar el grupo de seguridad específico para el redirector
  vpc_security_group_ids = [aws_security_group.C2_Redirector_SG.id]

  # Crear una sola instancia redirector
  count     = 1

  # Asignar una IP privada predefinida
  private_ip = var.list_private_ips_C2_Redirectors[count.index]

  # Configuración de seguridad para los metadatos
  metadata_options {
    http_tokens = "required"
    http_put_response_hop_limit = 1
  }

  # Configurar el tamaño del disco
  root_block_device {
    volume_size = var.volume_size_C2_redirector
  }

  # Etiquetar la instancia para identificación
  tags = {
    Name = "C2-Redirector-${count.index + 0}"
  }

  # Copiar el script de actualización de hostname
  provisioner "file" {
    source      = local_file.update_aws_ec2_hostnames.filename
    destination = "/tmp/update_aws_ec2_hostnames.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    }
  }

  # Ejecutar el script para actualizar el hostname
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update_aws_ec2_hostnames.sh",
      "new_hostname=\"C2-Redirector-${count.index}\"",
      "sudo /tmp/update_aws_ec2_hostnames.sh $(cat /etc/hostname) $new_hostname"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.kali_ansible_become_user
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    }
  }
}

# Asignar una IP elástica al redirector
# Esto permite mantener una dirección IP fija para el redirector
resource "aws_eip" "C2_Redirector_eip" {
  count    = 1
  instance = aws_instance.C2_Redirector[count.index].id
}
