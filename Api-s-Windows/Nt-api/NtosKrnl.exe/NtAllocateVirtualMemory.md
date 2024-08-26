# NtAllocateVirtualMemory

---

### [NtAllocateVirtualMemory Microsoft DOC](https://learn.microsoft.com/es-es/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntallocatevirtualmemory)

La rutina NtAllocateVirtualMemory reserva, confirma o ambas, una región de páginas dentro del espacio de direcciones virtuales en modo de usuario de un proceso especificado.

---

**Sintaxis C++**

```cpp
__kernel_entry NTSYSCALLAPI NTSTATUS NtAllocateVirtualMemory(
  [in]      HANDLE    ProcessHandle,
  [in, out] PVOID     *BaseAddress,
  [in]      ULONG_PTR ZeroBits,
  [in, out] PSIZE_T   RegionSize,
  [in]      ULONG     AllocationType,
  [in]      ULONG     Protect
);
```

---

## Parámetros

`[in] ProcessHandle`

Identificador del proceso para el que se debe realizar la asignación. Use la macro NtCurrentProcess , definida en Ntddk.h, para especificar el proceso actual.

`[in, out] BaseAddress`

Puntero a una variable que recibirá la dirección base de la región asignada de páginas. Si el valor inicial de BaseAddress no es NULL, la región se asigna a partir de la dirección virtual especificada redondeada hacia abajo hasta el siguiente límite de dirección de tamaño de página host. Si el valor inicial de BaseAddress es NULL, el sistema operativo determinará dónde asignar la región.

`[in] ZeroBits`

Número de bits de dirección de orden superior que deben ser cero en la dirección base de la vista de sección. Se usa solo cuando el sistema operativo determina dónde asignar la región, como cuando BaseAddress\* es NULL. Tenga en cuenta que cuando ZeroBits es mayor que 32, se convierte en una máscara de bits.

`[in, out] RegionSize`

Puntero a una variable que recibirá el tamaño real, en bytes, de la región asignada de páginas. El valor inicial de RegionSize especifica el tamaño, en bytes, de la región y se redondea hasta el siguiente límite de tamaño de página host. RegionSize no puede ser cero en la entrada.

`[in] AllocationType`

Máscara de bits que contiene marcas que especifican el tipo de asignación que se va a realizar para la región de páginas especificada. En la tabla siguiente se describen las marcas más comunes. Consulte [VirtualAlloc](../../WinApi/kernelbase.dll/VirtualAlloc.md) para obtener una lista completa de las posibles marcas y descripciones.

<pre style="background-color: lavender; padding: 10px; border-radius: 5px;">
Nota
Se debe establecer uno de MEM_COMMIT, MEM_RESET o MEM_RESERVE.
</pre>

|                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| MEM_COMMIT             | La región especificada de páginas se va a confirmar.                                                                                                                                                                                                                                                                                                                                                                                                                  |
| MEM_RESERVE            | La región especificada de las páginas se va a reservar.                                                                                                                                                                                                                                                                                                                                                                                                               |
| MEM_RESET              | Restablezca el estado de la región especificada para que, si las páginas están en el archivo de paginación, se descartan y se traen páginas de ceros. Si las páginas están en memoria y modificadas, se marcan como no modificadas para que no se escriban en el archivo de paginación. El contenido no está a cero. El parámetro Protect no se usa, pero debe establecerse en un valor válido. Si se establece MEM_RESET, no se puede establecer ninguna otra marca. |
| Otras marcas (MEM_XXX) | Consulte [VirtualAlloc](../../WinApi/kernelbase.dll/VirtualAlloc.md)                                                                                                                                                                                                                                                                                                                                                                                                  |

`[in] Protect`
Máscara de bits que contiene marcas de protección de páginas que especifican la protección deseada para la región confirmada de páginas. En la tabla siguiente se describen estas marcas.

