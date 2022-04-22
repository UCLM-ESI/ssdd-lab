# El microservicio como base.

El sistema estará dividido en diferentes microservicios, cada uno encargado
de realizar una de las diferentes tareas que tiene que realizar el sistema
en su conjunto. Además, cada microservicio deberá lanzarse varias veces,
de modo que tengamos varias instancias de cada uno para aumentar la
disponibilidad de los mismos.

Esta multiplicidad de instancias de cada servicio implica que las
instancias de todos los servicios deberán conocerse entre ellas y, en
algunos casos, compartir los datos que están utilizando de manera que no
haya incoherencias entre los datos almacenados en cada instancia.

## Servicio principal

El primer microservicio actúa de entrada al sistema para los clientes. A
través de su interfaz podrá obtener referencias a otros servicios.

Para arrancar este servicio debe proporcionarse un token de
administración, que deberá ser almacenado en memoria para poder
comprobarlo en aquellas operaciones que requieren de dicho token.

Este servicio debe implementar la interfaz `Main` del fichero Slice, la
cual tiene estás funciones:

- `getAuthenticator()`: que devuelve un proxy a un servicio de
    autenticación.
- `getCatalog()`: que devuelve un proxy a un servicio de catalogo.
- `updateDB()`: recibe una base de datos actualizada de servicio
    proporcionada por otra instancia de este servicio.
- `isAdmin()`: devuelve un valor booleano para comprobar si el token
    proporcionado corresponde o no con el administrativo.

## Servicio de autenticación.

La autenticación en el servicio se gestiona a través de este servicio. El
usuario debe enviar un usuario y contraseña periódicamente, obteniendo un
token de autenticación que tendrá una validez limitada en el tiempo
(2 minutos). También proporciona la funcionalidad de comprobar si un token
es válido para el resto de servicios del sistema que necesiten verificar
la validez de un token proporcionado por un usuario.

El servicio debe almacenar en una base de datos persistente (no
necesariamente debe ser SQL) las credenciales de los usuarios. Los tokens,
por su naturaleza temporal, no deben aparecer en ese almacenamiento
persistente.

Adicionalmente proporciona al administrador la funcionalidad de añadir y
eliminar usuarios.

Dicho servicio implementa la interfaz `Authenticator`:

- `refreshAuthorization()`: crea un nuevo token de autorización de usuario
    si las credenciales son válidas.

- `isAuthorized()`: indica si un token dado es válido o no.
- `whois()`: permite descubrir el nombre del usuario a partir de un token
    válido.

- `addUser()`: función administrativa que permite añadir unas nuevas
    credenciales en el almacén de datos si el token administrativo es
    correcto.

- `removeUser()`: función administrativa que permite eliminar unas
    credenciales del almacén de datos si el token administrativo es
    correcto.

- `updateDB()`: recibe una base de datos actualizada de servicio
    proporcionada por otra instancia de este servicio.

### Comunicación entre instancia del servicio de autenticación

Cada instancia del servicio de autenticación puede generar diferentes
eventos para comunicar al resto de instancias del servicio. Es importante
tanto que estos eventos se generen correctamente como que sean tratados al
recibirlos.

Dichos eventos pueden venir de dos canales de eventos diferentes,
representados por las interfaces `UserUpdates` y `Revocations`:

- `UserUpdates.newUser)=`: se emitirá cuando un nuevo usuario sea creado
    por el administrador.

- `UserUpdates.newToken()`: se emitirá cuando un usuario llame
    satisfactoriamente a la función refreshAuthorization y un nuevo token
    sea generado.

- `Revocations.revokeUser()`: se emitirá cuando el administrador elimine
    un unusuario del sistema.

- `Revocations.revokeToken()`: se emitirá cuando un token expire pasados
    los 2 minutos de validez.

## Servicio de catálogo

El servicio de catálogo proporciona a los usuarios acceso al catálogo y a
la reproducción de los medios disponibles en la aplicación.

Para ello, debe disponer de un almacén de datos persistente de acceso
único para la instancia del servicio en ejecución, dónde se almacenará
información relativa a los medios: identificador, nombre asignado al medio
por el administrador, y los tags asignados por cada usuario del sistema,
si las hubiera.

El servicio debe recibir información desde los proveedores de streaming
(explicados más adelante) para poder ofrecer a la aplicación de usuario un
proxy para poder acceder a cada medio.

El servicio debe implementar la interfaz `MediaCatalog`:

- `getTile()`: permite realizar la búsqueda de un medio conocido su
    identificador.

- `getTilesByName()`: permite realizar una búsqueda de medios usando su
    nombre.

