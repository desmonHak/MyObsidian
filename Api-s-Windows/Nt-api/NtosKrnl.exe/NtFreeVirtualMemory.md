# NtFreeVirtualMemory

---

### [NtFreeVirtualMemory Microsoft DOC](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntfreevirtualmemory)

La rutina NtFreeVirtualMemory libera, descompromete, o ambos libera y descompromete, una región de páginas dentro del espacio de direcciones virtual de un proceso especificado.

---

**Sintaxis C++**

```cpp
__kernel_entry NTSYSCALLAPI NTSTATUS NtFreeVirtualMemory(
  [in]      HANDLE  ProcessHandle,
  [in, out] PVOID   *BaseAddress,
  [in, out] PSIZE_T RegionSize,
  [in]      ULONG   FreeType
);
```

---

## Parámetros

`[in] ProcessHandle`

Un handle para el proceso en cuyo contexto residen las páginas a liberar. Utilice la macro NtCurrentProcess, definida en Ntddk.h, para especificar el proceso actual.

`[in, out] BaseAddress`

Un puntero a una variable que recibirá la dirección virtual base de la región de páginas liberada.

Si se establece la bandera MEM_RELEASE en el parámetro FreeType, \*BaseAddress debe ser la dirección base devuelta por [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md) cuando se reservó la región.

`[in, out] RegionSize`

Un puntero a una variable que recibirá el tamaño real, en bytes, de la región de páginas liberada. La rutina redondea el valor inicial de esta variable al siguiente límite de tamaño de página del host y vuelve a escribir el valor redondeado en esta variable.

Si la bandera MEM_RELEASE está activada en *FreeType, *RegionSize debe ser cero. NtFreeVirtualMemory libera toda la región que fue reservada en la llamada de asignación inicial a [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md).

Si el indicador MEM_DECOMMIT está activado en *FreeType, NtFreeVirtualMemory libera todas las páginas de memoria que contengan uno o más bytes en el rango de *BaseAddress a (*BaseAddress + *RegionSize). Esto significa, por ejemplo, que si una región de memoria de dos bytes se encuentra en el límite de una página, ambas páginas son liberadas.

NtFreeVirtualMemory libera toda la región reservada por NtAllocateVirtualMemory. Si se cumplen las tres condiciones siguientes, toda la región pasa al estado reservado:

- El indicador MEM_DECOMMIT está activado.
- \*BaseAddress es la dirección base devuelta por [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md) cuando se reservó la región.
- \*RegionSize es cero.

`[in] FreeType`

Una máscara de bits que contiene indicadores que describen el tipo de operación de liberación que NtFreeVirtualMemory realizará para la región de páginas especificada. Los valores posibles se enumeran en la tabla siguiente.

|              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| :----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| MEM_DECOMMIT | NtFreeVirtualMemory liberará la región especificada de páginas. Las páginas pasan al estado reservado. NtFreeVirtualMemory no falla si se intenta descomprometer una página no comprometida. Esto significa que puede descomprometer un rango de páginas sin determinar primero su estado de compromiso actual.                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| MEM_RELEASE  | NtFreeVirtualMemory liberará la región especificada de páginas. Las páginas entran en estado libre. Si especifica esta bandera, RegionSize debe ser cero, y BaseAddress debe apuntar a la dirección base devuelta por [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md) cuando se reservó la región. NtFreeVirtualMemory falla si no se cumple alguna de estas condiciones. Si alguna página de la región está actualmente comprometida, NtFreeVirtualMemory primero la descompromete y luego la libera. NtFreeVirtualMemory no falla si intenta liberar páginas que están en diferentes estados, algunas reservadas y otras comprometidas. Esto significa que puede liberar un rango de páginas sin determinar primero su estado de compromiso actual. |

## Valor devuelto

NtFreeVirtualMemory devuelve STATUS_SUCCESS o un código de error. Los posibles códigos de error son los siguientes.