|                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PAGE_NOACCESS     | No se permite el acceso a la región confirmada de páginas. Un intento de leer, escribir o ejecutar la región confirmada produce una excepción de infracción de acceso, denominada error de protección general (GP).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| PAGE_READONLY     | Se permite el acceso de solo lectura y ejecución a la región confirmada de páginas. Un intento de escribir la región confirmada produce una infracción de acceso.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| PAGE_READWRITE    | Se permite el acceso de lectura, escritura y ejecución a la región confirmada de páginas. Si se permite el acceso de escritura a la sección subyacente, se comparte una sola copia de las páginas. De lo contrario, las páginas se comparten de solo lectura o copia en escritura.                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| PAGE_EXECUTE      | Se permite ejecutar el acceso a la región confirmada de páginas. Un intento de leer o escribir en la región confirmada produce una infracción de acceso.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| PAGE_EXECUTE_READ | Se permite el acceso de ejecución y lectura a la región confirmada de páginas. Un intento de escribir en la región confirmada produce una infracción de acceso.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| PAGE_GUARD        | Las páginas de la región se convierten en páginas de protección. Cualquier intento de lectura o escritura en una página de protección hace que el sistema genere una excepción de STATUS_GUARD_PAGE. Las páginas de protección actúan como una alarma de acceso único. Esta marca es un modificador de protección de páginas, válido solo cuando se usa con una de las marcas de protección de páginas distintas de PAGE_NOACCESS. Cuando un intento de acceso lleva al sistema a desactivar el estado de la página de protección, la protección de página subyacente se hace cargo. Si se produce una excepción de página de protección durante un servicio del sistema, el servicio normalmente devuelve un indicador de estado de error. |
| PAGE_NOCACHE      | La región de las páginas debe asignarse como noquecheable. no se permite PAGE_NOCACHE para las secciones.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| PAGE_WRITECOMBINE | Permite la combinación de escritura, es decir, la fusión de escrituras de la memoria caché a la memoria principal, donde el hardware lo admite. Esta marca se usa principalmente para la memoria del búfer de fotogramas para que las escrituras en la misma línea de caché se combinen siempre que sea posible antes de escribirse en el dispositivo. Esto puede reducir considerablemente las escrituras en el bus a la memoria de vídeo (por ejemplo). Si el hardware no admite la combinación de escritura, se omite la marca. Esta marca es un modificador de protección de páginas, válido solo cuando se usa con una de las marcas de protección de páginas distintas de PAGE_NOACCESS.                                              |

## Valor devuelto

**NtAllocateVirtualMemory** devuelve STATUS_SUCCESS o un código de estado de error. Entre los posibles códigos de estado de error se incluyen los siguientes:

- **STATUS_ACCESS_DENIED**
- **STATUS_ALREADY_COMMITTED**
- **STATUS_COMMITMENT_LIMIT**
- **STATUS_CONFLICTING_ADDRESSES**
- **STATUS_INSUFFICIENT_RESOURCES**
- **STATUS_INVALID_HANDLE**
- **STATUS_INVALID_PAGE_PROTECTION**
- **STATUS_NO_MEMORY**
- **STATUS_OBJECT_TYPE_MISMATCH**
- **STATUS_PROCESS_IS_TERMINATING**

## Comentarios

NtAllocateVirtualMemory puede realizar las siguientes operaciones:

- Confirme una región de páginas reservadas por una llamada anterior a NtAllocateVirtualMemory.
- Reserva una región de páginas gratuitas.
- Reserve y confirme una región de páginas gratuitas.
  Los controladores en modo kernel pueden usar NtAllocateVirtualMemory para reservar un intervalo de direcciones virtuales accesibles para la aplicación en el proceso especificado y, a continuación, realizar llamadas adicionales a NtAllocateVirtualMemory para confirmar páginas individuales desde el intervalo reservado. Esto permite que un proceso reserve un intervalo de su espacio de direcciones virtuales sin consumir almacenamiento físico hasta que sea necesario.

Cada página del espacio de direcciones virtuales del proceso se encuentra en uno de los tres estados descritos en la tabla siguiente.