- `getTilesByTags()`: permite realizar búsquedas de medios en función de
    los tags definidos por el usuario.

- `addTags()`: permite añadir una lista de tags a un medio concreto.

- `removeTags()`: permite eliminar una lista de tags de un medio concreto.
    Los tags que no existan se ignorarán.

- `renameTile()`: operación de administración que permite renombrar un
    determinado medio en la base de datos.

- `updateDB()`: recibe una estructura de datos con toda la base de datos
    existente en una instancia que estuviera funcionando anteriormente.

### Comunicación entre instancia del servicio de catálogo

Las instancias del servicio de catálogo deben enviar actualizaciones entre
ellas para mantener la coherencia de los datos almacenados. Dicha
comunicación se realizará a través del canal de eventos representado por
la interfaz `CatalogUpdates`:

- `renameTile()`: se emitirá cuando el administrador modifique el nombre
    de un medio en una instancia.

- `addTags()`: se emitirá cuando un usuario añada satisfactoriamente tags
    a algún medio.

- `removeTags()`: se emitirá cuando un usuario elimine satisfactoriamente
    tags de algún medio.

## Servicio de *streaming*

El servicio de *streaming* se encarga de enviar al usuario lo necesario
para que pueda acceder a un medio. El servicio debe leer de un directorio
en el disco duro los ficheros que serán compartidos por *streaming*.

La transmisión de vídeo está fuera del ámbito de la práctica, por lo que
se proporciona el código necesario para implementar tanto el servidor como
el cliente del flujo de vídeo.

El servicio deberá anunciar al servicio de catálogo (a todas sus
instancias) cada archivo alojado en esa instancia del servicio de
*streaming*. Para ello se utilizará un canal de eventos asociado a la
interfaz `StreamAnnouncements`.

- `newMedia()`: será emitido por cada instancia cuando se encuentre un
    nuevo fichero o sea subido uno nuevo por el administrador.

- `removedMedia()`: se emitirá cuando un fichero sea eliminado de una
instancia por el administrador.

El identificador de un medio, utilizado tanto por el servicio de
*streaming* como por el catálogo, se calculará en función del contenido
del fichero, de modo que si 2 instancias almacenan sendas copias del mismo
fichero, el identificador calculado será igual en ambas. Para ello, puede
utilizarse la suma SHA256 del fichero.

El servicio implementa la interfaz `StreamProvider`:

- `getStream()`: genera en la instancia un sirviente de la interfaz
    `StreamProvider` que podrá ser utilizado para acceder al medio.

- `isAvailable()`: comprueba si la instancia tiene el medio requerido
    disponible.

- `reannounceMedia()`: hace que la instancia vuelva a anunciar, a través
    del canal de eventos explicado anteriormente, sus medios disponibles.

- `uploadMedia()`: permite al administrador subir un nuevo medio al
    servicio.

- `deleteMedia()`: permite al administrador eliminar un medio del
    servicio.

Cuando un usuario solicita reproducir un vídeo a través de la operación
`getStream`, el servicio generará un sirviente de la interfaz
`StreamController` único para ese medio y usuario. Dicho sirviente deberá
ser eliminado del adaptador de objetos y olvidado por completo una vez el
usuario termine de utilizarlo.

Las operaciones disponibles en la interfaz son:

- `getSDP()`: devuelve la cadena de conexión para reproducir el streaming
    del fichero.

- `getSyncTopic()`: devuelve el nombre de un canal de eventos generado a
    propósito para que el cliente pueda recibir eventos relacionados con
    la reproducción. Dicha comunicación se explicará más adelante.

- `refreshAuthentiation()`: dado que los tokens de autenticación expiran
    cada 2 minutos, permiten al usuario enviar su token renovado para
    evitar ser expulsado de la reproducción. Si el usuario no cumpliera
    con la actualización de su token, el servicio de envío del medio
    debería detenerse y dar por finalizado el streaming.

- `stop()`: permite al usuario detener la reproducción y liberar los
    recursos.

### Comunicación entre el servicio de *streaming* y el cliente.

El servicio de *streaming* necesita comunicarse con el cliente para
solicitarle la actualización de su token de autenticación cuando sea
necesario. Para ello, cada sirviente de `StreamController` creará y
destruirá, cuando sea necesario, un canal de eventos único donde podrá
enviar éste evento a los suscriptores, cumpliendo con la interfaz
`StreamSync`:

- `requestAuthentication()`: se emitirá cuando se reciba un evento de
    token inválido desde el servicio de autenticación. Se esperarán 5
    segundos para que el cliente pueda eviar su nuevo token. Si no lo
    hace, se interrumpirá el envío del medio.
