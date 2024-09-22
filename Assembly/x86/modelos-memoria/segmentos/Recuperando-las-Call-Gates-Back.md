https://www.alex-ionescu.com/bringing-call-gates-back/

## Introduction
Hace unos meses, mientras revisaba los cambios en la actualización de aniversario de Windows 10 para el libro ``Windows Internals 7th Edition``, noté que el núcleo comenzó a imponer el uso de la función CR4[FSGSBASE] (introducida en los procesadores ``Intel Ivy Bridge``, consulte la Sección 4.5.3 en los [AMD Manuals](http://developer.amd.com/wordpress/media/2012/10/24593_APM_v21.pdf)) para permitir el uso de la [User Mode Scheduling](https://msdn.microsoft.com/en-us/library/windows/desktop/dd627187(v=vs.85).aspx) ([[UMS]]).

```ruby
 Advertencia

A partir de Windows 11, no se admite la programación en modo de usuario (UMS). Todas las llamadas producen el error `ERROR_NOT_SUPPORTED`.
```

Esto me llevó a analizar más a fondo cómo funcionaba [[UMS]] antes de que se agregara esta función del procesador, algo de lo que sabía un poco, pero no lo suficiente como para escribir sobre ello.

Lo que descubrí cambió por completo mi comprensión de la semántica del modo largo de ``64 bits`` y desafió muchas suposiciones que estaba haciendo; al consultar con otros expertos, parece que estaban tan sorprendidos como yo (¡incluso ``Mateusz`` "``j00ru``" ``Jurczyk`` no lo sabía!).

A lo largo de esta publicación del blog, verá cómo los procesadores ``x64``, incluso cuando funcionan en ``modo de 64 bits``, véase [[modo-largo]]:

- Aún admiten el uso de una ``tabla de descriptores locales`` ([[LDT]]) 
- Aún admiten el uso de puertas de llamada([[Call-Gates]]), utilizando un nuevo formato de descriptor.
- Aún admiten la segmentación basada en la tabla de descriptores ([[GDT]]/[[LDT]]) utilizando el segmento [[FS]]/[[GS]], ignorando el nuevo mecanismo basado en [[MSR]] que se pretendía "``reemplazarlo``". Véase [[modelos-memoria]].

Además, veremos cómo ``Windows x64`` aún permite que las aplicaciones en modo usuario creen una [[LDT]] (con **limitaciones específicas**).

Al final del día, demostraremos que el increíble artículo de ``j00ru`` y ``Gynvael Coldwind`` sobre el abuso de las ``tablas de descriptores`` sigue siendo relevante, incluso en sistemas ``x64``, en sistemas hasta la actualización de aniversario de Windows 10. Como tal, la lectura de ese [artículo](https://j00ru.vexillium.org/2010/01/descriptor-tables-in-kernel-exploitation-a-new-article/) debe considerarse un prerrequisito para esta publicación.

Tenga en cuenta que todas estas técnicas ya no funcionan en sistemas con actualización de aniversario o posteriores, ni funcionarán en procesadores [[Intel-Ivy-Bridge]] o posteriores, por lo que las presento ahora. Además, aquí no se presenta ninguna "vulnerabilidad" o "día cero", por lo que no hay motivo de alarma. Se trata simplemente de una combinación interesante de componentes internos de ``CPU``, sistema y SO, que en sistemas más antiguos podrían haberse utilizado como una forma de obtener la ejecución de código en el [[ring-0]], en presencia de una vulnerabilidad ya existente.

## Una breve introducción a la programación en modo de usuario

[[UMS]] permite de manera eficiente que los procesos en ``modo de usuario`` cambien entre múltiples subprocesos de “``usuario``” sin involucrar al núcleo, una extensión y una gran mejora del antiguo mecanismo “[fibra](https://msdn.microsoft.com/en-us/library/windows/desktop/ms682661(v=vs.85).aspx)”. Varios [videos en Channel 9](https://channel9.msdn.com/Shows/Going+Deep/Dave-Probert-Inside-Windows-7-User-Mode-Scheduler-UMS) explican cómo se hace esto, al igual que la [patente](http://www.google.com/patents/US20100083275).

Uno de los problemas clave que surgen cuando se intenta cambiar entre subprocesos sin involucrar al núcleo es el registro por subproceso que se usa en los sistemas ``x86`` y ``x64`` para apuntar al [[TEB]]. En los sistemas ``x86``, se usa el segmento [[FS]], aprovechando una entrada en el [[GDT]] (``KGDT_R3_TEB``), y en los ``x64``, se usa el segmento [[GS]], aprovechando los dos registros específicos del modelo ([[MSR]]) que implementó ``AMD``: ``MSR_GS_BASE`` y ``MSR_KERNEL_GS_SWAP``.

Como [[UMS]] ahora necesitaría permitir cambiar la dirección base de este registro por subproceso desde el modo de usuario (ya que involucrar una transición del núcleo iría en contra de todo el objetivo), existen dos problemas:

1. En sistemas ``x86``, esto podría implementarse a través de la segmentación, lo que permite que un proceso tenga segmentos [[FS]] adicionales. Pero hacerlo en el [[GDT]] limitaría la cantidad de subprocesos [[UMS]] disponibles en el sistema (además de causar una degradación del rendimiento si varios procesos usan [[UMS]]), mientras que hacerlo en el [[LDT]] entraría en conflicto con el uso existente del [[LDT]] en el sistema (como [[NTVDM]]).
2. En sistemas ``x64``, **modificar la dirección base del segmento [[GS]] requiere modificar los [[MSR]] antes mencionados**, lo que es una operación de [[ring-0]].

Vale la pena mencionar el hecho de que las ``fibras`` nunca resolvieron este problema, sino que todas las fibras comparten un solo subproceso (y [[TEB]]). Pero el objetivo de [[UMS]] es proporcionar un verdadero aislamiento de subprocesos. Entonces, ¿qué puede hacer Windows?

Bueno, resulta que una lectura atenta de los Manuales de AMD (Sección 4.8.2) indica lo siguiente:

- “La **segmentación está deshabilitada** en el modo de ``64 bits``”
- “Los **segmentos de datos a los que hacen referencia los registros de segmento [[FS]] y [[GS]]** reciben un tratamiento especial en el modo de ``64 bits``”.
- “Para estos segmentos, el campo de dirección base no se ignora y se puede utilizar un valor distinto de cero en los cálculos de direcciones virtuales.

No puedo empezar a contar la cantidad de veces que he oído, visto y repetido yo mismo el primer punto. Pero, ¿que [[FS]]/[[GS]] _todavía_ se puede utilizar con un segmento de datos, incluso en el modo de ``64 bits`` de longitud? Esto literalmente me trajo recuerdos del modo ``Unreal``.

Sin embargo, es evidente que ``Microsoft`` estaba prestando atención (¿lo solicitaron?). Como probablemente ya pueda adivinar, [[UMS]] aprovecha esta característica en particular (por eso solo está disponible en versiones ``x64`` de Windows). De hecho, el núcleo crea una ``tabla de descriptores locales`` [[LDT]] tan pronto como hay un subproceso [[UMS]] presente en el proceso.

Esta fue mi segunda sorpresa, ya que no tenía idea de que las [[LDT]] todavía eran algo compatible al ejecutar código nativo de ``64 bits`` (es decir, "[[modo-largo]]"). Pero todavía lo son, por lo que agregar el bit ``TABLE_INDICATOR (TI) (0x4)`` en un segmento hará que el procesador lea la [[LDTR]] para recuperar la dirección base de la [[LDT]] y ``desreferenciar`` el segmento indicado por los otros bits.

Veamos cómo podemos obtener nuestra propia [[LDT]] para un proceso.

## Tabla de descriptores locales en x64

A diferencia de la API [[NtSetLdtEntries]] de ``x86`` y la clase de información ``ProcessLdtInformation``, el núcleo de Windows ``x64`` no proporciona un mecanismo para que aplicaciones arbitrarias en modo usuario creen una [[LDT]]. De hecho, todas estas API devuelven ``STATUS_NOT_SUPPORTED``.

Dicho esto, al llamar a la ``API`` en modo usuario [[EnterUmsSchedulingMode]], que básicamente llama a [[NtSetInformationThread]] con la clase [[ThreadUmsInformation]], el núcleo creará una [[LDT]] ([[KeInitializeProcessLdt]]).

Esto, a su vez, llenará los siguientes campos en [[KPROCESS]]:

1. ``LdtFreeSelectorHint`` que indica el primer índice de selector libre en la [[LDT]]
2. ``LdtTableLength`` que almacena la cantidad total de entradas de la [[LDT]]; está codificado en ``8192``, lo que revela el hecho de que se asigna una [[LDT]] estática de ``64K``
3. ``LdtSystemDescriptor`` que almacena la entrada de la [[LDT]] que se almacenará en la [[GDT]]
4. ``LdtBaseAddress`` que almacena un puntero a la [[LDT]] de este proceso
5. ``LdtProcessLock`` que es un ``FAST_MUTEX`` utilizado para sincronizar los cambios en la [[LDT]]

Finalmente, se envía un ``DPC`` a todos los procesadores que carga la [[LDT]] en todos los procesadores.

Esto se hace leyendo [[KPROCESS]]``->LdtSystemDescriptor`` y escribiendo en la [[GDT]] en el desplazamiento ``0x60`` en ``Windows 10``, o en el desplazamiento ``0x70`` en ``Windows 8.1`` (ronda extra: veremos por qué hay una diferencia un poco más adelante).

Luego, se utiliza la instrucción [[LLDT]] y el selector se almacena en el campo ``KPRCB->LdtSelector``. En este punto, el proceso tiene una [[LDT]]. El siguiente paso es completarla.

La función ahora lee la dirección de la [[TEB]]. Si el [[TEB]] cae en la porción de ``32 bits`` del espacio de direcciones (es decir, mayor que ``0xFFFFFF000``), se lo establece como la dirección base de un nuevo segmento en la [[LDT]] (usando [[LdtFreeSelectorHint]] para elegir qué selector, en este caso, ``0x00``), y el campo [[TebMappedLowVa]] en [[KTHREAD]] replica la dirección [[TEB]] real.

Por otro lado, si la dirección [[TEB]] es mayor a ``4 GB``, ``Windows 8.1`` y versiones anteriores transformarán la asignación privada que contiene el [[TEB]] en una asignación compartida (usando un prototipo de [[PTE]]) y reasignarán una segunda copia en la primera dirección descendente disponible (que normalmente sería ``0xFFFFE000``). Luego, [[TebMappedLowVa]] tendrá esta dirección reasignada por debajo de los ``4 GB``.

Además, el ``VAD``, que permanece “``privado``” (y esto no se mostrará como una asignación verdaderamente compartida) se marcará como ``NoChange``, y además tendrá el campo ``VadFlags.Teb`` configurado para indicar que es una asignación especial. Esto evita que se realicen cambios en esta dirección a través de llamadas como [[VirtualProtect]].

¿Por qué esta limitación de ``4 GB`` y reasignación? ¿Cómo ayuda un [[LDT]] aquí? Bueno, resulta que los manuales de ``AMD64`` son bastante claros sobre el hecho de que las instrucciones ``mov gs, XXX`` y ``pop gs``:

- Borran la dirección superior de ``32 bits`` del registro de sombra de la dirección base [[GS]]
- Cargan la dirección inferior de ``32 bits`` del registro de sombra de la dirección base [[GS]] con el contenido de la entrada de la tabla de descriptores en el selector dado

Por lo tanto, la segmentación de estilo ``x86`` todavía es totalmente compatible cuando se trata de [[FS]] y [[GS]], incluso cuando se opera en [[modo-largo]], y anula la dirección base de ``64 bits`` almacenada en ``MSR_GS_BASE``. Sin embargo, debido a que no hay una entrada de ``tabla de descriptor de segmento`` de datos de ``64 bits``, solo se puede usar una dirección base de ``32 bits``, lo que requiere que el kernel realice esta compleja reasignación.

Sin embargo, en ``Windows 10``, esta funcionalidad no está presente y, en su lugar, el kernel verifica la presencia de la característica de ``CPU FSGSBASE``. Si la característica está presente, no se crea una [[LDT]] en absoluto y, en su lugar, se aprovecha el hecho de que las aplicaciones en modo usuario pueden usar las instrucciones [[WRGSBASE]] y [[RDGSBASE]] para evitar tener que reasignar un [[TEB]] de`` < 4 GB``. Por otro lado, si la característica de ``CPU`` _no_ está disponible, siempre que el [[TEB]] real termine por debajo de los ``4 GB``, se _seguirá utilizando_ una [[LDT]].

Un cambio adicional y final ocurre en ``Anniversary Update``, donde la funcionalidad [[LDT]] se elimina por completo; incluso si el [[TEB]] está por debajo de los ``4 GB``, se aplica [[FSGSBASE]] para la disponibilidad de [[UMS]].

Por último, durante cada cambio de contexto, si el [[KPROCESS]] del hilo recién programado contiene una dirección base [[LDT]] que es diferente a la que está cargada actualmente en el [[GDT]], la nueva dirección base [[LDT]] se carga en el [[GDT]] y el selector [[LDT]] se carga en contra (codificado de nuevo desde ``0x60`` o ``0x70``).

Tenga en cuenta que si el nuevo [[KPROCESS]] no tiene una [[LDT]], la entrada [[LDT]] en la [[GDT]] no se elimina; por lo tanto, la [[GDT]] siempre tendrá una entrada [[LDT]] ahora que se ha creado al menos un hilo [[UMS]] en un proceso, como se puede ver en esta salida del depurador:
```c
lkd> $$>a< c:\class\dumpgdt.wds 70 70
                                                    P Si Gr Pr Lo
Sel        Base              Limit          Type    l ze an es ng
---- ----------------- ----------------- ---------- - -- -- -- --
0070 ffffe000`2037d000 00000000`0000ffff LDT        0 Nb By P  Nl
```

Puede ver cómo esto coincide con el descriptor [[LDT]] de la aplicación “Prueba [[UMS]]”:
```c
lkd> dt nt!_KPROCESS ffffe0002143e080 Ldt*
+0x26c LdtFreeSelectorHint : 1
+0x26e LdtTableLength : 0x2000
+0x270 LdtSystemDescriptor : _KGDTENTRY64
+0x280 LdtBaseAddress : **0xffffe000**`2037**d000** Void
```

```c
lkd> dx ((nt!_KGDTENTRY64 *)0xffffe0002143e2f0)
[+0x000] LimitLow : 0xffff [Type: unsigned short]
[+0x002] BaseLow : **0xd000** [Type: unsigned short]
[+0x004] Bytes [Type: ]
[+0x004] Bits [Type: ]
[+0x008] BaseUpper : **0xffffe000** [Type: unsigned long]
[+0x00c] MustBeZero : 0x0 [Type: unsigned long]
```

## Call Gates en x64

Las puertas de llamada([[Call-gates]]) son un mecanismo que permite que las aplicaciones heredadas de ``16`` y ``32 bits`` **pasen de un nivel de privilegios inferior a uno superior**. Aunque ``Windows NT`` nunca utilizó dichas puertas de llamada internamente, sí lo hicieron varios programas ``antivirus`` mal escritos, algunos emuladores y exploits, tanto en sistemas ``9x`` como ``NT``, debido a la forma sencilla en que permitían a alguien con acceso a la memoria física (o con una vulnerabilidad [[Write-What-Where]] en la memoria virtual) crear una puerta trasera para elevar los privilegios.

Sin embargo, con la llegada de ``Supervisor-Mode-Execution-Prevention`` ([[SMEP]]), esta técnica parece haber pasado de moda. Además, en los sistemas ``x64``, dado que se espera que las puertas de llamada se inserten en la tabla de descriptores globales ([[GDT]]), que se sabe que protege [[PatchGuard]], la técnica se degrada aún más. Además de eso, la mayoría de las personas (incluido yo) asumieron que ``AMD`` simplemente había eliminado por completo esta característica que a menudo no se usaba de la arquitectura ``x64``.

Sin embargo, curiosamente, ``AMD`` sí se tomó la molestia de redefinir un nuevo formato de descriptor de [[Call-gates]] de modo largo ``x64``, eliminando el antiguo “conteo de parámetros” y ampliándolo a un formato de ``16 bytes`` para hacer lugar para un desplazamiento de ``64 bits``, como se muestra a continuación:
![[Pasted image 20240904104305.png]]
Esto significa que si una puerta de llamada se encontrara en una ``tabla de descriptores``, el procesador aún admitiría el uso de una ``far call`` o un ``far jmp`` para hacer referencia a un descriptor de puerta de llamada y cambiar ``CS:RIP`` a una nueva ubicación.

## Técnica de explotación: Encontrar el [[LDT]]

Primero, aunque [[SMEP]] hace que un ``RIP`` de [[ring-3]] sea inutilizable para obtener la ejecución de [[ring-0]], establecer el Desplazamiento de destino de una ``Puerta de llamada de 64 bits`` en una instrucción de pivote de pila y luego realizar una ``RET`` en un dispositivo de desactivación de [[SMEP]] permitirá que la ejecución del código de [[ring-0]] continúe.

Obviamente, [[HyperGuard]] ahora evita este comportamiento, pero [[HyperGuard]] solo se agregó en ``Anniversary Update``, que deshabilita el uso del [[LDT]] de todos modos.

Esto significa que la capacidad de instalar una Puerta de llamada de ``64 bits`` sigue siendo una técnica viable para obtener una ejecución controlada con privilegios de [[ring-0]].

Dicho esto, si el [[GDT]] está protegido por [[PatchGuard]], significa que insertar una puerta de llamada no es realmente viable: existe la posibilidad de que se detecte tan pronto como se inserte, e incluso un intento de limpiar la puerta de llamada después de usarla podría llegar demasiado tarde. Al intentar implementar una técnica de explotación estable y persistente, es mejor evitar las cosas que [[PatchGuard]] detectará.

Por otro lado, ahora sabemos que los procesadores ``x64`` aún admiten el uso de una [[LDT]], y que Windows aprovecha esto al implementar [[UMS]]. Además, dado que los procesos arbitrarios pueden tener [[LDT]] arbitrarias, [[PatchGuard]] no protege las entradas [[LDT]] de procesos individuales, a diferencia de la [[GDT]].

Eso aún deja la pregunta de cómo encontramos la [[LDT]] del proceso actual, una vez que hemos habilitado [[UMS]]. Bueno, dado que la [[LDT]] es una asignación estática de ``64 KB``, de un grupo no paginado, esto aún nos deja con una opción. Como expliqué hace unos años en [mi publicación sobre el Big Pool](http://www.alex-ionescu.com/?p=231), una asignación tan grande será fácilmente enumerable desde el ``modo de usuario`` siempre que se conozca su etiqueta:
```c
lkd> !pool ffffe000`22f3b000
```

```c
Pool page ffffe00022f3b000 region is Nonpaged pool
*ffffe00022f3b000 : large allocation, tag **kLDT**, size 0x10000 bytes
```

Si bien esta es una buena fuga de información incluso en ``Windows 10``, en ``Windows 8.1`` entra en juego una mitigación: los procesos de nivel IL bajo ya no pueden usar la ``API`` que describí, lo que significa que la dirección [[LDT]] solo se puede filtrar (sin una vulnerabilidad de lectura arbitraria/fuga de información de [[ring-0]] existente) en un nivel IL medio o superior.

Sin embargo, dado que se trata de una asignación de tamaño bastante grande, significa que si se puede realizar una asignación controlada de ``64 KB`` en un grupo no paginado y se filtra su dirección desde un nivel IL bajo, aún se puede adivinar la dirección [[LDT]]. Las formas de hacerlo se dejan como ejercicio para el lector.

Alternativamente, si el atacante tiene una vulnerabilidad de lectura arbitraria, la dirección [[LDT]] se puede recuperar fácilmente de la estructura [[KPROCESS]] leyendo el campo ``LdtBaseAddress`` o computándola desde el campo ``LdtSystemDescriptor``. Obtener [[KPROCESS]] es fácil a través de una variedad de API no documentadas, aunque ahora también están bloqueadas en ``Windows 8.1`` desde un nivel IL bajo.

Por lo tanto, otra técnica común es utilizar un objeto [[GDI]] o ``User`` que tenga un propietario como ``tagTHREADINFO``, que luego apunte a [[ETHREAD]] (que a su vez a [[EPROCESS]]). Como alternativa, se podría recuperar la dirección base de [[GDT]] del campo [[GdtBase]] de [[KPCR]], si hay una forma de filtrar el [[KPCR]], y luego leer la dirección base del segmento en el desplazamiento ``0x60`` o ``0x70``. La infinidad de formas de filtrar punteros y eludir [[KASLR]], incluso desde Low IL, está más allá (¿por debajo?) del contenido de esta publicación.

## Técnica de explotación: creación de una Call Gate

El siguiente paso es escribir una puerta de llamada en uno de los selectores presentes en la [[LDT]]. De forma predeterminada, si este es el subproceso del programador inicial, esperamos encontrar su [[TEB]]. De hecho, en esta máquina virtual de ``Windows 8.1`` de muestra, podemos ver el [[TEB]] reasignado en ``0xFFFFE000``:
```c
lkd> dq 0xffffe000`2037d000
ffffe000`2037d000 **ffff**f3ff`**e000**1820
```

```c
lkd> dt nt!_KGDTENTRY64 ffffe000`2037d000 -b
+0x000 LimitLow : 0x1820
+0x002 BaseLow : **0xe000**
+0x004 Bytes :
+0x000 BaseMiddle : **0xff** ''
+0x001 Flags1 : 0xf3 ''
+0x002 Flags2 : 0xff ''
+0x003 BaseHigh : **0xff** ''
+0x004 Bits :
+0x000 BaseMiddle : 0y11111111 (0xff)
+0x000 Type : 0y10011 (0x13)
+0x000 Dpl : 0y11
+0x000 Present : 0y1
+0x000 LimitHigh : 0y1111
+0x000 System : 0y1
+0x000 LongMode : 0y1
+0x000 DefaultBig : 0y1
+0x000 Granularity : 0y1
+0x000 BaseHigh : 0y11111111
+0x008 BaseUpper : 0
+0x00c MustBeZero : 0
```

Para convertir este ``segmento de datos`` en una puerta de llamada, basta con convertir el tipo de ``0x13`` (segmento de datos de usuario, lectura/escritura, acceso) a ``0x0C`` (segmento del sistema, puerta de llamada).

Sin embargo, al hacerlo, se creará una puerta de llamada con el siguiente ``CS:[RIP] => E000:00000000FFFF1820``

Tenemos, por lo tanto, dos problemas:

1. ``0xE000`` no es un segmento válido
2. ``0xFFFF1820`` es una dirección de modo de usuario, lo que provocará una violación de [[SMEP]] en la mayoría de los sistemas modernos.

El primer problema no es fácil de resolver: si bien podríamos crear miles de subprocesos [[UMS]], lo que provocaría que ``0xE000`` se convirtiera en un segmento válido (que luego convertiríamos en un segmento de código de [[ring-0]]), este sería el segmento ``0xE004``. Y si uno puede cambiar ``0xE000``, también se puede evitar el problema y configurarlo en su valor correcto – (``KGDT64_R0_CODE``) ``0x10``, desde el principio.

El segundo problema se puede solucionar de varias maneras.

1. Se puede utilizar una escritura arbitraria para configurar ``BaseUpper``, ``BaseHigh``, ``LimitHigh``, ``Flags2`` y ``LimitLow`` (que conforman los ``64 bits`` de ``Code Offset``) en el ``RIP``[[ring-0]]  deseado que contiene un pivote de pila o alguna otra instrucción o dispositivo interesante.
2. O bien, una escritura arbitraria para modificar el [[PTE]] para convertirlo en [[ring-0]], ya que la dirección base del [[PTE]] no es aleatoria en las versiones de Windows vulnerables a un ataque basado en [[LDT]]. 3. Por último, si solo nos interesa la escalada de ``SYSTEM->``[[ring-0]], los sistemas anteriores a Windows 10 pueden ser atacados a través del ataque basado en [[AWE]] que describí en Infiltrate 2015, que permitirá la creación de una página [[ring-0]] ejecutable.

También vale la pena mencionar que, dado que Windows 7 tiene todo el grupo no paginado marcado como ejecutable y el [[LDT]] es en sí mismo una asignación de grupo no paginado de ``64 KB``, está compuesto por páginas completamente ejecutables, por lo que se podría usar una escritura arbitraria para establecer el desplazamiento de [[Call-gates]] en algún lugar dentro de la asignación del [[LDT]] en sí.

## Técnica de explotación: escritura de la carga útil del anillo 0

Escribir el código de carga útil del [[ring-0]] de ``x64`` es mucho más difícil que en ``x86``.

Para empezar, el segmento [[GS]] debe establecerse inmediatamente en su valor correcto, de lo contrario podría producirse una falla triple. Esto se hace mediante la instrucción ``swapgs``.

A continuación, es importante darse cuenta de que una compuerta de llamada establece el selector de segmento de pila ([[SS]]) en 0. Si bien ``x64`` funciona de forma nativa de esta manera, Windows espera que [[SS]] sea ``KGDT64_R0_DATA`` o ``0x18``, y puede ser una buena idea respetarlo.

Además, tenga en cuenta que el valor al que se establecerá ``RSP`` es igual al ``Rsp0`` de ``TSS``, que normalmente se utiliza para interrupciones, mientras que una llamada de sistema típica utilizaría el campo ``RspBase`` de [[KPRCB]]. Estos deben estar sincronizados, pero tenga en cuenta que una compuerta de llamada no deshabilita las interrupciones automáticamente, a diferencia de una compuerta de interrupción.

Un exploit confiable debe tomar nota de todos estos detalles para evitar que la máquina se bloquee.

Además, la salida de una puerta de llamada _debe_ hacerse con la instrucción '``far return``'. Una vez más, se aplica otra advertencia: algunos ensambladores pueden no generar un verdadero retorno lejano de ``64 bits`` (es decir, carecen de un prefijo ``rex.w``), lo que extraerá incorrectamente datos de ``32 bits`` de la pila. Asegúrese de que se genere un '``retfq``' o '``retfl``' o '``rex.w retf``' en su lugar.

## Técnicas de explotación Bono: Corrupción de la dirección [[LDT]], segmento oculto, limpieza [[diferida]] [[GDT]]

Tenga en cuenta que hemos pasado por algunas dificultades para obtener la dirección de la [[LDT]] y describir las formas en que las entradas [[TEB]] de [[UMS]] podrían corromperse de manera de convertirlas en entradas de [[Call-gates]]; es útil mencionar que quizás una técnica mucho más fácil (según los parámetros de ataque y la vulnerabilidad) es simplemente sobrescribir el campo ``LdtSystemDescriptor`` en [[EPROCESS]] (algo que el artículo basado en ``x86`` de ``j00ru`` también señaló).

Esto se debe a que, en el próximo cambio de contexto, la [[GDT]] se actualizará automáticamente con una copia de este descriptor, que podría configurarse en una dirección base de modo de usuario (debido a la falta de [[SMAP]] en el sistema operativo), evitando la necesidad de parchear la [[GDT]] (y ubicarla, lo que es difícil cuando la función [[NPIEP]] de ``Hyper-V`` está habilitada) o modificar la [[LDT]] del núcleo real (y filtrar su dirección).

De hecho, para que esto funcione, se requiere una única escritura arbitraria de ``32 bits`` (de hecho, incluso menos), que debe, como mínimo, establecer los campos:

- P a 1 (Hacer que el segmento esté presente)
- ``Type`` a 2 (Establecer el segmento como una entrada [[LDT]])
- ``BaseMid`` a 1 (Establecer la base a ``0x10000``, como ejemplo, ya que las direcciones por debajo de este valor ya no están permitidas)

Por lo tanto, una escritura de ``0x00008201``, por ejemplo, es suficiente para lograr el resultado deseado de establecer la [[LDT]] de este proceso a ``0x10000``.

Tan pronto como se produzca un cambio de contexto de regreso al proceso, el [[Assembly/x86/GDT]] tendrá cargado este descriptor de segmento [[LDT]]:
```c
lkd> $$>a< c:\class\dumpgdt.wds 70 70
                                                    P Si Gr Pr Lo
Sel        Base              Limit          Type    l ze an es ng
---- ----------------- ----------------- ---------- - -- -- -- --
0070 00000000`00010000 00000000`00000000 LDT
```

Pero espere, ¿acaso establecer un límite de 0 no crea una [[LDT]] vacía? ¡No se preocupe! En el modo largo, los límites en las entradas del descriptor de [[LDT]] se ignoran por completo... desafortunadamente, aunque esto es lo que dice el manual de ``AMD64``, obtengo violaciones de acceso, al menos en ``Hyper-V x64``, si el límite no es lo suficientemente grande como para contener el segmento. Así que su rendimiento puede variar.

Pero eso está bien, ¡podemos limitar esto a una simple sobrescritura de ``4 bytes``! El truco consiste simplemente en pasar por el proceso de crear una [[LDT]] real en primer lugar, luego filtrar su dirección (como se describe). A continuación, asigne la [[LDT]] falsa de modo de usuario en la misma dirección de ``32 bits`` inferior, manteniendo los ``32 bits`` superiores en cero. Luego, use la sobrescritura de 4 bytes para borrar el campo ``BaseUpper`` del ``LdtSystemDescriptor`` de [[KPROCESS]].

Incluso si la dirección [[LDT]] del núcleo no se puede filtrar por alguna razón, uno puede "adivinar" fácilmente cada posibilidad (sabiendo que estará alineada con la página) y rociar todo el espacio de direcciones de ``32 bits``. Esto parece mucho, pero en realidad es solo alrededor de un millón de asignaciones.

Finalmente, una técnica alternativa es aprovechar el manejo de excepciones: si se sobrescribe la [[LDT]] incorrecta, el núcleo no se bloqueará al cargar el segmento [[LDT]] no válido (siempre que sea canónico, no se verifica la validez del [[PTE]]). En cambio, solo cuando el exploit intente usar la puerta de llamada, se generará un [[GPF]], y solo en el contexto de la aplicación [[ring-3]]. Como tal, uno puede probar progresivamente cada posible dirección [[LDT]] de ``32 bits`` inferior hasta que ya no se emita un [[GPF]]. Voila: hemos encontrado los ``32 bits`` inferiores correctos.

Como otra ventaja, ¿por qué el selector para la [[LDT]] es ``0x70`` en ``Windows 8.``1 y anteriores, pero ``0x60`` en ``Windows 10``?

La respuesta se encuentra en un hecho aún menos conocido: hasta este último, el núcleo creaba un segmento de modo de compatibilidad de [[ring-0]] en el desplazamiento ``0x60``. Esto significa que un atacante astuto puede establecer [[CS]] en ``0x60`` y disfrutar de una extraña combinación de ejecución de código heredado de ``32 bits`` con privilegios de [[ring-0]] (se aplican varias advertencias, incluido lo que haría una interrupción al regresar y el hecho de que no se podría usar ninguna API del núcleo).

Finalmente, tenga en cuenta que incluso una vez que existe un proceso de aprovechamiento de [[UMS]], la entrada ``GDT`` no se borra y apunta a una asignación de grupo liberado. Esto significa que si se conoce una forma de asignar ``64 KB`` de memoria de grupo no paginado controlada (como algunas de las formas descritas en mi publicación de blog Big Pool), la entrada [[GDT]] podría hacerse para apuntar a la memoria controlada (como un búfer de canalización con nombre) que reutilizará el mismo puntero. Luego, se debe encontrar alguna manera de hacer que el sistema siga confiando en esta dirección/entrada (ya sea haciendo que se emita un [[LLDT]] de ``0x60``/``0x70`` o haciendo que el campo ``LdtSystemDescriptor`` de un [[EPROCESS]] reutilice esta dirección).

Esta es más una técnica antiforense que otra cosa, porque mantiene el [[GDT]] apuntando a un [[LDT]] en modo kernel, aunque esté controlado por el atacante.