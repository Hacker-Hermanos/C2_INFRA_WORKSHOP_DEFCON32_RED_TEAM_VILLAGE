# tailscale_ubuntu

Este rol instala Tailscale VPN usando los [pasos de instalación manual](https://tailscale.com/download/linux):

- Valida si Tailscale ya está instalado con `tailscale -v`
- Agrega la clave de firma del paquete Tailscale en `/usr/share/keyrings/` y el repositorio focal de Ubuntu en `/etc/apt/sources.list.d/tailscale.list` si no está instalado usando `curl` y `tee`
- Si ya existe, elimina el paquete Tailscale existente usando `apt`
- Valida que el paquete fue desinstalado exitosamente
- Deshabilita el inicio automático y detiene cualquier demonio/servicio de Tailscale en ejecución usando `systemctl`/`systemd`
- Instala Tailscale usando `apt`
- Valida que el paquete fue instalado exitosamente
- Habilita el inicio automático del demonio/servicio de Tailscale usando `systemctl`/`systemd`
- Valida la Clave de Autenticación de Tailscale verificando que `tailscale_authkey` esté definida y tenga una longitud de 30 caracteres y guarda el resultado de la validación en `authorization` usando `register`
- Valida si la red de Tailscale está activa con `tailscale status` y guarda el resultado en `status` usando `register`
- Conecta la máquina en la que se está ejecutando el rol a la VPN `tailnet` de Tailscale usando `tailscale up -authkey {{ tailscale_authkey }}`
- Verifica la dirección IPv4 de la red de Tailscale con `tailscale ip` y la guarda en `ip_check` usando `register`
- Guarda la dirección IPv4 de la red de Tailscale en `tailscale_ip` usando `set_fact` y muestra el valor de `ip_check` guardado en el paso anterior
- Verifica el estado de tailscaled y sus conexiones y lo guarda en `status_check`
- Muestra el valor de `status_check` en la consola

## Requisitos

Para crear otros roles como este, sigue [este](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedimiento (enlazado).

Este rol asume:

- Puedes alcanzar tu dispositivo y Ansible está configurado correctamente, se puede probar con: ` ansible -m ping "target_hostname, " -v `
- Lo estás ejecutando en un sistema operativo basado en Debian como Kali Linux o Ubuntu
- `apt` está en uso para este sistema y hay una conexión a internet disponible para descargar los paquetes y archivos de repositorio referenciados en el rol
- Estás proporcionando una Clave de Autenticación de Tailscale válida en el archivo `vars/main.yml` o `defaults/main.yml` con el nombre `tailscale_authkey`
- Estás configurando la variable `remote_user` a `kali` o `ubuntu` o un "nombre de usuario con pocos privilegios" en el archivo `vars/main.yml`

## Variables del Rol

- `tailscale_authkey`: Clave de Autenticación de Tailscale
- `remote_user`: configurado a `kali` o un "nombre de usuario con pocos privilegios" en el archivo `vars/main.yml`

## Dependencias

- Variables definidas arriba y configuradas con valores válidos
- `apt` Advanced Package Tool instalado en el sistema basado en Ubuntu o Kali

## Ejemplo de Playbook

Incluir un ejemplo de cómo usar tu rol (por ejemplo, con variables pasadas como parámetros) siempre es útil para los usuarios también:

Archivo principal de playbook o tarea YML:

```YML
---
# Este es un playbook de Ansible para instalar Tailscale en un sistema basado en Kali Linux
# Un playbook es una lista de tareas que Ansible ejecutará en los hosts especificados

- name: Instalar Tailscale en un sistema basado en Kali Linux  # Nombre de la tarea principal
  hosts: all  # Especifica que la tarea se ejecutará en todos los hosts definidos en el inventario
  remote_user: kali  # Usuario remoto con el que se ejecutarán las tareas. Asegúrate de que este usuario tenga los permisos necesarios
  become: true  # Permite elevar los privilegios a superusuario (root) para ejecutar tareas que requieren permisos administrativos
  roles:
    - tailscale_kali  # Especifica el rol a ejecutar. Un rol es una forma de organizar tareas y otros archivos relacionados

# Nota: Asegúrate de que el usuario 'kali' tenga permisos sudo sin contraseña configurados para que 'become: true' funcione correctamente.
# La seguridad operacional implica que el usuario remoto debe ser de confianza y tener los permisos mínimos necesarios para realizar las tareas.
# Además, la clave de autenticación de Tailscale debe mantenerse segura y no debe ser expuesta en archivos de configuración públicos.
```

Contenido de `vars/main.yml` con el que se escribió este rol:

```YML
---
# Archivo de variables para tailscale
# Este archivo contiene las variables necesarias para configurar y conectar Tailscale en una máquina.

# remote_user es el usuario remoto con el que se ejecutarán las tareas de Ansible.
# Este usuario debe tener los permisos necesarios para ejecutar comandos en la máquina remota.
# Asegúrate de que el usuario tenga permisos sudo sin contraseña configurados para que 'become: true' funcione correctamente.
# La seguridad operacional implica que el usuario remoto debe ser de confianza y tener los permisos mínimos necesarios para realizar las tareas.
remote_user: kali

# tailscale_authkey es la clave de autenticación utilizada para conectar la máquina a la red VPN de Tailscale.
# Esta clave debe ser proporcionada por el usuario y debe mantenerse segura.
# No compartas esta clave públicamente ya que puede comprometer la seguridad de tu red VPN.
# La clave debe tener al menos 30 caracteres de longitud para ser válida.
# Es importante que esta clave sea única y generada desde el panel de administración de Tailscale.
# Asegúrate de que la clave no esté expuesta en ningún archivo de configuración o repositorio público.
# La clave de autenticación permite que la máquina se una a la red VPN de Tailscale, proporcionando acceso seguro a otros dispositivos en la red.
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
