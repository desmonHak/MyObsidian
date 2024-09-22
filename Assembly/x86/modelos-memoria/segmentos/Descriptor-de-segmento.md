https://wiki.osdev.org/Global_Descriptor_Table
véase también [[registros-segmento-selectores-segmento]], [[GDT]], [Segmentation](https://wiki.osdev.org/Segmentation "Segmentation"), [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 2D, 3A, 3B, 3C, 3D, and 4](https://www.intel.com/content/www/us/en/content-details/782158/intel-64-and-ia-32-architectures-software-developer-s-manual-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4.html?wapkw=intel%2064%20and%20ia-32%20architectures%20software%20developer%27s%20manual&docid=782161)

[[Descriptor-de-segmento]]:
![[Pasted image 20240905185326.png]]
Son **estructuras de datos** que se encuentran en la [[GDT]], [[LDT]] o [[IDT]] y **que describen los segmentos**. 
- ``Base`` (``32 bits``). un valor de 32 bits que contiene la dirección lineal donde comienza el segmento.
- `Limit` Tamaño del segmento (``20 bits``) que indica la unidad máxima direccionable, ya sea en unidades de `1 byte` o en páginas de `4 KiB`. Por lo tanto, si elige la granularidad de página y establece el valor de Límite en `0xFFFFF`, el segmento abarcará todo el espacio de direcciones de `4 GiB` en el modo de **`32 bits`**.
	 _**En el modo de 64 bits, los valores de `Base` y `Limit` se ignoran, cada descriptor cubre todo el espacio de direcciones lineal independientemente de lo que se establezca**_.

	Para obtener más información, consulte la `Sección 3.4.5`: `Descriptores de segmento y la Figura 3-8`: `Descriptor de segmento del Manual del desarrollador de software de Intel, Volumen 3-A`.

- `G`(`Granularity flag`): Indicador de granularidad, indica el tamaño en el que se escala el valor **Límite**.
	- Si ``G=0`` se mide en ``byte`` (``0..1 Mb``). 
	- Si ``G=1`` se mide en bloques de ``4 kb`` (``0..4Gb``). 
		- Su tamaño variará con el direccionamiento de ``32 bits`` (``D/B=1``) o de ``16 bits`` (``D/B=0``) 
		- Dependerá de si se expande hacia arriba (``TYPE.E=1``) o de si se expande hacia abajo (``TYPE.E=0``)
		- (Se ignoran los ``12 bits`` menos significativos del offset). Si ``Límite=0`` los ``offsets`` ``0.. 4095`` son válidos.
	
**Access Byte**

| 7                          | 6...5                                   | 4                              | 3                         | 2                                        | 1                                     | 0                       |
| -------------------------- | --------------------------------------- | ------------------------------ | ------------------------- | ---------------------------------------- | ------------------------------------- | ----------------------- |
| **P**<br>(Present-segment) | **DPL**<br>(Descriptor Privilege Level) | **S**<br>(Descriptor type bit) | **E**<br>(Executable bit) | **DC**<br>(Direction bit/Conforming bit) | **RW**<br>(Readable bit/Writable bit) | **A**<br>(Accessed bit) |
- `DPL` (``Descriptor Privilege Level``). Nivel de privilegio del segmento. No se puede acceder al segmento si no se tiene suficiente privilegio o está conformado. ([CPU Privilege level](https://wiki.osdev.org/Security#Rings "Security")) 0 = privilegio más alto (`kernel`), 3 = privilegio más bajo (aplicaciones de usuario). ^1e145d
- `A`(`Accessed bit`) Bit de acceso. La CPU lo establecerá cuando se acceda al segmento, a menos que se establezca en **1** de antemano. Esto significa que, en caso de que el descriptor [[GDT]] se almacene en páginas de **solo lectura** y este **bit se establezca en **0**, la `CPU` que intente establecer este bit activará una __falla de página__. Es mejor dejarlo establecido en **1** a menos que sea necesario.
- `E`(`Executable bit`): Bit ejecutable. 
	- `E=`**0** el descriptor define un segmento de datos.  ^eddd92
	- `E=`**1** define un segmento de código desde el cual se puede ejecutar.
- `DC` `Direction bit/Conforming bit`.
	- Para selectores de datos: `bit de dirección`(`Direction bit`). 
		- `DC=`(**0**), el segmento crece hacia arriba. 
		- `DC=`(**1**), el segmento [crece hacia abajo](https://wiki.osdev.org/Expand_Down "Expand Down"), es decir, el **Offset** tiene que ser mayor que el **Limit**.
	- Para selectores de código: `bit de conformidad`(`Conforming bit).
		- `DC=`(**0**) el código en este segmento solo se puede ejecutar desde el anillo(`ring`) establecido en **DPL**.
		- `DC=`(1) el código en este segmento se puede ejecutar desde un nivel de privilegio **igual o inferior**. 
		 Por ejemplo, el código en el [[ring-3]] puede realizar un salto lejano(`jmp far`) al código _conforme_ en un segmento del [[ring-2]]. El campo **DPL** representa el nivel de privilegio más alto que se permite para ejecutar el segmento. Por ejemplo, el código en el `ring 0` no puede realizar un salto lejano(`jmp far`) a un segmento de código conforme donde **DPL**`=2`, mientras que el código en los `ring 2 y 3` sí puede. Tenga en cuenta que el nivel de privilegio sigue siendo el mismo, es decir, un salto lejano(`jmp far`) desde el [[ring-3]] a un segmento con un **DPL**`=2` **permanece en el [[ring-3]] después del salto**.
- ``P`` (``Present-segment``). Indica si el segmento está (``=1``) o no (``=0``) en memoria. **Permite un sistema de memoria virtual basado en la segmentación**.
- ``D/B`` (``Default Operation Size/Default Stack Size``)  Indicador de tamaño.
		- (``=1``) Direccionamiento ``32 bits`` y usa ``ESP``. define un segmento de [[modo-protegido]] de `32 bits`. Un [[GDT]] puede tener selectores de `16 y 32 bits` a la vez.
		- (``=0``) Direccionamiento de ``16 bits`` y usa ``SP``. define un segmento de [[modo-protegido]] de `16 bits`.
		
- ``AVL`` (``Available to software``)
- `S` (`Descriptor type bit`)
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
- `L`(`Long-mode`)Indicador de código de [[modo-largo]]. 
	- `L=`(**1**), el descriptor define un segmento de código de 64 bits. Cuando está activado, **DB** debe estar siempre vacío. 
	- `L=`(0). Para cualquier otro tipo de segmento (otros tipos de código o cualquier segmento de datos), debe estar vacío (**0**).

### Descriptores de segmentos del sistema. Cuando S=0
![[Pasted image 20240905190800.png]]
Para los segmentos de sistema, como los que definen un segmento [[TSS]] (`segmento de estado de tarea`**[Task State Segment](https://wiki.osdev.org/Task_State_Segment "Task State Segment")**) o una [[LDT]](`tabla de descriptores locales`**[Local Descriptor Table](https://wiki.osdev.org/Local_Descriptor_Table "Local Descriptor Table")**), el formato del byte de acceso difiere ligeramente, **con el fin de definir distintos tipos de segmentos de sistema en lugar de segmentos de código y datos**.

Para obtener más información, consulte la **Sección 3.5: Tipos de descriptores del sistema** y la Figura 3-2: **System-Segment and Gate-Descriptor Types**(`Tipos de segmentos del sistema y descriptores de puerta`) del `Manual del desarrollador de software Intel`, `Volumen 3-A`.

### Access Byte

| 7     | 6...5   | 4     | 3...0    |
| ----- | ------- | ----- | -------- |
| **P** | **DPL** | **S** | **Type** |
- **Type:**  Tipo de segmento del sistema.

Tipos disponibles en [[modo-protegido]] de `32 bits`:
- **0x1:** `16-bit` [[TSS]] (_Disponible_)
- **0x2:** [[LDT]]
- **0x3:** `16-bit` [[TSS]] (_Ocupado_)
- **0x9:** `32-bit` [[TSS]] (_Disponible_)
- **0xB:** `32-bit` [[TSS]] (_Ocupado_)

Tipos disponibles en [[modo-largo]]:
- **0x2:** [[LDT]]
- **0x9:** `64-bit` [[TSS]] (_Disponible_)
- **0xB:** `64-bit` [[TSS]] (_Ocupado_)

# Descriptor de Segmento de Sistema en [[modo-largo]]
[[TSS]] (`segmento de estado de tarea`**[Task State Segment](https://wiki.osdev.org/Task_State_Segment "Task State Segment")**) o una [[LDT]](`tabla de descriptores locales`**[Local Descriptor Table](https://wiki.osdev.org/Local_Descriptor_Table "Local Descriptor Table")**) en [[modo-largo]], el formato de un [[Descriptor-de-segmento]] difiere para asegurar que el valor `Base` pueda contener una **Dirección Lineal** de `64 bits`. Ocupa el espacio en la tabla de dos entradas habituales, en formato `little endian`, de forma que la mitad inferior de esta entrada precede a la mitad superior en la tabla.

Para más información, véase el apartado 8.2.3: **[[TSS]] Descriptor in 64-bit Mode**(Descriptor [[TSS]] en modo de `64 bits`) y la Figura 8-4: **Format of [[TSS]] and [[LDT]] Descriptors in 64-bit Mode**(Formato de los descriptores [[TSS]] y [[LDT]] en modo de `64 bits`) del `Intel Software Developer Manual`, `Volume 3-A`. 

Descriptor de segmento del sistema `64-bit`. ^6c0bd8

| 127....96 | 95....64 | 63...56               | 55...52              | 51...48                | 47...40                    | 39...32               | 31...16              | 15...0                |
| --------- | -------- | --------------------- | -------------------- | ---------------------- | -------------------------- | --------------------- | -------------------- | --------------------- |
| Reserved  | **Base** | **Base**  <br>31...24 | **Flags**  <br>3...0 | **Limit**  <br>19...16 | **Access Byte**  <br>7...0 | **Base**  <br>23...16 | **Base**  <br>15...0 | **Limit**  <br>15...0 |


