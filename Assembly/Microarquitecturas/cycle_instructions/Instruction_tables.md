https://agner.org/optimize/instruction_tables.pdf
https://agner.org/optimize/

Las cifras de las tablas de instrucciones representan los resultados de mis mediciones en lugar de los valores oficiales publicados por los proveedores de microprocesadores. Algunos valores de mis tablas son mayores o menores
que los valores publicados en otros lugares. Las discrepancias se pueden explicar por los siguientes factores:
- Mis cifras son valores experimentales, mientras que las cifras publicadas por los proveedores de microprocesadores pueden estar basadas en teorías o simulaciones.
- Mis cifras se obtienen con un método de prueba particular en condiciones particulares. Es posible que se puedan obtener valores diferentes en otras condiciones.
- Algunas latencias son difíciles o imposibles de medir con precisión, especialmente para el acceso a la memoria y las conversiones de tipos que no se pueden encadenar.
- Las latencias para mover datos de una unidad de ejecución a otra se enumeran explícitamente en algunas de mis tablas, mientras que están incluidas en las latencias generales en algunas tablas publicadas por los proveedores de microprocesadores.
La mayoría de los valores son los mismos en todos los modos de microprocesador ([[Assembly/MODOS/modo-real]], [[Assembly/MODOS/modo-virtual-8086]], [[Assembly/MODOS/modo-protegido]], 16 bits, 32 bits, 64 bits([[Assembly/MODOS/modo-largo]])).
Los valores para llamadas lejanas([[JMP FAR]]) e interrupciones([[INT]]) pueden ser diferentes en distintos modos. Las puertas de llamada no han sido probadas.
Las instrucciones con un prefijo [[LOCK]] tienen una latencia larga que depende de la organización de la caché y posiblemente de la velocidad de la RAM. Si hay varios procesadores o núcleos o dispositivos de acceso directo a memoria ([[DMA]]), entonces todas las instrucciones bloqueadas bloquearán una línea de caché para acceso exclusivo, lo que puede implicar acceso a RAM. Un prefijo [[LOCK]] normalmente cuesta más de cien ciclos de reloj, incluso en sistemas de un solo procesador. Esto también se aplica a la instrucción [[XCHG]] con un operando de memoria.

### Instrucción
El nombre de la instrucción es el código ensamblador de la instrucción. Se pueden unir varias instrucciones o varias variantes de la misma instrucción en la misma línea. Las instrucciones con y sin un prefijo 'v' en el nombre tienen los mismos valores a menos que se indique lo contrario.
### Operandos
Los operandos pueden ser diferentes tipos de registros, memoria o constantes inmediatas. Las abreviaturas utilizadas en las tablas son: 
- ``i`` = constante inmediata, 
- ``r`` = cualquier registro de propósito general, 
- ``r32`` = registro de 32 bits, etc., 
- ``mm`` = registro mmx de 64 bits, 
- ``x`` o xmm = registro xmm de  128 bits, 
- ``y`` = registro ymm de 256 bits, 
- ``z`` = registro zmm de 512 bits, 
- ``v`` = cualquier registro vectorial, 
- ``sr`` = registro de segmento, 
- ``m`` = cualquier operando de memoria, incluidos los operandos indirectos, 
- ``m64`` significa operando de memoria de 64 bits, etc.
### Latencia
La latencia de una instrucción es el retraso que genera la instrucción en una cadena de dependencia. La unidad de medida son los ciclos de reloj. Cuando la frecuencia de reloj varía dinámicamente, las cifras se refieren a la frecuencia de reloj central. Los números que se muestran son valores mínimos. Los errores de caché, la desalineación y las excepciones pueden aumentar considerablemente los recuentos de reloj. Se supone que los operandos de punto flotante son números normales. Los números desnormalizados, NAN e infinitos pueden aumentar las latencias en posiblemente más de 100 ciclos de reloj en muchos procesadores, excepto en las instrucciones de movimiento, mezcla y booleanas. Los resultados de desbordamiento de punto flotante, desbordamiento insuficiente, desnormalizados o NAN pueden dar un retardo similar. Un valor faltante en la tabla significa que el valor no se ha medido o que no se puede medir de manera significativa.
Algunos procesadores tienen una unidad de ejecución segmentada que es más pequeña que el tamaño de registro más grande, de modo que las diferentes partes del operando se calculan en diferentes momentos. Supongamos, por ejemplo, que tenemos una larga cadena de dependencia de instrucciones vectoriales de 128 bits que se ejecutan en una unidad de ejecución de 64 bits completamente segmentada con una latencia de 4. Los 64 bits inferiores de cada operación se calcularán en los tiempos 0, 4, 8, 12, 16, etc. Y los 64 bits superiores de cada operación se calcularán en los tiempos 1, 5, 9, 13, 17, etc., como se muestra en la figura siguiente. 
Si observamos una instrucción de 128 bits de forma aislada, la latencia será 5. Pero si observamos una larga cadena de instrucciones de 128 bits, la latencia total será de 4 ciclos de reloj
por instrucción más un ciclo de reloj adicional al final. La latencia en este caso se indica como 4 en las tablas porque este es el valor que agrega a una cadena de dependencia.
![[Pasted image 20240914023152.png]]