|                                 |                                                                                                                                         |
| :------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| **STATUS_ACCESS_DENIED**        | Un proceso ha solicitado acceso a un objeto, pero no se le han concedido esos derechos de acceso.                                       |
| **STATUS_INVALID_HANDLE**       | Se ha especificado un valor de ProcessHandle no válido.                                                                                 |
| **STATUS_OBJECT_TYPE_MISMATCH** | Existe una discrepancia entre el tipo de objeto requerido por la operación solicitada y el tipo de objeto especificado en la solicitud. |

## Comentarios

Cada página del espacio de direcciones virtual del proceso se encuentra en uno de los tres estados descritos en la siguiente tabla.

|               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| :------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **FREE**      | La página no está comprometida ni reservada. El proceso no puede acceder a la página. Intentar leer o escribir en una página libre resulta en una excepción de violación de acceso. Puede utilizar NtFreeVirtualMemory para poner páginas reservadas o comprometidas en estado libre.                                                                                                                                                                                                                                       |
| **RESERVED**  | La página está reservada. El rango de direcciones no puede ser utilizado por otras funciones de asignación. La página no es accesible para el proceso y no tiene almacenamiento físico asociado. Si se intenta leer o escribir en una página reservada se produce una excepción de violación de acceso. Puede utilizar NtFreeVirtualMemory para poner páginas de memoria comprometida en estado reservado, y para poner páginas de memoria reservada en estado libre.                                                       |
| **COMMITTED** | The page is committed. Physical storage in memory or in the paging file on disk is allocated for the page, and access is controlled by a protection code. The system initializes and loads each committed page into physical memory only at the first attempt to read from or write to that page. When a process terminates, the system releases all storage for committed pages. You can use [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md) to put committed memory pages into either the reserved or free state. |

NtFreeVirtualMemory puede realizar las siguientes operaciones:

- Descomprometer una región de páginas comprometidas o no comprometidas. Tras esta operación, las páginas quedan en estado reservado.
- Liberar una región de páginas reservadas. Después de esta operación, las páginas se encuentran en estado libre.
- Descomprometer y liberar una región de páginas comprometidas o no comprometidas. Tras esta operación, las páginas se encuentran en estado libre.

NtFreeVirtualMemory puede descomprometer un rango de páginas que están en diferentes estados, algunas comprometidas y otras no comprometidas. Esto significa que puede descomprometer un rango de páginas sin determinar primero el estado de compromiso actual de cada página. Al descomprometer una página se libera su almacenamiento físico, ya sea en memoria o en el archivo de paginación del disco.

Si una página se descompromete pero no se libera, su estado cambia a reservado. Posteriormente se puede llamar a [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md) para liberarla, o a NtFreeVirtualMemory para liberarla. Si se intenta leer o escribir en una página reservada, se produce una excepción de violación de acceso.

NtFreeVirtualMemory puede liberar un rango de páginas que están en diferentes estados, algunas reservadas y otras confirmadas. Esto significa que puede liberar un rango de páginas sin determinar primero el estado de compromiso actual de cada página. El rango completo de páginas reservadas originalmente por [NtAllocateVirtualMemory](./NtAllocateVirtualMemory.md) debe liberarse al mismo tiempo.

Si se libera una página, su estado cambia a libre y queda disponible para posteriores operaciones de asignación. Una vez liberada o descomprometida la memoria, no se puede volver a hacer referencia a ella. Cualquier información que pudiera haber en esa memoria desaparece para siempre. Si se intenta leer o escribir en una página libre, se produce una excepción de violación de acceso. Si necesitas información, no liberes la memoria que la contiene.

Para obtener más información sobre la gestión de memoria para controladores en modo kernel, consulte [Gestión de memoria para controladores de Windows](https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/managing-memory-for-drivers).

<pre style="background-color: lavender; padding: 10px; border-radius: 5px;">
Nota
Si la llamada a la función NtFreeVirtualMemory se produce en modo usuario, 
debe utilizar el nombre "NtFreeVirtualMemory" en lugar de "ZwFreeVirtualMemory".
</pre>

