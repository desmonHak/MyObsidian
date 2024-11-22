vea [[Spin_Lock]]
https://www.felixcloutier.com/x86/pause.html

# PAUSE — Spin Loop Hint

| Opcode | Instruction | Op/En | 64-Bit Mode | Compat/Leg Mode | Description                                                                       |
| ------ | ----------- | ----- | ----------- | --------------- | --------------------------------------------------------------------------------- |
| F3 90  | PAUSE       | ZO    | Valid       | Valid           | Da una pista al procesador que mejora el rendimiento del bucle de espera de giro. |

## Instruction Operand Encoding [¶](https://www.felixcloutier.com/x86/pause.html#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/pause.html#description)

Mejora el rendimiento de los bucles de espera de giro. Al ejecutar un "bucle de espera de giro", los procesadores sufrirán una grave penalización de rendimiento al salir del bucle porque detecta una posible violación del orden de la memoria. La instrucción [[PAUSE]] proporciona una pista al procesador de que la secuencia de código es un bucle de espera de giro. El procesador utiliza esta pista para evitar la violación del orden de la memoria en la mayoría de las situaciones, lo que mejora enormemente el rendimiento del procesador. Por este motivo, se recomienda que se coloque una instrucción [[PAUSE]] en todos los bucles de espera de giro.

Una función adicional de la instrucción [[PAUSE]] es reducir la energía consumida por un procesador mientras ejecuta un bucle de giro. Un procesador puede ejecutar un bucle de espera de giro extremadamente rápido, lo que hace que el procesador consuma mucha energía mientras espera que el recurso en el que está girando esté disponible. Insertar una instrucción de pausa en un bucle de espera de giro reduce en gran medida el consumo de energía del procesador.

Esta instrucción se introdujo en los procesadores Pentium 4, pero es compatible con versiones anteriores de todos los procesadores IA-32. En los procesadores IA-32 anteriores, la instrucción [[PAUSE]] funciona como una instrucción [[NOP]]. Los procesadores Pentium 4 e Intel Xeon implementan la instrucción [[PAUSE]] como un retraso. El retraso es finito y puede ser cero para algunos procesadores. Esta instrucción no cambia el estado arquitectónico del procesador (es decir, realiza esencialmente una operación de no operación con retraso).

El funcionamiento de esta instrucción es el mismo en los modos que no son de 64 bits y en el modo de 64 bits.

## Operación [¶](https://www.felixcloutier.com/x86/pause.html#operation)
```c
Execute_Next_Instruction(DELAY);
```

## Excepciones numéricas [¶](https://www.felixcloutier.com/x86/pause.html#numeric-exceptions)
Ninguna.

## Excepciones (todos los modos operativos) [¶](https://www.felixcloutier.com/x86/pause.html#exceptions--all-operating-modes-)
``#UD Si se utiliza el prefijo LOCK.``


https://stackoverflow.com/questions/7086220/what-does-rep-nop-mean-in-x86-assembly-is-it-the-same-as-the-pause-instru

# [¿Qué significa "rep; nop;" en el ensamblado x86? ¿Es lo mismo que la instrucción "pause"?](https://stackoverflow.com/questions/7086220/what-does-rep-nop-mean-in-x86-assembly-is-it-the-same-as-the-pause-instru)

- ¿Qué significa `rep; nop`?
- ¿Es lo mismo que la instrucción `pause`?
- ¿Es lo mismo que `rep nop` (sin el punto y coma)?
- ¿Cuál es la diferencia con la instrucción `nop` simple?
- ¿Se comporta de manera diferente en los procesadores AMD e Intel?
- (bonus) ¿Dónde está la documentación oficial de estas instrucciones?

---

### Motivación para esta pregunta

