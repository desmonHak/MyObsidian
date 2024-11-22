https://www.ibm.com/docs/es/aix/7.3?topic=tuning-tcp-maximum-segment-size

# Ajuste de tamaño máximo de segmento TCP

Última actualización: 2024-08-27

Los paquetes de tamaño máximo que envía TCP pueden tener un gran impacto en el ancho de banda, ya que es más eficiente enviar el mayor tamaño de paquete posible en la red.

TCP controla este tamaño máximo, conocido como Tamaño máximo de segmento ([[MSS]]), para cada conexión TCP. Para redes de conexión directa, TCP calcula el [[MSS]] utilizando el tamaño de MTU de la interfaz de red y, a continuación, resta las cabeceras de protocolo para obtener el tamaño de los datos en el paquete TCP. Por ejemplo, Ethernet con una [[MTU]] de 1500 daría como resultado un [[MSS]] de 1460 después de restar 20 bytes para la cabecera IPv4 y 20 bytes para la cabecera TCP.

El protocolo TCP incluye un mecanismo para ambos extremos de una conexión para anunciar el MSS que se va a utilizar sobre la conexión cuando se crea la conexión. Cada extremo utiliza el campo OPTIONS en la cabecera TCP para anunciar un [[MSS]] propuesto. El [[MSS]] elegido es el más pequeño de los valores proporcionados por los dos extremos. Si un punto final no proporciona su MSS, se asumen 536 bytes, lo que es malo para el rendimiento.

El problema es que cada punto final TCP solo conoce la [[MTU]] de la red a la que está conectado. No sabe cuál es el tamaño de [[MTU]] de otras redes que pueden estar entre los dos puntos finales. Por lo tanto, TCP solo conoce el [[MSS]] correcto si ambos puntos finales están en la misma red. Por lo tanto, TCP maneja la publicidad de MSS de manera diferente dependiendo de la configuración de la red, si quiere evitar el envío de paquetes que pueden requerir que la fragmentación de IP pase por redes MTU más pequeñas.

El valor de [[MSS]] anunciado por el software TCP durante la configuración de la conexión depende de si el otro extremo es un sistema local en la misma red física (es decir, los sistemas tienen el mismo número de red) o si está en una red (remota) diferente.

- **[Hosts en la misma red](https://www.ibm.com/docs/es/ssw_aix_73/performance/hosts_same_network.html)**  
    Si el otro extremo de la conexión está en la misma red IP, el MSS anunciado por TCP se basa en la MTU de la interfaz de red local.
- **[Hosts en redes diferentes](https://www.ibm.com/docs/es/ssw_aix_73/performance/hosts_diff_networks.html)**  
    Cuando el otro extremo de la conexión está en una red remota, el TCP del sistema operativo toma como valor predeterminado la publicidad de un [[MSS]] que se determina con el método siguiente.
- **[Descubrimiento de MTU de vía de acceso TCP](https://www.ibm.com/docs/es/ssw_aix_73/performance/tcp_path_mtu_disc.html)**  
    La opción de protocolo de descubrimiento de [[MTU]] de vía de acceso TCP está habilitada de forma predeterminada en AIX. Esta opción permite que la pila de protocolos determine el tamaño mínimo de [[MTU]] en cualquier red que esté actualmente en la vía de acceso entre dos hosts y que esté controlada por la opción de red **tcp_pmtu_discover=1**.
- **[Rutas estáticas](https://www.ibm.com/docs/es/ssw_aix_73/performance/static_routes.html)**  
    Puede alterar temporalmente el valor de [[MSS]] predeterminado de 1460 bytes especificando una ruta estática a una red remota específica.
- **[Utilización de la opción tcp_mssdflt del mandato no](https://www.ibm.com/docs/es/ssw_aix_73/performance/use_tcp_mssdflt_no.html)**  
    La opción tcp_mssdflt se utiliza para establecer el tamaño máximo de paquete para la comunicación con redes remotas.
- **[Subred y la opción subnetsarelocal del mandato no](https://www.ibm.com/docs/es/ssw_aix_73/performance/subnet_subnetsarelocal_no.html)**  
    Puede utilizar la opción subnetsarelocal del mandato no para controlar cuando TCP considera que un punto final remoto es local (en la misma red) o remoto.

**Tema principal:**

[Ajuste de rendimiento de TCP y UDP](https://www.ibm.com/docs/es/ssw_aix_73/performance/tcp_udp_perf_tuning.html "Los valores óptimos de los parámetros de comunicaciones ajustables varían con el tipo de LAN, así como con las características comunicaciones-E/S del sistema predominante y los programas de aplicación. En esta sección se describen los principios globales del ajuste de comunicaciones para AIX.")