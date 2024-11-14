# Exercise 2: Configura el Servidor C2 "Teamserver" utilizando roles de Ansible

## Pasos principales

- Actualiza el archivo `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ansible_Roles/tailscale_kali/vars/main.yml` del rol `tailscale_kali` para incluir tu clave API de VPN (formato: `tskey-auth-kXXXXXXX`)
- Instala y configura un framework C2 (por ejemplo, Mythic C2) en el servidor usando el rol de Ansible `mythic_kali` a traves del playbook `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_2/ansible/C2_TeamServer_playbook.yml`. Ejemplo sobre como correr el playbook esta en la seccion debajo "`Ejecutar el playbook de Ansible`". Alternativamente, puedes usar los roles de Ansible `sliver_kali` o `cobaltstrike` (necesitarias una licencia valida) para utilizar otros marcos de trabajo (frameworks) de comando y control.
- Configura la VPN del servidor C2 para establecer las comunicaciones entre el servidor y el redirector utilizando el rol de Ansible `tailscale_kali` a traves del playbook `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_2/ansible/C2_TeamServer_playbook.yml`. Ejemplo sobre como correr el playbook esta en la seccion debajo "`Ejecutar el playbook de Ansible`". Ejemplo de la seccion `backend_teamservers` en el archivo `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ansible_Roles/redirector/vars/main.yml` del rol `redirector` donde debemos anadir la IP de VPN del servidor C2 (nota: tambien podriamos usar una IPv4 publica, pero esto no es recomendado dado que no es tan seguro como encriptar el trafico con una VPN como hacemos en este ejercicio):
    - Tenemos que actualizar los valores de dos atributos: `name` y `vpn_ip` (con la IPv4 de Tailscale de tu servidor C2) dentro de la "llave" `backend_teamservers`:
    - Por ejemplo, referirse al archivo `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejemplos/main.yml` para ver un ejemplo de como debemos actualizar el rol `redirector`:

```json
[...]
        backend_teamservers: [
            {
                # Servidor de producción
                # Este es el servidor principal que maneja el tráfico en vivo.
                # Asegúrate de que esté bien protegido y monitoreado.
                name: 'TeamServer_TS0',
                vpn_ip: '100.119.62.116'
            },
        ],
[...]
```

