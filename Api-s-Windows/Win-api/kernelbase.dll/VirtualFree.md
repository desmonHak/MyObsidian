# VirtualFree 

---

### [VirtualFree Microsoft DOC](https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-virtualfree)

Libera, descommite o libera y descommite una región de páginas dentro del espacio de direcciones virtuales del proceso de llamada.

Para liberar memoria asignada en otro proceso por la función [VirtualAllocEx](Poner enlace), use la función [VirtualFreeEx](Poner enlace).

---

**Sintaxis C++**

```cpp
BOOL VirtualFree(
  [in] LPVOID lpAddress,
  [in] SIZE_T dwSize,
  [in] DWORD  dwFreeType
);
```

---

## Parámetros

```[in] lpAddress```
Puntero a la dirección base de la región de las páginas que se van a liberar.

Si el parámetro dwFreeType es MEM_RELEASE, este parámetro debe ser la dirección base devuelta por la función [VirtualAlloc](./VirtualAlloc.md) cuando se reserva la región de las páginas.

```[in] dwSize```
Tamaño de la región de memoria que se va a liberar, en bytes.

Si el parámetro dwFreeType es MEM_RELEASE, este parámetro debe ser 0 (cero). La función libera toda la región reservada en la llamada de asignación inicial a [VirtualAlloc](./VirtualAlloc.md).

Si el parámetro dwFreeType es MEM_DECOMMIT, la función descommite todas las páginas de memoria que contienen uno o varios bytes en el intervalo del parámetro lpAddress a (lpAddress+dwSize). Esto significa, por ejemplo, que una región de 2 bytes de memoria que extiende un límite de página hace que ambas páginas se descommitan. Si lpAddress es la dirección base devuelta por [VirtualAlloc](./VirtualAlloc.md) y dwSize es 0 (cero), la función descommite toda la región asignada por [VirtualAlloc](./VirtualAlloc.md). Después de eso, toda la región está en estado reservado.

```[in] dwFreeType```
Tipo de operación libre. Este parámetro puede ser uno de los siguientes valores.


|                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| :-------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ``#define **MEM_DECOMMIT** 0x00004000`` | operación, las páginas están en estado reservado. La función no produce un error si intenta descommitar una página sin confirmar. Esto significa que puede descommitr un intervalo de páginas sin determinar primero el estado de compromiso actual. El valor de MEM_DECOMMIT no se admite cuando el parámetro lpAddress proporciona la dirección base para un enclave. Esto es así para enclaves que no admiten la administración de memoria dinámica (es decir, SGX1). Los enclaves SGX2 permiten MEM_DECOMMIT en cualquier lugar del enclave.                                                                                                                                                                                                                                                                                                                                                    |
| ``#define **MEM_RELEASE**  0x00008000`` | Libera la región especificada de páginas o marcador de posición (para un marcador de posición, el espacio de direcciones se libera y está disponible para otras asignaciones). Después de esta operación, las páginas quedan en el estado libre. Si especifica este valor, dwSize debe ser 0 (cero) y lpAddress debe apuntar a la dirección base devuelta por la función [VirtualAlloc](./VirtualAlloc.md) cuando se reserva la región. Se produce un error en la función si no se cumple cualquiera de estas condiciones. Si se confirma actualmente alguna página de la región, la función se descommite primero y, a continuación, las libera. La función no produce un error si intenta liberar páginas que están en diferentes estados, algunas reservadas y otras confirmadas. Esto significa que puede liberar un intervalo de páginas sin determinar primero el estado de compromiso actual |

Al usar MEM_RELEASE, este parámetro también puede especificar uno de los valores siguientes:

|                                                      |                                                                                                                                                                                                                                                                                       |                                                                                                                                                                                                    |
| :--------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ``#define **MEM_COALESCE_PLACEHOLDERS** 0x0000000``1 | Para fusionar dos marcadores de posición adyacentes, especifique MEM_RELEASE                                                                                                                                                                                                          | MEM_COALESCE_PLACEHOLDERS. Cuando se combinan marcadores de posición, lpAddress y dwSize deben coincidir exactamente con el intervalo general de los marcadores de posición que se van a combinar. |
| ``#define **MEM_PRESERVE_PLACEHOLDER**  0x00000002`` | Libera una asignación a un marcador de posición (después de reemplazar un marcador de posición por una asignación privada mediante [VirtualAlloc2](Poner enlace) o Virtual2AllocFromApp). Para dividir un marcador de posición en dos marcadores de posición, especifique MEM_RELEASE | MEM_PRESERVE_PLACEHOLDER.                                                                                                                                                                          |


## Valor devuelto

Si la función se realiza correctamente, el valor devuelto es distinto de cero.

Si la función no se realiza correctamente, el valor devuelto es 0 (cero). Para obtener información de error extendida, llame a [GetLastError](Poner enlace).

## Comentarios

