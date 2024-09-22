Esta colección de archivos de encabezado de API nativa se ha mantenido desde 2009 para el proyecto Process Hacker y es el conjunto de definiciones de API nativas más actualizado que conozco. He recopilado estas definiciones de archivos de encabezado y de símbolos oficiales de Microsoft, así como de mucha ingeniería inversa y conjeturas. Consulte `phnt.h` para obtener más información.

## Uso

Primero asegúrese de que su programa esté utilizando el último SDK de Windows. 
Estos archivos de encabezado están diseñados para ser utilizados por programas en modo de usuario. En lugar de `#include <windows.h>`, coloque

```c
[[include]] <phnt_windows.h>
[[include]] <phnt.h>
```

en la parte superior de su programa. La primera línea proporciona acceso a la API de Win32, así como a los valores `NTSTATUS`. La segunda línea proporciona acceso a toda la API nativa. De forma predeterminada, sólo se incluyen en su programa las definiciones presentes en Windows XP. Para cambiar esto, utilice uno de los siguientes:

```c
[[define]] PHNT_VERSION PHNT_WINXP // Windows XP
[[define]] PHNT_VERSION PHNT_WS03 // Windows Server 2003
[[define]] PHNT_VERSION PHNT_VISTA // Windows Vista
[[define]] PHNT_VERSION PHNT_WIN7 // Windows 7
[[define]] PHNT_VERSION PHNT_WIN8 // Windows 8
[[define]] PHNT_VERSION PHNT_WINBLUE // Windows 8.1
[[define]] PHNT_VERSION PHNT_THRESHOLD // Windows 10
```
