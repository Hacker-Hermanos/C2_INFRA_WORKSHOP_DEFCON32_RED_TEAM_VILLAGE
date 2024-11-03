# Ejercicio 3: Configura 1 Redirector C2 usando Roles de Ansible

¡Vamos a configurar nuestro Redirector C2! Sigue estos pasos emocionantes:

1. Consigue un dominio o usa uno existente para configurar un registro A con la IP de tu redirector.
2. Configura la VPN del Redirector C2 para las comunicaciones entre el servidor C2 y el redirector.
3. Configura el Redirector C2 con `apache2`:
   - Usa nuestro rol personalizado de Ansible basado en el de tevora threat:

```Bash
ansible-playbook /path/to/DEFCON32_RT_Village_workshop/Exercise_3/ansible/C2_Redirector_playbook.yml -i '<REDIRECTOR_IP>, ' --private-key /path/to/DEFCON32_RT_Village_workshop/Exercise_1/SSH-Key-*.pem --extra-vars 'kali'
```

   - Redirige el tráfico C2 a la interfaz del túnel VPN del servidor C2.

4. ¡Refuerza tu Redirector C2!:
   - Implementa rutas URI para los listeners.
   - Configura el logging:
     - Logging en directorios personalizados.
     - Trace logging para un seguimiento detallado.
   - Filtra el tráfico (usa como referencia [curi0usJack/.htaccess](https://gist.github.com/curi0usJack/971385e8334e189d93a6cb4671238b10)).
   - Soluciona problemas con estos comandos:

```Bash
cat -n /var/www/html/<REDIRECTOR_DOMAIN.TLD>/logs/*.log | grep "<SOURCE_IP>" | awk '{print $16,$17,$18,$19,$20,$21,$22,$23}'
cat -n /var/www/html/<REDIRECTOR_DOMAIN.TLD>/logs/*.log | grep "<SOURCE_IP>" | awk '{print $16,$17,$18,$19,$20,$21,$22,$23}' | grep " matched\|not-matched"
```

   - Envía tráfico de prueba:

```Bash
curl -k -s https://<REDIRECTOR_DOMAIN.TLD>/Hacker-Hermanos-Rocks -v -A "Mozilla/5.0" --header "Hacker-Hermanos-Rocks: True"
```

5. Configura los listeners del servidor C2:
   - Usa la IP VPN del Servidor C2 (aquí es donde el Redirector enviará el tráfico).
   - Define la ruta URI.
   - Establece los headers necesarios.

6. Genera los payloads y pruébalos:
   - Usa TCPDUMP para verificar:

```Bash
sudo tcpdump -i tailscale0 port 443 -nvv
```

## Retos del Ejercicio 3

1. ¿Cómo abordarías a un defensor que reproduce tráfico C2 desde una captura de paquetes?
2. ¿Cómo crearías una lista de todas las direcciones IP y CIDRs de sandboxes populares online (ej: any.run, recorded future, virustotal, crowdstrike, karspersky, defender for endpoint, etc.)?
3. Investiga y configura más Security Headers (ej: https://pentest-tools.com/blog/essential-http-security-headers) para que el redirector parezca una aplicación legítima al ser analizado. Observa los que ya están implementados, ¿eliminarías o modificarías alguno o sus valores?:

| Header | Valor | Descripción |
| --- | --- | --- |
| Strict-Transport-Security  | max-age=31536000 | Edad máxima en segundos (1 año). |
| | includeSubDomains | Aplica la regla a todos los subdominios. |
| | preload | Indica a los navegadores precargar el sitio para HSTS. |
| Content-Security-Policy    | default-src 'self' | Permite cargar recursos solo del mismo origen. |
| | script-src 'self' 'unsafe-inline' | Permite scripts del mismo origen e inline. Considera eliminar 'unsafe-inline' si es posible. |
| | style-src 'self' 'unsafe-inline' | Permite estilos del mismo origen e inline. Ajusta 'unsafe-inline' según sea necesario. |
| | img-src 'self' data: | Permite imágenes del mismo origen y URIs de datos. |
| | font-src 'self' | Permite fuentes del mismo origen. |
| | object-src 'none' | Desactiva todos los elementos object, embed y applet. |
| | frame-ancestors 'self' | Restringe los dominios que pueden incrustar la página. |
| | base-uri 'self' | Limita las URLs que se pueden usar en el elemento base. |
| | form-action 'self' | Restringe las URLs a las que los formularios pueden enviar datos. |
| X-XSS-Protection | 1; mode=block | Activa el filtro XSS y evita el renderizado si se detecta un ataque. |
| X-Frame-Options | SAMEORIGIN | Permite mostrar la página en un frame solo en el mismo origen. |
| X-Content-Type-Options | nosniff | Evita que el navegador interprete archivos como un MIME type diferente al especificado. |
| Referrer-Policy | strict-origin-when-cross-origin | Envía la URL completa solo para peticiones del mismo origen y el origen para peticiones cross-origin. |
| Content-Type | text/html; charset=utf-8 | Establece el MIME type como HTML con codificación UTF-8. |

## Glosario Técnico

- **Registro A**: Un tipo de registro DNS que mapea un nombre de dominio a la dirección IPv4 de un servidor.
- **VPN (Red Privada Virtual)**: Tecnología que crea una conexión segura y encriptada sobre una red menos segura.
- **Apache2**: Servidor web de código abierto popular y altamente configurable.
- **Ansible**: Herramienta de automatización para configurar y administrar computadoras.
- **URI (Identificador de Recursos Uniforme)**: Cadena de caracteres que identifica un recurso web.
- **Logging**: Proceso de registrar eventos y datos para análisis y troubleshooting.
- **Trace logging**: Nivel detallado de logging que captura información paso a paso.
- **.htaccess**: Archivo de configuración de Apache que permite cambios por directorio.
- **Payload**: En seguridad, código diseñado para ejecutar acciones específicas en un sistema objetivo.
- **TCPDUMP**: Herramienta de línea de comandos para analizar tráfico de red.
- **Security Headers**: Cabeceras HTTP que mejoran la seguridad de una aplicación web.
- **HSTS (HTTP Strict Transport Security)**: Mecanismo de seguridad web para proteger contra ataques de degradación de protocolo y secuestro de cookies.
- **CSP (Content Security Policy)**: Capa adicional de seguridad que ayuda a detectar y mitigar ciertos tipos de ataques.
- **MIME type**: Identificador de dos partes para formatos de archivo transmitidos por Internet.
