(extra21-22)=
# **IceFlix**: diseño de microservicios - Entrega extraordinaria

El objetivo principal del proyecto es **desarrollar un sistema distribuido
basado en microservicios**. Para ello se tomará como modelo la popular
plataforma de streaming NetFlix para crear una pequeña plataforma de
streaming bajo demanda, utilizando algunos de los servicios disponibles en
ZeroC ICE. Los objetivos principales de la práctica son:

- Familiarizarse con la invocación a métodos remotos.
- Control de eventos.
- Diseñar algoritmos tolerantes a fallos comunes en sistemas distribuidos.
- Fomentar el trabajo en equipos multidisciplinares.

## Introducción

Conocida por todos es la plataforma de *streaming* bajo demanda
**Netflix**, lo que quizás no es tan popular es la gran competencia técnica
que existe detrás, el increíble sistema distribuido que soporta el uso
simultáneo de la plataforma por millones de usuarios en todo el mundo. No
todos los detalles de su funcionamiento han sido publicados por la empresa,
sin embargo, si los suficientes para poder hacernos una idea general de su
funcionamiento.

```{figure} assets/netflix_in_aws_arch.png
Arquitectura de servicios de Netflix
```

Una colección de microservicios soporta el funcionamiento de la
plataforma: autenticación, facturación, catalogado, recodificación,
análisis y profiling de clientes (big data), etc. Estos microservicios se
ejecutan en varias regiones de AWS. Por otro lado, Netflix dispone de sus
propios servidores físicos (OCA's) que almacenan los archivos de vídeo y
están diseñados específicamente para ofrecer un gran rendimiento en tareas
de *streaming*.

Obviamente no se pretende crear una arquitectura de una complejidad
semejante, pero sí intentaremos implementar una pequeña maqueta con una
serie de microservicios que cooperarán entre sí para ofrecer video bajo
demanda de una forma similar a como lo hace la conocida plataforma. No
vamos a utilizar mecanismos de caché ni a implementar muchos de los
servicios disponibles en la plataforma real: nos centraremos en
autenticación, catalogado de medios y streaming RTSP.
