https://wiki.osdev.org/Segmentation

# Introducción
### Segmentación (https://wiki.osdev.org/Segmentation)
Permite aislar código, datos y pila de cada programa de forma que no puedan interferirse. **No se puede deshabilitar**.

### Paginación 
Permite implementar un sistema de memoria virtual bajo demanda de páginas de forma que el entorno de ejecución de un programa quede mapeado en memoria tal como se necesite. Es opcional. 

Si no se usa la paginación, el espacio de direcciones lineales coincide con el espacio de direcciones físicas. 

**La segmentación soporta la memoria virtual definiendo un espacio de direcciones lineales mucho más grande que el espacio de direcciones físicas**. ``64 Terabytes`` de direcciones virtuales ``((2^14)*(2^32)=(2^46))`` frente a ``2^32`` de dir. Físicas.

Con la paginación cada segmento se divide en páginas (típ. ``4kb``) que se almacenan en memoria y disco. El S.O. mantiene un directorio de páginas y unas tablas de páginas para seguir la pista a las páginas. Al acceder a una dirección lineal, ésta se convierte en física. Si la página que incluye esa dirección no está en memoria física, se interrumpe la ejecución (fallo de página) para leerla del disco y continuar. El intercambio de páginas (``swapping``) es transparente a la ejecución de los programas.

![[Pasted image 20240905183811.png]]

# Desarrollo
### [[Modelo-plano]]
Es un espacio de direcciones no segmentado. 
Necesita al menos de dos [[descriptores-de-segmento]] (``código`` y ``datos``) que tendrán un tamaño de ``4Gb`` cada uno empezando ambos en la dirección ``0``.

#### [[Modelo-plano-protegido]] 
Funciona igual solo que si intentamos acceder a posiciones de memoria física no presentes, generará una excepción.
![[Pasted image 20240905184131.png]]![[Pasted image 20240905184209.png]]
[[Modelo-multi-segmentado]] 
Los segmentos son privados y del tamaño justo, aunque también pueden ser compartidos. Cada tarea tiene su conjunto de segmentos. 

Se vigila si nos salimos de los segmentos y se puede prohibir realizar determinadas acciones en algunos segmentos (solo ``lectura``, ``niveles de protección``).

# Direcciones lineales, lógicas y físicas
### [[Direcciones-Físicas]] 
En [[modo-protegido]] se dispone de ``4Gb`` o ``2**32 bytes`` de espacio de direcciones físicas (**las que se ponen en el bus de direcciones**). Puede estar ocupado con memoria (``RAM``, ``ROM``) y/o con ``Entrada/Salida``. A partir de [[Pentium-Pro CR4.PAE=1]] activa ``una extensión del direccionamiento físico``, conocido como [[PAE]] que permite direccionar hasta ``64Gb`` (``2^36``).

### [[Direcciones-Lógicas-y-Lineales]]
La **dirección lógica o virtual** se compone de un **selector de segmento** **y de un desplazamiento**. El **selector de segmento indexa en la [[GDT]]** (**o en la [[LDT]] actua**l) un descriptor de segmento. Una vez comprobado que el desplazamiento está en los límites del segmento y que tengamos nivel de privilegio suficiente para acceder **se le suma la dirección base y se obtiene la dirección lineal**. Para ``pasar de la dirección lineal a la dirección física está el mecanismo de la paginación``.
![[Pasted image 20240905184820.png]]

# Selectores-descriptores-de-segmento
### [[Selectores-de-segmento]] véase [[registros-segmento-selectores-segmento]]
El índice selecciona una de las ``8192`` (``2^14``) entradas (``máximo``) de la [[GDT]] y [[LDT]]. El indicador de tabla selecciona la tabla (se usará [[GDTR]] o [[LDTR]]). **[[RPL]] será el nivel de privilegio solicitado para acceder al segmento**. La **primera entrada de la [[GDT]]** se usa como **selector de segmento NULO**. Si intentamos acceder al segmento apuntado por él se producirá una excepción.
![[Pasted image 20240905185250.png]]
### [[Registros de segmento]] véase [[registros-segmento-selectores-segmento]]
[[CS]], [[DS]], [[ES]], [[FS]], [[GS]], [[SS]] de ``16 bits``. **Disponen de una parte oculta (``caché``) para acelerar las referencias a memoria**.
![[Pasted image 20240905185326.png]]

