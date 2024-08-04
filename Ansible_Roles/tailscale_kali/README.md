Role Name
=========

This role installs Tailscale VPN using the [manual installation steps](https://tailscale.com/download/linux):

- Validate if Tailscale is already installed with `tailscale -v`
- Adds the Tailscale package signing key into `/usr/share/keyrings/` and ubuntu focal repository into `/etc/apt/sources.list.d/tailscale.list` if it is not installed using `curl` and `tee`
- If it already exsits, removes the existing Tailscale package using `apt`
- Validates that the package was uninstalled successfully
- Disables automatic start and stops any running Tailscale daemon/service using `systemctl`/`systemd`
- Installs Taiscale using `apt`
- Validates that the package was installed successfully
- Enables Tailscale daemon/service automatic start using `systemctl`/`systemd`
- Validates Tailscale Authentication Key checking that the `tailscale_authkey` is defined and it has a character length of "30" and saves the result of the validation to `authorization` using `register`
- Validates if Tailscale network is up with `tailscale status` and saves the result to `status` using `register`
- Connects the machine that the role is being ran for to the Tailscale's VPN `tailnet` using `tailscale up -authkey {{ tailscale_authkey }}`
- Checks the machine tailnet's IPv4 with `tailscale ip` and saves it to `ip_check` using `register`
- Saves the machine tailnet's IPv4 to `tailscale_ip` using `set_fact` and outputting the value of the `ip_check` saved in the previous step
- Checks the status of tailscaled and its connections and saves it to `status_check`
- Outputs the value `status_check` to the console

Requirements
------------

To create other roles like this, follow [this](https://redhatgov.io/workshops/ansible_automation/exercise1.5/) procedure (linked).

This role assumes:

- You are able to reach your device and ansible is correctly configured, can be tested via: ` ansible -m ping "target_hostname, " -v `
- You are running it against a Debian based operating system such as Kali linux or Ubuntu
- `apt` is in use for this system and there is an internet connection available to download the packages and repository files referenced in the role
- You are providing a valid Tailscale Authentication Key in the `vars/main.yml` file or `defaults/main.yml` with the name `tailscale_authkey`
- You are setting the `remote_user` variable to `kali` or `ubuntu` or a "low privileged username" in the `vars/main.yml` file

Role Variables
--------------

- `tailscale_authkey`: Tailscale Authentication Key
- `remote_user`: set to `kali` or a "low privileged username" in the `vars/main.yml` file

Dependencies
------------

- variables defined above and set to valid values
- `apt` Advanced Package Tool installed in the ubuntu or kali based system

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

Main playbook or task YML file:

```YML
---
- name: Install Tailscale into a Kali Linux based system
  hosts: all
  remote_user: kali
  become: true
  roles:
    - tailscale_kali
```

Contents of `vars/main.yml` this role was written with:

```YML
---
# vars file for tailscale
remote_user: kali
tailscale_authkey: "tskey-abcdef1432341818"
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
