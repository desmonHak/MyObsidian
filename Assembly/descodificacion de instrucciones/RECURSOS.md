https://stackoverflow.com/questions/6924912/finding-number-of-operands-in-an-instruction-from-opcodes?rq=1

Aunque el conjunto de instrucciones x86 es bastante complejo (de todos modos, es CISC) y vi que muchas personas aquí desalientan tus intentos de entenderlo, diré lo contrario: aún se puede entender, y puedes aprender sobre el camino por qué es tan complejo y cómo Intel ha logrado extenderlo varias veces desde el 8086 hasta los procesadores modernos.

Las instrucciones x86 usan codificación de longitud variable, por lo que pueden estar compuestas de múltiples bytes. Cada byte está ahí para codificar diferentes cosas, y algunas de ellas son opcionales (se codifica en el código de operación ya sea que se usen o no esos campos opcionales).

Por ejemplo, cada código de operación puede estar precedido por cero a cuatro bytes de prefijo, que son opcionales. Por lo general, no necesitas preocuparte por ellos. Se usan para cambiar el tamaño de los operandos o como códigos de escape al "segundo piso" de la tabla de códigos de operación con instrucciones extendidas de CPU modernas ([[MMX]], [[SSE]], etc.).

Luego está el código de operación real, que normalmente es de un byte, pero puede tener hasta tres bytes para instrucciones extendidas. Si solo usa el conjunto de instrucciones básicas, no necesita preocuparse por ellos también.

A continuación, está el llamado byte ModR/M (a veces también llamado mode-reg-reg/mem), que codifica el modo de direccionamiento y los tipos de operandos. Solo lo usan los códigos de operación que tienen dichos operandos. Tiene tres campos de bits:

Los primeros dos bits (desde la izquierda, los más significativos) codifican el modo de direccionamiento (4 combinaciones de bits posibles).
Los siguientes tres bits codifican el primer registro (8 combinaciones de bits posibles).
Los últimos tres bits pueden codificar otro registro o extender el modo de direccionamiento, según la configuración de los primeros dos bits.
Después del byte ModR/M, podría haber otro byte opcional (según el modo de direccionamiento) llamado SIB (Base de índice de escala). Se utiliza para modos de direccionamiento más exóticos para codificar el factor de escala (1x, 2x, 4x), la dirección base/registro y el registro de índice utilizado. Tiene un diseño similar al byte ModR/M, pero los dos primeros bits desde la izquierda (los más significativos) se utilizan para codificar la escala, y los tres siguientes y los tres últimos bits codifican los registros de índice y base, como sugiere el nombre.

Si se utiliza algún desplazamiento, va justo después. Puede tener una longitud de 0, 1, 2 o 4 bytes, según el modo de direccionamiento y el modo de ejecución (16 bits/32 bits/64 bits).

El último es siempre el dato inmediato, si lo hay. También puede tener una longitud de 0, 1, 2 o 4 bytes.

Ahora, cuando conoce el formato general de las instrucciones x86, solo necesita saber cuáles son las codificaciones para todos esos bytes. Y hay algunos patrones, al contrario de lo que se cree comúnmente.

Por ejemplo, todas las codificaciones de registros siguen un patrón claro ACDB. Es decir, para las instrucciones de 8 bits, los dos bits más bajos del código de registro codifican los registros A, C, D y B, respectivamente:

`00` = `A` register (accumulator)  
`01` = `C` register (counter)  
`10` = `D` register (data)  
`11` = `B` register (base)

Sospecho que sus procesadores de 8 bits usaban sólo estos cuatro registros de 8 bits codificados de esta manera:
```c
       second
      +---+---+
f     | 0 | 1 |          00 = A
i +---+---+---+          01 = C
r | 0 | A : C |          10 = D
s +---+ - + - +          11 = B
t | 1 | D : B |
  +---+---+---+
```

