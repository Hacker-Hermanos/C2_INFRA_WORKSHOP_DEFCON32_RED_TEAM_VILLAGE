# Exercise 3: Configure 1 C2 Redirector using Ansible Roles

Let's set up our C2 Redirector! Follow these exciting steps:

1. Acquire a domain or use an existing one to set an A record with the IP of your redirector.
2. Configure the C2 Redirector's VPN for backend communications between the C2 server and the redirector.
3. Configure the C2 Redirector with `apache2`:
   - Use our custom Ansible role based on tevora threat:

   ```bash
   ansible-playbook /path/to/DEFCON32_RT_Village_workshop/Exercise_3/ansible/C2_Redirector_playbook.yml -i '<REDIRECTOR_IP>, ' --private-key /path/to/DEFCON32_RT_Village_workshop/Exercise_1/SSH-Key-*.pem --extra-vars 'kali'
   ```

   - Forward C2 traffic to the C2 server's VPN tunnel interface.

4. Harden your C2 Redirector:
   - Implement URI paths for listeners.
   - Configure logging:
     - Custom directory logging.
     - Trace logging for detailed tracking.
   - Filter traffic (use [curi0usJack/.htaccess](https://gist.github.com/curi0usJack/971385e8334e189d93a6cb4671238b10) as a reference).
   - Troubleshoot with these commands:

   ```bash
   cat -n /var/www/html/<REDIRECTOR_DOMAIN.TLD>/logs/*.log | grep "<SOURCE_IP>" | awk '{print $16,$17,$18,$19,$20,$21,$22,$23}'
   cat -n /var/www/html/<REDIRECTOR_DOMAIN.TLD>/logs/*.log | grep "<SOURCE_IP>" | awk '{print $16,$17,$18,$19,$20,$21,$22,$23}' | grep " matched\|not-matched"
   ```

   - Send test traffic:

   ```bash
   curl -k -s https://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks -v -A "Mozilla/5.0" --header "Hacker-Hermanos-Rocks: True"
   ```

5. Configure the C2 server listeners:
   - Use the VPN IP of the C2 Server (this is where the Redirector will send the traffic).
   - Define the URI path.
   - Set the necessary headers.

6. Generate payloads and test them:
   - Use TCPDUMP to verify:

   ```bash
   sudo tcpdump -i tailscale0 port 443 -nvv
   ```

## Exercise 3 Challenges

1. How would you address a defender replaying C2 traffic from a packet capture?
2. How would you create a list of all source IP addresses and CIDRs of popular online sandboxes (e.g., any.run, recorded future, virustotal, crowdstrike, kaspersky, defender for endpoint, etc.)?
3. Research and further configure Security Headers (e.g., https://pentest-tools.com/blog/essential-http-security-headers) to make the redirector seem like a legitimate application when footprinted. Note the ones currently implemented, would you remove or modify any or their values?:

| Header | Value | Description |
| --- | --- | --- |
| Strict-Transport-Security  | max-age=31536000 | Maximum age in seconds (1 year). |
| | includeSubDomains | Applies the rule to all subdomains. |
| | preload | Tells browsers to preload the site for HSTS. |
| Content-Security-Policy    | default-src 'self' | Allows resources to be loaded only from the same origin. |
| | script-src 'self' 'unsafe-inline' | Allows scripts from the same origin and inline scripts. Consider removing 'unsafe-inline' if possible. |
| | style-src 'self' 'unsafe-inline' | Allows styles from the same origin and inline styles. Adjust 'unsafe-inline' as needed. |
| | img-src 'self' data: | Allows images from the same origin and data URIs. |
| | font-src 'self' | Allows fonts from the same origin. |
| | object-src 'none' | Disallows all object, embed, and applet elements. |
| | frame-ancestors 'self' | Restricts the domains that can embed the page. |
| | base-uri 'self' | Restricts the URLs that can be used in the base element. |
| | form-action 'self' | Restricts the URLs forms can submit to. |
| X-XSS-Protection | 1; mode=block | Enables XSS filtering and prevents rendering of the page if an attack is detected. |
| X-Frame-Options | SAMEORIGIN | Allows the page to be displayed in a frame only on the same origin. |
| X-Content-Type-Options | nosniff | Prevents the browser from interpreting files as a different MIME type than specified. |
| Referrer-Policy | strict-origin-when-cross-origin | Sends the full URL only for same-origin requests and the origin for cross-origin requests. |
| Content-Type | text/html; charset=utf-8 | Sets the MIME type to HTML with UTF-8 character encoding. |

## Technical Glossary

- **A Record**: A type of DNS record that maps a domain name to the IPv4 address of a server.
- **VPN (Virtual Private Network)**: Technology that creates a secure and encrypted connection over a less secure network.
- **Apache2**: A popular and highly configurable open-source web server.
- **Ansible**: An automation tool for configuring and managing computers.
- **URI (Uniform Resource Identifier)**: A string of characters that identifies a web resource.
- **Logging**: The process of recording events and data for analysis and troubleshooting.
- **Trace logging**: A detailed level of logging that captures step-by-step information.
- **.htaccess**: An Apache configuration file that allows per-directory changes.
- **Payload**: In security, code designed to execute specific actions on a target system.
- **TCPDUMP**: A command-line tool for analyzing network traffic.
- **Security Headers**: HTTP headers that enhance the security of a web application.
- **HSTS (HTTP Strict Transport Security)**: A web security mechanism to protect against protocol downgrade attacks and cookie hijacking.
- **CSP (Content Security Policy)**: An additional security layer that helps detect and mitigate certain types of attacks.
- **MIME type**: A two-part identifier for file formats transmitted over the Internet.