Después de un debate en los comentarios de [otra pregunta](https://stackoverflow.com/questions/7083482/how-to-prevent-compiler-optimization-on-a-small-piece-of-code), me di cuenta de que no sé qué significa `rep; nop;` en el ensamblado x86 (o x86-64). Y tampoco pude encontrar una buena explicación en la web.

Sé que `rep` es un prefijo que significa `"repetir la siguiente instrucción `cx` veces" (o al menos lo era, en el antiguo ensamblado x86 de 16 bits). Según esta [tabla de resumen en Wikipedia](http://en.wikipedia.org/wiki/X86_instruction_listings#Original_8086.2F8088_instructions), parece que `rep` solo se puede usar con `movs`, `stos`, `cmps`, `lods`, `scas` (pero tal vez esta limitación se eliminó en procesadores más nuevos). Por lo tanto, creo que `rep nop` (sin punto y coma) repetiría una operación `nop` `cx` veces.

Sin embargo, después de buscar más, me confundí aún más. Parece que `rep; nop` y `pause` [se asignan exactamente al mismo código de operación](https://stackoverflow.com/questions/2589447/is-it-necessary-that-each-machine-code-can-only-map-to-one-assembly-code/2589462#2589462), y `pause` tiene un comportamiento un poco diferente al de solo `nop`. Algunos [mensajes antiguos de 2005](http://www.x86-64.org/pipermail/discuss/2005-March/005800.html) decían cosas diferentes:

- _"trata de no quemar demasiada energía"_
- _"es equivalente a 'nop' solo con codificación de 2 bytes"._
- _"es mágico en Intel. Es como 'nop pero deja que se ejecute el otro hermano HT'"_
- _"es pausa en Intel y relleno rápido en Athlon"_

Con estas opiniones diferentes, no pude entender el significado correcto.

Se está utilizando en el kernel de Linux (tanto en [i386](http://www.cs.fsu.edu/~baker/devices/lxr/http/source/linux/arch/um/sys-i386/asm/processor.h#L53) como en [x86_64](http://www.cs.fsu.edu/~baker/devices/lxr/http/source/linux/arch/um/sys-x86_64/asm/processor.h#L20)), junto con este comentario: `/* REP NOP (PAUSE) es una buena cosa para insertar en bucles de espera ocupada. */` También [se está utilizando en BeRTOS](http://doc.bertos.org/2.6/attr_8h_source.html#l00096), con el mismo comentario.


`rep; nop` es de hecho lo mismo que la instrucción `pause` (código de operación `F390`). Se puede usar para ensambladores que aún no admiten la instrucción `pause`. En procesadores anteriores, esto simplemente no hacía nada, al igual que `nop`, pero en dos bytes. En procesadores nuevos que admiten hiperprocesamiento, se usa como una pista para el procesador de que está ejecutando un bucle de giro para aumentar el rendimiento. De la [referencia de instrucciones de Intel](https://software.intel.com/en-us/download/intel-64-and-ia-32-architectures-software-developers-manual-volume-2b-instruction-set-reference-m-u):

> Mejora el rendimiento de los bucles de espera de giro. Al ejecutar un “bucle de espera de giro”, un procesador Pentium 4 o Intel Xeon sufre una grave penalización de rendimiento al salir del bucle porque detecta una posible violación del orden de la memoria. La instrucción PAUSE proporciona una pista al procesador de que la secuencia de código es un bucle de espera de giro. El procesador utiliza esta pista para evitar la violación del orden de la memoria en la mayoría de las situaciones, lo que mejora enormemente el rendimiento del procesador. Por este motivo, se recomienda que se coloque una instrucción PAUSE en todos los bucles de espera de giro.


**En la práctica, las CPU existentes ignoran los prefijos (excepto `lock`) que no se aplican a una instrucción.**

La documentación dice que el uso de `rep` con instrucciones a las que no se aplica está "reservado y puede causar un comportamiento impredecible" porque las CPU _futuras_ podrían reconocerlo como parte de alguna instrucción nueva.** Una vez que establecen una nueva codificación de instrucción específica usando `f3 xx`, documentan cómo se ejecuta en CPU más antiguas. (Sí, el espacio de código de operación x86 es tan limitado que hacen cosas locas como esta, y sí, hace que los decodificadores sean complicados).

En este caso, **significa que puedes usar `pause` en bucles de giro sin romper la compatibilidad con versiones anteriores**. Las CPU antiguas que no conocen la función `pause` la decodificarán como un NOP sin causar ningún daño, como lo garantiza el manual de referencia ISA de Intel [entrada para `pause`](https://www.felixcloutier.com/x86/pause). En las CPU nuevas, obtienes el beneficio del ahorro de energía / compatibilidad con HT y [evitas la especulación errónea sobre el orden de la memoria](https://stackoverflow.com/questions/12894078/pause-instruction-in-x86) cuando la memoria en la que estás girando cambia y abandonas el bucle de giro.

---

Enlaces a los manuales de Intel y muchas otras cosas interesantes en la página de información de la wiki de la etiqueta x86 (https://stackoverflow.com/tags/x86/info)

Otro caso de un prefijo `rep` sin sentido que se convierte en una nueva instrucción en las nuevas CPU: `lzcnt` es `F3 0F BD /r`. En las CPU que no admiten esa instrucción (que no tienen el indicador de función LZCNT en su CPUID), se decodifica como `rep bsr`, que se ejecuta igual que `bsr`. Por lo tanto, en las CPU antiguas, produce `32 - expected_result` y no está definido cuando la entrada era cero.

Pero `tzcnt` y `bsf` hacen lo mismo con entradas distintas de cero, por lo que los compiladores pueden usar y usan `tzcnt` incluso cuando no se garantiza que la CPU de destino lo ejecutará como `tzcnt`. Las CPU AMD tienen `tzcnt` rápido, `bsf` lento y en Intel ambos son rápidos. Siempre que no importe para la corrección (no depende de la configuración de indicadores o de dejar el comportamiento de destino sin modificar en el caso de entrada=0), es útil que se decodifique como `tzcnt` en las CPU que lo admiten.

---

Un caso de un prefijo `rep` sin sentido que probablemente nunca se decodifique de forma diferente: `rep ret` se usa de forma predeterminada por gcc cuando se apunta a CPU "genéricas" (es decir, no se apunta a una CPU específica con `-march` o `-mtune`, y no se apunta a AMD K8 o K10). Pasarán décadas antes de que alguien pueda crear una CPU que decodifique `rep ret` como algo distinto a `ret`, porque está presente en la mayoría de los binarios en la mayoría de las distribuciones de Linux. Consulte [¿Qué significa `rep ret`?](https://stackoverflow.com/questions/20526361/what-does-rep-ret-mean)


https://www.intel.com/content/www/us/en/docs/cpp-compiler/developer-guide-reference/2021-8/pause-intrinsic.html

## Intrínseco de pausa
El prototipo de este intrínseco de Intel® Streaming SIMD Extensions 2 (Intel® SSE2) se encuentra en el archivo de encabezado [[xmmintrin.h]].

Para utilizar estos intrínsecos, incluya el archivo [[immintrin.h]] de la siguiente manera:

```c
#include <immintrin.h>
```

### Intrínseco de pausa
```c
void _mm_pause(void);
```

El intrínseco de pausa se utiliza en bucles de espera de giro con los procesadores que implementan la ejecución dinámica (especialmente la ejecución fuera de orden). En el bucle de espera de giro, el intrínseco de pausa mejora la velocidad a la que el código detecta la liberación del bloqueo y proporciona una ganancia de rendimiento especialmente significativa.

La ejecución de la siguiente instrucción se retrasa durante una cantidad de tiempo específica de la implementación. La instrucción [[PAUSE]] no modifica el estado arquitectónico. Para la programación dinámica, la instrucción PAUSE reduce la penalización por salir del bucle giratorio.

**Ejemplo de bucle con la instrucción [[PAUSE]]:**
En este ejemplo, el programa gira hasta que la ubicación de memoria A coincide con el valor en el registro eax. La secuencia de código que sigue muestra una prueba y prueba y configuración.
```js
spin_loop:
	pause 
	cmp eax, A 
	jne spin_loop
```

En este ejemplo, el giro se produce sólo después de que el intento de obtener un bloqueo haya fallado.
```js
get_lock:
	mov eax, 1 
	xchg eax, A    ; Try to get lock 
	cmp eax, 0     ; Test if successful 
	jne spin_loop
```

### Critical Section
```c
// critical_section code 
mov A, 0      ; Release lock 
jmp continue 
spin_loop: 
	pause; 
				// spin-loop hint 
	cmp 0, A  
				// check lock availability 
	jne spin_loop 
	jmp get_lock 
// continue: other code
```

> NOTA:
Se predice que la primera rama pasará a la sección crítica en previsión de obtener acceso exitoso al bloqueo. Se recomienda enfáticamente que todos los bucles de espera de giro incluyan la instrucción [[PAUSE]]. Dado que [[PAUSE]] es compatible con versiones anteriores de todas las generaciones de procesadores basados ​​en la arquitectura IA-32 existentes, no se necesita una prueba para el tipo de procesador (una prueba [[CPUID]]). Todos los procesadores heredados ejecutan la instrucción [[PAUSE]] como un [[NOP]], pero en los procesadores que usan la instrucción [[PAUSE]] como una pista puede haber un beneficio significativo en el rendimiento.