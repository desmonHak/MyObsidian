
### AMD K7

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit   |
| ---------------- | --------- | -------- | ------- | --------------------- | ---------------- |
| [[ADD]], [[SUB]] | r,r/i     | 1        | 1       | 1/3                   | [[ALU]]          |
| [[ADD]], [[SUB]] | r,m       | 1        | 1       | 1/2                   | [[ALU]], [[AGU]] |
| [[ADD]], [[SUB]] | m,r       | 1        | 7       | 2.5                   | [[ALU]], [[AGU]] |

### AMD K8

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit   |
| ---------------- | --------- | -------- | ------- | --------------------- | ---------------- |
| [[ADD]], [[SUB]] | r,r/i     | 1        | 1       | 1/3                   | [[ALU]]          |
| [[ADD]], [[SUB]] | r,m       | 1        | 1       | 1/2                   | [[ALU]], [[AGU]] |
| [[ADD]], [[SUB]] | m,r       | 1        | 7       | 2.5                   | [[ALU]], [[AGU]] |

### AMD K10

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit   |
| ---------------- | --------- | -------- | ------- | --------------------- | ---------------- |
| [[ADD]], [[SUB]] | r,r/i     | 1        | 1       | 1/3                   | [[ALU]]          |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 1/2                   | [[ALU]], [[AGU]] |
| [[ADD]], [[SUB]] | m,r       | 1        | 4       | 1                     | [[ALU]], [[AGU]] |

### [[Bulldozer]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r/i     | 1        | 1       | 0.5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | r,m       | 1        | 1       | 0.5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | m,r       | 1        |         | 0.5                   | [[EX01]]       |

### [[Piledriver]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | m,r       | 1        | 7-8     | 1                     | [[EX01]]       |
| [[ADD]], [[SUB]] | m,i       | 1        | 7-8     | 1                     | [[EX01]]       |
### [[Steamroller]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | m,r       | 1        | 7       | 1                     | [[EX01]]       |
| [[ADD]], [[SUB]] | m,i       | 1        | 7       | 1                     | [[EX01]]       |

### [[Excavator]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.25                  |                |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.25                  |                |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | m,r       | 1        | 7       | 1                     | [[EX01]]       |
| [[ADD]], [[SUB]] | m,i       | 1        | 7       | 1                     | [[EX01]]       |
### [[Zen_1]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.25                  |                |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.25                  |                |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | m,r       | 1        | 6       | 1                     | [[EX01]]       |
| [[ADD]], [[SUB]] | m,i       | 1        | 6       | 1                     | [[EX01]]       |
### [[Zen_2]]
| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.3                   |                |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.3                   |                |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,5                   | [[EX01]]       |
| [[ADD]], [[SUB]] | m8/16,r   | 1        | 7       | 1                     | [[EX01]]       |
| [[ADD]], [[SUB]] | m32/64,r  | 1        | 7       | 1                     | [[EX01]]       |
### [[Zen_3]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.25                  |                |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.25                  |                |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,33                  | [[EX01]]       |
| [[ADD]], [[SUB]] | m,r       | 1        | 7-8     | 1                     | [[EX01]]       |
### [[Zen_4]]
| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |     |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- | --- |
| [[ADD]], [[SUB]] | r,r       | 1        | 1       | 0.25                  |                |     |
| [[ADD]], [[SUB]] | r,i       | 1        | 1       | 0.25                  |                |     |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 0,33                  |                |     |
| [[ADD]], [[SUB]] | m,r8/16   | 1        | 7-8     | 1                     |                |     |
| [[ADD]], [[SUB]] | m,r32/64  | 1        | 1       | 1                     |                |     |
### [[Bodcat]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r/i     | 1        | 1       | 0.5                   | I0/1           |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 1                     |                |
| [[ADD]], [[SUB]] | m,r       | 1        |         | 1                     |                |

### [[Jaguar]]

