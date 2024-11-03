# Sliver

[![sliver_kali](https://img.shields.io/ansible/role/<PENDING_ROLE>)](https://galaxy.ansible.com/pr0b3r7/<PENDING_ROLE>)

Este rol de Ansible instala Sliver C2 descargando la última versión usando el gestor de paquetes `apt`.

1. Bucle a través de la instalación de paquetes pre-requisitos y `sliver`
1. Bucle a través de la validación de paquetes pre-requisitos y `sliver`
1. Verificar la versión de `sliver` (cliente) como validación adicional de que Sliver fue instalado
1. Verificar la ayuda de `sliver-server` como validación adicional de que Sliver fue instalado

## Requisitos

Este rol asume:
- Puedes alcanzar tu dispositivo y ansible está correctamente configurado, se puede probar vía: ` ansible -m ping "target_hostname, " -v `
- Lo estás ejecutando en un sistema operativo basado en Debian como Kali Linux o Ubuntu

## Variables del Rol

- `remote_user`: configurado a `kali` o un "nombre de usuario con pocos privilegios" en el archivo `vars/main.yml`
- `become_user`: configurado a `kali` o un "nombre de usuario con pocos privilegios" en el archivo `vars/main.yml`

## Dependencias

Todas las dependencias son manejadas a través de este rol de Ansible

- gpg
- build-essential
- mingw-w64
- binutils-mingw-w64
- g++-mingw-w64
- sliver
- net-tools

## Ejemplo de Playbook

Incluir un ejemplo de cómo usar tu rol (por ejemplo, con variables pasadas como parámetros) siempre es útil para los usuarios también:

```YAML
---
- name: Install Sliver C2 via Ansible Role
  hosts: all
  become: true
  remote_user: kali
  gather_facts: true
  become_method: ansible.builtin.sudo
  roles:
     - sliver_kali
```

## Licencia

Licencia MIT

## Información del Autor


| Redes Sociales | Enlace |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
