# VirtualAlloc 

---

### [VirtualAlloc  Microsoft DOC](https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc)

Reserva, confirma o cambia el estado de una región de páginas en el espacio de direcciones virtuales del proceso de llamada. La memoria asignada por esta función se inicializa automáticamente en cero.

Para asignar memoria en el espacio de direcciones de otro proceso, use la función [VirtualAllocEx](poner enlace) .

---

**Sintaxis C++**

```cpp
LPVOID VirtualAlloc(
  [in, optional] LPVOID lpAddress,
  [in]           SIZE_T dwSize,
  [in]           DWORD  flAllocationType,
  [in]           DWORD  flProtect
);
```

---

### Parámetros

```[in, optional] lpAddress```

Dirección inicial de la región que se va a asignar. Si se reserva la memoria, la dirección especificada se redondea hacia abajo hasta el múltiplo más cercano de la granularidad de asignación. Si la memoria ya está reservada y se confirma, la dirección se redondea hacia abajo hasta el límite de la página siguiente. Para determinar el tamaño de una página y la granularidad de asignación en el equipo host, use la función [GetSystemInfo](Poner enlace) . Si este parámetro es NULL, el sistema determina dónde asignar la región.

Si esta dirección está dentro de un enclave que no se ha inicializado llamando a [InitializeEnclave](Poner enlace), VirtualAlloc asigna una página de ceros para el enclave en esa dirección. La página debe no confirmarse previamente y no se medirá con la instrucción EEXTEND del modelo de programación intel Software Guard Extensions.

Si la dirección se encuentra dentro de un enclave que inicializó, se produce un error en la operación de asignación con el error ERROR_INVALID_ADDRESS . Esto es cierto para enclaves que no admiten la administración de memoria dinámica (es decir, SGX1). Los enclaves SGX2 permitirán la asignación y el enclave debe aceptar la página después de que se haya asignado.

```[in] dwSize```

Tamaño de la región, en bytes. Si el parámetro lpAddress es NULL, este valor se redondea al límite de la página siguiente. De lo contrario, las páginas asignadas incluyen todas las páginas que contienen uno o varios bytes en el intervalo de lpAddress a lpAddress+dwSize. Esto significa que un intervalo de 2 bytes estratega un límite de página hace que ambas páginas se incluyan en la región asignada.

```[in] flAllocationType```

Tipo de asignación de memoria. Este parámetro debe contener uno de los valores siguientes.


