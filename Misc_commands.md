# Comandos Diversos

```BASH
# Este comando verifica si Ansible puede conectarse exitosamente a un host Kali específico
# El parámetro -m ping ejecuta el módulo de ping de Ansible
# inventory.yml es el archivo que contiene la lista de hosts a los que nos queremos conectar
ansible -m ping '0x-kali-test.domain.local, ' -i inventory.yml

# Este comando ejecuta una automatización (playbook) de Ansible con configuraciones específicas:
# - ANSIBLE_HOST_KEY_CHECKING=false: Desactiva la verificación de claves SSH por seguridad
# - -i '<IPv4>, ': Especifica la dirección IP del servidor objetivo
# - --private-key: Indica qué archivo de clave privada usar para la conexión SSH
# - --extra-vars: Permite pasar variables adicionales al playbook
export ANSIBLE_HOST_KEY_CHECKING=false ; ansible-playbook -i '<IPv4>, ' --private-key <KEY_NAME>.pem 'ansible/<ANSIBLE_PLAYBOOK_NAME>.yml' --extra-vars 'kali'

# Este comando realiza una prueba básica de conectividad HTTP a tu redirector
# -k: Ignora errores de certificados SSL
# -s: Modo silencioso, no muestra la barra de progreso
# -v: Modo verbose, muestra detalles de la conexión
curl -k -s "http://<REDIRECTOR_DOMAIN.TLD>/Hacker-Hermanos-Rocks" -v

# Este comando configura automáticamente certificados SSL usando Let's Encrypt:
# --apache: Configura Apache automáticamente
# --post-hook: Ejecuta un comando después de obtener el certificado
# --agree-tos: Acepta los términos de servicio automáticamente
# -w: Especifica el directorio web
# -d: Especifica el dominio para el certificado
# --force-renewal: Fuerza la renovación del certificado aunque no haya expirado
sudo certbot --apache --post-hook "service apache2 restart" --agree-tos --register-unsafely-without-email -w /var/www/html/ -d <REDIRECTOR_DOMAIN.TLD> --force-renewal

# Estos comandos realizan pruebas avanzadas del redirector simulando diferentes navegadores:
# -A: Especifica el User-Agent (identifica el tipo de cliente que hace la petición)
# -H: Añade headers personalizados a la petición
# Primer ejemplo usando curl como User-Agent:
curl -k -s "https://<REDIRECTOR_DOMAIN.TLD>/Hacker-Hermanos-Rocks" -v -A "curl" -H "Hacker-Hermanos-Rocks: True"

# Segundo ejemplo simulando Mozilla Firefox como User-Agent:
curl -k -s "https://<REDIRECTOR_DOMAIN.TLD>/Hacker-Hermanos-Rocks" -v -A "Mozilla/5.0" -H "Hacker-Hermanos-Rocks: True"
```
