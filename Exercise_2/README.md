# Exercise 2: Configure 1 C2 Teamserver using Ansible Roles

## Main Steps

- Install and configure a C2 framework (e.g., Mythic C2) on the server
- Update `vars/main.yml` and `defaults/main.yml` files in the `Ansible_Roles/tailscale_kali` role to include your VPN API key (format: `tskey-auth-kXXXXXXX`)
- Configure the C2 server's VPN to establish communications between the server and redirector
- Update `vars/main.yml` and `defaults/main.yml` files in the `Ansible_Roles/redirector` role to add the C2 server's VPN IP
- Replace "`<TAILSCALE_C2_VPN_IP>`" with your C2 server's Tailscale IPv4

### Placeholders to Update in `Ansible_Roles/redirector/vars/main.yml`

Make sure to replace the following placeholders in the redirector role's `vars/main.yml` file:

- `<REDIRECTOR_DOMAIN_TLD>`: Main domain for the redirector.
- `<DECOY_DOMAIN_TLD>`: Decoy domain for unauthorized visitors.
- `<HTTP_PORT>`: Port for unencrypted HTTP traffic.
- `<HTTPS_PORT>`: Port for encrypted HTTPS traffic.
- `<SERVER_SIGNATURE>`: Server signature in HTTP responses.
- `<Prod_C2_TeamServer_TS0>`: Production server name.
- `<PROD_C2_VPN_IP>`: Production server's VPN IP. This ensures C2 traffic is redirected to the correct C2 server and that traffic is encrypted by the VPN.
- `<REQUIRED_HTTP_HEADER_1>`, `<REQUIRED_HTTP_HEADER_2>`: Required HTTP headers to authenticate requests. The C2 implant must be configured to send these headers.
- `<URI_PATH_NAME_1>`, `<URI_PATH_1>`: URI path definitions that the redirector will process and forward to the backend server. C2 traffic must be configured to call the same URI path defined here.
- `<REWRITE_FILTER_1>`, `<BACKEND_PORT_1>`: Rewrite rules to direct traffic to backend servers.

#### Example of the variables file in Ansible_Roles/redirector/vars/main.yml

```yaml
---
vhosts_dictionary: [
    {
        redirector_domain: 'test.evildomain.com',
        decoy_domain: 'www.healthcare.gov',
        http_port: 80,
        https_port: 443,
        server_signature: "Microsoft-IIS/10.0",
        backend_teamservers: [
            {
                name: 'TeamServer_TS0',
                vpn_ip: '100.100.100.100'
            },
        ],
        required_http_header: [
            'Hacker-Hermanos-Is-The-Best'
        ],
        uri_path_definitions: [
            {
                name: 'hackerhermanos',
                path: '/hackerhermanos'
            }
        ],
        rewrite_rule_filters: [
            {
                rewritefilter: 'hackerhermanos',
                backend_forward_port: '4443',
                backend_teamserver: 'TeamServer_TS0'
            }
        ]
    }
]
```

### Run the Ansible Playbook

To execute the Ansible playbook, use the following command:

```bash
ansible-playbook /path/to/DEFCON32_RT_Village_workshop/Exercise_2/ansible/C2_TeamServer_playbook.yml -i '<C2_SERVER_IP>, ' --private-key /path/to/DEFCON32_RT_Village_workshop/Exercise_1/SSH-Key-name.pem --extra-vars 'kali'
```

## Exercise 2 Challenges!

Get ready to take your skills to the next level! We propose these exciting challenges:

1. Create your own Ansible role to install alternative VPN solutions! How about trying Nebula VPN from the Slack team?
2. Develop a configuration that restricts ALL incoming traffic to the C2 server but still allows C2 traffic redirection. What tool would you use to achieve this?
3. Enhance the `redirector` Ansible role to display Mythic credentials. It will be super useful!

## Additional Challenges! 🚀

Ready to take your skills to the next level? Try these challenges:

1. Create your own Ansible role to install alternative VPN solutions (try Nebula VPN from the Slack team!)
2. Develop a configuration that restricts ALL incoming traffic to the C2 server, maintaining C2 traffic redirection. What tool would you use?
3. Enhance the `redirector` Ansible role to display Mythic credentials.

## Technical Glossary

- **Ansible Role**: A reusable set of tasks in Ansible that facilitates the automation of complex configurations.

- **VPN (Virtual Private Network)**: Technology that creates a secure and encrypted connection over a less secure network.

- **Nebula VPN**: A VPN solution developed by the Slack team, focused on mesh networks and high scalability.

- **Inbound Traffic**: All network traffic arriving at a server or system from the outside.

- **C2 Server (Command & Control)**: Central server that controls and coordinates security operations, enabling communication with target systems.

- **C2 Traffic Redirection**: Technique to hide the real location of the C2 server using intermediate servers.

- **Mythic**: Popular C2 framework known for its flexibility and advanced capabilities in security operations.