En el caso de las llamadas de controladores en modo kernel, las versiones NtXxx y ZwXxx de una rutina de Servicios del sistema nativos de Windows pueden comportarse de manera diferente en cuanto a la forma en que manejan e interpretan los parámetros de entrada. Para obtener más información sobre la relación entre las versiones NtXxx y ZwXxx de una rutina, consulte [Uso de las versiones Nt y Zw de las rutinas de los servicios nativos del sistema](https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/using-nt-and-zw-versions-of-the-native-system-services-routines).

|                                   |                                        |
| :-------------------------------- | -------------------------------------- |
| **Cliente mínimo compatible**     | Windows 2000                           |
| **Plataforma de destino**         | Universal                              |
| **Encabezado**                    | ntifs.h (incluya Ntifs.h, Fltkernel.h) |
| **Library**                       | NtosKrnl.lib                           |
| **Archivo DLL**                   | NtosKrnl.exe                           |
| **IRQL**                          | PASSIVE_LEVEL                          |
| **Reglas de cumplimiento de DDI** | HwStorPortProhibitedDDIs, PowerIrpDDis |

---

## Implementacion

```c
NTSTATUS __stdcall NtFreeVirtualMemory(HANDLE ProcessHandle, PVOID *BaseAddress, PSIZE_T RegionSize, ULONG FreeType)
{
    char PreviousMode; // dl
    __int64 v8; // rcx
    __int64 v9; // rcx
    NTSTATUS result; // eax
    ULONG_PTR v11; // [rsp+38h] [rbp-20h]
    PVOID v12; // [rsp+40h] [rbp-18h]

    PreviousMode = KeGetCurrentThread()->PreviousMode;
    if ( PreviousMode )
    {
        v8 = (__int64)BaseAddress;
        if ( (unsigned __int64)BaseAddress >= 0x7FFFFFFF0000 )
        v8 = 0x7FFFFFFF0000;
        *(_QWORD *)v8 = *(_QWORD *)v8;
        v9 = (__int64)RegionSize;
        if ( (unsigned __int64)RegionSize >= 0x7FFFFFFF0000 )
        v9 = 0x7FFFFFFF0000;
        *(_QWORD *)v9 = *(_QWORD *)v9;
    }
    v12 = *BaseAddress;
    v11 = *RegionSize;
    result = MmFreeVirtualMemory((ULONG_PTR)ProcessHandle, PreviousMode, 0);
    if ( result >= 0 )
    {
        *RegionSize = v11;
        *BaseAddress = v12;
    }
    return result;
}
```

---

### [Example 1](./NtAllocateVirtualMemory/example1.c)

Ejecutar shellcode reservando memoria en el proceso actual con permisos de lectura, escritura y ejecucion

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

[[pragma]] comment(lib, "ntdll")

typedef NTSTATUS(NTAPI* NtAllocateVirtualMemoryPtr)(
    HANDLE             ProcessHandle,
    PVOID              *BaseAddress,
    ULONG              ZeroBits,
    PSIZE_T             RegionSize,
    ULONG              AllocationType,
    ULONG              Protect);
typedef NTSTATUS(NTAPI* NtFreeVirtualMemoryPtr)(
    HANDLE  ProcessHandle,
    PVOID   *BaseAddress,
    PSIZE_T RegionSize,
    ULONG   FreeType
);

