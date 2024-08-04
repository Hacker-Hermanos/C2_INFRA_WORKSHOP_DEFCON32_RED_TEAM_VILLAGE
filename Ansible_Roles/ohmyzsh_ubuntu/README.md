Role Name
=========

This ansible role customizes the [ZSH](https://www.kali.org/tools/zsh/) (that comes installed by default installed into ubuntu) by making the following changes:

- Downloads installer for [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) into `/tmp/install.sh` if not installed already
- Installs [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) using the [manual installation script](https://github.com/ohmyzsh/ohmyzsh) downloaded into `/tmp/install.sh`. More info can be found on its [website](https://ohmyz.sh/) for low privileged user and root
- Checks that oh-my-zsh was correctly installed for low privileged user and root
- Installs the recommended fonts ["MesloLGS"](https://github.com/romkatv/powerlevel10k-media) according to the [manual installation method](https://github.com/romkatv/powerlevel10k) detailed in the README for [powerlevel10k](https://github.com/romkatv/powerlevel10k) and updates font cache to enable the fonts in the system
- Installs [powerlevel10k](https://github.com/romkatv/powerlevel10k) ZSH theme

- Installs the following plugins into oh-my-zsh for low privileged user and root

  - Installs cargo for rust packages such as exa, lsd and bat
  - Installs exa, lsd and bat
  - Creates a directory under `.oh-my-zsh/custom/plugins/sudo` and downloads the [sudo plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo) `.zsh` script into it
  - Installs [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) `.zsh` script under `.oh-my-zsh/custom/plugins/zsh-syntax-highlighting`
  - Installs [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions.git) `.zsh` script under `.oh-my-zsh/custom/plugins/zsh-autosuggestions`
  - Installs [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search.git) `.zsh` script under `.oh-my-zsh/custom/plugins/zsh-history-substring-search`
  - Installs [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete.git) `.zsh` script under `.oh-my-zsh/custom/plugins/zsh-autocomplete`
  - Installs [fzf-zsh-plugin](https://github.com/unixorn/fzf-zsh-plugin.git) `.zsh` script under `.oh-my-zsh/custom/plugins/fzf-zsh-plugin`

- Installs the following theme(s) into `.oh-my-zsh/custom/themes/`

  - [powerlevel10k](https://github.com/romkatv/powerlevel10k.git)

- Install custom .zshrc containing functions, aliases, custom/themes and custom/plugins directories to /home/low_priv_user/.zshrc and /root/.zshrc

Requirements
------------

To create other roles like this, follow [this](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedure (linked).

This role assumes:

- You are able to reach your device and ansible is correctly configured, can be tested via: ` ansible -m ping "target_hostname, " -v `
- you are running it against a Debian based operating system such as Kali linux or Ubuntu
- `git` is installed in this system and there is an internet connection available to download the packages and repository files referenced in the role
- you are setting the `remote_user` variable to `ubuntu` or a "low privileged username" in the `vars/main.yml` file

Role Variables
--------------

- `remote_user`: set to `ubuntu` or a "low privileged username" in the `vars/main.yml` file
- `become_user`: set to `ubuntu` or a "low privileged username" in the `vars/main.yml` file

Dependencies
------------

- variables defined above and set to valid values
- `git` installed in the Ubuntu or Kali based system (can be installed via apt install git -y in a system with Advanced Package Tool "apt" installed)

Example Playbook
----------------

Main playbook or task YML file:

```YML
---
- name: Install oh-my-zsh into a ubuntu Linux based system
  hosts: all
  remote_user: ubuntu
  become: true
  roles:
    - ohmyzsh
```

Contents of `vars/main.yml` this role was written with:

```YML
---
# vars file for ohmyzsh
remote_user: ubuntu
become_user: ubuntu
```

## License

MIT License

## Author Information

-------

| Social Media | Link |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
