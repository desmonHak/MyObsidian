## CPUID(5): MONITOR/MWAIT Informacion.
Esta página no se mostrará en modo de lanzamiento si [[CPUID(0)]].``EAX < 5``.

Nota: Esta captura de pantalla está obsoleta y se realizó en una máquina más antigua que actualmente no está disponible para el autor. El mecanismo para escribir configuraciones se agregó después de que se tomó esta captura de pantalla.
![[Pasted image 20240916224653.png]]
- Bits ``EAX`` 
	- ``Bits 15-00``: tamaño de línea de monitor más pequeño en bytes (el valor predeterminado es la granularidad del monitor del procesador). 
	- ``Bits 31-16``: reservados = 0. 
- Bits ``EBX`` 
	- ``Bits 15-00``: tamaño de línea de monitor más grande en bytes (el valor predeterminado es la granularidad del monitor del procesador). 
	- ``Bits 31-16``: reservados = 0. 
- Bit ``ECX`` 
	- ``Bit 00``: Enumeración de extensiones de [[MONITOR]]-[[MWAIT]] (más allá de los registros ``EAX`` y ``EBX``) compatibles. 
	- ``Bit 01``: Admite el tratamiento de interrupciones como eventos de interrupción para [[MWAIT]], incluso cuando las interrupciones están deshabilitadas. 
	- Bits ``31-02``: Reservados.
- Bits ``EDX`` 
	- ``Bits 03-00``: Número de subestados [[C0]]* compatibles con [[MWAIT]]. 
	- ``Bits 07-04``: Número de subestados [[C1]]* compatibles con [[MWAIT]]. 
	- ``Bits 11-08``: Número de subestados [[C2]]* compatibles con [[MWAIT]]. 
	- ``Bits 15-12``: Número de subestados [[C3]]* admitidos mediante [[MWAIT]]. 
	- ``Bits 19-16``: Número de subestados [[C4]]* admitidos mediante [[MWAIT]]. 
	- ``Bits 23-20``: Número de subestados [[C5]]* admitidos mediante [[MWAIT]]. 
	- ``Bits 27-24``: Número de subestados [[C6]]* admitidos mediante [[MWAIT]]. 
	- ``Bits 31-28``: Número de subestados [[C7]]* admitidos mediante [[MWAIT]].

```c
typedef union {
   struct { // low order
      UINT SmallestMonitorLineSize:16;  // 15..0
      UINT Reserved2:16;                // 31..16
   } bits;  // high order
   UINT w;
} EAX5b;

typedef union {
   struct { // low order
      UINT LargestMonitorLineSize:16;   // 15..0
      UINT Reserved1:16;                // 31..16
   } bits;  // high order
   UINT w;
} EBX5b;

typedef union {
   struct { // low order
      UINT MWAITEnumerationSupported:1;  // 0
      UINT InterruptsAsBreakEvents:1;    // 1
      UINT Reserved3:30;                 // 31..2
   } bits;
   UINT w;
} ECX5b;

typedef union {
   struct { // low order
      UINT C0:4;                        // 0..3
      UINT C1:4;                        // 4..7
      UINT C2:4;                        // 8..11
      UINT C3:4;                        // 15..12
      UINT C4:4;                        // 19..16
      UINT Reserved4:12;                // 31..29
   } bits;  // high order
   UINT w;
} EDX5b;
```