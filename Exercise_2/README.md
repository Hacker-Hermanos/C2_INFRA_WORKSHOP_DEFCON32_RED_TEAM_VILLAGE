# Exercise 2: Configure 1 C2 Teamserver using Ansible Roles

- Configure C2 Server with a framework (e.g., Mythic C2)
- Update `vars/main.yml`, `defaults/main.yml` for `Ansible_Roles/tailscale_kali` to add the VPN API key (i.e., `tskey-auth-kXXXXXXX`)
- Configure C2 Server's VPN for backend communications between C2 server and redirector
- Update `vars/main.yml`, `defaults/main.yml` for `Ansible_Roles/redirector` to add the VPN IP of the C2 server to the Ansible Role that configures the redirector
- Replace "`<TAILSCALE_C2_VPN_IP>`" with C2 Tailscale VPN IPv4

`ansible-playbook /path/to/DEFCON32_RT_Village_workshop/Exercise_2/ansible/C2_TeamServer_playbook.yml -i '<C2_SERVER_IP>, ' --private-key /path/to/DEFCON32_RT_Village_workshop/Exercise_1/SSH-Key-name.pem --extra-vars 'kali'`

## Exercise 2 challenges

1. Develop your own Ansible role to install alternative VPN solutions (i.e., nebula VPN by Slack team)
2. Implement a configuration that will allow you to restrict ALL ingress traffic to the C2 server while still allowing for C2 traffic redirection. What tool would you use?
3. Modify the `redirector` ansible role so that it outputs the Mythic credentials
