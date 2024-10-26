# Misc Commands

```BASH
# Comprueba la conectividad con un host Kali usando Ansible
ansible -m ping '0x-kali-test.domain.local, ' -i inventory.yml


# Ejecuta un playbook de Ansible deshabilitando la verificación de claves SSH
export ANSIBLE_HOST_KEY_CHECKING=false ; ansible-playbook -i '<IPv4>, ' --private-key <KEY_NAME>.pem 'ansible/<ANSIBLE_PLAYBOOK_NAME>.yml' --extra-vars 'kali'


# ¡Prueba tu redirector! Este comando hace una petición HTTP simple
curl -k -s "http://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks" -v

# Configura automáticamente SSL con Let's Encrypt - ¡súper útil!
sudo certbot --apache --post-hook "service apache2 restart" --agree-tos --register-unsafely-without-email -w /var/www/html/ -d <REDIRECTOR_DOMAIN.TLD> --force-renewal

# Prueba avanzada del redirector con diferentes User-Agents y headers personalizados
curl -k -s "https://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks" -v -A "curl" -H "Hacker-Hermanos-Rocks: True"
curl -k -s "https://<REDIRECTOR_DOMAIN.TLD>/redteamvillagerocks" -v -A "Mozilla/5.0" -H "Hacker-Hermanos-Rocks: True"
```
