https://es.wikipedia.org/wiki/QUIC
https://www.xataka.com/pro/quic-propuesta-google-convertida-estandar-permitira-acelerar-internet

**QUIC (Quick UDP Internet Connections o Conexiones UDP rápidas en Internet)** es un [protocolo de red](https://es.wikipedia.org/wiki/Protocolo_de_comunicaciones "Protocolo de comunicaciones") sobre la [capa de transporte](https://es.wikipedia.org/wiki/Capa_de_transporte "Capa de transporte") diseñado por Jim Roskind en [Google](https://es.wikipedia.org/wiki/Google "Google"), inicialmente implantado en 2012, y anunciado como experimento ampliado en 2013. QUIC soporta un conjunto de conexiones [multiplexadas](https://es.wikipedia.org/wiki/Multiplexaci%C3%B3n "Multiplexación") entre dos extremos sobre [UDP](https://es.wikipedia.org/wiki/User_Datagram_Protocol "User Datagram Protocol") (User Datagram Protocol), y fue diseñado para proveer seguridad equivalente a [TLS/SSL](https://es.wikipedia.org/wiki/Transport_Layer_Security "Transport Layer Security"), junto con latencia de conexión y de transporte reducidas, y estimación de [ancho de banda](https://es.wikipedia.org/wiki/Ancho_de_banda_(inform%C3%A1tica) "Ancho de banda (informática)") en cada dirección para evitar la congestión. El principal objetivo de QUIC es mejorar el rendimiento percibido de [aplicaciones web](https://es.wikipedia.org/wiki/Aplicaci%C3%B3n_web "Aplicación web") orientadas a conexión que usan actualmente [TCP](https://es.wikipedia.org/wiki/Transmission_Control_Protocol "Transmission Control Protocol"). También proporciona un entorno para la iteración rápida de algoritmos de prevención de congestión, estableciendo control en el espacio de aplicación en ambos extremos, en lugar de hacerlo en el (lento de actualizar a nivel de cliente) [espacio kernel](https://es.wikipedia.org/wiki/N%C3%BAcleo_(inform%C3%A1tica) "Núcleo (informática)").

En junio de 2015,[1](https://es.wikipedia.org/wiki/QUIC#cite_note-1)​ un borrador de trabajo (Internet Draft) sobre una especificación para QUIC fue presentado al [IETF](https://es.wikipedia.org/wiki/Grupo_de_Trabajo_de_Ingenier%C3%ADa_de_Internet "Grupo de Trabajo de Ingeniería de Internet") para su estandarización.[2](https://es.wikipedia.org/wiki/QUIC#cite_note-2)​ En 2016[3](https://es.wikipedia.org/wiki/QUIC#cite_note-3)​ se estableció un grupo de trabajo de QUIC. En octubre de 2018, los Grupos de Trabajo HTTP y QUIC del IETF decidieron conjuntamente llamar "HTTP/3" al mapeo HTTP sobre QUIC antes de convertirlo en un estándar mundial[4](https://es.wikipedia.org/wiki/QUIC#cite_note-4)​. En mayo de 2021, el IETF estandarizó QUIC en [RFC](https://es.wikipedia.org/wiki/Request_for_Comments "Request for Comments") [9000](https://datatracker.ietf.org/doc/html/rfc9000), respaldado por [RFC](https://es.wikipedia.org/wiki/Request_for_Comments "Request for Comments") [8999](https://datatracker.ietf.org/doc/html/rfc8999), [RFC](https://es.wikipedia.org/wiki/Request_for_Comments "Request for Comments") [9001](https://datatracker.ietf.org/doc/html/rfc9001) y [RFC](https://es.wikipedia.org/wiki/Request_for_Comments "Request for Comments") [9002](https://datatracker.ietf.org/doc/html/rfc9002)[5](https://es.wikipedia.org/wiki/QUIC#cite_note-5)​.

## Motivaciones y metas

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=1 "Editar sección: Motivaciones y metas")]

