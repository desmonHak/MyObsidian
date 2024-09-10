
PEB en 32bits:
La PEB no puede ser referenciada directamente, pero en el caso de 32 bits, la [[TEB]] se obtiene a través del registro FS, y luego el offset ``0x30``, es decir, la dirección de la PEB se obtiene a través del valor contenido en el campo PEB.

```c
MOV EAX, DWORD PTR FS:[0x18]
MOV EAX, DWORD PTR DS:[EAX+0x30]
```

Arriba obtenemos la dirección de [[TEB]] directamente a través de FS:[0x18], y luego añadimos PEB sumando el offset ``0x30`` a esta dirección. O puedes usarlo directamente así:

```c
MOV EAX, DWORD PTR FS:[0x30]
```

Ahora que la dirección de la PEB está en EAX, los campos de la PEB también se suman a EAX para encontrar el campo deseado. A continuación, cubriré las rutinas en un entorno de 64 bits. En 64-bit, el registro GS es usado en lugar del registro FS, y el offset ``0x30`` tiene la dirección [[TEB]]. PEB también se encuentra en el offset de referencia [[TEB]] ``0x60``.

```c
MOV RAX, QWORD PTR GS:[0x30]
MOV RAX, QWORD PTR DS:[RAX+0x60]
```

Esto también se puede utilizar directamente de la siguiente manera:
```c
MOV RAX, QWORD PTR GS:[0x60]
```

A partir de x86, los miembros más comunes de PEB son:
```c
0x002 BYTE BeingDebugged;
0x008 void* ImageBaseAddress;
0x00C _PEB_LDR_DATA* Ldr;
0x018 void* ProcessHeap
0x064 DWORD NumberOfProcessors;
0x068 DWORD NtGlobalFlag;
```

^ab1f70

