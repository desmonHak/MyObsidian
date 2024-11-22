https://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like

### ¿Cómo se ve el lenguaje ensamblador multinúcleo?
En el pasado, para escribir en ensamblador x86, por ejemplo, se tenían instrucciones que decían "cargar el registro EDX con el valor 5", "incrementar el registro EDX", etc.

Con las CPU modernas que tienen 4 núcleos (o incluso más), a nivel de código de máquina, ¿parece que hay 4 CPU independientes (es decir, hay solo 4 registros "EDX" distintos)? Si es así, cuando dices "incrementar el registro EDX", 

¿qué determina qué registro EDX de la CPU se incrementa? 
¿Existe un concepto de "contexto de CPU" o "hilo" en el ensamblador x86 ahora?
¿Cómo funciona la comunicación/sincronización entre los núcleos?


Si estuvieras escribiendo un sistema operativo, 
¿qué mecanismo se expone a través del hardware para permitirte programar la ejecución en diferentes núcleos? 
¿Se trata de alguna instrucción privilegiada especial?

Si estuviera escribiendo un compilador optimizador/máquina virtual de código de bytes para una CPU multinúcleo, ¿qué necesitaría saber específicamente sobre, por ejemplo, x86 para que genere código que se ejecute de manera eficiente en todos los núcleos?

¿Qué cambios se han realizado en el código de máquina x86 para admitir la funcionalidad multinúcleo?


Esta no es una respuesta directa a la pregunta, pero es una respuesta a una pregunta que aparece en los comentarios. Básicamente, la pregunta es qué soporte da el hardware a la operación multinúcleo, la capacidad de ejecutar múltiples subprocesos de software al mismo tiempo, sin que el software cambie de contexto entre ellos (a veces llamado un sistema SMP).

Nicholas Flynt tenía razón, al menos en lo que respecta a x86. En un entorno multinúcleo (hiperprocesamiento, multinúcleo o multiprocesador), el núcleo Bootstrap (normalmente el subproceso de hardware (también conocido como núcleo lógico) 0 en el núcleo 0 en el procesador 0) comienza a buscar código desde la dirección 0xfffffff0. Todos los demás núcleos (subprocesos de hardware) se inician en un estado de suspensión especial llamado Wait-for-SIPI. Como parte de su inicialización, el núcleo principal envía una interrupción especial entre procesadores (IPI) a través del APIC llamada SIPI (Startup IPI) a cada núcleo que está en WFS. El SIPI contiene la dirección desde la que ese núcleo debe comenzar a buscar código.

Este mecanismo permite que cada núcleo ejecute código desde una dirección diferente. Todo lo que se necesita es soporte de software para que cada núcleo de hardware configure sus propias tablas y colas de mensajes.

El sistema operativo las usa para realizar la programación multiproceso real de las tareas de software. (Un sistema operativo normal solo tiene que iniciar otros núcleos una vez, en el arranque, a menos que esté conectando CPU en caliente, por ejemplo, en una máquina virtual. Esto es independiente de iniciar o migrar subprocesos de software a esos núcleos. Cada núcleo ejecuta el núcleo, que pasa su tiempo llamando a una función de suspensión para esperar una interrupción si no hay nada más que hacer).

En lo que respecta al ensamblaje real, como escribió Nicholas, no hay diferencia entre los ensamblajes para una aplicación de un solo subproceso o de múltiples subprocesos. Cada núcleo tiene su propio conjunto de registros (contexto de ejecución), por lo que escribir:
```js
mov edx, 0
```
solo actualizará EDX para el subproceso que se está ejecutando actualmente. No hay forma de modificar EDX en otro procesador usando una sola instrucción de ensamblaje. Necesita algún tipo de llamada al sistema para solicitarle al SO que le indique a otro subproceso que ejecute código que actualizará su propio EDX.

### Ejemplo de hardware básico ejecutable mínimo de Intel x86

