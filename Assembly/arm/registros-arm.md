https://help.totalview.io/current/HTML/index.html#page/TotalView/totalviewref-architectures.58.13.html#

### Para ARM32
Arm 32 tiene 16 registro, de r0 a r15 siendo cada uno de 32bits
![[Pasted image 20250419194610.png]]

Todos los registros son de propósito general, excepto:

- R13 / SP → que contiene el puntero de pila.
- R14 / LR → el registro de enlace que contiene la dirección de retorno de los llamantes.
- R15 / PC → que contiene el contador de programa.

#### En modo ARM:
Las instrucciones tienen 32 bits de ancho.
Todas las instrucciones deben estar alineadas por palabra.
El PC está en bits [31:2] y los bits [1:0] no están definidos.

#### En modo Thumb:
Las instrucciones tienen 16 bits de ancho.
Todas las instrucciones deben estar alineadas por media palabra.
El PC está en bits [31:1] y el bit 0 no está definido.

#### pero en modo Jazelle
Las instrucciones tienen 8 bits de ancho. Se obtienen cuatro a la vez.
### Para ARM64 
La ISA AArch64 define 31 registros de propósito general que se pueden usar para almacenar valores de 64 o 32 bits y puede encontrarlos referenciados como *Xn*, *Wn* o *Rn* (las mayúsculas son opcionales), donde *n* es el índice del registro (un número de 0 a 30).

Cuando se utilizan para almacenar 64 bits, se les asigna la letra X.
Cuando se utilizan para 32 bits, se les asigna la letra W.
O, de forma más general (independientemente del tamaño), se les puede asignar la letra R.

Por ejemplo, para referirse a la parte inferior del registro con índice 0 utilice el símbolo W0 y para todos los 64 bits puede utilizar X0:
![[Pasted image 20250419195142.png]]
Registros R0 a R7: se utilizan para guardar argumentos cuando se llama a una función (ver a continuación), mientras que el R0 se utiliza también para almacenar el resultado que devuelve una función.

>Nota: Cuando se llama a una función, el compilador utiliza un marco de pila (ubicado en la pila de ejecución del programa) para almacenar toda la información temporal que la función requiere para su funcionamiento. Según la convención de llamada, la función que la llama colocará esta información en registros específicos, en la pila o en ambos. Por ejemplo, la convención de llamada de C ([[__cdecl]], por sus siglas en inglés) coloca hasta seis argumentos en los registros RDI, RSI, RDX, RCX, R8 y R9, y cualquier valor adicional se coloca en la pila.

- **Registro R8:** (_Registro de ubicación de resultado indirecto_), utilizado en C++ para devolver objetos no triviales (definidos por el llamador).
- **Registros R9 a R15:** (conocidos como _registros scratch_) pueden usarse en cualquier momento sin suposiciones sobre su contenido.
- **Registros R16, R17:** (_registros temporales de llamada intraprocedimiento_) El enlazador puede usarlos en código PLT. Pueden usarse como registros temporales entre llamadas.
- **Registro R18:** (_registro de plataforma_) reservado para el uso de la ABI de plataforma. Por ejemplo, para la ABI de Windows, en modo kernel, apunta a [KPCR](https://en.wikipedia.org/wiki/Processor_Control_Region) para el procesador actual. En modo usuario, apunta a [TEB](https://docs.microsoft.com/en-us/windows/win32/debug/thread-environment-block--debugging-notes-).
- **Registros R19-R28:** también pueden usarse como registros de referencia, pero su contenido debe guardarse antes de su uso y restaurarse posteriormente.
- **Registro** **R29:** se usa como _Puntero de Marco_, apuntando al marco de pila actual y suele ser útil cuando el programa se ejecuta bajo un depurador. El compilador GNU C tiene una opción para usar _R29_ como registro de propósito general mediante la opción _-fomit-frame-pointer_.
- **Registro** **R30:** se conoce como _registro de enlace (lr)_ y puede usarse para almacenar la dirección de retorno durante una llamada a una función, una alternativa a guardar la dirección en la pila de llamadas. Ciertas instrucciones de bifurcación y enlace almacenan la dirección actual en el registro de enlace antes de que el contador de programa (el registro que contiene la dirección de la siguiente instrucción) cargue la nueva dirección.
- El **puntero de pila (sp)** almacena la dirección correspondiente al final de la pila (o, como se dice comúnmente, apuntando a la parte superior de la pila). Esta dirección cambia cuando se insertan registros en la pila o durante la asignación o eliminación de variables locales.
- El **contador de programa (pc)** contiene la siguiente dirección que contiene el código a ejecutar. Se incrementa automáticamente en cuatro después de cada instrucción, aunque puede modificarse con un pequeño número de instrucciones (por ejemplo, adr o ldr). Esto permite saltar a una nueva dirección y comenzar a ejecutar código desde allí.
- El **registro cero** (denominado **zr**, **xzr** o **wzr**) es un registro especial (https://en.wikichip.org/w/index.php?title=special-purpose_register&action=edit&redlink=1) que está conectado al valor entero `0`. Escribir en ese registro siempre se descarta y leer su valor siempre dará como resultado la lectura de un "0":
![[1_CpT9ukirZHek24DoA4dx5g.webp]]
El registro **PSTATE** es un conjunto de campos utilizados principalmente por el sistema operativo. Los programas de usuario utilizan los primeros cuatro bits, marcados como N, Z, C y V respectivamente (denominados _indicadores de condición_), donde cada uno se interpreta de la siguiente manera:
- **N** → Negativo: el indicador se establece en 1 cuando el resultado (con signo) de una operación es negativo.
- **Z** → Cero: el indicador se establece en 1 cuando el resultado de una operación es 0 y en 0 cuando el resultado es distinto de 0.
- **C** → Acarreo: el indicador se establece en 1 si una operación de suma resulta en un acarreo o una operación de resta resulta en un préstamo.
- **O** → Desbordamiento: se establece en 1 si se produce un desbordamiento con signo durante una suma o resta.
![[1_6UJmLzfYnOOZbtAJGUS4Vg.webp]]

La arquitectura *AArch64*(**ARM64**) también admite 32 registros de coma flotante/*SIMD*, numerados del 0 al 31, donde se puede acceder a cada uno como un valor completo de 128 bits (usando *v0* a *v31* o *q0* a *q31*), un valor de 64 bits (usando *d0* a *d31*), un valor de 32 bits (usando *s0* a *s31*), un valor de 16 bits (usando h0 a h31) o un valor de 8 bits (usando *b0* a *b31*). Al referenciar menos de 128 bits, solo se accede a los bits inferiores del registro completo de 128 bits, dejando los bits restantes intactos a menos que se especifique lo contrario.