Se quiere reducir la latencia a lo largo de todo Internet, proporcionando un conjunto de interacciones de usuario más receptivo. A medida que pase el tiempo, el ancho de banda irá creciendo, pero el tiempo de intercambio de mensajes, al depender de la velocidad de la luz, no podrá variar en sí mismo. Por ello, se necesita un protocolo para que las peticiones, respuestas e interacciones en Internet tengan menor latencia con menores tiempos de retransmisión, algo a lo que QUIC consigue aproximarse. Los pares de direcciones IP y los sockets son recursos finitos. Un transporte multiplexado tiene el potencial de unificar el tráfico y de reducir la utilización de puertos, de unificar mensajes de reportes y respuestas y también de reducir la información redundante (en cabeceras por ejemplo). En resumen, desarrollar un protocolo que cumpla:
- Un uso extendido del mismo en todo el mundo.
- Reducir la pérdida de paquetes por bloqueo línea
- Baja latencia.
- Mejorar el soporte para móviles, en términos de latencia y eficiencia.
## Detalles

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=2 "Editar sección: Detalles")]

QUIC apunta a ser el equivalente a una conexión TCP independiente, pero con una latencia mucho más reducida (el objetivo es de 0 [RTT](https://es.wikipedia.org/wiki/Tiempo_de_ida_y_vuelta "Tiempo de ida y vuelta") en el establecimiento de la conexión) y mejor soporte de multiplexado [SPDY](https://es.wikipedia.org/wiki/SPDY "SPDY"). Si las características de QUIC demuestran efectividad, estas características podrían migrar a una versión posterior de TCP y TLS (los cuales tienen un ciclo de despliegue notablemente más largo).
### Establecimiento de conexión

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=3 "Editar sección: Establecimiento de conexión")]

