http://www.flounder.com/cpuid_explorer2.htm#CPUID(1):EAX
## Número de serie del procesador
Tenga en cuenta que esta página solo se muestra en modo de depuración, a menos que el procesador tenga capacidad para un número de serie de procesador. Ninguna CPU desde [[ADD#^a92c4c|Pentium III]] ha tenido esta capacidad y, por lo tanto, esta página no se muestra normalmente. Esta página no se mostrará en modo de lanzamiento si [[CPUID(0)]].``EAX < 3``.
![[Pasted image 20240916222310.png]]
##### AMD
Esta pantalla no es compatible con las plataformas ``AMD``.
##### Intel
```c
CPUregs regs;
GetCPUID(1, &regs);

EDX1b EDX;
EDX.w = regs.EDX;
if(regs.EAX >= 3 && EDX.bits.PSN)
   { /* has processor serial number */
    GetCPUID(3, &regs);
    LARGE_INTEGER serial;
    serial.LowPart = regs.ECX;
    serial.HighPart = regs.EDX;

    // ... use serial.QuadPart here
   } /* has processor serial number */
```