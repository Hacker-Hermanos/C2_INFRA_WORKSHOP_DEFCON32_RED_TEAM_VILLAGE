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
# Archivo de variables para el Rol de Ansible 'redirector'
# Este archivo define la configuración principal para un servidor redirector
# que maneja el tráfico entre dominios y servidores backend

vhosts_dictionary: [
    {
        # Configuración del primer hostname (servidor virtual)
        # Esta sección define cómo se comportará el redirector para un dominio específico
        # Dominio principal del redirector (ejemplo: ejemplo.com)
        # Este es el dominio que los usuarios legítimos utilizarán para acceder al servicio.
        # Asegúrate de que este dominio esté correctamente configurado en DNS.
        redirector_domain: 'test.evildomain.com',
        # Dominio señuelo que se mostrará a los visitantes no autorizados
        # Este dominio se utiliza para engañar a los usuarios no autorizados, 
        # redirigiéndolos a un sitio diferente. Asegúrate de que este dominio no revele información sensible.
        decoy_domain: 'www.healthcare.gov',
        # Puerto para tráfico HTTP no cifrado
        # El tráfico en este puerto no está cifrado, lo que significa que es susceptible a intercepciones.
        # Considera redirigir todo el tráfico HTTP a HTTPS para mayor seguridad.
        http_port: 80,
        # Puerto para tráfico HTTPS cifrado
        # HTTPS cifra el tráfico, protegiendo la información sensible durante la transmisión.
        # Asegúrate de tener un certificado SSL válido para este puerto.
        https_port: 443,
        # Firma del servidor que se mostrará en las respuestas HTTP
        # La firma del servidor puede revelar información sobre el software y la versión que estás usando.
        # Considera ocultar o modificar esta firma para evitar que los atacantes obtengan información útil.
        server_signature: "Microsoft-IIS/10.0",
        # Lista de servidores backend (TeamServers) que recibirán el tráfico redirigido
        # Estos son los servidores que realmente procesarán las solicitudes después de ser redirigidas.
        # Asegúrate de que estos servidores estén protegidos y que solo acepten tráfico del redirector.
        backend_teamservers: [
            {
                # Servidor de producción
                # Este es el servidor principal que maneja el tráfico en vivo.
                # Asegúrate de que esté bien protegido y monitoreado.
                name: 'TeamServer_TS0',
                vpn_ip: '100.100.100.100'
            },
        ],  # Add a comma here to separate the list items
        # Cabeceras HTTP requeridas para autenticar las peticiones legítimas
        # Estas cabeceras se utilizan para verificar que las solicitudes provienen de clientes autorizados.
        # Asegúrate de que estas cabeceras sean difíciles de adivinar y que se mantengan en secreto.
        required_http_header: [
            'Hacker-Hermanos-Is-The-Best'
            # '<ADDITIONAL_HEADER>' # Añade cabeceras adicionales según sea necesario
        ],
        # Definiciones de rutas URI que el redirector procesará
        # Estas son las rutas específicas que el redirector manejará.
        # Asegúrate de que las rutas no expongan información sensible o funcionalidades no deseadas.
        uri_path_definitions: [
            {
                # Primera definición de ruta
                # Define una ruta específica que el redirector debe manejar.
                name: 'hackerhermanos',
                path: '/hackerhermanos'
            }
            # Añade más definiciones de rutas URI según sea necesario
        ],
        # Reglas de reescritura para dirigir el tráfico a los servidores backend
        # Estas reglas determinan cómo se redirige el tráfico a los servidores backend.
        # Asegúrate de que las reglas sean precisas para evitar redirecciones incorrectas.
        rewrite_rule_filters: [
            {
                # Regla para el servidor de producción
                # Esta regla redirige el tráfico al servidor de producción.
                # Asegúrate de que el puerto y la IP sean correctos.
                rewritefilter: 'hackerhermanos',
                backend_forward_port: '4443',
                backend_teamserver: 'TeamServer_TS0'
            }
            # Añade más filtros según sea necesario
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