### [[Descriptor-de-segmento]].
Son **estructuras de datos** que se encuentran en la [[GDT]], [[LDT]] o [[IDT]] y **que describen los segmentos**. 
- Límite Tamaño del segmento (``20 bits``). 
	- Si ``G=0`` se mide en ``byte`` (``0..1 Mb``). 
	- Si ``G=1`` se mide en bloques de ``4 kb`` (``0..4Gb``). 
	- Su tamaño variará con el direccionamiento de ``32 bits`` (``D/B=1``) o de ``16 bits`` (``D/B=0``) 
	- Dependerá de si se expande hacia arriba (``TYPE.E=1``) o de si se expande hacia abajo (``TYPE.E=0``)
	- ``Base`` (``32 bits``).
	- ``S (=1)`` Indica descriptor de segmento. 
	- ``S (=0)`` Descriptor de segmento del sistema.
	- ``TYPE`` 
		- ``S=1, BIT11 = 0 ``
			- Se trata de un ___segmento de DATOS___  ![[Pasted image 20240905190201.png]]
				- ``A`` ``Accesed``. Se ha accedido al segmento (``=1``).
				- ``W`` ``Write Enable``. Se puede escribir en el segmento (``=1``). 
				- ``E`` ``Expansion Direction``. (``=1``) ``Down``. Se trata de un segmento de pila. (``=0``) ``Up``. Se trata de un segmento de datos convencional. 
		- ``S=1, BIT11 = 1 ``
			- Se trata de un ___segmento de CÓDIGO___![[Pasted image 20240905190208.png]]
				- ``A`` ``Accesed``. Se ha accedido al segmento (``=1``). El S.O. lo usa y lo borra. 
				- ``R`` ``Read Enable``. Se puede leer su contenido además de ejecutarlo (``=1``). 
				- ``C`` ``Conforming``. Las transferencias de ejecución a segmentos conformados (``=1``) se pueden hacer manteniendo el nivel de privilegio actual.
	- ``DPL`` (``Descriptor Privilege Level``). Nivel de privilegio del segmento. No se puede acceder al segmento si no se tiene suficiente privilegio o está conformado. ^d48e9a
	- ``P`` (``Present-segment``). Indica si el segmento está (``=1``) o no (``=0``) en memoria. **Permite un sistema de memoria virtual basado en la segmentación**.
	- ``D/B`` (``Default Operation Size/Default Stack Size``) 
		- (``=1``) Direccionamiento ``32 bits`` y usa ``ESP``. 
		- (``=0``) Direccionamiento de ``16 bits`` y usa ``SP``
	- ``G`` (``Granularity``) 
		- (``=0``) Límite medido en ``bytes``. 
		- (``=1``) Límite medido en bloques de ``4 kb``. 
		 (Se ignoran los ``12 bits`` menos significativos del offset). Si ``Límite=0`` los ``offsets`` ``0.. 4095`` son válidos.
	- ``AVL`` (``Available to software``)
	![[Pasted image 20240905190659.png]]
### Descriptores de segmentos del sistema. Cuando S=0
![[Pasted image 20240905190800.png]]

# [[Paginación]] (memoria virtual)

^cd416f

El espacio de direcciones lineal se divide en páginas (``4 kb``) que se mapean en memoria física y disco. La paginación traduce la dirección lineal en dirección física. Si la página no está en memoria, se produce una excepción de fallo de página y se intercambia una página entre memoria y disco([[Swapping]]). 
Para agilizar la traducción se dispone de los [[TLB]]’s que mantienen la traducción para las entradas recientemente accedidas. **Sólo habrá una penalización temporal si no se encuentra en la [[TLB]]**, en cuyo caso se accede a un directorio de páginas y a una tabla de páginas.

### Opciones en paginación 
[[CR0.PG]] : ``Activa la paginación`` 
[[CR4.PSE]] : Activa páginas de ``4Mb`` (o ``2 Mb`` si [[CR4.PAE=1]]) 
[[CR4.PAE]] : Activa direccionamiento físico de ``36 bits`` conocido como [[PAE]].

### Traducción de páginas de ``4kb`` 
``1024 entradas directorio * 1024 entradas tabla`` = ``2^20`` páginas de ``4 kb`` (=``4Gb``)
![[Pasted image 20240905191245.png]]
### Traducción de páginas de 4Mb 
[[CR4.PSE=1]] (``Extensión activada``) 
#### ``PS=1`` (``entrada del directorio de pág``.) 
Indica página grande (``4Mb`` o ``2Mb``) 
``1024 entradas directorio = 1024 páginas de 4Mb (=4Gb).`` 
Se pueden mezclar las páginas de ``4kb`` y ``4Mb`` en el mismo directorio de páginas. 
#### Base de directorio de páginas 
En [[CR3]] ([[PDBR]]) se almacena la dirección física donde se encuentra el directorio de páginas. La página de`` 4kb`` donde está contenido el directorio de páginas debe encontrarse en memoria antes de que [[CR3]] apunte a ella.
![[Pasted image 20240905191514.png]]
![[Pasted image 20240905191526.png]]
### Formato de las entradas 
- ``Base``: ``Dirección física`` (múltiplo de ``4kb`` o ``4Mb``) 
- ``P``: ``Present``. Indica si la página está o no en memoria. 
	- Si no está -> **fallo de página**. 
	- Este bit lo modifica el S.O. La CPU sólo lo lee. 
- ``R/W``: ``Read/Write``. Sólo ``lectura (=0)``. ``Lectura/escritura (=1)``.
- ``U/S``: ``User``/``Supervisor``. Privilegio necesario para acceder: 
	- (``=0``) ring 0,1,2; 
	- (``=1``) ring 3.
- ``PWT``: ``Page-Level Write-Through``. 
	- (``=0``) Escritura continua, 
	- (``=1``) Escritura diferida. 
	- Si [[CR0.CD=1]] se ignora.
- ``PCD``: ``Page-Level Cache Disable``. 
	- (``=0``) Sin caché.
	- (``=1``) Con caché. 
	- Si [[CR0.CD=1]] se ignora este campo.
-  ``A``: ``Accesed``. **Indica si se ha accedido a la página. El ``CPU`` lo pone a uno y el S.O. lo borra**. _Permite algoritmos de descarte de páginas_
- ``D``: ``Dirty``. __Indica si se ha escrito en la página. El ``CPU`` lo pone a uno y el S.O. lo borra__.
- ``PS``: ``Page size``. Tamaño de la página apuntada: 
	- (``=0``) ``4 kb``
	- (``=1``) ``4 Mb``  si[[ CR4.PAE=0]] 
	- (``=1``) ``2Mb``    si [[CR4.PAE=1]].
- ``G``: ``Global``. Indica página global. 
	- Si [[CR4.PGE=1]] y ``G=1`` no se invalidará la entrada de esta página en la [[TLB]] ni siquiera cuando cambie [[CR3]] o se cambie de tarea. El S.O lo escribe y el ``CPU`` lo lee.
- ``AVL``: ``Available to software``.
![[Pasted image 20240905192523.png]]
# Caché de traducción de páginas ([[TLB]]).
Véase [[TLB]]