|                                   |                                                                  |
| :-------------------------------- | ---------------------------------------------------------------- |
| **Cliente mínimo compatible**     | Windows 2000                                                     |
| **Plataforma de destino**         | Universal                                                        |
| **Encabezado**                    | ntifs.h (incluya Ntifs.h)                                        |
| **Library**                       | NtosKrnl.lib                                                     |
| **Archivo DLL**                   | NtosKrnl.exe                                                     |
| **IRQL**                          | PASSIVE_LEVEL                                                    |
| **Reglas de cumplimiento de DDI** | HwStorPortProhibitedDIs, PowerIrpDDis, SpNoWait, StorPortStartIo |

---

## Implementacion

```c
NTSTATUS __stdcall NtAllocateVirtualMemory(
    HANDLE     ProcessHandle,
    PVOID     *BaseAddress,
    ULONG_PTR ZeroBits,
    PSIZE_T   RegionSize,
    ULONG     AllocationType,
    ULONG     Protect
){
    uint64_t  v8 = 0;                               // r14
    char      PreviousMode;                         // bl
    int64_t   _BaseAddress_;                        // rcx
    int64_t   variable_muerta0;                     // rcx                      // codigo muerto
    PVOID     _BaseAddress_;                        // rdi
    int64_t   _RegionSize_;                         // rsi
    NTSTATUS  VirtualMemoryPrepare;                 // ebx // codigo de estado

    uint8_t   PreviousModeCurrentThread;            // [rsp+70h] [rbp-138h]
    uint64_t  v17;                                  // [rsp+78h] [rbp-130h] BYREF
    PVOID     v18;                                  // [rsp+80h] [rbp-128h] BYREF
    PVOID     variable_muerta1 = 0;                 // [rsp+88h] [rbp-120h]      // codigo muerto
    ULONG_PTR variable_muerta2 = 0;                 // [rsp+90h] [rbp-118h]      // codigo muerto
    PVOID     Object[3];                            // [rsp+98h] [rbp-110h] BYREF
    int64_t   v22[10];                              // [rsp+B0h] [rbp-F8h] BYREF
    int64_t   v23[16];                              // [rsp+100h] [rbp-A8h] BYREF
    HANDLE    _ProcessHandle_ = (int)ProcessHandle; // [rsp+1B0h] [rbp+8h]
    ULONG_PTR _ZeroBits_ = ZeroBits;                // [rsp+1C0h] [rbp+18h]

    memset(v22, 0, 0x48);                              // poner la memoria a 0
    PreviousMode = KeGetCurrentThread()->PreviousMode; // obtener el modo anterior del hilo actual
    PreviousModeCurrentThread = PreviousMode;
    if ( PreviousMode )
    {
        _BaseAddress_ = (int64_t)BaseAddress;

        if ( (uint64_t)BaseAddress >= 0x7FFFFFFF0000 ) _BaseAddress_ = 0x7FFFFFFF0000;
        *(_QWORD *)_BaseAddress_ = *(_QWORD *)_BaseAddress_;      // codigo muerto
        
        _RegionSize_ = (int64_t)RegionSize;                     

        if ( (uint64_t)RegionSize >= 0x7FFFFFFF0000 ) variable_muerta0 = 0x7FFFFFFF0000; // codigo muerto
        *(_QWORD *)variable_muerta0 = *(_QWORD *)variable_muerta0; // codigo muerto
    }
    _BaseAddress_    = *BaseAddress;
    variable_muerta1 = *BaseAddress; // codigo muerto
    _RegionSize_     = *RegionSize;
    variable_muerta2 = *RegionSize;  // codigo muerto

    LODWORD(v22[4]) = AllocationType & 0x7F;
    if ( (AllocationType & 0x44000) != 0 ) return STATUS_INVALID_PARAMETER; // return 0xc000000d(-1073741811)
    memset(v23, 0, sizeof(v23));                        
    v18 = 0;
    Object[0] = 0;
    v17 = 0;
    VirtualMemoryPrepare = MiAllocateVirtualMemoryPrepare(
                            _ProcessHandle_,
                            (DWORD)_BaseAddress_,
                            _ZeroBits_,
                            _RegionSize_,
                            AllocationType & 0xFFFFFF80,
                            Protect,
                            (int64_t)v22,
                            PreviousMode,
                            0,
                            0,
                            0,
                            (int64_t)v23,
                            (int64_t)Object);
    if ( VirtualMemoryPrepare >= 0 )
    {
        if ( v22[3] )
        {
        if ( v22[3] == -3 )
        {
            v8 = 1; // si v8 se pone en 1 ocurrio un STATUS_INVALID_PARAMETER
            v17 = 1;
        }
        else
        {
            VirtualMemoryPrepare = PsReferencePartitionByHandle(v22[3], 2, PreviousModeCurrentThread, 1633054029, &v17);
            v8 = v17;
            if ( VirtualMemoryPrepare < 0 )
            goto LABEL_13;
        }
        }
        if ( LOBYTE(v22[6]) == 1 && (AllocationType & (MEM_LARGE_PAGES | MEM_PHYSICAL)) != MEM_PHYSICAL ) // MEM_LARGE_PAGES(0x20000000) | MEM_PHYSICAL(0x00400000)
        {
        VirtualMemoryPrepare = STATUS_INVALID_PARAMETER; // VirtualMemoryPrepare = 0xc000000d(-1073741811)
    LABEL_21:
            if ( v23[0] )
                ++dword_140C4E6EC;
            else
                ++dword_140C4E6E8;
            goto LABEL_14;
            }
            VirtualMemoryPrepare = MiAllocateVirtualMemory(v23, v8, &v18);
            if ( VirtualMemoryPrepare >= 0 )
            {
                _BaseAddress_ = v18;
                variable_muerta1 = v18;     // codigo muerto
                _RegionSize_ = v23[3];
                variable_muerta2 = v23[3];  // codigo muerto
            }
        }
        LABEL_13:
            if ( VirtualMemoryPrepare < 0 ) goto LABEL_21;

            LABEL_14:
                if ( v8 >= 2 ) PsDereferencePartition(v8);

                // si el contador del objeto no es nulo, se decrementa 
                if ( Object[0] ) ObfDereferenceObjectWithTag(Object[0], 0x6D566D4D);
                /*
                    Las regiones de memoria son creados como objetos del kernel donde este le sigue y estan gobernados bajo
                    el tag 0x6D566D4D o MmVm

                    Mm = Memory Manager ?
                    Vm = Virtual Memory ?

                    https://learn.microsoft.com/es-es/windows-hardware/drivers/kernel/object-reference-tracing-with-tags

                    https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/nf-wdm-obdereferenceobjectwithtag

                    void ObDereferenceObjectWithTag(
                        [in]  a,
                        [in]  t
                    );

                    La rutina ObDereferenceObjectWithTag disminuye el recuento de referencias del objeto especificado y escribe un valor de etiqueta de cuatro bytes en el objeto para soportar el rastreo de referencias de objetos.

                    [in] a
                    Un puntero al objeto. La persona que llama obtiene este puntero cuando crea el objeto, o de una llamada previa a la rutina ObReferenceObjectByHandleWithTag después de abrir el objeto.

                    [in] t
                    Especifica un valor de etiqueta personalizado de cuatro bytes. Para más información, consulte la siguiente sección Observaciones.
                 */
                if ( VirtualMemoryPrepare >= 0 )
                {
                    *BaseAddress = _BaseAddress_;
                    *RegionSize = _RegionSize_;
                }
                return VirtualMemoryPrepare;
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

#include <stdint.h>
#include <stdio.h>
#include <windows.h>
#include <string.h>

#pragma comment(lib, "ntdll")

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

#define NT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
#define NtCurrentProcess() ((HANDLE)(LONG_PTR)-1)

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
