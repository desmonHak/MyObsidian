# RDTSC — Leer el contador de marca de tiempo

| Opcode*   | Instruction | Op/En | 64-Bit Mode | Compat/Leg Mode | Description                                     |
| --------- | ----------- | ----- | ----------- | --------------- | ----------------------------------------------- |
| ``0F 31`` | [[RDTSC]]   | ZO    | Valid       | Valid           | Leer el contador de marca de tiempo en EDX:EAX. |

## Codificación de operandos de instrucciones [¶](https://www.felixcloutier.com/x86/rdtsc#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Descripción [¶](https://www.felixcloutier.com/x86/rdtsc#description)

Lee el valor actual del contador de marca de tiempo del procesador (un [[MSR]] de 64 bits) en los registros ``EDX:EAX``. El registro ``EDX`` se carga con los 32 bits de orden superior del [[MSR]] y el registro ``EAX`` se carga con los 32 bits de orden inferior. (En los procesadores que admiten la arquitectura Intel 64, se borran los 32 bits de orden superior de cada uno de ``RAX`` y ``RDX``).

El procesador incrementa de forma monótona el contador de marca de tiempo [[MSR]] en cada ciclo de reloj y lo restablece a 0 cada vez que se reinicia el procesador. Consulte “``Contador de marca de tiempo``” en el ``Capítulo 18 del Manual del desarrollador de software de las arquitecturas Intel® 64 e IA-32, Volumen 3B``, para obtener detalles específicos del comportamiento del contador de marca de tiempo.

El indicador de desactivación de marca de tiempo ([[TSD]]) en el registro [[CR4]] restringe el uso de la instrucción [[RDTSC]] de la siguiente manera. Cuando el indicador está borrado, la instrucción [[RDTSC]] se puede ejecutar en cualquier nivel de privilegio; Cuando se establece la bandera, la instrucción solo se puede ejecutar en el nivel de [[ring-0]].

El contador de marca de tiempo también se puede leer con la instrucción [[RDMSR]], cuando se ejecuta en el nivel de [[ring-0]].

La instrucción [[RDTSC]] no es una instrucción serializadora. No necesariamente espera hasta que se hayan ejecutado todas las instrucciones anteriores antes de leer el contador. De manera similar, las instrucciones posteriores pueden comenzar a ejecutarse antes de que se realice la operación de lectura. Los siguientes elementos pueden guiar al software que busca ordenar las ejecuciones de [[RDTSC]]:

- Si el software requiere que [[RDTSC]] se ejecute solo después de que se hayan ejecutado todas las instrucciones anteriores y todas las cargas anteriores sean visibles globalmente,1 puede ejecutar [[LFENCE]] inmediatamente antes de [[RDTSC]].
- Si el software requiere que [[RDTSC]] se ejecute solo después de que se hayan ejecutado todas las instrucciones anteriores y todas las cargas y almacenamientos anteriores sean visibles globalmente, puede ejecutar la secuencia [[MFENCE]];[[LFENCE]] inmediatamente antes de [[RDTSC]].
- Si el software requiere que [[RDTSC]] se ejecute antes de la ejecución de cualquier instrucción posterior (incluido cualquier acceso a la memoria), puede ejecutar la secuencia [[LFENCE]] inmediatamente después de [[RDTSC]].

Esta instrucción fue introducida por el procesador Pentium.

Consulte “``Cambios en el comportamiento de las instrucciones en operaciones no raíz de VMX``” en el ``Capítulo 26 del Manual del desarrollador de software de arquitecturas Intel® 64 e IA-32, Volumen 3C``, para obtener más información sobre el comportamiento de esta instrucción en operaciones no raíz de [[VMX]].

> 1. Se considera que una carga se vuelve visible globalmente cuando se determina el valor que se va a cargar.
## Operación [¶](https://www.felixcloutier.com/x86/rdtsc#operation)
```c
IF (CR4.TSD = 0) or (CPL = 0) or (CR0.PE = 0)
    THEN EDX:EAX := TimeStampCounter;
    ELSE (* CR4.TSD = 1 and (CPL = 1, 2, or 3) and CR0.PE = 1 *)
        #GP(0);
FI;
```

## Banderas afectadas [¶](https://www.felixcloutier.com/x86/rdtsc#flags-affected)
Ninguna.

## Excepciones del modo protegido [¶](https://www.felixcloutier.com/x86/rdtsc#protected-mode-exceptions)

|       |                                                                                              |
| ----- | -------------------------------------------------------------------------------------------- |
| GP(0) | Si el indicador [[TSD]] en el registro [[CR4]] está configurado y el [[CPL]] es mayor que 0. |
| UD    | Si se utiliza el prefijo [[LOCK]].                                                           |

## Excepciones del modo de dirección real [¶](https://www.felixcloutier.com/x86/rdtsc#real-address-mode-exceptions)

|     |                                    |
| --- | ---------------------------------- |
| UD  | Si se utiliza el prefijo [[LOCK]]. |

## Excepciones del modo virtual-8086 [¶](https://www.felixcloutier.com/x86/rdtsc#virtual-8086-mode-exceptions)

|       |                                                                  |
| ----- | ---------------------------------------------------------------- |
| GP(0) | Si el indicador [[TSD]] en el registro [[CR4]] está establecido. |
| UD    | Si se utiliza el prefijo [[LOCK]].                               |

## Excepciones del modo de compatibilidad [¶](https://www.felixcloutier.com/x86/rdtsc#compatibility-mode-exceptions)

Las mismas excepciones que en el modo protegido.

## Excepciones del modo de 64 bits [¶](https://www.felixcloutier.com/x86/rdtsc#64-bit-mode-exceptions)

Las mismas excepciones que en el modo protegido.