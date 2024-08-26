```c
#define WIN32_CLIENT_INFO_LENGTH 62
#define STATIC_UNICODE_BUFFER_LENGTH 261

typedef struct _TEB_thread
{
    PNT_TIB NtTib;

    PVOID EnvironmentPointer;
    CLIENT_ID ClientId;
    PVOID ActiveRpcHandle;
    PVOID ThreadLocalStoragePointer;
    PPEB_process ProcessEnvironmentBlock;

    ULONG LastErrorValue;
    ULONG CountOfOwnedCriticalSections;
    PVOID CsrClientThread;
    PVOID Win32ThreadInfo;
    ULONG User32Reserved[26];
    ULONG UserReserved[5];
    PVOID WOW32Reserved;
    LCID CurrentLocale;
    ULONG FpSoftwareStatusRegister;
    PVOID ReservedForDebuggerInstrumentation[16];

	#ifdef _WIN64
	    PVOID SystemReserved1[25];
	    PVOID HeapFlsData;
	    ULONG_PTR RngState[4];
	#else
	    PVOID SystemReserved1[26];
	#endif

    CHAR PlaceholderCompatibilityMode;
    BOOLEAN PlaceholderHydrationAlwaysExplicit;
    CHAR PlaceholderReserved[10];

    ULONG ProxiedProcessId;
    ACTIVATION_CONTEXT_STACK_C ActivationStack;
  
    UCHAR WorkingOnBehalfTicket[8];

    NTSTATUS ExceptionCode;

    PACTIVATION_CONTEXT_STACK_C ActivationContextStackPointer;
    ULONG_PTR InstrumentationCallbackSp;
    ULONG_PTR InstrumentationCallbackPreviousPc;
    ULONG_PTR InstrumentationCallbackPreviousSp;

	#ifdef _WIN64
		ULONG TxFsContext;
	#endif
	
	BOOLEAN InstrumentationCallbackDisabled;

	#ifdef _WIN64
		BOOLEAN UnalignedLoadStoreExceptions;
	#endif

	#ifndef _WIN64
		UCHAR SpareBytes[23];
		ULONG TxFsContext;
	#endif

    GDI_TEB_BATCH GdiTebBatch;
    CLIENT_ID RealClientId;
    HANDLE GdiCachedProcessHandle;
    ULONG GdiClientPID;
    ULONG GdiClientTID;
    PVOID GdiThreadLocalInfo;

    ULONG_PTR Win32ClientInfo[WIN32_CLIENT_INFO_LENGTH];

    PVOID glDispatchTable[233];
    ULONG_PTR glReserved1[29];
    PVOID glReserved2;
    PVOID glSectionInfo;
    PVOID glSection;
    PVOID glTable;
    PVOID glCurrentRC;
    PVOID glContext;

    NTSTATUS LastStatusValue;
    UNICODE_STRING_C StaticUnicodeString;

    WCHAR StaticUnicodeBuffer[STATIC_UNICODE_BUFFER_LENGTH];

    PVOID DeallocationStack;

    PVOID TlsSlots[TLS_MINIMUM_AVAILABLE];
    LIST_ENTRY TlsLinks;

    PVOID Vdm;
    PVOID ReservedForNtRpc;
    PVOID DbgSsReserved[2];

    ULONG HardErrorMode;
    
	#ifdef _WIN64
		PVOID Instrumentation[11];
	#else
		PVOID Instrumentation[9];
	#endif

	GUID ActivityId;
	PVOID SubProcessTag;
	PVOID PerflibData;

	PVOID EtwTraceData;
	PVOID WinSockData;
	ULONG GdiBatchCount;

	union {
		PROCESSOR_NUMBER CurrentIdealProcessor;
		ULONG IdealProcessorValue;
		struct {
			UCHAR ReservedPad0;
			UCHAR ReservedPad1;
			UCHAR ReservedPad2;
			UCHAR IdealProcessor;
		};
	};

    ULONG GuaranteedStackBytes;
    PVOID ReservedForPerf;
    PVOID ReservedForOle; // tagSOleTlsData
    ULONG WaitingOnLoaderLock;
    PVOID SavedPriorityState;
    ULONG_PTR ReservedForCodeCoverage;
    PVOID ThreadPoolData;
    PVOID *TlsExpansionSlots;

	#ifdef _WIN64
		PVOID ChpeV2CpuAreaInfo; // CHPEV2_CPUAREA_INFO 
							     // previously DeallocationBStore
	    PVOID Unused;            // previously BStoreLimit
	#endif

    ULONG MuiGeneration;
    ULONG IsImpersonating;
    PVOID NlsCache;
    PVOID pShimData;
    ULONG HeapData;
    HANDLE CurrentTransactionHandle;
    PTEB_ACTIVE_FRAME ActiveFrame;
    PVOID FlsData;

    PVOID PreferredLanguages;
    PVOID UserPrefLanguages;
    PVOID MergedPrefLanguages;
    ULONG MuiImpersonation;

	union {
		USHORT CrossTebFlags;
		USHORT SpareCrossTebBits : 16;
	};

	union {
        USHORT SameTebFlags;
        struct {
            USHORT SafeThunkCall : 1;
            USHORT InDebugPrint : 1;
            USHORT HasFiberData : 1;
            USHORT SkipThreadAttach : 1;
            USHORT WerInShipAssertCode : 1;
            USHORT RanProcessInit : 1;
            USHORT ClonedThread : 1;
            USHORT SuppressDebugMsg : 1;
            USHORT DisableUserStackWalk : 1;
            USHORT RtlExceptionAttached : 1;
            USHORT InitialThread : 1;
            USHORT SessionAware : 1;
            USHORT LoadOwner : 1;
            USHORT LoaderWorker : 1;
            USHORT SkipLoaderInit : 1;
            USHORT SkipFileAPIBrokering : 1;
        };
    };

    PVOID TxnScopeEnterCallback;
    PVOID TxnScopeExitCallback;
    PVOID TxnScopeContext;
    ULONG LockCount;
    LONG WowTebOffset;
    PVOID ResourceRetValue;
    PVOID ReservedForWdf;
    ULONGLONG ReservedForCrt;
    GUID EffectiveContainerId;
    ULONGLONG LastSleepCounter; // Win11
    ULONG SpinCallCount;
    ULONGLONG ExtendedFeatureDisableMask;
    PVOID SchedulerSharedDataSlot; // 24H2
    PVOID HeapWalkContext;
    GROUP_AFFINITY PrimaryGroupAffinity;
    ULONG Rcu[2];
} TEB_thread, *PTEB_thread;

#endif
```

