[SetThreadAffinityMask](https://learn.microsoft.com/es-es/windows/win32/api/winbase/nf-winbase-setthreadaffinitymask)

Establece una máscara de afinidad de procesador para el subproceso especificado.

```c
DWORD_PTR SetThreadAffinityMask(
  [in] HANDLE    hThread,
  [in] DWORD_PTR dwThreadAffinityMask
);
```

## Parámetros

`[in] hThread`

Identificador del subproceso cuya máscara de afinidad se va a establecer.

Este identificador debe tener el derecho de acceso **THREAD_SET_INFORMATION** o **THREAD_SET_LIMITED_INFORMATION** y el derecho de acceso **THREAD_QUERY_INFORMATION** o **THREAD_QUERY_LIMITED_INFORMATION** . Para obtener más información, consulte [Derechos de acceso y seguridad de subprocesos](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/thread-security-and-access-rights).

**Windows Server 2003 y Windows XP:** El identificador debe tener los derechos de acceso **THREAD_SET_INFORMATION** y **THREAD_QUERY_INFORMATION** .

`[in] dwThreadAffinityMask`

Máscara de afinidad para el subproceso.

En un sistema con más de 64 procesadores, la máscara de afinidad debe especificar procesadores en el [grupo de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups) actual del subproceso.

## Valor devuelto

Si la función se ejecuta correctamente, el valor devuelto es la máscara de afinidad anterior del subproceso.

Si la función no se realiza correctamente, el valor devuelto es cero. Para obtener información de error extendida, llame a [GetLastError](https://learn.microsoft.com/es-es/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror).

Si la máscara de afinidad de subproceso solicita un procesador que no está seleccionado para la máscara de afinidad de proceso, se **ERROR_INVALID_PARAMETER** el último código de error.

## Comentarios

Una máscara de afinidad de subproceso es un vector de bits en el que cada bit representa un procesador lógico en el que se permite ejecutar un subproceso. Una máscara de afinidad de subproceso debe ser un subconjunto de la máscara de afinidad de proceso para el proceso contenedor de un subproceso. Un subproceso solo se puede ejecutar en los procesadores en los que se puede ejecutar su proceso. Por lo tanto, la máscara de afinidad de subproceso no puede especificar un bit para un procesador cuando la máscara de afinidad de proceso especifica un 0 bits para ese procesador.

Establecer una máscara de afinidad para un proceso o subproceso puede dar lugar a que los subprocesos reciban menos tiempo de procesador, ya que el sistema está restringido a ejecutar los subprocesos en determinados procesadores. En la mayoría de los casos, es mejor permitir que el sistema seleccione un procesador disponible.

Si la nueva máscara de afinidad de subproceso no especifica el procesador que está ejecutando actualmente el subproceso, el subproceso se vuelve a programar en uno de los procesadores permitidos.

A partir de Windows 11 y Windows Server 2022, en un sistema con más de 64 procesadores, afinidades de procesos y subprocesos abarcan todos los procesadores del sistema, en todos los [grupos de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups), de forma predeterminada. _DwThreadAffinityMask_ debe especificar procesadores en el grupo principal actual del subproceso.

## Requisitos

Expandir tabla

|Requisito|Value|
|---|---|
|**Cliente mínimo compatible**|Windows XP [aplicaciones de escritorio \| aplicaciones para UWP]|
|**Servidor mínimo compatible**|Windows Server 2003 [aplicaciones de escritorio \| aplicaciones para UWP]|
|**Plataforma de destino**|Windows|
|**Encabezado**|winbase.h (incluya Windows.h)|
|**Library**|Kernel32.lib|
|**Archivo DLL**|Kernel32.dll|

## Vea también

[GetProcessAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-getprocessaffinitymask)

[Varios procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/multiple-processors)

[OpenThread](https://learn.microsoft.com/es-es/windows/desktop/api/processthreadsapi/nf-processthreadsapi-openthread)

[Funciones de proceso y subproceso](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/process-and-thread-functions)

[Grupos de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups)

[SetProcessAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-setprocessaffinitymask)

[SetThreadIdealProcessor](https://learn.microsoft.com/es-es/windows/desktop/api/processthreadsapi/nf-processthreadsapi-setthreadidealprocessor) -> [[SetThreadIdealProcessor - Cambiar afinidad ideal para el hilo en los nucleos]]

[Subprocesos](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/multiple-threads)