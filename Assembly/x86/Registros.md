https://help.totalview.io/current/HTML/index.html#page/TotalView/Intelx86MXSCRRegister_2.html
https://en.wikipedia.org/wiki/Task_state_segment
https://en.wikipedia.org/wiki/X86_debug_register
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
- Ocho registros MMX de 64 bits. (Estos registros se superponen con los registros x87). ^7e46b4
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

^7febb0


| Nombre   | Descripcion                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [[CF]]   | ``Bandera de acarreo``: Indica si ocurrió un acarreo. Por ejemplo si sumamos ``9 + 1`` será ``10``, ese ``1`` que nos levamos al realizar la suma, se le denomina acarreo. Esta ``flag`` es muy usada en operaciones aritméticas.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| [[PF]]   | ``Bandera de paridad``: se utiliza para indicar si el número de bits 1 en el byte menos significativo (los 8 bits más bajos) del resultado de una operación es par o impar.<br>- Se activa (se pone a 1) si el número de bits 1 en el byte menos significativo es par.<br>- Se desactiva (se pone a 0) si el número de bits 1 en el byte menos significativo es impar.<br>1. Ejemplos:<br>    - Resultado: ``10101010`` (4 unos) -> [[PF]] = ``1`` (par)<br>    - Resultado: ``10101011`` (5 unos) -> [[PF]] = ``0`` (impar)<br>Originalmente, se usaba para la detención simple de errores de comunicación, aunque a día de hoy su uso es menos común.<br>Esta flag es alterada mayormente por operaciones aritméticas y lógicas,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| [[AF]]   | ``Auxiliary Carry Flag``: se utiliza principalmente para operaciones aritméticas en [[BCD]] (``Binary-Coded Decimal``) aunque las instrucciones para [[BCD]] no se puede usar en [[Assembly/MODOS/modo-largo]].<br>- Se activa (se pone a 1) cuando ocurre un acarreo (``carry``) o un préstamo (``borrow``) entre los bits 3 y 4 de un byte en una operación aritmética.<br>Se ve afectada por operaciones aritméticas como operaciones de suma ([[ADD]]), resta ([[SUB]]), incremento ([[INC]]) y decremento ([[DEC]]) y por operaciones lógicas como [[AND]], [[OR]], [[XOR]].<br>Ejemplos de activación:<br>    - En una suma: Si ``0x0F + 0x01`` = ``0x10``, [[AF]] se activará porque hay un acarreo del bit 3 al bit 4.<br>    - En una resta: Si ``0x10 - 0x01`` = ``0x0F``, [AF] se activará porque hay un préstamo del bit 4 al bit 3.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| [[ZF]]   | ``Bandera cero``: Indica si una operación es cero.<br>- Se activa (se pone a 1) cuando el resultado de una operación es cero.<br>- Se desactiva (se pone a 0) cuando el resultado no es cero.<br>Es afectada por operaciones aritméticas y lógicas, pero también por instrucciones de comparación como [[CPM]] y operaciones de desplazamiento y rotación.<br>Es muy usada en estructuras de control condicionales (bucles, sentencias if, …).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| [[SF]]   | ``Bandera de signo``: Indica si el valor guardado de una operación, es negativo(``1``) o positivo (``0``).<br>Se ve afecta por operaciones aritméticas como suma, resta, multiplicación, división, por operaciones lógicas, por operaciones de desplazamiento y operaciones de rotacion.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| [[TF]]   | ``Trap Flag``: Se usa para la depuración de programas vía [[single-stepping]]. Cuando [[TF]] está activada (puesta a 1), el procesador genera una excepción de depuración (interrupción 1) después de ejecutar cada instrucción. <br> - Permite a los depuradores ejecutar un programa instrucción por instrucción.<br> - Facilita el análisis detallado del comportamiento del programa en tiempo de ejecución.<br>Generalmente se activa y desactiva por software de depuración. No se modifica directamente por instrucciones de programa normales. El sistema operativo generalmente guarda y restaura el estado de [[TF]] durante cambios de contexto. <br><br>En [[Assembly/MODOS/modo-largo]], el manejo de excepciones, incluida la excepción de depuración generada por [[TF]], puede ser ligeramente diferente debido a los cambios en la estructura de la tabla de descriptores de interrupción ([[IDT]]). Su manipulación directa generalmente está restringida en sistemas Windows y se maneja a través de ``APIs`` del sistema operativo o depuradores. Sin embargo, aquí te explico cómo se podría abordar teóricamente y algunas alternativas prácticas. <br>Se puede usar en Windows la función [[SetThreadContext]] para cambiar las ``flags`` de un ``Thread``/``Subrpoceso`` pero normalmente requiere privilegios. |
| [[IF]]   | `Interrupt Flag`: La ``flag`` de interrupciones es una bandera de control crucial, permite determinar si el procesador a de responder a interrupciones externas(interrupciones enmascarables) o si no lo a de hacer.<br>- Cuando [[IF]] está activada (``1``), el procesador puede responder a interrupciones externas.<br>- Cuando [[IF]] está desactivada (``0``), el procesador ignora las interrupciones enmascarables.<br>Esta ``flag`` se altera usando la instrucción [[CLI]](``Clear Interrupt Flag``) y se vuelve a activar usando [[STI]](``Set Interrupt Flag``). Solo el kernel en un sistema moderno, puede llamar a estas instrucciones para interactuar con la ``flag``.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| [[DF]]   | ``Direction Flag``: Se utiliza para controlar la dirección en la que se procesan las cadenas de datos en operaciones de cadena.<br>- Cuando [[DF]] está desactivada (``0``), las operaciones de cadena procesan de izquierda a derecha (incrementando los punteros de dirección).<br>- Cuando [[DF]] está activada (``1``), las operaciones de cadena procesan de derecha a izquierda (decrementando los punteros de dirección).<br><br>- [[CLD]] (``Clear Direction Flag``): Desactiva [[DF]], estableciendo el procesamiento de izquierda a derecha.<br>- [[STD]] (``Set Direction Flag``): Activa [[DF]], estableciendo el procesamiento de derecha a izquierda.<br><br>Se ve afectada por operaciones de cadena como [[MOVS]], [[CMPS]], [[SCAS]], [[LODS]], [[STOS]].<br><br>- Es crucial en la manipulación eficiente de cadenas y arrays.<br>- Permite recorrer datos en ambas direcciones sin necesidad de cambiar el código de la operación.                                                                                                                                                                                                                                                                                                                                                                                   |
| [[OF]]   | ``Overflow Flag``: Se utiliza para detectar desbordamientos en operaciones aritméticas con números con signo.<br> - Se activa (1) cuando el resultado de una operación aritmética es demasiado grande o demasiado pequeño para ser representado en el formato de [[complemento_a_dos]] del operando de destino.<br><br>Afectada por:<br>    - Principalmente operaciones aritméticas como suma, resta, multiplicación y división con números con signo.<br>    - También se ve afectada por algunas operaciones de desplazamiento.<br><br>Se usa para:<br>- Detectar errores en cálculos con números enteros con signo.<br>- Utilizada en comprobaciones de rango y en la implementación de aritmética de precisión extendida.<br><br>Ejemplo:<br>En una suma: Si ``0x7FFFFFFF + 1`` = ``0x80000000``, [[OF]] se activará porque el resultado no puede representarse correctamente como un número positivo de 32 bits con signo.<br><br>**Mientras [[CF]] se usa para operaciones sin signo, [[OF]] se usa para operaciones con signo.**                                                                                                                                                                                                                                                                                                |
| [[IOPL]] | ``I/O Privilege Level``: Sirve para controlar el acceso a instrucciones de entrada/salida (``I/O``) y está relacionada con la seguridad y los privilegios del sistema. <br>Funcionamiento:<br>- [[IOPL]] consta de dos bits en el registro de ``flags`` (bits ``12`` y ``13``).<br>- Define el nivel de privilegio mínimo requerido para ejecutar instrucciones de ``I/O``.<br>- [[IOPL]] puede tener valores de ``0 a 3``, donde ``0`` es el nivel más privilegiado y ``3`` el menos.<br><br>Si el nivel de privilegio actual ([[CPL]]) es menor o igual que [[IOPL]], se permiten las operaciones de ``I/O``.<br>Si [[CPL]] > [[IOPL]], se genera una excepción al intentar ejecutar instrucciones de ``I/O``. Los sistemas operativos utilizan [[IOPL]] para proteger el hardware de accesos no autorizados.<br>Típicamente, solo el kernel del sistema operativo tiene acceso completo a las operaciones de ``I/O``.<br>Afecta a instrucciones como [[IN]], [[OUT]], [[INS]], [[OUTS]], [[CLI]], [[STI]], entre otras.<br><br>Modificación:<br>- Solo puede ser modificada por código que se ejecuta en el nivel de privilegio [[ring-0]] (``modo kernel``).<br>- Se cambia típicamente durante cambios de contexto o al entrar/salir del [[Assembly/MODOS/modo-protegido]].                                                        |
| [[NT]]   | ``Nested Task``: Indica si la tarea actual es una tarea anidada en el contexto de multitarea por hardware.<br>- Cuando [[NT]] está activada (``1``), indica que la tarea actual fue invocada por una instrucción [[CALL]] o una interrupción.<br>- Cuando está desactivada (``0``), indica que la tarea actual es la tarea base o no anidada.<br>1. Contexto histórico:<br>    - Era más relevante en los primeros procesadores x86 que soportaban multitarea por hardware.<br>    - En procesadores modernos, la multitarea se maneja principalmente por software (sistemas operativos).<br><br>Se utiliza en conjunto con la instrucción [[IRET]] (``Interrupt Return``) para determinar si se debe realizar un cambio de tarea.<br>Ayuda a mantener la integridad del estado de la tarea en sistemas que utilizan multitarea por hardware.<br>- Trabaja en conjunto con otras banderas y estructuras de control de tareas (como el [[TSS]] - Task State Segment).                                                                                                                                                                                                                                                                                                                                                                    |
En 32bits se expandió el registro de 16bits a 32bits y se le denomino ``EFLAG``. De igual manera con 64bits, la cual se expandió a ``RFLAG``.

