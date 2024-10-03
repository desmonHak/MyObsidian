http://www.flounder.com/cpuid_explorer2.htm#CPUID(1):EAX
Vea [[Obtener_modelo_cpu_intel]]

- Información Básica extendida. Esta pagina extiende la información de la pagina [[CPUID(0)]]

# CPUID(1).EAX
Obtiene modelo y familia de la CPU
##### Intel:

| 31    28 | 27            20 | 19      16 | 15 14     | 13 12 | 11     8 | 7      4 | 3      0 |
| -------- | ---------------- | ---------- | --------- | ----- | -------- | -------- | -------- |
| Reserved | Extended family  | Extmodel   | Reserved2 | type  | familyid | model    | stepping |
Valor de ejemplo ``0xB0671``, no se obtiene directamente de la instrucción CPUID, sino que es una representación condensada
1. El valor 0xB0671 se construye de la siguiente manera:    
    - Bits 0-3 (0001): Stepping ID
    - Bits 4-7 (0111): Model Number
    - Bits 8-11 (0110): Family Code
    - Bits 12-13 (00): Processor Type
    - Bits 16-19 (1011): Extended Model
    - Bits 20-27 (00000011): Extended Family
    
2. En hexadecimal, esto se representa como 0xB0671.

##### AMD:

| 31    28 | 27       20     | 19    16 | 15 14     | 13 12     | 11     8 | 7      4 | 3      0 |
| -------- | --------------- | -------- | --------- | --------- | -------- | -------- | -------- |
| Reserved | Extended family | Extmodel | Reserved2 | Reserved2 | familyid | model    | stepping |

```c
typedef union {
   struct {                        // low order
		UINT SteppingID:4;         // 3..0
		UINT ModelID:4;            // 7..4
		UINT FamilyID:4;           // 11..8
		UINT ProcessorType:2;      // 13..12
		UINT Reserved2:2;          // 15..14
		UINT ExtendedModel:4;      // 19..16
		UINT ExtendedFamily:8;     // 27..20
		UINT Reserved:4;           // 31..28
	} Intel;                       // high order

   struct {                        // low order
		UINT SteppingID:4;         // 3..0
		UINT ModelID:4;            // 7..4
		UINT FamilyID:4;           // 11..8
		UINT Reserved2:4;          // 15..12
		UINT ExtendedModel:4;      // 19..16
		UINT ExtendedFamily:8;     // 27..20
		UINT Reserved:4;           // 31..28
	} AMD;                         // high order
	UINT w;
} EAX1b;
```

```
IDS_PROCESSOR_00B "Original OEM processor"
IDS_PROCESSOR_01B "Intel Overdrive ® processor"
IDS_PROCESSOR_10B "Dual processor"
IDS_PROCESSOR_11B "Intel reserved"
```
# CPUID(1).EBX


| 31            24    | 23            16  | 15             8     | 7              0 |
| ------------------- | ----------------- | -------------------- | ---------------- |
| Initial [[APIC]] ID | Logical Processor | [[CLFLUSH]] LineSize | Brand Index      |
```c
typedef union {
	struct { // low order
		UINT BrandIndex:8;
		UINT CLFLUSHLineSize:8;
		UINT LogicalProcessors:8;
		UINT InitialAPICID:8;
	} bits;  // high order
	UINT w;
} EBX1b;
```

```c
CPUregs regs;
GetCPUID(1, &regs);

EBX1b EBX;

EBX.w = regs.EBX;
UINT ComputedCLFLUSHLineSize = EBX.bits.CLFLUSHLineSize * 8;
UINT NumberOfLogicalProcessors = (EBX.bits.LogicalProcessors == 0 ? 1 : EBX.bits.LogicalProcessors);
```

```c
IDS_BRAND_INDEX_01H "Intel ® Celeron ® processor"
IDS_BRAND_INDEX_02H "Intel ® Pentium ® III processor"
IDS_BRAND_INDEX_03H "Intel ® Pentium ® III Xeon(tm) processor\nIntel ® Celeron ® processor"
IDS_BRAND_INDEX_04H "Intel ® Pentium ® III processor"
IDS_BRAND_INDEX_06H "Mobile Intel ® Pentium ® III processor-M"
IDS_BRAND_INDEX_07H "Mobile Intel ® Celeron ® processor"
IDS_BRAND_INDEX_08H "Intel ® Pentium ® 4 processor"
IDS_BRAND_INDEX_09H "Intel ® Pentium ® 4 processor"
IDS_BRAND_INDEX_0AH "Intel ® Celeron ® processor"
IDS_BRAND_INDEX_0BH "Intel ® Xeon(tm) processor\nIntel ® Xeon(tm) processor MP"
IDS_BRAND_INDEX_0CH "Intel ® Xeon(tm) processor MP"
IDS_BRAND_INDEX_0EH "Mobile Intel ® Pentium ® 4 processor\nIntel ® Xeon(tm) processor"
IDS_BRAND_INDEX_0FH "Mobile Intel ® Celeron ® processor"
IDS_BRAND_INDEX_11H "Mobile Genuine Intel ® processor"
IDS_BRAND_INDEX_12H "Intel ® Celeron ® M processor"
IDS_BRAND_INDEX_13H "Mobile Intel ® Celeron ® processor"
IDS_BRAND_INDEX_14H "Intel ® Celeron ® processor"
IDS_BRAND_INDEX_15H "Mobile Genuine Intel ® processor"
IDS_BRAND_INDEX_16H "Intel ® Pentium ® M processor"
IDS_BRAND_INDEX_17H "Mobile Intel ® Celeron ® processor"
```

