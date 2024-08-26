https://www.felixcloutier.com/x86/arpl
## Ajustar el campo RPL del selector de segmento

| Opcode | Instruction     | Op/En | 64-bit Mode | Compat/Leg Mode | Description                                   |
| ------ | --------------- | ----- | ----------- | --------------- | --------------------------------------------- |
| 63 /r  | ARPL r/m16, r16 | MR    | N. E.       | Valid           | Ajuste RPL de r/m16 a no menos de RPL de r16. |

| ARPL – Ajustar el campo RPL del selector | Encoding                 |
| ---------------------------------------- | ------------------------ |
| from register                            | 0110 0011 : 11 reg1 reg2 |
| from memory                              | 0110 0011 : mod reg r/m  |
## Instruction Operand Encoding [¶](https://www.felixcloutier.com/x86/arpl#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|MR|ModRM:r/m (w)|ModRM:reg (r)|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/arpl#description)

Compara los campos RPL de dos selectores de segmento. El primer operando (operando destino) contiene un selector de segmento y el segundo operando (operando origen) contiene el otro. (El campo RPL se encuentra en los bits 0 y 1 de cada operando.) Si el campo RPL del operando destino es menor que el campo RPL del operando origen, se activa el indicador [[flags-de-la-cpu|ZF]] y se incrementa el campo RPL del operando destino para que coincida con el del operando origen. En caso contrario, se borra el indicador [[flags-de-la-cpu|ZF]] y no se realiza ningún cambio en el operando destino. (El operando destino puede ser un registro de palabras o una posición de memoria; el operando fuente debe ser un registro de palabras).

La instrucción ARPL está pensada para ser utilizada por procedimientos del sistema operativo (aunque también puede ser utilizada por aplicaciones). Generalmente se utiliza para ajustar el RPL de un [[GDT|selector de segmento]] que ha sido pasado al sistema operativo por un programa de aplicación para que coincida con el nivel de privilegio del programa de aplicación. Aquí el selector de segmento pasado al sistema operativo se coloca en el operando destino y el selector de segmento para el segmento de código del programa de aplicación se coloca en el operando fuente. (El campo RPL en el operando fuente representa el nivel de privilegio del programa de aplicación). La ejecución de la instrucción ARPL garantiza entonces que el RPL del selector de segmento recibido por el sistema operativo no es inferior (no tiene un privilegio superior) al nivel de privilegio del programa de aplicación (el selector de segmento para el segmento de código del programa de aplicación puede leerse de la pila tras una llamada a procedimiento).

Esta instrucción se ejecuta como se describe en el modo de compatibilidad y en el modo heredado. No es codificable en el [[modo-largo|modo de 64 bits]].

Consulte «``Comprobación de los privilegios de acceso del llamante``» en el Capítulo 3, «Gestión de memoria en [[modo-protegido]]», del ``Manual del desarrollador de software de arquitecturas Intel® 64 e IA-32``, ``Volumen 3A``, para obtener más información sobre el uso de esta instrucción.

## Operación [¶](https://www.felixcloutier.com/x86/arpl#operation)
```c
IF 64-BIT MODE
    THEN
        See MOVSXD;
    ELSE
        IF DEST[RPL] < SRC[RPL]
            THEN
                ZF := 1;
                DEST[RPL] := SRC[RPL];
            ELSE
                ZF := 0;
        FI;
FI;
```
```c
if ((dst & 3) < (src & 3)) {
   dst = (dst & 0xFFFC) | (src & 3);
   eflags.zf = 1;
} else eflags.zf = 0;
```

## Banderas afectadas [¶](https://www.felixcloutier.com/x86/arpl#flags-affected)

El indicador [[flags-de-la-cpu|ZF]] se pone a 1 si el campo RPL del operando destino es menor que el del operando origen; en caso contrario, se pone a 0.
## Excepciones del modo protegido [¶](https://www.felixcloutier.com/x86/arpl#protected-mode-exceptions)

|                     |                                                                                                                                                                                                                                                                                                  |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ``#GP(0)``          | Si el destino se encuentra en un segmento no grabable.<br>Si la dirección efectiva de un operando de memoria está fuera del límite del segmento ``CS, DS, ES, FS o GS``.<br>Si el registro ``DS, ES, FS o GS`` se utiliza para acceder a la memoria y contiene un selector de segmento ``NULL``. |
| ``#SS(0)``          | Si la dirección efectiva de un operando de memoria está fuera del límite de segmento ``SS``.                                                                                                                                                                                                     |
| ``#PF(fault-code)`` | Si se produce un fallo de página.                                                                                                                                                                                                                                                                |
| ``#AC(0)``          | Si la comprobación de alineación está activada y se hace una referencia a memoria no alineada mientras el nivel de privilegio actual es 3.                                                                                                                                                       |
| ``#UD``             | Si se utiliza el prefijo ``LOCK``                                                                                                                                                                                                                                                                |

## Excepciones de modo de dirección real [¶](https://www.felixcloutier.com/x86/arpl#real-address-mode-exceptions)

|         |                                                                                                     |
| ------- | --------------------------------------------------------------------------------------------------- |
| ``#UD`` | La instrucción ARPL no se reconoce en modo de dirección real.<br>Si se utiliza el prefijo ``LOCK``. |

## Excepciones del modo Virtual-8086 [¶](https://www.felixcloutier.com/x86/arpl#virtual-8086-mode-exceptions)

|         |                                                                                                |
| ------- | ---------------------------------------------------------------------------------------------- |
| ``#UD`` | La instrucción ARPL no se reconoce en modo virtual-8086.<br>Si se utiliza el prefijo ``LOCK``. |

## Excepciones del modo compatibilidad  [¶](https://www.felixcloutier.com/x86/arpl#compatibility-mode-exceptions)

Las mismas excepciones que en modo protegido.