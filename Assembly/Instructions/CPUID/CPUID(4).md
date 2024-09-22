## CPUID(4, _n_): Información Cache
Tenga en cuenta que la visualización de cada línea de caché para cada valor de ``n`` es esencialmente idéntica. Sin embargo, si el tipo de caché no está definido, esa información no se muestra. En el modo de depuración, siempre se mostrarán las páginas de la línea de caché 1 a 6. La cantidad de cachés informadas actualmente está fijada en el momento de la compilación y está limitada a un máximo de ``6 cachés``. Se pueden agregar más agregando más páginas. En el modo de lanzamiento, estas páginas no se mostrarán si [[CPUID(0)]].``EAX`` < ``4``.

##### AMD
This display is not supported for AMD platforms.

##### Intel
###### EAX:

| 31         26 | 25                    14 | 13    10 | 9   | 8   | 7    5 | 4        0 |
| ------------- | ------------------------ | -------- | --- | --- | ------ | ---------- |
| cores/pkg     | threads sharing cache-1  | ######## | FA  | SI  | Level  | Type       |
- FA - Fully associative
- SI - Self-initializing
- Type:
	- 00H - No mas información de cache.
	- 01H - Cache de datos.
	- 02H - Cache de instrucciones.
	- 03H - Caché unificada (datos + instrucciones).
###### EBX:

| 31                 22 | 21                12 | 11                     0 |
| --------------------- | -------------------- | ------------------------ |
| associativity - 1     | line partitions - 1  | Coherency line size - 1  |
###### ECX:

| 31                                                               0 |
| ------------------------------------------------------------------ |
| Number of sets -1                                                  |

###### EDX:
Reservado

```c
typedef union {
    struct { // low order
         UINT CacheType:5;        // 4..0
         UINT CacheLevel:3;       // 7..5
         UINT SelfInitializing:1; // 8
         UINT FullyAssociative:1; // 9
         UINT Reserved:4;         // 13..10
         UINT ThreadsSharing:12;  // 25..14
         UINT CoresPerPackage:6;  // 31..26
     } bits; // high order
     UINT w;
} EAX4b;

typedef union {
    struct { // low order
         UINT SystemCoherencyLineSize:12; // 11..0
         UINT PhysicalLinePartitions:10;  // 21..12
         UINT WaysOfAssociativity:10;     // 32..22
    } bits; // high order
    UINT w;
} EBX4b;
```

La cantidad de caches que puede haber según la implementación, es de ``2**8`` o ``256``. El valor que se pase a ``ECX`` es el ID cache a inspeccionar, en el caso de que en la cache numero `i` el valor del campo `CacheType` sea ``0``, quiere decir que ya se examino todas las caches que la ``CPU`` tenia, lo cual muy probablemente puede ser ``!= 256``.
```c
for(UINT i = 0; i < 256; i++)
   { /* examine each level */
    CPUregs regs;
    regs.ECX = i; // ¡Tenga en cuenta que ECX debe configurarse antes de realizar la llamada!
    GetCPUID(4, &regs);
    EAX4b EAX;
    EAX.w = regs.EAX;

    if(EAX.bits.CacheType == 0) // si tipo cache es 0 no hay mas info cache
       break; // No hay más información de caché disponible

    UINT ActualThreadsSharingCache = EAX.ThreadsSharing + 1;
    UINT ActualCoresPerPackage = EAX.CoresPerPackage + 1;

    EBX4b EBX;
    EBX.w = regs.EBX;

    UINT ActualSystemCoherencyLineSize = EBX.SystemCoherencyLineSize + 1;
    UINT ActualPhysicalLinePartitions = EBX.PhysicalLinePartitions + 1;
    UINT ActualNumberOfSets = regs.ECX + 1;

    // ... use cache information here
   } /* examine each level */
```

```c
IDS_CACHE_TYPE_01 "Data cache"
IDS_CACHE_TYPE_02 "Instruction cache"
IDS_CACHE_TYPE_03 "Unified (data + instruction) cache"
```