----
### Registros de segmentos

^7b52ac

En estos se almacenan direcciones de memoria de donde empieza y acaban los distintos segmentos que a dividido el OS. Vea [[segmentación]], [[registros-segmento-selectores-segmento]], [[Descriptor-de-segmento]]. En el [[Assembly/MODOS/modo-largo]] la segmentación no funciona igual que en el [[Assembly/MODOS/modo-protegido]], vera [[Recuperando-las-Call-Gates-Back]]. Los registros de segmentos en sistemas x86 son los siguientes:

| Nombre | Descripcion                             |
| ------ | --------------------------------------- |
| ``SS`` | Segmento de pila([[sp-bp-pila\|stack]]) |
| ``CS`` | Segmento al código(``Code``)            |
| ``DS`` | Segmento de datos(``Data``)             |
| ``ES`` | Segmento extra(``Extra``)               |
| ``FS`` | Segmento F(F viene después de E)        |
| ``GS`` | Segmento G(G viene después de F)        |
Originalmente en el [[8086]] solo había 4 registros de segmento, [[SS]], [[CS]], [[DS]] y [[ES]], a partir del [[Assembly/MODOS/modo-protegido]] se añadieron los segmentos [[FS]] y [[GS]] como extra.
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
### Registro de punto flotante (SEE)
Estos registros se usan para hacer cálculos en paralelo y de coma flotante(double, float). Forman parte del llamado `juego de intrucciones extendidas x86`. Estos registros usan sus propias instrucciones para operar.

