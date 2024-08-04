# Misc Commands

```BASH
ansible -m ping '0x-kali-test.domain.local, ' -i inventory.yml


export ANSIBLE_HOST_KEY_CHECKING=false ; ansible-playbook -i '<IPv4>, ' --private-key <KEY_NAME>.pem 'ansible/<ANSIBLE_PLAYBOOK_NAME>.yml' --extra-vars 'kali'



curl -k -s "http://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks" -v

sudo certbot --apache --post-hook "service apache2 restart" --agree-tos --register-unsafely-without-email -w /var/www/html/ -d <REDIRECTOR_DOMAIN.TLD> --force-renewal

curl -k -s "https://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks" -v -A "curl" -H "Hacker-Hermanos-Rocks: True"
curl -k -s "https://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks" -v -A "Mozilla/5.0" -H "Hacker-Hermanos-Rocks: True"
```
