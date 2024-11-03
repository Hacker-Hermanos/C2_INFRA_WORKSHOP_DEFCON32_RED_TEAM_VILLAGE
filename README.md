# ¡Domina la Automatización de Infraestructura C2!

¿Listo para revolucionar tu forma de implementar infraestructura C2? En esta sesión práctica, te mostraremos cómo dominar la implementación de frameworks C2, redirectores y toda la infraestructura necesaria.

Descubrirás cómo la infraestructura como código te permite crear despliegues C2 robustos y seguros, eliminando errores manuales y ahorrando tiempo valioso.

[¡Revisa las diapositivas aquí!](https://docs.google.com/presentation/d/16QZhyyeSVlAqNl6Lin2Es68pUtSRrxMj/edit?usp=drive_link&ouid=113544216782604326804&rtpof=true&sd=true)

![](./DC32_C2_Infrastructure.png)

## ¿Qué aprenderás?

- Dominarás cada componente de la infraestructura C2 y su interacción
- Crearás despliegues C2 automatizados y seguros
- Implementarás infraestructura como código para lograr despliegues consistentes
- Aplicarás las mejores prácticas de seguridad operacional
- Diseñarás arquitecturas C2 escalables y mantenibles

## Lo que cubriremos

- Una vista práctica de los componentes clave
- Arquitectura detallada y su implementación
- Seguridad desde el primer momento:
  - Control total del tráfico entrante
  - Gestión segura de accesos SSH/RSA
  - Túneles VPN para mayor seguridad
  - Aislamiento completo del servidor C2 post-configuración
- Escalabilidad sin complicaciones:
  - Aprovecha el poder de `count` en Terraform para multiplicar tus recursos EC2

## Ejercicios Detallados

### Ejercicio 1: Implementación de 1 Servidor C2 y 1 Redirector C2

- **Objetivos**: Aprende a reemplazar dominios en configuraciones, implementar servidores y redirectores C2 usando Infraestructura como Código, y actualizar zonas DNS.
- **Retos**: Aumenta el número de redirectores con Terraform, maneja múltiples dominios con Apache, y configura Terraform para usar un bucket S3 como almacén de estado.

### Ejercicio 2: Configura 1 C2 Teamserver usando Roles de Ansible

- **Pasos principales**: Instala y configura un framework C2, actualiza configuraciones de VPN, y utiliza Ansible para automatizar la configuración del servidor C2.
- **Retos**: Crea roles de Ansible para VPNs alternativas, desarrolla configuraciones de tráfico restrictivas, y mejora la visibilidad de credenciales en roles de Ansible.

### Ejercicio 3: Configura 1 Redirector C2 usando Roles de Ansible

- **Pasos**: Configura un redirector C2 con Apache, implementa logging y filtrado de tráfico, y refuerza la seguridad del redirector.
- **Retos**: Aborda la detección de tráfico C2, crea listas de IPs de sandboxes, y configura headers de seguridad para mejorar la legitimidad del redirector.

### Ejercicio 4: Despliega una CDN de AWS CloudFront para redirigir tráfico C2

- **Pasos**: Utiliza AWS CloudFront para redirigir tráfico C2, reconfigura listeners y genera payloads que se conecten a la CDN.
- **Retos**: Automatiza despliegues de CDN en múltiples plataformas, implementa redirección con funciones serverless, y utiliza un bucket S3 para el estado de Terraform.

## Prepara tu entorno

¡Asegúrate de tener todo listo antes de empezar!

- Si usas macOS o Linux, configura una VM Windows. [Descárgala aquí](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/)
- Instala Terraform - [Guía rápida de instalación](https://developer.hashicorp.com/terraform/install?ajs_aid=27f06833-e61f-422f-9656-921b533a86bb&product_intent=terraform)
- Configura tus credenciales AWS:
  - [Crea tus claves de acceso](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey)
  - [Configúralas en tu sistema](https://docs.aws.amazon.com/cli/v1/userguide/cli-authentication-user.html#cli-authentication-user-configure.title)
- Obtén tu clave Tailscale para el rol de Ansible - [Instrucciones aquí](https://tailscale.com/kb/1085/auth-keys)

## Glosario Técnico

- **Servidor C2 (Command & Control)**: Herramienta central en pruebas de penetración para gestionar operaciones de seguridad.
- **Redirector C2**: Componente que oculta la ubicación del servidor C2, mejorando la seguridad operacional.
- **Infraestructura como Código (IaC)**: Gestión de infraestructura mediante código, usando herramientas como Terraform.
- **DNS (Sistema de Nombres de Dominio)**: Traduce nombres de dominio a direcciones IP.
- **Apache**: Servidor web configurable para operaciones C2.
- **Terraform**: Herramienta de IaC para definir y crear infraestructura en la nube.
- **Bucket S3**: Almacenamiento en la nube de AWS para guardar el estado de Terraform.
- **CDN (Red de Entrega de Contenidos)**: Sistema de servidores para entregar contenido web rápidamente.
- **AWS CloudFront**: CDN de Amazon para distribuir contenido con baja latencia.
- **Listeners C2**: Componentes que procesan conexiones entrantes en un servidor C2.
- **Payload C2**: Código enviado a sistemas comprometidos para comunicación con el servidor C2.
- **Ansible**: Herramienta de automatización para configurar y administrar sistemas.
- **VPN (Red Privada Virtual)**: Conexión segura y encriptada sobre una red menos segura.
- **Security Headers**: Cabeceras HTTP que mejoran la seguridad de una aplicación web.
