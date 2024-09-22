https://wiki.osdev.org/Segmentation#Notes_Regarding_Pascal[FPC]

Vea [[registros-segmento-selectores-segmento]], [[Descriptor-de-segmento]]

## [[modo-real]]
En el [Modo real](https://wiki.osdev.org/Real_Mode "Modo real") se utiliza una dirección lógica en el formato `A:B` para direccionar la memoria. Esto se traduce en una dirección física utilizando la ecuación:
```c
Dirección física = (A * 0x10) + B
```
Los registros en modo real puro están limitados a `16 bits` para direccionamiento. `16` bits pueden representar cualquier número entero entre `0` y `64k`. Esto significa que si establecemos `A` como un valor fijo y permitimos que `B` cambie, podemos direccionar un área de `64k` de memoria. Esta área de `64k` se llama segmento.
```c
A = Un segmento de 64k 
B = Desplazamiento dentro del segmento
```
La dirección base de un segmento es la parte `(A * 0x10)` de la ecuación que mostré. Debería ser obvio que los segmentos pueden superponerse.

Por ejemplo, el segmento `0x1000` tiene una dirección base de `0x10000`. Este segmento ocupa el rango de direcciones físicas `0x10000 -> 0x1FFFF`, sin embargo, el segmento `0x1010` tiene una dirección base de `0x10100`. Este segmento ocupa el rango de direcciones físicas `0x10100` -> `0x200FF`

Como puede ver, podríamos usar cualquiera de los segmentos para alcanzar direcciones físicas entre `0x10100` y `0x1FFFF`, ya que los segmentos se superponen.

La línea de computadoras x86 tiene 6 registros de segmento ([[CS]], [[DS]], [[ES]], [[FS]], [[GS]], [[SS]]). Son totalmente independientes entre sí.

| registro         | proposito                                             |
| ---------------- | ----------------------------------------------------- |
| [[CS]]           | Code Segment                                          |
| [[DS]]           | Data Segment                                          |
| [[SS]]           | [Stack](https://wiki.osdev.org/Stack "Stack") Segment |
| [[ES]]           | Extra Segment                                         |
| [[FS]]<br>[[GS]] | General Purpose Segments                              |


[[DS]], [[ES]], [[FS]], [[GS]], [[SS]] se utilizan para formar direcciones cuando se desea leer o escribir en la memoria. No siempre es necesario codificarlas explícitamente, porque algunas operaciones del procesador suponen que se utilizarán determinados registros de segmento.

Por ejemplo:

escribirá la palabra contenida en ax en la dirección [[DS]]:`SI`
```r
MOV [SI], AX 
```
escribirá la palabra contenida en ax en la dirección [[ES]]:DI
```r
MOV ES:[DI], AX
```

[[CMPSB]] comparará el `byte` en [[DS]]:`SI` con el `byte` en [[ES]]:`DI`, establecerá el indicador cero si son iguales y decrementará o incrementará `SI` y `DI` según el estado del indicador de dirección.

Como puede ver, a menudo el registro de segmento que se utiliza no está contenido en la instrucción, pero hay uno que se está utilizando. CADA vez que forma una dirección en un procesador `x86` habrá un registro de segmento involucrado.

### Operaciones que afectan a los registros de segmento
Además de [[CS]], los registros de segmento se pueden cargar con un registro general ([[MOV]] `DS, AX`) o con el de la parte superior de la pila ([[POP]] `ds`).

[[CS]] es el único registro de segmento que no se puede alterar directamente. La única vez (estoy seguro de que me estoy olvidando de una) en que [[CS]] se altera es cuando el código cambia la ejecución a otro segmento. Los únicos comandos que pueden hacer esto son:
#### Salto lejano ([[JMP FAR]])
Aquí, el nuevo valor para [[CS]] se codifica en la instrucción de salto. Por ejemplo, [[JMP]] `0x10:0x100` indica que se debe cargar [[CS]] con el segmento `0x10` e `IP` con `0x100`. [[CS]]:`IP` es la dirección lógica de la instrucción que se va a ejecutar.
#### Llamada lejana ([[CALL FAR]])
Esto es exactamente lo mismo que un salto lejano, pero los valores actuales de [[CS]]/`IP` se introducen en la [pila](https://wiki.osdev.org/Stack "Pila") antes de ejecutarse en la nueva posición.
#### [[INT]]
El procesador lee el nuevo valor de [[CS]]/`IP` de la tabla de vectores de interrupción y luego ejecuta lo que efectivamente es una llamada lejana después de insertar `E`[[FLAGS]] en la [pila](https://wiki.osdev.org/Stack "Pila").
#### Retorno lejano([[RETF]]/[[RETF|RET FAR]])
Aquí, el procesador extrae el segmento/desplazamiento de retorno de la [pila](https://wiki.osdev.org/Stack "Pila") en [[CS]]/`IP` y cambia la ejecución a esa dirección.
#### [[IRET]]
Esto es exactamente lo mismo que un retorno lejano, salvo que el procesador extrae `E`[[FLAGS]] de la [pila](https://wiki.osdev.org/Stack "Pila") además de [[CS]]/`IP`.

Aparte de estos casos, ninguna instrucción altera el valor de [[CS]].

## [[modo-protegido]]
La [[segmentación]] se considera una técnica de protección de memoria obsoleta en [[modo-protegido]] tanto por los fabricantes de `CPU` como por la mayoría de los programadores. Ya no se admite en [[modo-largo]] (tal como era en [[modo-protegido]]), vea [[Recuperando-las-Call-Gates-Back]]. La información que se incluye aquí es necesaria para que funcione el [[modo-protegido]]; también se necesita [[GDT]] de `64 bits` para ingresar al [[modo-largo]] y los segmentos aún se usan para saltar del [[modo-largo]] al [[modo-real|modo de compatibilidad]] y viceversa. Si desea tomarse en serio el desarrollo de SO, le recomendamos enfáticamente usar el modelo de memoria plana y la [paginación](https://wiki.osdev.org/Paging "Paginación") como técnica de administración de memoria. Para obtener más información, consulte [x86-64](https://wiki.osdev.org/X86-64 "X86-64")._

_Lea más sobre [Tabla de descriptores globales](https://wiki.osdev.org/Global_Descriptor_Table "Tabla de descriptores globales")_

En [Modo protegido](https://wiki.osdev.org/Protected_mode "Modo protegido"), se utiliza una dirección lógica en el formato `A:B` para direccionar la memoria. Al igual que en [Modo real](https://wiki.osdev.org/Real_Mode "Modo real"), A es la parte del segmento y B es el desplazamiento dentro de ese segmento. Los registros en modo protegido están limitados a `32 bits`. `32 bits` pueden representar cualquier número entero entre `0` y `4 GiB`.

Como `B` puede ser cualquier valor entre `0` y `4 GiB`, nuestros segmentos ahora tienen un tamaño máximo de `4 GiB` (el mismo razonamiento que en [[modo-real]]).

Ahora, la diferencia.
En el [[modo-protegido]], `A` no es un valor absoluto para el segmento. En el [[modo-protegido]], `A` es un [[registros-segmento-selectores-segmento|selector]]. Un [[registros-segmento-selectores-segmento|selector]] representa un desplazamiento en una tabla del sistema denominada [Tabla de descriptores globales](https://wiki.osdev.org/Global_Descriptor_Table "Tabla de descriptores globales") ([[GDT]]). La [[GDT]] contiene una lista de descriptores. Cada uno de estos descriptores contiene información que describe las características de un segmento.

Cada [[Descriptor-de-segmento|descriptor de segmento]] contiene la siguiente información:
- La dirección base del segmento
- El tamaño de operación predeterminado en el segmento (`16 bits`/`32 bits`)
- El nivel de privilegio del descriptor ([[modelos-memoria#^5d8a1f|ring 0]] -> [[modelos-memoria#^5d8a1f|ring 3]])
- La granularidad (el límite del segmento está en bytes/unidades de 4 kb)
- El límite del segmento (el desplazamiento legal máximo dentro del segmento)
- La presencia del segmento (¿está presente o no?)
- El [[Descriptor-de-segmento#^6c0bd8|]] (0 = sistema; 1 = código/datos)
- El [[Descriptor-de-segmento#^eddd92|tipo de segmento]] (0 = sistema; 1 = código/datos)
- El tipo de segmento (Código/Datos/Lectura/Escritura/Acceso/Conforme/No conforme/Expandir hacia arriba/[Expandir hacia abajo](https://wiki.osdev.org/Expand_Down "Expandir hacia abajo"))

Para los fines de esta explicación, solo me interesan tres cosas: la dirección base, el límite y el tipo de descriptor.

Si el tipo de descriptor es claro (tipo de sistema), entonces el descriptor no está describiendo un segmento, sino uno de los mecanismos de compuerta especiales, dónde encontrar un [[LDT]] o un [[TSS]]. Estos no tienen nada que ver con el direccionamiento general, por lo que asumiré un tipo de descriptor de 1 (tipo de código/datos) y dejaré que lea los manuales de Intel para el resto.

El segmento se describe por su dirección base y límite. ¿Recuerdas en [[modo-real]] donde el segmento era un área de `64k` en la memoria? La única diferencia aquí es que el tamaño del segmento no es fijo. La dirección base proporcionada por el descriptor es el comienzo del segmento, el límite es el desplazamiento máximo que el procesador permitirá antes de producir una excepción.

Por lo tanto, el rango de direcciones físicas en nuestro segmento de modo protegido es:
```c
Base del segmento -> Base del segmento + Límite del segmento
```
Dada una dirección lógica `A:B` (recuerde que `A` es un selector), podemos determinar la dirección física a la que se traduce usando:
```c
Dirección física = Base del segmento (GDT[A]) + B
```
**Base del segmento (que se obtiene a partir del descriptor [[GDT]][A])**

Todas las demás reglas del [[modo-real]] siguen aplicándose.
### Notas
- Los segmentos pueden superponerse
- [[CS]], [[DS]], [[ES]], [[FS]], [[GS]], [[SS]] son independientes entre sí
- [[CS]] no se puede cambiar directamente

En el [[modo-protegido]], [[CS]] también se puede cambiar a través del [[TSS]] o una compuerta.

## Notas sobre `C`
- La mayoría de los compiladores de `C` asumen un modelo de memoria plana.
- En este modelo, todos los segmentos cubren el espacio de direcciones completo (normalmente de `0` a `4 Gb` en `x86`). En esencia, esto significa que ignoramos por completo la parte `A` de nuestra dirección lógica `A:B`. La razón de esto es que la mayoría de los procesadores en realidad no tienen `segmentación` (y es mucho más fácil para el compilador optimizarla).
- Esto te deja con 2 descriptores por nivel de privilegio (normalmente `Ring 0` y `Ring 3`), uno para el código y otro para los datos, que describen exactamente el mismo segmento. La única diferencia es que el descriptor de código se carga en [[CS]], y el descriptor de datos lo utilizan todos los demás registros de segmento. La razón por la que necesitas tanto un descriptor de código como de datos es que el procesador no te permitirá cargar [[CS]] con un descriptor de datos (esto es para ayudar con la seguridad cuando se utiliza un modelo de memoria segmentada, y aunque es inútil en el modelo de memoria plana, sigue siendo necesario porque no puedes desactivar la segmentación).
- En general, si desea utilizar el mecanismo de segmentación, al hacer que los diferentes registros de segmento representen segmentos con diferentes direcciones base, no podrá utilizar un compilador de C moderno y es muy posible que se vea restringido a solo Assembly.
- Por lo tanto, si va a utilizar C, haga lo que hace el resto del mundo de C, que es configurar un modelo de memoria plana, utilizar paginación e ignorar el hecho de que la segmentación incluso existe.

## Notas sobre Pascal[FPC]
Lo anterior puede aplicarse en teoría a `FreePascal`, sin embargo, en la realidad se ignora, si el compilador le presta alguna atención. Se utilizan los segmentos gemelos para `CÓDIGO` y `DATOS` y, como se especificó anteriormente, son necesarios. Sin embargo, se respetan los límites de tamaño (NO tiene que tener una longitud de `4 GB`).

"*En general, si desea utilizar el mecanismo de segmentación, al hacer que los diferentes registros de segmento representen segmentos con diferentes direcciones base, no podrá utilizar un compilador `C` moderno y es muy posible que se vea restringido a solo `Assembly`".

Esto simplemente NO es cierto para `Freepascal`.
La "`A` en `A:B`" es lo que permite referencias de puntero de `48` y `64 bits`, no solo con la unidad `NewFrontier` de `Pascal`, sino también con `FreePascal` (referencia de puntero `Word:Longint`).
- La suposición de que `CÓDIGO` y `DATOS` ocupan el mismo espacio (al menos con bits [[PAE]] [[NX]] y unidades de paginación no utilizadas) permite que el código tipo virus o ROGUE aproveche la máquina en primer lugar. Las especificaciones de INTEL incluso lo dicen. CÓDIGO y DATOS deben MANTENERSE separados. Microsoft todavía sufre este problema, a pesar de tener los bits [[NX]] habilitados incluso en los sistemas operativos más recientes.

## See Also
### Articles
[Segment Limits](https://wiki.osdev.org/Segment_Limits#Segmentation "Segment Limits")

### Threads
### External Links
- [Removing the Mystery from SEGMENT : OFFSET Addressing](http://mirror.href.com/thestarman/asm/debug/Segments.html)
- [Aug 2008: Memory Translation and Segmentation](http://duartes.org/gustavo/blog/post/memory-translation-and-segmentation) by Gustavo Duarte