Luego, en los procesadores de 16 bits, duplicaron este banco de registros y agregaron un bit más en la codificación del registro para elegir el banco, de esta manera:
```c
       second                second         0 00  =  AL
      +----+----+           +----+----+     0 01  =  CL
f     | 0  | 1  |     f     | 0  | 1  |     0 10  =  DL
i +---+----+----+     i +---+----+----+     0 11  =  BL
r | 0 | AL : CL |     r | 0 | AH : CH |
s +---+ - -+ - -+     s +---+ - -+ - -+     1 00  =  AH
t | 1 | DL : BL |     t | 1 | DH : BH |     1 01  =  CH
  +---+---+-----+       +---+----+----+     1 10  =  DH
    0 = BANK L              1 = BANK H      1 11  =  BH
```

Pero ahora también puede optar por utilizar ambas mitades de estos registros juntos, como registros completos de 16 bits. Esto se hace mediante el último bit del código de operación (el bit menos significativo, el que está más a la derecha): si es 0, se trata de una instrucción de 8 bits. Pero si este bit está establecido (es decir, el código de operación es un número impar), se trata de una instrucción de 16 bits. En este modo, los dos bits codifican uno de los registros ACDB, como antes. Los patrones siguen siendo los mismos. Pero ahora codifican registros completos de 16 bits. Pero cuando el tercer byte (el más alto) también está establecido, cambian a otro banco de registros, llamados registros de índice/puntero, que son: SP (puntero de pila), BP (puntero de base), SI (índice de origen), DI (índice de destino/datos). Por lo tanto, el direccionamiento ahora es el siguiente:
```c
       second                second         0 00  =  AX
      +----+----+           +----+----+     0 01  =  CX
f     | 0  | 1  |     f     | 0  | 1  |     0 10  =  DX
i +---+----+----+     i +---+----+----+     0 11  =  BX
r | 0 | AX : CX |     r | 0 | SP : BP |
s +---+ - -+ - -+     s +---+ - -+ - -+     1 00  =  SP
t | 1 | DX : BX |     t | 1 | SI : DI |     1 01  =  BP
  +---+----+----+       +---+----+----+     1 10  =  SI
    0 = BANK OF           1 = BANK OF       1 11  =  DI
  GENERAL-PURPOSE        POINTER/INDEX
     REGISTERS             REGISTERS
```

Cuando se introdujeron las CPU de 32 bits, se duplicaron estos bancos de nuevo, pero el patrón sigue siendo el mismo. Ahora, los códigos de operación impares significan los registros de 32 bits y los códigos de operación pares, como antes, los registros de 8 bits. Yo llamaría a los códigos de operación impares las versiones "largas", porque la versión de 16/32 bits se utiliza según la CPU y su modo de funcionamiento actual. Cuando funciona en modo de 16 bits, los códigos de operación impares ("largos") significan registros de 16 bits, pero cuando funciona en modo de 32 bits, los códigos de operación impares ("largos") significan registros de 32 bits. Se puede invertir la situación anteponiendo a toda la instrucción el prefijo 66 (anulación del tamaño del operando). Los códigos de operación pares (los "cortos") son siempre de 8 bits. Por tanto, en una CPU de 32 bits, los códigos de registro son:
```c
0 00 = EAX      1 00 = ESP
0 01 = ECX      1 01 = EBP
0 10 = EDX      1 10 = ESI
0 11 = EBX      1 11 = EDI
```

Como puede ver, el patrón ACDB sigue siendo el mismo. También el patrón SP, BP, SI, SI sigue siendo el mismo. Solo utiliza las versiones más largas de los registros.

También hay algunos patrones en los códigos de operación. Uno de ellos ya lo he descrito (par vs. impar = 8 bits "cortos" vs. 16/32 bits "largos"). Puede ver más de ellos en este mapa de códigos de operación que hice una vez para referencia rápida y para ensamblar/desensamblar cosas a mano:
![[Pasted image 20241102195724.png]]

(Aún no es una tabla completa, faltan algunos de los códigos de operación. Tal vez la actualice algún día).

