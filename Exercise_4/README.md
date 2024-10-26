# Ejercicio 4: ¡Despliega una Distribución de Red de Entrega de Contenidos (CDN de AWS CloudFront) para redirigir tráfico C2!

¡Prepárate para llevar tu infraestructura C2 al siguiente nivel! En este emocionante ejercicio, vamos a utilizar el poder de las CDN para hacer nuestro tráfico C2 aún más sigiloso. Sigue estos pasos:

1. Despliega la redirección C2 usando la CDN de CloudFront
2. Configura la redirección C2 en la CDN de CloudFront
3. Reconfigura los listeners C2 para que se comuniquen con la URL de la CDN
4. Genera payloads C2 que se conecten a la URL de la CDN

## ¡Retos del Ejercicio 4!

¿Listo para más? Intenta estos desafíos adicionales:

1. Automatiza el despliegue y configuración de Azure FrontDoor CDN para redirección C2
2. Repite el desafío #1, pero con Google CDN
3. Ahora hazlo con Fastly
4. ¿Qué tal con CloudFlare?
5. Implementa la redirección usando funciones serverless en el proveedor de nube que prefieras
6. Modifica el Terraform de este ejercicio para usar un bucket S3 de AWS como almacén del archivo de estado. Investiga y comprende por qué mantener un archivo de estado local no es recomendable y cuáles son los riesgos asociados.

## Glosario Técnico

- **CDN (Red de Entrega de Contenidos)**: Sistema de servidores distribuidos que entrega contenido web basándose en la ubicación geográfica del usuario, mejorando la velocidad y confiabilidad.
- **AWS CloudFront**: Servicio de CDN rápido y altamente seguro de Amazon Web Services, ideal para distribuir contenido con baja latencia y altas velocidades de transferencia.
- **Redirección C2**: Técnica para ocultar la ubicación real del servidor de comando y control (C2) utilizando intermediarios como CDNs.
- **Listeners C2**: Componentes del servidor C2 que esperan y procesan las conexiones entrantes de los agentes desplegados.
- **Payload C2**: Código o datos que se envían a un sistema comprometido para establecer comunicación con el servidor C2.
- **Azure FrontDoor**: Servicio de CDN y balanceo de carga de Microsoft Azure, similar a CloudFront pero con características específicas de Azure.
- **Google CDN**: Solución de CDN de Google Cloud Platform, que ofrece entrega de contenido rápida y segura a nivel global.
- **Fastly**: CDN de alto rendimiento conocida por su capacidad de configuración avanzada y baja latencia.
- **CloudFlare**: Proveedor de CDN y servicios de seguridad web, popular por su protección contra DDoS y su red global.
- **Funciones Serverless**: Modelo de ejecución de código donde el proveedor de nube gestiona la infraestructura, permitiendo a los desarrolladores centrarse solo en el código.
- **Terraform**: Herramienta de infraestructura como código que permite definir y provisionar recursos de infraestructura de forma declarativa.
- **Bucket S3**: Servicio de almacenamiento de objetos de Amazon Web Services, útil para almacenar y recuperar cualquier cantidad de datos.
- **Archivo de Estado de Terraform**: Archivo que Terraform usa para mantener un seguimiento de los recursos gestionados y su estado actual.
