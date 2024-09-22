
### Qué es un registro?
En nuestra `CPU` podemos encontrar unas "memorias" especiales que se llaman registros, hay gente que los llaman también celdas. Estas son mas rápidas que la `RAM` pero tiene un menor tamaño, "son memorias cache". Su tamaño depende de la arquitectura del procesador y de si el mismo de de 64, 32, 16 u 8bits. Estas memorias especiales las llamamos "registros". 

Si nuestra CPU es de `32bits`, nosotros no dispondremos de registros de `64bits` obviamente, pero si podremos hacer uso de estos para hacer divisiones de registros, es decir, si nuestro registro mas grande es de `32bits`, podemos dividirlo y tener dos registros de `16bits`, a su vez, uno de estos registros de `16bits` podemos partirlos en 2 registro de `8bits`. Tal vez te preguntes por que alguien querría hacer esto, la respuesta es mas simple de lo que parece y es por temas de compatibilidad.
Imagínense que tienen una CPU de `64bits` con sus correspondientes registro de 64 y queremos correr programa de `32bits`, lo que podemos hacer es "dividir" esos registros de `64bits` para obtener los de `32bits`, aunque la otra mitad no se usaran para nada. Este sistema nos permite tener una compatibilidad para ejecutar programas de 64, 32, 16 u 8bits siempre y cuando podamos hacer las divisiones necesarias. 
Aunque no siempre es por esto, otras veces simplemente querremos optimizar nuestro código, y tal vez un registro de `64bits` sea demasiado grande para lo que queremos.

Vea también [[registros-cpu|8086 registros]]

![registros x64](registros-4.png|200)


![[registros-3.png]]

![[registros-1.png]]

![[registros-2.png]]

