
[SetProcessAffinityMask]https://learn.microsoft.com/es-es/windows/win32/api/winbase/nf-winbase-setprocessaffinitymask)

Establece una máscara de afinidad de procesador para los subprocesos del proceso especificado.

```c
BOOL SetProcessAffinityMask(
  [in] HANDLE    hProcess,
  [in] DWORD_PTR dwProcessAffinityMask
);
```

## Parámetros

`[in] hProcess`

Identificador del proceso cuya máscara de afinidad se va a establecer. Este identificador debe tener el derecho de acceso **PROCESS_SET_INFORMATION** . Para obtener más información, consulte [Derechos de acceso y seguridad de procesos](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/process-security-and-access-rights).

`[in] dwProcessAffinityMask`

Máscara de afinidad para los subprocesos del proceso.

En un sistema con más de 64 procesadores, la máscara de afinidad debe especificar procesadores en un único [grupo de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups).

## Valor devuelto

Si la función se realiza correctamente, el valor devuelto es distinto de cero.

Si la función no se realiza correctamente, el valor devuelto es cero. Para obtener información de error extendida, llame a [GetLastError](https://learn.microsoft.com/es-es/windows/desktop/api/errhandlingapi/nf-errhandlingapi-getlasterror).

Si la máscara de afinidad de proceso solicita un procesador que no está configurado en el sistema, se **ERROR_INVALID_PARAMETER** el último código de error.

En un sistema con más de 64 procesadores, si el proceso de llamada contiene subprocesos en más de un grupo de procesadores, el último código de error se **ERROR_INVALID_PARAMETER**.

## Comentarios

Una máscara de afinidad de proceso es un vector de bits en el que cada bit representa un procesador lógico en el que se permiten ejecutar los subprocesos del proceso. El valor de la máscara de afinidad de proceso debe ser un subconjunto de los valores de máscara de afinidad del sistema obtenidos por la función [GetProcessAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-getprocessaffinitymask) . Un proceso solo puede ejecutarse en los procesadores configurados en un sistema. Por lo tanto, la máscara de afinidad de proceso no puede especificar un bit para un procesador cuando la máscara de afinidad del sistema especifica un 0 bits para ese procesador.

La afinidad de proceso la hereda cualquier proceso secundario o proceso local recién creado.

No llame a **SetProcessAffinityMask** en un archivo DLL al que puedan llamar los procesos distintos de los suyos.

En un sistema con más de 64 procesadores, la función **SetProcessAffinityMask** se puede usar para establecer la máscara de afinidad de proceso solo para procesos con subprocesos en un único [grupo de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups). Use la función [SetThreadAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-setthreadaffinitymask) para establecer la máscara de afinidad para subprocesos individuales en varios grupos. Esto cambia eficazmente la asignación de grupos del proceso.

A partir de Windows 11 y Windows Server 2022, en un sistema con más de 64 procesadores, afinidades de procesos y subprocesos abarcan todos los procesadores del sistema, en todos los grupos de procesadores, de forma predeterminada. En lugar de producir errores siempre en caso de que el proceso de llamada contenga subprocesos en más de un grupo de procesadores, se produce un error en la función **SetProcessAffinityMask** (devolviendo cero con **ERROR_INVALID_PARAMETER** último código de error) si el proceso había establecido explícitamente la afinidad de uno o varios de sus subprocesos fuera del [grupo principal](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups) del proceso.

## Requisitos

| **Cliente mínimo compatible**  | Windows XP [aplicaciones de escritorio \| aplicaciones para UWP]          |
| ------------------------------ | ------------------------------------------------------------------------- |
| **Servidor mínimo compatible** | Windows Server 2003 [aplicaciones de escritorio \| aplicaciones para UWP] |
| **Plataforma de destino**      | Windows                                                                   |
| **Encabezado**                 | winbase.h (incluya Windows.h)                                             |
| **Library**                    | Kernel32.lib                                                              |
| **Archivo DLL**                | Kernel32.dll                                                              |

## Vea también

[CreateProcess](https://learn.microsoft.com/es-es/windows/desktop/api/processthreadsapi/nf-processthreadsapi-createprocessa)

[GetProcessAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-getprocessaffinitymask)

[Varios procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/multiple-processors)

[Funciones de proceso y subproceso](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/process-and-thread-functions)

[Procesos](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/child-processes)

[Grupos de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups) -> [[Grupos de procesadores]]

[SetThreadAffinityMask](https://learn.microsoft.com/es-es/windows/desktop/api/winbase/nf-winbase-setthreadaffinitymask) -> [[SetThreadAffinityMask - Cambiar afinidad de un subproceso]]