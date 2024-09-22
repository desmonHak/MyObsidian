http://www.flounder.com/cpuid_explorer2.htm#CPUID(1):EAX
## Cache and [[TLB]] parameters
Esta pantalla no es compatible con la arquitectura ``AMD``. La información de caché y [[TLB]] está disponible mediante [[CPUID(0x80000006)]].ECX.

### Estructura

Para los registros EAX, EBX, ECX y EDX:

| 0  desc  | desc    | desc    | desc    |
| -------- | ------- | ------- | ------- |
| 1####### | ####### | ####### | ####### |

Si el bit de orden superior del registro es ``0``, cada ``byte`` del registro contiene un descriptor de caché/[[TLB]] válido. Si el bit de orden superior del registro es ``1``, cada byte del registro está reservado y no tiene ningún significado. No he encontrado ninguna máquina que tenga un valor de conteo ``> 1``.

```c
EREGS2 ER;
CPUID(2, &ER.regs);
if(ER.descriptors[0] != 0x00) { /* valid descriptors */
	for(int i = 1; i < sizeof(ER.regs.descriptors); i++)
		{ /* decode each descriptor */
		if((i & 0x3 == 0) && (ER.descriptors[i] & 0x80)) { 
			/* invalid descriptors */
			i += 3; continue;
		} /* invalid descriptors */
		// ... decode ER.descriptors[i]
	} /* decode each descriptor */
} /* valid descriptors */
```
El código anterior supone que el ``byte`` de orden inferior de ``EAX`` es ``1``. Se necesitaría un bucle más complejo para manejar otros casos; tenga en cuenta que el valor en ``AL`` parece ser válido en operaciones posteriores. Sin embargo, la documentación no es clara sobre este hecho.
La prueba especial para ``descriptors[0] == 0`` es necesaria porque los procesadores ``AMD`` devuelven todos los ceros y no establecen ningún bit de orden superior en ``1``.
```c
IDS_CTLB_00H "Null descriptor"
IDS_CTLB_01H "Instruction TLB: 4K pages, 4-way set associative, 32 entries\nI 4Kx4wx32"
IDS_CTLB_02H "Instruction TLB: 4K pages, 4-way set associative, 2 entries\nI 4Kx4wx2"
IDS_CTLB_03H "Data TLB: 4K pages, 4-way set associative, 64 entries\nD 4Kx4wx64"
IDS_CTLB_04H "Data TLB: 4M pages, 4-way set associative, 8 entries\nD 4Mx4wx8"
IDS_CTLB_05H "Data TLB: 4M pages, 4-way set associative, 8 entries\n4Mx4wx8"
IDS_CTLB_06H "1st-level instruction cache: 8K, 4-way set associative, 32 byte line size\nI 8Kx4wx32"
IDS_CTLB_08H "1st-level instruction cache: 16K, 4-way set associative, 32 byte line size\nI 16Kx4wx32"
IDS_CTLB_0AH "1st-level data cache: 8K, 2-way set associative, 32 byte line size\nD 8Kx2wx32"
IDS_CTLB_0CH "1st-level data cache: 16K, 4-way set associative, 32 byte line size\nD 16Kx4wx32"
IDS_CTLB_22H "3rd-level cache: 512K, 4-way set associative, 64-byte line size, 2 lines per sector\n512Kx4wx64"
IDS_CTLB_23H "3rd-level cache; 1M, 8-way set associative, 64 byte line size, 2 lines per sector\n1Mx8wx64"
IDS_CTLB_25H "3rd-level cache: 2M, 8-way set associative, 64 byte line size, 2 lines per sector\n2Mx8wx64"
IDS_CTLB_29H "3rd-level cache: 4M, 8-way set associative, 64 byte line size, 2 lines per sector\n4Mx8wx64"
IDS_CTLB_2CH "1st-level data cache: 32K, 8-way asociative, 64 byte line size\nD 32Kx8wx64"
IDS_CTLB_30H "1st-level instruction cache: 32K, 8-way set associative, 64 byte line size\nI 32Kx8wx64"
IDS_CTLB_40H "No 2nd-level cache, or, if processor contains a valid 2nd-level cache, no 3rd-level cache"
IDS_CTLB_41H "2nd-level cache: 128K, 4-way set associative, 32 byte line size\n128Kx4wx32"
IDS_CTLB_42H "2nd-level cache: 256K, 4-way set associative, 32 byte line size\n256Kx4wx32"
IDS_CTLB_43H "2nd-level cache: 512K, 4-way set associative, 32 byte line size\n512Kx4wx32"
IDS_CTLB_44H "2nd-level cache: 1M, 4-way set associative, 32 byte line size\n1Mx4wx32"
IDS_CTLB_45H "2nd-level cache: 2M, 4-way set associative, 32 byte line size\n2Mx4wx32"
IDS_CTLB_46H "3rd-level cache: 4M, 4-way set associative, 64 byte line size\n4Mx4wx64"
IDS_CTLB_47H "3rd-level cache, 8M, 8-way set associative, 64 byte line size\n8Mx8wx64"
IDS_CTLB_49H "2nd-level cache: 4M, 16-way set associative, 64 byte line size\n4Mx16wx64"
IDS_CTLB_50H "Instruction TLB: 4K and 2M or 4M pages, 64 entries\nI 4K+2M/4Mx64"
IDS_CTLB_51H "Instruction TLB: 4K and 2M or 4M pages, 128 entries\nI 4K+2M/4Mx128"
IDS_CTLB_52H "Instruction TLB: 4K and 2M or 4M pages, 256 entries\nI 4K+2M/4Mx256"
IDS_CTLB_56H "Data TLB0: 4M pages, 4-way set associative, 16 entries\nD 4Mx4wx16"
IDS_CTLB_57H "Data TLB0: 4K pages, 4-way set associative, 16 entries\nD 4Kx4wx16"
IDS_CTLB_5BH "Data TLB: 4K and 4M pages, 64 entries\nD 4K+4Mx64"
IDS_CTLB_5CH "Data TLB: 4K and 4M pages, 128 entries\nD 4K+4Mx128"
IDS_CTLB_5DH "Data TLB: 4K and 4M pages, 256 entries\nD 4K+4Mx254"
IDS_CTLB_60H "1st-level data cache: 16K, 8-way set associative, 64 byte line size\n16Kx8x64"
IDS_CTLB_66H "1st-level data cache: 8K, 4-way set associative, 64 byte line size\n8Kx4wx64"
IDS_CTLB_67H "1st-level data cache: 16K, 4-way set associative, 64 byte line size\n16Kx4wx64"
IDS_CTLB_68H "1st-level data cache: 32K, 4-way set associative, 64 byte line size\n32Kx4wx64"
IDS_CLTB_70H "Trace cache: 12K-uOp, 8-way set associative\nTr 12Kx8w"
IDS_CTLB_71H "Trace cache: 16K-uOp, 8-way set associative\nTr 16Kx8w"
IDS_CTLB_72H "Trace cache: 32K-uOp, 8-way set associative\nTr 32Kx8w"
IDS_CTLB_78H "2nd-level cache: 128K, 8-way set associative, 64 byte line size\n128Kx8wx64"
IDS_CTLB_79H "2nd-level cache: 128K, 8-way set associative, 64 byte line size, 2 lines per sector\n128Kx8wx64"
IDS_CTLB_7AH "2nd-level cache: 256K, 8-way set associative, 64 byte line size, 2 lines per sector\n256Kx8wx64"
IDS_CTLB_7BH "2nd-level cache: 512K, 8-way set associative, 64 byte line size, 2 lines per sector\n512Kx8wx64"
IDS_CTLB_7CH "2nd-level cache: 1M, 8-way set associative, 64 byte line size, 2 lines per sector\n1Mx8wx64"
IDS_CTLB_7DH "2nd-level cache: 2M, 8-way set associative, 64 byte line size\n2Mx82x64"
IDS_CTLB_7FH "2nd-level cache: 512K, 2-way set associative, 64 byte line size\n512Kx2wx64"
IDS_CTLB_82H "2nd-level cache: 256K, 8-way set associative, 32 byte line size\n256Kx8wx32"
IDS_CTLB_83H "2nd-level cache: 512K, 8-way set associative, 32 byte line size\n512Kx8wx32"
IDS_CTLB_84H "2nd-level cache: 1M, 8-way set associative, 32 byte line size\n1Mx8wx32"
IDS_CTLB_85H "2nd-level cache: 2M, 8-way set associative, 32 byte line size\n2Mx8wx32"
IDS_CTLB_86H "2nd-level cache: 512K, 4-way set associative, 64 byte line size\n512Kx4wx64"
IDS_CTLB_87H "2nd-level cache: 1M, 8-way set associative, 64 byte line size\n1Mx8wx64"
IDS_CTLB_B0H "Instruction TLB: 4K pages, 4-way set associative, 128 entries\nI 4Kx4x128"
IDS_CTLB_B3H "Data TLB: 4K pages, 4-way set associative, 128 entries\nD 4Kx4wx128"
IDS_CTLB_B4H "Data TLB1: 4K pages, 4-way set associative, 256 entries\nD 4Kx4wx256"
IDS_CTLB_F0H "64-byte prefetching"
IDS_CTLB_F1H "128-byte prefetching"
```
