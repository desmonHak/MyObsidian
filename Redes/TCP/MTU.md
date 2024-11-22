La **unidad máxima de transferencia** (_Maximum Transmission Unit_ - **MTU**) es un término de [redes de computadoras](https://es.wikipedia.org/wiki/Red_de_computadoras "Red de computadoras") que expresa el tamaño en [bytes](https://es.wikipedia.org/wiki/Byte "Byte") de la unidad de datos más grande que puede enviarse usando un [protocolo de comunicaciones](https://es.wikipedia.org/wiki/Protocolo_de_comunicaciones).

Ejemplos de MTU para distintos protocolos usados en Internet:

- [Ethernet](https://es.wikipedia.org/wiki/Ethernet "Ethernet"): 1500 bytes
- [PPPoE](https://es.wikipedia.org/wiki/PPPoE "PPPoE"): 1492 bytes
- [ATM](https://es.wikipedia.org/wiki/Asynchronous_Transfer_Mode "Asynchronous Transfer Mode") (AAL5): 9180 bytes
- [FDDI](https://es.wikipedia.org/wiki/FDDI "FDDI"): 4470 bytes
- [PPP](https://es.wikipedia.org/wiki/Point-to-Point_Protocol "Point-to-Point Protocol"): 576 bytes

Para el caso de [IP](https://es.wikipedia.org/wiki/Protocolo_IP "Protocolo IP"), el máximo valor de la [[MTU]]s es ``64 Kilobytes`` (216 - 1). Sin embargo, ese es un valor máximo teórico, pues, en la práctica, la entidad IP determinará el máximo tamaño de los datagramas IP en función de la tecnología de red por la que vaya a ser enviado el datagrama. Por defecto, el tamaño de datagrama IP es de 576 bytes. Solo pueden enviarse datagramas más grandes si se tiene conocimiento fehaciente de que la red destinataria del datagrama puede aceptar ese tamaño. En la práctica, dado que la mayoría de máquinas están conectadas a redes Ethernet o derivados, el tamaño de datagrama que se envía es con frecuencia de 1500 bytes.

Los datagramas pueden pasar por varios tipos de redes con diferentes tamaños aceptables antes de llegar a su destino. Por tanto, para que un datagrama llegue sin fragmentación al destino, ha de ser menor o igual que el menor [[MTU]] de todas las redes por las que pase.

En el caso de TCP/UDP, el valor máximo está dado por el [[MSS]] ([Maximum Segment Size](https://es.wikipedia.org/wiki/Tama%C3%B1o_M%C3%A1ximo_de_Segmento "Tamaño Máximo de Segmento")), y toma su valor en función de tamaño máximo de datagrama, dado que el [[MTU]] = [[MSS]] + cabeceras IP + cabeceras TCP/UDP. En concreto, el máximo tamaño de segmento es igual al máximo tamaño de datagrama menos 40 (que es número mínimo de bytes que ocuparán las cabeceras IP y TCP/UDP en el datagrama).

## Posibles problemas

[[editar](https://es.wikipedia.org/w/index.php?title=Unidad_m%C3%A1xima_de_transferencia&action=edit&section=1 "Editar sección: Posibles problemas")]

Cada vez más redes bloquean el tráfico [[ICMP]] (p.ej. para evitar [ataques de denegación de servicio](https://es.wikipedia.org/wiki/Ataque_de_denegaci%C3%B3n_del_servicio "Ataque de denegación del servicio")), lo que impide que funcione el descubrimiento del [[MTU]] de la ruta. A menudo pueden detectarse estos bloqueos si la conexión funciona con un tráfico bajo de datos pero se bloquea cuando un host envía un bloque grande de datos de una vez. También, en una red IP, la ruta desde el origen al destino a menudo se modifica dinámicamente por diferentes motivos (balanceo de carga, congestión, etc.); esto puede hacer que la [[MTU]] de la ruta varíe (a veces repetidamente) durante una transmisión, lo cual puede ocasionar que los siguientes paquetes se desechen antes de que el host encuentre una nueva [[MTU]] fiable para la ruta.