https://github.com/ranma42/TigerOnVBox/blob/master/Explanation.md
Configuración del perfil de la ``CPU`` y del [[CPUID]]
El núcleo de **Mac OS X** 10.4 no puede analizar correctamente parte de la información del [[CPUID]] de las ``CPU`` modernas, lo que provoca un bloqueo total al cargar módulos o un pánico del núcleo en la inicialización del núcleo. Afortunadamente, ``VirtualBox`` permite anular la mayor parte de la información del [[CPUID]].

Para entender lo que sucede, se requiere cierto conocimiento sobre la instrucción [[CPUID]]. Devuelve "``identificación de la CPU``" (e información de las características) sobre el procesador. El contenido del registro ``EAX`` (y en algunos casos del [[Registros]] ``ECX``) selecciona la hoja (y la subhoja), es decir, qué información debe devolverse. Los registros ``EAX``, ``EBX``, ``ECX`` y ``EDX`` se utilizan para almacenar la salida.

``VirtualBox`` permite anular los valores devueltos por esta instrucción de dos maneras:

solicitando que se emule un procesador diferente
```c
VBoxManage modifyvm Tiger --cpu-profile 'Intel Pentium 4 3.00GHz'
```

anulando una hoja específica
```c
VBoxManage modifyvm <VM_Name> --cpuidset <leaf> <eax> <ebx> <ecx> <edx>
```
La hoja [[CPUID(0)]] ``EAX=0`` devuelve el valor máximo para las hojas [[CPUID]] básicas en ``EAX`` y una cadena de identificación del proveedor en ``EBX-EDX-ECX``. En algunos casos (por ejemplo, para realizar una migración en vivo de máquinas virtuales en diferentes procesadores), es deseable restringir las características de la ``CPU`` tanto como sea posible, pero en nuestro caso, nuestro objetivo es que estén disponibles para la máquina virtual. Específicamente, para habilitar múltiples procesadores, necesitamos habilitar al menos la hoja ``EAX=4`` (la identificación del proveedor se puede dejar como está).

```c
# Establezca CPUID EAX=0 para devolver 00000004 "Genu" "ntel" "ineI"
VBoxManage modifyvm Tiger --cpuidset 00000000 00000004 756e6547 6c65746e 49656e69
```

Las subhojas de ``EAX=4`` contienen información de caché que el núcleo tiene problemas para analizar y, desafortunadamente, no parece haber forma de anular una subhoja en ``VirtualBox`` sin anular todo el perfil de la ``CPU``. Entre los perfiles que se incluyen actualmente en ``VirtualBox``, el ``Intel Pentium 4 de 3,00 GHz`` es el único que parece arrancar bien con el límite de hojas establecido en 4.

Si se establece el perfil de la ``CPU`` en un ``Pentium 4`` antiguo, es probable que ``VirtualBox`` no exponga varias de las funciones disponibles en la ``CPU``. Las anulaciones para ``EAX=1`` y ``EAX=0x80000001`` se utilizan para volver a habilitar cualquier función compatible con la ``CPU``. En realidad, las anulaciones habilitarán incluso funciones que no son compatibles con la ``CPU`` del host, pero ``VirtualBox`` se encarga de filtrarlas.
```c
# Establezca CPUID EAX=1 para devolver la información de la versión/marca de Pentium 4
# pero anule las funciones, habilitando todo excepto XSAVE
VBoxManage modifyvm Tiger --cpuidset 00000001 00000f43 00020800 fbffffff ffffffff
# Establezca CPUID EAX=0x80000001 para devolver cualquier función como habilitada
VBoxManage modifyvm Tiger --cpuidset 80000001 00000000 00000000 ffffffff ffffffff
```
Tenga en cuenta que [[XSAVE]] (``bit 26`` de ``ECX`` para ``EAX=1``) no está habilitado. Esto es necesario porque VirtualBox se quejará al iniciarse si ese bit está habilitado en un procesador sin [[LEAF]] ``EAX=0xd``. Estas anulaciones de funciones son muy agresivas y es posible que en el futuro se deban deshabilitar otras funciones como [[XSAVE]].

### Datos DMI 
El núcleo y la mayoría de las aplicaciones no parecen comprobar los datos DMI, con la excepción de System Profiler. Con la configuración predeterminada, no puede mostrar la información básica del hardware, aparentemente porque intenta analizar la versión del BIOS de una manera específica. Es decir, la convierte en tokens utilizando . como separador y muestra el primer, tercer y cuarto token. Por lo tanto, para que funcione la página de Hardware, la versión del BIOS se reemplaza con:
```c
VBoxManage setextradata Tiger VBoxInternal/Devices/efi/0/Config/DmiBIOSVersion EFI32..Virtual.Box
```
En general, sería posible reemplazarla con
```c
VBoxManage setextradata Tiger VBoxInternal/Devices/efi/0/Config/DmiBIOSVersion AAA.BBB.CCC.DDD.EEE
```
Esto hace que la página Perfilador del sistema → Hardware muestre "Versión de ROM de arranque: AAA.CCC.DDD"
Además, la máquina virtual está configurada para usar los datos DMI predeterminados de VirtualBox en lugar de propagar los datos del host:
```c
VBoxManage setextradata Tiger VBoxInternal/Devices/efi/0/Config/DmiUseHostInfo 0
```