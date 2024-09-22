
En la arquitectura ``x86-64``, los registros de segmento [[FS]] y [[GS]] se utilizan a menudo para acceder a estructuras de datos específicas en la memoria. Estos registros son particularmente útiles para implementar el almacenamiento local de subprocesos ([[TLS]]), manejar datos por ``CPU`` o acceder a áreas de memoria específicas. En el contexto de ``Windows``, la manipulación de estos registros directamente desde el modo de usuario está restringida, a diferencia de ``Linux``, donde se pueden configurar mediante llamadas del sistema.

Consideraciones específicas de ``Windows``
En ``Windows``, el uso de [[FS]] y [[GS]] está más controlado:

[[FS]]: generalmente apunta al bloque de información de subprocesos ([[TIB]]) en aplicaciones de ``32 bits``. En aplicaciones de ``64 bits``, este rol lo asume a menudo [[GS]].
[[GS]]: en el modo de ``64 bits``, el sistema operativo suele utilizar [[GS]] para almacenar datos por subproceso.
Configuración de [[FS]]/[[GS]] en ``Linux`` frente a ``Windows``
En ``Linux``, puede utilizar la interfaz [[syscall]] ([[#^24eaf9|sys_arch_prctl]]) para configurar la dirección base para [[FS]] o [[GS]], como se muestra en el ejemplo de código que proporcionó. Esto le permite apuntar estos registros de segmento a una ubicación de memoria definida por el usuario, lo que permite el uso de [[GS]] como base para sus propias estructuras de datos.

Sin embargo, en ``Windows``, no es posible configurar [[FS]] o [[GS]] directamente desde el modo de usuario sin invocar instrucciones privilegiadas ([[WRMSR]]) o usar API especializadas, que generalmente no están expuestas a aplicaciones en modo de usuario.

Solución alternativa mediante API de depuración en ``Windows``
Si necesita controlar los registros [[GS]] o [[FS]] en un entorno ``Windows``, una posible solución alternativa implica usar las API de depuración de ``Windows``. Al crear un proceso con privilegios de depuración, puede modificar la dirección base [[FS]] o [[GS]] para ese proceso:

Cree un proceso con privilegios de depuración: use [[CreateProcessA]] con ``DEBUG_PROCESS`` para iniciar un nuevo proceso que pueda depurar.

Modifique los registros de segmento: una vez que tenga privilegios de depuración, puede usar la API ``SetThreadContext`` para modificar las direcciones base [[FS]] o [[GS]] en el proceso de destino.

Notas importantes
Precaución: la modificación de los registros de segmentos en ``Windows`` puede generar un comportamiento indefinido, especialmente si el sistema operativo depende de estos registros para administrar datos específicos de subprocesos o por ``CPU``.
Alternativas: para el almacenamiento local de subprocesos ([[TLS]]) o una funcionalidad similar, considere usar abstracciones de nivel superior proporcionadas por la ``API de Windows``, como ``TlsAlloc``, ``TlsGetValue`` y ``TlsSetValue``.
Ejemplo para linux:
```ruby
section .data
    buffer   db 64

section .text
    global _start

_start:
    ; Load the address of buffer into rsi
    lea rsi, [buffer]

    ; Call arch_prctl to set GS base
    mov eax, 0x1001       ; ARCH_SET_GS
    mov edi, 0x1004       ; GS register
    syscall

    ; Access buffer via GS
    mov rax, [gs:0]
    mov rdx, 'data'
    mov [gs:0], rdx

    ; Exit the program
    mov eax, 60
    xor edi, edi
    syscall
```


https://www.kernel.org/doc/html/v5.9/x86/x86_64/fsgs.html

#### 22.8. Uso de segmentos [[FS]] y [[GS]] en aplicaciones de espacio de usuario
La arquitectura ``x86`` admite la segmentación. Las instrucciones que acceden a la memoria pueden utilizar el modo de direccionamiento basado en registros de segmentos. La siguiente notación se utiliza para direccionar un byte dentro de un segmento:

Registro de segmento: dirección de byte
La dirección base del segmento se suma a la dirección de byte para calcular la dirección virtual resultante a la que se accede. Esto permite acceder a múltiples instancias de datos con la misma dirección de byte, es decir, el mismo código. La selección de una instancia particular se basa puramente en la dirección base en el registro de segmento.

En el modo de ``32 bits``, la ``CPU`` proporciona ``6 segmentos``, que también admiten límites de segmento. Los límites se pueden utilizar para aplicar protecciones de espacio de direcciones.

En el modo de ``64 bits``, los segmentos [[CS]]/[[SS]]/[[DS]]/[[ES]] se ignoran y la dirección base siempre es 0 para proporcionar un espacio de direcciones completo de ``64 bits``. Los segmentos [[FS]] y [[GS]] siguen funcionando en el modo de 64 bits.

#### 22.8.1. Uso común de FS y GS
El segmento [[FS]] se utiliza comúnmente para abordar el almacenamiento local de subprocesos ([[TLS]]). [[FS]] suele ser administrado por código de tiempo de ejecución o una biblioteca de subprocesos. Las variables declaradas con el especificador de clase de almacenamiento '[[__thread]]' se instancian por subproceso y el compilador emite el prefijo de dirección [[FS]]: para acceder a estas variables. Cada subproceso tiene su propia dirección base de [[FS]], por lo que se puede utilizar código común sin cálculos complejos de desplazamiento de dirección para acceder a las instancias por subproceso. Las aplicaciones no deben utilizar [[FS]] para otros fines cuando utilizan tiempos de ejecución o bibliotecas de subprocesos que administran el [[FS]] por subproceso.

El segmento [[GS]] no tiene un uso común y las aplicaciones pueden utilizarlo libremente. ``GCC`` y ``Clang`` admiten el direccionamiento basado en [[GS]] a través de identificadores de espacio de direcciones.

#### 22.8.2. Lectura y escritura de la dirección base FS/GS
Existen dos mecanismos para leer y escribir la dirección base [[FS]]/[[GS]]:

la llamada al sistema [[arch_prctl()]]
la familia de instrucciones [[FSGSBASE]]

#### 22.8.3. Acceso a la base FS/GS con [[arch_prctl()]]
El mecanismo basado en ``arch_prctl(2)`` está disponible en todas las ``CPU`` de ``64 bits`` y en todas las versiones del núcleo.

Lectura de la base:
```c
arch_prctl(ARCH_GET_FS, &fsbase); 
arch_prctl(ARCH_GET_GS, &gsbase);
```

Escritura de la base:
```c
arch_prctl(ARCH_SET_FS, fsbase); 
arch_prctl(ARCH_SET_GS, gsbase);
```

El ``prctl`` ``ARCH_SET_GS`` puede estar deshabilitado según la configuración del núcleo y los ajustes de seguridad.

#### 22.8.4. Acceso a la base [[FS]]/[[GS]] con las instrucciones [[FSGSBASE]]
Con la generación de [[CPU Ivy Bridge]], Intel introdujo un nuevo conjunto de instrucciones para acceder a los registros base [[FS]] y [[GS]] **directamente desde el espacio de usuario**. Estas instrucciones también son compatibles con las ``CPU AMD Family 17H``. Las siguientes instrucciones están disponibles:
[[RDFSBASE]]  ``%reg Leer el registro base FS``
[[RDGSBASE]]  ``%reg Leer el registro base GS``
[[WRFSBASE]]  ``%reg Escribir el registro base FS``
[[WRGSBASE]] ``%reg Escribir el registro base GS``

Las instrucciones evitan la sobrecarga de la llamada al sistema [[arch_prctl()]] y permiten un uso más flexible de los modos de direccionamiento [[FS]]/[[GS]] en aplicaciones de espacio de usuario. Esto no evita los conflictos entre las bibliotecas de subprocesos y los entornos de ejecución que utilizan [[FS]] y las aplicaciones que desean usarlo para sus propios fines.

#### 22.8.4.1. Habilitación de instrucciones FSGSBASE
Las instrucciones se enumeran en la hoja ``7`` de [[CPUID]], ``bit 0 de EBX``. Si está disponible, [[/proc/cpuinfo]] muestra ‘``fsgsbase``’ en la entrada de indicadores de las ``CPU``.

La disponibilidad de las instrucciones no las habilita automáticamente. El núcleo debe habilitarlas explícitamente en [[CR4]]. La razón de esto es que los núcleos más antiguos hacen suposiciones sobre los valores en el registro [[GS]] y los imponen cuando se establece la base [[GS]] mediante [[arch_prctl()]]. Permitir que el espacio de usuario escriba valores arbitrarios en la base [[GS]] violaría estas suposiciones y causaría un mal funcionamiento.

En los núcleos que no habilitan [[FSGSBASE]], la ejecución de las instrucciones [[FSGSBASE]] fallará con una excepción ``#UD``.

El núcleo proporciona información confiable sobre el estado habilitado en el vector [[ELF AUX]]. Si el bit [[HWCAP2_FSGSBASE]] está establecido en el vector [[AUX]], el núcleo tiene habilitadas las instrucciones [[FSGSBASE]] y las aplicaciones pueden usarlas. El siguiente ejemplo de código muestra cómo funciona esta detección:
```c
[[include]] <sys/auxv.h>
[[include]] <elf.h>

/* Will be eventually in asm/hwcap.h */
[[ifndef]] HWCAP2_FSGSBASE
[[define]] HWCAP2_FSGSBASE        (1 << 1)
[[endif]]

....

unsigned val = getauxval(AT_HWCAP2);

if (val & HWCAP2_FSGSBASE)
     printf("FSGSBASE enabled\n");
```

#### 22.8.4.2. Compatibilidad con el compilador de instrucciones FSGSBASE[](https://www.kernel.org/doc/html/v5.9/x86/x86_64/fsgs.html#fsgsbase-instructions-compiler-support "Enlace permanente a este título")

La versión 4.6.4 de ``GCC`` y las posteriores proporcionan funciones intrínsecas para las instrucciones [[FSGSBASE]]. ``Clang 5`` también las admite.

| `_readfsbase_u64()`    | Read the FS base register  |
| ---------------------- | -------------------------- |
| `_readfsbase_u64()`    | Read the GS base register  |
| ``_writefsbase_u64()`` | Write the FS base register |
| ``_writegsbase_u64()`` | Write the GS base register |

Para utilizar estos intrínsecos, <[[immintrin.h]]> debe incluirse en el código fuente y debe agregarse la opción del compilador ``-mfsgsbase``.

## 22.8.5. Compatibilidad del compilador con direccionamiento basado en [[FS]]/[[GS]][](https://www.kernel.org/doc/html/v5.9/x86/x86_64/fsgs.html#compiler-support-for-fs-gs-based-addressing "Permalink to this headline")

``GCC versión 6`` y posteriores brindan compatibilidad con direccionamiento basado en [[FS]]/[[GS]] a través de espacios de direcciones con nombre. ``GCC`` implementa los siguientes identificadores de espacio de direcciones para ``x86``:

| `__seg_fs` | La variable se direcciona en relación con FS |
| ---------- | ------------------------------------ |
| `__seg_gs` | La variable se direcciona en relación con GS |
Los símbolos de preprocesador ``__SEG_FS`` y ``__SEG_GS`` se definen cuando se admiten estos espacios de direcciones. El código que implementa los modos de respaldo debe verificar si estos símbolos están definidos. Ejemplo de uso:
```c
[[ifdef]] __SEG_GS

long data0 = 0;
long data1 = 1;

long __seg_gs *ptr;

/* Compruebe si FSGSBASE está habilitado por el kernel (HWCAP2_FSGSBASE) */
....

/* Set GS base to point to data0 */
_writegsbase_u64(&data0);

/* Access offset 0 of GS */
ptr = 0;
printf("data0 = %ld\n", *ptr);

/* Set GS base to point to data1 */
_writegsbase_u64(&data1);
/* ptr still addresses offset 0! */
printf("data1 = %ld\n", *ptr);
```
``Clang`` no proporciona los identificadores de espacio de direcciones ``GCC``, pero proporciona espacios de direcciones a través de un mecanismo basado en atributos en ``Clang 2.6`` y versiones más nuevas

| ``__attribute__((address_space(256))`` | La variable se direcciona en relación con [[GS]] |
| -------------------------------------- | ------------------------------------------------ |
| ``__attribute__((address_space(257))`` | La variable se direcciona en relación con [[FS]] |
#### 22.8.6. Direccionamiento basado en [[FS]]/[[GS]] con ensamblaje en línea
En caso de que el compilador no admita espacios de direcciones, se puede utilizar ensamblaje en línea para el modo de direccionamiento basado en [[FS]]/[[GS]]:

```js
mov %fs:offset, %reg
mov %gs:offset, %reg

mov %reg, %fs:offset
mov %reg, %gs:offset
```

# En Linux x86-64 moderno, ¿es seguro que el espacio de usuario sobrescriba el registro [[GS]]?
https://stackoverflow.com/questions/59620103/in-modern-linux-x86-64-is-it-safe-for-userspace-to-overwrite-the-gs-register
```python
En un programa C de 64 bits, que utiliza glibc, pthreads, etc. (nada exótico), ¿es seguro sobrescribir el registro GS, sin restaurarlo, en las versiones actuales del kernel y glibc? Sé que pthreads/glibc utiliza el registro FS para el puntero del bloque de almacenamiento local del subproceso, por lo que alterarlo arruinará todo lo que use TLS, pero no estoy seguro sobre GS Si no, ¿es seguro guardar el valor, sobrescribirlo y luego restaurarlo, siempre que el código del espacio de usuario mientras se sobrescribe no haga X (¿qué es X?)
```

No lo sé con seguridad; Jester dice "Sí, pero en lugar de hacer eso probablemente querrás `arch_prctl(ARCH_SET_GS, foo);`"

O en una ``CPU`` con [[FSGSBASE]], quizás [`wrgsbase`](https://www.felixcloutier.com/x86/wrfsbase:wrgsbase) desde el espacio de usuario, si el kernel (como ``Linux 5.9`` o más reciente) lo habilita para el uso del espacio de usuario. (`CR4.FSGSBASE[bit 16]` debe estar configurado o falla con ``#UD``).

Sé que ``x86-64`` cambió al uso de ``FS`` para ``TLS`` (``32 bits usa GS)`` debido a cómo el punto de entrada de la [[syscall]] usa `swapgs` para encontrar la pila del kernel.

Creo que eso fue solo por coherencia entre el ``usuario`` y el ``kernel`` para el [[TLS]] del ``kernel``/cosas por núcleo, porque los procesos de ``32 bits`` bajo un kernel de ``64 bits`` todavía usan [[GS]] para [[TLS]]. Excepto que los procesos de ``32 bits`` no pueden usar `syscall` (excepto en ``CPU AMD``). Eso por sí solo no descarta algún código que solo se ejecute para un proceso de ``64 bits`` que podría hacer algo con [[GS]], pero probablemente no haya ningún problema.

[`swapgs`](https://www.felixcloutier.com/x86/swapgs) solo intercambia la base [[GS]], no el selector. No sé si hay algún punto de entrada del ``kernel`` que reescriba [[GS]] con algún valor de selector predeterminado (y luego vuelva a cargar la base [[GS]] guardada). Supongo que no.

# Un posible final para la saga [[FSGSBASE]]
https://lwn.net/Articles/821723/
La serie de parches [[FSGSBASE]] llegó a su decimotercera versión a fines de mayo. Permite algunas instrucciones "nuevas" para la arquitectura ``x86``, abriendo el camino para una serie de mejoras significativas en el rendimiento. Uno podría pensar que una serie de parches como esta sería una apuesta segura, pero [[FSGSBASE]] ha tenido una historia problemática; mientras tanto, las demoras en fusionarlo pueden haber llevado a que varios usuarios instalen agujeros de raíz en sus sistemas Linux con la esperanza de mejorar la seguridad.
Los "segmentos" son un remanente de versiones antiguas de la arquitectura x86; alguna vez fueron regiones distintas de memoria utilizadas para sortear las limitaciones de direccionamiento de esa era. La memoria virtual ha eliminado la necesidad de segmentos, pero el concepto persiste; los procesadores ``x86_64`` solo implementan dos de los segmentos originales (llamados "[[FS]]" y "[[GS]]"). En estos procesadores, un "segmento" es realmente solo un desplazamiento hacia la memoria virtual sin mucho otro significado; su valor restante proviene del modo de direccionamiento basado en segmentos compatible con la ``CPU``.

Históricos o no, estos registros de segmento todavía se utilizan. Un uso común de [[FS]] en el espacio de usuario es el almacenamiento local de subprocesos; cada subproceso tiene un valor único del registro base de [[FS]] que apunta a su propia área de almacenamiento. El código que se ejecuta en subprocesos puede entonces utilizar el direccionamiento basado en segmentos para acceder al almacenamiento local sin tener que preocuparse por dónde está ese almacenamiento. El núcleo, en cambio, utiliza [[GS]] de una manera similar para los datos por ``CPU``. Hay algunas reliquias del uso único de ``FS`` por parte del núcleo para indicar el rango de direcciones accesible al espacio de usuario, pero las funciones [[get_fs()]] y [[set_fs()]] del núcleo ya no utilizan ese segmento.

La modificación de los registros de segmento **siempre ha sido una operación privilegiada**. Sin embargo, hay valor en permitir que el espacio de usuario haga uso de los registros base de [[FS]] y [[GS]], por lo que el núcleo proporciona esa funcionalidad a través de la llamada al sistema [[arch_prctl()]]. Dado que **los registros base son realmente establecidos por el núcleo**, el código privilegiado puede contar con saber cuál será su contenido (y que dicho contenido tiene sentido).

#### [[FSGSBASE]]
Sin embargo, **llamar al núcleo para configurar un registro es una operación relativamente costosa**. Si la llamada debe realizarse una vez para configurar un área de almacenamiento local de subproceso, nadie notará el costo, pero el código que necesita realizar cambios frecuentes en el registro base [[FS]] o [[GS]] se ralentizará por la sobrecarga de la llamada al sistema. En realidad, configurar esos registros, que se almacenan en registros específicos del modelo ``x86`` ([[MSR]]), **es algo costoso en sí mismo. Por eso, Intel agregó un conjunto de instrucciones para manipular directamente los registros base** [[FS]] y [[GS]] a la serie de procesadores "**Ivy Bridge**" en 2012. Este conjunto de instrucciones a menudo se conoce como "[[FSGSBASE]]".

Sin embargo, antes de que el espacio de usuario pueda usar realmente esas instrucciones, **el núcleo debe configurar un bit especial que las habilite** y, a pesar del tiempo que ha pasado desde que estuvieron disponibles, **ese bit permanece sin configurar**. Dado que el núcleo siempre ha tenido el control de esos registros, contiene una serie de suposiciones sobre su contenido; El simple hecho de permitir que el espacio de usuario los cambie sin preparar primero el núcleo es una receta para cualquiera de las numerosas vulnerabilidades que se explotan fácilmente.

Evitar esos problemas es conceptualmente bastante simple, aunque un poco más complejo en la implementación. El núcleo debe esforzarse por garantizar que los registros [[FS]] y (especialmente) [[GS]] tengan valores correctos en cada entrada en el espacio del núcleo. El manejo de ciertas vulnerabilidades de ejecución especulativa se vuelve un poco más complicado. Y, por supuesto, se debe proporcionar un botón de control para que los administradores puedan desactivar [[FSGSBASE]] si es necesario.

Todo lo que se necesita es que alguien escriba este código. ``Intel`` tardó en publicar parches para [[FSGSBASE]], y nadie más se ofreció a hacer ese trabajo tampoco. Cuando finalmente se publicaron los parches, se encontraron con una serie de problemas en la revisión y han requerido numerosas revisiones. Los curiosos pueden ver este mensaje de ``Thomas Gleixner`` para ver una cronología de los eventos hasta marzo de 2019. La versión 7 del conjunto de parches, publicada en mayo de 2019, llegó a fusionarse con el árbol del subsistema ``x86`` antes de que salieran a la luz varios problemas; esa fusión se revirtió posteriormente de una manera bastante malhumorada después de que salieran a la luz nuevos problemas. Más recientemente, ``Sasha Levin`` ha retomado este trabajo (a pesar de no ser un empleado de Intel) y está tratando de llevarlo a cabo; aún puede tener éxito para el ciclo de desarrollo 5.9.

### Los agujeros de ``root`` entran en el vacío
El desarrollo de esta característica aparentemente simple ha sido un proceso bastante largo y complicado; durante todo este tiempo, los usuarios no han podido aprovecharla. Pero los usuarios, siendo usuarios, han demostrado no estar dispuestos a esperar. Uno de los casos de uso que ha creado más presión es "``Software Guard Extensions``" ([[SGX]]) ``de Intel``, que está pensado para permitir la creación de "``enclaves``" privados para proteger el código y los datos privilegiados. El soporte de [[SGX]] para el kernel ha tenido su propia historia difícil y sigue sin fusionarse, por lo que los desarrolladores que quieren descubrir cómo hacer uso de esta característica han estado trabajando completamente fuera de línea.

Uno de los proyectos más destacados en esta área es [[Graphene]], que se describe a sí mismo como un "``sistema operativo de biblioteca``" para aplicaciones seguras. El sitio web menciona a [[SGX]] de esta manera:

[[Graphene]] ejecuta aplicaciones sin modificar dentro de Intel [[SGX]]. Admite bibliotecas cargadas dinámicamente, enlaces en tiempo de ejecución, abstracciones de múltiples procesos y autenticación de archivos. Para mayor seguridad, [[Graphene]] realiza comprobaciones criptográficas y semánticas en la interfaz del host no confiable. Los desarrolladores proporcionan un archivo de manifiesto para configurar el entorno de la aplicación y las políticas de aislamiento, [[Graphene]] hace el resto automáticamente.
[[Graphene]] comenzó como un proyecto de investigación, pero desde entonces ha recibido una buena cantidad de apoyo de empresas, incluida ``Intel``. El proyecto tiene ambiciones de ser la plataforma de soporte estándar de [[SGX]], y algunos proveedores de la nube están evidentemente considerando la posibilidad de brindar soporte, con la bendición de ``Intel``.

[[Graphene]] tiene un pequeño problema: trabajar con [[SGX]] requiere la capacidad de modificar el registro base de [[FS]] con frecuencia. Para mantener rápidas las llamadas a los enclaves, [[Graphene]] carga un pequeño módulo del núcleo que habilita las instrucciones [[FSGSBASE]]. Dado que el núcleo no está preparado para esto, esa acción abre inmediatamente un ``agujero de raíz`` en el sistema involucrado, **justo lo que uno quiere ver de un sistema que se supone que brinda mayor seguridad**. [[Graphene]] no es el único que tiene este comportamiento; la biblioteca ``Occlum`` [[SGX]] hace lo mismo, por ejemplo.

Es justo decir que la comunidad de desarrollo del núcleo, en general, no se impresionó con este enfoque del problema. ``Don Porter``, uno de los creadores de [[Graphene]], intentó justificar la habilitación de [[FSGSBASE]] a espaldas del núcleo señalando que los proyectos [[SGX]] asumen que el sistema operativo anfitrión está comprometido; después de todo, [[SGX]] existe para proteger los datos en esa situación. Sin embargo, extender esa filosofía a comprometer el sistema desde el principio sigue siendo difícil de vender.

Al final, los desarrolladores del núcleo suelen entender la idea de utilizar este tipo de truco para solucionar un problema y al mismo tiempo abordar otros problemas. **El hecho de que no se encuentre ninguna advertencia en el llamativo sitio web de [[Graphene]], o en los artículos que describen [[Graphene]], de que la instalación del código compromete el sistema es más difícil de aceptar**. Incluso hay, como señaló ``Levin``, un libro llamado ``Responsible Genomic Data Sharing`` que sugiere utilizar [[Graphene]], lo que no parece del todo responsable. Después de un debate, ``Porter`` aceptó la idea de que se necesitan algunas advertencias de alto perfil para evitar que los usuarios potenciales abran sus sistemas en nombre de la "``seguridad``".

Las advertencias son un paso en la dirección correcta, pero la forma correcta de abordar este problema es incluir los parches de [[FSGSBASE]] en el núcleo para que los demás trucos ya no sean necesarios. Como beneficio adicional, estos parches también hacen que el núcleo sea más rápido, ya que las nuevas instrucciones son más rápidas que realizar operaciones en [[MSR]]. Por lo tanto, un soporte adecuado de [[FSGSBASE]] debería hacer que casi todos estén más contentos.

Como se ha señalado, es de esperar que esto suceda pronto. Sin embargo, todo este asunto ha dejado un poco de mal sabor de boca en muchos desarrolladores; hay un cierto descontento manifiesto con la forma en que Intel ha manejado la situación. Resolver eso puede llevar más tiempo.

https://board.flatassembler.net/topic.php?p=229263
```ruby
Hola a todos. ¿Hasta qué punto puedo configurar los desplazamientos fs y/o gs como desee y aún así esperar que las llamadas a kernel32.dll funcionen? Si no es posible configurar ninguno de ellos de manera segura, ¿cuánto espacio hay en cada uno que pueda usar?
```
Puede configurar otros valores, pero no valores de su elección, solo ranuras coincidentes en el [[Assembly/x86/GDT]]. El núcleo solo define algunas ranuras en el [[Assembly/x86/GDT]] y nada más. Tienen poco valor para los programas en modo usuario.

```ruby
Entonces, ¿estás diciendo que cuando mis subprocesos están haciendo sus propios asuntos y no llaman a ningún código externo, el núcleo aún espera que gs y fs apunten a ubicaciones válidas pero no especificadas (para cambios de contexto)?
```
No es el núcleo, es la ``CPU``.
Cada vez que configure ``GS``, leerá el [[Assembly/x86/GDT]] para encontrar la ranura y cargar el [[shadow-spaces]]. Su código fallará si intenta configurar un valor que el [[Assembly/x86/GDT]] no tiene. Y el [[Assembly/x86/GDT]] tiene muy pocas ranuras. Probablemente pueda hacer una copia de ``CS`` o ``DS``, pero eso es todo lo que obtendrá, todo lo demás fallará.

```ruby
Empecemos de nuevo, ya que claramente no me estoy explicando con claridad. Como usuario pobre en el mundo de los usuarios, no me importa en absoluto qué 16 bits hay realmente en fs y gs. Me interesan las direcciones hacia y desde las que instrucciones como
```
```r
mov rax, qword [gs:0] ; leer desde la ubicación X+0
mov qword [gs:8], rdx ; escribir en la ubicación X+8
```
```ruby
leer y escribir. Entiendo que esto puede ser cualquier desplazamiento de 64 bits X siempre que gs esté "configurado" en X. Simplemente estoy preguntando cómo puedo controlar X como un usuario normal y si necesito guardar y/o restaurar X antes de llamar a kernel32.dll, por ejemplo. Lo siguiente funciona perfectamente en Linux e ilustra el punto. Aquí "configura" gs en el búfer, por lo que X = dirección del búfer como se indica anteriormente.
Codigo:
```
```ruby
; this program should print "good"
ARCH_SET_GS    = 0x1001
ARCH_SET_FS    = 0x1002
ARCH_GET_FS    = 0x1003
ARCH_GET_GS    = 0x1004
sys_write      = 0x0001 
sys_arch_prctl = 0x009e
sys_exit_group = 0x00e7

format ELF64 executable
entry Start

segment readable writeable
str_good db "good",10
str_bad  db "bad",10
buffer   rb 1000

segment readable executable
Start:
   ; Establezca "gs" (lo que sea que eso signifique) en la dirección del búfer
   lea rsi, [buffer]
   mov eax, sys_arch_prctl
   mov edi, ARCH_SET_GS
   syscall
   
   mov eax, "asdf"
   mov dword[buffer],eax
   
   ; Lo siguiente debe leerse desde la misma ubicación que mov edx,dword[buffer]
   mov edx,dword[gs:0]
   
   cmp eax,edx
   je .good
   
.bad:
   mov edi, 1
   lea rsi, [str_bad]
   mov edx, 4
   mov eax, sys_write
   syscall
   
   xor edi, edi
   mov eax, sys_exit_group
   syscall
   
.good:
   mov edi, 1
   lea rsi, [str_good]
   mov edx, 5
   mov eax, sys_write
   syscall
   
   xor edi, edi
   mov eax, sys_exit_group
   syscall
```

^24eaf9

Bien, recapitulemos, por si acaso. Como usuario, no puedes establecer [[GS]] con un valor de tu elección. La tabla [[Assembly/x86/GDT]] no lo admite. La ``CPU`` evitará que establezcas un valor aleatorio.

Para el código ``Linux``, estás usando el núcleo para crear una nueva entrada en la [[Assembly/x86/GDT]] que permite que [[GS]] apunte a una ubicación de memoria aleatoria. Pero no hay una ``API de Windows`` similar a la que puedas llamar para pedirle al núcleo que cree una nueva entrada en la [[Assembly/x86/GDT]].

```ruby
Creo que se ha generado cierta confusión porque mencionaste los registros de segmento en el título.

Así que, para cualquiera que lea esto, puede que se confunda. Los registros de segmento solo existen en modo real. En modo protegido, se reutilizan los mismos nombres (CS, DS, etc.) para los selectores, que apuntan a entradas en el GDT (y LDT). El GDT/
```
[[LDT]]
```ruby
son áreas de memoria protegidas que el núcleo mantiene para definir el entorno de ejecución de la CPU.
```

Creo que estás aumentando la confusión al mencionar [[Assembly/x86/GDT]], cuando en el modo largo la base de [[FS]] y [[GS]] no está controlada por [[Assembly/x86/GDT]], sino por un [[MSR]] dedicado. E incluso hay instrucciones especializadas ([[RDFSBASE]]/[[RDGSBASE]] y [[WRFSBASE]]/[[WRGSBASE]]) que permiten acceder a estos valores directamente. Como explicó ``Feryno`` ([en el hilo vinculado](https://board.flatassembler.net/topic.php?p=216136#216136) vea [[db-26-in-x64]] El soporte para este tipo de trucos en Windows va y viene. Probablemente no haya nada en lo que puedas confiar, porque no se ha documentado oficialmente que se admita nada a este nivel. A partir de Windows 11, no se admite la programación en modo usuario. Todas las llamadas fallan con el error ERROR_NOT_SUPPORTED.[# Bringing Call Gates Back](https://www.alex-ionescu.com/bringing-call-gates-back/)), hay configuraciones adicionales a tener en cuenta, pero como demuestra mi ejemplo, al menos en algunas circunstancias se puede hacer incluso desde el modo de usuario.


[[FS]], [[GS]] se pueden cambiar generalmente en ``modo kernel``. En instrucciones como ``MOV FS,AX`` / ``MOV GS,AX`` las bases ``fs``/``gs`` se cargan desde [[Assembly/x86/GDT]] (solo ``bases de 32 bits`` debido a las limitaciones de [[Assembly/x86/GDT]]). Debido a que estas bases se expanden a ``64 bits`` para admitir sistemas operativos de ``64 bits``, el kernel después de ``MOV FS,AX`` / ``MOV GS,AX`` ejecuta instrucciones [[WRMSR]] con estos valores en ``ECX``:
Código:
```js
MSR_IA32_FS_BASE        = 0C0000100h
MSR_IA32_GS_BASE        = 0C0000101h
MSR_IA32_KERNEL_GS_BASE = 0C0000102h
```

No puede ejecutar [[WRMSR]] en modo usuario para ajustar estas bases, la instrucción [[WRMSR]] tiene privilegios ``ring0``.
Más tarde se introdujeron métodos adicionales como las instrucciones [[RDFSBASE]] [[WRFSBASE]] [[RDGSBASE]] [[WRGSBASE]] - lea el enlace publicado por ``Tomasz``.
Encontré un método interesante para ajustar las bases desde el modo usuario en ``Linux`` mediante una llamada al sistema. En ``ms win x64`` no conozco un método similar y sencillo, pero puedes ejecutar un proceso secundario como depurador y luego ajustar sus registros usando llamadas del sistema dedicadas al depurador:
https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessa [[CreateProcessA]]
es necesario establecer ``dwCreationFlags`` en ``DEBUG_PROCESS`` o en ``DEBUG_PROCESS+DEBUG_ONLY_THIS_PROCESS``
El kernel, al cambiar de [[ring-3]] a [[ring-0]], ejecuta [[SWAPGS]] como una forma rápida de cambiar las bases [[GS]] de [[ring-3]] y [[ring-0]] y también ejecuta lo mismo justo antes de volver a cambiar de [[ring-0]] a [[ring-3]] (normalmente la secuencia de código [[SWAPGS]] \ ``iretq``, [[SWAPGS]] \ ``sysretq``). Así que no juegues con la base [[GS]] de [[ring-0]].