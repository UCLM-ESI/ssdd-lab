# Cliente IceFlix

A continuación, se especificarán las características que debe implementar
el cliente.

## Conexión y autenticación

El cliente debe permitir especificar el proxy del servicio `Main` que va a
utilizar. En caso de capturar un error `TemporaryUnavailable`, podría
informar al usuario. Pero debe reintentar automáticamente la conexión hasta
un máximo determinado de veces que podrá definir el usuario y que por
defecto serán 3 intentos, con una pausa de 5.0 segundos entre intentos.

Cuando la conexión esté establecida (se haya comprobado que el proxy es
válido) se debe permitir al usuario autenticarse en el sistema. Esta
autenticación no debe ser obligatoria puesto que se permite realizar
búsquedas en el catálogo de forma anónima (únicamente por nombre).

En ningún caso el cliente debe mandar la contraseña introducida por el
usuario (que tampoco se debe mostrar nunca en el cliente) sino que mandará
la representación hexadecimal de la suma SHA256 del password.

Una vez que el cliente se haya autenticado, se debe suscribir al canal que
implementa `Revocations` para detectar que su token ha caducado y, si lo
hace, renovar automáticamente el mismo.

También debe permitir cerrar la sesión del usuario para poder cambiar las
credenciales si el usuario lo desea.

Por último, el cliente mantendrá informado al usuario en todo momento de
que la conexión está establecida y de si existe una sesión iniciada.

## Búsqueda en el catálogo

Cuando el cliente se encuentre on-line, permitirá al usuario buscar títulos
por nombre o por tags. Las búsquedas por nombre se pueden realizar por
término exacto o simplemente que el título incluya la palabra de búsqueda.
La búsqueda por tags funcionará de manera similar: cuando el usuario
introduzca la lista de tags, podrá indicar si quiere los títulos cuyos tags
tengan alguno en común o tengan que estar todos.

Una vez realizada la búsqueda, si se obtienen identificadores de vuelta, el
cliente mostrará el nombre y los tags del stream referenciado por cada
identificador.

El último resultado de búsqueda que haya obtenido títulos se almacenará en
memoria de manera que el usuario pueda seleccionar alguno de los títulos
obtenidos en cualquier momento. Cuando el usuario seleccione un título, el
programa cliente deberá informar al usuario en todo momento de su selección
activa.

## Edición del catálogo

Las opciones de edición del catálogo sólo podrán utilizarse si el cliente
tiene una sesión activa en ese momento, en caso contrario se informará al
usuario que debe autenticarse. Además de tener un token válido, el usuario
deberá haber seleccionado alguno de los títulos que haya encontrado en una
búsqueda anterior; si no tiene seleccionado ningún título, el error deberá
informar al usuario de que necesita uno.

Una vez se disponga de autorización y del título que se desea editar, el
cliente debe permitir añadir tags (uno o varios) o eliminarlos.

## Reproducción de medios

Si el cliente dispone de conexión, autorización y título seleccionado, debe
permitir al usuario iniciar la reproducción del flujo. Una vez iniciado una
reproducción, el cliente seguirá funcionando con normalidad, además debe
permitir interrumpir el flujo en cualquier momento. Cuando se esté
reproduciendo un vídeo, el cliente debe informar al usuario de este hecho
de forma continua, además, debe suscribirse al canal asociado al
`StreamController` que implementa `StreamSync` para recibir los eventos
`requestAuthentication()` necesarios para continuar con la recepción del
video en caso de expiración del token.

## Operaciones administrativas

Las diferentes operaciones administrativas que están definidas para los
servicios deben poder ser utilizadas, bien en el mismo cliente a través de
un menú específico, bien en un cliente específico aparte. En ambos casos,
el token administrativo se tratará como una contraseña, no debiéndose
mostrar en pantalla. Puede ser suministrado como parámetro de
configuración.

Para la operación `StreamProvider.uploadMedia()` será necesario implementar
un sirviente de la interfaz `MediaUploader`:

- `receive()`: el servicio de stream provider llamará a esta operación para
    recibir un bloque de bytes, de como máximo, el tamaño indicado.

- `close()`:  el servicio de stream provider llamará a esta operación para
    cancelar la subida o cuando el número de bytes recibido en el último
    `receive` sea 0, para indicar que ya se ha terminado la transferencia.