En el conjunto SEE existe un registro de estado de banderas, que vendría siendo similar a [[flags-de-la-cpu|FLAGS & EFLAGS & RFLAGS]] llamado [[MXCSR]]

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

# Registro IDTR

^bccb95


# Registro TR (Registro de tareas)

^bd44f7
https://en.wikipedia.org/wiki/Task_state_segment
El registro TR es un registro de 16 bits que contiene un selector de segmento para el [[TSS]]. Se puede cargar a través de la instrucción [[LTR]]. [[LTR]] es una instrucción privilegiada y actúa de manera similar a otras cargas de registros de segmento. El registro de tareas tiene dos partes: una parte visible y accesible para el programador y una parte invisible que se carga automáticamente desde el descriptor [[TSS]].

# Registros de depuración (DR0, DR1, DR2, DR3, DR4, DR5, DR6, DR7)

^7d52f7

https://en.wikipedia.org/wiki/X86_debug_register
En la arquitectura x86, un registro de depuración es un registro que utiliza un procesador para depurar programas. Hay seis registros de depuración, denominados DR0...DR7, con DR4 y DR5 como sinónimos obsoletos de DR6 y DR7. Los registros de depuración permiten a los programadores habilitar de forma selectiva varias condiciones de depuración asociadas con un conjunto de cuatro direcciones de depuración. Dos de estos registros se utilizan para controlar las funciones de depuración. Se accede a estos registros mediante variantes de la instrucción MOV. Un registro de depuración puede ser el operando de origen o el operando de destino. Los registros de depuración son recursos privilegiados; las instrucciones MOV que acceden a ellos solo se pueden ejecutar en el nivel de privilegio cero o [[ring-0]]. Un intento de leer o escribir los registros de depuración cuando se ejecuta en cualquier otro nivel de privilegio provoca un fallo de protección general.
#### DR0 a DR3
Cada uno de estos registros contiene la dirección lineal asociada con una de las cuatro condiciones de punto de interrupción. Cada condición de punto de interrupción se define con más detalle mediante bits en DR7.

