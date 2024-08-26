[GetLogicalProcessorInformationEx](https://learn.microsoft.com/es-es/windows/win32/api/sysinfoapi/nf-sysinfoapi-getlogicalprocessorinformationex)

Recupera información sobre las relaciones de los procesadores lógicos y el hardware relacionado.

```c
BOOL GetLogicalProcessorInformationEx(
  [in]            LOGICAL_PROCESSOR_RELATIONSHIP           RelationshipType,
  [out, optional] PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX Buffer,
  [in, out]       PDWORD                                   ReturnedLength
);
```

## Parámetros

`[in] RelationshipType`

Tipo de relación que se va a recuperar. Este parámetro puede ser uno de los siguientes valores [de LOGICAL_PROCESSOR_RELATIONSHIP](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ne-winnt-logical_processor_relationship) .

|Valor|Significado|
|---|---|
|**RelationProcessorCore**<br><br>0|Recupera información sobre los procesadores lógicos que comparten un único núcleo de procesador.|
|**RelationNumaNode**<br><br>1|Recupera información sobre los procesadores lógicos que forman parte del mismo nodo NUMA.|
|**RelationCache**<br><br>2|Recupera información sobre los procesadores lógicos que comparten una memoria caché.|
|**RelationProcessorPackage**<br><br>3|Recupera información sobre los procesadores lógicos que comparten un paquete físico.|
|**RelationGroup**<br><br>4|Recupera información sobre los procesadores lógicos que comparten un grupo de procesadores.|
|**RelationProcessorDie**<br><br>5|Recupera información sobre los procesadores lógicos que comparten un procesador die.|
|**RelationNumaNodeEx**<br><br>6|Recupera información sobre los procesadores lógicos que forman parte del mismo nodo NUMA (con afinidad completa).|
|**RelationProcessorModule**<br><br>7|Recupera información sobre los procesadores lógicos que comparten un módulo de procesador.|
|**RelationAll**<br><br>0xffff|Recupera información sobre los procesadores lógicos para todos los tipos de relación (caché, nodo NUMA, núcleo del procesador, paquete físico, grupo de procesadores, diedo de procesador y módulo de procesador).|

`[out, optional] Buffer`

Puntero a un búfer que recibe una secuencia de estructuras [de SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX](https://learn.microsoft.com/es-es/windows/win32/api/winnt/ns-winnt-system_logical_processor_information_ex) de tamaño variable. Si se produce un error en la función, el contenido de este búfer no está definido.

`[in, out] ReturnedLength`

En la entrada, especifica la longitud del búfer al que apunta _buffer_, en bytes. Si el búfer es lo suficientemente grande como para contener todos los datos, esta función se realiza correctamente y _ReturnedLength_ se establece en el número de bytes devueltos. Si el búfer no es lo suficientemente grande como para contener todos los datos, se produce un error en la función, [GetLastError](https://learn.microsoft.com/es-es/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror) devuelve ERROR_INSUFFICIENT_BUFFER y _ReturnedLength_ se establece en la longitud del búfer necesaria para contener todos los datos. Si se produce un error en la función distinto de ERROR_INSUFFICIENT_BUFFER, el valor de _ReturnedLength_ no está definido.

## Valor devuelto

Si la función se ejecuta correctamente, el valor devuelto es TRUE y al menos una estructura [de SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX](https://learn.microsoft.com/es-es/windows/win32/api/winnt/ns-winnt-system_logical_processor_information_ex) se escribe en el búfer de salida.

Si se produce un error en la función, el valor devuelto es FALSE. Para obtener información de error extendida, llame a [GetLastError](https://learn.microsoft.com/es-es/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror).

## Comentarios

Si un proceso de 32 bits que se ejecuta en WOW64 llama a esta función en un sistema con más de 64 procesadores, algunas de las máscaras de afinidad de procesador devueltas por la función pueden ser incorrectas. Esto se debe a que el **DWORD** de alto orden de la estructura [KAFFINITY](https://learn.microsoft.com/es-es/windows-hardware/drivers/kernel/interrupt-affinity-and-priority) de 64 bits que representa todos los 64 procesadores se "plega" en una estructura **KAFFINITY** de 32 bits en el búfer del autor de la llamada. Como resultado, las máscaras de afinidad para los procesadores de 32 a 63 se representan incorrectamente como duplicados de las máscaras para los procesadores de 0 a 31. Además, las máscaras de afinidad para los procesadores de 32 a 63 se representan incorrectamente como duplicados de las máscaras para los procesadores de 0 a 31. Además, la suma de todos los valores **ActiveProcessorCount** y **MaximumProcessorCount** por grupo notificados en [PROCESSOR_GROUP_INFO](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-processor_group_info) estructuras puede excluir algunos procesadores lógicos activos.

Cuando se llama a esta función con un tipo de relación **RelationProcessorCore**, devuelve una estructura [PROCESSOR_RELATIONSHIP](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-processor_relationship) para cada núcleo de procesador activo de cada grupo de procesadores del sistema. Esto es por diseño, ya que un subproceso de 32 bits sin configurar puede ejecutarse en cualquier procesador lógico de un grupo determinado, incluidos los procesadores de 32 a 63. Un llamador de 32 bits puede usar el recuento total de **estructuras de PROCESSOR_RELATIONSHIP** para determinar el número real de núcleos de procesador activos en el sistema. Sin embargo, la afinidad de un subproceso de 32 bits no se puede establecer explícitamente en el procesador lógico 32 a 63 de ningún grupo de procesadores.

Para compilar una aplicación que use esta función, establezca _WIN32_WINNT >= 0x0601. Para obtener más información, vea [Uso de los encabezados de Windows](https://learn.microsoft.com/es-es/windows/desktop/WinProg/using-the-windows-headers).

### Comportamiento a partir de Windows Server 2022 (21H2, compilación 20348)

El comportamiento de esta y otras funciones NUMA se ha modificado para admitir mejor los sistemas con nodos que contienen más de 64 procesadores. Para obtener más información sobre este cambio, incluida la información sobre cómo habilitar el comportamiento anterior de esta API, consulte [Compatibilidad con NUMA](https://learn.microsoft.com/es-es/windows/win32/procthread/numa-support).

Las solicitudes de [RelationNumaNode](https://learn.microsoft.com/es-es/windows/win32/api/winnt/ne-winnt-logical_processor_relationship) devolverán [NUMA_NODE_RELATIONSHIP](https://learn.microsoft.com/es-es/windows/win32/api/winnt/ns-winnt-numa_node_relationship) estructuras que contengan solo la afinidad del nodo dentro del grupo principal. El valor [GroupCount](https://learn.microsoft.com/es-es/windows/win32/api/winnt/ns-winnt-numa_node_relationship) será 1 y el tamaño de la estructura es fijo.

Las solicitudes de **RelationNumaNodeEx** o **RelationAll** devolverán **estructuras NUMA_NODE_RELATIONSHIP** que contienen una matriz de afinidades para el nodo en todos los grupos. **GroupCount** informa del número de afinidades y el tamaño de la estructura es variable.

## Requisitos

Expandir tabla

|Requisito|Value|
|---|---|
|**Cliente mínimo compatible**|Windows 7 [aplicaciones de escritorio \| Aplicaciones para UWP]|
|**Servidor mínimo compatible**|Windows Server 2008 R2 [aplicaciones de escritorio \| Aplicaciones para UWP]|
|**Plataforma de destino**|Windows|
|**Encabezado**|sysinfoapi.h (incluya Windows.h)|
|**Library**|Kernel32.lib|
|**Archivo DLL**|Kernel32.dll|

## Vea también

[SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX](https://learn.microsoft.com/es-es/windows/win32/api/winnt/ns-winnt-system_logical_processor_information_ex)