# Exercise 2: Configure 1 C2 Teamserver using Ansible Roles

## Pasos principales

- Instala y configura un framework C2 (por ejemplo, Mythic C2) en el servidor
- Actualiza los archivos `vars/main.yml` y `defaults/main.yml` del rol `Ansible_Roles/tailscale_kali` para incluir tu clave API de VPN (formato: `tskey-auth-kXXXXXXX`)
- Configura la VPN del servidor C2 para establecer las comunicaciones entre el servidor y el redirector
- Actualiza los archivos `vars/main.yml` y `defaults/main.yml` del rol `Ansible_Roles/redirector` para añadir la IP de VPN del servidor C2
- Sustituye "`<TAILSCALE_C2_VPN_IP>`" con la IPv4 de Tailscale de tu servidor C2

### Placeholders a actualizar en `Ansible_Roles/redirector/vars/main.yml`

Asegúrate de reemplazar los siguientes placeholders en el archivo `vars/main.yml` del rol `redirector`:

- `<REDIRECTOR_DOMAIN_TLD>`: Dominio principal del redirector.
- `<DECOY_DOMAIN_TLD>`: Dominio señuelo para visitantes no autorizados.
- `<HTTP_PORT>`: Puerto para tráfico HTTP no cifrado.
- `<HTTPS_PORT>`: Puerto para tráfico HTTPS cifrado.
- `<SERVER_SIGNATURE>`: Firma del servidor en las respuestas HTTP.
- `<Prod_C2_TeamServer_TS0>`: Nombre del servidor de producción. Es
- `<PROD_C2_VPN_IP>`: IP de VPN del servidor de producción. Esto asegurara que el trafico C2 sea redirigido al servidor C2 correcto y que este trafico este encriptado por la VPN.
- `<REQUIRED_HTTP_HEADER_1>`, `<REQUIRED_HTTP_HEADER_2>`: Cabeceras HTTP requeridas para autenticar peticiones. El implante de C2 debe ser configurado para enviar estas cabeceras.
- `<URI_PATH_NAME_1>`, `<URI_PATH_1>`: Definiciones de rutas URI que el redirector procesará dejando pasar el tráfico al servidor backend. El trafico C2 debe ser configurado para llamar al mismo URI path definido aquí.
- `<REWRITE_FILTER_1>`, `<BACKEND_PORT_1>`: Reglas de reescritura para dirigir el tráfico a los servidores backend.

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

### Ejecutar el playbook de Ansible

`ansible-playbook /path/to/DEFCON32_RT_Village_workshop/Exercise_2/ansible/C2_TeamServer_playbook.yml -i '<C2_SERVER_IP>, ' --private-key /path/to/DEFCON32_RT_Village_workshop/Exercise_1/SSH-Key-name.pem --extra-vars 'kali'`

## ¡Retos del Ejercicio 2!

¡Prepárate para llevar tus habilidades al siguiente nivel! Te proponemos estos emocionantes desafíos:

1. ¡Crea tu propio rol de Ansible para instalar soluciones VPN alternativas! ¿Qué tal si pruebas con Nebula VPN del equipo de Slack?

2. Desarrolla una configuración que restrinja TODO el tráfico de entrada al servidor C2, pero que aún permita la redirección del tráfico C2. ¿Qué herramienta usarías para lograrlo?

3. Mejora el rol `redirector` de Ansible para que muestre las credenciales de Mythic. ¡Será súper útil!

## ¡Retos adicionales! 🚀

¿Listo para llevar tus habilidades al siguiente nivel? Intenta estos desafíos:

1. Crea tu propio rol de Ansible para instalar soluciones VPN alternativas (¡prueba con Nebula VPN del equipo de Slack!)
2. Desarrolla una configuración que restrinja TODO el tráfico de entrada al servidor C2, manteniendo la redirección del tráfico C2. ¿Qué herramienta usarías?
3. Mejora el rol `redirector` de Ansible para que muestre las credenciales de Mythic

## Glosario Técnico

- **Rol de Ansible**: Conjunto de tareas reutilizables en Ansible que facilitan la automatización de configuraciones complejas.

- **VPN (Red Privada Virtual)**: Tecnología que crea una conexión segura y encriptada sobre una red menos segura.

- **Nebula VPN**: Solución VPN desarrollada por el equipo de Slack, enfocada en redes mesh y alta escalabilidad.

- **Tráfico de entrada**: Todo el tráfico de red que llega a un servidor o sistema desde el exterior.

- **Servidor C2 (Command & Control)**: Servidor central que controla y coordina las operaciones de seguridad, permitiendo la comunicación con los sistemas objetivo.

- **Redirección de tráfico C2**: Técnica para ocultar la ubicación real del servidor C2 utilizando servidores intermedios.

- **Mythic**: Framework C2 popular conocido por su flexibilidad y capacidades avanzadas en operaciones de seguridad.