| Instruccion      | Operandos | [[μops]] | Latency | Reciprocal throughput | Execution unit |
| ---------------- | --------- | -------- | ------- | --------------------- | -------------- |
| [[ADD]], [[SUB]] | r,r/i     | 1        | 1       | 0.5                   |                |
| [[ADD]], [[SUB]] | r,m       | 1        |         | 1                     |                |
| [[ADD]], [[SUB]] | m,r       | 1        | 6       | 1                     |                |
### Intel Pentium MMX([[P5]]) y Intel Pentium I([[P5]])

| Instruccion                            | Operandos | Clock cycles | Pairability |
| -------------------------------------- | --------- | ------------ | ----------- |
| [[ADD]] [[SUB]] [[AND]] [[OR]] [[XOR]] | r,r/i     | 1            | uv          |
| [[ADD]] [[SUB]] [[AND]] [[OR]] [[XOR]] | r,m       | 2            | uv          |
| [[ADD]] [[SUB]] [[AND]] [[OR]] [[XOR]] | m , r/i   | 3            | uv          |
### Pentium Pro([[P6(Client)]]), Pentium II([[P6(Client)]]) and Pentium III([[P6(Client)]])

^a92c4c

[[μops]]: La cantidad de μops que genera la instrucción para cada puerto de ejecución.
``p0``: Puerto 0: [[ALU]], etc.
``p1``: Puerto 1: [[ALU]], saltos
``p01``: Instrucciones que pueden ir al puerto 0 o 1, el que esté vacante primero.
``p2``: Puerto 2: cargar datos, etc.
``p3``: Puerto 3: generación de dirección para almacenar
``p4``: Puerto 4: almacenar datos

| Instruccion                            | Operandos | [[μops]]                                                                                                      | Latency |
| -------------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------- | ------- |
| [[ADD]] [[SUB]] [[AND]] [[OR]] [[XOR]] | r,r/i     | ``p0``   (None) <br>``p1``   (None)<br>``p01`` (1)<br>``p2``   (None) <br>``p3``   (None) <br>``p4``   (None) | None    |
| [[ADD]] [[SUB]] [[AND]] [[OR]] [[XOR]] | r,m       | ``p0``   (None) <br>``p1``   (None)<br>``p01`` (1)<br>``p2``   (1) <br>``p3``   (None) <br>``p4``   (None)    | None    |
| [[ADD]] [[SUB]] [[AND]] [[OR]] [[XOR]] | m , r/i   | ``p0``   (None) <br>``p1``   (None)<br>``p01`` (1)<br>``p2``   (1) <br>``p3``   (1) <br>``p4``   (1)          | None    |
### Intel Pentium M ([[Dothan]])
[[μops]]: La cantidad de μops que genera la instrucción para cada puerto de ejecución.
``p0``: Puerto 0: [[ALU]], etc.
``p1``: Puerto 1: [[ALU]], saltos
``p01``: Instrucciones que pueden ir al puerto 0 o 1, el que esté vacante primero.
``p2``: Puerto 2: cargar datos, etc.
``p3``: Puerto 3: generación de dirección para almacenar
``p4``: Puerto 4: almacenar datos
``μops fused domain``: la cantidad de [[μops]] en las etapas de decodificación, cambio de nombre, asignación y retiro en el [[pipeline]]. Las [[μops]] fusionadas cuentan como una.
``μops unfused domain``: la cantidad de [[μops]] para cada puerto de ejecución. Las [[μops]] fusionadas cuentan como dos.

