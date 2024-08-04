# Sliver
=========

[![sliver_kali](https://img.shields.io/ansible/role/<PENDING_ROLE>)](https://galaxy.ansible.com/pr0b3r7/<PENDING_ROLE>)

This Ansible Role installs Sliver C2 by downloading the latest version using `apt` package manager.

1. Loop through pre-requisite and `sliver` packages installation
1. Loop through pre-requisite and `sliver` packages validation
1. Check `sliver` version (client) as additional validation that Sliver was installed
1. Check `sliver-server` help as additional validation that Sliver was installed

Requirements
------------

This role assumes:
	- You are able to reach your device and ansible is correctly configured, can be tested via: ` ansible -m ping "target_hostname, " -v `
	- You are running it against a Debian based operating system such as Kali linux or Ubuntu

Role Variables
--------------

- `remote_user`: set to `kali` or a "low privileged username" in the `vars/main.yml` file
- `become_user`: set to `kali` or a "low privileged username" in the `vars/main.yml` file

Dependencies
------------

All dependencies are handled via this Ansible Role

- gpg
- build-essential
- mingw-w64
- binutils-mingw-w64
- g++-mingw-w64
- sliver
- net-tools

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

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

## License

MIT License

## Author Information

-------

| Social Media | Link |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