|                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| :--------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ``#define **MEM_COMMIT** 0x00001000``    | Asigna cargos de memoria (del tamaño total de la memoria y los archivos de paginación en el disco) para las páginas de memoria reservadas especificadas. La función también garantiza que, cuando el autor de la llamada accede inicialmente a la memoria, el contenido será cero. Las páginas físicas reales no se asignan a menos que se tenga acceso a las direcciones virtuales. Para reservar y confirmar páginas en un paso, llame a VirtualAlloc con MEM_COMMIT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | MEM_RESERVE. Al intentar confirmar un intervalo de direcciones específico, se especifica MEM_COMMIT sin MEM_RESERVE y se produce un error en un lpAddress que no sea NULL, a menos que ya se haya reservado todo el intervalo. El código de error resultante es ERROR_INVALID_ADDRESS. Un intento de confirmar una página que ya está confirmada no hace que se produzca un error en la función. Esto significa que puede confirmar páginas sin determinar primero el estado de compromiso actual de cada página. Si lpAddress especifica una dirección dentro de un enclave, flAllocationType debe ser MEM_COMMIT. |
| ``#define **MEM_RESERVE** 0x00002000``   | Reserva un intervalo del espacio de direcciones virtuales del proceso sin asignar ningún almacenamiento físico real en memoria o en el archivo de paginación en el disco. Puede confirmar páginas reservadas en llamadas posteriores a la función VirtualAlloc . Para reservar y confirmar páginas en un paso, llame a VirtualAlloc con MEM_COMMIT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | MEM_RESERVE  . Otras funciones de asignación de memoria, como malloc y [LocalAlloc](Poner enlace), no pueden usar un intervalo reservado de memoria hasta que se libere.                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ``#define **MEM_RESET** 0x00080000``     | Indica que los datos del intervalo de memoria especificados por lpAddress y dwSize ya no son de interés. Las páginas no deben leerse ni escribirse en el archivo de paginación. Sin embargo, el bloque de memoria se usará de nuevo más tarde, por lo que no debe descommitido. Este valor no se puede usar con ningún otro valor. El uso de este valor no garantiza que el intervalo operado con MEM_RESET contenga ceros. Si desea que el intervalo contenga ceros, descommita la memoria y, a continuación, vuelva a enviarla. Al especificar MEM_RESET, la función VirtualAlloc omite el valor de flProtect. Sin embargo, debe establecer flProtect en un valor de protección válido, como PAGE_NOACCESS. VirtualAlloc devuelve un error si usa MEM_RESET y el intervalo de memoria se asigna a un archivo. Una vista compartida solo es aceptable si se asigna a un archivo de paginación.                                                                                                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ``#define **MEM_RESET_UNDO** 0x1000000`` | MEM_RESET_UNDO solo se debe llamar a en un intervalo de direcciones al que MEM_RESET se aplicó correctamente anteriormente. Indica que los datos del intervalo de memoria especificado por lpAddress y dwSize son de interés para el autor de la llamada e intenta invertir los efectos de MEM_RESET. Si la función se ejecuta correctamente, significa que todos los datos del intervalo de direcciones especificados están intactos. Si se produce un error en la función, al menos algunos de los datos del intervalo de direcciones se han reemplazado por ceros. Este valor no se puede usar con ningún otro valor. Si se llama a MEM_RESET_UNDO en un intervalo de direcciones que no se MEM_RESET anteriormente, el comportamiento no está definido. Al especificar MEM_RESET, la función VirtualAlloc omite el valor de flProtect. Sin embargo, debe establecer flProtect en un valor de protección válido, como PAGE_NOACCESS. Windows Server 2008 R2, Windows 7, Windows Server 2008, Windows Vista, Windows Server 2003 y Windows XP: La marca de MEM_RESET_UNDO no se admite hasta Windows 8 y Windows Server 2012. |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |

Este parámetro también puede especificar los valores siguientes como se indica.


|                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| :----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ``#define **MEM_LARGE_PAGES** 0x20000000`` | Asigna memoria con [compatibilidad con páginas grandes](https://learn.microsoft.com/es-es/windows/win32/memory/large-page-support). El tamaño y la alineación deben ser un múltiplo del mínimo de página grande. Para obtener este valor, use la función [GetLargePageMinimum](Poner enlace). Si especifica este valor, también debe especificar MEM_RESERVE y MEM_COMMIT.                                                                                                                                                                                                                                                                |
| ``#define **MEM_PHYSICAL** 0x00400000``    | Reserva un intervalo de direcciones que se puede usar para asignar páginas [de extensiones de ventanas de direcciones](https://learn.microsoft.com/es-es/windows/win32/memory/address-windowing-extensions) (AWE). Este valor se debe usar con MEM_RESERVE y ningún otro valor.                                                                                                                                                                                                                                                                                                                                                           |
| ``#define **MEM_TOP_DOWN** 0x00100000``    | Asigna memoria en la dirección más alta posible. Esto puede ser más lento que las asignaciones normales, especialmente cuando hay muchas asignaciones.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ``#define **MEM_WRITE_WATCH** 0x00200000`` | Hace que el sistema realice un seguimiento de las páginas escritas en en la región asignada. Si especifica este valor, también debe especificar MEM_RESERVE. Para recuperar las direcciones de las páginas en las que se ha escrito desde que se asignó la región o se restableció el estado de seguimiento de escritura, llame a la función [GetWriteWatch](Poner enlace) . Para restablecer el estado de seguimiento de escritura, llame a [GetWriteWatch](Poner enlace) o [ResetWriteWatch](Poner enlace). La característica de seguimiento de escritura permanece habilitada para la región de memoria hasta que se libera la región. |

```[in] flProtect```

