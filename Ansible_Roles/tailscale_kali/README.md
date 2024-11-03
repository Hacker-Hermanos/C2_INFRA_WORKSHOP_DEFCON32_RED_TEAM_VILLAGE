# tailscale_kali

Este rol instala Tailscale VPN usando los [pasos de instalación manual](https://tailscale.com/download/linux):

- Valida si Tailscale ya está instalado con `tailscale -v`
- Agrega la clave de firma del paquete Tailscale en `/usr/share/keyrings/` y el repositorio de ubuntu focal en `/etc/apt/sources.list.d/tailscale.list` si no está instalado usando `curl` y `tee`
- Si ya existe, elimina el paquete Tailscale existente usando `apt`
- Valida que el paquete fue desinstalado correctamente
- Deshabilita el inicio automático y detiene cualquier demonio/servicio de Tailscale en ejecución usando `systemctl`/`systemd`
- Instala Tailscale usando `apt`
- Valida que el paquete fue instalado correctamente
- Habilita el inicio automático del demonio/servicio de Tailscale usando `systemctl`/`systemd`
- Valida la Clave de Autenticación de Tailscale verificando que `tailscale_authkey` esté definida y tenga una longitud de 30 caracteres, y guarda el resultado de la validación en `authorization` usando `register`
- Valida si la red de Tailscale está activa con `tailscale status` y guarda el resultado en `status` usando `register`
- Conecta la máquina en la que se está ejecutando el rol a la VPN de Tailscale `tailnet` usando `tailscale up -authkey {{ tailscale_authkey }}`
- Verifica la dirección IPv4 de la red de Tailscale con `tailscale ip` y la guarda en `ip_check` usando `register`
- Guarda la dirección IPv4 de la red de Tailscale en `tailscale_ip` usando `set_fact` y muestra el valor de `ip_check` guardado en el paso anterior
- Verifica el estado de tailscaled y sus conexiones y lo guarda en `status_check`
- Muestra el valor de `status_check` en la consola

## Requisitos

Para crear otros roles como este, sigue [este](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedimiento (enlace).

Este rol asume:

- Puedes alcanzar tu dispositivo y ansible está correctamente configurado, se puede probar con: ` ansible -m ping "target_hostname, " -v `
- Lo estás ejecutando en un sistema operativo basado en Debian como Kali Linux o Ubuntu
- `apt` está en uso para este sistema y hay una conexión a internet disponible para descargar los paquetes y archivos de repositorio referenciados en el rol
- Estás proporcionando una Clave de Autenticación de Tailscale válida en el archivo `vars/main.yml` o `defaults/main.yml` con el nombre `tailscale_authkey`
- Estás configurando la variable `remote_user` a `kali` o `ubuntu` o un "nombre de usuario con pocos privilegios" en el archivo `vars/main.yml`

## Variables del Rol

- `tailscale_authkey`: Clave de Autenticación de Tailscale
- `remote_user`: configurado a `kali` o un "nombre de usuario con pocos privilegios" en el archivo `vars/main.yml`

## Dependencias

- variables definidas arriba y configuradas con valores válidos
- `apt` Advanced Package Tool instalado en el sistema basado en ubuntu o kali

## Ejemplo de Playbook

Archivo principal de playbook o tarea YML:

```YML
---
- name: Instalar Tailscale en un sistema basado en Kali Linux
  hosts: all  # Aplica esta tarea a todos los hosts definidos en el inventario
  remote_user: kali  # Usuario remoto con el que se ejecutarán las tareas, en este caso 'kali'
  become: true  # Escala privilegios para ejecutar las tareas como superusuario
  roles:
    - tailscale_kali  # Especifica el rol 'tailscale_kali' que contiene todas las tareas necesarias para instalar y configurar Tailscale
```

Contenido de `vars/main.yml` con el que se escribió este rol:

```YML
---
# archivo de variables para tailscale

# Usuario remoto con el que se ejecutarán las tareas
# Este usuario debe tener permisos limitados para minimizar riesgos de seguridad.
# Asegúrate de que el usuario tenga los permisos necesarios para ejecutar las tareas.
remote_user: kali

# Clave de autenticación para Tailscale
# Esta clave es necesaria para conectar la máquina a la red VPN de Tailscale.
# Asegúrate de mantener esta clave segura y no compartirla públicamente.
# La clave debe tener al menos 30 caracteres para ser válida.
# Si la clave es comprometida, puede permitir el acceso no autorizado a la red VPN.
tailscale_authkey: "tskey-abcdef1432341818"
```

## Licencia

Licencia MIT

## Información del autor

| Social Media | Link |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