Como puede ver, las instrucciones aritméticas y lógicas se encuentran principalmente en la mitad superior de la tabla, y las mitades izquierda y derecha de la misma siguen un diseño similar. Las instrucciones de movimiento de datos están en la mitad inferior. Todas las instrucciones de ramificación (saltos condicionales) están en la fila 7*. También hay una fila B* completa reservada para la instrucción [[MOV]], que es una forma abreviada de cargar valores inmediatos (constantes) en registros. Todos son códigos de operación de un byte seguidos inmediatamente por la constante inmediata, porque codifican el registro de destino en el código de operación (se eligen por el número de columna en esta tabla), en sus tres bytes menos significativos (los de más a la derecha). Siguen el mismo patrón para la codificación de registros. Y el cuarto bit es el que elige "corto"/"largo". Puedes ver que tu instrucción [[IMUL]] ya está en la tabla, exactamente en la posición 69 (eh... ;J).

Para muchas instrucciones, el bit justo antes del bit "corto/largo" sirve para codificar el orden de los operandos: cuál de los dos registros codificados en el byte ModR/M es el de origen y cuál es el de destino (esto se aplica a las instrucciones con dos operandos de registro).

En cuanto al campo de modo de direccionamiento del byte ModR/M, aquí se explica cómo interpretarlo:

11 es el más simple: codifica las transferencias de registro a registro. Un registro se codifica con los tres bits siguientes (el campo reg) y el otro registro con los otros tres bits (el campo R/M) de este byte.
01 significa que después de este byte habrá un desplazamiento de un byte.
10 significa lo mismo, pero el desplazamiento utilizado es de cuatro bytes (en CPU de 32 bits).
00 es el más complicado: significa direccionamiento indirecto o un desplazamiento simple, según el contenido del campo R/M.
Si el byte SIB está presente, se indica mediante el patrón de 100 bits en los bits R/M. También hay un código 101 para el modo de solo desplazamiento de 32 bits, que no utiliza el byte SIB en absoluto.

Aquí se incluye un resumen de todos estos modos de direccionamiento:
```c
Mod R/M
 11 rrr = register-register  (uno codificado en bits `R/M`, el otro en bits `reg`).
 00 rrr = [ register ]       (excepto SP y BP, que están codificados en byte 'SIB')
 00 100 = SIB byte present
 00 101 = 32-bit displacement only (no `SIB` byte required)
 01 rrr = [ rrr + disp8 ]    (Desplazamiento de 8 bits después del byte `ModR/M`)
 01 100 = SIB + disp8
 10 rrr = [ rrr + disp32 ]   (excepto SP, lo que significa que se utiliza el byte 'SIB')
 10 100 = SIB + disp32
```
Ahora, decodifiquemos su [[IMUL]]:

``69`` es su código de operación. Codifica la versión del [[IMUL]] que no extiende el signo de los operandos de 8 bits. La versión ``6B`` sí los extiende. (Se diferencian por el bit 1 en el código de operación, si alguien preguntó).

``62`` es el byte RegR/M. En binario es 0110 0010 o 01 100 010. Los primeros dos bytes (el campo Mod) indican el modo de direccionamiento indirecto y que el desplazamiento será de 8 bits. Los siguientes tres bits (el campo reg) son 100 y codifican el registro SP (en este caso ESP, ya que estamos en modo de 32 bits) como el registro de destino. Los últimos tres bits son el campo R/M y tenemos 010 allí, que codifica el registro D (en este caso EDX) como el otro registro (de origen) utilizado.

Ahora esperamos un desplazamiento de 8 bits. Y ahí está: 2f es el desplazamiento, uno positivo (+47 en decimal).

La última parte son cuatro bytes de la constante inmediata, que es requerida por la instrucción imul. En tu caso, es ``6c 64 2d 6c``, que en little-endian es $6c2d646c.

Los manuales describen cómo diferenciar entre versiones de uno, dos o tres operandos.
![[Pasted image 20241102201514.png]]F6/F7: un operando; 0F AF: dos operandos; 6B/69: tres operandos.


