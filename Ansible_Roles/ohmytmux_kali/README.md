# ohmytmux_kali

Este rol de ansible instala [`tmux`](https://github.com/tmux/tmux/wiki) y lo personaliza instalando [`oh-my-tmux`](https://github.com/gpakosz/.tmux) realizando los siguientes cambios:

- Verifica si tmux está instalado con apt antes de la instalación
- Instala tmux con apt si no está instalado
- Verifica si tmux está instalado con apt después de la instalación
- Confirma la instalación de tmux
- Instala oh-my-tmux vía git para usuario con privilegios limitados
- Instala oh-my-tmux.conf vía enlace simbólico a $HOME/.tmux.conf
- Copia oh-my-tmux.conf.local a $HOME/.tmux.conf.local
- Valida que el archivo oh-my-tmux.conf.local existe
- Instala oh-my-tmux vía git para root
- Instala oh-my-tmux.conf vía enlace simbólico a /root/.tmux.conf
- Copia oh-my-tmux.conf.local a /root/.tmux.conf.local
- Valida que el archivo oh-my-tmux.conf.local existe

## Requisitos

Para crear otros roles como este, sigue [este](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedimiento (enlazado).

Este rol asume que:

- Puedes alcanzar tu dispositivo y ansible está correctamente configurado, puede probarse mediante: ` ansible -m ping "target_hostname, " -v `
- Lo estás ejecutando en un sistema operativo basado en Debian como Kali linux o Ubuntu
- `git` está instalado en este sistema y hay una conexión a internet disponible para descargar los paquetes y archivos del repositorio referenciados en el rol
- Estás configurando la variable `remote_user` como `kali` o un "nombre de usuario con privilegios limitados" en el archivo `vars/main.yml`

Variables del Rol

- `remote_user`: configurar como `kali` o un "nombre de usuario con privilegios limitados" en el archivo `vars/main.yml`
- `become_user`: configurar como `kali` o un "nombre de usuario con privilegios limitados" en el archivo `vars/main.yml`

## Dependencias

- Variables definidas arriba y configuradas con valores válidos
- `git` instalado en el sistema Ubuntu o Kali (puede instalarse vía apt install git -y en un sistema con Advanced Package Tool "apt" instalado)

## Ejemplo de Playbook

Archivo YML principal del playbook o tarea:

```YML
---
# Playbook para instalar oh-my-tmux en un sistema Kali Linux
- name: Install oh-my-tmux into a Kali Linux based system  # Nombre descriptivo del playbook
  hosts: all                # Se ejecutará en todos los hosts definidos en el inventario
  remote_user: kali        # Usuario remoto para la conexión SSH
  become: true             # Habilita la elevación de privilegios (sudo)
  roles:
    - ohmytmux            # Nombre del rol a ejecutar
```

Contenido de `vars/main.yml` con el que se escribió este rol:

```YML
---
# Archivo de variables para el rol ohmytmux
remote_user: kali    # Usuario remoto para la conexión SSH
become_user: kali    # Usuario para la elevación de privilegios
```

## Licencia

Licencia MIT

## Información del Autor

-------

| Redes Sociales | Enlace |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