Los registros de dirección de depuración son efectivos independientemente de si la paginación está habilitada o no. Las direcciones en estos registros son direcciones lineales. Si la paginación está habilitada, las direcciones lineales se traducen en direcciones físicas mediante el mecanismo de paginación del procesador. Si la paginación no está habilitada, estas direcciones lineales son las mismas que las direcciones físicas.

Tenga en cuenta que cuando la paginación está habilitada, las diferentes tareas pueden tener diferentes asignaciones de direcciones lineales a físicas. Cuando este es el caso, una dirección en un registro de dirección de depuración puede ser relevante para una tarea pero no para otra. Por este motivo, el x86 tiene bits de habilitación globales y locales en DR7. Estos bits indican si una dirección de depuración determinada tiene una relevancia global (todas las tareas) o local (solo la tarea actual).

#### DR6 - Estado de depuración
El registro de estado de depuración permite al depurador determinar qué condiciones de depuración se han producido. Cuando el procesador detecta una excepción de depuración habilitada, activará los bits correspondientes de este registro antes de entrar en el controlador de excepciones de depuración.

| Bits  | Abbreviation  | Description                                                                                                                                                                                                                                                                                                                                                                                                |
| ----- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0     | B0            | Breakpoint #0 Condition Detected[a](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_condition-3)                                                                                                                                                                                                                                                                                          |
| 1     | B1            | Breakpoint #1 Condition Detected[a](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_condition-3)                                                                                                                                                                                                                                                                                          |
| 2     | B2            | Breakpoint #2 Condition Detected[a](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_condition-3)                                                                                                                                                                                                                                                                                          |
| 3     | B3            | Breakpoint #3 Condition Detected[a](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_condition-3)                                                                                                                                                                                                                                                                                          |
| 10:4  | —             | Reserved.  <br>Read as all-0s on 386/486 processors, all-1s on later processors.[3](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-potemkin-4)                                                                                                                                                                                                                                                 |
| 11    | BLD           | Cleared to 0 by the processor for Bus Lock Trap exceptions.[b](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-5)[4](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-6)<br><br>On processors that don't support Bus Lock Trap exceptions, bit 11 of DR6 is a read-only bit, acting in the same way as bits 10:4.                                                                     |
| 12    | BK,  <br>SMMS | (386/486 only) SMM or ICE mode entered[3](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-potemkin-4) (see also DR7, bit 12).  <br>Reserved and read as 0 on all later processors.                                                                                                                                                                                                              |
| 13    | BD            | Debug Register Access Detected[c](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-7)[d](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-dr6_noclear-8)[e](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-9) (see also DR7, bit 13).                                                                                                                                      |
| 14    | BS            | Single-Step execution (enabled by [EFLAGS.TF](https://en.wikipedia.org/wiki/FLAGS_register "FLAGS register"))[d](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-dr6_noclear-8)                                                                                                                                                                                                                 |
| 15    | BT            | Task Switch breakpoint.[d](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-dr6_noclear-8)  <br>Occurs when a task switch is done with a [TSS](https://en.wikipedia.org/wiki/Task_state_segment "Task state segment") that has the T (debug trap flag) bit set.                                                                                                                                  |
| 16    | RTM           | (Processors with [Intel TSX](https://en.wikipedia.org/wiki/Intel_TSX "Intel TSX") only)  <br>Cleared to 0 by the processor for debug exceptions inside RTM transactions,[f](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-10) set to 1 for all debug exceptions outside transactions.  <br>On processors without TSX, bit 16 of DR6 is a read-only bit, acting in the same way as bits 31:17. |
| 31:17 | —             | Reserved.  <br>Read as all-0s on 386/486/[6x86](https://en.wikipedia.org/wiki/Cyrix_6x86 "Cyrix 6x86") processors, all-1s on later processors.                                                                                                                                                                                                                                                             |
| 63:32 | —             | (x86-64 only) Reserved.  <br>Read as all-0s. Must be written as all-0s.                                                                                                                                                                                                                                                                                                                                    |
#### DR7 - Control de depuración
El registro de control de depuración se utiliza para habilitar de forma selectiva las cuatro condiciones de punto de interrupción de dirección y para especificar el tipo y el tamaño de cada uno de los cuatro puntos de interrupción. Hay dos niveles de habilitación: los niveles local (0, 2, 4, 6) y global (1, 3, 5, 7). El procesador restablece automáticamente los bits de habilitación local en cada cambio de tarea para evitar condiciones de punto de interrupción no deseadas en la nueva tarea. Los bits de habilitación global no se restablecen con un cambio de tarea; por lo tanto, se pueden utilizar para condiciones que son globales para todas las tareas.

| Bits  | Abbreviation  | Description                                                                                                                                                                                                                                                                                                                |
| ----- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0     | L0            | Local enable for breakpoint #0.                                                                                                                                                                                                                                                                                            |
| 1     | G0            | Global enable for breakpoint #0.                                                                                                                                                                                                                                                                                           |
| 2     | L1            | Local enable for breakpoint #1.                                                                                                                                                                                                                                                                                            |
| 3     | G1            | Global enable for breakpoint #1.                                                                                                                                                                                                                                                                                           |
| 4     | L2            | Local enable for breakpoint #2.                                                                                                                                                                                                                                                                                            |
| 5     | G2            | Global enable for breakpoint #2.                                                                                                                                                                                                                                                                                           |
| 6     | L3            | Local enable for breakpoint #3.                                                                                                                                                                                                                                                                                            |
| 7     | G3            | Global enable for breakpoint #3.                                                                                                                                                                                                                                                                                           |
|       |               |                                                                                                                                                                                                                                                                                                                            |
| 8     | LE            | (386 only) Local Exact Breakpoint Enable.[a](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-exact386-12)                                                                                                                                                                                                       |
| 9     | GE            | (386 only) Global Exact Breakpoint Enable.[a](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-exact386-12)                                                                                                                                                                                                      |
| 10    | —             | Reserved, read-only, read as 1 and should be written as 1.                                                                                                                                                                                                                                                                 |
| 11    | RTM           | (Processors with [Intel TSX](https://en.wikipedia.org/wiki/Intel_TSX "Intel TSX") only)  <br>Enable advanced debugging of RTM transactions (only if `DEBUGCTL` bit 15 is also set)  <br>On other processors: reserved, read-only, read as 0 and should be written as 0.                                                    |
| 12    | IR,  <br>SMIE | (386/486 processors only) Action on breakpoint match:  <br>0 = INT 1 (#DB exception, default)  <br>1 = Break to ICE/SMM[b](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-15)  <br>On other processors: Reserved, read-only, read as 0 and should be written as 0.                                             |
| 13    | GD            | General Detect Enable. If set, will cause a debug exception on any attempt at accessing the DR0-DR7 registers.[c](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-16)                                                                                                                                           |
| 15:14 | —             | Reserved, should be written as all-0s.[d](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-18)                                                                                                                                                                                                                   |
|       |               |                                                                                                                                                                                                                                                                                                                            |
| 17:16 | R/W0          | Breakpoint condition for breakpoint #0.[e](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_type-19)                                                                                                                                                                                                       |
| 19:18 | LEN0          | Breakpoint length for breakpoint #0.[f](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_len-20)                                                                                                                                                                                                           |
| 21:20 | R/W1          | Breakpoint condition for breakpoint #1.[e](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_type-19)                                                                                                                                                                                                       |
| 23:22 | LEN1          | Breakpoint length for breakpoint #1.[f](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_len-20)                                                                                                                                                                                                           |
| 25:24 | R/W2          | Breakpoint condition for breakpoint #2.[e](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_type-19)                                                                                                                                                                                                       |
| 27:26 | LEN2          | Breakpoint length for breakpoint #2.[f](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_len-20)                                                                                                                                                                                                           |
| 29:28 | R/W3          | Breakpoint condition for breakpoint #3.[e](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_type-19)                                                                                                                                                                                                       |
| 31:30 | LEN3          | Breakpoint length for breakpoint #3.[f](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-brkpt_len-20)                                                                                                                                                                                                           |
|       |               |                                                                                                                                                                                                                                                                                                                            |
| 32    | DR0_PT_LOG    | Enable DR0/1/2/3 breakpoint match as a trigger input for PTTT (Processor Trace Trigger Tracing).[9](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-21)<br><br>Read as 0 and must be written as all-0s on processors that don't support PTTT.[g](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-22) |
| 33    | DR1_PT_LOG    | Enable DR0/1/2/3 breakpoint match as a trigger input for PTTT (Processor Trace Trigger Tracing).[9](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-21)<br><br>Read as 0 and must be written as all-0s on processors that don't support P                                                                       |
| 34    | DR2_PT_LOG    | Enable DR0/1/2/3 breakpoint match as a trigger input for PTTT (Processor Trace Trigger Tracing).[9](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-21)<br><br>Read as 0 and must be written as all-0s on processors that don't support P                                                                       |
| 35    | DR3_PT_LOG    | Enable DR0/1/2/3 breakpoint match as a trigger input for PTTT (Processor Trace Trigger Tracing).[9](https://en.wikipedia.org/wiki/X86_debug_register#cite_note-21)<br><br>Read as 0 and must be written as all-0s on processors that don't support P                                                                       |
| 63:36 | —             | (x86-64 only) Reserved.  <br>Read as all-0s. Must be written as all-0s.                                                                                                                                                                                                                                                    |

# Registros de rango de tipo de memoria (MTRR)

^af9eb5

https://es.wikipedia.org/wiki/Registro_de_rango_de_tipo_de_memoria#:~:text=Los%20registros%20de%20rango%20de,accesos%20a%20rangos%20de%20memoria.

Los **registros de rango de tipo de memoria** (**MTRRs**, del inglés _memory type range registers_) son un conjunto de [registros](https://es.wikipedia.org/wiki/Registro_(hardware) "Registro (hardware)") extendidos que proveen a [software de sistema](https://es.wikipedia.org/wiki/Software_de_sistema "Software de sistema") con control sobre la manera en que el CPU [cachea](https://es.wikipedia.org/wiki/Cach%C3%A9_de_CPU "Caché de CPU") accesos a rangos de [memoria](https://es.wikipedia.org/wiki/Memoria_(inform%C3%A1tica) "Memoria (informática)"). Constan de [registros de modelo específico](https://es.wikipedia.org/w/index.php?title=Registro_de_modelo_espec%C3%ADfico&action=edit&redlink=1 "Registro de modelo específico (aún no redactado)") (MSRs), registros especiales proporcionados por CPUs modernos. Los modos de acceso posibles para regiones de memoria incluyen no cachear, [escribir a través de](https://es.wikipedia.org/wiki/Cach%C3%A9_(inform%C3%A1tica) "Caché (informática)"), combinación de escrituras, protección de escritura y [retardo de escritura](https://es.wikipedia.org/wiki/Cach%C3%A9_(inform%C3%A1tica) "Caché (informática)"). En modo de retardo de escritura, las escrituras se realizan [a](https://es.wikipedia.org/wiki/Unidad_central_de_procesamiento "Unidad central de procesamiento") caché, que se marca como modificado, de modo que sus contenidos serán escritos a memoria en algún momento posterior.

#### Combinación de escrituras
La combinación de escritura permite a las transferencias de escritura ser combinadas en una transferencia más grande antes de pasarlas al bus de memoria, lo cual facilita escrituras más eficientes a recursos del sistema tales como [memoria gráfica](https://es.wikipedia.org/wiki/Memoria_gr%C3%A1fica_de_acceso_aleatorio "Memoria gráfica de acceso aleatorio").Esto a menudo aumenta la velocidad de operaciones de escritura de imagen en varios órdenes de magnitud, a costo de perder las sencillas semánticas de lectura y escritura secuencial de la memoria normal. Existen bits adicionales proporcionados por [arquitecturas](https://es.wikipedia.org/wiki/Arquitectura_de_computadoras "Arquitectura de computadoras"), como [AMD64](https://es.wikipedia.org/wiki/X86-64 "X86-64"), admiten el _shadowing_ de contenidos de ROM en la memoria de sistema ([ROM](https://es.wikipedia.org/wiki/Memoria_de_solo_lectura "Memoria de solo lectura") sombra), y la configuración de [E/S mapeada en memoria](https://es.wikipedia.org/wiki/E/S_mapeada_en_memoria "E/S mapeada en memoria").

#### MTRRs en procesadores x86
En sistemas [x86](https://es.wikipedia.org/wiki/X86 "X86") tempranos, especialmente cuando [caché](https://es.wikipedia.org/wiki/Cach%C3%A9_de_CPU "Caché de CPU") se encontraba en chips externos al paquete de CPU, esta función estuvo controlada por el [chipset](https://es.wikipedia.org/wiki/Chipset "Chipset") y configurada en preferencias de [BIOS](https://es.wikipedia.org/wiki/BIOS "BIOS").

Cuando se movió caché al mismo paquete el que CPU, los CPUs comenzaron a implementar _MTRRs de rango fijo_ que cubren el primer [mebibyte](https://es.wikipedia.org/wiki/Mebibyte "Mebibyte") de memoria por compatibilidad con lo que los BIOSes proporcionaban en aquel tiempo. Estos suelen controlar la política de caché necesitada para el acceso a [VGA](https://es.wikipedia.org/wiki/Video_Graphics_Array "Video Graphics Array") y todos los accesos de memoria mientras el sistema se ejecuta en [modo real](https://es.wikipedia.org/wiki/Modo_real "Modo real"). Por enciam de 1 MiB, los CPUs proporcionar un número de _MTRRs de rango variable_, los cuales pueden ser libremente delimitados e incluso traslaparse entre sí. Estos MTRRs de rango variable pueden ser utilizados para establecer la política de caché de memoria gráfica y otros rangos de memoria utilizados por dispositivos [PCI](https://es.wikipedia.org/wiki/Peripheral_Component_Interconnect "Peripheral Component Interconnect").

Empezando con la familia Intel P6 ([Pentium Pro](https://es.wikipedia.org/wiki/Pentium_Pro "Pentium Pro"), [Pentium II](https://es.wikipedia.org/wiki/Pentium_II "Pentium II") y posteriores), los MTRRs pueden usarse para controlar el acceso del procesador a rangos de memoria.[1](https://es.wikipedia.org/wiki/Registro_de_rango_de_tipo_de_memoria#cite_note-The_Linux_Gamers-1)​

Los procesadores [Cyrix](https://es.wikipedia.org/wiki/Cyrix "Cyrix") [6x86](https://es.wikipedia.org/wiki/Cyrix_6x86 "Cyrix 6x86"), [6x86MX](https://es.wikipedia.org/wiki/Cyrix_6x86 "Cyrix 6x86") y [MII](https://es.wikipedia.org/wiki/Cyrix_6x86 "Cyrix 6x86") tienen Registros de Rango de Direcciones (ARRs) que proporcionan una funcionalidad similar a los MTRRs.

El [AMD](https://es.wikipedia.org/wiki/Advanced_Micro_Devices "Advanced Micro Devices") [K6-2](https://es.wikipedia.org/wiki/AMD_K6-2 "AMD K6-2") (_stepping_ 8 y superior) y el K6-III tienen dos MTRRs. La familia AMD [Athlon](https://es.wikipedia.org/wiki/AMD_Athlon "AMD Athlon") proporciona 8 MTRRs compatibles con Intel.

El [Centaur](https://es.wikipedia.org/wiki/Centaur_Technology "Centaur Technology") C6 WinChip tiene 8 registros de este tipo, permitiendo combinación de escrituras.

Los procsadores VIA Cyrix III y [VIA](https://es.wikipedia.org/wiki/VIA_Technologies "VIA Technologies") C3 ofrecen 8 MTRRs compatibles con Intel.

La interfaz de memoria de CPUs [AMD K8](https://es.wikipedia.org/wiki/Advanced_Micro_Devices "Advanced Micro Devices") soporta "codificaciones extendidas del campo tipo de MTRR de rango fijo" que permite especificar si los accesos a ciertos rangos de direcciones son ejecutados accesando a RAM a través del _Direct Connect Architecture_ o por [E/S mapeada en memoria](https://es.wikipedia.org/wiki/E/S_mapeada_en_memoria "E/S mapeada en memoria"). Esto permite, por ejemplo, [RAM sombra](https://es.wikipedia.org/wiki/Memoria_de_acceso_aleatorio "Memoria de acceso aleatorio") implementada copiando contenidos de [ROM](https://es.wikipedia.org/wiki/Memoria_de_solo_lectura "Memoria de solo lectura") a [RAM](https://es.wikipedia.org/wiki/Memoria_de_acceso_aleatorio "Memoria de acceso aleatorio").

#### Sucesores
CPUs x86 más recientes soportan una técnica más avanzada llamada [tablas de atributos de página](https://es.wikipedia.org/wiki/Tabla_de_atributos_de_p%C3%A1gina "Tabla de atributos de página") ([[PAT]]s) que permite selección de modos por página individual, en vez de haber un número limitado de registros de baja granularidad, para tratar con tamaños de memoria modernos.

Los detalles del funcionamiento de los MTRRs se describen en los manuales de procesador de los distintos vendedores.