El rendimiento es el número máximo de instrucciones del mismo tipo que se pueden ejecutar por ciclo de reloj cuando los operandos de cada instrucción son independientes de las instrucciones anteriores. 
Los valores que se enumeran son los recíprocos de los rendimientos, es decir, el número promedio de ciclos de reloj por instrucción cuando las instrucciones no forman parte de una cadena de dependencia limitante. Por ejemplo, un rendimiento recíproco de 2 para [[FMUL]] significa que una nueva instrucción [[FMUL]] puede comenzar a ejecutarse 2 ciclos de reloj después de una [[FMUL]] anterior. Un rendimiento recíproco de 0,33 para [[ADD]] significa que las unidades de ejecución pueden manejar 3 sumas de números enteros por ciclo de reloj. La razón para enumerar los valores recíprocos es que esto facilita las comparaciones entre latencia y rendimiento. El rendimiento recíproco también se denomina latencia de emisión. Los valores que se enumeran son para un solo subproceso o un solo núcleo. Un valor faltante en la tabla significa que el valor no se ha medido.

### μops
[[μops]] Cómo se midieron los valores ``Uop`` o [[μop]] es una abreviatura de microoperación. Los procesadores con núcleos fuera de orden son capaces de dividir instrucciones complejas en [[μops]]. Por ejemplo, una instrucción de lectura-modificación puede dividirse en una μop de lectura y una μop de modificación. La cantidad de [[μops]] que genera una instrucción es importante cuando ciertos cuellos de botella en la tubería limitan la cantidad de μops por ciclo de reloj. 

### Execution unit
Unidad de ejecución: El núcleo de ejecución de un microprocesador tiene varias unidades de ejecución. Cada unidad de ejecución puede manejar una categoría particular de [[μops]], por ejemplo, adiciones de punto flotante. La información sobre a qué unidad de ejecución va una ``μop`` en particular puede ser útil para dos propósitos. En primer lugar, dos [[μops]] no pueden ejecutarse simultáneamente si necesitan la misma unidad de ejecución. Y en segundo lugar, algunos procesadores tienen una latencia de un ciclo de reloj adicional cuando el resultado de una μop que se ejecuta en una unidad de ejecución se necesita como entrada para una μop en otra unidad de ejecución. 

### Execution port
Puerto de ejecución: Las unidades de ejecución se agrupan alrededor de unos pocos puertos de ejecución en la mayoría de los procesadores Intel. Cada ``μop`` pasa a través de un puerto de ejecución para llegar a la unidad de ejecución correcta. Un puerto de ejecución puede ser un cuello de botella porque solo puede manejar un ``μop`` a la vez. Dos [[μops]] no se pueden ejecutar simultáneamente si necesitan el mismo puerto de ejecución, incluso si van a diferentes unidades de ejecución. Conjunto de instrucciones Esto indica a qué conjunto de instrucciones pertenece una instrucción. La instrucción solo está disponible en procesadores que admiten este conjunto de instrucciones. Los conjuntos de instrucciones más importantes se enumeran en la página siguiente. La disponibilidad en procesadores anteriores a [[i80386]] no se aplica a operandos de ``32`` y ``64 bits``. La disponibilidad en el conjunto de instrucciones [[MMX]] no se aplica a instrucciones de enteros empaquetados de ``128 bits``, que requieren [[SSE2]]. 
La disponibilidad en el conjunto de instrucciones [[SSE]] no se aplica a instrucciones de punto flotante de doble precisión, que requieren [[SSE2]]. Las instrucciones de ``32 bits`` están disponibles en [[i80386]] y posteriores. Las instrucciones de ``64 bits`` en registros de propósito general solo están disponibles en sistemas operativos de ``64 bits``. Las instrucciones que utilizan registros [[XMM]] ([[SSE]] y posteriores), registros [[YMM]] ([[AVX]] y posteriores) y registros [[ZMM]] ([[AVX512]] y posteriores) solo están disponibles en sistemas operativos que admiten estos conjuntos de registros.

