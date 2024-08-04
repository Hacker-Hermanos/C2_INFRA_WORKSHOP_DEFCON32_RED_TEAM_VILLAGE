Role Name
=========

This ansible role installs [`tmux`](https://github.com/tmux/tmux/wiki) and customizes it installing [`oh-my-tmux`](https://github.com/gpakosz/.tmux) by making the following changes:

- Check if tmux is installed with apt before installing
- Install tmux with apt if it is not installed
- Check if tmux is installed with apt after installing
- Confirm tmux installation
- Install oh-my-tmux via git for low privileged user
- Install oh-my-tmux.conf via symbolic link to $HOME/.tmux.conf
- Copy oh-my-tmux.conf.local to $HOME/.tmux.conf.local
- Validate oh-my-tmux.conf.local file exists
- Install oh-my-tmux via git for root
- Install oh-my-tmux.conf via symbolic link to /root/.tmux.conf
- Copy oh-my-tmux.conf.local to /root/.tmux.conf.local
- Validate oh-my-tmux.conf.local file exists

Requirements
------------

To create other roles like this, follow [this](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedure (linked).

This role assumes:

- You are able to reach your device and ansible is correctly configured, can be tested via: ` ansible -m ping "target_hostname, " -v `
- You are running it against a Debian based operating system such as Kali linux or Ubuntu
- `git` is installed in this system and there is an internet connection available to download the packages and repository files referenced in the role
- you are setting the `remote_user` variable to `kali` or a "low privileged username" in the `vars/main.yml` file

Role Variables
--------------

- `remote_user`: set to `kali` or a "low privileged username" in the `vars/main.yml` file
- `become_user`: set to `kali` or a "low privileged username" in the `vars/main.yml` file

Dependencies
------------

- variables defined above and set to valid values
- `git` installed in the Ubuntu or Kali based system (can be installed via apt install git -y in a system with Advanced Package Tool "apt" installed)

Example Playbook
----------------

Main playbook or task YML file:

```YML
---
- name: Install oh-my-tmux into a Kali Linux based system
  hosts: all
  remote_user: kali
  become: true
  roles:
    - ohmytmux
```

Contents of `vars/main.yml` this role was written with:

```YML
---
# vars file for ohmytmux
remote_user: kali
become_user: kali
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