static uint8_t code[] =
    "\x48\x31\xff\x48\xf7\xe7\x65\x48\x8b\x58\x60\x48\x8b\x5b\x18\x48\x8b\x5b\x20\x48\x8b\x1b\x48\x8b\x1b\x48\x8b\x5b\x20\x49\x89\xd8\x8b"
    "\x5b\x3c\x4c\x01\xc3\x48\x31\xc9\x66\x81\xc1\xff\x88\x48\xc1\xe9\x08\x8b\x14\x0b\x4c\x01\xc2\x4d\x31\xd2\x44\x8b\x52\x1c\x4d\x01\xc2"
    "\x4d\x31\xdb\x44\x8b\x5a\x20\x4d\x01\xc3\x4d\x31\xe4\x44\x8b\x62\x24\x4d\x01\xc4\xeb\x32\x5b\x59\x48\x31\xc0\x48\x89\xe2\x51\x48\x8b"
    "\x0c\x24\x48\x31\xff\x41\x8b\x3c\x83\x4c\x01\xc7\x48\x89\xd6\xf3\xa6\x74\x05\x48\xff\xc0\xeb\xe6\x59\x66\x41\x8b\x04\x44\x41\x8b\x04"
    "\x82\x4c\x01\xc0\x53\xc3\x48\x31\xc9\x80\xc1\x07\x48\xb8\x0f\xa8\x96\x91\xba\x87\x9a\x9c\x48\xf7\xd0\x48\xc1\xe8\x08\x50\x51\xe8\xb0"
    "\xff\xff\xff\x49\x89\xc6\x48\x31\xc9\x48\xf7\xe1\x50\x48\xb8\x9c\x9e\x93\x9c\xd1\x9a\x87\x9a\x48\xf7\xd0\x50\x48\x89\xe1\x48\xff\xc2"
    "\x48\x83\xec\x20\x41\xff\xd6";
SIZE_T size_of_code = sizeof(code); // tamaño del shellcode

[[define]] NT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
[[define]] NtCurrentProcess() ((HANDLE)(LONG_PTR)-1)

int main() {

    HMODULE hNtdll = LoadLibraryA("ntdll.dll"); // cargamos ntdll que carga NtosKrnl.exe(el kernel de windows) para obtener su direccion
    if (hNtdll == NULL) {
        puts("Error al cargar la biblioteca ntdll.dll");
        return EXIT_FAILURE;
    }
    // Obtiene la direccion a la función NtAllocateVirtualMemory
    NtAllocateVirtualMemoryPtr NtAllocateVirtualMemory = (NtAllocateVirtualMemoryPtr)(GetProcAddress(hNtdll, "NtAllocateVirtualMemory"));
    if (NtAllocateVirtualMemory == NULL) {
        puts("Error al obtener la direccion a la función NtAllocateVirtualMemory");
        goto exit_free_null;
    }
    // Obtiene la direccion a la función NtFreeVirtualMemory
    NtFreeVirtualMemoryPtr NtFreeVirtualMemory = (NtFreeVirtualMemoryPtr)(GetProcAddress(hNtdll, "NtFreeVirtualMemory"));
    if (NtFreeVirtualMemory == NULL) {
        puts("Error al obtener la direccion a la función NtFreeVirtualMemory");
        goto exit_free_null;
    }

    /*SYSTEM_INFO systemInfo;
    GetSystemInfo(&systemInfo);
    DWORD pageSize = systemInfo.dwPageSize; // obtener el tamaño de pagina*/

    PVOID exec = NULL; // ptr a la memoria reservada
    NTSTATUS Status = NtAllocateVirtualMemory(NtCurrentProcess(), &exec, 0, (PSIZE_T)&size_of_code, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

    if (!NT_SUCCESS(Status)) goto exit_free_null;
    printf("ptr NtAllocateVirtualMemory: 0x%p\n", exec);

	/*
    PVOID exec = VirtualAlloc(0, sizeof(code), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if (exec == NULL) puts("VirtualAlloc error");
    printf("ptr VirtualAlloc: 0x%p\n", exec);
    */

    memcpy(exec, code, sizeof code); // copiar el shellcode a la nueva memoria reservada
	((void(*)())exec)(); // ejecuta el shellcode

    // liberar memoria reservada:
    Status = NtFreeVirtualMemory(NtCurrentProcess(), &exec, (PSIZE_T)&size_of_code, MEM_RELEASE);
    if (!NT_SUCCESS(Status)) goto exit_free_null;

    FreeLibrary(hNtdll); // liberar la libreria(memoria asociada)
	return EXIT_SUCCESS;

    exit_free_null:
        puts("Error");
        FreeLibrary(hNtdll);
        return EXIT_FAILURE;

}
```

---
