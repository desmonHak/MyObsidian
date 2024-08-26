
[SetThreadGroupAffinity](https://learn.microsoft.com/es-es/windows/win32/api/processtopologyapi/nf-processtopologyapi-setthreadgroupaffinity)

Establece la afinidad de grupo de procesadores para el subproceso especificado.

```c
BOOL SetThreadGroupAffinity(
  [in]            HANDLE               hThread,
  [in]            const GROUP_AFFINITY *GroupAffinity,
  [out, optional] PGROUP_AFFINITY      PreviousGroupAffinity
);
```

## Parámetros

`[in] hThread`

Identificador del subproceso.

El identificador debe tener el derecho de acceso THREAD_SET_INFORMATION. Para obtener más información, consulte [Derechos de acceso y seguridad de subprocesos](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/thread-security-and-access-rights).

`[in] GroupAffinity`

Estructura [GROUP_AFFINITY](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-group_affinity) que especifica la afinidad de grupo de procesadores que se usará para el subproceso especificado.

`[out, optional] PreviousGroupAffinity`

Puntero a una estructura [de GROUP_AFFINITY](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-group_affinity) para recibir la afinidad de grupo anterior del subproceso. Este parámetro puede ser NULL.
## Valor devuelto

Si la función se realiza correctamente, el valor devuelto es distinto de cero.

Si la función no se realiza correctamente, el valor devuelto es cero. Para obtener información de error extendida, use [GetLastError](https://learn.microsoft.com/es-es/windows/desktop/api/adshlp/nf-adshlp-adsgetlasterror).
## Comentarios

^29ab1f

A partir de Windows 11 y Windows Server 2022, en un sistema con más de 64 procesadores, las afinidades de procesos y subprocesos abarcan todos los procesadores del sistema, en todos los [grupos de procesadores](https://learn.microsoft.com/es-es/windows/desktop/ProcThread/processor-groups), de forma predeterminada. La función **SetThreadGroupAffinity** restringe la afinidad de un subproceso a los procesadores a través del grupo de procesadores único especificado por el _groupAffinity especificado por la groupAffinity_ especificada. Este grupo también se convertirá en el grupo principal del subproceso.

Para compilar una aplicación que usa esta función, establezca _WIN32_WINNT >= 0x0601. Para obtener más información, vea [Usar los encabezados de Windows](https://learn.microsoft.com/es-es/windows/desktop/WinProg/using-the-windows-headers).
## Requisitos

|Requisito|Value|
|---|---|
|**Cliente mínimo compatible**|Windows 7 [solo aplicaciones de escritorio]|
|**Servidor mínimo compatible**|Windows Server 2008 R2 [solo aplicaciones de escritorio]|
|**Plataforma de destino**|Windows|
|**Encabezado**|processtopologyapi.h|
|**Library**|Kernel32.lib|
|**Archivo DLL**|Kernel32.dll|

## Vea también

[GROUP_AFFINITY](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-group_affinity)