- Continua actualizando los siguientes valores "placeholder" en el archivo `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ansible_Roles/redirector/vars/main.yml` del rol `redirector`. Si tienes alguna duda, consulta la seccion `Ejemplo del archivo de variables en Ansible_Roles/redirector/vars/main.yml` que esta justo debajo de esta lista:

    - `<REDIRECTOR_DOMAIN.TLD>`: Dominio principal del redirector.
    - `<DECOY_DOMAIN.TLD>`: Dominio señuelo para visitantes no autorizados.
    - `<HTTP_PORT>`: Puerto para tráfico HTTP no cifrado. Solamente es necesario actualizar este valor si vamos a utilizar un canal de comunicacion HTTP para el C2 (sino, dejarlo con el valor por defecto `80` funciona).
    - `<HTTPS_PORT>`: Puerto para tráfico HTTPS cifrado. Aqui debemos actualizarlo con el puerto que utilizaremos para el C2. Por defecto esta en `443` pero podemos utilizar cualquier otro puerto para recibir trafico HTTPS en el servidor C2.
    - `<SERVER_SIGNATURE>`: Firma del servidor en las respuestas HTTP. Esto se utiliza para confundir a los atacantes, escaneres de red (e.g., `nmap`), etc haciendo el servidor de redireccion aparecer como que esta corriendo un servidor web diferente al que es. Si este valor no se actualiza, el rol de Ansible `redirector` no va a funcionar correctamente y fallara al correr el playbook. Adicionalmente, por defecto, esta en `Apache 2.X` pero podemos utilizar cualquier otra firma que queramos (e.g., `Microsoft-IIS/10.0`).
    - `<Prod_C2_TeamServer_TS0>`: Nombre del servidor de producción. Esta direccion IPv4 es donde el servidor de comando y control (C2) esta corriendo esperando conexiones entrantes desde el implante de C2.
    - `<PROD_C2_VPN_IP>`: IP de VPN del servidor de producción. Esto asegurara que el trafico C2 sea redirigido al servidor C2 correcto y que este trafico este encriptado por la VPN.
    - `<REQUIRED_HTTP_HEADER_1>`, `<REQUIRED_HTTP_HEADER_2>`: Cabeceras HTTP requeridas para autenticar peticiones. El implante de C2 debe ser configurado para enviar estas cabeceras. Si no se configuran estas cabeceras, el redirector va a mandar el trafico al dominio de señuelo.
    - `<URI_PATH_NAME_1>`, `<URI_PATH_1>`: Definiciones de rutas URI que el redirector procesará dejando pasar el tráfico al servidor backend. El implante de C2 debe ser configurado para pedir esta ruta URI. Si no se configuran esta(s) ruta(s), el redirector va a mandar el trafico al dominio de señuelo.
    - `<REWRITE_FILTER_1>`, `<BACKEND_PORT_1>`: Reglas de reescritura para dirigir el tráfico a los servidores backend. Estas reglas dictan la logica que Apache utilizara para redirigir el trafico al servidor backend. Esta misma logica es la que utilizamos para redireccionar el trafico C2 hacia el dominio de señuelo si el trafico no cumple con las caracteristicas que hemos definido (e.g., cabeceras HTTP, User-Agent, ruta de URI, etc). ***Nota: Se pueden configurar muchas mas! Recomendamos consultar la documentacion de Apache para entender todas las opciones disponibles.***

### Ejemplo del archivo de variables en Ansible_Roles/redirector/vars/main.yml

```yaml
---
vhosts_dictionary: [
    {
        redirector_domain: 'test2.robertepimentel.com',
        decoy_domain: 'www.hackerhermanos.com',
        http_port: 80,
        https_port: 443,
        server_signature: "Microsoft-IIS/10.0",
        backend_teamservers: [
            {
                name: 'TeamServer_TS0',
                vpn_ip: '100.110.58.28'
            },
        ],
        required_http_header: [
            'Hacker-Hermanos-Is-The-Best'
        ],
        uri_path_definitions: [
            {
                name: 'hackerhermanos',
                path: 'hackerhermanos'
            }
        ],
        rewrite_rule_filters: [
            {
                rewritefilter: 'hackerhermanos',
                backend_forward_port: '4443',
                backend_teamserver_bind_ip_variable: 'TeamServer_TS0'
            }

        ]
    }
]
```

### Ejecutar el playbook de Ansible

```bash
cd /ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_2/ansible

ansible-playbook /ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_2/ansible/C2_TeamServer_playbook.yml -i '<C2_SERVER_IP>, ' --private-key /ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_1/SSH-Key-name.pem --extra-vars 'kali'

```

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

- **Playbook de Ansible**: Conjunto de tareas que se ejecutan en un servidor para configurar y desplegar aplicaciones o servicios. Puede contener una o mas roles de Ansible.

- **VPN (Red Privada Virtual)**: Tecnología que crea una conexión segura y encriptada sobre una red menos segura.

- **Nebula VPN**: Solución VPN desarrollada por el equipo de Slack, enfocada en redes mesh y alta escalabilidad.

- **Tráfico de entrada**: Todo el tráfico de red que llega a un servidor o sistema desde el exterior.

- **Servidor C2 (Command & Control)**: Servidor central que controla y coordina las operaciones de seguridad, permitiendo la comunicación con los sistemas objetivo.

- **Redirección de tráfico C2**: Técnica para ocultar la ubicación real del servidor C2 utilizando servidores intermedios.

- **Mythic**: Framework C2 popular conocido por su flexibilidad y capacidades avanzadas en operaciones de seguridad.
