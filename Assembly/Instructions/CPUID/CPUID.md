[Intel CPUID segun wikichip](https://en.wikichip.org/wiki/intel/cpuid#:~:text=Below%20is%20a%20list%20of%20Intel's)
[Hypervisor Discovery Microsoft](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery)
[AMD CPUID segun wikichip](https://en.wikichip.org/wiki/amd/cpuid)

To PyTorch ``CPU INFOrmation library (x86/x86-64/ARM/ARM64,Linux/Windows/Android/macOS/iOS)``: 
https://github.com/pytorch/cpuinfo/tree/main/src/x86

[[CPUID(0)]]
[[CPUID(1)]]
[[CPUID(2)]]
[[CPUID(3)]]
[[CPUID(4)]]

``Intel`` y ``AMD`` han reservado los niveles de [[CPUID]] ``0x40000000`` - ``0x400000FF`` para uso de software. Los hipervisores pueden usar estos niveles para proporcionar una interfaz para pasar información desde el hipervisor al invitado que se ejecuta dentro de una máquina virtual.
sta propuesta define un marco estándar para la forma en que las comunidades de Linux e hipervisores definen de manera incremental este espacio de [[CPUID]].
(Esta propuesta puede ser adoptada por otros sistemas operativos invitados. Sin embargo, esto no es un requisito porque un hipervisor puede exponer una interfaz [[CPUID]] diferente según el tipo de sistema operativo invitado que se especifica en la configuración de la máquina virtual).

Bit presente del hipervisor: ``Bit 31`` de ``ECX`` de la hoja [[CPUID(1)]]. ``Intel`` y ``AMD`` han reservado este bit para que lo usen los hipervisores, e indica la presencia de un hipervisor.

Las ``CPU`` virtuales (hipervisores) establecen este bit en ``1`` y las ``CPU`` físicas (todas las ``CPU`` existentes y futuras) establecen este bit en cero. El software invitado puede sondear este bit para detectar si se está ejecutando dentro de una máquina virtual.

Se garantiza que  [[CPUID(0x40000000)]] y  [[CPUID(0x40000001)]] existirá si el bit de presencia de hipervisor ([[HVP]]) está habilitado en  [[CPUID(1)]] devuelve ``ECX``: ``bit 31`` establecido), que es un requisito para la interfaz PV de [[Hyper-V]]. ^69528c

  
Hoja de información de [[CPUID(0x40000000)]] del hipervisor: Hoja ``0x40000000``. Esta hoja devuelve el rango de hojas de [[CPUID]] admitido por el hipervisor y la firma del proveedor del hipervisor. # EAX: El valor de entrada máximo para [[CPUID]] admitido por el hipervisor.  
``EBX``, ``ECX``, ``EDX``: Firma de ID del proveedor del hipervisor. Hojas específicas del hipervisor: Rango de hojas ``0x40000001`` - ``0x4000000F``. Estas hojas de [[CPUID]] están reservadas como hojas específicas del hipervisor. La semántica de estas 15 hojas depende de la firma leída de la "Hoja de información del hipervisor".

``Hojas genéricas``: Rango de hojas ``0x40000010`` - ``0x4000000FF``. La semántica de estas hojas es consistente en todos los hipervisores. Esto permite que el núcleo invitado pruebe e interprete estas hojas sin verificar la firma del hipervisor. Un hipervisor puede indicar que una hoja o el campo de una hoja no es compatible al devolver cero cuando se prueba esa hoja o campo. Para evitar la situación en la que varios hipervisores intentan definir la semántica de la misma hoja durante el desarrollo, podemos dividir el espacio de hojas genérico para permitir que cada hipervisor defina una parte del espacio genérico.
### Por ejemplo:
- ``VMware`` podría definir ``0x4000001X``
- ``Xen``      podría definir ``0x4000002X``
- ``KVM``      podría definir ``0x4000003X``
- y así sucesivamente...

Tenga en cuenta que los hipervisores pueden implementar cualquier hoja que se haya
definido en el espacio de hojas genérico siempre que se puedan encontrar características comunes. Por ejemplo, los hipervisores ``VMware`` pueden implementar hojas
que se hayan definido en el área [[KVM]] ``0x4000003X`` y viceversa.

El núcleo puede detectar la compatibilidad con un campo genérico dentro de la hoja
``0x400000XY`` mediante el siguiente algoritmo:

1. Obtenga ``EAX`` de la hoja ``0x400000000``, información de [[CPUID]] del hipervisor.
``EAX`` devuelve el valor de entrada máximo para el espacio de [[CPUID]] del hipervisor.

Si ``EAX`` < ``0x400000XY``, el campo no está disponible.

2. De lo contrario, extraiga el campo de la hoja de destino ``0x400000XY``
haciendo [[CPUID]](``0x400000XY``).

Si (``campo == 0``), el hipervisor no admite o no implementa esta función. El núcleo debe manejar este caso
con elegancia para que nunca se requiera que un hipervisor admita o implemente ninguna hoja genérica en particular.

--------------------------------------------------------------------------------

Definición del espacio [[CPUID(0x40000010)]] genérico.
Hoja ``0x40000010``, Información de tiempo.
``VMware`` ha definido la primera hoja genérica para proporcionar información de tiempo.
Esta hoja devuelve la frecuencia [[TSC]] actual y la frecuencia Bus actual en ``kHz``.
#### EAX: Frecuencia TSC (virtual) en kHz.
#### EBX: Frecuencia Bus (virtual) (temporizador apic local) en kHz.
#### ECX, EDX: RESERVADO (según lo anterior, los campos reservados se establecen en cero).


Según ``Microsoft``, un bit de indicador en el registro ``ECX`` (bit n.° 31, "``Hipervisor presente``"), después de ejecutar [[CPUID(1)]] con el registro ``EAX`` establecido en ``0x000000001``, se establecerá en 1 en una máquina virtual (``Microsoft``) y en 0 en el hardware real. Este es, de hecho, el mecanismo de detección oficial del hipervisor. También es el mecanismo de detección oficial para ``VMWare6``.

**Pero aquí ``Microsoft`` y ``VMWare`` se basan incorrectamente en un accidente de implementación de hardware. Las especificaciones [[CPUID]] de ``Intel2`` y ``AMD3`` establecen que el bit n.° 31 del registro ECX está reservado. La especificación de Intel incluso establece explícitamente que no se debe confiar en el valor del bit.** ^c89788

La detección de la ejecución de software en una máquina virtual ``VMware`` se basa en dos mecanismos: Prueba del bit de presencia del hipervisor [[CPUID]] Prueba de la información [[DMI]] del ``BIOS`` virtual y del puerto del hipervisor Prueba del bit de presencia del hipervisor [[CPUID]]

Las ``CPU`` Intel y ``AMD`` han reservado el ``bit 31`` de ``ECX`` de la hoja [[CPUID(1)]] como bit de presencia del hipervisor. Este bit permite que los hipervisores indiquen su presencia al sistema operativo invitado. Los hipervisores configuran este bit y las ``CPU`` físicas (todas las ``CPU`` existentes y futuras) configuran este bit en cero. Los sistemas operativos invitados pueden probar el ``bit 31`` para detectar si se están ejecutando dentro de una máquina virtual.

``Intel`` y ``AMD`` también han reservado las hojas [[CPUID]] ``0x40000000`` - ``0x400000FF`` para uso de software. Los hipervisores pueden usar estas hojas para proporcionar una interfaz para pasar información del hipervisor al sistema operativo invitado que se ejecuta dentro de una máquina virtual. El bit del hipervisor indica la presencia de un hipervisor y que es seguro probar estas hojas de software adicionales. ``VMware`` define la hoja ``0x40000000`` como la hoja de información de [[CPUID]] del hipervisor. El código que se ejecuta en un hipervisor ``VMware`` puede probar la hoja de información de [[CPUID]] para la firma del hipervisor. ``VMware`` almacena la cadena "``VMwareVMware``" en ``EBX``, ``ECX``, ``EDX`` de la hoja de [[CPUID]] ``0x40000000``. Código de muestra
  
Prueba de la información [[DMI]] del ``BIOS`` virtual y del puerto del hipervisor Además del método basado en [[CPUID]] para la detección de máquinas virtuales de ``VMware``, ``VMware`` también proporciona un mecanismo de respaldo por las siguientes razones: Esta técnica basada en [[CPUID]] no funcionará para el código invitado que se ejecuta en [[CPL3]] cuando [[VT]]/[[AMD-V]] no está disponible o no está habilitado. El bit de presencia del hipervisor y la hoja de información del hipervisor **solo se definen para productos basados ​​en la versión 7 del hardware de VMware**. 

### Información [[DMI]] del ``BIOS`` virtual
El ``BIOS`` virtual de ``VMware`` tiene muchos identificadores específicos de ``VMware`` que los programas pueden usar para detectar hipervisores. Para la comprobación de la cadena [[DMI]], utilice el número de serie del ``BIOS`` y compruebe si contiene la cadena "``VMware``-" o "``VMW``" (para invitados ``Mac OS`` X que se ejecutan en Fusion). 
Código de muestra
```c
int dmi_check(void)
{
        char string[10];
        GET_BIOS_SERIAL(string);

        if (!memcmp(string, "VMware-", 7) || !memcmp(string, "VMW", 3))
            return 1;                       // DMI contains VMware specific string.
        else return 0;
}
```

Realizar solo la comprobación de DMI no es suficiente porque el número de serie del BIOS puede, por casualidad, contener la cadena "``VMware``-" o "``VMW``". También debe probar el puerto del hipervisor.

### Puerto del hipervisor
``VMware`` implementa un puerto de ``E/S`` que los programas pueden consultar para detectar si el software se está ejecutando en un hipervisor de ``VMware``. Este puerto de hipervisor se comporta de manera diferente según los valores mágicos en ciertos registros y modifica algunos registros como efecto secundario. El hipervisor de ``VMware`` se detecta al realizar una operación [[IN]] en el puerto ``0x5658`` (el puerto del hipervisor de ``VMware``).

Realizar una operación [[IN]] en el puerto ``0x5658`` con
```c

eax = 0x564D5868 (valor mágico del hipervisor de VMware)
ebx = 0xFFFFFFFF (UINT_MAX)
ecx = 10 (identificador del comando Getversion)
edx = 0x5658 (número de puerto del hipervisor)
```
En ``VMware``, esta operación modifica el valor del registro ``ebx`` a ``0x564D5868`` (el valor mágico del hipervisor de ``VMware``).

Código de ejemplo
```c
[[define]] VMWARE_HYPERVISOR_MAGIC 0x564D5868
[[define]] VMWARE_HYPERVISOR_PORT 0x5658

[[define]] VMWARE_PORT_CMD_GETVERSION 10

[[define]] VMWARE_PORT(cmd, eax, ebx, ecx, edx) \
	__asm__("inl (%%dx)" : \
	"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) : \
		"0"(VMWARE_HYPERVISOR_MAGIC), \
		"1"(VMWARE_PORT_CMD_##cmd), \
		"2"(VMWARE_HYPERVISOR_PORT), "3"(UINT_MAX) : \
	"memoria");

int hypervisor_port_check(void)
{
	uint32_t eax, ebx, ecx, edx;
	VMWARE_PORT(GETVERSION, eax, ebx, ecx, edx);
	// Correcto: se ejecuta en VMware
	if (ebx == VMWARE_HYPERVISOR_MAGIC) return 1; 
	else return 0;
}
```

Aunque este puerto se encuentra fuera del espacio ``ISA`` ``x86``, un sistema físico puede tener un dispositivo que use el mismo número de puerto que el puerto del hipervisor de ``VMware``. Acceder al puerto del dispositivo físico en dichos sistemas puede tener un efecto indefinido en ese dispositivo. Para evitarlo, pruebe la información del ``BIOS`` virtual antes de consultar el puerto del hipervisor.
Código recomendado

```c
int Detect_VMware(void) {
	// Correcto: se ejecuta en VMware.
	if (cpuid_check()) return 1; 
	else if (dmi_check() && hypervisor_port_check()) return 1;
	
	return 0;
}
```