Los valores de las tablas se miden con el uso de mis propios programas de prueba, que están disponibles
en www.agner.org/optimize/testp.zip
La unidad de tiempo para todas las mediciones son los ciclos de reloj de la ``CPU``. Se intenta obtener la frecuencia de reloj más alta si la frecuencia de reloj varía con la carga de trabajo. Muchos procesadores Intel tienen un contador de rendimiento llamado "ciclos de reloj de núcleo". Este contador proporciona mediciones que son independientes de la frecuencia de reloj variable. Cuando no hay un contador de "ciclos de reloj de núcleo" disponible, se utiliza el "contador de marca de tiempo" (instrucción [[RDTSC]]). En los casos en que esto da resultados inconsistentes (por ejemplo, en AMD Bobcat), es necesario hacer que el procesador aumente la frecuencia de reloj ejecutando una gran cantidad de instrucciones (> 1 millón) o desactivar las funciones de ahorro de energía en la configuración del BIOS.
Los rendimientos de las instrucciones se miden con una secuencia larga de instrucciones del mismo tipo, donde las instrucciones posteriores utilizan diferentes registros para evitar la dependencia de cada instrucción de la anterior. Los registros de entrada se borran en los casos en los que es imposible utilizar registros diferentes. El código de prueba se construye cuidadosamente en cada caso para asegurarse de que no haya otro cuello de botella que limite el rendimiento además del que se está midiendo. Las latencias de las instrucciones se miden en una larga cadena de dependencia de instrucciones idénticas donde la salida de cada instrucción se utiliza como entrada para la siguiente instrucción.
La secuencia de instrucciones debe ser larga, pero no tan larga que no quepa en la caché de código de nivel 1. Una longitud típica es de 100 instrucciones del mismo tipo. Esta secuencia se repite en un bucle si se desea una mayor cantidad de instrucciones.

No es posible medir la latencia de una instrucción de lectura o escritura de memoria con métodos de software.
Solo es posible medir la latencia combinada de una escritura de memoria seguida de una lectura de memoria desde la misma dirección. Lo que se mide aquí no es en realidad el tiempo de acceso a la caché, porque en la mayoría de los casos el microprocesador es lo suficientemente inteligente como para hacer un "reenvío de almacenamiento" directamente desde la unidad de escritura a la unidad de lectura en lugar de esperar a que los datos vayan a la caché y vuelvan. La latencia de este proceso de reenvío de almacenamiento se divide arbitrariamente en una latencia de escritura y una latencia de lectura en las tablas. Pero, de hecho, el único valor que tiene sentido para la optimización del rendimiento es la suma del tiempo de escritura
y el tiempo de lectura. Un problema similar ocurre cuando la entrada y la salida de una instrucción utilizan diferentes tipos de registros. Por ejemplo, la instrucción [[MOVD]] puede transferir datos entre registros de propósito general y registros vectoriales XMM. El valor que se puede medir es la latencia combinada de la transferencia de datos de un tipo de registros a otro tipo y viceversa (``A → B → A``). 

La división de esta latencia entre la latencia ``A → B`` y la latencia ``B → A`` a veces es obvia, a veces se basa en conjeturas, recuentos de µop, evidencia indirecta o secuencias triangulares como ``A → B → Memoria → A``. En muchos casos, sin embargo, la división de la latencia total entre la latencia ``A → B`` y la latencia ``B → A`` es arbitraria. Sin embargo, lo que no se puede medir no importa para la optimización del rendimiento. Lo que cuenta es la suma de la latencia ``A → B`` y la latencia ``B → A``, no los términos individuales.
Los recuentos de ``µop`` generalmente se miden con el uso de los contadores de monitorización de rendimiento ([[PMC]]) que
están integrados en los microprocesadores modernos. Los [[PMC]] para procesadores [[VIA]] no están documentados y la interpretación de estos [[PMC]] se basa en la experimentación.

Los puertos de ejecución y las unidades de ejecución que utiliza cada instrucción o ``µop`` se detectan de distintas maneras según el microprocesador en particular. Algunos microprocesadores tienen [[PMC]] que pueden proporcionar esta información directamente. En otros casos, es necesario obtener esta información indirectamente
probando si una instrucción o ``µop`` en particular puede ejecutarse simultáneamente con otra instrucción/``µop`` que se sabe que va a un puerto de ejecución o unidad de ejecución en particular. En algunos procesadores, hay un retraso para transmitir datos de una unidad de ejecución (o grupo de unidades de ejecución) a otra. Este retraso se puede utilizar para detectar si dos instrucciones/``µop`` diferentes están utilizando la misma unidad de ejecución o unidades de ejecución diferentes.

