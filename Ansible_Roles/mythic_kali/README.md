# Mythic

-------

[![mythic_kali](https://img.shields.io/ansible/role/<PENDING_ROLE>)](https://galaxy.ansible.com/pr0b3r7/<PENDING_ROLE>)

Install Mythic

Role Variables

-------

A list of all the variables can be found in ./defaults/main.yml.

Important:

If this role fails to install. You must run the below script to remove Mythic running containers. Otherwise, the directory where the repository is cloned into, will continue being populated by the running containers.

```BASH
sudo rm -rfv /opt/TA0011_C2/Mythic && 
sudo mkdir /opt/TA0011_C2 && 
cd /opt/TA0011_C2 &&
sudo git clone https://github.com/its-a-feature/Mythic &&
cd /opt/TA0011_C2/Mythic &&
sudo make &&
sudo /opt/TA0011_C2/Mythic/mythic-cli start &&
sudo /opt/TA0011_C2/Mythic/mythic-cli stop &&
sudo docker-compose down --remove-orphans
```

## Base Configs

- `mythic_repo` - Path to the repo you'd like to install. Useful if using a fork of Mythic
- `mythic_version` - Branch to pull from repo
- `installation_path` - Path to install Mythic

## Service Configs

-------

- `server_header` - Mythic HTTP server header
- `admin_username` - Admin username for Mythic
- `default_password` - Admin password for Mythic
- `operation_name` - Default operation name

## Agents

-------

- `agents[].repo` - Git repository to pull agent
- `agents[].branch` - Branch to pull from repository

Dependencies

-------

Example Playbook

-------

```yaml
- hosts: servers
  roles:
      - { role: mythic_kali }
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