Muy pocos protocolos en Internet trabajan sin al menos un intercambio de mensajes de inicialización.[6](https://es.wikipedia.org/wiki/QUIC#cite_note-6)​ La mayoría de los protocolos tienen una ronda de mensajes para TCP y otra para aquellos que también usan TLS antes de que los datos puedan empezar a ser enviados. Con QUIC una vez el cliente haya cacheado la información sobre el servidor, éste puede establecer una conexión encriptada sin intercambio de mensajes. QUIC soluciona los dos problemas más comunes por los cuales un establecimiento de conexión requiere varios intercambios.

En primer lugar, el [spoofing](https://es.wikipedia.org/wiki/Spoofing "Spoofing") de la dirección IP se soluciona de forma que el servidor envía un _token_ de dirección IP origen. No es más que una cadena de bytes opaca desde el punto de vista del cliente. Desde el punto de vista del servidor, es un bloque encriptado autenticado que contiene, al menos, la dirección IP del cliente y una [marca temporal](https://es.wikipedia.org/wiki/Marca_temporal "Marca temporal") por el servidor. Este _token_ puede ser visto como el número de secuencia en una conexión TCP. Mientras que el cliente no cambie su dirección IP o el _token_ no sea demasiado viejo, éste podrá seguirse usando de forma válida para el intercambio de información.

En segundo lugar, la protección a un [ataque de repetición](https://es.wikipedia.org/wiki/Ataque_de_REPLAY "Ataque de REPLAY") (Replay protection). Del lado del cliente, éste puede mandar un número aleatorio único (nonce) incluido en la derivación de la clave de la misma forma que lo hace TLS. En cambio para mantener una conexión sin rondas de intercambio previas, el servidor no puede realizar el mismo proceso, por lo tanto QUIC ofrece protección a este tipo de ataque únicamente después de la primera respuesta del servidor. Antes, depende de la aplicación el verificar que la información es segura. Por ejemplo, en Chrome, solo las peticiones [GET](https://es.wikipedia.org/wiki/Hypertext_Transfer_Protocol "Hypertext Transfer Protocol") son enviadas antes de una confirmación [handshake](https://es.wikipedia.org/wiki/Handshaking "Handshaking").

En resumen, la primera vez que un cliente QUIC se conecta a un servidor, el cliente debe realizar un intercambio de mensajes enviando un mensaje hello (CHLO) vacío para adquirir la información necesaria. El servidor envía entonces una respuesta rejection (REJ) con la información que el cliente necesita incluyendo el _token_ fuente de dirección y los certificados del servidor. Las próximas veces que el cliente envíe un CHLO, puede usar las credenciales cacheadas de la conexión anterior para mandar inmediatamente las peticiones encriptadas al servidor.

### Control flexible de congestión

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=4 "Editar sección: Control flexible de congestión")]

QUIC ofrece un mecanismo de control de congestión más completo que el ofrecido por TCP originalmente, lo que significa mayor información de valor. Actualmente, QUIC usa una reimplementación de TCP Cubic, aunque al ser un protocolo experimental aún se está buscando diferentes aproximaciones.[7](https://es.wikipedia.org/wiki/QUIC#cite_note-7)​

Un ejemplo de esta información extra que ofrece QUIC es que cada paquete, tanto el original como el retransmitido, llevan un número de secuencia nuevo. Esto permite al emisor de QUIC distinguir [ACKs](https://es.wikipedia.org/wiki/ACK "ACK") para transmisiones o ACKs para retransmisiones, lo que evita el problema de ambigüedad que sufre TCP en sus retransmisiones. Un ACK de QUIC también porta explícitamente el retraso sufrido desde la recepción de un paquete y el propio reconocimiento del paquete por parte del receptor. Esto último junto con los crecientes números de secuencia permite un cálculo preciso del tiempo de intercambio de mensajes (RTT).

QUIC soporta hasta unos rangos de 256 [NACK](https://es.wikipedia.org/wiki/NACK "NACK"), lo que le hace más resistente al reordenamiento de bytes que TCP, además de mantener más bytes en la transferencia cuando hay reordenamiento o pérdida de estos. Tanto cliente y servidor tienen una visión más precisa de qué paquetes ha recibido su par.

### Control de flujo a nivel de conexión y de paquetes de datos

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=5 "Editar sección: Control de flujo a nivel de conexión y de paquetes de datos")]

QUIC implementa un control de flujo de paquetes y nivel de conexión muy parecido al seguido por [HTTP/2](https://es.wikipedia.org/wiki/HTTP/2 "HTTP/2"). Funciona de la siguiente manera; el receptor informa del número total de bytes que es capaz de soportar en cada paquete de datos recibido. Durante el envío y recepción de paquetes individuales, el receptor envía paquetes de WINDOWS_UPDATE que incrementan el límite de bytes para ese flujo, permitiendo a su par enviar más datos en un mismo flujo.

Además de esta primera medida de control, QUIC implementa control de flujo a nivel de conexión para permitir cierta flexibilidad en los extremos. Es decir, si un extremo tiene un [buffer](https://es.wikipedia.org/wiki/B%C3%BAfer_de_datos "Búfer de datos") con cierta capacidad de memoria para conexión, este control de flujo proporciona a los flujos de información que se reciben las ventanas de memoria adecuadas para su tamaño dentro del límite establecido. Ejemplo: Si un servidor tiene 5 MB disponibles para cada conexión, se podría limitar de forma que permita 5 flujos de 1 MB o 500 flujos de 10 KB. Gracias a este control de flujo, esta configuración puede ser dinámica e ir variando dependiendo de los flujos que recibe.

Similar al autoajuste de la ventana de recepción en TCP, QUIC implementa un autoajuste de las ventanas de flujo tanto para conexión como para el envío de información. Este autoajuste incrementa el tamaño de la ventana de datos si se percibe una limitación en el ritmo de envío, lo que provoca un aumento de velocidad en la transmisión de datos.

### Multiplexado

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=6 "Editar sección: Multiplexado")]

HTTP/2 y TCP sufren del conocido bloqueo head-of-line. Puesto que HTTP/2 multiplexa muchos flujos de información sobre un único flujo TCP, la pérdida de un segmento TCP provoca el bloqueo de todos los segmentos siguientes hasta que se produzca una retransmisión, independientemente del flujo HTTP/2 que está encapsulado en estos segmentos.[8](https://es.wikipedia.org/wiki/QUIC#cite_note-8)​

Debido a que QUIC está diseñado desde la base para operaciones de multiplexado, los paquetes de datos perdidos de un flujo individual generalmente solo afectarán a ese flujo en particular. Cada flujo de bits puede ser enviado inmediatamente a su llegada al destino correspondiente, de forma que los flujos sin pérdidas pueden continuar para ser ensamblados y seguir adelante en la aplicación. Únicamente los bits de cabecera [HTTP](https://es.wikipedia.org/wiki/HTTP "HTTP") de QUIC pueden producir bloqueo head-of-line ya que son tratados mediante compresión de cabeceras HPACK.

### Autenticación y encriptación de la cabecera y carga útil de un paquete

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=7 "Editar sección: Autenticación y encriptación de la cabecera y carga útil de un paquete")]

Los paquetes QUIC están siempre encriptados. Aunque algunas partes de la cabecera del paquete no están encriptadas, siguen gozando de [autenticación](https://es.wikipedia.org/wiki/Autenticaci%C3%B3n "Autenticación") por el receptor lo que deniega la capacidad de inyección o de manipulación de datos por obra de terceros. QUIC protege las conexiones de la manipulación consciente o inconsciente de la información en los puntos intermedios entre los extremos de una comunicación. Como excepción, solamente los paquetes PUBLIC_RESET, cuya función es resetear una conexión, no están autenticados.[9](https://es.wikipedia.org/wiki/QUIC#cite_note-9)​

### Corrección de errores hacia delante

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=8 "Editar sección: Corrección de errores hacia delante")]

Con el objetivo de recuperar paquetes perdidos sin esperar a una retransmisión, QUIC actualmente trabaja con un esquema FEC (Forward Error Correction) sencillo basado en [XOR](https://es.wikipedia.org/wiki/Cifrado_XOR "Cifrado XOR"). En el flujo de paquetes, se envía un paquete FEC que contiene la paridad de los paquetes de un grupo determinado. Si uno de los paquetes del grupo se pierde, el contenido de este se puede recuperar del análisis del paquete FEC y del resto de paquetes del grupo. El emisor decide cuándo enviar paquetes FEC para optimizar la transmisión en distintos escenarios. Por ejemplo, al comienzo y al final de una petición.[10](https://es.wikipedia.org/wiki/QUIC#cite_note-10)

### Migración de conexión

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=9 "Editar sección: Migración de conexión")]

