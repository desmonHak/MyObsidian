# Pila en 32bits
En 32bits la convenciones mas usadas son [[__cdecl]]



# Pila en 64bits

[https://learn.microsoft.com/es-es/cpp/build/stack-usage?view=msvc-170](https://learn.microsoft.com/es-es/cpp/build/stack-usage?view=msvc-170)

Toda la memoria más allá de la dirección actual de RSP se considera volátil: el sistema operativo o un depurador pueden sobrescribir esta memoria durante una sesión de depuración de usuario o un controlador de interrupción. Por lo tanto, RSP siempre debe establecerse antes de intentar leer o escribir valores en un marco de pila.

En esta sección se describe la asignación de espacio de pila a variables locales y el intrínseco **alloca**

## Asignación de pila

El prólogo de una función es responsable de asignar espacio de pila a variables locales, registros guardados, parámetros de pila y parámetros de registro.

El área de parámetros se encuentra siempre en la parte inferior de la pila (aunque se use `alloca`), para esté adyacente en todo momento a la dirección de devolución durante cualquier llamada de función. Contiene como mínimo cuatro entradas, pero siempre incluye espacio suficiente para contener todos los parámetros que necesita cualquier función a la que se pueda llamar. Tenga en cuenta que siempre se asigna espacio para los parámetros de registro, incluso si los parámetros en sí mismos no se alojan nunca en la pila. De este modo, un destinatario tiene la garantía de que se ha asignado espacio para todos sus parámetros. Se requieren direcciones principales para los argumentos de registro, por lo que hay disponible un área contigua en caso de que la función a la que se llama deba tomar la dirección de la lista de argumentos (va_list) o de un argumento independiente. Esta área también proporciona un lugar conveniente para guardar los argumentos de registro durante la ejecución del código thunk y como opción de depuración (por ejemplo, facilita la búsqueda de argumentos durante la depuración si están almacenados en sus direcciones principales en el código de prólogo). Incluso si la función a la que se llama tiene menos de cuatro parámetros, estas cuatro ubicaciones de la pila son propiedad de la función a la que se llama y esta puede usarlas para otros fines, además de para guardar los valores de registro de parámetros. Por lo tanto, es posible que el autor de la llamada no guarde información en esta región de la pila a lo largo de una llamada de función.

Si el espacio se asigna dinámicamente (`alloca`) en una función, se debe usar un registro no volátil como puntero de marco para marcar la base de la parte fija de la pila, y dicho registro debe guardarse e inicializarse en el prólogo. Tenga en cuenta que cuando se usa `alloca`, las llamadas al mismo destinatario procedentes del mismo autor de la llamada pueden tener direcciones principales diferentes para sus parámetros de registro.

La pila siempre se mantendrá siempre con una alineación de 16 bytes, excepto en el prólogo (por ejemplo, después de insertar la dirección de devolución) y cuando se indique en los [tipos de función](https://learn.microsoft.com/es-es/cpp/build/stack-usage?view=msvc-170#function-types) para una clase determinada de funciones de marco.

A continuación se incluye un ejemplo de diseño de pila, en el que la función A llama a una función B no hoja. El prólogo de la función A ya ha asignado espacio para todos los parámetros de pila y de registro que requiere B en la parte inferior de la pila. La llamada inserta la dirección de retorno y el prólogo de B asigna espacio para sus variables locales, registros no volátiles y el espacio necesario para que llame a las funciones. Si B usa `alloca`, el espacio se asigna entre la variable local/el área de almacenamiento del registro no volátil y el área de la pila de parámetros.

![[Pasted image 20240810140504.png]]

Cuando la función B llama a otra función, la dirección de devolución se inserta justo debajo de la dirección principal de RCX.

## Tipos de función
Básicamente, hay dos tipos de función. Una función que requiere un marco de pila se denomina _función de marco_. Una función que no requiere un marco de pila se denomina _función de hoja_.

Una función de marco es aquella que asigna espacio de pila, llama a otras funciones, guarda registros no volátiles o usa el control de excepciones. Además, requiere una entrada de la tabla de funciones. Una función de marco requiere un prólogo y un epílogo. También puede asignar dinámicamente espacio de pila y emplear un puntero de marco. Además, tiene a su disposición todas las capacidades de este estándar de llamada.

Si una función de marco no llama a otra función, no es necesario alinear la pila (como se indica en la sección [Asignación de pila](https://learn.microsoft.com/es-es/cpp/build/stack-usage?view=msvc-170#stack-allocation)).

Una función de hoja es aquella que no requiere una entrada de la tabla de funciones. No puede realizar cambios en los registros no volátiles, incluido RSP, lo que significa que no puede llamar a ninguna función ni asignar espacio de pila. La pila puede dejarse sin alinear mientras se ejecuta.
## Alineación de malloc
Se garantiza que [malloc](https://learn.microsoft.com/es-es/cpp/c-runtime-library/reference/malloc?view=msvc-170) devolverá memoria correctamente alineada para almacenar cualquier objeto que tenga una alineación fundamental y que quepa en la cantidad de memoria asignada. Una _alineación fundamental_ es aquella menor o igual que la alineación más grande que la implementación admite sin una especificación de alineación. (En Visual C++, esta es la alineación necesaria para un **`double`**, u 8 bytes. En el código destinado a plataformas de 64 bits, es de 16 bytes). Por ejemplo, una asignación de cuatro bytes se alinearía en un límite que admita cualquier objeto de cuatro bytes o más pequeño.

Visual C++ permite tipos que tienen una _alineación extendida_, conocidos también como tipos _alineados en exceso_. Por ejemplo, los tipos de SSE [__m128](https://learn.microsoft.com/es-es/cpp/cpp/m128?view=msvc-170) y `__m256`, y los tipos que se declaran mediante `__declspec(align( n ))`, donde `n` es mayor que 8, tienen alineación extendida. `malloc` no garantiza la alineación de memoria en un límite adecuado para un objeto que requiere alineación extendida. Para asignar memoria a los tipos alineados en exceso, [_aligned_malloc](https://learn.microsoft.com/es-es/cpp/c-runtime-library/reference/aligned-malloc?view=msvc-170) y funciones relacionadas.

## alloca
[_alloca](https://learn.microsoft.com/es-es/cpp/c-runtime-library/reference/alloca?view=msvc-170) debe tener una alineación de 16 bytes y, además, usar un puntero de marco.

La pila que se asigna debe incluir espacio después de ella para los parámetros de las funciones llamadas posteriormente, como se indica en [Asignación de pila](https://learn.microsoft.com/es-es/cpp/build/stack-usage?view=msvc-170#stack-allocation).
## Construcción del área de pila para el parámetro dinámico

Si se usa un puntero de marco, existe la opción de crear dinámicamente el área de pila para el parámetro. Esto no se realiza actualmente en el compilador x64.

## Stack frames y ejemplo de llamada

Normalmente, un trozo de memoria "empieza" en la dirección más baja y "acaba" en la dirección más alta del intervalo.
```c
0 ...  <-------------------------->  ...
       |                           |
       Comienzo                  final
```

La [pila](sp-bp-pila) es diferente, la [pila](sp-bp-pila) crece hacia abajo. Una nueva asignación que haces "empieza" en una dirección más alta y "termina" en una dirección más baja. 
```c
0 ...  <-------------------------->  ...
       |                           |
       Comienzo                  Final
       Nuevo RSP                Antiguo RSP
       Top-Of-Stack 
```

Para aumentar la confusión, esta dirección inferior ahora recibe el nombre de ``"Top-Of-Stack"(parte superior de la pila)``, que definitivamente tampoco es intuitivo para la palabra 'top'. (Nada de esta confusión existiría si sólo la pila creciera hacia arriba...)

```js
push rbp
mov rbp, rsp
sub rsp, 16
mov [rbp - 8], rdi
mov [rbp - 16], rsi
```
Tu fragmento de código contiene 2 asignaciones de memoria de pila: ``push rbp`` solicita ``8 bytes``, y ``sub rsp, 16`` solicita ``16 bytes``. Una vez asignada, eres libre de leer/escribir desde/a esta memoria. En el caso de ``push rbp`` es la CPU la que escribe en la memoria.
```c
0 ...  <---RSI------RDI------RBP-->  ...
       |         |        |        |
       Comienzo  |        |      Final
       Nuevo RSP |        |     Antiguo RSP
       Nuevo Top-Of-Stack |     Antiguo Top-Of-Stack
       |         |        |
       [RBP-16]  [RBP-8]  [RBP]
```

La pila en 64bits a de estar alineada a 16bytes, para eso puede hacer esta operación:
```js
and rsp, 0x0fffffffffffffff0 ; asegúrese de que la pila está alineada a 16 bytes
```

En 64bits no es necesario llamar a las funciones de Windows como:
```c
_ExitProcess@4
```
Pues en 64bits al usar la [convección de llamada](convenciones-de-llamadas.md) [[__fastcall]] no se ponen parámetros en la pila sino que se ponen en los registros específicos de la convención, usándose solo la pila cuando la cantidad de parámetros exceda la cantidad de registros.
