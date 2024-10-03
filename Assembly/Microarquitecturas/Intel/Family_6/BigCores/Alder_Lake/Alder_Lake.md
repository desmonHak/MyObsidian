https://en.wikichip.org/wiki/intel/microarchitectures/alder_lake
https://edc.intel.com/content/www/us/en/design/ipla/software-development-platforms/client/platforms/alder-lake-desktop/12th-generation-intel-core-processors-datasheet-volume-1-of-2/006/cpuid/

| Core                                                                                                                                                      | Abbrev    | Platform | Target                                                                                              |
| --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | -------- | --------------------------------------------------------------------------------------------------- |
| [Alder Lake M](https://en.wikichip.org/w/index.php?title=intel/cores/alder_lake_m&action=edit&redlink=1 "intel/cores/alder lake m (page does not exist)") | [[ADL-M]] |          | Portátiles ligeros, 2 en 1 desmontables, tablets, salas de conferencias, memorias USB, etc.         |
| [Alder Lake P](https://en.wikichip.org/w/index.php?title=intel/cores/alder_lake_p&action=edit&redlink=1 "intel/cores/alder lake p (page does not exist)") | [[ADL-P]] |          | Máximo rendimiento móvil, estaciones de trabajo móviles, equipos portátiles All-in-One (AiO), Minis |
| [Alder Lake S](https://en.wikichip.org/wiki/intel/cores/alder_lake_s "intel/cores/alder lake s")                                                          | [[ADL-S]] |          | Rendimiento de escritorio a buen precio, AiOs y minis                                               |

```c
Name	CPU Configuration	                    GPU	Dimensions	Area
ADL-S	8P + 8E	                                 32 EU	        10.5 mm x 20.5 mm	215.25 mm²
        6P + 0E	                                                10.5 mm x 15.5 mm	162.75 mm²
ADL-P	6P + 8E	                                 96 EU
ADL-M	2P + 8E
```

Vea la pagina numero ``0`` de [[CPUID(0)]] para obtener estos datos:
```c
Core  Extended Family  Family	         Extended Model	    Model
S	        0	        0x6	                   0x9	         0x7
                     Family 6 Model 151
P	        0	        0x6	                   0x9	         0xA
                     Family 6 Model 154
```

Vea la pagina numero `1` de [[CPUID(1)]] para ver las distintas extensiones que tiene su CPU ([[HT]], [[AVX]], [[AVX2]], [[TBT]], [[TBMT]]).
```c
Family  	General Description	            Differentiating Features
                                          Cores HT AVX AVX2 TBT TBMT
Core i3	    Low-end Performance	        4 (4+0) ✔	✔	✔	 ✔	 ✘
Core i5	    Mid-range Performance	   10 (6+4) ✔	✔	✔	 ✔	 ✘
                                        6 (6+0)
Core i7	    High-end Performance	   12 (8+4)	✔	✔	✔	 ✔	 ✔
Core i9	    Extreme Performance	       16 (8+8)	✔	✔	✔	 ✔	 ✔
```


| SKU               | CPUID  | Extended Family<br><br>[27:20] | Extended Model<br><br>[19:16] | Processor Type<br><br>[13:12] | Family Code<br><br>[11:8] | Model Number<br><br>[7:4] | Stepping ID<br><br>[3:0] |
| ----------------- | ------ | ------------------------------ | ----------------------------- | ----------------------------- | ------------------------- | ------------------------- | ------------------------ |
| S-processor 8+8   | 90672h | 0x0                            | 0x9                           | 0x0                           | 0x6                       | 0x7                       | 0x2                      |
| S-processor 6+0   | 90675h | 0x0                            | 0x9                           | 0x0                           | 0x6                       | 0x7                       | 0x5                      |
| P-processor 6+8   | 906A3h | 0x0                            | 0x9                           | 0x0                           | 0x6                       | 0x7                       | 0x3                      |
| H-processor 6+8   | 906A3h | 0x0                            | 0x9                           | 0x0                           | 0x6                       | 0x7                       | 0x3                      |
| U15-processor 2+8 | 906A4h | 0x0                            | 0x9                           | 0x0                           | 0x6                       | 0x7                       | 0x4                      |
| U9-processor 2+8  | 906A4h | 0x0                            | 0x9                           | 0x0                           | 0x6                       | 0x7                       | 0x4                      |

