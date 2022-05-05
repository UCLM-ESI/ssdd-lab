# Uso de canales de eventos

Como se menciona en el apartado anterior, todos los servicios hacen un uso
u otro de canales de eventos. Para ello, debe utilizarse el servicio
proporcionado por ZeroC Ice llamado **IceStorm**.

Además de los eventos ya mencionados en la descripción de cada uno, todos
los servicios necesitarán realizar anunciamientos para que el resto del
sistema conozca su existencia.

## Canal de descubrimiento de servicios

Todas las instancias de todos los servicios deben ser capaz de enviar y
recibir eventos definidos por la interfaz `ServiceAnnouncements` de la
interfaz slice:

- `newService()`: se emitirá una única vez cuando una instancia es
    iniciada, de modo que otras instancias del mismo servicio sepan que
    existe una nueva réplica.

- `announce()`: se emitirá periódicamente para comunicar que la instancia
    sigue funcionando. Debe emitirse dentro de una horquilla de tiempo
    entre 8 y 12 segundos.

Cuando una instancia existente recibe un evento `newService`, debe
reaccionar conectando directamente con la nueva instancia para enviarle
una base de datos actualizada a través de una llamada directa al método
`updateDB` que poseen aquellos servicios dotados de algún tipo de base
de datos (persistente o no).

1. El servicio arranca y envía al canal de anunciamientos un evento "new
    service", que servirá para intentar encontrar instancias del mismo
    servicio que estén funcionando previamente.

1. Dependiendo de si existen instancias anteriores:
    1. Si existen, todas las instancias enviarán un mensaje de
        actualización de base de datos al nuevo servicio.

    1. Si no existe ninguno, pasados 3 segundos la nueva instancia asumirá
        que es la primera y pasará al punto siguiente.

1. El servicio comenzará a anunciarse normalmente a través de eventos
    "announce".

```{figure} assets/service_start_no_other_services.png
Diagrama de secuencia de anunciamiento inicial cuando no hay otros
servicios activos
```

```{figure} assets/service_start_current_exists.png
Diagrama de secuencia de anunciamiento inicial cuando hay otros servicios
activos previamente
```

Para facilitar la implementación, se proporciona un código de ejemplo en
el [repositorio plantilla][1] que puede ser usado libremente. Dicha
implementación incluye tanto una clase encargada de realizar la
publicación de los eventos de anunciamiento como la encargada de
recibirlos y mantener una estructura de datos en memoria de los servicios
encontrados.

[1]: https://github.com/SSDD-2021-2022/template-ssdd-lab