Protección de memoria para la región de páginas que se va a asignar. Si se confirman las páginas, puede especificar cualquiera de las [constantes de protección de memoria](https://learn.microsoft.com/es-es/windows/win32/Memory/memory-protection-constants).

Si lpAddress especifica una dirección dentro de un enclave, flProtect no puede ser ninguno de los valores siguientes:

- PAGE_NOACCESS
- PAGE_GUARD
- PAGE_NOCACHE
- PAGE_WRITECOMBINE

Al asignar memoria dinámica para un enclave, el parámetro flProtect debe ser PAGE_READWRITE o PAGE_EXECUTE_READWRITE.

## Valor devuelto
Si la función se ejecuta correctamente, el valor devuelto es la dirección base de la región asignada de páginas.

Si la función no se realiza correctamente, el valor devuelto es NULL. Para obtener información de error extendida, llame a [GetLastError](Poner enlace).

## Comentarios

Cada página tiene un [estado de página](https://learn.microsoft.com/es-es/windows/win32/Memory/page-state) asociado. La función VirtualAlloc puede realizar las siguientes operaciones:

- Confirmar una región de páginas reservadas
- Reservar una región de páginas gratuitas
- Reservar y confirmar simultáneamente una región de páginas gratuitas

VirtualAlloc no puede reservar una página reservada. Puede confirmar una página que ya está confirmada. Esto significa que puede confirmar un intervalo de páginas, independientemente de si ya se han confirmado y la función no producirá un error.

Puede usar VirtualAlloc para reservar un bloque de páginas y, a continuación, realizar llamadas adicionales a VirtualAlloc para confirmar páginas individuales desde el bloque reservado. Esto permite que un proceso reserve un intervalo de su espacio de direcciones virtuales sin consumir almacenamiento físico hasta que sea necesario.

Si el parámetro lpAddress no es NULL, la función usa los parámetros lpAddress y dwSize para calcular la región de las páginas que se van a asignar. El estado actual de todo el intervalo de páginas debe ser compatible con el tipo de asignación especificado por el parámetro flAllocationType . De lo contrario, se produce un error en la función y no se asigna ninguna de las páginas. Este requisito de compatibilidad no impide confirmar una página ya confirmada, como se mencionó anteriormente.

Para ejecutar código generado dinámicamente, use VirtualAlloc para asignar memoria y la función [VirtualProtect](Poner enlace) para conceder acceso PAGE_EXECUTE.

La función VirtualAlloc se puede usar para reservar una región [de extensiones de ventanas de direcciones](https://learn.microsoft.com/es-es/windows/win32/memory/address-windowing-extensions) (AWE) de memoria dentro del espacio de direcciones virtuales de un proceso especificado. A continuación, esta región de memoria se puede usar para asignar páginas físicas hacia y fuera de la memoria virtual según lo requiera la aplicación. Los valores MEM_PHYSICAL y MEM_RESERVE deben establecerse en el parámetro AllocationType . No se debe establecer el valor de MEM_COMMIT . La protección de páginas debe establecerse en PAGE_READWRITE.

La función [VirtualFree](./VirtualFree.md) puede descommitir una página confirmada, liberar el almacenamiento de la página, o puede descommitir y liberar simultáneamente una página confirmada. También puede liberar una página reservada, por lo que es una página gratuita.

Al crear una región que será ejecutable, el programa de llamada asume la responsabilidad de garantizar la coherencia de caché a través de una llamada adecuada a [FlushInstructionCache](Poner enlace) una vez que se haya establecido el código. De lo contrario, los intentos de ejecutar código fuera de la región recién ejecutable pueden producir resultados imprevisibles.


| | |
| :-------------------------------- | -------------------------------------- |
| **Cliente mínimo compatible** | Windows XP [aplicaciones de escritorio | aplicaciones para UWP] |
| **Servidor mínimo compatible** | Windows Server 2003 [aplicaciones de escritorio | aplicaciones para UWP] |
| **Plataforma de destino** | Windows |
| **Encabezado** | memoryapi.h (incluya Windows.h, Memoryapi.h) |
| **Library** | onecore.lib |
| **Archivo DLL** | Kernel32.dll |
| **Lugar donde se implementa** | kernelbase.dll |

---

## Implementacion

```c
LPVOID __stdcall VirtualAlloc(LPVOID lpAddress, SIZE_T dwSize, DWORD flAllocationType, DWORD flProtect)
{
    NTSTATUS Status;                // eax (estado de operacion)
    PVOID BaseAddress = lpAddress;; // [rsp+40h] [rbp+8h] BYREF
    ULONG_PTR RegionSize = dwSize;; // [rsp+48h] [rbp+10h] BYREF

    // si la direccion no es nula y es menos a la direccion
    if ( lpAddress && (uint64_t)lpAddress < UlongToPtr(BaseStaticServerData->SysInfo.AllocationGranularity)) RtlSetLastWin32Error(0x57); // ERROR_INVALID_PARAMETER == 0x57
    else {
        Status = NtAllocateVirtualMemory(
            (HANDLE)0xFFFFFFFFFFFFFFFF,  // NtCurrentProcess == ((HANDLE)(LONG_PTR)-1)
            &BaseAddress,
            0,
            &RegionSize,
            flAllocationType & 0xFFFFFFC0,
            flProtect
        );
        if ( Status >= 0 ) return BaseAddress;
        BaseSetLastNTError((unsigned int)Status);
    }
    return 0;
}
```

---
### [Example 1](./VirtualAlloc/example1.c)

Reservar una pagina de memoria:

```c
/*
 *
 *  Fuente: https://learn.microsoft.com/es-es/windows/win32/Memory/reserving-and-committing-memory
 *          https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc
 *  Compila con: gcc example1.c -o example1.exe 
 *
 */

// A short program to demonstrate dynamic memory allocation
// using a structured exception handler.

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <stdlib.h>             // For exit

#define PAGELIMIT 80            // Number of pages to ask for

LPTSTR lpNxtPage;               // Address of the next page to ask for
DWORD dwPages = 0;              // Count of pages gotten so far
DWORD dwPageSize;               // Page size on this computer

INT PageFaultExceptionFilter(DWORD dwCode)
{
    LPVOID lpvResult;

    // If the exception is not a page fault, exit.

    if (dwCode != EXCEPTION_ACCESS_VIOLATION)
    {
        _tprintf(TEXT("Exception code = %d.\n"), dwCode);
        return EXCEPTION_EXECUTE_HANDLER;
    }

    _tprintf(TEXT("Exception is a page fault.\n"));

    // If the reserved pages are used up, exit.

    if (dwPages >= PAGELIMIT)
    {
        _tprintf(TEXT("Exception: out of pages.\n"));
        return EXCEPTION_EXECUTE_HANDLER;
    }

    // Otherwise, commit another page.

    lpvResult = VirtualAlloc(
                     (LPVOID) lpNxtPage, // Next page to commit
                     dwPageSize,         // Page size, in bytes
                     MEM_COMMIT,         // Allocate a committed page
                     PAGE_READWRITE);    // Read/write access
    if (lpvResult == NULL )
    {
        _tprintf(TEXT("VirtualAlloc failed.\n"));
        return EXCEPTION_EXECUTE_HANDLER;
    }
    else
    {
        _tprintf(TEXT("Allocating another page.\n"));
    }

    // Increment the page count, and advance lpNxtPage to the next page.

    dwPages++;
    lpNxtPage = (LPTSTR) ((PCHAR) lpNxtPage + dwPageSize);

    // Continue execution where the page fault occurred.

    return EXCEPTION_CONTINUE_EXECUTION;
}

VOID ErrorExit(LPTSTR lpMsg)
{
    _tprintf(TEXT("Error! %s with error code of %ld.\n"),
             lpMsg, GetLastError ());
    exit (0);
}

VOID _tmain(VOID)
{
    LPVOID lpvBase;               // Base address of the test memory
    LPTSTR lpPtr;                 // Generic character pointer
    BOOL bSuccess;                // Flag
    DWORD i;                      // Generic counter
    SYSTEM_INFO sSysInfo;         // Useful information about the system

    GetSystemInfo(&sSysInfo);     // Initialize the structure.

    _tprintf (TEXT("This computer has page size %d.\n"), sSysInfo.dwPageSize);

    dwPageSize = sSysInfo.dwPageSize;

    // Reserve pages in the virtual address space of the process.

    lpvBase = VirtualAlloc(
                     NULL,                 // System selects address
                     PAGELIMIT*dwPageSize, // Size of allocation
                     MEM_RESERVE,          // Allocate reserved pages
                     PAGE_NOACCESS);       // Protection = no access
    if (lpvBase == NULL )
        ErrorExit(TEXT("VirtualAlloc reserve failed."));

    lpPtr = lpNxtPage = (LPTSTR) lpvBase;


    // Release the block of pages when you are finished using them.

    bSuccess = VirtualFree(
                       lpvBase,       // Base address of block
                       0,             // Bytes of committed pages
                       MEM_RELEASE);  // Decommit the pages

    _tprintf (TEXT("Release %s.\n"), bSuccess ? TEXT("succeeded") : TEXT("failed") );

}
```

### [Example 2](./VirtualAlloc/example2.c)

Ejecutar shellcode usando VirtualAlloc:
```c
/*
 *
 *  Fuente: https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntfreevirtualmemory
 *          https://learn.microsoft.com/es-es/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntallocatevirtualmemory
 *  Compila con: gcc example1.c -o example1.exe 
 *
 */

#include <stdint.h>
#include <stdio.h>
#include <windows.h>
#include <string.h>

void PrintLastErrorInfo() {
    LPVOID lpMsgBuf;
    DWORD dwLastError = GetLastError();

    DWORD dwFlags = FORMAT_MESSAGE_ALLOCATE_BUFFER |
                    FORMAT_MESSAGE_FROM_SYSTEM |
                    FORMAT_MESSAGE_IGNORE_INSERTS;

    DWORD dwLanguageId = MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT);

    DWORD dwResult = FormatMessage(dwFlags, NULL, dwLastError, dwLanguageId,
                                   (LPTSTR)&lpMsgBuf, 0, NULL);

    if (dwResult != 0) {
        printf("Error code: %lu\n", dwLastError);
        printf("Error message: %s\n", (LPCTSTR)lpMsgBuf);
        
        // Libera el búfer de mensajes
        LocalFree(lpMsgBuf);
    } else {
        fprintf(stderr, "Error al obtener información sobre el último error.\n");
    }
}

static uint8_t code[] =   
    "\x48\x31\xff\x48\xf7\xe7\x65\x48\x8b\x58\x60\x48\x8b\x5b\x18\x48\x8b\x5b\x20\x48\x8b\x1b\x48\x8b\x1b\x48\x8b\x5b\x20\x49\x89\xd8\x8b"
    "\x5b\x3c\x4c\x01\xc3\x48\x31\xc9\x66\x81\xc1\xff\x88\x48\xc1\xe9\x08\x8b\x14\x0b\x4c\x01\xc2\x4d\x31\xd2\x44\x8b\x52\x1c\x4d\x01\xc2"
    "\x4d\x31\xdb\x44\x8b\x5a\x20\x4d\x01\xc3\x4d\x31\xe4\x44\x8b\x62\x24\x4d\x01\xc4\xeb\x32\x5b\x59\x48\x31\xc0\x48\x89\xe2\x51\x48\x8b"
    "\x0c\x24\x48\x31\xff\x41\x8b\x3c\x83\x4c\x01\xc7\x48\x89\xd6\xf3\xa6\x74\x05\x48\xff\xc0\xeb\xe6\x59\x66\x41\x8b\x04\x44\x41\x8b\x04"
    "\x82\x4c\x01\xc0\x53\xc3\x48\x31\xc9\x80\xc1\x07\x48\xb8\x0f\xa8\x96\x91\xba\x87\x9a\x9c\x48\xf7\xd0\x48\xc1\xe8\x08\x50\x51\xe8\xb0"
    "\xff\xff\xff\x49\x89\xc6\x48\x31\xc9\x48\xf7\xe1\x50\x48\xb8\x9c\x9e\x93\x9c\xd1\x9a\x87\x9a\x48\xf7\xd0\x50\x48\x89\xe1\x48\xff\xc2"
    "\x48\x83\xec\x20\x41\xff\xd6";
SIZE_T size_of_code = sizeof(code); // tamaño del shellcode

int main() {
    PVOID exec = VirtualAlloc(0, sizeof(code), MEM_COMMIT, PAGE_EXECUTE_READWRITE);

    if (exec == NULL) puts("VirtualAlloc error");
    printf("ptr VirtualAlloc: 0x%p\n", exec);

    memcpy(exec, code, sizeof code); // copiar el shellcode a la nueva memoria reservada
	((void(*)())exec)(); // ejecuta el shellcode
    PrintLastErrorInfo();

    if(!VirtualFree(exec, 0, MEM_RELEASE)){// liberar memoria
        // si el valor es 0 == false, a ocurrio un error
        PrintLastErrorInfo();
        return EXIT_FAILURE;
    } 
    puts("Succes");
	return EXIT_SUCCESS;
}
```

---
