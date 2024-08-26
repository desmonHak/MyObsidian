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