Las conexiones QUIC están identificadas por una ID de conexión de [64 bits](https://es.wikipedia.org/wiki/64_bits "64 bits"), generada de forma aleatoria por el cliente. QUIC puede sobrevivir a cambios de la dirección IP (al contrario que TCP) y a cambios de traducciones de [NAT](https://es.wikipedia.org/wiki/Traducci%C3%B3n_de_direcciones_de_red "Traducción de direcciones de red") ya que la ID de conexión continúa siendo la misma durante estas migraciones. QUIC también proporciona verificación criptográfica automática de un cliente migrado debido a que este cliente continúa usando la misma clave de sesión para encriptar y desencriptar paquetes.[11](https://es.wikipedia.org/wiki/QUIC#cite_note-11)​

### Tipos de paquetes y formato

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=10 "Editar sección: Tipos de paquetes y formato")]

QUIC tiene paquetes especiales y paquetes normales. Hay dos tipos de paquetes especiales: Paquetes de negociación de versión y paquetes de reset públicos. Asimismo, existen dos tipos de paquetes: Paquetes de datos y paquetes FEC. Todos los paquetes QUIC deberían ser dimensionados para encajar en una [MTU](https://es.wikipedia.org/wiki/Unidad_m%C3%A1xima_de_transferencia "Unidad máxima de transferencia") para evitar fragmentación IP. [IPv4](https://es.wikipedia.org/wiki/IPv4 "IPv4") implementa un máximo de 1370 bytes por paquete mientras que en [IPv6](https://es.wikipedia.org/wiki/IPv6 "IPv6") es de 1350 bytes.[12](https://es.wikipedia.org/wiki/QUIC#cite_note-12)​

- _**Cabecera de un paquete QUIC,**_ la cual tiene un tamaño mínimo de 2 bytes hasta 19 bytes. El formato de una cabecera es el siguiente:

1. _Flags públicos →_ Ocupa 8 bits y contiene la siguiente información: si la cabecera contiene la versión del protocolo, si es un paquete reset o no, tamaño de la ID de conexión y número de bytes de orden inferior presentes en cada paquete.
2. _ID de Conexión →_ Número aleatorio de 64 bits seleccionado por el cliente que identifica la conexión.
3. _Versión de QUIC →_ Número de 32 bits. Únicamente está presente si así lo indica el flag de versión.
4. _Número de paquete →_ Son los 8, 16, 32 o 48 bits del número de paquete, dependiendo del valor del [flag](https://es.wikipedia.org/wiki/Flag "Flag") correspondiente. Como mucho puede haber un número máximo de paquete de 64 bits.

- _**Paquetes especiales**_

1. _Paquete de negociación de versión →_ Solamente lo envía el servidor. Contiene las versiones del protocolo que el servidor soporta.
2. _Paquete de reset público →_ Contiene los flags públicos, una ID de conexión y el resto del paquete viene codificado con los datos de establecimiento de conexión.

- _**Paquetes normales**_

Están autenticados y encriptados, excepto la cabecera pública que está autenticada pero no encriptada. Tras desencriptar el contenido del paquete, el texto plano comienza con una cabecera privada. En esta cabecera privada se encuentra la información de FEC (Forward Error Correction). Tras esta cabecera tenemos el tipo de mensaje y su carga útil.

Las conexiones permanecen abiertas hasta que se vuelvan inactivas durante un período de tiempo previamente negociado. Cuando un servidor decide terminar una conexión inactiva, no se lo notifica al cliente. Hay dos maneras de terminar:[13](https://es.wikipedia.org/wiki/QUIC#cite_note-13)​

- _**Apagado explícito**_ → Un extremo envía un paquete _CONNECTION_CLOSE_ a su par iniciando así una finalización de la conexión. Antes de enviar este paquete, el extremo envía una advertencia (_GOAWAY_) avisando de que pronto se va a terminar la conexión. Una vez enviado este paquete _GOAWAY_, el extremo no aceptará más flujos de paquetes de su par.
- _**Apagado implícito**_ → El tiempo de inactividad por defecto en una conexión QUIC es de 30 segundos, mientras que el máximo es de 10 minutos (se debe especificar en el parámetro _ICSL_). Tras este tiempo de inactividad, un extremo envía un paquete _CONNECTION_CLOSE_ y finaliza la conexión.

También es posible que uno de los extremos envíe un paquete _PUBLIC_RESET_ en cualquier momento de la conexión que provocará el fin de una conexión activa. Es el equivalente a un _TCP RST_.

### Parámetros de transporte en

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=12 "Editar sección: Parámetros de transporte en")]

El handshake es responsable de negociar una variedad de parámetros de transporte para una conexión

**Parámetros requeridos**

- _SFCW_ → Da el tamaño en bytes de la ventana de control de flujo de paquetes (Stream Flow Control Window).
- _CFCW_ → Da el tamaño en bytes de la ventana de control de flujo de conexión (Connection Flow Control Window).

**Parámetros opcionales**

- _SRBF_ → Tamaño del buffer del socket del receptor en bytes (Socket receive buffer size finn bytes). El par puede querer limitar su máximo _CWND_ a algo parecido al buffer del socket del receptor. Por defecto tiene un valor de 256 Kbytes y un mínimo de 16 Kbytes.
- _TODO_ → Truncamiento del ID de conexión (Cnnection ID truncation). Si se envía por un par, indica que los ID de conexión deben ser truncados a 0 bytes. Es útil para los casos en los que un puerto del cliente es usado únicamente para una conexión.
- _COPA_ → Opciones de conexión (Connection óptimos). El campo contiene cualquier opción de conexión requerida por el cliente o el servidor. Son usados mayormente para experimentar e irán evolucionando con el tiempo.

### Códigos de error de QUIC

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=13 "Editar sección: Códigos de error de QUIC")]

