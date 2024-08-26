`target (string, …)`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-target-function-attribute)

https://gcc.gnu.org/onlinedocs/gcc/x86-Function-Attributes.html

Varios back-ends de destino implementan el atributo `target` para especificar que una función se compilará con opciones de destino diferentes a las especificadas en la línea de comandos. Las opciones de la línea de comandos de destino originales se ignoran. Se pueden proporcionar una o más cadenas como argumentos. Cada cadena consta de uno o más sufijos separados por comas al prefijo `-m` que forman conjuntamente el nombre de una opción dependiente de la máquina. Consulte [Opciones dependientes de la máquina](https://gcc.gnu.org/onlinedocs/gcc/Submodel-Options.html).

El atributo `target` se puede usar, por ejemplo, para compilar una función con una ISA (arquitectura de conjunto de instrucciones) diferente a la predeterminada. Se puede usar `#pragma GCC target'` para especificar opciones específicas de destino para más de una función. Consulte  [Function Specific Option Pragmas](https://gcc.gnu.org/onlinedocs/gcc/Function-Specific-Option-Pragmas.html), para obtener detalles sobre el pragma.

Por ejemplo, en un ``x86``, podría declarar una función con el atributo `target("sse4.1,arch=core2")` y otra con `target("sse4a,arch=amdfam10")`. Esto es equivalente a compilar la primera función con las opciones ``-msse4.1`` y ``-march=core2``, y la segunda función con las opciones ``-msse4a`` y ``-march=amdfam10``. Depende de usted asegurarse de que una función solo se invoque en una máquina que admita la [[ISA]] particular para la que está compilada (por ejemplo, usando [[cpuid]] en ``x86`` para determinar qué bits de características y familia de arquitectura se usan).

```c
int core2_func (void) __attribute__ ((__target__ ("arch=core2")));
int sse3_func (void) __attribute__ ((__target__ ("sse3")));
```

Proporcionar múltiples cadenas como argumentos separados por comas para especificar múltiples opciones es equivalente a separar los sufijos de las opciones con una coma (‘,’) dentro de una sola cadena. No se permiten espacios dentro de las cadenas.

Las opciones admitidas son específicas de cada destino; consulte [x86 Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/x86-Function-Attributes.html), [PowerPC Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/PowerPC-Function-Attributes.html), [ARM Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/ARM-Function-Attributes.html), [AArch64 Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Function-Attributes.html), [Nios II Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/Nios-II-Function-Attributes.html), y [S/390 Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/S_002f390-Function-Attributes.html).

Como se explicó en Atributos de funciones comunes, este atributo permite especificar opciones de compilación específicas del destino.

En ``x86``, se permiten las siguientes opciones:

‘``3dnow``’
‘``no-3dnow``’
Habilitar o deshabilitar la generación de las instrucciones [[3DNow]]!.

‘``3dnowa``’
‘``no-3dnowa``’
Habilitar o deshabilitar la generación de las instrucciones [[3DNow]]! mejoradas.

‘[[abm]]’
‘``no-``[[abm]]’
Habilitar o deshabilitar la generación de las instrucciones de bits avanzadas. [[ABM]] (``Advanced Bit Manipulation``). Consulte https://en.wikipedia.org/wiki/X86_Bit_manipulation_instruction_set.

‘``adx``’
‘``no-adx``’
Habilitar o deshabilitar la generación de las instrucciones [[ADX]].

‘``aes``’
‘``no-aes``’
Habilitar o deshabilitar la generación de las instrucciones [[AES]].

‘``avx``’
‘``no-avx``’
Habilitar o deshabilitar la generación de las instrucciones [[AVX]].

‘``avx2``’
‘``no-avx2``’
Habilita o deshabilita la generación de las instrucciones [[AVX2]].

‘``avx512bitalg``’
‘``no-avx512bitalg``’
Habilita o deshabilita la generación de las instrucciones [[AVX512BITALG]].

‘``avx512bw``’
‘``no-avx512bw``’
Habilita o deshabilita la generación de las instrucciones [[AVX512BW]].

‘``avx512cd``’
‘``no-avx512cd``’
Habilita o deshabilita la generación de las instrucciones [[AVX512CD]].

‘``avx512dq``’
‘``no-avx512dq``’
Habilita o deshabilita la generación de las instrucciones [[AVX512DQ]].

‘``avx512er``’
‘``no-avx512er``’
Habilita o deshabilita la generación de las instrucciones [[AVX512ER]].

‘``avx512f``’
‘``no-avx512f``’
Habilita o deshabilita la generación de las instrucciones [[AVX512F]].

‘``avx512ifma``’
‘``no-avx512ifma``’
Habilita o deshabilita la generación de las instrucciones [[AVX512IFMA]].

‘``avx512vbmi``’
‘``no-avx512vbmi``’
Habilita o deshabilita la generación de las instrucciones [[AVX512VBMI]].

‘``avx512vbmi2``’
‘``no-avx512vbmi2``’
Habilita o deshabilita la generación de las instrucciones [[AVX512VBMI2]].

‘``avx512vl``’
‘``no-avx512vl``’
Habilita o deshabilita la generación de las instrucciones [[AVX512VL]].

‘``avx512vnni``’
‘``no-avx512vnni``’
Habilita o deshabilita la generación de las instrucciones [[AVX512VNNI]].

‘``avx512vpopcntdq``’
‘``no-avx512vpopcntdq``’
Habilita o deshabilita la generación de las instrucciones [[AVX512VPOPCNTDQ]].

‘``bmi``’
‘``no-bmi``’
Habilita o deshabilita la generación de las instrucciones [[BMI]].

‘``bmi2``’
‘``no-bmi2``’
Habilita o deshabilita la generación de las instrucciones [[BMI2]].

‘``cldemote``’
‘``no-cldemote``’
Habilita o deshabilita la generación de las instrucciones [[CLDEMOTE]].

‘``clflushopt``’
‘``no-clflushopt``’
Habilita o deshabilita la generación de las instrucciones [[CLFLUSHOPT]].

‘``clwb``’
‘``no-clwb``’
Habilita o deshabilita la generación de las instrucciones [[CLWB]].

‘``clzero``’
‘``no-clzero``’
Habilita o deshabilita la generación de las instrucciones [[CLZERO]].

‘``crc32``’
‘``no-crc32``’
Habilita o deshabilita la generación de las instrucciones [[CRC32]].

‘``cx16``’
‘``no-cx16``’
Habilita o deshabilita la generación de las instrucciones [[CMPXCHG16B]].

‘``default``’
Consulte [Function Multiversioning](https://gcc.gnu.org/onlinedocs/gcc/Function-Multiversioning.html), donde se utiliza para especificar la versión de función predeterminada.

‘``f16c``’
‘``no-f16c``’
Habilita o deshabilita la generación de las instrucciones [[F16C]].

‘``fma``’
‘``no-fma``’
Habilita/deshabilita la generación de las instrucciones [[FMA]].

‘``fma4``’
‘``no-fma4``’
Habilita/deshabilita la generación de las instrucciones [[FMA4]].

‘``fsgsbase``’
‘``no-fsgsbase``’
Habilita/deshabilita la generación de las instrucciones [[FSGSBASE]].

‘``fxsr``’
‘``no-fxsr``’
Habilita/deshabilita la generación de las instrucciones [[FXSR]].

‘``gfni``’
‘``no-gfni``’
Habilita/deshabilita la generación de las instrucciones [[GFNI]].

‘``hle``’
‘``no-hle``’
Habilita/deshabilita la generación de los prefijos de instrucciones [[HLE]].

‘``lwp``’
‘``no-lwp``’
Habilita/deshabilita la generación de las instrucciones [[LWP]].

‘``lzcnt``’
‘``no-lzcnt``’
Habilita/deshabilita la generación de las instrucciones [[LZCNT]].

‘``mmx``’
‘``no-mmx``’
Habilita/deshabilita la generación de las instrucciones [[MMX]].

‘``movbe``’
‘``no-movbe``’
Habilita/deshabilita la generación de las instrucciones [[MOVBE]].

‘``movdir64b``’
‘``no-movdir64b``’
Habilita/deshabilita la generación de las instrucciones [[MOVDIR64B]].

‘``movdiri``’
‘``no-movdiri``’
Habilita/deshabilita la generación de las instrucciones [[MOVDIRI]].

‘``mwait``’
‘``no-mwait``’
Habilita/deshabilita la generación de las instrucciones [[MWAIT]] y [[MONITOR]].

‘``mwaitx``’
‘``no-mwaitx``’
Habilita/deshabilita la generación de las instrucciones [[MWAITX]].

‘``pclmul``’
‘``no-pclmul``’
Habilita/deshabilita la generación de las instrucciones [[PCLMUL]].

‘``pconfig``’
‘``no-pconfig``’
Habilita/deshabilita la generación de las instrucciones [[PCONFIG]].

‘``pku``’
‘``no-pku``’
Habilita o deshabilita la generación de las instrucciones [[PKU]].

‘``popcnt``’
‘``no-popcnt``’
Habilita o deshabilita la generación de la instrucción [[POPCNT]].

‘``prfchw``’
‘``no-prfchw``’
Habilita o deshabilita la generación de la instrucción [[PREFETCHW]].

‘``ptwrite``’
‘``no-ptwrite``’
Habilita o deshabilita la generación de las instrucciones [[PTWRITE]].

‘``rdpid``’
‘``no-rdpid``’
Habilita o deshabilita la generación de las instrucciones [[RDPID]].

‘``rdrnd``’
‘no-rdrnd’
Habilita o deshabilita la generación de las instrucciones [[RDRND]].

‘``rdseed``’
‘``no-rdseed``’
Habilita o deshabilita la generación de las instrucciones [[RDSEED]].

‘``rtm``’
‘``no-rtm``’
Habilita o deshabilita la generación de las instrucciones [[RTM]].

‘``sahf``’
‘``no-sahf``’
Habilita o deshabilita la generación de instrucciones [[SAHF]].

‘``sgx``’
‘``no-sgx``’
Habilita o deshabilita la generación de instrucciones [[SGX]].

‘``sha``’
‘``no-sha``’
Habilita o deshabilita la generación de instrucciones [[SHA]].

‘``shstk``’
‘``no-shstk``’
Habilita o deshabilita las funciones integradas de [[shadow stack]] de [[CET]].

‘``sse``’
‘``no-sse``’
Habilita o deshabilita la generación de instrucciones [[SSE]].

‘``sse2``’
‘``no-sse2``’
Habilita o deshabilita la generación de instrucciones [[SSE2]].

‘``sse3``’
‘``no-sse3``’
Habilita o deshabilita la generación de instrucciones [[SSE3]].

‘``sse4``’
‘``no-sse4``’
Habilita o deshabilita la generación de las instrucciones [[SSE4]] (tanto [[SSE4.1]] como [[SSE4.2]]).

‘``sse4.1``’
‘``no-sse4.1``’
Habilita o deshabilita la generación de las instrucciones [[SSE4.1]].

‘``sse4.2``’
‘``no-sse4.2``’
Habilita o deshabilita la generación de las instrucciones [[SSE4.2]].

‘``sse4a``’
‘``no-sse4a``’
Habilita o deshabilita la generación de las instrucciones [[SSE4A]].

‘``ssse3``’
‘``no-ssse3``’
Habilita o deshabilita la generación de las instrucciones [[SSSE3]].

‘``tbm``’
‘``no-tbm``’
Habilita o deshabilita la generación de las instrucciones [[TBM]].

‘``vaes``’
‘``no-vaes``’
Habilita o deshabilita la generación de las instrucciones [[VAES]].

‘``vpclmulqdq``’
‘``no-vpclmulqdq``’
Habilita o deshabilita la generación de las instrucciones [[VPCLMULQDQ]].

‘``waitpkg``’
‘``no-waitpkg``’
Habilita o deshabilita la generación de las instrucciones [[WAITPKG]].

‘``wbnoinvd``’
‘``no-wbnoinvd``’
Habilita o deshabilita la generación de las instrucciones [[WBNOINVD]].

‘``xop``’
‘``no-xop``’
Habilita o deshabilita la generación de las instrucciones [[XOP]].

‘``xsave``’
‘``no-xsave``’
Habilita o deshabilita la generación de las instrucciones [[XSAVE]].

‘``xsavec``’
‘``no-xsavec``’
Habilita o deshabilita la generación de las instrucciones [[XSAVEC]].

‘``xsaveopt``’
‘``no-xsaveopt``’
Habilita o deshabilita la generación de las instrucciones [[XSAVEOPT]].

‘``xsaves``’
‘``no-xsaves``’
Habilita/deshabilita la generación de las instrucciones [[XSAVES]].

‘``amx-tile``’
‘``no-amx-tile``’
Habilita/deshabilita la generación de las instrucciones [[AMX-TILE]].

‘``amx-int8``’
‘``no-amx-int8``’
Habilita/deshabilita la generación de las instrucciones [[AMX-INT8]].

‘``amx-bf16``’
‘``no-amx-bf16``’
Habilita/deshabilita la generación de las instrucciones [[AMX-BF16]].

‘``uintr``’
‘``no-uintr``’
Habilita/deshabilita la generación de las instrucciones [[UINTR]].

‘``hreset``’
‘``no-hreset``’
Habilita/deshabilita la generación de la instrucción [[HRESET]].

‘``kl``’
‘``no-kl``’
Habilita/deshabilita la generación de las instrucciones [[KEYLOCKER]].

‘``widekl``’
‘``no-widekl``’
Habilita o deshabilita la generación de las instrucciones [[WIDEKL]].

‘``avxvnni``’
‘``no-avxvnni``’
Habilita o deshabilita la generación de las instrucciones [[AVXVNNI]].

‘``avxifma``’
‘``no-avxifma``’
Habilita o deshabilita la generación de las instrucciones [[AVXIFMA]].

‘``avxvnniint8``’
‘``no-avxvnniint8``’
Habilita o deshabilita la generación de las instrucciones [[AVXVNNIINT8]].

‘``avxneconvert``’
‘``no-avxneconvert``’
Habilita o deshabilita la generación de las instrucciones [[AVXNECONVERT]].

‘``cmpccxadd``’
‘``no-cmpccxadd``’
Habilita o deshabilita la generación de las instrucciones [[CMPccXADD]].

‘``amx-fp16``’
‘``no-amx-fp16``’
Habilita o deshabilita la generación de las instrucciones [[AMX-FP16]].

‘``prefetchi``’
‘``no-prefetchi``’
Habilita o deshabilita la generación de las instrucciones [[PREFETCHI]].

‘``raoint``’
‘``no-raoint``’
Habilita o deshabilita la generación de las instrucciones [[RAOINT]].

‘``amx-complex``’
‘``no-amx-complex``’
Habilita o deshabilita la generación de las instrucciones [[AMX-COMPLEX]].

‘``avxvnniint16``’
‘``no-avxvnniint16``’
Habilita o deshabilita la generación de las instrucciones [[AVXVNNIINT16]].

‘``sm3``’
‘``no-sm3``’
Habilita o deshabilita la generación de las instrucciones [[SM3]].

‘``sha512``’
‘``no-sha512``’
Habilita o deshabilita la generación de instrucciones [[SHA512]].

‘``sm4``’
‘``no-sm4``’
Habilita o deshabilita la generación de instrucciones [[SM4]].

‘``usermsr``’
‘``no-usermsr``’
Habilita o deshabilita la generación de instrucciones [[USER_MSR]].

‘``apxf``’
‘``no-apxf``’
Habilita o deshabilita la generación de funciones [[APX]], incluidas [[EGPR]], [[PUSH2POP2]], [[NDD]] y [[PPX]].

‘``avx10.1``’
‘``no-avx10.1``’
Habilita o deshabilita la generación de instrucciones [[AVX10.1]].

‘``avx10.1-256``’
‘``no-avx10.1-256``’
Habilita o deshabilita la generación de instrucciones [[AVX10.1]].

‘``avx10.1-512``’
‘``no-avx10.1-512``’
Habilita o deshabilita la generación de instrucciones [[AVX10.1]] de 512 bits.

‘``avx10.2``’
‘``no-avx10.2``’
Habilita o deshabilita la generación de instrucciones [[AVX10.2]].

‘``avx10.2-256``’
‘``no-avx10.2-256``’
Habilita o deshabilita la generación de instrucciones [[AVX10.2]].

‘``avx10.2-512``’
‘``no-avx10.2-512``’
Habilita o deshabilita la generación de instrucciones [[AVX10.2]] de 512 bits.

‘``cld``’
‘``no-cld``’
Habilita o deshabilita la generación de [[CLD]] antes de que se mueva la cadena.

‘``fancy-math-387``’
‘``no-fancy-math-387``’
Habilite o deshabilite la generación de las instrucciones seno, coseno y raíz cuadrada en la unidad de punto flotante 387. [[x87]] Consulte: https://stackoverflow.com/questions/8207890/ambiguity-in-decoding-specific-x87-fpu-instructions y https://langdev.stackexchange.com/questions/2404/are-x87-long-doubles-still-relevant y https://gcc.gcc.gnu.narkive.com/U1xnzB9c/fancy-x87-ops-sse-and-mfpmath-sse-387-performance.

‘``ieee-fp``’
‘``no-ieee-fp``’
Habilite o deshabilite la generación de punto flotante que depende de la aritmética IEEE. [[IEEE-754]] Consulte https://es.wikipedia.org/wiki/IEEE_754.

‘``inline-all-stringops``’
‘``no-inline-all-stringops``’
Habilite o deshabilite la inserción en línea de operaciones de cadena.

‘``inline-stringops-dynamically``’
‘``no-inline-stringops-dynamically``’
Habilite o deshabilite la generación del código en línea para realizar operaciones de cadena pequeñas y llamar a las rutinas de la biblioteca para operaciones grandes.

‘``align-stringops``’
‘``no-align-stringops``’
Alinee o no alinee el destino de las operaciones de cadena en línea.

‘``recip``’
‘``no-recip``’
Habilita o deshabilita la generación de instrucciones [[RCPSS]], [[RCPPS]], [[RSQRTSS]] y [[RSQRTPS]] seguidas de un paso [[Newton-Raphson]] (consulte https://es.wikipedia.org/wiki/Método_de_Newton) adicional en lugar de realizar una división de punto flotante.

‘``general-regs-only``’
Genera código que utiliza solo los [[las-arquitecturas#^482839|registros generales]].

‘``arch=ARCH``’
Especifica la arquitectura para la que se generará el código al compilar la función.

‘``tune=TUNE``’
Especifica la arquitectura para la que se ajustará al compilar la función.

‘``fpmath=FPMATH``’
Especifica qué unidad de punto flotante se utilizará. Debes especificar la opción target("``fpmath=sse,387``") como target("``fpmath=sse+387``") porque la coma separaría diferentes opciones.

‘``prefer-vector-width=OPT``’
En tar ``x86`` obtiene, el atributo ``prefer-vector-width`` informa al compilador que utilice un ancho de vector de bits ``OPT`` en las instrucciones en lugar del valor predeterminado en la plataforma seleccionada.

Los valores ``OPT`` válidos son:

‘``none``’
No se aplican limitaciones adicionales a ``GCC`` que no sean las definidas por la plataforma seleccionada.

‘``128``’
Prefiere un ancho de vector de ``128 bits`` para las instrucciones.

‘``256``’
Prefiere un ancho de vector de ``256 bits`` para las instrucciones.

‘``512``’
Prefiere un ancho de vector de ``512 bits`` para las instrucciones.