[PEB segun algun chino](https://sp4n9x.github.io/2021/04/14/TEB_and_PEB/)


```c
// https://sp4n9x.github.io/2021/04/14/TEB_and_PEB/
typedef struct PEB_process

{
    /*0x000 */ BYTE InheritedAddressSpace;
    /*0x001 */ BYTE ReadImageFileExecOptions;
    /*0x002 */ BYTE BeingDebugged;
    /*0x003 */ BYTE SpareBool;
    /*0x004 */ void *Mutant;
    /*0x008 */ void *ImageBaseAddress;
    /*0x00c */ PEB_process_LDR_DATA *Ldr;
    /*0x010 */ RTL_USER_PROCESS_PARAMETERS_C *ProcessParameters;
    /*0x014 */ void *SubSystemData;
    /*0x018 */ void *ProcessHeap;
    /*0x01c */ RTL_CRITICAL_SECTION_C *FastPebLock;
    /*0x020 */ void *FastPebLockRoutine;
    /*0x024 */ void *FastPebUnlockRoutine;
    /*0x028 */ DWORD EnvironmentUpdateCount;
    /*0x02c */ void *KernelCallbackTable;
    /*0x030 */ DWORD SystemReserved[1];
    /*0x034 */ DWORD ExecuteOptions : 2; // bit offset: 34, len=2
    /*0x034 */ DWORD SpareBits : 30;     // bit offset: 34, len=30
    /*0x038 */ PEB_FREE_BLOCK_C *FreeList;
    /*0x03c */ DWORD TlsExpansionCounter;
    /*0x040 */ void *TlsBitmap;
    /*0x044 */ DWORD TlsBitmapBits[2];
    /*0x04c */ void *ReadOnlySharedMemoryBase;
    /*0x050 */ void *ReadOnlySharedMemoryHeap;
    /*0x054 */ void **ReadOnlyStaticServerData;
    /*0x058 */ void *AnsiCodePageData;
    /*0x05c */ void *OemCodePageData;
    /*0x060 */ void *UnicodeCaseTableData;
    /*0x064 */ DWORD NumberOfProcessors;
    /*0x068 */ DWORD NtGlobalFlag;
    /*0x070 */ LARGE_INTEGER_C CriticalSectionTimeout;
    /*0x078 */ DWORD HeapSegmentReserve;
    /*0x07c */ DWORD HeapSegmentCommit;
    /*0x080 */ DWORD HeapDeCommitTotalFreeThreshold;
    /*0x084 */ DWORD HeapDeCommitFreeBlockThreshold;
    /*0x088 */ DWORD NumberOfHeaps;
    /*0x08c */ DWORD MaximumNumberOfHeaps;
    /*0x090 */ void **ProcessHeaps;
    /*0x094 */ void *GdiSharedHandleTable;
    /*0x098 */ void *ProcessStarterHelper;
    /*0x09c */ DWORD GdiDCAttributeList;
    /*0x0a0 */ void *LoaderLock;
    /*0x0a4 */ DWORD OSMajorVersion;
    /*0x0a8 */ DWORD OSMinorVersion;
    /*0x0ac */ WORD OSBuildNumber;
    /*0x0ae */ WORD OSCSDVersion;
    /*0x0b0 */ DWORD OSPlatformId;
    /*0x0b4 */ DWORD ImageSubsystem;
    /*0x0b8 */ DWORD ImageSubsystemMajorVersion;
    /*0x0bc */ DWORD ImageSubsystemMinorVersion;
    /*0x0c0 */ DWORD ImageProcessAffinityMask;
    /*0x0c4 */ DWORD GdiHandleBuffer[34];
    /*0x14c */ void (*PostProcessInitRoutine)();
    /*0x150 */ void *TlsExpansionBitmap;
    /*0x154 */ DWORD TlsExpansionBitmapBits[32];
    /*0x1d4 */ DWORD SessionId;
    /*0x1d8 */ LARGE_INTEGER_C AppCompatFlags;
    /*0x1e0 */ LARGE_INTEGER_C AppCompatFlagsUser;
    /*0x1e8 */ void *pShimData;
    /*0x1ec */ void *AppCompatInfo;
    /*0x1f0 */ UNICODE_STRING_C CSDVersion;
    /*0x1f8 */ void *ActivationContextData;
    /*0x1fc */ void *ProcessAssemblyStorageMap;
    /*0x200 */ void *SystemDefaultActivationContextData;
    /*0x204 */ void *SystemAssemblyStorageMap;
    /*0x208 */ DWORD MinimumStackCommit;
} PEB_process, *PPEB_process;
```

^0195c6


```c
// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_PEB
//0x7d0 bytes (sizeof) 
struct _PEB { 
	UCHAR InheritedAddressSpace; //0x0 UCHAR ReadImageFileExecOptions; //0x1 
	UCHAR BeingDebugged; //0x2 
	union { 
		UCHAR BitField; //0x3 
		struct { 
			UCHAR ImageUsesLargePages:1; //0x3 
			UCHAR IsProtectedProcess:1; //0x3 
			UCHAR IsImageDynamicallyRelocated:1; //0x3 
			UCHAR SkipPatchingUser32Forwarders:1; //0x3 
			UCHAR IsPackagedProcess:1; //0x3 
			UCHAR IsAppContainer:1; //0x3 
			UCHAR IsProtectedProcessLight:1; //0x3 
			UCHAR IsLongPathAwareProcess:1; //0x3 
		}; 
	}; 
	UCHAR Padding0[4]; //0x4 
	VOID* Mutant; //0x8 
	VOID* ImageBaseAddress; //0x10 
	struct _PEB_LDR_DATA Ldr; //0x18 struct 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_PEB_LDR_DATA
	
	struct _RTL_USER_PROCESS_PARAMETERS * ProcessParameters; //0x20 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_RTL_USER_PROCESS_PARAMETERS
	
	VOID* SubSystemData; //0x28 
	VOID* ProcessHeap; //0x30 
	struct _RTL_CRITICAL_SECTION* FastPebLock; //0x38 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_RTL_CRITICAL_SECTION
	union _SLIST_HEADER* volatile AtlThunkSListPtr; //0x40 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_SLIST_HEADER
	VOID* IFEOKey; //0x48 
	union { 
		ULONG CrossProcessFlags; //0x50 
		struct { 
			ULONG ProcessInJob:1; //0x50 
			ULONG ProcessInitializing:1; //0x50 
			ULONG ProcessUsingVEH:1; //0x50 
			ULONG ProcessUsingVCH:1; //0x50 
			ULONG ProcessUsingFTH:1; //0x50 
			ULONG ProcessPreviouslyThrottled:1; //0x50 
			ULONG ProcessCurrentlyThrottled:1; //0x50 
			ULONG ProcessImagesHotPatched:1; //0x50 
			ULONG ReservedBits0:24; //0x50 
		}; 
	}; 
	UCHAR Padding1[4]; //0x54 
	union { 
		VOID* KernelCallbackTable; //0x58 
		VOID* UserSharedInfoPtr; //0x58 
	}; 
	ULONG SystemReserved; //0x60 
	ULONG AtlThunkSListPtr32; //0x64 
	VOID* ApiSetMap; //0x68 
	ULONG TlsExpansionCounter; //0x70 
	UCHAR Padding2[4]; //0x74 
	struct _RTL_BITMAP* TlsBitmap; //0x78 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_RTL_BITMAP
	
	ULONG TlsBitmapBits[2]; //0x80 
	VOID* ReadOnlySharedMemoryBase; //0x88 
	VOID* SharedData; //0x90 
	VOID** ReadOnlyStaticServerData; //0x98 
	VOID* AnsiCodePageData; //0xa0 
	VOID* OemCodePageData; //0xa8 
	VOID* UnicodeCaseTableData; //0xb0 
	ULONG NumberOfProcessors; //0xb8 
	ULONG NtGlobalFlag; //0xbc 
	union _LARGE_INTEGER CriticalSectionTimeout; //0xc0 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_LARGE_INTEGER
	
	ULONGLONG HeapSegmentReserve; //0xc8 
	ULONGLONG HeapSegmentCommit; //0xd0 
	ULONGLONG HeapDeCommitTotalFreeThreshold; //0xd8 
	ULONGLONG HeapDeCommitFreeBlockThreshold; //0xe0 
	ULONG NumberOfHeaps; //0xe8 
	ULONG MaximumNumberOfHeaps; //0xec 
	VOID** ProcessHeaps; //0xf0 
	VOID* GdiSharedHandleTable; //0xf8 
	VOID* ProcessStarterHelper; //0x100 
	ULONG GdiDCAttributeList; //0x108 
	UCHAR Padding3[4]; //0x10c 
	struct _RTL_CRITICAL_SECTION* LoaderLock; //0x110 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_RTL_CRITICAL_SECTION
	
	ULONG OSMajorVersion; //0x118 
	ULONG OSMinorVersion; //0x11c 
	USHORT OSBuildNumber; //0x120 
	USHORT OSCSDVersion; //0x122 
	ULONG OSPlatformId; //0x124 
	ULONG ImageSubsystem; //0x128 
	ULONG ImageSubsystemMajorVersion; //0x12c 
	ULONG ImageSubsystemMinorVersion; //0x130 
	UCHAR Padding4[4]; //0x134 
	ULONGLONG ActiveProcessAffinityMask; //0x138 
	ULONG GdiHandleBuffer[60]; //0x140 
	VOID (*PostProcessInitRoutine)(); //0x230 
	struct _RTL_BITMAP* TlsExpansionBitmap; //0x238 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_RTL_BITMAP
	ULONG TlsExpansionBitmapBits[32]; //0x240 
	ULONG SessionId; //0x2c0 
	UCHAR Padding5[4]; //0x2c4 
	union _ULARGE_INTEGER AppCompatFlags; //0x2c8 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_ULARGE_INTEGER
	
	union _ULARGE_INTEGER AppCompatFlagsUser; //0x2d0 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_ULARGE_INTEGER
	
	VOID* pShimData; //0x2d8 
	VOID* AppCompatInfo; //0x2e0 
	struct _UNICODE_STRING CSDVersion; //0x2e8 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_UNICODE_STRING
	
	struct _ACTIVATION_CONTEXT_DATA* ActivationContextData; //0x2f8 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_ACTIVATION_CONTEXT_DATA
	
	struct _ASSEMBLY_STORAGE_MAP* ProcessAssemblyStorageMap; //0x300 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_ASSEMBLY_STORAGE_MAP
	
	struct _ACTIVATION_CONTEXT_DATA* SystemDefaultActivationContextData; //0x308 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_ACTIVATION_CONTEXT_DATA
	
	struct _ASSEMBLY_STORAGE_MAP* SystemAssemblyStorageMap; //0x310 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_ASSEMBLY_STORAGE_MAP
	
	ULONGLONG MinimumStackCommit; //0x318 
	VOID* SparePointers[2]; //0x320 
	VOID* PatchLoaderData; //0x330 
	struct _CHPEV2_PROCESS_INFO* ChpeV2ProcessInfo; //0x338 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_CHPEV2_PROCESS_INFO
	ULONG AppModelFeatureState; //0x340 
	ULONG SpareUlongs[2]; //0x344 
	USHORT ActiveCodePage; //0x34c 
	USHORT OemCodePage; //0x34e 
	USHORT UseCaseMapping; //0x350 
	USHORT UnusedNlsField; //0x352 
	VOID* WerRegistrationData; //0x358 
	VOID* WerShipAssertPtr; //0x360 
	VOID* EcCodeBitMap; //0x368 
	VOID* pImageHeaderHash; //0x370 
	union { 
		ULONG TracingFlags; //0x378 
		struct { 
			ULONG HeapTracingEnabled:1; //0x378
			ULONG CritSecTracingEnabled:1; //0x378 
			ULONG LibLoaderTracingEnabled:1; //0x378 
			ULONG SpareTracingBits:29; //0x378 
		}; 
	}; 
	UCHAR Padding6[4]; //0x37c 
	ULONGLONG CsrServerReadOnlySharedMemoryBase; //0x380 
	ULONGLONG TppWorkerpListLock; //0x388 
	struct _LIST_ENTRY TppWorkerpList; //0x390 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_LIST_ENTRY
	
	VOID* WaitOnAddressHashTable[128]; //0x3a0 
	VOID* TelemetryCoverageHeader; //0x7a0 
	ULONG CloudFileFlags; //0x7a8 
	ULONG CloudFileDiagFlags; //0x7ac 
	CHAR PlaceholderCompatibilityMode; //0x7b0 
	CHAR PlaceholderCompatibilityModeReserved[7]; //0x7b1 
	struct _LEAP_SECOND_DATA* LeapSecondData; //0x7b8 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_LEAP_SECOND_DATA
	
	union { 
		ULONG LeapSecondFlags; //0x7c0
		struct { 
			ULONG SixtySecondEnabled:1; //0x7c0 
			ULONG Reserved:31; //0x7c0 
		}; 
	}; 
	ULONG NtGlobalFlag2; //0x7c4 
	ULONGLONG ExtendedFeatureDisableMask; //0x7c8 
};
```

```c
PTEB_thread My_NtCurrentTeb()
{
	PTEB_thread teb;
	
	// Para sistemas de 64 bits
	#if defined(_M_X64) || defined(__x86_64__)
    __asm__("movq %%gs:0x30, %0" : "=r"(teb));

	// Para sistemas de 32 bits
	#elif defined(_M_IX86) || defined(__i386__)
    __asm__("movl %%fs:0x18, %0" : "=r"(teb));
    
	#else
	#error "Unsupported architecture"
	#endif
	
	return teb;
}
```
Se puede situar información de los registros de segmentos usados aquí: [[Registros de segmento en Windows (GS & FS)]].


Imprimir PEB:
```c
void PrintPEB_process(PEB_process *peb)

{

    if (!peb) {
        printf("PEB_process is NULL.\n");
        return;
    }

    printf("PEB_process:\n");
    printf("  InheritedAddressSpace: %u\n", peb->InheritedAddressSpace);
    printf("  ReadImageFileExecOptions: %u\n", peb->ReadImageFileExecOptions);
    printf("  BeingDebugged: %u\n", peb->BeingDebugged);
    printf("  SpareBool: %u\n", peb->SpareBool);
    printf("  Mutant: %p\n", peb->Mutant);
    printf("  ImageBaseAddress: %p\n", peb->ImageBaseAddress);
    printf("  Ldr: %p\n", peb->Ldr);
    printf("  ProcessParameters: %p\n", peb->ProcessParameters);
    printf("  SubSystemData: %p\n", peb->SubSystemData);
    printf("  ProcessHeap: %p\n", peb->ProcessHeap);
    printf("  FastPebLock: %p\n", peb->FastPebLock);
    printf("  FastPebLockRoutine: %p\n", peb->FastPebLockRoutine);
    printf("  FastPebUnlockRoutine: %p\n", peb->FastPebUnlockRoutine);
    printf("  EnvironmentUpdateCount: %u\n", peb->EnvironmentUpdateCount);
    printf("  KernelCallbackTable: %p\n", peb->KernelCallbackTable);
    printf("  SystemReserved[0]: %u\n", peb->SystemReserved[0]);
    printf("  ExecuteOptions: %u\n", peb->ExecuteOptions);
    printf("  SpareBits: %u\n", peb->SpareBits);
    printf("  FreeList: %p\n", peb->FreeList);
    printf("  TlsExpansionCounter: %u\n", peb->TlsExpansionCounter);
    printf("  TlsBitmap: %p\n", peb->TlsBitmap);
    printf("  TlsBitmapBits[0]: %u\n", peb->TlsBitmapBits[0]);
    printf("  TlsBitmapBits[1]: %u\n", peb->TlsBitmapBits[1]);
    printf("  ReadOnlySharedMemoryBase: %p\n", peb->ReadOnlySharedMemoryBase);
    printf("  ReadOnlySharedMemoryHeap: %p\n", peb->ReadOnlySharedMemoryHeap);
    printf("  ReadOnlyStaticServerData: %p\n", peb->ReadOnlyStaticServerData);
    printf("  AnsiCodePageData: %p\n", peb->AnsiCodePageData);
    printf("  OemCodePageData: %p\n", peb->OemCodePageData);
    printf("  UnicodeCaseTableData: %p\n", peb->UnicodeCaseTableData);
    printf("  NumberOfProcessors: %u\n", peb->NumberOfProcessors);
    printf("  NtGlobalFlag: %u\n", peb->NtGlobalFlag);
    printf("  CriticalSectionTimeout.QuadPart: %lld\n", peb->CriticalSectionTimeout.QuadPart);
    printf("  HeapSegmentReserve: %u\n", peb->HeapSegmentReserve);
    printf("  HeapSegmentCommit: %u\n", peb->HeapSegmentCommit);
    printf("  HeapDeCommitTotalFreeThreshold: %u\n", peb->HeapDeCommitTotalFreeThreshold);
    printf("  HeapDeCommitFreeBlockThreshold: %u\n", peb->HeapDeCommitFreeBlockThreshold);
    printf("  NumberOfHeaps: %u\n", peb->NumberOfHeaps);
    printf("  MaximumNumberOfHeaps: %u\n", peb->MaximumNumberOfHeaps);
    printf("  ProcessHeaps: %p\n", peb->ProcessHeaps);
    printf("  GdiSharedHandleTable: %p\n", peb->GdiSharedHandleTable);
    printf("  ProcessStarterHelper: %p\n", peb->ProcessStarterHelper);
    printf("  GdiDCAttributeList: %u\n", peb->GdiDCAttributeList);
    printf("  LoaderLock: %p\n", peb->LoaderLock);
    printf("  OSMajorVersion: %u\n", peb->OSMajorVersion);
    printf("  OSMinorVersion: %u\n", peb->OSMinorVersion);
    printf("  OSBuildNumber: %u\n", peb->OSBuildNumber);
    printf("  OSCSDVersion: %u\n", peb->OSCSDVersion);
    printf("  OSPlatformId: %u\n", peb->OSPlatformId);
    printf("  ImageSubsystem: %u\n", peb->ImageSubsystem);
    printf("  ImageSubsystemMajorVersion: %u\n", peb->ImageSubsystemMajorVersion);
    printf("  ImageSubsystemMinorVersion: %u\n", peb->ImageSubsystemMinorVersion);
    printf("  ImageProcessAffinityMask: %u\n", peb->ImageProcessAffinityMask);
    printf("  GdiHandleBuffer[0]: %u\n", peb->GdiHandleBuffer[0]);

    // Continue printing other fields similarly
    printf("  PostProcessInitRoutine: %p\n", peb->PostProcessInitRoutine);
    printf("  TlsExpansionBitmap: %p\n", peb->TlsExpansionBitmap);
    printf("  TlsExpansionBitmapBits[0]: %u\n", peb->TlsExpansionBitmapBits[0]);

    // Continue for all TlsExpansionBitmapBits elements
    printf("  SessionId: %u\n", peb->SessionId);
    printf("  AppCompatFlags.QuadPart: %lld\n", peb->AppCompatFlags.QuadPart);
    printf("  AppCompatFlagsUser.QuadPart: %lld\n", peb->AppCompatFlagsUser.QuadPart);
    printf("  pShimData: %p\n", peb->pShimData);
    printf("  AppCompatInfo: %p\n", peb->AppCompatInfo);
    printf("  CSDVersion.Length: %u\n", peb->CSDVersion.Length);
    printf("  CSDVersion.MaximumLength: %u\n", peb->CSDVersion.MaximumLength);
    printf("  CSDVersion.Buffer: %p\n", peb->CSDVersion.Buffer);
    printf("  ActivationContextData: %p\n", peb->ActivationContextData);
    printf("  ProcessAssemblyStorageMap: %p\n", peb->ProcessAssemblyStorageMap);
    printf("  SystemDefaultActivationContextData: %p\n", peb->SystemDefaultActivationContextData);
    printf("  SystemAssemblyStorageMap: %p\n", peb->SystemAssemblyStorageMap);
    printf("  MinimumStackCommit: %u\n", peb->MinimumStackCommit);

}
```

El [[PEB]] contiene un miembro ImageProcessAffinityMask el cual indica la mascara de afinidad del proceso:
```c
/*0x0c0 */ DWORD ImageProcessAffinityMask;
```
Este valor puede ser cambiado con [[SetProcessAffinityMask - Cambiar afinidad de un proceso]].
