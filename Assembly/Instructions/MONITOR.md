https://www.felixcloutier.com/x86/monitor

# MONITOR — Set Up Monitor Address

| Opcode       | Instruction | Op/En | 64-Bit Mode | Compat/Leg Mode | Description                                                                                                                                                                                                         |
| ------------ | ----------- | ----- | ----------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ``0F 01 C8`` | [[MONITOR]] | ZO    | Valid       | Valid           | Configura un rango de direcciones lineal que será monitoreado por hardware y activa el monitor. El rango de direcciones debe ser de tipo caché de memoria de escritura diferida. La`` dirección es DS``:RAX/EAX/AX. |

## Instruction Operand Encoding [¶](https://www.felixcloutier.com/x86/monitor#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/monitor#description)
La instrucción [[MONITOR]] activa el hardware de monitorización de direcciones utilizando una dirección especificada en EAX (el rango de direcciones que el hardware de monitorización comprueba para las operaciones de almacenamiento puede determinarse utilizando [[CPUID]]). Un almacenamiento en una dirección dentro del rango de direcciones especificado activa el hardware de monitorización. El estado del hardware de monitorización es utilizado por [[MWAIT]].

La dirección se especifica en ``RAX/EAX/AX`` y el tamaño se basa en el tamaño de dirección efectivo de la instrucción codificada. Por defecto, el segmento DS se utiliza para crear una dirección lineal que es monitorizada. Se pueden utilizar anulaciones de segmento.

También se utilizan ``ECX`` y ``EDX``. Comunican otra información a [[MONITOR]]. ECX especifica extensiones opcionales. ``EDX`` especifica sugerencias opcionales; no cambia el comportamiento arquitectónico de la instrucción. Para el procesador [[ADD#^c5b559|Pentium 4]] (familia 15, modelo 3), no se definen extensiones ni sugerencias. Las sugerencias no definidas en ``EDX`` son ignoradas por el procesador; las extensiones no definidas en ``ECX`` provocan un fallo de protección general.

El rango de direcciones debe utilizar memoria del tipo ``write-back``. Sólo la memoria de escritura hacia atrás activará correctamente el hardware de monitorización. En el Capítulo 9, «``Gestión de múltiples procesadores``'» del ``Manual del Desarrollador de Software de las Arquitecturas Intel® 64 e IA-32``, ``Volumen 3A``, se describe información adicional sobre la determinación del rango de direcciones a utilizar para evitar falsas activaciones.

La instrucción [[MONITOR]] se ordena como una operación de carga con respecto a otras transacciones de memoria. La instrucción está sujeta a la comprobación de permisos y fallos asociados a una carga de bytes. Al igual que una carga, [[MONITOR]] establece el ``bit A`` pero no el ``bit D`` en las tablas de páginas.

[[CPUID(1)]]:``ECX``.[[MONITOR]][``bit 3``] indica la disponibilidad de [[MONITOR]] y [[MWAIT]] en el procesador. Cuando está activado, [[MONITOR]] sólo puede ejecutarse en el nivel de privilegio 0 (su uso en cualquier otro nivel de privilegio provoca una excepción de código de operación no válido). El sistema operativo o la ``BIOS`` del sistema pueden deshabilitar esta instrucción utilizando el [[MSR]] ``IA32_MISC_ENABLE``; al deshabilitar [[MONITOR]] se borra el indicador de función [[CPUID]] y la ejecución genera una excepción de código de operación no válido.

El funcionamiento de la instrucción es el mismo en los modos que no son de ``64 bits`` y en el modo de 64 bits.

## Operation [¶](https://www.felixcloutier.com/x86/monitor#operation)
[[MONITOR]] configura un rango de direcciones para el hardware del monitor utilizando el contenido de ``EAX`` (``RAX`` en modo de ``64 bits``) como una dirección efectiva y pone el hardware del monitor en estado armado. Siempre use memoria del tipo de caché de escritura diferida. Un almacenamiento en el rango de direcciones especificado activará el hardware del monitor. El contenido de ``ECX`` y ``EDX`` se utiliza para comunicar otra información al hardware del monitor.

## [[Assembly/MODOS/modo-protegido]] Exceptions [¶](https://www.felixcloutier.com/x86/monitor#protected-mode-exceptions)

|                                                                                                     |                                                                         |
| --------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| GP(0)                                                                                               | If the value in EAX is outside the CS, DS, ES, FS, or GS segment limit. |
| If the DS, ES, FS, or GS register is used to access memory and it contains a NULL segment selector. |                                                                         |
| If ECX ≠ 0.                                                                                        |                                                                         |
| SS(0)                                                                                               | If the value in EAX is outside the SS segment limit.                    |
| PF(fault-code)                                                                                      | For a page fault.                                                       |
| UD                                                                                                  | if [[CPUID]].[[CPUID(1)\|0x01]]:``ECX``.[[MONITOR]][``bit 3``] = 0.     |
| If current privilege level is not 0.                                                                |                                                                         |

## [[Assembly/MODOS/modo-real]] Mode Exceptions [¶](https://www.felixcloutier.com/x86/monitor#real-address-mode-exceptions)

|              |                                                                                                                                                |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| GP           | If the CS, DS, ES, FS, or GS register is used to access memory and the value in EAX is outside of the effective address space from 0 to FFFFH. |
| If ECX ≠ 0. |                                                                                                                                                |
| SS           | If the SS register is used to access memory and the value in EAX is outside of the effective address space from 0 to FFFFH.                    |
| UD           | if [[CPUID]].[[CPUID(1)\|0x01]]:``ECX``.[[MONITOR]][``bit 3``] = 0.                                                                            |

## [[Assembly/MODOS/modo-virtual-8086]] Mode Exceptions [¶](https://www.felixcloutier.com/x86/monitor#virtual-8086-mode-exceptions)

|                                       |                                                                                                                                               |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| [UD](app://obsidian.md/index.html#UD) | The [[MONITOR]] instruction is not recognized in virtual-8086 mode (even if [[CPUID]].[[CPUID(1)\|0x01]]:``ECX``.[[MONITOR]][``bit 3``] = 1). |

## Compatibility Mode Exceptions [¶](https://www.felixcloutier.com/x86/monitor#compatibility-mode-exceptions)
Same exceptions as in protected mode.

## [[Assembly/MODOS/modo-largo]] Exceptions [¶](https://www.felixcloutier.com/x86/monitor#64-bit-mode-exceptions)

|                                      |                                                                                                       |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| GP(0)                                | If the linear address of the operand in the CS, DS, ES, FS, or GS segment is in a non-canonical form. |
| If RCX ≠ 0.                         |                                                                                                       |
| SS(0)                                | If the SS register is used to access memory and the value in EAX is in a non-canonical form.          |
| PF(fault-code)                       | For a page fault.                                                                                     |
| UD                                   | If the current privilege level is not 0.                                                              |
| If CPUID.01H:ECX.MONITOR[bit 3] = 0. |                                                                                                       |