# Explicación de los conjuntos de instrucciones para procesadores x86
- ``x86`` Este es el nombre del conjunto de instrucciones común, compatible con todos los procesadores de este linaje
- [[i80186]] Esta es la primera extensión del conjunto de instrucciones ``x86``. Nuevas instrucciones de enteros: [[PUSH]] i, [[PUSHA]], [[POPA]], [[IMUL]] r,r,i, [[BOUND]], [[ENTER]], [[LEAVE]], desplaza y rota por ≠ 1 inmediato. 
- [[i80286]] Instrucciones del sistema para el [[Assembly/MODOS/modo-protegido]] de 16 bits. 
- [[i80386]] Los ocho [[Registros]] de propósito general se extienden de ``16`` a ``32 bits``. Direccionamiento de ``32 bits``. [[Assembly/MODOS/modo-protegido]] de ``32 bits``. Direccionamiento de índice escalado. [[MOVZX]], [[MOVSX]], [[IMUL]] r,r, [[SHLD]], [[SHRD]], [[BT]], [[BTR]], [[BTS]], [[BTC]], [[BSF]], [[BSR]], [[SET]]cc. 
- [[i80486]] [[BSWAP]]. Las versiones posteriores tienen [[CPUID]]. 
- [[x87]] Este es el conjunto de instrucciones de punto flotante. Se admite cuando hay un coprocesador ``8087`` o posterior. Algunos procesadores [[i80486]] y todos los procesadores desde ``Pentium``/``K5`` tienen soporte integrado para instrucciones de punto flotante sin la necesidad de un coprocesador. 
- ``80287`` FSTSW AX 
- ``80387`` [[FPREM1]], [[FSIN]], [[FCOS]], [[FSINCOS]]. 
- ``Pentium`` [[RDTSC]], [[RDPMC]]. 
- ``PPro`` Instrucciones de movimiento condicional ([[CMOV]], [[FCMOV]]) y comparación rápida de punto flotante ([[FCOMI]]) introducidas en ``Pentium Pro``. Estas instrucciones no se admiten en Pentium [[MMX]], pero sí en todos los procesadores con [[SSE]] y posteriores. 
- [[MMX]] Instrucciones de vector entero con enteros empaquetados de`` 8, 16 y 32 bits`` en los registros [[MMX]] de ``64 bits`` [[MM0]] - [[MM7]], que tienen alias en los registros de pila de punto flotante [[ST]]``(0)`` - [[ST]]``(7)``. 
- [[SSE]] Instrucciones escalares y vectoriales de punto flotante de precisión simple en los nuevos registros [[XMM]] de ``128 bits`` [[XMM]]``0`` - [[XMM]]``7``. [[PREFETCH]], [[SFENCE]], [[FXSAVE]], [[FXRSTOR]], [[MOVNTQ]], [[MOVNTPS]]. El uso de registros [[XMM]] requiere soporte del sistema operativo.
- [[SSE2]] Instrucciones escalares y vectoriales de punto flotante de precisión doble en los registros [[XMM]] de ``128 bits`` [[XMM]]``0`` - [[XMM]]``7``. Aritmética de enteros de ``64 bits`` en los registros [[MMX]]. Instrucciones de vectores enteros con enteros empaquetados de ``8, 16, 32 y 64 bits`` en los registros [[XMM]]. [[MOVNTI]], [[MOVNTPD]], [[PAUSE]], [[LFENCE]], [[MFENCE]].
- [[SSE3]] [[FISTTP]], [[LDDQU]], [[MOVDDUP]], [[MOVSHDUP]], [[MOVSLDUP]], [[ADDSUBPS]], [[ADDSUPPD]], [[HADDPS]], [[HADDPD]], [[HSUBPS]], [[HSUBPD]]. 
- [[SSSE3]] ([[SSE3]] suplementario): [[PSHUFB]], [[PHADDW]], [[PHADDSW]], [[PHADDD]], [[PMADDUBSW]], [[PHSUBW]], [[PHSUBSW]], [[PHSUBD]], [[PSIGNB]], [[PSIGNW]], [[PSIGND]], [[PMULHRSW]], [[PABSB]], [[PABSW]], [[PABSD]], [[PALIGNR]]. 
- ``64 bit`` .   Este conjunto de instrucciones se llama ``x86-64``, ``x64``, ``AMD64`` o ``EM64T``. Define un nuevo modo de ``64 bits`` con direccionamiento de ``64 bits`` y las siguientes extensiones: 
Los registros de propósito general se extienden a ``64 bits``, y el número de registros de propósito general se extiende de ocho a dieciséis. El número de registros [[XMM]] también se extiende de ocho a dieciséis, pero el número de registros [[MMX]] y [[ST]] sigue siendo ocho. Los datos se pueden direccionar en relación con el puntero de instrucción. 
No hay forma de acceder a estas extensiones en el modo de ``32 bits`` La mayoría de las instrucciones que implican segmentación no están disponibles en el modo de ``64 bits``. No se permiten saltos ni llamadas directas, pero sí saltos indirectos, llamadas indirectas y retornos lejanos. Estos se utilizan en el código del sistema para cambiar de modo. No se pueden utilizar los registros de segmento [[DS]], [[ES]] y [[SS]]. Los segmentos [[FS]] y [[GS]] y los prefijos de segmento están disponibles en el modo de ``64 bits`` y se utilizan para direccionar bloques de entorno de subprocesos y bloques de entorno de procesador.