| Instruccion     | Operandos | μops <br>fused <br>domain | [[μops]] unfused domain                                                                                       | Latency | Reciprocal throughput |
| --------------- | --------- | ------------------------- | ------------------------------------------------------------------------------------------------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                         | ``p0``   (None) <br>``p1``   (None)<br>``p01`` (1)<br>``p2``   (None) <br>``p3``   (None) <br>``p4``   (None) | 1       | 0.5                   |
| [[ADD]] [[SUB]] | r,m       | 1                         | ``p0``   (None) <br>``p1``   (None)<br>``p01`` (1)<br>``p2``   (1) <br>``p3``   (None) <br>``p4``   (None)    | 2       | 1                     |
| [[ADD]] [[SUB]] | m , r/i   | 3                         | ``p0``   (None) <br>``p1``   (None)<br>``p01`` (1)<br>``p2``   (1) <br>``p3``   (1) <br>``p4``   (1)          | None    | 1                     |
### Intel Core 2 ([[Merom]]) 65nm
``Unit``: Indica qué grupo de unidades de ejecución se utiliza. Se genera un retraso adicional de 1 ciclo de reloj si un registro escrito por un ``μop`` en la unidad de enteros (``int``) es leído por un ``μop`` en la unidad de punto flotante (``float``) o viceversa. ``flt→int`` significa que una instrucción con múltiples [[μops]] recibe la entrada en la unidad de coma flotante y entrega la salida en la unidad de enteros. Los retrasos por mover datos entre diferentes unidades se incluyen en latencia cuando son inevitables. Por ejemplo, [[MOVD]] ``eax, xmm0`` tiene un retraso de reloj adicional de 1 para moverse de la unidad de enteros [[XMM]] a la unidad de enteros de propósito general. Esto se incluye en latencia porque ocurre independientemente de qué instrucción venga a continuación. Nada de lo que se indica en unidad significa que sea poco probable que ocurran retrasos adicionales o que sean inevitables y, por lo tanto, se incluyen en la cifra de latencia.

| Instruccion     | Operandos | μops <br>fused <br>domain | [[μops]] unfused domain                                                                                                | Unit | Latency | Reciprocal throughput |
| --------------- | --------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (None) <br>``p3``   (None) <br>``p4``   (None) | int  | 1       | 0.5                   |
| [[ADD]] [[SUB]] | r,m       | 1                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (1) <br>``p3``   (None) <br>``p4``   (None)    | int  | 2       | 1                     |
| [[ADD]] [[SUB]] | m , r/i   | 2                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (1) <br>``p3``   (1) <br>``p4``   (1)          | int  | None    | 1                     |
### Intel Core 2([[Wolfdale]]) 45nm

| Instruccion     | Operandos | μops <br>fused <br>domain | [[μops]] unfused domain                                                                                                | Unit | Latency | Reciprocal throughput |
| --------------- | --------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (None) <br>``p3``   (None) <br>``p4``   (None) | None | 1       | 0.33                  |
| [[ADD]] [[SUB]] | r,m       | 1                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (1) <br>``p3``   (None) <br>``p4``   (None)    | None | None    | 1                     |
| [[ADD]] [[SUB]] | m , r/i   | 2                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (1) <br>``p3``   (1) <br>``p4``   (1)          | None | 6       | 1                     |

### Intel [[Nehalem(Client)]]
| Instruccion     | Operandos | μops <br>fused <br>domain | [[μops]] unfused domain                                                                                                | Do-main | Latency | Reciprocal throughput |
| --------------- | --------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (None) <br>``p3``   (None) <br>``p4``   (None) | None    | 1       | 0.33                  |
| [[ADD]] [[SUB]] | r,m       | 1                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (1) <br>``p3``   (None) <br>``p4``   (None)    | None    | None    | 1                     |
| [[ADD]] [[SUB]] | m , r/i   | 2                         | ``p15`` (1) <br>``p0``   (x) <br>``p1``   (x)<br>`p5`   (x)<br>``p2``   (1) <br>``p3``   (1) <br>``p4``   (1)          | None    | 6       | 1                     |

### Intel [[Sandy_Bridge(Client)]]

| Instruccion     | Operandos | μops <br>fused <br>domain | [[μops]] unfused domain                                                                                 | Latency | Reciprocal throughput |
| --------------- | --------- | ------------------------- | ------------------------------------------------------------------------------------------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                         | ``p015`` (1) <br>``p0``    (x) <br>``p1``    (x)<br>`p5`    (x)<br>``p23``   (None) <br>``p4``   (None) | 1       | None                  |
| [[ADD]] [[SUB]] | r,m       | 1                         | ``p015`` (1) <br>``p0``    (x) <br>``p1``    (x)<br>`p5`    (x)<br>``p23``   (1) <br>``p4``   (None)    | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                         | ``p015`` (1) <br>``p0``    (x) <br>``p1``    (x)<br>`p5`    (x)<br>``p23``   (2) <br>``p4``   (1)       | 6       | 1                     |
### Intel [[Ivy_Bridge(Client)]]

| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain                                                                                 | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ------------------------------------------------------------------------------------------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | ``p015`` (1) <br>``p0``    (x) <br>``p1``    (x)<br>`p5`    (x)<br>``p23``   (None) <br>``p4``   (None) | 1       | 0.33                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | ``p015`` (1) <br>``p0``    (x) <br>``p1``    (x)<br>`p5`    (x)<br>``p23``   (1) <br>``p4``   (None)    | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | ``p015`` (1) <br>``p0``    (x) <br>``p1``    (x)<br>`p5`    (x)<br>``p23``   (2) <br>``p4``   (1)       | 6       | 1                     |
### Intel [[Haswell(Client)]]
- ``μops fused domain``: la cantidad de [[μops]] en las etapas de decodificación, renombrado y asignación en la secuencia. Las [[μops]] fusionadas cuentan como una.
- ``μops unfused domain``: la cantidad total de [[μops]] para todos los puertos de ejecución. Las [[μops]] fusionadas cuentan como dos. Las macrooperaciones fusionadas cuentan como una. La instrucción tiene fusión de [[μops]] si este número es mayor que el número en el dominio fusionado. Algunas operaciones no se cuentan aquí si no van a ningún puerto de ejecución o si los contadores son inexactos.
- ``μops each port``: la cantidad de [[μops]] para cada puerto de ejecución. ``p0`` significa una ``μop`` al puerto de ejecución 0. ``p01`` significa una ``μop`` que puede ir al puerto ``0`` o al puerto ``1``. ``p0 p1`` significa dos [[μops]] que van al puerto ``0`` y ``1``, respectivamente.
	Puerto 0: [[ALU]] de enteros, f.p. y vector, [[MUL]], [[DIV]], ramificación
	Puerto 1: [[ALU]] de enteros, f.p. y vector
	Puerto 2: Carga(Load)
	Puerto 3: Carga(Load)
	Puerto 4: Almacenar(Store)
	Puerto 5: [[ALU]] de enteros y vector
	Puerto 6: [[ALU]] de enteros, ramificación
	Puerto 7: Dirección de almacenamiento
- ``Reciprocal throughput``: El número promedio de ciclos de reloj central por instrucción para una serie de instrucciones independientes del mismo tipo en el mismo hilo.

| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | ------------------ | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``          | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``  | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``2p0156 p237 p4`` | 6       | 1                     |
### Intel [[Broadwell(Client)]]
| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | ------------------ | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``          | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``  | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``2p0156 p237 p4`` | 6       | 1                     |
### Intel [[Skylake(Client)]]

| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port  | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | ------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``           | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``   | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``2p0156 2p237 p4`` | 5       | 1                     |
### Intel [[Skylake-X]]
| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port  | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | ------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``           | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``   | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``2p0156 2p237 p4`` | 5       | 1                     |
### Intel [[Coffee_Lake]]

| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port  | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | ------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``           | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``   | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``2p0156 2p237 p4`` | 5       | 1                     |
### Intel [[Cannon_Lake]]

| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port  | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | ------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``           | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``   | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``2p0156 2p237 p4`` | 5       | 1                     |
### Intel [[Ice_Lake(Client)]]

| Instruccion     | Operandos | [[μops]] <br>fused <br>domain | [[μops]] unfused domain | [[μops]] each port    | Latency | Reciprocal throughput |
| --------------- | --------- | ----------------------------- | ----------------------- | --------------------- | ------- | --------------------- |
| [[ADD]] [[SUB]] | r,r/i     | 1                             | 1                       | ``p0156``             | 1       | 0.25                  |
| [[ADD]] [[SUB]] | r,m       | 1                             | 2                       | ``p0156`` ``p23``     | None    | 0.5                   |
| [[ADD]] [[SUB]] | m , r/i   | 2                             | 4                       | ``p0156 p23 p49 p78`` | 5       | 1                     |
### Intel Pentium 4 ([[Netburst]])

