# Ejercicio 1: Implementación de 1 Servidor C2 y 1 Redirector C2

## Objetivos

- Reemplaza el texto "`<REDIRECTOR_DOMAIN.TLD>`" con tu dominio
- Reemplaza el texto "`<REDIRECTOR_DOMAIN_TLD>`" con un valor representativo (sin usar '.')
- Implementa un servidor C2 usando Infraestructura como Código
- Implementa un redirector C2 usando Infraestructura como Código
- Actualiza la zona DNS con la IPv4 del redirector

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