## Instrucciones no disponibles en modo de 64 bits 
Las siguientes instrucciones no están disponibles en modo de ``64 bits``:  [[PUSHA]], [[POPA]], [[BOUND]], [[INTO]], 
instrucciones [[BCD]]: [[AAA]], [[AAS]], [[DAA]], [[DAS]], [[AAD]], [[AAM]], instrucciones no documentadas ([[SALC]], [[ICEBP]], alias ``82H`` para código de operación ``80H``), [[SYSENTER]], [[SYSEXIT]], [[ARPL]]. En algunos procesadores Intel anteriores, [[LAHF]] y [[SAHF]] no están disponibles en modo de 64 bits. 
Las instrucciones de incremento y decremento de registro no se pueden codificar en la forma de código de operación corto de un byte porque estos códigos se han reasignado como prefijos ``REX``. 

La mayoría de las instrucciones que involucran segmentación no están disponibles en modo de ``64 bits``. No se permiten saltos lejanos directos ni llamadas, pero sí saltos lejanos indirectos, llamadas lejanas indirectas y retornos lejanos indirectos. Estos se utilizan en código de sistema para cambiar de modo. No se permiten las instrucciones [[PUSH]] [[CS]], [[PUSH]] [[DS]], [[PUSH]] [[ES]], [[PUSH]] [[SS]], [[POP]] [[DS]], [[POP]] [[ES]], [[POP]] [[SS]], [[LDS]] y [[LES]]. 
Los prefijos [[CS]], [[DS]], [[ES]] y [[SS]] están permitidos, pero se ignoran. Los segmentos [[FS]] y [[GS]] y los prefijos de segmento están disponibles en modo de ``64 bits`` y se utilizan para direccionar bloques de entorno de subprocesos y bloques de entorno de procesador. 

