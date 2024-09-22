## CPUID(10): Monitores de rendimiento
##### EAX

| **31            24** | **23            16** | **15             8** | **7              0** |
| -------------------- | -------------------- | -------------------- | -------------------- |
| **EBX vector len**   | **GP bit width**     | **counters**         | **version ID**       |

##### EBX

| **31                                           7** | 6      | 5      | 4      | 3      | 2      | 1      | 0      |
| -------------------------------------------------- | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| **#####################**                          | **BM** | **BI** | **CM** | **CR** | **RC** | **IR** | **CC** |
****CC - Evento de ciclo del núcleo no disponible
IR - Evento de instrucción retirada no disponible
RC - Evento de ciclos de referencia no disponible
CR - Evento de referencia de caché de último nivel no disponible
CM - Evento de referencia de caché de último nivel no disponible
BI - Evento de instrucción de rama retirada no disponible
BM - Evento «Branch Mispredict» retirado no disponible **BM - Evento «Branch Mispredict» retirado no disponible

##### ECX
Reservado

##### EDX

| **31                                 13** | **12               5**1 | **4        0**0 |
| ----------------------------------------- | ----------------------- | --------------- |
| **#####################**                 | **width of counters**   | **counters**    |
```c
typedef union {
   struct { // low order
      UINT VersionID:8;         // 7..0
      UINT GPCounters:8;        // 15..8
      UINT GPCounterWidth:8;    // 23..16
      UINT EBXVectorLength:8;   // 31..24
   } bits;  // high order
   UINT w;
} EAX10b;

typedef union {
   struct { // low order
      UINT CoreCycleNA:1;            // 0
      UINT InstructionRetiredNA:1;   // 1
      UINT ReferenceCyclesNA:1;      // 2
      UINT CacheReferenceNA:1;       // 3
      UINT CacheMissNA:1;            // 4
      UINT BranchRetiredNA:1;        // 5
      UINT BranchMispredictNA:1;     // 6
      UINT Reserved1:25;             // 31..7
   } bits;  // high order
   UINT w;
} EBX10b;

typedef union {
   struct { // low order
      UINT FixedFunctionCounters:5;    // 4..0
      UINT CounterBitWidth:8;          // 12..5
      UINT Reserved2:19;               // 31..13
   } bits;  // high order
   UINT w;
} EDX10b;
```