[https://learn.microsoft.com/es-es/windows-hardware/drivers/debugger/x64-architecture](https://learn.microsoft.com/es-es/windows-hardware/drivers/debugger/x64-architecture)

La arquitectura x64 es una extensión compatible con versiones anteriores de x86. Proporciona un nuevo modo de 64 bits y un modo heredado de 32 bits, que es idéntico a x86.

El término "x64" incluye AMD 64 e Intel64. Los conjuntos de instrucciones son casi idénticos.
## Registros

x64 amplía los registros de uso general de x86 para que sean de 64 bits y agrega registros de 64 bits nuevos. Los registros de 64 bits tienen nombres que comienzan por "r". Por ejemplo, la extensión de 64 bits de **eax** se denomina **rax**. Los nuevos registros se denominan **r8** a **r15**.

Los 32 bits inferiores, 16 bits y 8 bits de cada registro son direccionables directamente en operandos. Esto incluye registros, como **esi**, cuyos 8 bits inferiores no eran direccionables anteriormente. En la tabla siguiente se especifican los nombres de lenguaje de ensamblado para las partes inferiores de los registros de 64 bits.

| Registro de 64 bits | 32 bits inferiores | 16 bits inferiores | 8 bits inferiores |
| ------------------- | ------------------ | ------------------ | ----------------- |
| Rax                 | Eax                | ax                 | al                |
| Rbx                 | Ebx                | Bx                 | bl                |
| rcx                 | ecx                | Cx                 | cl                |
| rdx                 | Edx                | Dx                 | Dl                |
| Rsi                 | Esi                | si                 | sil               |
| Rdi                 | Edi                | di                 | Dil               |
| Rbp                 | Ebp                | bp                 | bpl               |
| Rsp                 | Esp                | sp                 | Spl               |
| r8                  | r8d                | r8w                | r8b               |
| r9                  | r9d                | r9w                | r9b               |
| r10                 | r10d               | r10w               | r10b              |
| r11                 | r11d               | r11w               | r11b              |
| r12                 | r12d               | r12w               | r12b              |
| r13                 | r13d               | r13w               | r13b              |
| r14                 | r14d               | r14w               | r14b              |
| r15                 | r15d               | r15w               | r15b              |

Las operaciones que se generan en un subregistro de 32 bits se extienden automáticamente a cero en todo el registro de 64 bits. Las operaciones que se generan en los subregistro de 8 o 16 bits no se extienden con cero (este comportamiento es compatible con x86).

Los 8 bits altos de **ax**, **bx**, **cx** y **dx** siguen siendo direccionables como **ah**, **bh**, **ch**, **dh** , pero no se pueden usar con todos los tipos de operandos.

El registro **eip** y **flags** del puntero de instrucción se han ampliado a 64 bits (**rip** y **rflags**, respectivamente).

El procesador x64 también proporciona varios conjuntos de registros de punto flotante:

- Ocho registros x80 bits x87.
- Ocho registros MMX de 64 bits. (Estos registros se superponen con los registros x87).
- El conjunto original de ocho registros SSE de 128 bits se incrementa a dieciséis.
## [[convenciones-de-llamadas]]

A diferencia de x86, el compilador de C/C++ en x64 admite la convención [[__fastcall]]. Esta convención de llamada aprovecha el mayor número de registros disponibles en x64:

- Los cuatro primeros parámetros enteros o de puntero se pasan en los registros **rcx**, **rdx**, **r8** y **r9** .
- Los cuatro primeros parámetros de punto flotante se pasan en los cuatro primeros registros SSE, **xmm0**-**xmm3**.
- El autor de la llamada reserva espacio en la pila para los argumentos pasados en los registros. La función llamada puede usar este espacio para volcar el contenido de los registros en la pila.
- Los argumentos adicionales se pasan en la pila.
- Se devuelve un valor devuelto de entero o puntero en el registro **rax** , mientras que se devuelve un valor devuelto de punto flotante en **xmm0**.
- **rax**, **rcx**, **rdx**, **r8**-**r11** son volátiles.
- **rbx**, **rbp**, **rdi**, **rsi**, **r12**-**r15** son no volátiles.

La convención de llamada para C++ es similar. **Este puntero** se pasa como primer parámetro implícito. Los tres parámetros siguientes se pasan en los registros restantes, mientras que el resto se pasan en la pila.
Vea mas convenciones llamadas [[convenciones-de-llamadas]], [[__cdecl]],  [[__stdcall]], [[__regcall]], [[__clrcall]],[[__thiscall]], [[__fastcall]], [[__vectorcall]], [[__msfastcall]]
## Modos de direccionamiento

Los modos de direccionamiento en modo de 64 bits son similares, pero no idénticos a x86.
- Las instrucciones que hacen referencia a registros de 64 bits se realizan automáticamente con precisión de 64 bits. Por ejemplo, **mov rax, [rbx]** mueve 8 bytes a partir de **rbx** a **rax**.
- Se ha agregado una forma especial de la instrucción **mov** para constantes inmediatas de 64 bits o direcciones constantes. Para todas las demás instrucciones, las constantes inmediatas o las direcciones constantes siguen siendo de 32 bits.
- x64 proporciona un nuevo modo de direccionamiento relativo a **la extracción**. Las instrucciones que hacen referencia a una sola dirección constante se codifican como desplazamientos de **rip**. Por ejemplo, la instrucción **mov rax, [**_addr_**]** mueve 8 bytes a partir de la**extracción**_del addr_ + a **rax**.

Instrucciones, como **jmp**, **llamada**, **inserción** y **pop**, que hacen referencia implícitamente al puntero de instrucción y el puntero de pila los tratan como registros de 64 bits en x64.
## Consulte también

- [X86-64 Wikipedia](https://en.wikipedia.org/wiki/X86-64)
- [Recursos para desarrolladores de AMD 64](https://developer.amd.com/resources/)
- [Intel: introducción al ensamblado x64](https://software.intel.com/content/www/us/en/develop/articles/introduction-to-x64-assembly.html)
- [x64 Primer: todo lo que necesita saber para empezar a programar sistemas Windows de 64 bits - Matt Pietrek](https://learn.microsoft.com/es-es/archive/msdn-magazine/2006/may/x64-starting-out-in-64-bit-windows-systems-with-visual-c)
- [La historia de las convenciones de llamada, parte 5: amd64 Raymond Chen](https://devblogs.microsoft.com/oldnewthing/20040114-00/?p=41053)
----
### Registros Puntero: puntero Base(BP), puntero Pila(SP) y puntero de instrucciones (IP):
Estos registros guardara direcciones de memoria.
#### Registros BP y SP:
Estos registros trabajan de la la mano y se asocian al registro de segmento `ss`. Estos registros se usan en conjunto para manipular el `stack`, también conocido como pila. `bp` viene de `Base Pointer` que es lo mismo que `Puntero Base` y `sp` proviene de `Stack Pointer` o `Puntero Stack`. Podéis encontrar mas información de estos registros y del uso de la pila en este apartado:

- [Registros BP, SP y la pila.](./sp-bp-pila.md)

Debemos mencionar, que al igual que los registro de tipo `A, B`, `C` y `D`, estos también tienen sus versiones en distintos tamaños y colores. Siendo `bpl`, `bp`, `ebp`, `rbp`, las correspondientes versiones de los registros de 8, 16, 32 y 64bits del `Base Pointer`. Y en el caso del `Stack Pointer`, sus registros son `spl`, `sp`, `esp`, `rsp`, siendo de 8, 16, 32 y 64bits. Los registros `sp` y `bo` también son conocidos como registros apuntadores, ya que apuntan normalmente a una dirección de memoria.
#### Registro Puntero de Instrucción (IP)
También conocido como `instruction pointer`, este registro tiene almacenado la dirección de memoria de la instrucción a ejecutar. Este registro es actualizado de forma automática por el procesador tras la ejecución de cada instrucción. Este registro trabaja junto al registro `cs`. En `cs` se especifica la dirección de segmento de código y `ip` contiene el desplazamiento dentro del segmento de código.

Si `cs` tiene un valor hexadecimal de `0x1234` y el registro `ip` tiene un valor de `0x0012`, la dirección de la siguiente instrucción a ejecutar es la suma del registro `cs` y del registro `ip`. `cs` + `ip` = `0x1234` + `0x0012` = `0x1246`. La dirección de la siguiente instrucción a ejecutar es `0x1246`.
El procesador aumenta el valor del registro `ip` acorde al tamaño de la instrucción anterior, si la instrucción anterior ocupaba `3bytes`, el nuevo valor de `ip` es el valor antiguo mas 3.

De este registro, el `ip`, también existe sus versiones de 8, 16, 32 y 64 bits, conocidos como `ipl`, `ip`, `eip` y `rip`. No estoy seguro de la existencia del registro `ipl` pero lo incluyo por si acaso y a ver si usted es capaz de encontrar algo acerca de el.
Como programadores, nosotros no podemos alterar el registro `ip` de forma directa, sino con instrucciones especificas como `jmp` o `call`.

----

### Los registros de propósito general extendido.

Estos registros solo los encontraremos en procesadores de `64bits`. Se usan para escribir y leer datos que podemos almacenar, tal como haríamos con `variables`. Existe 8 de estos registros y solo en procesadores de `64bits`. También tienen sus versiones de 8, 16, 32 y 64bits. De estos registros, los de `64bits` se llaman `r8`, `r9`, `r10`, `r11`, `r12`, `r13`, `r14` y `r15`. De los de `32bits` encontramos `r8d`, `r9d`, `r10d`, `r11d`, `r12d`, `r13d`, `r14d`. De los de `16bits` encontramos `r8w`, `r9w`, `r10w`, `r11w`, `r12w`, `r13w`, `r14w`.De los de `8bits` encontramos `r8b`, `r9b`, `r10b`, `r11b`, `r12b`, `r13b`, `r14b`.

| `64bits` |  `32bits` |  `16bits` |  ` 8bits` |
|:--------:|:---------:|:---------:|:---------:|
|   `r8`   |   `r8d`   |   `r8w`   |   `r8b`   |
|   `r9`   |   `r9d`   |   `r9w`   |   `r9b`   |
|   `r10`  |   `r10d`  |   `r10w`  |   `r10b`  |
|   `r11`  |   `r11d`  |   `r11w`  |   `r11b`  |
|   `r12`  |   `r12d`  |   `r12w`  |   `r12b`  |
|   `r13`  |   `r13d`  |   `r13w`  |   `r13b`  |
|   `r14`  |   `r14d`  |   `r14w`  |   `r14b`  |
|   `r15`  |   `r15d`  |   `r15w`  |   `r15b`  |

----
### Registros de bandera
Estos registros se usan para hacer bucles, condicionales, obtener información de si se produjo un overflow, si ocurrió un acarreo y etc. Funciona como un registro con indicadores de estados. En sistemas de ``16bits``, este registro se llamaba [[FLAGS|FLAG]] y tena las siguientes banderas:
```c
typedef struct CPU_struct_flags {
    // https://es.wikipedia.org/wiki/Registro_FLAGS
    // https://wiki.cheatengine.org/index.php?title=Assembler
    uint8_t CF   :1; // (00)    Bandera de acarreo 
                     // (01)    Reservado, siempre 1 en EFLAGS2​ 
    uint8_t PF   :1; // (02)    Bandera de paridad
                     // (03)    Reservado
    uint8_t AF   :1; // (04)    Bandera de ajuste; Se establece en un acarreo o préstamo al valor de los 4 bits de orden inferior. 
                     // (05)    Reservado
    uint8_t ZF   :1; // (06)    Bandera de cero
    uint8_t SF   :1; // (07)    Bandera de signo
    uint8_t TF   :1; // (08)    Bandera de trampa (paso único); Permite detener el código dentro de un segmento (permite el paso único/depuración en programación).
    uint8_t IF   :1; // (09)    Bandera de interrupción habilitada
    uint8_t DF   :1; // (10)    Bandera de dirección
    uint8_t OF   :1; // (11)    Bandera de desbordamiento 
    uint8_t IOPL :2; // (12-13) I/O Privilege Level Registro de 2 bits que especifica qué nivel de privilegio se requiere para acceder a los puertos IO.
    uint8_t NT   :1; // (14)    Tarea Anidada Se convierte en 1 cuando se realizan llamadas dentro de un programa.
                     // (15)    Reservado, siempre 1 en 8086 y 186, siempre 0 en modelos más recientes.
```


| Nombre   | Descripcion                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [[CF]]   | ``Bandera de acarreo``: Indica si ocurrió un acarreo. Por ejemplo si sumamos ``9 + 1`` será ``10``, ese ``1`` que nos levamos al realizar la suma, se le denomina acarreo. Esta ``flag`` es muy usada en operaciones aritméticas.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| [[PF]]   | ``Bandera de paridad``: se utiliza para indicar si el número de bits 1 en el byte menos significativo (los 8 bits más bajos) del resultado de una operación es par o impar.<br>- Se activa (se pone a 1) si el número de bits 1 en el byte menos significativo es par.<br>- Se desactiva (se pone a 0) si el número de bits 1 en el byte menos significativo es impar.<br>1. Ejemplos:<br>    - Resultado: ``10101010`` (4 unos) -> [[PF]] = ``1`` (par)<br>    - Resultado: ``10101011`` (5 unos) -> [[PF]] = ``0`` (impar)<br>Originalmente, se usaba para la detención simple de errores de comunicación, aunque a día de hoy su uso es menos común.<br>Esta flag es alterada mayormente por operaciones aritméticas y lógicas,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| [[AF]]   | ``Auxiliary Carry Flag``: se utiliza principalmente para operaciones aritméticas en [[BCD]] (``Binary-Coded Decimal``) aunque las instrucciones para [[BCD]] no se puede usar en [[modo-largo]].<br>- Se activa (se pone a 1) cuando ocurre un acarreo (``carry``) o un préstamo (``borrow``) entre los bits 3 y 4 de un byte en una operación aritmética.<br>Se ve afectada por operaciones aritméticas como operaciones de suma ([[ADD]]), resta ([[SUB]]), incremento ([[INC]]) y decremento ([[DEC]]) y por operaciones lógicas como [[AND]], [[OR]], [[XOR]].<br>Ejemplos de activación:<br>    - En una suma: Si ``0x0F + 0x01`` = ``0x10``, [[AF]] se activará porque hay un acarreo del bit 3 al bit 4.<br>    - En una resta: Si ``0x10 - 0x01`` = ``0x0F``, [AF] se activará porque hay un préstamo del bit 4 al bit 3.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| [[ZF]]   | ``Bandera cero``: Indica si una operación es cero.<br>- Se activa (se pone a 1) cuando el resultado de una operación es cero.<br>- Se desactiva (se pone a 0) cuando el resultado no es cero.<br>Es afectada por operaciones aritméticas y lógicas, pero también por instrucciones de comparación como [[CPM]] y operaciones de desplazamiento y rotación.<br>Es muy usada en estructuras de control condicionales (bucles, sentencias if, …).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| [[SF]]   | ``Bandera de signo``: Indica si el valor guardado de una operación, es negativo(``1``) o positivo (``0``).<br>Se ve afecta por operaciones aritméticas como suma, resta, multiplicación, división, por operaciones lógicas, por operaciones de desplazamiento y operaciones de rotacion.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| [[TF]]   | ``Trap Flag``: Se usa para la depuración de programas vía [[single-stepping]]. Cuando [[TF]] está activada (puesta a 1), el procesador genera una excepción de depuración (interrupción 1) después de ejecutar cada instrucción. <br> - Permite a los depuradores ejecutar un programa instrucción por instrucción.<br> - Facilita el análisis detallado del comportamiento del programa en tiempo de ejecución.<br>Generalmente se activa y desactiva por software de depuración. No se modifica directamente por instrucciones de programa normales. El sistema operativo generalmente guarda y restaura el estado de [[TF]] durante cambios de contexto. <br><br>En [[modo-largo]], el manejo de excepciones, incluida la excepción de depuración generada por [[TF]], puede ser ligeramente diferente debido a los cambios en la estructura de la tabla de descriptores de interrupción ([[IDT]]). Su manipulación directa generalmente está restringida en sistemas Windows y se maneja a través de ``APIs`` del sistema operativo o depuradores. Sin embargo, aquí te explico cómo se podría abordar teóricamente y algunas alternativas prácticas. <br>Se puede usar en Windows la función [[SetThreadContext]] para cambiar las ``flags`` de un ``Thread``/``Subrpoceso`` pero normalmente requiere privilegios. |
| [[IF]]   | `Interrupt Flag`: La ``flag`` de interrupciones es una bandera de control crucial, permite determinar si el procesador a de responder a interrupciones externas(interrupciones enmascarables) o si no lo a de hacer.<br>- Cuando [[IF]] está activada (``1``), el procesador puede responder a interrupciones externas.<br>- Cuando [[IF]] está desactivada (``0``), el procesador ignora las interrupciones enmascarables.<br>Esta ``flag`` se altera usando la instrucción [[CLI]](``Clear Interrupt Flag``) y se vuelve a activar usando [[STI]](``Set Interrupt Flag``). Solo el kernel en un sistema moderno, puede llamar a estas instrucciones para interactuar con la ``flag``.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| [[DF]]   | ``Direction Flag``: Se utiliza para controlar la dirección en la que se procesan las cadenas de datos en operaciones de cadena.<br>- Cuando [[DF]] está desactivada (``0``), las operaciones de cadena procesan de izquierda a derecha (incrementando los punteros de dirección).<br>- Cuando [[DF]] está activada (``1``), las operaciones de cadena procesan de derecha a izquierda (decrementando los punteros de dirección).<br><br>- [[CLD]] (``Clear Direction Flag``): Desactiva [[DF]], estableciendo el procesamiento de izquierda a derecha.<br>- [[STD]] (``Set Direction Flag``): Activa [[DF]], estableciendo el procesamiento de derecha a izquierda.<br><br>Se ve afectada por operaciones de cadena como [[MOVS]], [[CMPS]], [[SCAS]], [[LODS]], [[STOS]].<br><br>- Es crucial en la manipulación eficiente de cadenas y arrays.<br>- Permite recorrer datos en ambas direcciones sin necesidad de cambiar el código de la operación.                                                                                                                                                                                                                                                                                                                                                                    |
| [[OF]]   | ``Overflow Flag``: Se utiliza para detectar desbordamientos en operaciones aritméticas con números con signo.<br> - Se activa (1) cuando el resultado de una operación aritmética es demasiado grande o demasiado pequeño para ser representado en el formato de [[complemento_a_dos]] del operando de destino.<br><br>Afectada por:<br>    - Principalmente operaciones aritméticas como suma, resta, multiplicación y división con números con signo.<br>    - También se ve afectada por algunas operaciones de desplazamiento.<br><br>Se usa para:<br>- Detectar errores en cálculos con números enteros con signo.<br>- Utilizada en comprobaciones de rango y en la implementación de aritmética de precisión extendida.<br><br>Ejemplo:<br>En una suma: Si ``0x7FFFFFFF + 1`` = ``0x80000000``, [[OF]] se activará porque el resultado no puede representarse correctamente como un número positivo de 32 bits con signo.<br><br>**Mientras [[CF]] se usa para operaciones sin signo, [[OF]] se usa para operaciones con signo.**                                                                                                                                                                                                                                                                                 |
| [[IOPL]] | ``I/O Privilege Level``: Sirve para controlar el acceso a instrucciones de entrada/salida (``I/O``) y está relacionada con la seguridad y los privilegios del sistema. <br>Funcionamiento:<br>- [[IOPL]] consta de dos bits en el registro de ``flags`` (bits ``12`` y ``13``).<br>- Define el nivel de privilegio mínimo requerido para ejecutar instrucciones de ``I/O``.<br>- [[IOPL]] puede tener valores de ``0 a 3``, donde ``0`` es el nivel más privilegiado y ``3`` el menos.<br><br>Si el nivel de privilegio actual ([[CPL]]) es menor o igual que [[IOPL]], se permiten las operaciones de ``I/O``.<br>Si [[CPL]] > [[IOPL]], se genera una excepción al intentar ejecutar instrucciones de ``I/O``. Los sistemas operativos utilizan [[IOPL]] para proteger el hardware de accesos no autorizados.<br>Típicamente, solo el kernel del sistema operativo tiene acceso completo a las operaciones de ``I/O``.<br>Afecta a instrucciones como [[IN]], [[OUT]], [[INS]], [[OUTS]], [[CLI]], [[STI]], entre otras.<br><br>Modificación:<br>- Solo puede ser modificada por código que se ejecuta en el nivel de privilegio [[ring-0]] (``modo kernel``).<br>- Se cambia típicamente durante cambios de contexto o al entrar/salir del [[modo-protegido]].                                                        |
| [[NT]]   | ``Nested Task``: Indica si la tarea actual es una tarea anidada en el contexto de multitarea por hardware.<br>- Cuando [[NT]] está activada (``1``), indica que la tarea actual fue invocada por una instrucción [[CALL]] o una interrupción.<br>- Cuando está desactivada (``0``), indica que la tarea actual es la tarea base o no anidada.<br>1. Contexto histórico:<br>    - Era más relevante en los primeros procesadores x86 que soportaban multitarea por hardware.<br>    - En procesadores modernos, la multitarea se maneja principalmente por software (sistemas operativos).<br><br>Se utiliza en conjunto con la instrucción [[IRET]] (``Interrupt Return``) para determinar si se debe realizar un cambio de tarea.<br>Ayuda a mantener la integridad del estado de la tarea en sistemas que utilizan multitarea por hardware.<br>- Trabaja en conjunto con otras banderas y estructuras de control de tareas (como el [[TSS]] - Task State Segment).                                                                                                                                                                                                                                                                                                                                                     |
En 32bits se expandió el registro de 16bits a 32bits y se le denomino ``EFLAG``. De igual manera con 64bits, la cual se expandió a ``RFLAG``.

----
### Registros de segmentos

^7b52ac

En estos se almacenan direcciones de memoria de donde empieza y acaban los distintos segmentos que a dividido el OS. Vea [[segmentación]], [[registros-segmento-selectores-segmento]], [[Descriptor-de-segmento]]. En el [[modo-largo]] la segmentación no funciona igual que en el [[modo-protegido]], vera [[Recuperando-las-Call-Gates-Back]]. Los registros de segmentos en sistemas x86 son los siguientes:

| Nombre | Descripcion                             |
| ------ | --------------------------------------- |
| ``SS`` | Segmento de pila([[sp-bp-pila\|stack]]) |
| ``CS`` | Segmento al código(``Code``)            |
| ``DS`` | Segmento de datos(``Data``)             |
| ``ES`` | Segmento extra(``Extra``)               |
| ``FS`` | Segmento F(F viene después de E)        |
| ``GS`` | Segmento G(G viene después de F)        |
Originalmente en el [[8086]] solo había 4 registros de segmento, [[SS]], [[CS]], [[DS]] y [[ES]], a partir del [[modo-protegido]] se añadieron los segmentos [[FS]] y [[GS]] como extra.
```c
typedef struct Segment_reg { // registros de segmento:
    uint16_t SS;      // Segmento a la pila ('S' significa 'Stack').
    uint16_t CS;      // Segmento al código ('C' significa 'Code').
    uint16_t DS;      // Segmento de datos (DS). Puntero a los datos ('D' significa «Data»).
    uint16_t ES;      // Segmento extra (ES). Puntero a datos extra ('E' significa 'Extra'; 'E' viene después de 'D').
    uint16_t FS;      // Segmento F (FS). Puntero a más datos extra ('F' viene después de 'E').
    uint16_t GS;      // Segmento G (GS). Puntero a más datos adicionales ('G' viene después de 'F').
} __attribute__((packed)) Segment_reg;
```

---- 
### Registro de punto flotante
Estos registros se usan para hacer cálculos en paralelo y de coma flotante(double, float). Forman parte del llamado `juego de intrucciones extendidas x86`. Estos registros usan sus propias instrucciones para operar.

----
## Registros de control ([[control-registers]])
- [[CR0]]
- [[CR1]]
- [[CR2]]
- [[CR3]]
- [[CR4]]
- [[CR5]]
- [[CR6]]
- [[CR7]]
- [[CR8]]
- [[CR9]]
- [[CR10]]
- [[CR11]]
- [[CR12]]
- [[CR13]]
- [[CR14]]
- [[CR15]]