La estructura [[TEB]] contiene una estructura [[TIB|TIB- (Thread Information Block)]] Con la información del bloque de subproceso/hilo:
```c
NT_TIB NtTib;
```

La estructura [[TEB]] contiene un puntero a una estructura de tipo [[PEB|PEB- (Process Environment Block)]]:
```c
PPEB_process ProcessEnvironmentBlock
```

Función para obtener el [[TEB]] con ensamblador via [[Registros de segmento en windows (gs & fs)]]:
```c
PTEB_thread My_NtCurrentTeb() {
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

El [[TEB]] contiene información sobre el grupo de núcleos, y el conjunto de núcleos del grupo en el que ejecutar el subproceso, además de valor ideales que indican en que grupo, numero y reserva de núcleos ideales correr.

El campo PrimaryGroupAffinity representa una afinidad específica de un grupo de nucleos, como la afinidad de un subproceso

```c
GROUP_AFFINITY PrimaryGroupAffinity;
```

[Informacion a la estructura de grupos de afinidad:](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-group_affinity)
```c
typedef struct _GROUP_AFFINITY {
  KAFFINITY Mask;
  WORD      Group;
  WORD      Reserved[3];
} GROUP_AFFINITY, *PGROUP_AFFINITY;
```
##   Members
`Mask`
Un mapa de bits que especifica la afinidad por cero o más procesadores dentro del grupo especificado.

`Group`
El número de grupo de procesadores.

`Reserved[3]`
Este miembro está reservado.