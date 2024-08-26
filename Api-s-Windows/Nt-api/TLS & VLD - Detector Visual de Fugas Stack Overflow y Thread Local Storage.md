
[https://xinhuang.github.io/posts/2015-10-23-visual-leak-detector-stack-overflow-and-thread-local-storage.html](https://xinhuang.github.io/posts/2015-10-23-visual-leak-detector-stack-overflow-and-thread-local-storage.html)

1. Resumen
En Windows, por defecto Thread Local Storage (TLS) tiene ``0x40`` slots. Posteriormente se amplía en ``0x400`` slots más. Estas ranuras de expansión son creadas bajo demanda cuando las APIs TLS `TlsAlloc/TlsFree/TlsGetValue/TlsSetValue` son invocadas en el thread actual. Y la expansión se consigue llamando a la API de Windows `RtlAllocateHeap`. Cuando las APIs TLS son invocadas por primera vez con un número de ranura >= ``0x40`` en un hilo que no se ha expandido antes, la expansión TLS se activará.

Visual Leak Detector (VLD) es una librería de rastreo de asignación de memoria, que ayuda a solucionar problemas de fugas de memoria enganchando APIs de asignación de memoria, incluyendo `RtlAllocateHeap`.

Cuando se produce una asignación de memoria, VLD almacenará la información en su ranura TLS para evitar la contención y reducir el impacto en el rendimiento. Cuando a VLD se le asigna una ranura TLS >= ``0x40`` y se produce una asignación de memoria en un subproceso que no ha expandido TLS, el acceso a la ranura TLS desde VLD provocará otra expansión TLS.

Sin embargo, la expansión llamará a `RtlAllocateHeap` para asignar memoria y el registro de esta asignación de memoria se guardará en la ranura TLS por VLD, que volverá a desencadenar otra expansión TLS... De esta manera, el programa entrará en recursión infinita.

2. Análisis
Hoy me he encontrado con un fallo debido a una recursión infinita al cambiar las pilas de llamadas entre KernelBase.dll y VLD.dll. Parece ser que de alguna manera VLD entra en una recursión infinita al llamar a `VisualLeakDetector::getTls()`. Lo que es más interesante es que a pesar de que este fallo se repite, VLD ha estado activado en nuestro producto durante mucho tiempo.
¿Por qué ocurre ahora?
La pila de llamadas tiene el siguiente aspecto:
```c
...
6dc9 0759f314 09ddbfcc 00000042 0a16b870 09defbd0 KERNELBASE!TlsSetValue+0x4f
6dca 0759f360 09ddc1a3 09defbd0 00490000 0759f38c vld!VisualLeakDetector::getTls+0xfc [c:\build\vld\v24c\src\vld.cpp @ 1075]
6dcb 0759f370 09dda74b 0baa5930 00000008 0759f69c vld!VisualLeakDetector::enabled+0x23 [c:\build\vld\v24c\src\vld.cpp @ 982]
6dcc 0759f38c 75c445cf 00490000 00000008 00001000 vld!VisualLeakDetector::_HeapAlloc+0x2b [c:\build\vld\v24c\src\vld_hooks.cpp @ 1617]
6dcd 0759f3a8 09ddbfcc 00000042 0a16b870 09defbd0 KERNELBASE!TlsSetValue+0x4f
6dce 0759f3f4 09ddc1a3 09defbd0 05480fe8 0759f420 vld!VisualLeakDetector::getTls+0xfc [c:\build\vld\v24c\src\vld.cpp @ 1075]
6dcf 0759f404 09dda74b 05480fd0 0000004c 0759f45c vld!VisualLeakDetector::enabled+0x23 [c:\build\vld\v24c\src\vld.cpp @ 982]
6dd0 0759f420 7614ea43 00490000 00000000 00000018 vld!VisualLeakDetector::_HeapAlloc+0x2b [c:\build\vld\v24c\src\vld_hooks.cpp @ 1617]
6dd1 0759f434 7614ea5f 762466bc 00000018 0759f450 ole32!CRetailMalloc_Alloc+0x16 [d:\w7rtm\com\ole32\com\class\memapi.cxx @ 641]
...
6dec 0759fde0 77419882 0546b610 718c8e2a 00000000 kernel32!BaseThreadInitThunk+0xe
6ded 0759fe20 77419855 7612d854 0546b610 00000000 ntdll!__RtlUserThreadStart+0x70
6dee 0759fe38 00000000 7612d854 0546b610 00000000 ntdll!_RtlUserThreadStart+0x1b
```

Cuando un hilo se inicia e intenta asignar memoria, VLD rastreará todas las asignaciones de memoria. VLD registra la información de asignación en una ranura TLS para evitar la contención y reducir el impacto en el rendimiento. Cuando VLD intenta inicializar la ranura TLS, la API de Windows `TlsSetValue` asigna memoria, y VLD rastrea la asignación guardándola en TLS. Esto es lo que podemos adivinar del volcado de error.

¿Pero por qué `TlsSetValue` asignará memoria? Echemos un vistazo al código assembly: (se omiten detalles sin interés, se añaden sangrías para una mejor formación y comprensión):
```c
KERNELBASE!TlsSetValue:
// BOOL WINAPI TlsSetValue(_In_ DWORD dwTlsIndex, _In_opt_ LPVOID lpTlsValue)
...
75c44585 56              push    esi
75c44586 648b3518000000  mov     esi,dword ptr fs:[18h]
// ESI points to Thread Environment Block (TEB)
75c4458d 57              push    edi
75c4458e 8b7d08          mov     edi,dword ptr [ebp+8]
75c44591 83ff40          cmp     edi,40h
75c44594 7260            jb      KERNELBASE!TlsSetValue+0x76 (75c445f6)  Branch

// if (dwTlsIndex >= 0x40) {

  KERNELBASE!TlsSetValue+0x16:
  75c44596 83ef40          sub     edi,40h
  75c44599 81ff00040000    cmp     edi,400h
  75c4459f 734e            jae     KERNELBASE!TlsSetValue+0x6f (75c445ef)  Branch

  // if (dwTlsIndex < 0x440) {

    KERNELBASE!TlsSetValue+0x21:
    75c445a1 8b86940f0000    mov     eax,dword ptr [esi+0F94h]
    75c445a7 85c0            test    eax,eax
    75c445a9 753c            jne     KERNELBASE!TlsSetValue+0x67 (75c445e7)  Branch

    // if (pTeb->TlsExpansionSlots == NULL)

      KERNELBASE!TlsSetValue+0x2b:
      75c445ab e88126ffff      call    KERNELBASE!KernelBaseGetGlobalData (75c36c31)
      75c445b0 8b402c          mov     eax,dword ptr [eax+2Ch]
      75c445b3 648b0d18000000  mov     ecx,dword ptr fs:[18h]
      75c445ba 6800100000      push    1000h
      75c445bf 83c808          or      eax,8
      75c445c2 50              push    eax
      75c445c3 8b4130          mov     eax,dword ptr [ecx+30h]
      75c445c6 ff7018          push    dword ptr [eax+18h]
      75c445c9 ff151810c375    call    dword ptr [KERNELBASE!_imp__RtlAllocateHeap (75c31018)]
      75c445cf 85c0            test    eax,eax
      75c445d1 750e            jne     KERNELBASE!TlsSetValue+0x61 (75c445e1)  Branch
      ...
      KERNELBASE!TlsSetValue+0x61:
      75c445e1 8986940f0000    mov     dword ptr [esi+0F94h],eax

      // pTeb->TlsExpansionSlots = RtlAllocateHeap(...)

    KERNELBASE!TlsSetValue+0x67:
    75c445e7 8b4d0c          mov     ecx,dword ptr [ebp+0Ch]
    75c445ea 890cb8          mov     dword ptr [eax+edi*4],ecx
    75c445ed eb11            jmp     KERNELBASE!TlsSetValue+0x80 (75c44600)  Branch

    // Set value to TLS slot
  }  else { // ERROR if (dwTlsIndex >= 0x440) }
} // if (dwTlsIndex >= 0x40)
```

Del código desensamblado podemos encontrar que la expansión ocurre cuando la ranura pasada >= ``0x40``. Esto confirma nuestra suposición. Pero dado que VLD entrará en recursividad infinita cuando vea una ranura TLS >= ``0x40``, ¿por qué el desbordamiento de pila no se ha observado antes?

Esta pregunta me ha intrigado durante bastante tiempo: la expansión ya se realiza en `TlsAlloc` para todos los hilos, ¿por qué es necesaria la asignación de memoria? Hasta que me di cuenta de que la expansión sólo se aplica a un [[TEB|Thread Environment Block]], ([[TEB]], donde `fs:[18h]` apunta) lo que significa que la expansión sólo afecta al thread actual. Todos los demás hilos permanecen intactos.

3. Reproducir
Después del análisis anterior, podemos intentar reproducir la recursión infinita para que podamos probar que la conclusión es correcta.
Para aumentar el número de ranuras TLS, basta con llamar a `TlsAlloc` en un bucle.
Otro paso necesario para reproducir es asegurarse de que VLD se asigna con una ranura TLS >= 64. Para hacer esto, primero incrementa el número de ranura TLS, luego carga y habilita VLD dinámicamente usando [[LoadLibrary]] & [[GetProcAddress]]. Después de habilitar VLD, asigne memoria en un nuevo hilo.

Aquí está el ejemplo de código mínimo reproducido:
```cpp
#include <windows.h>
#include <thread>
#include <chrono>
#include <memory>

typedef void(*vld_enable_t)(void);

int main(int argc, wchar_t *argv[]) {
  for (int i = 0; i < 0x40; ++i) TlsAlloc();

  HMODULE h_vld = LoadLibraryA("vld.dll");
  
  auto vld_enable = (vld_enable_t)::GetProcAddress(h_vld, "VLDGlobalEnable");
  vld_enable();
  
  std::thread([]() {std::make_shared<int>(); }).join();
  
  return 0;
}
```
Usando el código anterior podemos hacer que un programa se caiga por desbordamiento de pila, con una pila de llamadas casi igual a la que obtengo del volcado de fallos de nuestro producto. (Excepto por las primeras líneas que inicializan el CLR) Nuestra teoría sobre la expansión de VLD y TLS es correcta.

4. Conclusión
¿Cómo explicar por qué nunca antes se había producido el fallo?

VLD está vinculado a varias DLLs de nuestro producto, y se inicializa estáticamente en estas DLLs. Las DLLs se cargan dinámicamente en tiempo de ejecución cuando se usan, o nunca si no se tocan en tiempo de ejecución. Tal vez algún cambio reciente eliminó VLD de una de las DLLs que siempre se carga antes de que el conteo de asignación TLS llegue a ``0x40``, por lo que a veces cuando se carga VLD, hay posibilidades de que más de ``0x40`` ranuras TLS ya estén asignadas. Es por eso que VLD se asigna con ranura TLS >= ``0x40``.

También usamos muchos COM (ambos STA/MTA) en nuestro producto, los hilos y la asignación de memoria no son raros.

Cuando se dan estas dos condiciones, se produce una recursión infinita.