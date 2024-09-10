El comando `lscpu` devuelve información acerca de la CPU: 
```c
Arquitectura:                            x86_64  
 modo(s) de operación de las CPUs:      32-bit, 64-bit  
 Address sizes:                         39 bits physical, 48 bits virtual  
 Orden de los bytes:                    Little Endian  
CPU(s):                                  24  
 Lista de la(s) CPU(s) en línea:        0-23  
ID de fabricante:                        GenuineIntel  
 Nombre del modelo:                     13th Gen Intel(R) Core(TM) i7-13700KF  
   Familia de CPU:                      6  
   Modelo:                              183  
   Hilo(s) de procesamiento por núcleo: 2  
   Núcleo(s) por «socket»:              16  
   «Socket(s)»                          1  
   Revisión:                            1  
   CPU(s) scaling MHz:                  69%  
   CPU MHz máx.:                        5400,0000  
   CPU MHz mín.:                        800,0000  
   BogoMIPS:                            6835,20  
   Indicadores:                         fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2  
                                         ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology    
                                        nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma  
                                         cx16 xtpr pdcm sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm  
                                         3dnowprefetch cpuid_fault ssbd ibrs ibpb stibp ibrs_enhanced tpr_shadow flexpriority ept vpid ept_ad fsgs  
                                        base tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdseed adx smap clflushopt clwb intel_pt sha_ni xsaveopt    
                                        xsavec xgetbv1 xsaves split_lock_detect user_shstk avx_vnni dtherm ida arat pln pts hwp hwp_notify hwp_act  
                                        _window hwp_epp hwp_pkg_req hfi vnmi umip pku ospke waitpkg gfni vaes vpclmulqdq rdpid movdiri movdir64b f  
                                        srm md_clear serialize arch_lbr ibt flush_l1d arch_capabilities  
Virtualization features:                    
 Virtualización:                        VT-x  
Caches (sum of all):                        
 L1d:                                   640 KiB (16 instances)  
 L1i:                                   768 KiB (16 instances)  
 L2:                                    24 MiB (10 instances)  
 L3:                                    30 MiB (1 instance)  
NUMA:                                       
 Modo(s) NUMA:                          1  
 CPU(s) del nodo NUMA 0:                0-23  
Vulnerabilities:                            
 Gather data sampling:                  Not affected  
 Itlb multihit:                         Not affected  
 L1tf:                                  Not affected  
 Mds:                                   Not affected  
 Meltdown:                              Not affected  
 Mmio stale data:                       Not affected  
 Reg file data sampling:                Mitigation; Clear Register File  
 Retbleed:                              Not affected  
 Spec rstack overflow:                  Not affected  
 Spec store bypass:                     Mitigation; Speculative Store Bypass disabled via prctl  
 Spectre v1:                            Mitigation; usercopy/swapgs barriers and __user pointer sanitization  
 Spectre v2:                            Mitigation; Enhanced / Automatic IBRS; IBPB conditional; RSB filling; PBRSB-eIBRS SW sequence; BHI BHI_DIS  
                                        _S  
 Srbds:                                 Not affected  
 Tsx async abort:                       Not affected
```

Usar `lscpu | egrep -i 'core.*:|socket'` para ver la cantidad de socket's y nucleos
```bash
➜  Escritorio lscpu | egrep -i 'core.*:|socket'  
  
Núcleo(s) por «socket»:               16  
«Socket(s)»
```