# Rol de Ansible para Redireccionamiento Apache

Rol de Ansible que permite implementar rápidamente un redireccionador en un servidor existente con reglas de proxy mod_rewrite y usar Let's Encrypt para obtener un certificado SSL/TLS.

Basado en [Tevora Blog](https://www.tevora.com/threat-blog/rtops-automating-redirector-deployment-with-ansible)

## Configuración de Múltiples Dominios y Reglas ReWrite

Este rol permite configurar múltiples dominios y reglas de reescritura a través del diccionario `vhosts_dictionary` en el archivo `vars/main.yml`. La estructura del diccionario es la siguiente:

```yaml
# Definición del diccionario de hosts virtuales (vhosts_dictionary)
# Este diccionario contiene la configuración para cada dominio que el redirector manejará
vhosts_dictionary: [
    {
        # Dominio principal del redirector
        # Este es el dominio que el redirector utilizará para redirigir el tráfico
        redirector_domain: '<REDIRECTOR_DOMAIN_TLD>',
        
        # Dominio señuelo
        # Este dominio se mostrará a los visitantes no autorizados
        decoy_domain: '<DECOY_DOMAIN_TLD>',
        
        # Puerto para tráfico HTTP no cifrado
        # Especifica el puerto en el que el servidor escuchará las conexiones HTTP
        http_port: <HTTP_PORT>,
        
        # Puerto para tráfico HTTPS cifrado
        # Especifica el puerto en el que el servidor escuchará las conexiones HTTPS
        https_port: <HTTPS_PORT>,
        
        # Firma del servidor
        # Esta es la firma que el servidor mostrará en las respuestas HTTP
        server_signature: "<SERVER_SIGNATURE>",
        
        # Lista de servidores backend
        # Estos son los servidores que recibirán el tráfico redirigido
        backend_teamservers: [
            {
                # Nombre del servidor de producción
                # Identificador del servidor de producción en el backend
                name: '<Prod_C2_TeamServer_TS0>',
                
                # Dirección IP del servidor de producción
                # IP del servidor de producción en la red VPN
                vpn_ip: '<PROD_C2_VPN_IP>'
            },
            {
                # Nombre del servidor de desarrollo
                # Identificador del servidor de desarrollo en el backend
                name: '<Dev_C2_TeamServer_TS1>',
                
                # Dirección IP del servidor de desarrollo
                # IP del servidor de desarrollo en la red VPN
                vpn_ip: '<DEV_C2_VPN_IP>'
            }
        ],
        
        # Cabeceras HTTP requeridas
        # Lista de cabeceras HTTP que deben estar presentes en las peticiones legítimas
        required_http_header: [
            '<REQUIRED_HTTP_HEADER_1>',
            '<REQUIRED_HTTP_HEADER_2>',
        ],
        
        # Definiciones de rutas URI
        # Lista de rutas URI que el redirector procesará
        uri_path_definitions: [
            {
                # Nombre de la primera ruta URI
                # Identificador de la primera ruta URI
                name: '<URI_PATH_NAME_1>',
                
                # Ruta de la primera URI
                # Especifica la ruta de la primera URI
                path: '<URI_PATH_1>'
            },
            {
                # Nombre de la segunda ruta URI
                # Identificador de la segunda ruta URI
                name: '<URI_PATH_NAME_2>',
                
                # Ruta de la segunda URI
                # Especifica la ruta de la segunda URI
                path: '<URI_PATH_2>'
            }
        ],
        
        # Filtros de reglas de reescritura
        # Lista de reglas de reescritura que definen cómo se redirigirá el tráfico
        rewrite_rule_filters: [
            {
                # Filtro de reescritura para la primera regla
                # Define el patrón de reescritura para la primera regla
                rewritefilter: '<REWRITE_FILTER_1>',
                
                # Puerto de reenvío del backend
                # Especifica el puerto en el que el backend recibirá el tráfico redirigido
                backend_forward_port: '<BACKEND_PORT_1>',
                
                # Servidor backend
                # Especifica el servidor backend al que se redirigirá el tráfico
                backend_teamserver: '${PROD_C2_VPN_IP}'
            },
            {
                # Filtro de reescritura para la segunda regla
                # Define el patrón de reescritura para la segunda regla
                rewritefilter: '<REWRITE_FILTER_2>',
                
                # Puerto de reenvío del backend
                # Especifica el puerto en el que el backend recibirá el tráfico redirigido
                backend_forward_port: '<BACKEND_PORT_2>',
                
                # Servidor backend
                # Especifica el servidor backend al que se redirigirá el tráfico
                backend_teamserver: '${DEV_C2_VPN_IP}'
            }
        ]
    }
]
```

Para añadir un número arbitrario de reglas de reescritura (rewrite rules), simplemente añade más objetos al array `rewrite_rule_filters` dentro de cada entrada del `vhosts_dictionary`. Cada objeto debe seguir la estructura especificada, definiendo el filtro de reescritura (`rewritefilter`), el puerto de reenvío del backend (`backend_forward_port`), y el servidor backend (`backend_teamserver`).

## Ejemplo de cómo añadir más reglas de reescritura

Aquí se muestra cómo puedes añadir más reglas de reescritura al array `rewrite_rule_filters`. Cada objeto en el array representa una regla de reescritura que define cómo se debe redirigir el tráfico. Asegúrate de seguir la estructura especificada para cada objeto.

```yaml
rewrite_rule_filters: [
    {
        # Filtro de reescritura para una ruta específica
        rewritefilter: '/ruta/especifica/',
        # Puerto de reenvío del backend
        backend_forward_port: '8080',
        # Servidor backend al que se redirigirá el tráfico
        backend_teamserver: '${PROD_C2_VPN_IP}'
    },
    {
        # Filtro de reescritura para otra ruta
        rewritefilter: '/otra/ruta/',
        # Puerto de reenvío del backend
        backend_forward_port: '8081',
        # Servidor backend al que se redirigirá el tráfico
        backend_teamserver: '${DEV_C2_VPN_IP}'
    },
    {
        # Filtro de reescritura para una tercera ruta
        rewritefilter: '/tercera/ruta/',
        # Puerto de reenvío del backend
        backend_forward_port: '8082',
        # Servidor backend al que se redirigirá el tráfico
        backend_teamserver: '${STAGING_C2_VPN_IP}'
    },
    {
        # Filtro de reescritura para una cuarta ruta
        rewritefilter: '/cuarta/ruta/',
        # Puerto de reenvío del backend
        backend_forward_port: '8083',
        # Servidor backend al que se redirigirá el tráfico
        backend_teamserver: '${TEST_C2_VPN_IP}'
    }
]
```

## Configuración de múltiples dominios

Para configurar múltiples dominios, añade nuevas entradas al array `vhosts_dictionary`. Cada entrada en el array representa la configuración para un dominio específico.

```yaml
vhosts_dictionary: [
    {
        # Dominio principal del redirector
        redirector_domain: 'dominio1.com',
        # Dominio señuelo que se mostrará a los visitantes no autorizados
        decoy_domain: 'señuelo1.com',
        # Puerto para tráfico HTTP no cifrado
        http_port: 80,
        # Puerto para tráfico HTTPS cifrado
        https_port: 443,
        # Firma del servidor que se mostrará en las respuestas HTTP
        server_signature: "Servidor1",
        # Lista de servidores backend que recibirán el tráfico redirigido
        backend_teamservers: [
            {
                # Servidor de producción
                name: 'Prod_C2_TeamServer_TS0',
                vpn_ip: '10.0.0.1'
            },
            {
                # Servidor de desarrollo
                name: 'Dev_C2_TeamServer_TS1',
                vpn_ip: '10.0.0.2'
            }
        ],
        # Cabeceras HTTP requeridas para autenticar las peticiones legítimas
        required_http_header: [
            'Header1',
            'Header2',
        ],
        # Definiciones de rutas URI que el redirector procesará
        uri_path_definitions: [
            {
                # Primera definición de ruta
                name: 'Path1',
                path: '/ruta1'
            },
            {
                # Segunda definición de ruta
                name: 'Path2',
                path: '/ruta2'
            }
        ],
        # Filtros de reglas de reescritura para dirigir el tráfico a los servidores backend
        rewrite_rule_filters: [
            {
                # Filtro de reescritura para una ruta específica
                rewritefilter: '/ruta/especifica/',
                # Puerto de reenvío del backend
                backend_forward_port: '8080',
                # Servidor backend al que se redirigirá el tráfico
                backend_teamserver: '10.0.0.1'
            },
            {
                # Filtro de reescritura para otra ruta
                rewritefilter: '/otra/ruta/',
                # Puerto de reenvío del backend
                backend_forward_port: '8081',
                # Servidor backend al que se redirigirá el tráfico
                backend_teamserver: '10.0.0.2'
            }
        ]
    },
    {
        # Configuración para un segundo dominio
        redirector_domain: 'dominio2.com',
        # Dominio señuelo que se mostrará a los visitantes no autorizados
        decoy_domain: 'señuelo2.com',
        # Puerto para tráfico HTTP no cifrado
        http_port: 80,
        # Puerto para tráfico HTTPS cifrado
        https_port: 443,
        # Firma del servidor que se mostrará en las respuestas HTTP
        server_signature: "Servidor2",
        # Lista de servidores backend que recibirán el tráfico redirigido
        backend_teamservers: [
            {
                # Servidor de producción
                name: 'Prod_C2_TeamServer_TS0',
                vpn_ip: '10.0.0.3'
            },
            {
                # Servidor de desarrollo
                name: 'Dev_C2_TeamServer_TS1',
                vpn_ip: '10.0.0.4'
            }
        ],
        # Cabeceras HTTP requeridas para autenticar las peticiones legítimas
        required_http_header: [
            'Header3',
            'Header4',
        ],
        # Definiciones de rutas URI que el redirector procesará
        uri_path_definitions: [
            {
                # Primera definición de ruta
                name: 'Path3',
                path: '/ruta3'
            },
            {
                # Segunda definición de ruta
                name: 'Path4',
                path: '/ruta4'
            }
        ],
        rewrite_rule_filters: [
            {
                # Filtro de reescritura para una ruta específica
                rewritefilter: '/ruta/especifica/',
                # Puerto de reenvío del backend
                backend_forward_port: '8080',
                # Servidor backend al que se redirigirá el tráfico
                backend_teamserver: '${PROD_C2_VPN_IP}'
            },
            {
                # Filtro de reescritura para otra ruta
                rewritefilter: '/otra/ruta/',
                # Puerto de reenvío del backend
                backend_forward_port: '8081',
                # Servidor backend al que se redirigirá el tráfico
                backend_teamserver: '${DEV_C2_VPN_IP}'
            },
            {
                # Filtro de reescritura para una tercera ruta
                rewritefilter: '/tercera/ruta/',
                # Puerto de reenvío del backend
                backend_forward_port: '8082',
                # Servidor backend al que se redirigirá el tráfico
                backend_teamserver: '${STAGING_C2_VPN_IP}'
            }
        ]
    }
]
```

## Licencia

Licencia MIT

## Información del Autor

-------

| Redes Sociales | Enlace |
| --- | --- |
| LinkedIn | [Robert Pimentel](https://LinkedIn.com/in/pimentelrobert1) |
| Github | [@pr0b3r7](https://github.com/pr0b3r7) |
| Github | [@Hacker-Hermanos](https://github.com/Hacker-Hermanos) |
