# Ejercicio 1: Implementación de 1 Servidor C2 y 1 Redirector C2

## Objetivos

- Reemplaza el texto "`<REDIRECTOR_DOMAIN.TLD>`" con tu dominio en los siguientes archivos:
    - `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ansible_Roles/redirector/vars/main.yml`
    - `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_4/cf_distributions.tf`
- Reemplaza el texto "`<DECOY_DOMAIN.TLD>`" con el dominio senuelo en el siguiente archivo:
    - `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ansible_Roles/redirector/vars/main.yml`
- Reemplaza el texto "`<REDIRECTOR_DOMAIN_TLD>`" con un valor representativo (sin usar '.') en el archivo:
    - `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_4/cf_distributions.tf`
- Configura las direcciones IPv4 desde las podra iniciar conexiones hacia los recursos que hemos desplegado en los pasos anteriores (despliegue de servidor C2 y redirector C2). Para esto vamos a reemplazar el texto "`X.X.X.X`" con la IPv4 publica de la red desde la que se esta conectando en el archivo:
    - `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Ejercicio_1/variables.tf`
- Despliega un servidor C2 usando Infraestructura como Código
- Despliega un redirector C2 usando Infraestructura como Código
- Guarda las direcciones IPv4 de los recursos desplegados en un archivo de texto. Deberian verse como en la seccion siguiente:

```json
C2_Redirector_IPv4 = [
  "54.225.174.242",
]
C2_TeamServer_IPv4 = [
  "52.1.124.10",
]
```

- Actualiza la zona DNS con la IPv4 del redirector

### Ejemplo de despliegue

- `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Herramientas/terrawrapper.sh --deploy --workspace C2_Infra_Workshop_Test --plan-file C2_Infra_Workshop_Test.tfplan`

### Ejemplo de retirada

- `/ruta/hacia/el/repositorio/C2_INFRA_WORKSHOP_DEFCON32_RED_TEAM_VILLAGE/Herramientas/terrawrapper.sh --destroy --workspace C2_Infra_Workshop_Test --plan-file C2_Infra_Workshop_Test.tfplan`

## Retos del Ejercicio 1

1. ¿Puedes aumentar el número de redirectores usando Terraform?
2. ¿Cómo manejarías múltiples dominios usando Apache? ¿Qué arquitectura implementarías?
3. Configura Terraform para usar un bucket S3 de AWS como almacén de estado. Investiga y comprende por qué mantener un archivo de estado local no es recomendable y cuáles son los riesgos.

## Glosario Técnico

### Servidor C2 (Command & Control)

Un servidor de comando y control es una herramienta fundamental en pruebas de penetración que permite gestionar y coordinar operaciones de seguridad simuladas. Actúa como punto central de control para las evaluaciones de seguridad.

### Redirector C2

Un componente de infraestructura que ayuda a ocultar la ubicación real del servidor C2, funcionando como intermediario entre los agentes y el servidor principal. Mejora la seguridad operacional y dificulta la detección.

### Infraestructura como Código (IaC)

Metodología que nos permite gestionar y aprovisionar infraestructura mediante código en lugar de procesos manuales. Terraform es una de las herramientas más populares para IaC.

### DNS (Sistema de Nombres de Dominio)

Sistema que traduce nombres de dominio legibles por humanos a direcciones IP. La gestión de zonas DNS es crucial para dirigir el tráfico correctamente en nuestra infraestructura.

### Apache

Servidor web de código abierto popular que podemos configurar como redirector para nuestras operaciones C2.

### Terraform

Herramienta de IaC que nos permite definir y crear infraestructura en múltiples proveedores de nube de manera consistente y reproducible.

### Bucket S3

Servicio de almacenamiento en la nube de AWS que podemos usar para guardar de manera segura y centralizada el estado de nuestra infraestructura Terraform.