# CPUID(1).ECX
Obtiene tecnologías de la CPU

##### Intel: ![[Pasted image 20240916220134.png]]
##### AMD:![[Pasted image 20240916220220.png]]
```c
typedef struct cpuid_feat_ecx {
    uint32_t SSE3       :1; // 00
    uint32_t PCLMUL     :1; // 01
    uint32_t DTES64     :1; // 02
    uint32_t MONITOR    :1; // 03
    uint32_t DS_CPL     :1; // 04 CPL-qualified debug store
    uint32_t VMX        :1; // 05 VMX technology
    uint32_t SMX        :1; // 06
    uint32_t EST        :1; // 07 Enhanced SpeedStep technology
    uint32_t TM2        :1; // 08 Thermal Monitor 2 supported
    uint32_t SSSE3      :1; // 09
    uint32_t CID        :1; // 10 L1 context ID supported
    uint32_t SDBG       :1; // 11
    uint32_t FMA        :1; // 12
    uint32_t CX16       :1; // 13 CompareAndExchange16B supported
    uint32_t XTPR       :1; // 14
    uint32_t PDCM       :1; // 15
    uint32_t RESERVADO  :1; // 16
    uint32_t PCID       :1; // 17
    uint32_t DCA        :1; // 18
    uint32_t SSE4_1     :1; // 19
    uint32_t SSE4_2     :1; // 20
    uint32_t X2APIC     :1; // 21
    uint32_t MOVBE      :1; // 22
    uint32_t POPCNT     :1; // 23
    uint32_t TSC        :1; // 24
    uint32_t AES        :1; // 25
    uint32_t XSAVE      :1; // 26
    uint32_t OSXSAVE    :1; // 27
    uint32_t AVX        :1; // 28
    uint32_t F16C       :1; // 29
    uint32_t RDRAND     :1; // 30
    uint32_t HYPERVISOR :1; // 31
} cpuid_feat_ecx;
```

# CPUID(1).EDC
Obtiene tecnologías de la CPU
![[Pasted image 20240916220511.png]]
```c
typedef struct cpuid_feat_edx {
    uint32_t FPU        :1; // 00 FPU87 on chip
    uint32_t VME        :1; // 01 Virtual 8086 extensions
    uint32_t DE         :1; // 02 Debugging extensions
    uint32_t PSE        :1; // 03 Page Size extensions
    uint32_t TSC        :1; // 04 TimeStamp Counter
    uint32_t MSR        :1; // 05 RDMSR/WRMSR support
    uint32_t PAE        :1; // 06 Physical Address Extension
    uint32_t MCE        :1; // 07 Machine Check Exception
    uint32_t CX8        :1; // 08 CMXCHG8B
    uint32_t APIC       :1; // 09 APIC on-chip
    uint32_t RESERVADO  :1; // 10 
    uint32_t SEP        :1; // 11 SYSENTER/SYSEXIT
    uint32_t MTRR       :1; // 12 Memory Type Range Registers
    uint32_t PGE        :1; // 13 Global PTE bit
    uint32_t MCA        :1; // 14 Machine Check Architecture
    uint32_t CMOV       :1; // 15 CMOV: Conditional move/compare instruction
    uint32_t PAT        :1; // 16 Page attribute table
    uint32_t PSE36      :1; // 17 PSE36 Size extensions
    uint32_t PSN        :1; // 18 Processor serial number
    uint32_t CLFLUSH    :1; // 19 CFLUSH instruction
    uint32_t NX         :1; // 20 Bit NX
    uint32_t DS         :1; // 21 Debug Store
    uint32_t ACPI       :1; // 22 ACPI
    uint32_t MMX        :1; // 23 MMX
    uint32_t FXSR       :1; // 24 FXSAVE/FXRESTORE
    uint32_t SSE        :1; // 25 SSE extensions
    uint32_t SSE2       :1; // 26 SSE2 extensions
    uint32_t SS         :1; // 27 Self-Snoop
    uint32_t HTT        :1; // 28 Hyperthreading
    uint32_t TM         :1; // 29 Thermal Monitor
    uint32_t IA64       :1; // 30 
    uint32_t PBE        :1; // 31 Pending Break Enable
} cpuid_feat_edx;
```