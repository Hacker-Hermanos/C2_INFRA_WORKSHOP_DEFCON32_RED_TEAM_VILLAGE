# Mythic

-------

[![mythic_kali](https://img.shields.io/ansible/role/<PENDING_ROLE>)](https://galaxy.ansible.com/pr0b3r7/<PENDING_ROLE>)

Este rol instala Mythic en un sistema Kali Linux.

## Variables del Rol
-------

Una lista de todas las variables se puede encontrar en ./defaults/main.yml.

Importante:

Si este rol falla al instalarse, debes ejecutar el siguiente script para eliminar los contenedores de Mythic en ejecución. De lo contrario, el directorio donde se clonó el repositorio continuará siendo poblado por los contenedores en ejecución.

```BASH
# Este script realiza una limpieza completa y reinstalación de Mythic
# 1. Elimina completamente el directorio actual de Mythic
sudo rm -rfv /opt/TA0011_C2/Mythic && 

# 2. Crea un nuevo directorio para la instalación
sudo mkdir /opt/TA0011_C2 && 

# 3. Cambia al directorio de instalación
cd /opt/TA0011_C2 &&

# 4. Clona el repositorio oficial de Mythic
sudo git clone https://github.com/its-a-feature/Mythic &&

# 5. Entra al directorio de Mythic
cd /opt/TA0011_C2/Mythic &&

# 6. Compila e instala las dependencias necesarias
sudo make &&

# 7. Inicia los servicios de Mythic
sudo /opt/TA0011_C2/Mythic/mythic-cli start &&

# 8. Detiene los servicios de Mythic
sudo /opt/TA0011_C2/Mythic/mythic-cli stop &&

# 9. Limpia todos los contenedores Docker relacionados
sudo docker-compose down --remove-orphans
```

## Configuraciones Base

- `mythic_repo` - Ruta al repositorio que deseas instalar. Útil si estás usando un fork de Mythic
- `mythic_version` - Rama (branch) a extraer del repositorio
- `installation_path` - Ruta donde se instalará Mythic

## Configuraciones del Servicio

-------

- `server_header` - Encabezado del servidor HTTP de Mythic
- `admin_username` - Nombre de usuario del administrador para Mythic
- `default_password` - Contraseña del administrador para Mythic
- `operation_name` - Nombre predeterminado de la operación

## Agentes

-------

- `agents[].repo` - Repositorio Git para extraer el agente
- `agents[].branch` - Rama a extraer del repositorio

## Dependencias


## Ejemplo de Playbook

```yaml
# Este es un ejemplo básico de cómo usar el rol mythic_kali en tu playbook de Ansible
# - 'hosts: servers' especifica que este playbook se ejecutará en todos los servidores definidos
# - El rol 'mythic_kali' se aplicará a estos servidores
- hosts: servers
  roles:
      - { role: mythic_kali }
```

## Licencia

Licencia MIT

## Información del Autor

-------

| Red Social | Enlace |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