[Ejemplo de hardware básico ejecutable con todo el código repetitivo necesario](https://github.com/cirosantilli/x86-bare-metal-examples/blob/4ada3c2cd03784d53e263ec7eb35722d41d6de7a/smp.S). Todas las partes principales se describen a continuación.
```js
/*
# SMP

Expected output: "SMP started"

http://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like/33651438#33651438
*/

/* Must be a multiple of 0x1000. */
.equ STARTUP_CODE_ADDRESS, 0x1000
.equ SPINLOCK_ADDRESS, 0x2000

#include "common.h"
BEGIN
    STAGE2
    CLEAR
    /*
    TODO do we need 32-bit mode? I think yes because the APIC register
    FEE00300 is too high for 16-bit?
    */
    PROTECTED_MODE
    IDT_SETUP_48_ISRS
    REMAP_PIC_32
    PIT_GENERATE_FREQUENCY
    /* Each tick is 20us. */
    PIT_SET_FREQ 50000
    sti

    /*
    Setup the code that will be run
    on the other processors when they start up.
    Should be somewhere into the first 1Mb,
    as processors start in real mode.
    */
    cld
    mov $init_len, %ecx
    mov $init, %esi
    mov $STARTUP_CODE_ADDRESS, %edi
    rep movsb

    /* Setup the value that threads will modify for us. */
    movb $0, SPINLOCK_ADDRESS

    /*
    Move data into the lower ICR register:
    this should start the other processors.
    - Destination Shorthand = 11 = all except self
    - Trigger Mode = ?
    - Level = ?
    - Delivery Status = 0 = Idle
    - Destination Mode = ? = Does not matter since shorthand used
    - Delivery Mode = 110 = Startup
    - Vector = ? = does it matter for SIPI?
    */

    /* Load address of ICR low dword into ESI. */
    mov PIC_ICR_ADDRESS, %esi
    /* Load ICR encoding for broadcast INIT IPI to all APs. */
    mov $0x000C4500, %eax
    /* Broadcast INIT IPI to all APs */
    mov %eax, (%esi)
    /* 10-millisecond delay loop. */
    PIT_SLEEP_TICKS $500
    /*
    Load ICR encoding for broadcast SIPI IP to all APs.
    The low byte of this is the vector which encodes the staring address for the processors!
    This address is multiplied by 0x1000: processors start at CS = vector * 0x100 and IP = 0.
    */
    mov $0x000C4600 + STARTUP_CODE_ADDRESS / 0x1000, %eax
    /* Broadcast SIPI IPI to all APs. */
    mov %eax, (%esi)
    /* 200-microsecond delay loop. */
    PIT_SLEEP_TICKS $10
    /* Broadcast second SIPI IPI to all APs */
    mov %eax, (%esi)

    /* TODO improve this spinlock. */
not_started:
    cmpb $1, SPINLOCK_ADDRESS
    jne not_started

    /*
    This only happens if another thread starts and changes the spinlock.
    So if we see the message, SMP is working!
    */
    VGA_PRINT_STRING $message

    /* Testing if it is possible in 16-bit real mode. */
    /*PRINT_STRING $message*/
    hlt
message:
    .asciz "SMP started"
IDT_48_ENTRIES
PIT_SLEEP_TICKS_GLOBALS
interrupt_handler:
    cmp PIT_ISR_NUMBER, 4(%esp)
    jne not_pit
    PIT_SLEEP_TICKS_HANDLER_UPDATE
not_pit:
    ret

/*
Code that will run on the second, third,
etc. processors (Application Processors),
*/
.code16
init:
    xor %ax, %ax
    mov %ax, %ds
    movb $1, SPINLOCK_ADDRESS
    /*
    TODO mandatory?
    - is lock prefix enough?
    - is caching even on? I not because of CR0.CD and CR0.NW
    */
    wbinvd
    hlt
.equ init_len, . - init
```

Probado en Ubuntu 15.10 QEMU 2.3.0 y en el [hardware invitado real](https://stackoverflow.com/questions/22054578/how-to-run-a-program-without-an-operating-system/32483545#32483545) Lenovo ThinkPad T400.

[El Manual de Intel, Volumen 3, Guía de programación del sistema - 325384-056US, septiembre de 2015, cubre SMP en los capítulos 8, 9 y 10](https://web.archive.org/web/20151025081259/http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-system-programming-manual-325384.pdf).

La Tabla 8-1. "Secuencia de transmisión INIT-SIPI-SIPI y elección de tiempos de espera" contiene un ejemplo que básicamente funciona:
```js
MOV ESI, ICR_LOW    ; Cargar la dirección del dword bajo de ICR en ESI.
MOV EAX, 000C4500H  ; Cargar codificación ICR para transmisión INIT IPI
                    ; a todos los AP en EAX.
MOV [ESI], EAX      ; Transmitir INIT IPI a todos los AP
; Bucle de retardo de 10 milisegundos.
MOV EAX, 000C46XXH  ; Cargar codificación ICR para transmisión SIPI IP
                    ; a todos los AP en EAX, donde xx es el vector 
                    ; calculado en el paso 10.
MOV [ESI], EAX      ; Transmitir SIPI IPI a todos los AP
					; Bucle de retardo de 200 microsegundos
MOV [ESI], EAX      ; Transmitir segundo SIPI IPI a todos los AP
                    ; Espera la interrupción del temporizador hasta 
	                ; que el temporizador expire
```
En ese código:

1. La mayoría de los sistemas operativos harán que la mayoría de esas operaciones sean imposibles desde el [[ring-3]] (programas de usuario).
Por lo tanto, es necesario escribir su propio núcleo para jugar libremente con él: 
un programa Linux de usuario no funcionará.

2. Al principio, se ejecuta un solo procesador, llamado procesador de arranque ([[BSP]]).
Debe despertar a los demás (llamados procesadores de aplicación (AP)) a través de interrupciones especiales llamadas [interrupciones entre procesadores (IPI)](https://en.wikipedia.org/wiki/Inter-processor_interrupt).

Esas interrupciones se pueden realizar programando el controlador de interrupciones programable avanzado ([[APIC]] o [[x2APIC]]) a través del registro de comandos de interrupción ([[ICR]]).
El formato del [[ICR]] está documentado en: 10.6 "EMISIÓN DE INTERRUPCIONES ENTRE PROCESADORES"
El IPI se produce tan pronto como escribimos en el ICR.
3. ICR_LOW se define en 8.4.4 "Ejemplo de inicialización de MP" como:
```r
ICR_LOW EQU 0x0FEE00300
```

El valor mágico ``0FEE00300`` es la dirección de memoria del [[ICR]], como se documenta en la Tabla 10-1 "Mapa de direcciones de registros [[APIC]] locales"

4. En el ejemplo se utiliza el método más simple posible: se configura el [[ICR]] para que envíe IPI de difusión que se envían a todos los demás procesadores excepto al actual.

Pero también es posible, [y algunos lo recomiendan](https://stackoverflow.com/a/16368043/895245), obtener información sobre los procesadores a través de estructuras de datos especiales configuradas por el BIOS, [como las tablas ACPI o la tabla de configuración MP de Intel]([ACPI tables or Intel's MP configuration table](https://stackoverflow.com/questions/6146059/how-can-i-detect-the-number-of-cores-in-x86-assembly)), y activar solo los que se necesitan uno por uno.

5. ``XX`` en ``0x000C46XX`` codifica la dirección de la primera instrucción que ejecutará el procesador como:
```c
CS = XX * 0x100
IP = 0
```
Recuerde que [[CS]] multiplica las direcciones por ``0x10``, por lo que la dirección de memoria real de la primera instrucción es:
```c
XX * 0x1000
```
Por ejemplo, si ``XX == 1``, el procesador comenzará en ``0x1000``.

Debemos asegurarnos de que haya un código de [[Assembly/MODOS/modo-real]] de ``16 bits`` para ejecutar en esa ubicación de memoria, por ejemplo:
```js
mov $init_len, %ecx
mov $init, %esi
mov 0x1000, %edi
rep movsb

.code16
init:
    xor %ax, %ax
    mov %ax, %ds
    /* Do stuff. */
    hlt
.equ init_len, . - init
```
Otra posibilidad es utilizar un script enlazador.

6. Los bucles de retardo son una parte molesta para hacer funcionar: no hay una manera súper simple de hacer esos ciclos de suspensión con precisión. Los métodos posibles incluyen:
- PIT (usado en mi ejemplo)
- HPET
- Calibre el tiempo de un bucle ocupado con lo anterior y utilícelo en su lugar
Relacionado: [¿Cómo mostrar un número en la pantalla y suspender durante un segundo con el ensamblaje DOS x86?](https://stackoverflow.com/questions/9971405/how-to-display-a-number-on-the-screen-and-and-sleep-for-one-second-with-dos-x86)
7. Creo que el procesador inicial debe estar en [[Assembly/MODOS/modo-protegido]] para que esto funcione, ya que escribimos en la dirección ``0FEE00300H``, que es demasiado alta para ``16 bits``.
8. Para comunicarnos entre procesadores, podemos usar un spinlock en el proceso principal y modificar el bloqueo desde el segundo núcleo.
	Debemos asegurarnos de que la escritura en memoria se realice, por ejemplo, a través de [[WBINVD]].

### Estado compartido entre procesadores
8.7.1 "Estado de los procesadores lógicos" dice:

Las siguientes características forman parte del estado arquitectónico de los procesadores lógicos de los procesadores Intel 64 o IA-32 que admiten la tecnología Intel [[Hyper-Threading]]. Las características se pueden subdividir en tres grupos:
- Duplicado para cada procesador lógico
- Compartido por procesadores lógicos en un procesador físico
- Compartido o duplicado, según la implementación

Las siguientes características están duplicadas para cada procesador lógico:
- Registros de propósito general (``EAX``, ``EBX``, ``ECX``, ``EDX``, ``ESI``, ``EDI``, ``ESP`` y ``EBP``)
- Registros de segmento ([[CS]], [[DS]], [[SS]], [[ES]], [[FS]] y [[GS]])
- Registros [[Registros#^7febb0|EFLAGS]] y ``EIP``. Tenga en cuenta que los registros [[CS]] y ``EIP``/``RIP`` para cada procesador lógico apuntan al flujo de instrucciones para el subproceso que está ejecutando el procesador lógico. - Registros FPU [[x87]] (de [[TopSpeed-Clarion-JPI#^efbd62|ST0]] a ST7, palabra de estado, palabra de control, palabra de etiqueta, puntero de operando de datos y puntero de instrucción)
- Registros [[Registros#^7e46b4|MMX]] (de MM0 a MM7)
- Registros [[ADD#^65fa53|XMM]] (de XMM0 a XMM7) y el registro [[MXCSR]]
- Registros de control y registros de puntero de tabla del sistema ([[GDTR]], [[modelos-memoria#^57f7ab|LDTR]], [[Registros#^bccb95|IDTR]], [[Registros#^bd44f7|registro de tareas (TR)]])
- [[Registros#^7d52f7|Registros de depuración]] (DR0, DR1, DR2, DR3, DR6, DR7) y los MSR de control de depuración
- [[MSR]] de estado global de verificación de máquina (``IA32_MCG_STATUS``) y capacidad de verificación de máquina (``IA32_MCG_CAP``)
- [[MSR]] de control de administración de energía [[ACPI]] y modulación de reloj térmico
- [[MSR]] de contador de sello de tiempo
- La mayoría de los otros registros [[MSR]], incluida la tabla de atributos de página ([[PAT]]). Vea las excepciones a continuación.
- Registros [[APIC]] locales.
- Registros de propósito general adicionales (R8-R15), registros XMM (XMM8-XMM15), registro de control, IA32_EFER en procesadores Intel 64.

Los procesadores lógicos comparten las siguientes características:
- [[Registros#^af9eb5|Registros de rango de tipo de memoria]] (MTRR)

El hecho de que las siguientes características se compartan o dupliquen depende de la implementación:
- MSR IA32_MISC_ENABLE (dirección de [[MSR]] 1A0H)
- [[MSR]] de arquitectura de verificación de máquina (MCA) (excepto los [[MSR]] IA32_MCG_STATUS e IA32_MCG_CAP)
- [[MSR]] de control y contador de monitoreo de rendimiento

El uso compartido de caché se analiza en:
- [¿Cómo se comparten las memorias caché en las CPU multinúcleo de Intel?](https://stackoverflow.com/questions/944966/how-are-cache-memories-shared-in-multicore-intel-cpus/33510874#33510874)
- [http://stackoverflow.com/questions/4802565/multiple-threads-and-cpu-cache](http://stackoverflow.com/questions/4802565/multiple-threads-and-cpu-cache)
- [¿Pueden varias CPU/núcleos acceder a la misma RAM simultáneamente?](http://programmers.stackexchange.com/questions/183686/can-multiple-cpus-cores-access-the-same-ram-simutaneously)

Los hiperprocesos(hyperthreads) de Intel comparten más caché y canalización que los núcleos separados: [https://superuser.com/questions/133082/hyper-threading-and-dual-core-whats-the-difference/995858#995858](https://superuser.com/questions/133082/hyper-threading-and-dual-core-whats-the-difference/995858#995858)

### Ejemplo de hardware básico ejecutable mínimo de ARM
Aquí proporciono un ejemplo mínimo ejecutable de ARMv8 aarch64 para QEMU:
```js
global mystart
mystart:
    /* Reset spinlock. */
    mov x0, #0
    ldr x1, =spinlock
    str x0, [x1]

    /* Read cpu id into x1.
     * TODO: cores beyond 4th?
     * Mnemonic: Main Processor ID Register
     */
    mrs x1, mpidr_el1
    ands x1, x1, 3
    beq cpu0_only
cpu1_only:
    /* Only CPU 1 reaches this point and sets the spinlock. */
    mov x0, 1
    ldr x1, =spinlock
    str x0, [x1]
    /* Ensure that CPU 0 sees the write right now.
     * Optional, but could save some useless CPU 1 loops.
     */
    dmb sy
    /* Wake up CPU 0 if it is sleeping on wfe.
     * Optional, but could save power on a real system.
     */
    sev
cpu1_sleep_forever:
    /* Hint CPU 1 to enter low power mode.
     * Optional, but could save power on a real system.
     */
    wfe
    b cpu1_sleep_forever
cpu0_only:
    /* Only CPU 0 reaches this point. */

    /* Wake up CPU 1 from initial sleep!
     * See:https://github.com/cirosantilli/linux-kernel-module-cheat#psci
     */
    /* PCSI function identifier: CPU_ON. */
    ldr w0, =0xc4000003
    /* Argument 1: target_cpu */
    mov x1, 1
    /* Argument 2: entry_point_address */
    ldr x2, =cpu1_only
    /* Argument 3: context_id */
    mov x3, 0
    /* Unused hvc args: the Linux kernel zeroes them,
     * but I don't think it is required.
     */
    hvc 0

spinlock_start:
    ldr x0, spinlock
    /* Hint CPU 0 to enter low power mode. */
    wfe
    cbz x0, spinlock_start

    /* Semihost exit. */
    mov x1, 0x26
    movk x1, 2, lsl 16
    str x1, [sp, 0]
    mov x0, 0
    str x0, [sp, 8]
    mov x1, sp
    mov w0, 0x18
    hlt 0xf000

spinlock:
    .skip 8

```
[GitHub upstream](https://github.com/cirosantilli/linux-kernel-module-cheat/blob/ba2976cc7f3fedde691f771d38fcdb4ce2e12b94/baremetal/arch/aarch64/multicore.S).
Ensamblar y ejecutar:
```c
aarch64-linux-gnu-gcc \
  -mcpu=cortex-a57 \
  -nostdlib \
  -nostartfiles \
  -Wl,--section-start=.text=0x40000000 \
  -Wl,-N \
  -o aarch64.elf \
  -T link.ld \
  aarch64.S \
;
qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a57 \
  -d in_asm \
  -kernel aarch64.elf \
  -nographic \
  -semihosting \
  -smp 2 \
;
```

En este ejemplo, ponemos la CPU 0 en un bucle de spinlock, y solo sale cuando la CPU 1 libera el spinlock.
Después del spinlock, la CPU 0 realiza una [llamada de salida semihost](https://stackoverflow.com/questions/31990487/how-to-cleanly-exit-qemu-after-executing-bare-metal-program-without-user-interve/49930361#49930361) que hace que QEMU salga.
Si inicia QEMU con solo una CPU con `-smp 1`, entonces la simulación simplemente se cuelga para siempre en el spinlock.
La CPU 1 se activa con la interfaz PSCI, más detalles en: [ARM: Iniciar/Activar/Poner en marcha los otros núcleos/AP de la CPU y pasar la dirección de inicio de ejecución?](https://stackoverflow.com/questions/20055754/arm-start-wakeup-bringup-the-other-cpu-cores-aps-and-pass-execution-start-addre/53473447#53473447)
La [versión upstream](https://github.com/cirosantilli/linux-kernel-module-cheat/blob/ba2976cc7f3fedde691f771d38fcdb4ce2e12b94/baremetal/arch/aarch64/multicore.S) también tiene algunos ajustes para que funcione en gem5, por lo que también puede experimentar con las características de rendimiento.

No lo he probado en hardware real, por lo que no estoy seguro de su portabilidad. La siguiente bibliografía sobre Raspberry Pi puede resultar de interés:

- [https://github.com/bztsrc/raspi3-tutorial/tree/a3f069b794aeebef633dbe1af3610784d55a0efa/02_multicorec](https://github.com/bztsrc/raspi3-tutorial/tree/a3f069b794aeebef633dbe1af3610784d55a0efa/02_multicorec)
- [https://github.com/dwelch67/raspberrypi/tree/a09771a1d5a0b53d8e7a461948dc226c5467aeec/multi00](https://github.com/dwelch67/raspberrypi/tree/a09771a1d5a0b53d8e7a461948dc226c5467aeec /multi00) 
- [https://github.com/LdB-ECM/Raspberry-Pi/blob/3b628a2c113b3997ffdb408db03093b2953e4961/Multicore/SmartStart64.S](https://github.com/LdB-ECM/Raspberry-Pi/blob/3b628a2c113b3997ffdb408db0309 3b2953e4961/Multinúcleo/SmartStart64.S) - [https://github.com/LdB-ECM/Raspberry-Pi/blob/3b628a2c113b3997ffdb408db03093b2953e4961/Multicore/SmartStart32.S](https://github.com/LdB-ECM/Raspberry-Pi/blob/3b628a2c113b3997ffdb408db03093b2953e4961/Multicore/SmartStart32.S)

Este documento proporciona algunas pautas sobre el uso de primitivas de sincronización ARM que luego puede usar para hacer cosas divertidas con múltiples núcleos: [http://infocenter.arm.com/help/topic/com.arm.doc.dht0008a/DHT0008A_arm_synchronization_primitives.pdf](http://infocenter.arm.com/help/topic/com.arm.doc.dht0008a/DHT0008A_arm_synchronization_primitives.pdf)
Probado en Ubuntu 18.10, GCC 8.2.0, Binutils 2.31.1, QEMU 2.12.0.

## Próximos pasos para una programación más conveniente

Los ejemplos anteriores activan la CPU secundaria y realizan una sincronización básica de la memoria con instrucciones dedicadas, lo que es un buen comienzo.
Pero para que los sistemas multinúcleo sean fáciles de programar, por ejemplo, como los `pthreads` de [POSIX](https://stackoverflow.com/questions/1780599/what-is-the-meaning-of-posix/31865755#31865755), también deberá abordar los siguientes temas más complejos:

- configurar interrupciones y ejecutar un temporizador que decida periódicamente qué hilo se ejecutará ahora. Esto se conoce como [multihilo preventivo](https://en.wikipedia.org/wiki/Preemption_(computing)#Preemptive_multitasking).
Dicho sistema también necesita guardar y restaurar los registros de los hilos a medida que se inician y se detienen.
También es posible tener sistemas multitarea no preventivos, pero estos pueden requerir que modifiques tu código para que todos los subprocesos cedan (por ejemplo, con una implementación `pthread_yield`), y se vuelve más difícil equilibrar las cargas de trabajo.
Estos son algunos ejemplos simplistas de temporizadores de hardware:
- [x86 PIT](https://github.com/cirosantilli/x86-bare-metal-examples/blob/6dc9a73830fc05358d8d66128f740ef9906f7677/pit.S)
- lidiar con conflictos de memoria. En particular, cada hilo necesitará una [pila única](https://stackoverflow.com/questions/4584089/what-is-the-function-of-the-push-pop-instructions-used-on-registers-in-x86-ass/33583134#33583134) si desea codificar en C u otros lenguajes de alto nivel.
Podría limitar los hilos para que tengan un tamaño de pila máximo fijo, pero la mejor manera de lidiar con esto es con la [paginación](https://stackoverflow.com/questions/18431261/how-does-x86-paging-work) que permite pilas eficientes de "tamaño ilimitado".
Aquí hay [un ejemplo sencillo de aarch64 con hardware básico que explotaría si la pila se volviera demasiado profunda](https://github.com/cirosantilli/linux-kernel-module-cheat/blob/d6d7f15c912ed6371c8cf15a93f43488d6fc5efb/baremetal/arch/aarch64/multicore.c)
Esas son algunas buenas razones para usar el kernel de Linux o algún otro sistema operativo :-)

## Primitivas de sincronización de memoria de usuario
Aunque el inicio/detención/gestión de subprocesos generalmente está fuera del alcance del usuario, puede usar instrucciones de ensamblaje de subprocesos de usuario para sincronizar accesos a memoria sin llamadas al sistema potencialmente más costosas.

Por supuesto, debería preferir usar bibliotecas que envuelvan de manera portátil estas primitivas de bajo nivel. El estándar C++ en sí ha hecho grandes avances en los encabezados [`<mutex>`](https://en.cppreference.com/w/cpp/thread/mutex) y [`<atomic>`](https://en.cppreference.com/w/cpp/header/atomic), y en particular con [`std::memory_order`](https://en.cppreference.com/w/cpp/atomic/memory_order). No estoy seguro de si cubre todas las semánticas de memoria posibles, pero podría ser así.

La semántica más sutil es particularmente relevante en el contexto de [estructuras de datos libres de bloqueo](https://en.wikipedia.org/wiki/Non-blocking_algorithm), que pueden ofrecer beneficios de rendimiento en ciertos casos. Para implementarlas, probablemente tendrás que aprender un poco sobre los diferentes tipos de barreras de memoria: [https://preshing.com/20120710/memory-barriers-are-like-source-control-operations/](https://preshing.com/20120710/memory-barriers-are-like-source-control-operations/)

Boost, por ejemplo, tiene algunas implementaciones de contenedores sin bloqueos en: [https://www.boost.org/doc/libs/1_63_0/doc/html/lockfree.html](https://www.boost.org/doc/libs/1_63_0/doc/html/lockfree.html)

Esas instrucciones de espacio de usuario también parecen usarse para implementar la llamada al sistema `futex` de Linux, que es una de las principales primitivas de sincronización en Linux. `man futex` 4.15 dice:

> La llamada al sistema futex() proporciona un método para esperar hasta que una determinada condición se vuelva verdadera. Normalmente se utiliza como una construcción de bloqueo en el contexto de la sincronización de memoria compartida. Cuando se utilizan futexes, la mayoría de las operaciones de sincronización se realizan en el espacio de usuario. Un programa de espacio de usuario emplea la llamada al sistema futex() solo cuando es probable que el programa tenga que bloquearse durante un tiempo más largo hasta que la condición se vuelva verdadera. Se pueden utilizar otras operaciones futex() para despertar cualquier proceso o subproceso que esté esperando una condición particular.

El nombre de la llamada al sistema en sí significa "Espacio de usuario rápido XXX".

A continuación se muestra un ejemplo mínimo inútil de C++ x86_64 / aarch64 con ensamblaje en línea que ilustra el uso básico de dichas instrucciones, principalmente por diversión:

main.cpp:
```cpp
#include <atomic>
#include <cassert>
#include <iostream>
#include <thread>
#include <vector>

std::atomic_ulong my_atomic_ulong(0);
unsigned long my_non_atomic_ulong = 0;
#if defined(__x86_64__) || defined(__aarch64__)
unsigned long my_arch_atomic_ulong = 0;
unsigned long my_arch_non_atomic_ulong = 0;
#endif
size_t niters;

void threadMain() {
    for (size_t i = 0; i < niters; ++i) {
        my_atomic_ulong++;
        my_non_atomic_ulong++;
#if defined(__x86_64__)
        __asm__ __volatile__ (
            "incq %0;"
            : "+m" (my_arch_non_atomic_ulong)
            :
            :
        );
        // https://github.com/cirosantilli/linux-kernel-module-cheat#x86-lock-prefix
        __asm__ __volatile__ (
            "lock;"
            "incq %0;"
            : "+m" (my_arch_atomic_ulong)
            :
            :
        );
#elif defined(__aarch64__)
        __asm__ __volatile__ (
            "add %0, %0, 1;"
            : "+r" (my_arch_non_atomic_ulong)
            :
            :
        );
        // https://github.com/cirosantilli/linux-kernel-module-cheat#arm-lse
        __asm__ __volatile__ (
            "ldadd %[inc], xzr, [%[addr]];"
            : "=m" (my_arch_atomic_ulong)
            : [inc] "r" (1),
              [addr] "r" (&my_arch_atomic_ulong)
            :
        );
#endif
    }
}

int main(int argc, char **argv) {
    size_t nthreads;
    if (argc > 1) {
        nthreads = std::stoull(argv[1], NULL, 0);
    } else {
        nthreads = 2;
    }
    if (argc > 2) {
        niters = std::stoull(argv[2], NULL, 0);
    } else {
        niters = 10000;
    }
    std::vector<std::thread> threads(nthreads);
    for (size_t i = 0; i < nthreads; ++i)
        threads[i] = std::thread(threadMain);
    for (size_t i = 0; i < nthreads; ++i)
        threads[i].join();
    assert(my_atomic_ulong.load() == nthreads * niters);
    // We can also use the atomics direclty through `operator T` conversion.
    assert(my_atomic_ulong == my_atomic_ulong.load());
    std::cout << "my_non_atomic_ulong " << my_non_atomic_ulong << std::endl;
#if defined(__x86_64__) || defined(__aarch64__)
    assert(my_arch_atomic_ulong == nthreads * niters);
    std::cout << "my_arch_non_atomic_ulong " << my_arch_non_atomic_ulong << std::endl;
#endif
}
```
[GitHub upstream](https://github.com/cirosantilli/linux-kernel-module-cheat/blob/77c7df5fcded3a87aaed1de0f8d2335ba909d574/userland/cpp/atomic.cpp).

Possible output:
```
my_non_atomic_ulong 15264
my_arch_non_atomic_ulong 15267
```

De esto vemos que el prefijo x86 LOCK / instrucción aarch64 `LDADD` hizo que la adición fuera atómica: sin él tenemos condiciones de carrera en muchas de las adiciones, y el recuento total al final es menor que los 20000 sincronizados.

Ver también:

- x86
	- [[LOCK]] [¿Qué significa la instrucción "lock" en el ensamblaje x86?](https://stackoverflow.com/questions/8891067/what-does-the-lock-instruction-mean-in-x86-assembly/56803909#56803909)
	- [[PAUSE]] [¿Cómo funciona la instrucción de pausa x86 en spinlock *y* puede usarse en otros escenarios?](https://stackoverflow.com/questions/4725676/how-does-x86-pause-instruction-work-in-spinlock-and-can-it-be-used-in-other-sc)
- ARM
	- LDXR/STXR, LDAXR/STLXR: [ARM64: LDXR/STXR vs LDAXR/STLXR](https://stackoverflow.com/questions/21535058/arm64-ldxr-stxr-vs-ldaxr-stlxr)
	- LDADD y otras modificaciones de carga de la v8.1 atómicas almacenan Instrucciones: [http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0801g/alc1476202791033.html](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0801g/alc1476202791033.html)
	- WFE/SVE: [Manejo de instrucciones WFE en ARM](https://stackoverflow.com/questions/18825145/wfe-instruction-handling-in-arm)
	- [¿Qué es exactamente std::atomic?](https://stackoverflow.com/questions/31978324/what-exactly-is-stdatomic/58904448#58904448)

Probado en Ubuntu 19.04 amd64 y con el modo de usuario QEMU aarch64.