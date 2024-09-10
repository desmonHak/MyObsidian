https://www.felixcloutier.com/x86/rdmsr

# RDMSR — Read From Model Specific Register (Leer desde el registro específico del modelo)

**Opcode1**

| Instruction | Op/En | 64-Bit Mode | Compat/Leg Mode | Description |                                                       |
| ----------- | ----- | ----------- | --------------- | ----------- | ----------------------------------------------------- |
| ``0F 32``   |       |             | Valid           | Valid       | Leer [[MSR]] especificado por ``ECX`` en ``EDX:EAX``. |
1. Consulte la sección Compatibilidad de la arquitectura IA-32 a continuación..

## Codificación de operandos de instrucciones [¶](https://www.felixcloutier.com/x86/rdmsr#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/rdmsr#description)

Lee el contenido de un registro específico del modelo ([[MSR]]) de ``64 bits`` especificado en el registro ``ECX`` en los registros ``EDX:EAX``. (En los procesadores que admiten la arquitectura ``Intel 64``, se ignoran los ``32 bits`` de orden superior de ``RCX``). El registro ``EDX`` se carga con los ``32 bits`` de orden superior del ``MSR`` y el registro ``EAX`` se carga con los ``32 bits`` de orden inferior. (En los procesadores que admiten la arquitectura ``Intel 64``, se borran los ``32 bits`` de orden superior de cada uno de ``RAX`` y ``RDX``). Si se implementan menos de ``64 bits`` en el ``MSR`` que se está leyendo, los valores devueltos a ``EDX:EAX`` en las ubicaciones de bits no implementadas no están definidos.

Esta instrucción debe ejecutarse en el nivel de privilegio ``ring 0`` o en el [[modo-real]] de direccionamiento; de lo contrario, se generará una excepción de protección general ``#GP(0)``. La especificación de una dirección ``MSR`` reservada o no implementada en ``ECX`` también provocará una excepción de protección general.

Los ``MSR`` controlan las funciones de capacidad de prueba, seguimiento de ejecución, supervisión del rendimiento y errores de comprobación de la máquina. El capítulo 2, ``Model-Specific Registers (MSRs)``(“``Registros específicos del modelo (MSR)``”) del ``Intel® 64 and IA-32 Architectures Software Developer’s Manual``, ``Volume 4``, enumera todos los ``MSR`` que se pueden leer con esta instrucción y sus direcciones. Tenga en cuenta que cada familia de procesadores tiene su propio conjunto de ``MSR``.

La instrucción ``CPUID`` se debe utilizar para determinar si se admiten los ``MSR`` (``CPUID.01H:EDX[5]`` = 1) antes de utilizar esta instrucción.

## Compatibilidad de la arquitectura IA-32 [¶](https://www.felixcloutier.com/x86/rdmsr#ia-32-architecture-compatibility)

Los ``MSR`` y la capacidad de leerlos con la instrucción ``RDMSR`` se introdujeron en la arquitectura [[IA-32]] con el procesador ``Pentium``. La ejecución de esta instrucción por parte de un procesador [[IA-32]] antes que por parte del procesador ``Pentium`` da como resultado una excepción de código de operación no válido ``#UD``.

Consulte ``Changes to Instruction Behavior in VMX Non-Root Operation``(“``Cambios en el comportamiento de las instrucciones en la operación no raíz de VMX``”) en el ``Capítulo 26`` del ``Intel® 64 and IA-32 Architectures Software Developer’s Manual``, ``Volumen 3C``, para obtener más información sobre el comportamiento de esta instrucción en la operación no raíz de [[VMX]].

## Operation [¶](https://www.felixcloutier.com/x86/rdmsr#operation)

``EDX:EAX := MSR[ECX];``

## Flags Affected [¶](https://www.felixcloutier.com/x86/rdmsr#flags-affected)

Ninguna.

## Excepciones del modo protegido [¶](https://www.felixcloutier.com/x86/rdmsr#protected-mode-exceptions)

|            |                                                                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| ``#GP(0)`` | Si el nivel de privilegio actual no es ``ring 0``.<br>Si el valor en ``ECX`` especifica una dirección [[MSR]] reservada o no implementada. |
| ``#UD``    | Si se utiliza el prefijo [[LOCK]].                                                                                                         |

## Excepciones del modo de dirección real [¶](https://www.felixcloutier.com/x86/rdmsr#real-address-mode-exceptions)

|         |                                                                                      |
| ------- | ------------------------------------------------------------------------------------ |
| ``#GP`` | Si el valor en ``ECX ``especifica una dirección [[MSR]] reservada o no implementada. |
| ``#UD`` | Si se utiliza el prefijo [[LOCK]].                                                   |

## Excepciones del modo Virtual-8086 [¶](https://www.felixcloutier.com/x86/rdmsr#virtual-8086-mode-exceptions)

|            |                                                                  |
| ---------- | ---------------------------------------------------------------- |
| ``#GP(0)`` | La instrucción [[RDMSR]] no se reconoce en el modo virtual 8086. |


## Excepciones del modo de compatibilidad [¶](https://www.felixcloutier.com/x86/rdmsr#compatibility-mode-exceptions)

Las mismas excepciones que en el modo protegido.

## Excepciones del modo de 64 bits [¶](https://www.felixcloutier.com/x86/rdmsr#64-bit-mode-exceptions)

Las mismas excepciones que en el modo protegido.