Algunos consejos: primero, **consiga todos los documentos de conjuntos de instrucciones que pueda conseguir**. Para este caso x86, intente con algunos manuales antiguos de 8088/86, así como otros más recientes, de Intel, así como con la gran cantidad de tablas de códigos de operación que hay en la red. Es posible que las distintas interpretaciones y la documentación presenten, en primer lugar, errores o diferencias sutiles en la documentación, y en segundo lugar, es posible que algunas personas presenten la información de una manera diferente y más comprensible.

En segundo lugar, si este es su primer desensamblador, le recomiendo que evite x86, es muy difícil. Como su pregunta implica, los conjuntos de instrucciones de longitud de palabra variable son difíciles; **para crear un desensamblador remotamente exitoso, debe seguir el código en orden de ejecución, no en orden de memoria**. Por lo tanto, su desensamblador debe usar algún tipo de esquema no solo para decodificar e imprimir instrucciones, sino también para decodificar instrucciones de salto y etiquetar direcciones de destino como puntos de entrada en una instrucción. Por ejemplo, ARM tiene una longitud de instrucción fija; puede escribir un desensamblador ARM que comience al principio de la RAM y desensamble cada palabra directamente (suponiendo, por supuesto, que no sea una mezcla de código ARM y Thumb). thumb (no thumb2) se puede desensamblar de esta manera ya que solo hay un tipo de instrucción de 32 bits, todo lo demás es de 16 bits, y ese tipo se puede manejar en una máquina de estados simple ya que esas dos instrucciones de 16 bits aparecen como pares.

No podrá desensamblar todo (con un conjunto de instrucciones de longitud variable) y debido a los matices de alguna codificación manual o tácticas intencionales para evitar el desensamblaje, su código inicial que recorre el código en orden de ejecución puede tener lo que yo llamaría una colisión, por ejemplo, sus instrucciones anteriores. Digamos que una ruta lo lleva a 0x69 como el punto de entrada a la instrucción y usted determina a partir de eso que es una instrucción de 7 bytes, pero digamos que en otro lugar hay una instrucción de bifurcación cuyo destino se calcula como 0x2f como el código de operación para una instrucción, aunque una programación muy inteligente puede lograr algo así, es más probable que el desensamblador haya sido conducido a 
desensamblar datos. 

El desensamblador no sabrá que los datos son datos y, sin inteligencia adicional, no se dará cuenta de que la rama condicional es, de hecho, una rama incondicional (podría haber muchas instrucciones en diferentes rutas de rama entre la limpieza de la condición y la rama si se limpia la condición), por lo que asume que el byte después de la rama condicional es una instrucción.

Por último, aplaudo sus esfuerzos. A menudo recomiendo escribir desensambladores simples (aquellos que asumen que el código es muy corto, un código diseñado intencionalmente) para aprender muy bien un conjunto de instrucciones. Si no pone al desensamblador en una situación en la que tiene que seguir el orden de ejecución y, en cambio, puede ir en orden de memoria (**básicamente, no incruste datos entre instrucciones, póngalos al final o en otro lugar dejando solo cadenas de instrucciones para desensamblar**), comprender la decodificación del código de operación para un conjunto de instrucciones puede ayudarlo a programar mucho mejor para esa plataforma, tanto para lenguajes de bajo nivel como de alto nivel.

Respuesta corta: Intel solía publicar, y tal vez todavía lo haga, manuales de referencia técnica para los procesadores. Yo todavía tengo mis manuales del 8088/86, uno de hardware para las partes eléctricas y uno de software para el conjunto de instrucciones y cómo funciona. Tengo un 486 y probablemente uno 386. La instantánea en la respuesta de Igor se parece directamente a un manual de Intel. Debido a que el conjunto de instrucciones ha evolucionado tanto con el tiempo, x86 es una bestia difícil en el mejor de los casos. Al mismo tiempo, si el procesador puede navegar por estos bytes y ejecutarlos, puede escribir un programa que pueda hacer lo mismo pero decodificarlos. La diferencia es que probablemente no va a crear un simulador y cualquier rama que se calcule mediante el código y no esté explícita en el código no podrá verla y el destino de esa rama puede no aparecer en su lista de bytes para desensamblar.

