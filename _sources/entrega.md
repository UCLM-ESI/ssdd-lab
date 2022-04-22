# La entrega

Se entregará un único fichero comprimido en zip o tar.gz a través de la
plataforma de **Campus Virtual**. La estructura interna del archivo queda
a decisión de los estudiantes, pero deberá seguir al menos las siguientes
reglas: 

- `run_iceflix`: debe estar en la raíz del directorio del proyecto y debe
    ejecutar una instancia de todos y cada uno de los microservicios que
    forman el sistema. El fichero debe ser ejecutable.

- `run_client`: debe estar en la raíz del directorio del proyecto y debe
    lanzar el programa cliente. El fichero debe ser ejecutable.

- `CODEOWNERS`: debe estar en la raíz del directorio del proyecto y debe
    incluir la lista de miembros del equipo, uno por línea, comenzando por
    el carácter `#`. También debe incluir en la última línea un `*` seguido
    de los nombres de usuario en GitHub de los componentes del equipo.

- `README.md`: debe estar en la raíz del directorio del proyecto. Será un
    pequeño documento en lenguaje [Markdown][1] que explicará paso a paso
    cómo reproducir un medio y cómo editar su nombre y tags. Ejemplo de
    formato del fichero podría ser: 

    ```
    Ejecutar “run_iceflix” 
    Ejecutar “run_client” 
    Seleccionar <conectar> e introducir el proxy del servicio IceFlix::Main() 
    Seleccionar <autenticar> e introducir usuario y contraseña 
    Seleccionar <buscar> e introducir “ejemplo” 
    Seleccionar primer resultado de búsqueda pulsando “1” 
    Seleccionar <reproducir> 
    ```

    También debe incluir, bajo el título, la URL al repositorio del
    proyecto, así como cualquier otra información relevante del proyecto
    que el equipo considere oportuno.

Para poder probar la práctica de manera directa, se puede incluir un
archivo de vídeo de no más de 5MB a modo de ejemplo. De ser así, dicho
vídeo **deberá estar en el directorio `resources`**.

Es muy importante seguir las indicaciones sobre la entrega de manera exacta
ya que parte del proceso de evaluación se realiza de forma automática, por
eso los nombres de fichero deben ser exactamente los indicados
anteriormente.

Para facilitar la creación de esta estructura, se proporciona un
repositorio plantilla [template-ssdd-lab][2] que incluye todos los ficheros
anteriores, además de algunos ficheros de configuración, ejemplos de
implementación y utilidades para crear un programa instalable Python.

Adicionalmente a la evaluación automática también, realizará un análisis
estático de código con `pylint`[3]. Se considera que el estilo es correcto
si obtiene como mínimo un **9.0** de puntuación global.

```{note}
ATENCIÓN: Si tenéis miembros en el equipo que utilicen Windows, tened en
cuenta que los retornos de línea deben ser TIPO UNIX. Si se utilizan los
retornos tipo DOS la práctica no funcionará en el entorno de pruebas.
```

## Documentación de entrega 

No se solicitará memoria de prácticas ni documentación adicional en la
entrega. La evolución del proyecto se consultará con el historial de
commits de GIT. Por tanto, no se recomienda subir la práctica en uno o dos
commits. El repositorio debe tener commits de todos los miembros del
equipo.

## Defensa de prácticas 

La defensa de la práctica es **obligatoria**. Si algún grupo o alguno de
sus miembros, no se presentara, la práctica se considerará
**no presentada**.

Cada grupo que presente la práctica será convocado por uno de los
profesores de prácticas a una hora específica para revisar la práctica con
ellos y ejecutarla.

Se hará especial hincapié en ello en los siguientes casos:

- Repositorio con muy pocos commits o sin commits de algún miembro.
- El buscador de plagios alerte sobre dos o más entregas.

Una vez publicadas las notas, los alumnos tendrán derecho a revisión si no
estuvieran de acuerdo.

[1]: https://www.markdownguide.org/cheat-sheet/
[2]: https://github.com/SSDD-2021-2022/template-ssdd-lab
[3]: https://pylint.pycqa.org/en/latest/
