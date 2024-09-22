https://www.felixcloutier.com/x86/mwait
# MWAIT — Monitor Wait

| Opcode   | Instruction | Op/En | 64-Bit Mode | Compat/Leg Mode | Description                                                                                                                                                 |
| -------- | ----------- | ----- | ----------- | --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0F 01 C9 | [[MWAIT]]   | ZO    | Valid       | Valid           | A hint that allows the processor to stop instruction execution and enter an implementation-dependent optimized state until occurrence of a class of events. |

## Instruction Operand Encoding [¶](https://www.felixcloutier.com/x86/mwait#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Descripción [¶](https://www.felixcloutier.com/x86/mwait#description)
La instrucción [[MWAIT]] proporciona sugerencias para permitir que el procesador ingrese a un estado optimizado dependiente de la implementación. Hay dos usos principales: monitor de rango de direcciones y administración avanzada de energía. Ambos usos de [[MWAIT]] requieren el uso de la instrucción [[MONITOR]].

[[CPUID(1)]]:ECX.[[MONITOR]][bit 3] indica la disponibilidad de [[MONITOR]] y [[MWAIT]] en el procesador. Cuando se configura, [[MWAIT]] se puede ejecutar solo en el nivel de [[ring-0]] (el uso en cualquier otro nivel de privilegio da como resultado una excepción de código de operación no válido). El sistema operativo o el ``BIOS`` del sistema pueden deshabilitar esta instrucción mediante el uso de ``IA32_MISC_ENABLE`` [[MSR]]; Al deshabilitar [[MWAIT]] se borra el indicador de función [[CPUID]] y se genera una excepción de código de operación no válido durante la ejecución.

El funcionamiento de esta instrucción es el mismo en los modos que no son de ``64 bits`` y en el modo de ``64 bits``.

``ECX`` especifica extensiones opcionales para la instrucción [[MWAIT]]. ``EAX`` puede contener sugerencias como el estado optimizado preferido al que debe ingresar el procesador. Los primeros procesadores que implementaron [[MWAIT]] solo admitían el valor cero para ``EAX`` y ``ECX``. Los procesadores posteriores permitieron configurar ``ECX``[0] para habilitar interrupciones enmascaradas como eventos de interrupción para [[MWAIT]] (consulte a continuación). El software puede usar la instrucción [[CPUID]] para determinar las extensiones y sugerencias admitidas por el procesador.


## [[MWAIT]] para monitoreo de rango de direcciones [¶](https://www.felixcloutier.com/x86/mwait#mwait-for-address-range-monitoring)
Para el monitoreo de rango de direcciones, la instrucción [[MWAIT]] opera con la instrucción [[MONITOR]]. Las dos instrucciones permiten la definición de una dirección en la que esperar ([[MONITOR]]) y una operación optimizada dependiente de la implementación que se inicia en la dirección de espera ([[MWAIT]]). La ejecución de [[MWAIT]] es una indicación para el procesador de que puede ingresar a un estado optimizado dependiente de la implementación mientras espera un evento o una operación de almacenamiento en el rango de direcciones armado por [[MONITOR]].

Los siguientes eventos hacen que el procesador salga del estado optimizado dependiente de la implementación: un almacenamiento en el rango de direcciones armado por la instrucción [[MONITOR]], una NMI o SMI, una excepción de depuración, una excepción de verificación de máquina, la señal BINIT#, la señal INIT# y la señal RESET#. Otros eventos dependientes de la implementación también pueden hacer que el procesador salga del estado optimizado dependiente de la implementación.

Además, una interrupción([[INT]]) externa hace que el procesador salga del estado optimizado dependiente de la implementación (1) si la interrupción se entregaría al software (por ejemplo, como sería si se hubiera ejecutado HLT en lugar de [[MWAIT]]); o (2) si ECX[0] = 1. El software puede ejecutar [[MWAIT]] con ECX[0] = 1 solo si [[CPUID(5)]]:ECX[bit 1] = 1. (Las condiciones específicas de la implementación pueden dar como resultado una interrupción que haga que el procesador salga del estado optimizado dependiente de la implementación incluso si las interrupciones están enmascaradas y ECX[0] = 0).

Después de salir del estado optimizado dependiente de la implementación, el control pasa a la instrucción que sigue a la instrucción [[MWAIT]]. Una interrupción pendiente que no esté enmascarada (incluida una NMI o una SMI) puede entregarse antes de la ejecución de esa instrucción. A diferencia de la instrucción HLT, la instrucción [[MWAIT]] no admite un reinicio en la instrucción [[MWAIT]] después del manejo de una SMI.

Si la instrucción [[MONITOR]] anterior no armó correctamente un rango de direcciones o si la instrucción [[MONITOR]] no se ejecutó antes de ejecutar [[MWAIT]], entonces el procesador no ingresará al estado optimizado según la implementación. La ejecución se reanudará en la instrucción posterior a [[MWAIT]].

## [[MWAIT]] para administración de energía [¶](https://www.felixcloutier.com/x86/mwait#mwait-for-power-management)
[[MWAIT]] acepta una sugerencia y una extensión opcional para el procesador que le permite ingresar a un estado C de destino específico mientras espera un evento o una operación de almacenamiento en el rango de direcciones armado por [[MONITOR]]. La compatibilidad con extensiones [[MWAIT]] para administración de energía se indica mediante [[CPUID(5)]]:ECX[bit 0] que informa 1.