- [[SSE4.1]] -> [[MPSADBW]], [[PHMINPOSUW]], [[PMULDQ]], [[PMULLD]], [[DPPS]], [[DPPD]], [[BLEND]].., [[PMIN]].., [[PMAX]].., [[ROUND]].., [[INSERT]].., [[EXTRACT]].., [[PMOVSX]].., [[PMOVZX]].., [[PTEST]], [[PCMPEQQ]], [[PACKUSDW]], [[MOVNTDQA]] 
- [[SSE4.2]] -> [[CRC32]], [[PCMPESTRI]], [[PCMPESTRM]], [[PCMPISTRI]], [[PCMPISTRM]], [[PCMPGTQ]], [[POPCNT]]. 
- [[AES]] -> [[AESDEC]], [[AESDECLAST]], [[AESENC]], [[AESENCLAST]], [[AESIMC]], [[AESKEYGENASSIST]]. 
- [[CLMUL]] -> [[PCLMULQDQ]].
- [[AVX]] Los dieciséis registros [[XMM]] de ``128 bits`` se amplían a registros [[YMM]] de ``256 bits`` con espacio para una mayor ampliación en el futuro. El uso de registros [[YMM]] requiere el soporte del sistema operativo. Las instrucciones de vector de punto flotante están disponibles en versiones de ``256 bits``. Casi todas las instrucciones [[XMM]] anteriores ahora tienen dos versiones: con y sin extensión de cero en el registro [[YMM]] completo. Las versiones de extensión de cero tienen tres operandos en la mayoría de los casos. Además, se agregan las siguientes instrucciones en [[AVX]]: [[VBROADCASTSS]], [[VBROADCASTSD]], [[VEXTRACTF128]], [[VINSERTF128]], [[VLDMXCSR]], [[VMASKMOVPS]], [[VMASKMOVPD]], [[VPERMILPD]], [[VPERMIL2PD]], [[VPERMILPS]], [[VPERMIL2PS]], [[VPERM2F128]], [[VSTMXCSR]], [[VZEROALL]], [[VZEROUPPER]]. 
- [[AVX2]] Las instrucciones de vector entero están disponibles en versiones de ``256 bits``. Además, se agregan las siguientes instrucciones en [[AVX2]]: [[ANDN]], [[BEXTR]], [[BLSI]], [[BLSMSK]], [[BLSR]], [[BZHI]], [[INVPCID]], [[LZCNT]], [[MULX]], [[PEXT]], [[PDEP]], [[RORX]], [[SARX]], [[SHLX]], [[SHRX]], [[TZCNT]], [[VBROADCASTI128]], [[VBROADCASTSS]], [[VBROADCASTSD]], [[VEXTRACTI128]], [[VGATHERDPD]], [[VGATHERQPD]], [[VGATHERDPS]], [[VGATHERQPS]], [[VPGATHERDD]], [[VPGATHERQD]], [[VPGATHERDQ]], [[VPGATHERQQ]], [[VINSERTI128]], [[VPERM2I128]], [[VPERMD]], [[VPERMPD]], [[VPERMPS]], [[VPERMQ]], [[VPMASKMOVD]], [[VPMASKMOVQ]], [[VPSLLVD]], [[VPSLLVQ]], [[VPSRAVD]], [[VPSRLVD]], [[VPSRLVQ]]. 
- [[FMA3]] ([[FMA]]): Instrucciones de multiplicación y suma fusionadas: [[VFMADDxxxPD]], [[VFMADDxxxPS]], [[VFMADDxxxSD]], [[VFMADDxxxSS]], [[VFMADDSUBxxxPD]], [[VFMADDSUBxxxPS]], [[VFMSUBADDxxxPD]], [[VFMSUBADDxxxPS]], [[VFMSUBxxxPD]], [[VFMSUBxxxPS]], [[VFMSUBxxxSD]], [[VFMSUBxxxSS]], [[VFNMADDxxxPD]], [[VFNMADDxxPS]], [[VFNMADDxxxSD]], [[VFNMADDxxxSS]], [[VFNMSUBxxxPD]], [[VFNMSUBxxxPS]], [[VFNMSUBxxxSD]], [[VFNMSUBxxxSS]]. 
- [[FMA4]] Igual que Intel [[FMA]], pero con 4 operandos diferentes según una especificación preliminar de Intel que ahora solo es compatible con algunos procesadores AMD. La especificación [[FMA]] de Intel se cambió posteriormente a [[FMA3]], que ahora también es compatible con AMD.
- [[MOVBE]] [[MOVBE]] 
- [[POPCNT]] [[POPCNT]] 
- [[PCLMUL]] [[PCLMULQDQ]]
- [[XSAVE]] [[XSAVEOPT]] 
- [[RDRAND]] [[RDRAND]]
- [[RDSEED]] [[RDSEED]]
- [[BMI1]] [[ANDN]], [[BEXTR]], [[BLSI]], [[BLSMSK]], [[BLSR]], [[LZCNT]], [[TXCNT]] 
- [[BMI2]] [[BZHI]], [[MULX]], [[PDEP]], [[PEXT]], [[RORX]], [[SARX]], [[SHRX]], [[SHLX]] 
- [[ADX]] [[ADCX]], [[ADOX]], [[CLAC]]
- [[AVX512]]F Los registros [[YMM]] de ``256 bits`` se amplían a registros [[ZMM]] de ``512 bits``. El número de registros vectoriales se amplía a ``32`` en el modo de ``64 bits``, mientras que todavía hay solo 8 registros vectoriales en el modo de ``32 bits``. 8 nuevos registros de máscara vectorial ``k0 – k7``. Instrucciones vectoriales enmascaradas. Muchas instrucciones nuevas. Siempre se admiten vectores de punto flotante de precisión simple y doble. Se admiten otras instrucciones si también se admiten las diversas variantes opcionales de [[AVX512]], que se enumeran a continuación.
- [[AVX512BW]] Vectores de números enteros de ``8 bits`` y ``16 bits`` en registros [[ZMM]].
- [[AVX512DQ]] Algunas instrucciones adicionales con vectores de números enteros de ``32 bits`` y ``64 bits`` en registros [[ZMM]].
- [[AVX512VL]] Las operaciones vectoriales definidas para vectores de ``512 bits`` en los diversos subconjuntos de [[AVX512]], incluidas las operaciones enmascaradas, se pueden aplicar también a vectores de ``128 bits`` y ``256 bits``.
- [[AVX512CD]] Instrucciones de detección de conflictos 
- [[AVX512ER]] Función exponencial aproximada, raíz cuadrada recíproca y recíproca
- [[AVX512PF]] Prefetch de recopilación y dispersión
- [[SHA]] Algoritmo hash seguro 
- [[MPX]] Extensiones de protección de memoria 
- [[SMAP]] [[CLAC]], [[STAC]]
- [[CVT16]] - [[VCVTPH2PS]], [[VCVTPS2PH]].
- [[3DNow]] (``Sólo AMD. Obsoleto``). Instrucciones vectoriales de punto flotante de precisión simple en los registros [[MMX]] de ``64 bits``. Disponibles únicamente en procesadores ``AMD``. Las instrucciones [[3DNow]] son: [[FEMMS]], [[PAVGUSB]], [[PF2ID]], [[PFACC]], [[PFADD]], [[PFCMPEQ]]/[[GT]]/[[GE]], [[PFMAX]], [[PFMIN]], [[PFRCP]]/[[IT1]]/[[IT2]], [[PFRSQRT]]/[[IT1]], [[PFSUB]], [[PFSUBR]], [[PI2FD]], [[PMULHRW]], [[PREFETCH]]/W.
- [[3DNowE]] (sólo ``AMD``. Obsoleto). [[PF2IW]], [[PFNACC]], [[PFPNACC]], [[PI2FW]], [[PSWAPD]].
- [[PREFETCHW]] Esta instrucción sobrevivió de [[3DNow]] y ahora tiene su propio nombre de función.
- [[PREFETCHWT1]] [[PREFETCHWT1]]
- (sólo ``AMD``). [[EXTRQ]], [[INSERTQ]], [[LZCNT]], [[MOVNTSD]], [[MOVNTSS]], [[POPCNT]].
- [[SSE4A]] ([[POPCNT]] compartido con ``Intel`` [[SSE4.2]]).
- [[XOP]] (sólo ``AMD``. Obsoleto). [[VFRCZPD]], [[VFRCZPS]], [[VFRCZSD]], [[VFRCZSS]], [[VPCMOV]], [[VPCOMB]], [[VPCOMD]], [[VPCOMQ]], [[PCOMW]], [[VPCOMUB]], [[VPCOMUD]], [[VPCOMUQ]], [[VPCOMUW]], [[VPHADDBD]], [[VPHADDBQ]], [[VPHADDBW]], [[VPHADDDQ]], [[VPHADDUBD]], [[VPHADDUBQ]], [[VPHADDUBW]], [[VPHADDUDQ]], [[VPHADDUWD]], [[VPHADDUWQ]], [[VPHADDWD]], [[VPHADDWQ]], [[VPHSUBDQ]], [[VPHSUBWD]], [[VPMACSDD]], [[VPMACSDQH]], [[VPMACSDQL]], [[VPMACSSSDD]], [[VPMACSSDQH]], [[VPMACSSDQL]], [[VPMACSSSWD]], [[VPMACSWW]], [[VPMACSWD]], [[VPMACSWW]], [[VPMADCSSWD]], [[VPMADCSWD]], [[VPPERM]], [[VPROTB]], [[VPROTD]], [[VPROTQ]], [[VPROTW]], [[VPSHAB]], [[VPSHAD]], [[VPSHAQ]], [[VPSHAW]], [[VPSHLB]], [[VPSHLD]], [[VPSHLQ]], [[VPSHLW]].

