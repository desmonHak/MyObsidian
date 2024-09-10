La tabla de descriptores globales ([[GDT]]) es una tabla en la memoria específica de las arquitecturas `IA-32` y `x86-64`, Contiene entradas que informan a la [[CPU]] sobre los segmentos de memoria. (vea también [[Selectores-de-segmento]]) del procesador. Existe una tabla de descriptores de interrupciones similar que contiene descriptores de tareas e interrupciones. La [[GDT]] establece el comportamiento de los registros de segmentos y ayuda a garantizar que el modo protegido funcione sin problemas.
Se recomienda leer el [GDT Tutorial](https://wiki.osdev.org/GDT_Tutorial "GDT Tutorial")..

La tabla [[GDT]] contiene una serie de entradas denominadas `descriptores de segmento`. Cada una tiene una longitud de `8 bytes` y contiene información sobre el punto de inicio del segmento, la longitud del segmento y los derechos de acceso del segmento.

| 80 (64-bit mode)  <br>48 (32-bit mode)   16                | 15   0                     |
| ---------------------------------------------------------- | -------------------------- |
| **Offset**  <br>63 (64-bit mode)  <br>31 (32-bit mode)   0 | **Size**  <br>  <br>15   0 |
**`Size`**: el tamaño de la tabla en `bytes` menos 1. Esta resta se produce porque el valor máximo de Tamaño es `65535`, mientras que la [[GDT]] puede tener una longitud de hasta `65536` `bytes` (`8192 entradas`). Además, ninguna [[GDT]] puede tener un tamaño de `0 bytes`.  El tamaño de `Size` es de `16bytes` tanto en 32 como en `64bits`.
**`Offset`**(Desplazamiento): la dirección lineal de la [[GDT]] (**no la dirección física**, se aplica la **paginación**). El offset sera de `32bits` en una cpu de `32bits` y de `64bits` en una cpu de `64bits`

Tenga en cuenta que la cantidad de datos cargados por [[LGDT]] difiere en los modos de `32 bits` y `64 bits`; el desplazamiento tiene una longitud de `4 bytes` en el modo de `32 bits` y de `8 bytes` en el modo de `64 bits`.

Para obtener más información, consulte la `Sección 2.4.1: Registro de tabla de descriptores globales` ([[GDTR]]) y la `Figura 2-6: Registros de administración de memoria del Manual del desarrollador de software de Intel`, `volumen 3-A`.

Las entradas en el [[GDT]] tienen una longitud de 8 bytes y forman una tabla como esta:

| Address                | Content   |
| ---------------------- | --------- |
| [[GDTR]] `Offset + 0`  | `Null`    |
| [[GDTR]] `Offset + 8`  | `Entry 1` |
| [[GDTR]] `Offset + 16` | `Entry 2` |
| [[GDTR]] `Offset + 24` | `Entry 3` |
| **...**                | **...**   |
La primera entrada de la [[GDT]] (**Entrada 0**) debe ser **siempre nula** y en su lugar deben utilizarse las entradas siguientes.

A las entradas de la tabla se accede mediante `selectores de segmento`, que se cargan en los registros de segmentación mediante instrucciones de ensamblador o mediante funciones de hardware como las interrupciones. 

El siguiente código de sintaxis `NASM` representa una única entrada [[GDT]]: 
```r
struc gdt_entry_struct

	limit_low:   resb 2
	base_low:    resb 2
	base_middle: resb 1
	access:      resb 1
	granularity: resb 1
	base_high:   resb 1

endstruc
```
El selector de segmento, carga la tabla de descriptores de segmento y elige el descriptor de segmento especifico, se obtiene la Base del descriptor de segmento y se suma al offset comprobando que no se exceda el limite
![[Pasted image 20240905184820.png]]

[[Descriptor-de-segmento]]:
Cada entrada de la tabla tiene una estructura compleja:
![[Pasted image 20240905185326.png]]

63   56|55   52|51   48|47   40|39   32
---|---|---|---|---
**Base**  31   24|**Flags** 3   0|**Limit**  19   16|**Access Byte**  7   0|**Base** 23   16
Vea los campos en [[Descriptor-de-segmento]]

| 31   16          | 15   0            |
| ---------------- | ----------------- |
| **Base**  15   0 | **Limit**  15   0 |
## [[GDTR]] (en 32bits)
El [[GDT]] se indica mediante un registro especial en el chip `x86`, el registro [[GDT]] o simplemente [[GDTR]]. El [[GDTR]] tiene una longitud de `48 bits`. Los `16 bits` inferiores indican el tamaño del [[GDT]] y los `32 bits` superiores indican la ubicación del `GDT` en la memoria. A continuación se muestra un esquema del `GDTR`:
```c
|LIMIT|----BASE----|
```
`LIMIT` es el tamaño de la [[GDT]] y `BASE` es la dirección inicial. `LIMIT` es 1 menos que la longitud de la tabla, por lo que si `LIMIT` tiene el valor 15, la [[GDT]] tiene `16 bytes` de longitud.

Para cargar la [[GDTR]], se utiliza la instrucción [[LGDT]]:
```r
lgdt [gdtr]
```

Donde [[GDTR]] es un **puntero** a `6 bytes` de memoria que contiene el valor [[GDTR]] deseado. Nótese que para completar el proceso de carga de un nuevo [[GDT]], **los registros de segmento necesitan ser recargados**. El registro [[CS]] debe cargarse utilizando un salto lejano(`jmp far`):
```r
flush_gdt:
    lgdt [gdtr]
    jmp 0x08:complete_flush
 
complete_flush:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    ret
```