``EAX`` y ``ECX`` se utilizan para comunicar la información adicional a la instrucción [[MWAIT]], como el tipo de estado optimizado al que debe ingresar el procesador. ``ECX`` especifica extensiones opcionales para la instrucción [[MWAIT]]. ``EAX`` puede contener sugerencias como el estado optimizado preferido al que debe ingresar el procesador. Las condiciones específicas de la implementación pueden hacer que un procesador ignore la sugerencia e ingrese a un estado optimizado diferente. Las implementaciones futuras del procesador pueden implementar varios estados de "espera" optimizados y seleccionarán entre esos estados en función del argumento de la sugerencia.

[Tabla 4-10](https://www.felixcloutier.com/x86/mwait#tbl-4-10) describe el significado de los registros ``ECX`` y ``EAX`` para las extensiones `[[MWAIT]]`.

| Bits  | Descripción                                                                                                                                                                                          |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0     | Tratar las interrupciones como eventos de interrupción incluso si están enmascaradas (p. ej., incluso si [[flags-de-la-cpu\|EFLAGS]].IF=0). Se puede configurar solo si [[CPUID(5)]]:ECX[bit 1] = 1. |
| 31: 1 | Reservado                                                                                                                                                                                            |

[Tabla 4-10](https://www.felixcloutier.com/x86/mwait#tbl-4-10). Registro de extensión [[MWAIT]] (``ECX``)

| Bits  | Descripción                                                                                                                                                                                                                                             |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 3:0   | Subestado C dentro de un estado C, indicado por los bits [7:4]                                                                                                                                                                                          |
| 7:4   | Estado C de destino* El valor 0 significa [[C1]]; 1 significa [[C2]] y así sucesivamente El valor 01111B significa [[C0]] Nota: Los estados C de destino para las extensiones [[MWAIT]] son estados C específicos del procesador, no estados C [[ACPI]] |
| 31: 8 | Reservado                                                                                                                                                                                                                                               |

[Tabla 4-11](https://www.felixcloutier.com/x86/mwait#tbl-4-11). Registro de sugerencias [[MWAIT]] (``EAX``)

Tenga en cuenta que si se utiliza [[MWAIT]] para ingresar a cualquiera de los estados C que son numéricamente superiores a [[C1]], un almacenamiento en el rango de direcciones armado por la instrucción [[MONITOR]] hará que el procesador salga de [[MWAIT]] solo si el almacenamiento fue originado por otros agentes del procesador. Un almacenamiento de un agente que no sea del procesador podría no hacer que el procesador salga de MWAIT en tales casos.

Para obtener detalles adicionales sobre las extensiones [[MWAIT]], consulte el ``Capítulo 15, “Gestión térmica y de energía” del Manual del desarrollador de software de arquitecturas Intel® 64 e IA-32, Volumen 3A``.

## Example [¶](https://www.felixcloutier.com/x86/mwait#example)
[[MONITOR]]/[[MWAIT]] instruction pair must be coded in the same loop because execution of the [[MWAIT]] instruction will trigger the monitor hardware. It is not a proper usage to execute [[MONITOR]] once and then execute [[MWAIT]] in a loop. Setting up [[MONITOR]] without executing [[MWAIT]] has no adverse effects.

Typically the MONITOR/MWAIT pair is used in a sequence, such as:

EAX = Logical Address(Trigger)

ECX = 0 (*Hints *)

EDX = 0 (* Hints *)

IF ( !trigger_store_happened) {

MONITOR EAX, ECX, EDX

IF ( !trigger_store_happened ) {

MWAIT EAX, ECX

}

}

The above code sequence makes sure that a triggering store does not happen between the first check of the trigger and the execution of the monitor instruction. Without the second check that triggering store would go un-noticed. Typical usage of MONITOR and MWAIT would have the above code sequence within a loop.

## Numeric Exceptions [¶](https://www.felixcloutier.com/x86/mwait#numeric-exceptions)

None.

## Protected Mode Exceptions [¶](https://www.felixcloutier.com/x86/mwait#protected-mode-exceptions)

|   |   |
|---|---|
|#GP(0)|If ECX[31:1] ≠ 0.|
|If ECX[0] = 1 and CPUID.05H:ECX[bit 1] = 0.|
|#UD|If CPUID.01H:ECX.MONITOR[bit 3] = 0.|
|If current privilege level is not 0.|

## Real Address Mode Exceptions [¶](https://www.felixcloutier.com/x86/mwait#real-address-mode-exceptions)

|   |   |
|---|---|
|#GP|If ECX[31:1] ≠ 0.|
|If ECX[0] = 1 and CPUID.05H:ECX[bit 1] = 0.|
|#UD|If CPUID.01H:ECX.MONITOR[bit 3] = 0.|

## Virtual 8086 Mode Exceptions [¶](https://www.felixcloutier.com/x86/mwait#virtual-8086-mode-exceptions)

|   |   |
|---|---|
|#UD|The MWAIT instruction is not recognized in virtual-8086 mode (even if CPUID.01H:ECX.MONITOR[bit 3] = 1).|

## Compatibility Mode Exceptions [¶](https://www.felixcloutier.com/x86/mwait#compatibility-mode-exceptions)

Same exceptions as in protected mode.

## 64-Bit Mode Exceptions [¶](https://www.felixcloutier.com/x86/mwait#64-bit-mode-exceptions)

|   |   |
|---|---|
|#GP(0)|If RCX[63:1] ≠ 0.|
|If RCX[0] = 1 and CPUID.05H:ECX[bit 1] = 0.|
|#UD|If the current privilege level is not 0.|
|If CPUID.01H:ECX.MONITOR[bit 3] = 0.|