^c5b559

- ``Instrucción``: Nombre de la instrucción. cc significa cualquier código de condición. Por ejemplo, Jcc puede ser JB, JNE, etc.
- ``Operandos``:
	- ``i`` = constante inmediata,
	- ``r`` = cualquier registro,
	- ``r32`` = registro de ``32 bits``, etc.,
	- ``mm`` = registro mmx de ``64 bits``,
	- ``xmm`` = registro xmm de ``128 bits``,
	- ``sr`` = registro de segmento,
	- ``m`` = cualquier operando de memoria, incluidos los operandos indirectos,
	- ``m64`` significa operando de memoria de ``64 bits``, etc.
- [[μops]]: Número de μops emitidos desde el decodificador de instrucciones y almacenados en la caché de seguimiento.
- ``Microcódigo``: Número de μops adicionales emitidos desde la ``ROM`` de microcódigo.
- ``Latencia``: Este es el retraso que genera la instrucción en una cadena de dependencia si la siguiente instrucción dependiente comienza en la misma unidad de ejecución. Los números son valores mínimos. Los errores de caché, la desalineación y las excepciones pueden aumentar considerablemente los recuentos de reloj. Se supone que los operandos de punto flotante son números normales. Los números desnormalizados, NAN, infinito y excepciones aumentan los retrasos. La latencia de los movimientos hacia y desde la memoria no se puede medir con precisión debido al problema con los intermediarios de memoria explicado anteriormente en "Cómo se midieron los valores".
- ``Latencia adicional``: este número se agrega a la latencia si la siguiente instrucción dependiente está en una unidad de ejecución diferente. No hay latencia adicional entre [[ALU]]0 y [[ALU]]1.
- ``Rendimiento recíproco``: esto también se denomina latencia de emisión. Este valor indica la cantidad de ciclos de reloj desde que comienza la ejecución de una instrucción hasta que una instrucción independiente posterior puede comenzar a ejecutarse en la misma subunidad de ejecución. Un valor de ``0,25`` indica 4 instrucciones por ciclo de reloj en un hilo.
- ``Puerto``: el puerto a través del cual cada ``μop`` va a una unidad de ejecución. Dos [[μops]] independientes pueden comenzar a ejecutarse simultáneamente solo si pasan por diferentes puertos.
- ``Unidad de ejecución``: use esta información para determinar latencia adicional. Cuando una instrucción con más de un μop usa más de una unidad de ejecución, solo se enumeran la primera y la última unidad de ejecución.
- ``Subunidad de ejecución``: las medidas de rendimiento se aplican solo a las instrucciones que se ejecutan en la misma subunidad.
- ``Conjunto de instrucciones``: indica la compatibilidad de una instrucción con otros microprocesadores de la familia ``80x86``. La instrucción se puede ejecutar en microprocesadores que admitan el conjunto de instrucciones indicado.

| Instruccion     | Operandos | [[μops]] | Microcode | Latency | Additional latency | Reciprocal through-put | Port | Execution unit | Subunit | Instruction set |
| --------------- | --------- | -------- | --------- | ------- | ------------------ | ---------------------- | ---- | -------------- | ------- | --------------- |
| [[ADD]] [[SUB]] | r,r       | 1        | 0         | 0.5     | 0.5 - 1            | 0.25                   | 0/1  | [[ALU]]0/1     | None    | 86              |
| [[ADD]] [[SUB]] | r,m       | 2        | 0         | 1       | 0.5 - 1            | 1                      |      | None           | None    | 86              |
| [[ADD]] [[SUB]] | m , r     | 3        | 0         | >= 8    | None               | >= 4                   |      | None           | None    | 86              |
### Intel Pentium 4 w. EM64T ([[Prescott]])
| Instruccion     | Operandos | [[μops]] | Microcode | Latency | Additional latency | Reciprocal through-put | Port | Execution unit | Subunit | Instruction set |
| --------------- | --------- | -------- | --------- | ------- | ------------------ | ---------------------- | ---- | -------------- | ------- | --------------- |
| [[ADD]] [[SUB]] | r,r       | 1        | 0         | 1       | 0                  | 0.25                   | 0/1  | [[ALU]]0/1     | None    | 86              |
| [[ADD]] [[SUB]] | r,m       | 2        | 0         | 1       | 0                  | 1                      |      | None           | None    | 86              |
| [[ADD]] [[SUB]] | m , r     | 3        | 0         | 5       | None               | 2                      |      | None           | None    | 86              |
### Intel [[Atom]]