- _QUIC_NO_ERROR_ → No hubo error. No es válido para mensajes de tipo RST_STREAM o CONNECTION_CLOSE.
- _QUIC_STREAM_DATA_AFTER_TERMINATION_ → Había flujos de bits que mandar tras terminar la conexión o resetearla.
- _QUIC_SERVER_ERROR_PROCESSING_STREAM_ → Hubo varios errores del servidor que detuvo el procesado del flujo.
- _QUIC_MULTIPLE_TERMINATION_OFFSETS_ → El emisor recibió dos mensajes de fin de conexión en un mismo flujo.
- _QUIC_BAD_APPLICATION_PAYLOAD_ → El emisor recibió datos de aplicación incorrectos.
- _QUIC_INVALID_PACKET_HEADER_ → El emisor recibió una cabecera de paquete no válida.
- _QUIC_INVALID_FRAME_DATA_ → El emisor recibió un flujo bits de datos, dentro de los cuales algún segmento no es válido.
- _QUIC_INVALID_FEC_DATA_ → Los datos FEC no son válidos.
- _QUIC_INVALID_RST_STREAM_DATA_ → El flujo de datos RST no es válido.
- _QUIC_INVALID_CONNECTION_CLOSE_DATA_ → Los datos de cerrar conexión no son válidos.
- _QUIC_INVALID_ACK_DATA_ → Los datos ACK no son válidos.
- _QUIC_DECRYPTION_FAILURE_ → Hubo un error al descifrar.
- _QUIC_ENCRYPTION_FAILURE_ → Hubo un error al cifrar.
- _QUIC_PACKET_TOO_LARGE_ → El paquete excedió el máximo tamaño de paquete.
- _QUIC_PACKET_FOR_NONEXISTENT_STREAM_ → Los datos fueron enviados por un flujo que no existía.
- _QUIC_CLIENT_GOING_AWAY_ → El cliente se va a desconectar. Por ejemplo, al cerrar el explorador.
- _QUIC_SERVER_GOING_AWAY_ → El servidor se va a desconectar. Por ejemplo, al reiniciar el servidor.
- _QUIC_INVALID_STREAM_ID_ → Un ID de flujo es inválido.
- _QUIC_TOO_MANY_OPEN_STREAMS_ → Hay demasiados flujos abiertos.
- _QUIC_CONNECTION_TIMED_OUT_ → Se ha llegado al límite de tiempo de inactividad prenegociado.
- _QUIC_CRYPTO_TAGS_OUT_OF_ORDER_ → El mensaje handshake contenía etiquetas desordenadas.
- _QUIC_CRYPTO_TOO_MANY_ENTRIES_ → El mensaje handshake contenía demasiadas entradas.
- _QUIC_CRYPTO_INVALID_VALUE_LENGTH_ → El mensaje handshake contenía un valor de longitud inválido.
- _QUIC_CRYPTO_MESSAGE_AFTER_HANDSHAKE_COMPLETE_ → Un mensaje con objetivos criptográficos fue enviado después del mensaje de handshake.
- _QUIC_INVALID_CRYPTO_MESSAGE_TYPE_ → Un mensaje con objetivos criptográficos fue recibido con una etiqueta de mensaje errónea.
- _QUIC_SEQUENCE_NUMBER_LIMIT_REACHED_ → Si se envía un paquete más causará que un número de paquete sea reusado.
- _ERR_QUIC_CERT_ROOT_NOT_KNOWN_ - Código de error: -380
- _ERR_QUIC_GOAWAY_REQUEST_CAN_BE_RETRIED_ - Código de error: -381
- _ERR_QUIC_HANDSHAKE_FAILED_ - Código de error: -358
- _ERR_QUIC_PROTOCOL_ERROR_ - Código de error: -356

### Prioridad

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=14 "Editar sección: Prioridad")]

QUIC usa el mecanismo de prioridad de HTTP/2. Un flujo puede depender de otro flujo. En esta situación, el flujo _“padre”_ debería ser prioritario frente al flujo _“hijo”_. Además, los flujos _“padres”_ tienen una prioridad explícita, pero no deberían priorizarse frente a otros flujos de la misma categoría.[14](https://es.wikipedia.org/wiki/QUIC#cite_note-14)​

### HTTP/2 sobre QUIC

[[editar](https://es.wikipedia.org/w/index.php?title=QUIC&action=edit&section=15 "Editar sección: HTTP/2 sobre QUIC")]

Tanto QUIC como HTTP/2 contienen características y mecanismos que comparten entre ellos, por lo que QUIC permite a los mecanismos de HTTP/2 que sustituya estos últimos por los implementados por el protocolo de transporte, reduciendo la complejidad en el protocolo HTTP/2.[15](https://es.wikipedia.org/wiki/QUIC#cite_note-15)​