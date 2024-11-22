El [[Assembly/modos de la cpu/modo-real/modo-real]] es un modo simplista de `16 bits` que está presente en todos los procesadores `x86`. El [[Assembly/modos de la cpu/modo-real/modo-real]] fue el primer diseño de modo `x86` y fue utilizado por muchos de los primeros sistemas operativos antes del nacimiento del [[Assembly/MODOS/modo-protegido]]. Por motivos de compatibilidad, todos los procesadores `x86` comienzan la ejecución en [[Assembly/modos de la cpu/modo-real/modo-real]].

Todos los sistemas operativos modernos (`Windows`, `Linux`, ...) se ejecutan en [[Assembly/MODOS/modo-protegido]] o [[Assembly/MODOS/modo-largo]], debido a las muchas limitaciones y problemas que presenta el [[Assembly/modos de la cpu/modo-real/modo-real]] (consulte [[Advertencia_del_sistema_operativo_en_modo_real]]([Real Mode OS Warning](https://wiki.osdev.org/Real_Mode_OS_Warning "Real Mode OS Warning"))). Los sistemas operativos más antiguos (como [[DOS]]) y los programas se ejecutaban en [[Assembly/modos de la cpu/modo-real/modo-real]] porque era el único modo disponible en ese momento. Para obtener información sobre cómo cambiar del [[Assembly/modos de la cpu/modo-real/modo-real]] al [[Assembly/MODOS/modo-protegido]]o, consulte el artículo correspondiente.

Nota: existe un modo llamado [[Assembly/MODOS/modo-virtual-8086]] que permite que los sistemas operativos que se ejecutan en [[Assembly/MODOS/modo-protegido]] emulen el modelo [[segmentación|segmentado]] del [[Assembly/modos de la cpu/modo-real/modo-real]] para aplicaciones individuales. Esto se puede utilizar para permitir que un sistema operativo en modo protegido siga teniendo acceso, por ejemplo, a las funciones del [[BIOS]], siempre que sea necesario.

A continuación encontrará una lista de desventajas y ventajas. En su mayoría, se refieren al modo "en comparación con el [[Assembly/MODOS/modo-protegido]]".

### Contras
- Hay menos de `1 MB` de `RAM` disponible para su uso.
- No hay protección de memoria basada en hardware ([[GDT]]) ni memoria virtual.
- No hay mecanismos de seguridad integrados para proteger contra aplicaciones maliciosas o con errores.
- La longitud predeterminada del operando de la `CPU` es de solo `16 bits`.
- Los modos de direccionamiento de memoria proporcionados son más restrictivos que otros modos de `CPU`.
- Acceder a más de `64k` requiere el uso de registros de segmento con los que es difícil trabajar.

### Pros
- El [BIOS](https://wiki.osdev.org/BIOS "BIOS") instala controladores de dispositivos para controlar dispositivos y manejar interrupciones.
- Las [funciones del BIOS](https://wiki.osdev.org/BIOS#BIOS_functions "BIOS") proporcionan a los sistemas operativos una colección avanzada de funciones API de bajo nivel.
- El acceso a la memoria es más rápido debido a la falta de tablas de descriptores para verificar y registros más pequeños.

### Error común
Los programadores suelen pensar que, dado que el modo real tiene `16 bits` por defecto, los registros de `32 bits` no son accesibles. Esto no es cierto.

Todos los registros de `32 bits` (`EAX`, ...) aún se pueden utilizar, simplemente agregando el "[[Prefijo_de_anulación_del_tamaño_del_operando]]" (`0x66`) al comienzo de cualquier instrucción. Es probable que su ensamblador haga esto por usted, si simplemente intenta usar un registro de `32 bits`.
## Direccionamiento de memoria
En el [[Assembly/modos de la cpu/modo-real/modo-real]], hay un poco más de `1 MB` de memoria "direccionable" (incluida la [zona de memoria alta](https://wiki.osdev.org/Real_Mode#High_Memory_Area)). Consulta [Detección de memoria (x86) ](https://wiki.osdev.org/Detecting_Memory_(x86) "Detección de memoria (x86)")([[Detecting_Memory(x86)]]) y [Mapa de memoria (x86)](https://wiki.osdev.org/Memory_Map_(x86) "Mapa de memoria (x86)") para determinar cuánta memoria es realmente **utilizable**. La cantidad utilizable será mucho menor que `1 MB`. El acceso a la memoria se realiza mediante [Segmentación](https://wiki.osdev.org/Segmentation "Segmentación") a través de un sistema `segmento:desplazamiento`.

Hay seis registros de segmento de `16 bits`: [[CS]], [[DS]], [[ES]], [[FS]], [[GS]] y [[SS]]. Cuando se utilizan registros de segmento, las direcciones se dan con la siguiente notación (donde 'Segmento' es un valor en un [[registros-segmento-selectores-segmento|registro de segmento]] y 'Desplazamiento' es un valor en un registro de dirección):
```c
12F3   :   4B27
  ^         ^
Segment   Offset
```
Los segmentos y los desplazamientos están relacionados con las direcciones físicas mediante la ecuación:
```c
PhysicalAddress = Segment * 16 + Offset
Dirección física = Segmento * 16 + Desplazamiento
```

Por lo tanto, `12F3:4B27` corresponde a la dirección física `0x17A57`. Cualquier dirección física se puede representar de múltiples formas, con diferentes segmentos y desplazamientos. Por ejemplo, la dirección física `0x210` puede ser `0020:0010`, `0000:021`0 o `0021:0000`.

### [[sp-bp-pila|La pila]]
`SS` y `SP` son registros de segmento: desplazamiento de `16 bits` que especifican una dirección física de `20 bits` (descrita anteriormente), que es la "parte superior" actual de la pila. El [[8086]] usaba un direccionamiento de `20bits`. La pila almacena palabras de `16 bits`, crece hacia abajo y debe estar alineada con un límite de palabra (`16 bits`). Se utiliza cada vez que un programa realiza un código de operación [[PUSH]], [[POP]], [[CALL]], [[INT]] o [[RET]] y también cuando el [[BIOS]] maneja cualquier interrupción de hardware.

### Área de memoria alta
Si establece `DS` (o cualquier [[registros-segmento-selectores-segmento|segmento]]) en un valor de `0xFFFF`, apunta a una dirección que está `16 bytes` por debajo de `1 MB`. Si luego utiliza ese registro de segmento como base, con un desplazamiento de `0x10` a `0xFFFF`, puede acceder a direcciones de memoria física de `0x100000` a `0x10FFEF`. Esta área (de casi `64 kB`) por encima de `1 MB` se denomina "High Memory Area (Área de memoria alta)" en [[Assembly/modos de la cpu/modo-real/modo-real]]. Tenga en cuenta que debe tener la línea de dirección [A20](https://wiki.osdev.org/A20 "A20")(vea [[Linea_A20]]) activada para que esto funcione.
### [[modos-direccionamiento| Modos de direccionamiento]]
El [[Assembly/modos de la cpu/modo-real/modo-real]] utiliza el modo de direccionamiento de `16 bits` de forma predeterminada. Los programadores de ensamblador suelen estar familiarizados con los modos de direccionamiento de `32 bits` más comunes y es posible que deseen realizar ajustes, ya que los registros que están disponibles en el modo de direccionamiento de `16 bits` para su uso como "punteros" son mucho más limitados. Los programas típicos que se ejecutan en [[Assembly/modos de la cpu/modo-real/modo-real]] suelen estar limitados en la cantidad de bytes disponibles y se necesita un byte adicional en cada código de operación para utilizar el direccionamiento de `32 bits` en su lugar.

Tenga en cuenta que aún puede utilizar modos de direccionamiento de `32 bits` en `modo real`, simplemente agregando el "[[Prefijo_de_anulación_del_tamaño_de_la_dirección]]" (`0x67`) al comienzo de cualquier instrucción. Es probable que su ensamblador haga esto por usted, si simplemente intenta utilizar un modo de direccionamiento de `32 bits`. Pero aún estás limitado por el "límite" actual para el segmento que utilizas en cada acceso a la memoria (siempre `64K` en `modo real`; el [modo irreal](https://wiki.osdev.org/Unreal_Mode "Modo irreal") puede ser más grande).
- [BX + val]
- [SI + val]
- [DI + val]
- [BP + val]
- [BX + SI + val]
- [BX + DI + val]
- [BP + SI + val]
- [BP + DI + val]
- [address]

## Cambiar del [[Assembly/MODOS/modo-protegido]]([Protected Mode](https://wiki.osdev.org/Protected_Mode "Protected Mode")) " al [[Assembly/modos de la cpu/modo-real/modo-real]]

Como se indicó anteriormente, es posible que un sistema operativo en [[Assembly/MODOS/modo-protegido]] utilice el [[Assembly/MODOS/modo-virtual-8086]]([Virtual 8086 Mode](https://wiki.osdev.org/Virtual_8086_Mode "Virtual 8086 Mode")) para acceder a las funciones del [[BIOS]]. Sin embargo, el modo [[VM86]] tiene sus propias complicaciones y dificultades. Algunos diseñadores de SO piensan que es más simple y limpio volver temporalmente al [[Assembly/modos de la cpu/modo-real/modo-real]] en aquellas ocasiones en las que es necesario acceder a una función del [[BIOS]]. Esto requiere crear un programa especial `Ring 0` y colocarlo en una dirección de memoria física a la que se pueda acceder en [[Assembly/modos de la cpu/modo-real/modo-real]].
El SO generalmente necesita pasar un paquete de información sobre qué función del [[BIOS]] ejecutar.
El programa debe seguir los siguientes pasos:
1. Deshabilitar las interrupciones:
	- Desactive las interrupciones enmascarables mediante [[CLI]].
	- Desactivar [NMI](https://wiki.osdev.org/NMI "NMI") (opcional).
2. Desactivar [paginación](https://wiki.osdev.org/Paging "Paging"):
	- Transferir el control a una página 1:1.
	- Asegurarse de que [GDT](https://wiki.osdev.org/GDT "GDT") y [IDT](https://wiki.osdev.org/IDT "IDT")([[IDT]]) estén en una página 1:1.
	- Borrar el indicador `PG` en el registro de control cero([[CR0]]).
	- Establezca el tercer registro de control en 0([[CR3]]).
3. Utilice [[GDT]] con tablas de `16 bits` (omita este paso si ya hay una disponible):
	- Cree un nuevo [[GDT]] con un segmento de código y datos de `16 bits`:
		- Límite: `0xFFFFF`
		- Base: `0x0`
		- 16 bits
		- Nivel de privilegio: `0`
		- Granularidad: `0`
		- Lectura y escritura: `1`
	- Cargue el nuevo [[GDT]] asegurándose de que los [[Selectores-de-segmento]] utilizados actualmente seguirán siendo los mismos (el índice en [[CS]]/[[DS]]/[[SS]] será una copia del segmento original en el nuevo [[GDT]])
4. Salto lejano(`jmp far`) al [[Assembly/MODOS/modo-protegido]] de `16 bits`:
	- Salto lejano(`jmp far`) al [[Assembly/MODOS/modo-protegido]] de `16 bits` con un índice de segmento de `16 bits`.
5. Cargue selectores de segmento de datos con índices de `16 bits`:
	- Cargue [[DS]], [[ES]], [[FS]], [[GS]], [[SS]] con un segmento de datos de `16 bits`.
6. Cargar [[IDT]] en [[Assembly/modos de la cpu/modo-real/modo-real]]:
	- Límite: `0x3FF`
	- Base `0x0`
	- Usar [[LIDT]]
7. Deshabilitar el modo protegido:
	- Establecer el bit `PE` en [[CR0]] en falso.
8. Salto lejano(`jmp far`) al [[Assembly/modos de la cpu/modo-real/modo-real]]:
	- Salto lejano(`jmp far`) al [[Assembly/modos de la cpu/modo-real/modo-real]] con el [[registros-segmento-selectores-segmento|selector de segmento]] de [[Assembly/modos de la cpu/modo-real/modo-real]] (normalmente 0).
9. Recargar los registros de segmento de datos con valores de modo real:
	- Cargar [[DS]], [[ES]], [[FS]], [[GS]], [[SS]] con valores de [[Assembly/modos de la cpu/modo-real/modo-real]] adecuados (normalmente 0).
10. Establecer el puntero de pila en el valor adecuado:
	- Establecer SP en el valor de pila que no interfiera con el programa de [[Assembly/modos de la cpu/modo-real/modo-real]].
11. Habilitar interrupciones:
	- Habilitar interrupciones enmascarables con [[STI]].
12. Continuar en [[Assembly/modos de la cpu/modo-real/modo-real]] con todas las interrupciones del [[BIOS]].

## x86 Assembly Example
```r
[bits 16]

idt_real:
	dw 0x3ff		; 256 entradas, 4b cada una = 1K
	dd 0			; Modo real IVT @ 0x0000

savcr0:
	dd 0			; Ubicación de almacenamiento para pmode CR0.

Entry16:
        ; ¡Ya estamos en modo 16 bits aquí!

	cli			; Deshabilitar interrupciones..

	; ¡Necesitas entradas GDT en modo protegido de 16 bits!
	mov eax, DATASEL16	; Selector de datos de modo protegido de 16 bits.
	mov ds, eax
	mov es, eax
	mov fs, eax
	mov gs, eax
	mov ss, eax

	; Deshabilitar la paginación (necesitamos que todo esté mapeado 1:1).
	mov eax, cr0
	mov [savcr0], eax	; guardar pmode CR0
	and eax, 0x7FFFFFFe	; Deshabilitar el bit de paginación y deshabilitar el modo p de 16 bits.
	mov cr0, eax

	jmp 0:GoRMode		; Realizar Salto lejano para configurar CS.

GoRMode:
	mov sp, 0x8000		; Seleccione un puntero de pila.
	mov ax, 0		    ; Restablecer los registros de segmento a 0.
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	lidt [idt_real]
	sti		     	     ; Restaurar interrupciones: tenga cuidado, las 
						 ; int no controladas lo matarán.
```

## See Also

### Articles
- [BIOS](https://wiki.osdev.org/BIOS "BIOS")
- [System Initialization (x86)](https://wiki.osdev.org/System_Initialization_(x86) "System Initialization (x86)")
- [Protected Mode](https://wiki.osdev.org/Protected_Mode "Protected Mode")

### External Links
- [The Workings of: x86-16/32 Real Mode Addressing](https://web.archive.org/web/20130609073242/http://www.osdever.net/tutorials/rm_addressing.php?the_id=50) (2003)
- [The workings of IA32 real mode addressing and the A20 line](http://therx.sourceforge.net/osdev/files/ia32_rm_addr.pdf) (2004)

### References
- [Intel® 64 and IA-32 Architectures Software Developer's Manual](http://www.intel.com/products/processor/manuals/) (2011)
    - Volume 3A: System Programming Guide, Part 1,Chapter 20:8086 EMULATION,which is a detailed reference about real mode using 32-bit addressing mode