| Instruccion     | Operandos | [[μops]] | Unit            | Latency | Reciprocal throughput | Remarks |
| --------------- | --------- | -------- | --------------- | ------- | --------------------- | ------- |
| [[ADD]] [[SUB]] | r,/i      | 1        | [[ALU]]0/1      | 1       | 1/2                   |         |
| [[ADD]] [[SUB]] | r,m       | 1        | [[ALU]]0/1, Mem | None    | 1                     |         |
| [[ADD]] [[SUB]] | m ,r/i    | 1        | None            | 2       | 1                     |         |
### Intel [[Silvermont]]

| Instruccion     | Operandos | [[μops]] | Unit       | Latency | Reciprocal throughput | Remarks |
| --------------- | --------- | -------- | ---------- | ------- | --------------------- | ------- |
| [[ADD]] [[SUB]] | r,/i      | 1        | IP0/1      | 1       | 0.5                   |         |
| [[ADD]] [[SUB]] | r,m       | 1        | IP0/1, Mem | None    | 1                     |         |
| [[ADD]] [[SUB]] | m ,r/i    | 1        | IP0/1, Mem | 6       | 1                     |         |
### Intel [[Goldmont]]
| Instruccion     | Operandos | [[μops]] | Unit | Latency | Reciprocal throughput | Remarks |
| --------------- | --------- | -------- | ---- | ------- | --------------------- | ------- |
| [[ADD]] [[SUB]] | r,/i      | 1        |      | 1       | 0.33                  |         |
| [[ADD]] [[SUB]] | r,m       | 1        |      | None    | 1                     |         |
| [[ADD]] [[SUB]] | m ,r/i    | 1        |      | 5       | 1                     |         |
### Intel [[Goldmont_Plus]]

| Instruccion     | Operandos | [[μops]] | Unit | Latency | Reciprocal throughput | Remarks |
| --------------- | --------- | -------- | ---- | ------- | --------------------- | ------- |
| [[ADD]] [[SUB]] | r,/i      | 1        |      | 1       | 0.33                  |         |
| [[ADD]] [[SUB]] | r,m       | 1        |      | None    | 1                     |         |
| [[ADD]] [[SUB]] | m ,r/i    | 1        |      | 5       | 1                     |         |
### Intel [[Tremont]]

| Instruccion     | Operandos | [[μops]] | Unit | Latency | Reciprocal throughput | Remarks |
| --------------- | --------- | -------- | ---- | ------- | --------------------- | ------- |
| [[ADD]] [[SUB]] | r,/i      | 1        |      | 1       | 0.33                  |         |
| [[ADD]] [[SUB]] | r,m       | 1        |      | None    | 0.5                   |         |
| [[ADD]] [[SUB]] | m ,r/i    | 1        |      | 6       | 1                     |         |
### Intel [[Knights_Landing]]

| Instruccion     | Operandos | [[μops]] | Unit       | Latency | Reciprocal throughput | Remarks |
| --------------- | --------- | -------- | ---------- | ------- | --------------------- | ------- |
| [[ADD]] [[SUB]] | r,/i      | 1        | IP0/1      | 1       | 0.5                   |         |
| [[ADD]] [[SUB]] | r,m       | 1        | IP0/1, Mem | None    | 1                     |         |
| [[ADD]] [[SUB]] | m ,r/i    | 1        | IP0/1, Mem | 7       | 1                     |         |
