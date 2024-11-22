https://es.wikipedia.org/wiki/Tamaño_Máximo_de_Segmento
El **Tamaño Máximo de Segmento** (_Maximum Segment Size_ - **MSS**) es el tamaño más grande de datos, especificado en [bytes](https://es.wikipedia.org/wiki/Byte "Byte"), que un dispositivo de comunicaciones puede recibir en un único trozo, sin fragmentar. Para una comunicación óptima la suma del número de bytes del segmento de datos y la cabecera debe ser menor que el número de bytes de la [unidad máxima de transferencia](https://es.wikipedia.org/wiki/Unidad_m%C3%A1xima_de_transferencia "Unidad máxima de transferencia") (MTU) de la red.

El MSS tiene gran importancia en las conexiones en [Internet](https://es.wikipedia.org/wiki/Internet "Internet"), particularmente en la navegación [web](https://es.wikipedia.org/wiki/World_Wide_Web "World Wide Web"). Cuando se usa el protocolo [TCP](https://es.wikipedia.org/wiki/Transmission_Control_Protocol "Transmission Control Protocol") para efectuar una conexión, los ordenadores que se conectan deben acordar y establecer el tamaño de la [MTU](https://es.wikipedia.org/wiki/Unidad_m%C3%A1xima_de_transferencia "Unidad máxima de transferencia") que ambos puedan aceptar. El valor típico de [[MTU]] en una red puede ser, por ejemplo, 576 o 1500 [bytes](https://es.wikipedia.org/wiki/Byte "Byte"). Tanto la cabecera [IP](https://es.wikipedia.org/wiki/Protocolo_de_Internet "Protocolo de Internet") como la cabecera TCP tienen una longitud variable de al menos 20 bytes, cada una. En cualquier caso, el [[MSS]] es igual a la diferencia [[MTU]] - cabecera TCP - cabecera IP.

A medida que los datos son encaminados por la red deben pasar a través de múltiples [routers](https://es.wikipedia.org/wiki/Enrutador "Enrutador"). Idealmente, cada segmento de datos debería pasar por todos los routers sin ser fragmentado. Si el tamaño del segmento de datos es demasiado grande para cualquiera de los routers intermedios, los segmentos son fragmentados. Esto aminora la velocidad de conexión, y en algunos casos esta bajada de velocidad puede ser muy apreciable. La posibilidad de que ocurra esa fragmentación puede ser minimizada manteniendo el MSS tan pequeño como sea razonablemente posible. En la mayoría de los casos, el MSS es establecido automáticamente por el [sistema operativo](https://es.wikipedia.org/wiki/Sistema_operativo "Sistema operativo").

## Valores por defecto

[[editar](https://es.wikipedia.org/w/index.php?title=Tama%C3%B1o_M%C3%A1ximo_de_Segmento&action=edit&section=1 "Editar sección: Valores por defecto")]

El tamaño máximo de segmento TCP por defecto para IPv4 es ``536``. Para IPv6 es ``1220``. Cuando un host desea establecer el tamaño máximo de segmento a un valor distinto del predeterminado, el tamaño máximo de segmento se especifica como una opción TCP, inicialmente en el paquete TCP [SYN](https://es.wikipedia.org/wiki/SYN "SYN") durante el handshake TCP. El valor no se puede cambiar una vez establecida la conexión.

## Comunicación entre capas

[[editar](https://es.wikipedia.org/w/index.php?title=Tama%C3%B1o_M%C3%A1ximo_de_Segmento&action=edit&section=2 "Editar sección: Comunicación entre capas")]

Para notificar el MSS al otro extremo, ses realiza una comunicación entre capas del siguiente modo:

- El Controlador de Red (ND) o interfaz debe conocer la Unidad Máxima de Transmisión (MTU) de la red directamente conectada.
- El IP debe preguntar al Controlador de Red por la [unidad máxima de transferencia](https://es.wikipedia.org/wiki/Unidad_m%C3%A1xima_de_transferencia "Unidad máxima de transferencia").
- El TCP debe preguntar al IP por el Tamaño Máximo de Datagrama de Datos (MDDS). Este es el [[MTU]] menos la longitud de la cabecera IP (MDDS = [[MTU]] - IPHdrLen).
- Al abrir una conexión, TCP puede enviar una opción MSS con el valor igual a: MDDS - TCPHdrLen. En otras palabras, el valor [[MSS]] a enviar es: [[MSS]] = [[MTU]] - TCPHdrLen - IPHdrLen

Mientras se envían segmentos TCP al otro extremo, se realiza una comunicación entre capas de la siguiente forma:

- TCP debe determinar el Tamaño Máximo de Segmento de Datos (MSDS) a partir del valor por defecto o del valor recibido de la opción MSS.
- TCP debe determinar si la fragmentación de la fuente es posible (preguntando a la IP) y deseable.
- Si es así, TCP puede entregar a IP, segmentos (incluyendo la cabecera TCP) hasta MSDS + TCPHdrLen.
- Si no, TCP puede entregar a IP, segmentos (incluyendo la cabecera TCP) hasta el menor de (MSDS + TCPHdrLen) y MDDS.
- IP comprueba la longitud de los datos que le pasa TCP. Si la longitud es menor o igual que MDDS, IP adjunta la cabecera IP y la entrega al ND. En caso contrario, la IP debe realizar la fragmentación en origen.
## [[MSS]] y [[MTU]]

[[editar](https://es.wikipedia.org/w/index.php?title=Tama%C3%B1o_M%C3%A1ximo_de_Segmento&action=edit&section=3 "Editar sección: MSS y MTU")]

A veces se confunde [[MSS]] con [MTU/PMTU](https://es.wikipedia.org/wiki/Unidad_m%C3%A1xima_de_transferencia "Unidad máxima de transferencia"), que es una característica de la [capa de enlace](https://es.wikipedia.org/wiki/Capa_de_enlace_de_datos "Capa de enlace de datos") subyacente, mientras que [[MSS]] se aplica específicamente a TCP y, por tanto, a la [capa de transporte](https://es.wikipedia.org/wiki/Capa_de_transporte "Capa de transporte"). Los dos son similares en el sentido que limitan el tamaño máximo de la carga útil transportada por su respectiva [unidad de datos de protocolo](https://es.wikipedia.org/wiki/Unidad_de_datos_de_protocolo "Unidad de datos de protocolo") (trama para [[MTU]], segmento TCP para [[MSS]]), y están relacionados ya que [[MSS]] no puede exceder la [[MTU]] para su enlace subyacente (teniendo en cuenta la sobrecarga de cualquier cabecera añadida por las capas por debajo de TCP). Sin embargo, la diferencia, además de aplicarse a capas diferentes, es que la [[MSS]] puede tener un valor distinto en cualquier dirección y también que las tramas que superan la [[MTU]] pueden hacer que los paquetes (que encapsulan segmentos) sean fragmentados por la [capa de red](https://es.wikipedia.org/wiki/Capa_de_red "Capa de red"), mientras que los segmentos que superan la [[MSS]] simplemente se descartan.