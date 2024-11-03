# cobaltstrike

Este rol instala Cobalt Strike a través de un rol de ansible:

- Elimina el directorio `/opt/TA0011_C2` si existe para evitar conflictos con instalaciones previas
- Elimina el archivo `/tmp/cobaltstrike-dist.tgz` previo si existe para evitar conflictos con instalaciones previas
- Crea el directorio `/opt/TA0011_C2` donde se descargará Cobalt Strike
- Establece la versión predeterminada de Java a openjdk11 mediante `update-java-alternatives`
- Obtiene el token de descarga del sitio web de Cobalt Strike usando la clave de licencia (variable `cs_key`) para solicitar la descarga del archivo
- Descarga el archivo tarball (`.tgz`) de Cobalt Strike a `/tmp/cobaltstrike-dist.tgz`
- Extrae el archivo tarball de Cobalt Strike (.tgz) al directorio definido en la variable `c2_servers_dir`
- Actualiza y licencia Cobalt Strike usando expect y pasando la clave de licencia (`cobaltstrike_license`)

## Requisitos

Para crear otros roles como este, sigue [el procedimiento enlazado aquí](https://redhatgov.io/workshops/ansible_automation/exercise1.5/)

Este rol asume:

- Puedes alcanzar tu dispositivo y ansible está correctamente configurado, puede probarse mediante: ` ansible -m ping "target_hostname, " -v `
- Lo estás ejecutando en un sistema operativo basado en Debian como Kali linux o Ubuntu
- Lo estás ejecutando en un sistema x86_64. AARCH64/ARM64 no funcionará
- Java está instalado en el sistema
- Estás proporcionando una licencia válida de Cobalt Strike en el archivo `vars/main.yml` o `defaults/main.yml`

## Variables del Rol

Una descripción de las variables configurables para este rol debería ir aquí, incluyendo cualquier variable que esté en `defaults/main.yml`, `vars/main.yml`, y cualquier variable que pueda/deba ser configurada mediante parámetros al rol.
Cualquier variable que sea leída de otros roles y/o del alcance global (es decir, `hostvars`, `group vars`, etc.) también debería ser mencionada aquí.

- `cs_key`: debe ser una licencia válida de Cobalt Strike
- `cs_profile_location`: proporciona la ubicación de los perfiles malleable c2
- `cs_profile`: establece el nombre para el perfil malleable c2
- `c2_servers_dir`: establece la ubicación para que el software C2 se instale en el sistema

## Dependencias

- Variables definidas arriba y configuradas con valores válidos
- `apt`

## Ejemplo de Playbook

Ejemplo de cómo usar el rol para que los usuarios lo utilicen en su playbook:

```YML
---
- name: Install Cobalt Strike using Cobalt_Strike_role
  hosts: all
  remote_user: kali
  become: true
  become_method: sudo
  gather_facts: true
  roles:
    - Cobalt_Strike_role
```

Contenido de `vars/main.yml` con el que se escribió este rol:

```YML
---
# archivo de variables para cobaltstrike

# Clave de licencia de Cobalt Strike
# Debe ser reemplazada por una licencia válida de Cobalt Strike. El valor comprometido en el repositorio es un ejemplo y no una licencia válida.
# Es importante mantener esta clave segura y no compartirla públicamente, ya que una licencia comprometida puede permitir el uso no autorizado del software.
# Cuando se encuentra en <ROLENAME>/defaults/main.yml, no es necesario en <ROLENAME>/vars/main.yml
cs_key: ""

# Ubicación del perfil malleable C2
# Proporciona la ubicación del archivo de perfil malleable C2. Este archivo define cómo se comporta el tráfico de red del servidor C2.
# Asegúrate de que la ruta al archivo sea correcta y que el archivo exista en el sistema.
# La seguridad operacional implica que el perfil debe estar configurado correctamente para evitar detección por herramientas de seguridad.
cs_profile_location: ../files/clean.profile.j2

# Nombre del perfil malleable C2
# Establece el nombre para el perfil malleable C2. Este nombre se utilizará para identificar el perfil en las configuraciones de Cobalt Strike.
# Es importante elegir un nombre descriptivo y único para evitar confusiones con otros perfiles.
cs_profile: 'clean_malleable'

# Directorio de instalación del servidor C2
# Establece la ubicación donde se instalará el software del servidor C2 en el sistema.
# Asegúrate de que el directorio especificado tenga los permisos adecuados y suficiente espacio en disco.
# La seguridad operacional implica que el directorio debe ser accesible solo por usuarios autorizados para evitar modificaciones no autorizadas.
c2_servers_dir: '/opt/TA0011_C2'
```

## Licencia

Licencia Pública General GNU (GPL): GPL-3.0-only

## Información del autor

| | |
| - | - |
| Name | Robert Pimentel |
| Github | [Github](https://github.com/pr0b3r7) |
