# ohmyzsh_ubuntu

Este rol de Ansible personaliza el [ZSH](https://www.kali.org/tools/zsh/) (que viene instalado por defecto en Ubuntu) realizando los siguientes cambios:

- Descarga el instalador de [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) en `/tmp/install.sh` si no está instalado ya
- Instala [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) usando el [script de instalación manual](https://github.com/ohmyzsh/ohmyzsh) descargado en `/tmp/install.sh`. Más información se puede encontrar en su [sitio web](https://ohmyz.sh/) para el usuario con privilegios limitados y root
- Verifica que oh-my-zsh fue instalado correctamente para el usuario con privilegios limitados y root
- Instala las fuentes recomendadas ["MesloLGS"](https://github.com/romkatv/powerlevel10k-media) según el [método de instalación manual](https://github.com/romkatv/powerlevel10k) detallado en el README de [powerlevel10k](https://github.com/romkatv/powerlevel10k) y actualiza la caché de fuentes para habilitar las fuentes en el sistema
- Instala el tema ZSH [powerlevel10k](https://github.com/romkatv/powerlevel10k)

- Instala los siguientes plugins en oh-my-zsh para el usuario con privilegios limitados y root:

  - Instala cargo para paquetes de rust como exa, lsd y bat
  - Instala exa, lsd y bat
  - Crea un directorio bajo `.oh-my-zsh/custom/plugins/sudo` y descarga el [plugin sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo) `.zsh` script en él
  - Instala el script `.zsh` de [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) bajo `.oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
  - Instala el script `.zsh` de [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions.git) bajo `.oh-my-zsh/custom/plugins/zsh-autosuggestions`
  - Instala el script `.zsh` de [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search.git) bajo `.oh-my-zsh/custom/plugins/zsh-history-substring-search`
  - Instala el script `.zsh` de [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete.git) bajo `.oh-my-zsh/custom/plugins/zsh-autocomplete`
  - Instala el script `.zsh` de [fzf-zsh-plugin](https://github.com/unixorn/fzf-zsh-plugin.git) bajo `.oh-my-zsh/custom/plugins/fzf-zsh-plugin`

- Instala el/los siguiente(s) tema(s) en `.oh-my-zsh/custom/themes/`:

  - [powerlevel10k](https://github.com/romkatv/powerlevel10k.git)

- Instala un archivo .zshrc personalizado que contiene funciones, alias, directorios custom/themes y custom/plugins en /home/low_priv_user/.zshrc y /root/.zshrc

## Requisitos

Para crear otros roles como este, sigue [este](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedimiento (enlazado).

Este rol asume:

- Puedes alcanzar tu dispositivo y ansible está correctamente configurado, puede probarse mediante: ` ansible -m ping "target_hostname, " -v `
- Lo estás ejecutando en un sistema operativo basado en Debian como Kali linux o Ubuntu
- `git` está instalado en este sistema y hay una conexión a internet disponible para descargar los paquetes y archivos del repositorio referenciados en el rol
- Estás configurando la variable `remote_user` como `ubuntu` o un "nombre de usuario con privilegios limitados" en el archivo `vars/main.yml`

## Variables del Rol

- `remote_user`: configurar como `ubuntu` o un "nombre de usuario con privilegios limitados" en el archivo `vars/main.yml`
- `become_user`: configurar como `ubuntu` o un "nombre de usuario con privilegios limitados" en el archivo `vars/main.yml`

## Dependencias

- Variables definidas arriba y configuradas con valores válidos
- `git` instalado en el sistema Ubuntu o Kali (puede instalarse vía apt install git -y en un sistema con Advanced Package Tool "apt" instalado)

## Ejemplo de Playbook

Archivo YML principal del playbook o tarea:

```YML
---
- name: Install oh-my-zsh into a ubuntu Linux based system
  hosts: all
  remote_user: ubuntu
  become: true
  roles:
    - ohmyzsh
```

Contenido de `vars/main.yml` que se usó para escribir este rol:

```YML
---
# vars file for ohmyzsh
remote_user: ubuntu
become_user: ubuntu
```

## License

Licencia MIT

## Información del autor original

-------

| Social Media | Link |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
