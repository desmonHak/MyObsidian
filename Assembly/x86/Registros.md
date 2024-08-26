
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
## Convenciones de llamada

A diferencia de x86, el compilador de C/C++ solo admite una convención de llamada en x64. Esta convención de llamada aprovecha el mayor número de registros disponibles en x64:

- Los cuatro primeros parámetros enteros o de puntero se pasan en los registros **rcx**, **rdx**, **r8** y **r9** .

- Los cuatro primeros parámetros de punto flotante se pasan en los cuatro primeros registros SSE, **xmm0**-**xmm3**.

- El autor de la llamada reserva espacio en la pila para los argumentos pasados en los registros. La función llamada puede usar este espacio para volcar el contenido de los registros en la pila.

- Los argumentos adicionales se pasan en la pila.

- Se devuelve un valor devuelto de entero o puntero en el registro **rax** , mientras que se devuelve un valor devuelto de punto flotante en **xmm0**.

- **rax**, **rcx**, **rdx**, **r8**-**r11** son volátiles.

- **rbx**, **rbp**, **rdi**, **rsi**, **r12**-**r15** son no volátiles.

La convención de llamada para C++ es similar. **Este puntero** se pasa como primer parámetro implícito. Los tres parámetros siguientes se pasan en los registros restantes, mientras que el resto se pasan en la pila.
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
Estos registros se usan para hacer bucles, condicionales, obtener información de si se produjo un overflow, si ocurrió un acarreo y etc.

----
### Registros de segmentos

^7b52ac

En estos se almacenan direcciones de memoria de donde empieza y acaban los distintos segmentos que a dividido el OS. Saber que segmentos son de datos, que segmento son de instrucciones y etc.

---- 
### Registro de punto flotante
Estos registros se usan para hacer cálculos en paralelo y de coma flotante(double, float). Forman parte del llamado `juego de intrucciones extendidas x86`. Estos registros usan sus propias instrucciones para operar.