Role Name
=========

This role installs Cobalt Strike via an ansible role:

- Delete directory `/opt/TA0011_C2` if it exsits to avoid conflicts with a previous installations
- Delete prior `/tmp/cobaltstrike-dist.tgz` if it exists to avoid conflicts with a previous installations
- Create `/opt/TA0011_C2` directory where Cobalt Strike will be downloaded
- Set Default Java version to openjdk11 via `update-java-alternatives`
- Get download token from Cobalt Strike download website using license key (`cs_key` variable) to request archive download
- Downloading Cobalt Strike archive tarball (`.tgz`) to `/tmp/cobaltstrike-dist.tgz`
- Extract Cobalt Strike tarball (.tgz) to directory defined in `c2_servers_dir` variable
- Upgrade and license Cobalt Strike using expect and passing the license key (`cobaltstrike_license`)

Requirements
------------

To create other roles like this, follow [the linked procedure here](https://redhatgov.io/workshops/ansible_automation/exercise1.5/)

This role assumes:

- You are able to reach your device and ansible is correctly configured, can be tested via: ` ansible -m ping "target_hostname, " -v `
- You are running it against a Debian based operating system such as Kali linux or Ubuntu
- You are running it against a x86_64 system. AARCH64/ARM64 will not work
- Java is installed in the system
- You are providing a valid Cobalt Strike License in the `vars/main.yml` or `defaults/main.yml`

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role.
Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

- `cs_key`: must be a valid Cobalt Strike license
- `cs_profile_location`: provides location of malleable c2 profiles
- `cs_profile`: sets name for malleable c2 profile
- `c2_servers_dir`: sets location for C2 software to be installed in the system

Dependencies
------------

- variables defined above and set to valid values
- `apt`

Example Playbook
----------------

Example of how to use role for users to use in their playbook:

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

Contents of `vars/main.yml` this role was written with:

```YML
---
# vars file for cobaltstrike
cs_key: ""
# Must be replaced by a valid Cobalt Strike License. The value committed to the repository is an example and not a valid license.
# when in <ROLENAME>/defaults/main.yml this is not needed in <ROLENAME>/vars/main.yml
cs_profile_location: ../files/clean.profile.j2
cs_profile: 'clean_malleable'
c2_servers_dir: '/opt/TA0011_C2'
```

License

-------

GNU General Public License (GPL): GPL-3.0-only

Author Information

-------

| | |
| - | - |
| Name | Robert Pimentel |
| Github | [Github](https://github.com/pr0b3r7) |
