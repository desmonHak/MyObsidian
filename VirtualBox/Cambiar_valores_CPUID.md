https://forums.virtualbox.org/viewtopic.php?t=56345
Para cambiar valores en [[CPUID]] necesita [[Listar_maquinas_vm]] y observar que nombre tiene la maquina que desea alterar.

Ejemplos con el [[PAE]]:
```c
VBoxManage modifyvm "VM_without_PAE" --cpuidset 0x00000001 0x00020655 0x00000800 0x00000209 0x078bfbbf
VBoxManage modifyvm "VM_without_PAE" --cpuidset 0x80000001 0x00000000 0x00000000 0x00000001 0x28000800
VBoxManage setextradata "VM_without_PAE" VBoxInternal/CPUM/CPUID/00000001/edx 0x078bfbbf
VBoxManage setextradata "VM_without_PAE" VBoxInternal/CPUM/CPUID/80000001/edx 0x28000800
VBoxManage setextradata "VM_without_PAE" VBoxInternal/CPUM/HostCPUID/00000001/edx 0x078bfbbf
VBoxManage setextradata "VM_without_PAE" VBoxInternal/CPUM/HostCPUID/80000001/edx 0x28000800
```

```c
VBoxManage setextradata "name_vm" VBoxInternal/CPUM/HostCPUID/val_cpuid/reg number_val
```
Cambiar ``"name_vm"`` por el nombre de su VM, cambiar ``val_cpuid`` por el valor/pagina de [[CPUID]] a la que acceder, cambiar `reg` por el nombre de registro que modificar, cambiar `number_val` por  un valor numérico que indique el valor a asignar.

**He encontrado la solución:**  
Si una VM huésped debe permitir huéspedes de ``64 bits``, ciertas características [[CPUID]] tienen que ser establecidas. Estos se establecerán incluso si se anulan los valores [[CPUID]]. Si quieres saber qué características están configuradas, abre [[HWACCM.cpp]] y busca

```c
[[ifdef]] VBOX_ENABLE_64_BITS_GUESTS
```

El soporte de huéspedes de ``64 bits`` depende del valor de 
_``VBoxInternal/HWVirtExt/64bitEnabled``_ (``0 = desactivado``, ``1 = activado``). 

Por defecto, **_64bitEnabled_ es 0 en un host de 32 bits** y **1 en un host de 64 bits**. Así que si estás ejecutando un host de 64 bits (como yo) tienes que ejecutar

```c
VBoxManage setextradata <NombreVM> VBoxInternal/HWVirtExt/64bitEnabled 0
```

para desactivar los bits de características no deseadas.
[Top](https://forums.virtualbox.org/viewtopic.php?t=56345#top «Top»)
[Publicar respuesta](https://forums.virtualbox.org/posting.php?mode=reply&t=56345 «Publicar una respuesta»)


https://forums.virtualbox.org/viewtopic.php?t=78859
La configuración ``VendorID`` que está documentada como parte de las opciones de depuración de [[Hyper-V]] paravirtualización (``PV``) específicas del hipervisor. Se garantiza que [[CPUID(0x40000000)]] y [[CPUID(0x40000001)]] (EAX``=0x40000000:0x40000001``) existirá si el bit de presencia de hipervisor ([[HVP]]) está habilitado en [[CPUID]] (``EAX=0x00000001`` devuelve ``ECX: bit 31`` establecido), que es un requisito para la interfaz ``PV`` de [[Hyper-V]].

Esto no es lo mismo que la hoja [[CPUID(0)]] estándar (``EAX:0``) donde ``EBX``, ``ECX``, ``EDX`` devuelven la firma del proveedor de la ``CPU``. Esta hoja estándar existirá independientemente de si se utiliza una interfaz PV para la máquina virtual.
```c
VBoxManage modifyvm test-VM --paravirtdebug "enabled=1,vendorid='AuthenticAMD'"
```

¡**La sintaxis anterior es incorrecta**! No utilice comillas y recuerde que la firma tiene 12 caracteres fijos, por lo que si la cadena especificada es más corta, se rellenará con 0.
Actualmente, hay un error en el manual, donde se documenta como '``vendorid``' cuando debería ser '``vendor``'

Lo que probablemente desee es esto:
```c
VBoxManage modifyvm test-VM --paravirtdebug "enabled=1,vendor=AuthenticAMD"
```

Aunque lo anterior es sintácticamente correcto, no tiene sentido por qué querría especificar "``AuthenticAMD``" como el proveedor del hipervisor. No lo es, por lo que es "``VBoxVBoxVBox``" (que es el valor predeterminado) o para que se ejecute la depuración paravirtualizada de [[Hyper-V]], debemos simular ser "``Microsoft Hv``", lo que se hace automáticamente cuando configura "``enabled=1``". No es necesario que vuelvas a especificar manualmente el ``ID`` del proveedor a menos que quieras anularlo por alguna razón extraña...

Recuerde cambiar los valores de las paginas de hipervisores en el caso de hacer ``RE`` para evitar mecanismos de [[Anti_VM]].