Cada página de memoria de un espacio de direcciones virtuales de proceso tiene un [estado de página](https://learn.microsoft.com/es-es/windows/win32/Memory/page-state). La función VirtualFree puede descommitar un intervalo de páginas que se encuentran en diferentes estados, algunos confirmados y algunos no confirmados. Esto significa que puede descommitr un intervalo de páginas sin determinar primero el estado de compromiso actual de cada página. Al omitir una página, se libera su almacenamiento físico, ya sea en memoria o en el archivo de paginación en el disco.

Si se descommite una página pero no se libera, su estado cambia a reservado. Posteriormente, puede llamar a [VirtualAlloc](./VirtualAlloc.md) para confirmarlo o VirtualFree para liberarlo. Los intentos de lectura o escritura en una página reservada producen una excepción de infracción de acceso.

La función VirtualFree puede liberar un intervalo de páginas que se encuentran en diferentes estados, algunos reservados y algunos confirmados. Esto significa que puede liberar un intervalo de páginas sin determinar primero el estado de compromiso actual de cada página. El intervalo completo de páginas reservadas originalmente por la función [VirtualAlloc](./VirtualAlloc.md) debe liberarse al mismo tiempo.

Si se libera una página, su estado cambia a gratis y está disponible para las operaciones de asignación posteriores. Una vez que se libere o se descommita la memoria, nunca podrá volver a hacer referencia a la memoria. Cualquier información que pueda haber estado en esa memoria se ha ido para siempre. Si se intenta leer o escribir en una página gratuita, se produce una excepción de infracción de acceso. Si necesita mantener la información, no descommita ni libere memoria que contenga la información.

La función VirtualFree se puede usar en una región de AWE de memoria y invalida las asignaciones de páginas físicas de la región al liberar el espacio de direcciones. Sin embargo, la página física no se elimina y la aplicación puede usarlas. La aplicación debe llamar explícitamente a [FreeUserPhysicalPages](Poner enlace) para liberar las páginas físicas. Cuando finaliza el proceso, todos los recursos se limpian automáticamente.

Windows 10, versión 1709 y posteriores y Windows 11: para eliminar el enclave cuando termine de usarlo, llame a [DeleteEnclave](Poner enlace). No se puede eliminar un enclave de VBS llamando a la función VirtualFree o [VirtualFreeEx](Poner enlace) . Todavía puede eliminar un enclave SGX llamando a VirtualFree o [VirtualFreeEx](Poner enlace).

Windows 10, versión 1507, Windows 10, versión 1511, Windows 10, versión 1607 y Windows 10, versión 1703: para eliminar el enclave cuando termine de usarlo, llame a la función VirtualFree o [VirtualFreeEx](Poner enlace) y especifique los valores siguientes:

- Dirección base del enclave para el parámetro lpAddress .
- 0 para el parámetro dwSize .
- MEM_RELEASE para el parámetro dwFreeType .



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
BOOL __stdcall VirtualFree(LPVOID lpAddress, SIZE_T dwSize, DWORD dwFreeType)
{
    BOOL Status_return   = FALSE;     // edi ( la funcion supone que no ocurrio ningun error)
    NTSTATUS Status;                  // ebx
    ULONG_PTR RegionSize = dwSize;;   // [rsp+30h] [rbp+8h] BYREF
    PVOID BaseAddress    = lpAddress; // [rsp+38h] [rbp+10h] BYREF

    if ( 
        (dwFreeType & 0xFFFF3FFC) != 0 ||  
        (dwFreeType & 0x8003) == MEM_RELEASE && // (dwFreeType & 0x8003) == MEM_RELEASE(0x8000)
        dwSize   
    ) {
        // Se ha pasado un parámetro no válido a un servicio o función.
        Status = STATUS_INVALID_PARAMETER; // Status = 0xc000000d(STATUS_INVALID_PARAMETER)
        goto Exit_ret;
    }
    Status = NtFreeVirtualMemory(
        (HANDLE)0xFFFFFFFFFFFFFFFF,     // NtCurrentProcess()
        &BaseAddress, 
        &RegionSize, 
        dwFreeType
    );
    if ( Status == STATUS_INVALID_PAGE_PROTECTION )        // Status == 0xc0000045(STATUS_INVALID_PAGE_PROTECTION)
    {
        // La protección de página especificada no era válida.
        if ( !RtlFlushSecureMemoryCache(BaseAddress, RegionSize) ) goto Exit_ret;
        Status = NtFreeVirtualMemory(
            (HANDLE)0xFFFFFFFFFFFFFFFF, // NtCurrentProcess()
            &BaseAddress, 
            &RegionSize, 
            dwFreeType
        );
    }
    if ( Status < 0 )
    {
    Exit_ret:
        BaseSetLastNTError((unsigned int)Status);
        return Status_return; 
    }
    return TRUE; // ocurrio un error
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

[[include]] <windows.h>
[[include]] <tchar.h>
[[include]] <stdio.h>
[[include]] <stdlib.h>             // For exit

[[define]] PAGELIMIT 80            // Number of pages to ask for

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

[[include]] <stdint.h>
[[include]] <stdio.h>
[[include]] <windows.h>
[[include]] <string.h>

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