| Processor name        | Microarchitecture Code name     | Family number (hex) | Model number (hex) | Comment                     |
| --------------------- | ------------------------------- | ------------------- | ------------------ | --------------------------- |
| AMD K7 Athlon 6       |                                 | 6                   | 6                  | Step. 2, rev. A5            |
| AMD K8 Opteron        |                                 | F                   | 5                  | Stepping A                  |
| AMD K10 Opteron       |                                 | 10                  | 2                  | 2350, step. 1               |
| AMD Bulldozer         | [[Bulldozer]], [[Zambez]]       | 15                  | 1                  | FX-6100, step 2             |
| AMD Piledriver        | [[Piledriver]]                  | 15                  | 2                  | FX-8350, step 0. And others |
| AMD Steamroller       | [[Steamroller]], [[Kaveri]]     | 15                  | 30                 | A10-7850K, step 1           |
| AMD Excavator         | [[Bristol_Ridge]]               | 15                  | 65                 | A10-9700E, step 1           |
| AMD Ryzen             | [[Zen_1]]                       | 17                  | 1                  | Ryzen 7 1800X, step. 1      |
| AMD Ryzen 3700        | [[Zen_2]]                       | 17                  | 71                 | Ryzen 7 3700X, step. 0      |
| AMD Ryzen 5000        | [[Zen_3]]                       | 19                  | 21                 | Ryzen 7 5800X, step. 0      |
| AMD Ryzen 9           | [[Zen_4]]                       | 19                  | 61                 | Ryzen 9 7900X, step. 2      |
| AMD Bobcat            | [[Bobcat]]                      | 14                  | 1                  | E350, step. 0               |
| AMD Kabini            | [[Jaguar]]                      | 16                  | 0                  | A4-5000, step 1             |
| Intel Pentium         | [[P5]]                          | 5                   | 2                  |                             |
| Intel Pentium MMX     | [[P5]]                          | 5                   | 4                  | Stepping 4                  |
| Intel Pentium II      | [[P6(Client)]]                  | 6                   | 6                  |                             |
| Intel Pentium III     | [[P6(Client)]]                  | 6                   | 7                  |                             |
| Intel Pentium 4       | [[Netburst]]                    | F                   | 2                  | Stepping 4, rev. B0         |
| Intel Pentium 4 EM64T | [[Netburst]], [[Prescott]]      | F                   | 4                  | Xeon. Stepping 1            |
| Intel Pentium M       | [[Dothan]]                      | 6                   | D                  | Stepping 6, rev. B1         |
| Intel Core Duo        | [[Yonah]]                       | 6                   | E                  | Not fully tested            |
| Intel Core 2 (65 nm)  | [[Merom]]                       | 6                   | F                  | T5500, Step. 6, rev. B2     |
| Intel Core 2 (45 nm)  | [[Wolfdale]]                    | 6                   | 17                 | E8400, Step. 6              |
| Intel Core i7         | [[Nehalem]]                     | 6                   | 1A                 | i7-920, Step. 5, rev. D0    |
| Intel 2nd gen. Core   | [[Sandy_Bridge(Client)]]        | 6                   | 2A                 | i5-2500, Step 7             |
| Intel 3rd gen. Core   | [[Ivy_Bridge(Client)]]          | 6                   | 3A                 | i7-3770K, Step 9            |
| Intel 4th gen. Core   | [[Haswell(Client)]]             | 6                   | 3C                 | i7-4770K, step. 3           |
| Intel 5th gen. Core   | [[Broadwell(Client)]]           | 6                   | 56                 | D1540, step 2               |
| Intel 6th gen. Core   | [[Skylake(Client)]]             | 6                   | 5E                 | Step. 3                     |
| Intel 7th gen. Core   | [[Cascade_Lake]], [[Skylake-X]] | 6                   | 55                 | Step. 4                     |
| Intel 9th gen. Core   | [[Coffee_Lake]]                 | 6                   | 9E                 | Step. B                     |
| Intel 10th gen. Core  | [[Cannon_Lake]]                 | 6                   | 66                 | Step. 3                     |
| Intel 10th gen. Core  | [[Ice_Lake(Client)]]            | 6                   | 7E                 | Step. 5                     |
| Intel 11th gen. Core  | [[Tiger_Lake]]                  | 6                   | 8C                 | Step. 1                     |
| Intel 12th gen. Core  | ?                               | ?                   | ?                  | ?                           |
| Intel 13th gen. Core  | [[Raptor_Lake]]?                | ?                   | ?                  | ?                           |
| Intel Atom 330        | [[Diamondville]]                | 6                   | 1C                 | Step. 2                     |
| Intel Bay Trail       | [[Silvermont]]                  | 6                   | 37                 | Step. 3                     |
| Intel Apollo Lake     | [[Goldmont]]                    | 6                   | 5C                 | Step. 9                     |
| Intel Gemini Lake     | [[Goldmont_Plus]]               | 6                   | 7A                 | A Step. 1                   |
| Intel Jasper Lake     | [[Tremont]]                     | 6                   | 9C                 | Step. 0                     |
| Intel Xeon Phi        | [[Knights_Landing]]             | 6                   | 57                 | Step. 1                     |
| VIA Nano L2200        |                                 | 6                   | F                  | Step. 2                     |
| VIA Nano L3050        | [[Isaiah]]                      | 6                   | F                  | Step. 8 (prerelease sample) |

^abc2b3

