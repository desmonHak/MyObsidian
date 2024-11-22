https://wiki.osdev.org/Protected_Mode

El [[Assembly/modos de la cpu/modo-protegido]] es el modo operativo principal de los procesadores Intel modernos (y clones) desde el [[80286]] (`16 bits`) hasta la creación del [[Assembly/modos de la cpu/modo-largo]]. En los [[i80386]] y posteriores, el [[Assembly/modos de la cpu/modo-protegido]] de `32 bits` permite trabajar con varios espacios de direcciones virtuales, cada uno de los cuales tiene un máximo de `4 GB` de memoria direccionable; y permite que el sistema aplique una protección estricta de la memoria y de la `E/S` del hardware, así como que restrinja el conjunto de instrucciones disponible a través de anillos.

Una `CPU` que se inicializa mediante el [[BIOS]] se inicia en [[Assembly/modos de la cpu/modo-real/modo-real]]. Al habilitar el [[Assembly/modos de la cpu/modo-protegido]], se libera la potencia real de la `CPU`. Sin embargo, evitará que utilice la mayoría de las interrupciones del [[BIOS]], ya que estas funcionan en [[Assembly/modos de la cpu/modo-real/modo-real]] (a menos que también haya escrito un monitor [[V86]]([[Assembly/modos de la cpu/modo-virtual-8086]])).
## Ingresar al modo protegido
Antes de cambiar al [[Assembly/modos de la cpu/modo-protegido]], debe:
- Deshabilitar las interrupciones, incluida [NMI](https://wiki.osdev.org/Non_Maskable_Interrupt "Interrupción no enmascarable") (como se sugiere en el Manual de desarrolladores de Intel).
- Habilitar la [Línea A20](https://wiki.osdev.org/A20_Line "Línea A20")(vea [[Linea_A20]]).
- Cargar la [Tabla de descriptores globales](https://wiki.osdev.org/Global_Descriptor_Table "Tabla de descriptores globales") con descriptores de segmento adecuados para código, datos y pila.

El bit más bajo del registro [[CR0]] o [[MSW]] define si la `CPU` está en modo real o en modo protegido.

Este ejemplo carga una tabla de descriptores en el registro [[GDTR]] del procesador y luego establece el bit más bajo de [[CR0]]:
```r
cli            ; Deshabilitar interrupciones
lgdt [gdtr]    ; cargar el registro GDT con la dirección de inicio de la tabla de descriptores globales
mov eax, cr0 
or al, 1       ;Establezca el bit PE (habilitación de protección) en CR0 (registro de control 0)
mov cr0, eax

; Realizar un salto lejano al selector 08h (desplazamiento hacia GDT, apuntando a un descriptor de segmento de código PM de 32 bits)
; para cargar CS con el descriptor PM32 adecuado)
jmp 08h:PModeMain

PModeMain:
; cargar DS, ES, FS, GS, SS, ESP

```

## See Also
### Articles
- [Real Mode](https://wiki.osdev.org/Real_Mode "Real Mode")
- [Virtual 8086 Mode](https://wiki.osdev.org/Virtual_8086_Mode "Virtual 8086 Mode")

### External Links
- [http://www.osdever.net/tutorials/view/the-world-of-protected-mode](http://www.osdever.net/tutorials/view/the-world-of-protected-mode) - very good tutorial on how to enter protected mode
- [OSRC: protected mode](http://www.nondot.org/sabre/os/articles/ProtectedMode/)
- [http://home.swipnet.se/smaffy/asm/info/embedded_pmode.pdf](http://home.swipnet.se/smaffy/asm/info/embedded_pmode.pdf) - pragmatic tutorial on protected mode ([Cached copy](http://web.archive.org/web/20030604185154/http://home.swipnet.se/smaffy/asm/info/embedded_pmode.pdf))
- [http://www.brokenthorn.com/Resources/OSDev8.html](http://www.brokenthorn.com/Resources/OSDev8.html)
- [Protected mode Wikipedia page](https://wikipedia.org/wiki/Protected_mode "wikipedia:Protected mode")
- [http://members.tripod.com/protected_mode/alexfru/pmtuts.html](http://members.tripod.com/protected_mode/alexfru/pmtuts.html) - PMode tutorials in C & Asm