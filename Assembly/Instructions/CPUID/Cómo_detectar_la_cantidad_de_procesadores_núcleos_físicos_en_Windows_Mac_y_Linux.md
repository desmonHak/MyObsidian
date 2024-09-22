https://stackoverflow.com/questions/2901694/how-to-detect-the-number-of-physical-processors-cores-on-windows-mac-and-linu

Forma antigua de obtener cantidad de procesadores físicos y lógicos mediante [[CPUID(1)]]. Actualmente para procesadores modernos esta forma es incorrecta([cpuid-on-intel-i7-processors](https://stackoverflow.com/questions/1647190/cpuid-on-intel-i7-processors)):
```cpp
#include <iostream>
#include <string>

using namespace std;


void cpuID(unsigned i, unsigned regs[4]) {
#ifdef _WIN32
  __cpuid((int *)regs, (int)i);

#else
  asm volatile
    ("cpuid" : "=a" (regs[0]), "=b" (regs[1]), "=c" (regs[2]), "=d" (regs[3])
     : "a" (i), "c" (0));
  // ECX is set to zero for CPUID function 4
#endif
}


int main(int argc, char *argv[]) {
  unsigned regs[4];

  // Get vendor
  char vendor[12];
  cpuID(0, regs);
  ((unsigned *)vendor)[0] = regs[1]; // EBX
  ((unsigned *)vendor)[1] = regs[3]; // EDX
  ((unsigned *)vendor)[2] = regs[2]; // ECX
  string cpuVendor = string(vendor, 12);

  // Get CPU features
  cpuID(1, regs);
  unsigned cpuFeatures = regs[3]; // EDX

  // Logical core count per CPU
  cpuID(1, regs);
  unsigned logical = (regs[1] >> 16) & 0xff; // EBX[23:16]
  cout << " logical cpus: " << logical << endl;
  unsigned cores = logical;

  if (cpuVendor == "GenuineIntel") {
    // Get DCP cache info
    cpuID(4, regs);
    cores = ((regs[0] >> 26) & 0x3f) + 1; // EAX[31:26] + 1

  } else if (cpuVendor == "AuthenticAMD") {
    // Get NC: Number of CPU cores - 1
    cpuID(0x80000008, regs);
    cores = ((unsigned)(regs[2] & 0xff)) + 1; // ECX[7:0] + 1
  }

  cout << "    cpu cores: " << cores << endl;

  // Detect hyper-threads  
  bool hyperThreads = cpuFeatures & (1 << 28) && cores < logical;

  cout << "hyper-threads: " << (hyperThreads ? "true" : "false") << endl;

  return 0;
}
```

Intel(R) Core(TM)2 Duo CPU T7500 @ 2.20GHz:
```cpp
 logical cpus: 2
    cpu cores: 2
hyper-threads: false
```

Intel(R) Core(TM)2 Quad CPU Q8400 @ 2.66GHz:
```c
logical cpus: 4
    cpu cores: 4
hyper-threads: false
```

Intel(R) Xeon(R) CPU E5520 @ 2.27GHz (w/ x2 physical CPU packages):
```c
 logical cpus: 16
    cpu cores: 8
hyper-threads: true
```

Intel(R) Pentium(R) 4 CPU 3.00GHz:
```c
logical cpus: 2
    cpu cores: 1
hyper-threads: true
```

Usar [[CPUID(1)]].EBX[23:16] para obtener los procesadores lógicos o [[CPUID(4)]].EAX[31:26]+1 para obtener los físicos con procesadores Intel no arroja el resultado correcto en ningún procesador Intel que tengo.
Para Intel, se debe usar [[CPUID(0xB)]] Intel_thread/Fcore y topología de caché. La solución no parece ser trivial. Para AMD, es necesaria una solución diferente.

Aquí se encuentra el código fuente de Intel que informa la cantidad correcta de núcleos físicos y lógicos, así como la cantidad correcta de sockets https://software.intel.com/en-us/articles/intel-64-architecture-processor-topology-enumeration/. Probé esto en un sistema Intel de 4 sockets con 80 núcleos lógicos y 40 núcleos físicos.

A continuación se incluye el código fuente para AMD http://developer.amd.com/resources/documentation-articles/articles-whitepapers/processor-and-core-enumeration-using-cpuid/. Obtuvo el resultado correcto en mi sistema Intel de un solo socket, pero no en mi sistema de cuatro sockets. No tengo un sistema AMD para probar.

A continuación se muestra una solución para procesadores Intel con [[CPUID(0xB)]]. La forma de hacerlo es recorrer los procesadores lógicos[[SetProcessAffinityMask - Cambiar afinidad de un proceso]] y obtener el ID de [[x2APIC]] para cada procesador lógico a partir de [[CPUID]] y contar la cantidad de ID de [[x2APIC]] donde el bit menos significativo es cero. Para sistemas sin ``hiperprocesamiento``, el ID de [[x2APIC]] siempre será par. Para sistemas con ``hiperprocesamiento``, cada ID de [[x2APIC]] tendrá una versión par y otra impar.
```c
// input:  eax = functionnumber, ecx = 0
// output: eax = output[0], ebx = output[1], ecx = output[2], edx = output[3]
// static inline void cpuid (int output[4], int functionnumber)  

int getNumCores(void) {
    // Suponiendo un procesador Intel con CPUID leaf 11
    int cores = 0;
    #pragma omp parallel reduction(+:cores)
    {
        int regs[4];
        cpuid(regs,11);
        if(!(regs[3]&1)) cores++; 
    }
    return cores;
}
```

No basta con comprobar si una CPU Intel tiene ``hyperthreading``, también hay que comprobar si el ``hyperthreading`` está habilitado o deshabilitado. No hay ninguna forma documentada de comprobarlo. Un empleado de Intel ideó este truco para comprobar si el ``hyperthreading`` está habilitado: comprueba la cantidad de contadores de rendimiento programables utilizando [[CPUID(0xA)]].eax[15:8] y asume que si el valor es 8, el ``HT`` está deshabilitado, y si el valor es 4, el ``HT`` está habilitado (https://software.intel.com/en-us/forums/intel-isa-extensions/topic/831551).

No hay ningún problema en los chips ``AMD``: el [[CPUID]] informa 1 o 2 subprocesos por núcleo, dependiendo de si el ``multithreading`` simultáneo está deshabilitado o habilitado.

También hay que comparar el recuento de subprocesos del [[CPUID]] con el recuento de subprocesos informado por el sistema operativo para ver si hay varios chips de CPU.

He creado una función que implementa todo esto. Informa tanto del número de procesadores físicos como del número de procesadores lógicos. Lo he probado en procesadores Intel y AMD en Windows y Linux. Debería funcionar también en Mac. He publicado este código en https://github.com/vectorclass/add-on/tree/master/physical_processors
```cpp
/*********************  physical_processors.cpp   *****************************
* Author:        Agner Fog
* Date created:  2019-10-29
* Last modified: 2021-05-04
* Version:       2.01 
* Project:       vector class library
* Description:   Detect number of physical and logical processors on CPU chip.
*                Compile for C++11 or later
*
* (c) Copyright 2019-2021 Agner Fog.
* Apache License version 2.0 or later.
*******************************************************************************
Some modern CPUs can run two threads in each CPU core when simultaneous 
multithreading (SMT, called hyperthreading by Intel) is enabled.

The number of physical processors is the number of CPU cores.
The number of logical processors is the same number multiplied by the number of
threads that can run simultaneously in each CPU core.

Simultaneous multithreading will slow down performance when two CPU-intensive 
threads running in the same physical processor (CPU core) are competing for the
same resources. Therefore, the optimal number of threads for CPU-intensive
tasks is most likely to be the number of physical processors. 

Tasks that are less CPU-intensive but limited by RAM access, disk access, 
network, etc. may get an advantage by running as many threads as the number of
logical processors. This will be double the number of physical processors when
simultaneous multithreading is enabled.

The physicalProcessors function detects the number of physical processors and
logical processors on an x86 computer. This is useful for determining the 
optimal number of threads.


Note: There are several problems in detecting the number of physical processors:

1. The CPUID instruction on Intel CPUs will return a wrong number of logical
   processors when SMT (hyperthreading) is disabled. It may be necessary to 
   compare the number of processors returned by the CPUID instruction with the
   number of processors reported by the operating system to detect if SMT is 
   enabled (AMD processors do not have this problem).

2. It is necessary to rely on system functions to detect if there is more than 
   one CPU chip installed. It is assumed that the status of SMT is the same on
   all CPU chips in a system.

3. The behavior of VIA processors is undocumented.
   
4. This function is not guaranteed to work on future CPUs. It may need updating
   when new CPUs with different configurations or different CPUID functionality
   appear.
******************************************************************************/

#include <thread>     // std::thread functions

#ifdef _MSC_VER
#include <intrin.h>   // __cpuidex intrinsic function available on microsoft compilers
#endif

#ifdef VCL_NAMESPACE
namespace VCL_NAMESPACE {
#endif

// Define interface to CPUID instruction.
// input:  leaf = eax, subleaf = ecx
// output: output[0] = eax, output[1] = ebx, output[2] = ecx, output[3] = edx
static inline void cpuid(int output[4], int leaf, int subleaf = 0) {
#if defined(__GNUC__) || defined(__clang__)      // use inline assembly, Gnu/AT&T syntax
    int a, b, c, d;
    __asm("cpuid" : "=a"(a), "=b"(b), "=c"(c), "=d"(d) : "a"(leaf), "c"(subleaf) : );
    output[0] = a;
    output[1] = b;
    output[2] = c;
    output[3] = d;

#elif defined (_MSC_VER)                         // Microsoft compiler, intrin.h included
    __cpuidex(output, leaf, subleaf);            // intrinsic function for CPUID

#else                                            // unknown platform. try inline assembly with masm/intel syntax
    __asm {
        mov eax, leaf
        mov ecx, subleaf
        cpuid;
        mov esi, output
        mov[esi], eax
        mov[esi + 4], ebx
        mov[esi + 8], ecx
        mov[esi + 12], edx
    }
#endif
}

// Function prototype:
int physicalProcessors(int * logical_processors = 0);


// Find the number of physical and logical processors supported by CPU
// Parameter: 
// logical_processors: an optional pointer to an integer that will receive the number of logical processors.
// Return value: number of physical processors
int physicalProcessors(int * logical_processors) {
    int vendor = 0;                              // CPU vendor: 1 = Intel, 2 = AMD, 3 = VIA, 0 = other
    int logicalProc = 1;                         // number of logical processor cores
    int physicalProc = 1;                        // number of physical processor cores
    int procPerCore = 1;                         // logical cores per physical core
    bool hyperthreadingSupported = false;        // CPU supports hyperthreading / simultaneous multithreading
    int systemProcessors = std::thread::hardware_concurrency(); // number of processors reported by operating system

    int abcd[4] = { 0,0,0,0 };                   // CPUID output
    cpuid(abcd, 0);                              // CPUID function 0

    int maxLeaf = abcd[0];                       // maximum eax input for CPUID
    if (abcd[2] == 0x6C65746E) {                 // last 4 chars of "GenuineIntel"
        vendor = 1;
    }
    else if (abcd[2] == 0x444D4163) {            // last 4 chars of "AuthenticAMD"
        vendor = 2;
    }
    else if (abcd[2] == 0x736C7561) {            // last 4 chars of "CentaurHauls"
        vendor = 3;
    }

    if (maxLeaf >= 1) {
        cpuid(abcd, 1);
        if (abcd[3] & (1 << 28)) {               // hyperthreading supported
            hyperthreadingSupported = true;
        }
    }

    if (vendor == 1) {
        //////////////////
        //    Intel     //
        //////////////////

        int hyper = 0;                           // hyperthreading status: 0 = unknown, 1 = disabled, 2 = enabled
        if (maxLeaf >= 0xB) {                    // leaf 0xB or 0x1F: Extended Topology Enumeration
            int num = 0xB;
            // if (maxLeaf >= 0x1F) num = 0x1F;

            for (int c = 0; c < 5; c++) {
                cpuid(abcd, num, c);             // enumeration level c
                int type = (abcd[2] >> 8) & 0xFF;// enumeration type at level c
                if (type == 1) {                 // SMT level
                    procPerCore = abcd[1] & 0xFFFF;
                }
                else if (type >= 2) {            // core level
                    logicalProc = abcd[1] & 0xFFFF;
                }
                else if (type == 0) break;
                // There are more types/levels to consider if we use num = 0x1F. We may need  
                // to fix this in the future if CPUs with more complex configurations appear
            }
            physicalProc = logicalProc / procPerCore;

            // The number of performance monitor registers depends on hyperthreading status
            // on Intel CPUs with performance monitoring version 3 or 4
            cpuid(abcd, 0xA, 0);                 // performance monitor counters information
            int perfVersion = abcd[0] & 0xFF;    // performance monitoring version
            int perfNum = (abcd[0] >> 8) & 0xFF; // number of performance monitoring registers
            if (perfVersion == 3 || perfVersion == 4) {
                if (perfNum == 4) {
                    hyper = 2;                   // 4 performance registers when hyperthreading enabled
                }
                else if (perfNum == 8) {         // 8 performance registers when hyperthreading disabled
                    hyper = 1;
                    procPerCore = 1;
                    logicalProc = physicalProc;  // reduce the number of logical processors when hyperthreading is disabled
                }
                // hyper remains 0 in all other cases, indicating unknown status
            }
        }
        else if (maxLeaf >= 4) {                 // CPUID function 4: cache parameters and cores
            cpuid(abcd, 4);
            logicalProc = (abcd[0] >> 26) + 1;
            if (hyperthreadingSupported) {
                // number of logical processors per core is not known. Assume 2 if hyperthreading supported
                procPerCore = 2;
            }
            physicalProc = logicalProc / procPerCore;
        }
        else {
            // no information. Assume 1 processor
        }
        if (systemProcessors > logicalProc) {
            // Multiple CPU chips. Assume that chips are identical with respect to hypethreading
            physicalProc = systemProcessors * physicalProc / logicalProc;
            logicalProc = systemProcessors;
        }
        else if (logicalProc > systemProcessors && systemProcessors > 0 && hyper == 0) {
            // Hyperthreading is disabled
            logicalProc = systemProcessors;
            physicalProc = systemProcessors;        
        }
    }
    else if (vendor == 2) {

        //////////////////
        //    AMD       //
        //////////////////

        cpuid(abcd, 0x80000000);                 // AMD specific CPUID functions
        int maxLeaf8 = abcd[0] & 0xFFFF;         // maximum eax 0x8000.... input for CPUID

        if (maxLeaf8 >= 8) {
            cpuid(abcd, 0x80000008);
            logicalProc = (abcd[2] & 0xFF) + 1;

            if (maxLeaf8 >= 0x1E) {
                cpuid(abcd, 0x8000001E);
                procPerCore = ((abcd[1] >> 8) & 0x03) + 1;
                // procPerCore = 2 if simultaneous multithreading is enabled, 1 if disabled
            }
            else {
                if (hyperthreadingSupported) {
                    procPerCore = 2;
                }
                else {
                    procPerCore = 1;
                }
            }
            physicalProc = logicalProc / procPerCore;
        }
        else if (hyperthreadingSupported) {
            // number of logical processors per core is not known. Assume 2 if SMT supported
            logicalProc = 2;
            physicalProc = 1;
        }
        if (systemProcessors > logicalProc) {
            // Multiple CPU chips. Assume that chips are identical with respect to SMT
            physicalProc = systemProcessors * physicalProc / logicalProc;
            logicalProc = systemProcessors;
        }
    }
    else {
    
        //////////////////////////////
        //    VIA or unknown CPU    //
        //////////////////////////////

        // The behavior of VIA processors is undocumented! It is not known how to detect threads on a VIA processor
        physicalProc = logicalProc = systemProcessors;
        if (hyperthreadingSupported && physicalProc > 1) {
            physicalProc /= 2;
        }
    }
    if (logical_processors) {
        // return logical_processors if pointer is not null
        *logical_processors = logicalProc;
    }
    return physicalProc;
}

#ifdef VCL_NAMESPACE
}
#endif

/* Uncomment this for testing:

#include <stdio.h>

int main() {

    int logicalProc = 0;
    int physicalProc = physicalProcessors(&logicalProc); 

    printf("\nlogical processors: %i",  logicalProc);
    printf("\nphysical processors: %i", physicalProc);
    printf("\nlogical processors per core: %i", logicalProc / physicalProc);
    int sysproc = std::thread::hardware_concurrency();
    printf("\nsystem processors: %i", sysproc); 

    return 0;
}
*/
```

1. **[[CPUID(1)]].EBX[23:16]**: Este campo específico del registro EBX se utiliza para determinar el número máximo de procesadores lógicos en un paquete físico. Esto es útil para entender cuántos hilos de ejecución puede manejar un procesador simultáneamente.
2. **[[CPUID(4)]].EAX[31:26]+1**: Este campo en el registro EAX indica el número máximo de núcleos físicos en un paquete físico. Al sumar 1 al valor obtenido, se puede determinar cuántos núcleos físicos tiene un procesador.
3. **[[CPUID(4)]].EAX[25:14]+1**: Este campo también en el registro EAX proporciona el número máximo de procesadores lógicos que comparten una caché de nivel específico (como L2 o L3). Nuevamente, sumando 1 al valor, se obtiene el número real de procesadores lógicos que comparten esa caché