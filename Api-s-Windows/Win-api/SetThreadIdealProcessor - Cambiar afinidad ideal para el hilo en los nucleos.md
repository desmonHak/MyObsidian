[SetThreadIdealProcessor](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreadidealprocessor)

Establece un procesador preferido para un subproceso. El sistema programa subprocesos en sus procesadores preferidos siempre que sea posible.

En un sistema con más de 64 procesadores, esta función establece el procesador preferido en un procesador lógico del grupo de [procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups) al que se asigna el subproceso que realiza la llamada. Use la función [SetThreadIdealProcessorEx](https://learn.microsoft.com/es-es/windows/desktop/api/processthreadsapi/nf-processthreadsapi-setthreadidealprocessorex) para especificar un grupo de procesadores y un procesador preferido.

```c
DWORD SetThreadIdealProcessor(
  [in] HANDLE hThread,
  [in] DWORD  dwIdealProcessor
);
```

## Parámetros

`[in] hThread`

Identificador del subproceso cuyo procesador preferido se va a establecer. El identificador debe tener el derecho de acceso THREAD_SET_INFORMATION. Para obtener más información, consulte [Derechos de acceso y seguridad de subprocesos](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/thread-security-and-access-rights).

`[in] dwIdealProcessor`

Número del procesador preferido para el subproceso. Este valor es de base cero. Si este parámetro es MAXIMUM_PROCESSORS, la función devuelve el procesador ideal actual sin cambiarlo.

## Valor devuelto
Si la función se realiza correctamente, el valor devuelto es el procesador preferido anterior.
Si se produce un error en la función, el valor devuelto es (DWORD) – 1. Para obtener información de error extendida, llame a [GetLastError](https://learn.microsoft.com/es-es/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror).

## Comentarios

Puede usar la función [GetSystemInfo](https://learn.microsoft.com/es-es/windows/desktop/api/sysinfoapi/nf-sysinfoapi-getsysteminfo) para determinar el número de procesadores del equipo. También puede usar la función [GetProcessAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-getprocessaffinitymask) para comprobar los procesadores en los que se permite ejecutar el subproceso. Tenga en cuenta que **GetProcessAffinityMask** devuelve una máscara de bits, mientras que **SetThreadIdealProcessor** usa un valor entero para representar el procesador.

A partir de Windows 11 y Windows Server 2022, en un sistema con más de 64 procesadores, las afinidades de procesos y subprocesos abarcan todos los procesadores del sistema, en todos los [grupos de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups), de forma predeterminada. La función **SetThreadIdealProcessor** establece el procesador preferido en un procesador lógico del grupo principal del subproceso.

Para compilar una aplicación que usa esta función, defina _WIN32_WINNT como 0x0400 o posterior. Para obtener más información, vea [Usar los encabezados de Windows](https://learn.microsoft.com/es-es/windows/desktop/WinProg/using-the-windows-headers). ^53687a

**Windows 8.1** y **Windows Server 2012 R2**: esta función es compatible con las aplicaciones de la Tienda Windows en Windows 8.1, Windows Server 2012 R2 y versiones posteriores.

## Requisitos

|Requisito|Value|
|---|---|
|**Cliente mínimo compatible**|Windows XP [aplicaciones de escritorio \| aplicaciones para UWP]|
|**Servidor mínimo compatible**|Windows Server 2003 [aplicaciones de escritorio \| aplicaciones para UWP]|
|**Plataforma de destino**|Windows|
|**Encabezado**|processthreadsapi.h (incluya Windows.h)|
|**Library**|Kernel32.lib|
|**Archivo DLL**|Kernel32.dll|
## Vea también
[[GetThreadAffinityMask - Establecer afinidad de hilos]]
