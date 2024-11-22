# RDTSCP — Leer el contador de marca de tiempo y el identificador del procesador
https://www.felixcloutier.com/x86/rdtscp
https://stackoverflow.com/questions/27693145/rdtscp-versus-rdtsc-cpuid

Vea también  [[RDTSC]]

| Opcode*      | Instruction | Op/En | 64-Bit Mode | Compat/Leg Mode | Description                                                                                         |
| ------------ | ----------- | ----- | ----------- | --------------- | --------------------------------------------------------------------------------------------------- |
| ``0F 01 F9`` | [[RDTSCP]]  | ZO    | Valid       | Valid           | Lee el contador de marca de tiempo de 64 bits y el valor ``IA32_TSC_AUX`` en ``EDX:EAX`` y ``ECX``. |

## Codificación de operandos de instrucciones [¶](https://www.felixcloutier.com/x86/rdtscp#instruction-operand-encoding)

|Op/En|Operand 1|Operand 2|Operand 3|Operand 4|
|---|---|---|---|---|
|ZO|N/A|N/A|N/A|N/A|

## Description [¶](https://www.felixcloutier.com/x86/rdtscp#description)
Lee el valor actual del contador de marca de tiempo del procesador (un [[MSR]] de 64 bits) en los registros ``EDX:EAX`` y también lee el valor del [[MSR]] ``IA32_TSC_AUX`` (dirección ``C0000103H``) en el registro ``ECX``. El registro ``EDX`` se carga con los 32 bits de orden superior del [[MSR]] ``IA32_TSC``; el registro ``EAX`` se carga con los 32 bits de orden inferior del [[MSR]] ``IA32_TSC``; y el registro ``ECX`` se carga con los 32 bits de orden inferior del [[MSR]] ``IA32_TSC_AUX``. En los procesadores que admiten la arquitectura Intel 64, se borran los 32 bits de orden superior de cada uno de ``RAX``, ``RDX`` y ``RCX``.

El procesador incrementa de forma monótona el contador de marca de tiempo [[MSR]] en cada ciclo de reloj y lo restablece a 0 cada vez que se reinicia el procesador. Consulte ``“Contador de marca de tiempo” en el Capítulo 18 del Manual del desarrollador de software de las arquitecturas Intel® 64 e IA-32, Volumen 3B``, para obtener detalles específicos del comportamiento del contador de marca de tiempo.

El indicador de desactivación de marca de tiempo ([[TSD]]) en el registro [[CR4]] restringe el uso de la instrucción [[RDTSCP]] de la siguiente manera. Cuando el indicador está borrado, la instrucción [[RDTSCP]] se puede ejecutar en cualquier nivel de privilegio; cuando el indicador está establecido, la instrucción solo se puede ejecutar en [[ring-0]].

La instrucción [[RDTSCP]] no es una instrucción serializadora, pero espera hasta que se hayan ejecutado todas las instrucciones anteriores y todas las cargas anteriores sean visibles globalmente.1 Pero no espera a que los almacenamientos anteriores sean visibles globalmente, y las instrucciones posteriores pueden comenzar a ejecutarse antes de que se realice la operación de lectura. Los siguientes elementos pueden guiar al software que busca ordenar las ejecuciones de [[RDTSCP]]:

- Si el software requiere que [[RDTSCP]] se ejecute solo después de que todos los almacenamientos anteriores sean visibles globalmente, puede ejecutar [[MFENCE]] inmediatamente antes de [[RDTSCP]].
- Si el software requiere que [[RDTSCP]] se ejecute antes de la ejecución de cualquier instrucción posterior (incluido cualquier acceso a la memoria), puede ejecutar [[LFENCE]] inmediatamente después de [[RDTSCP]].

Consulte “``Cambios en el comportamiento de la instrucción en la operación no raíz ``[[VMX]]``” ``en el Capítulo 26 del Manual del desarrollador de software de arquitecturas Intel® 64 e IA-32, Volumen 3C``, para obtener más información sobre el comportamiento de esta instrucción en la operación no raíz [[VMX]].

> 1. Se considera que una carga se vuelve visible globalmente cuando se determina el valor que se cargará.

## Operation [¶](https://www.felixcloutier.com/x86/rdtscp#operation)
```c
IF (CR4.TSD = 0) or (CPL = 0) or (CR0.PE = 0)
    THEN
        EDX:EAX := TimeStampCounter;
        ECX := IA32_TSC_AUX[31:0];
    ELSE (* CR4.TSD = 1 and (CPL = 1, 2, or 3) and CR0.PE = 1 *)
        #GP(0);
FI;
```

## Flags Affected [¶](https://www.felixcloutier.com/x86/rdtscp#flags-affected)
None.

## Protected Mode Exceptions [¶](https://www.felixcloutier.com/x86/rdtscp#protected-mode-exceptions)

| GP(0) | Si el indicador [[TSD]] en el registro [[CR4]] está configurado y el [[CPL]] es mayor que 0.                            |
| ----- | ----------------------------------------------------------------------------------------------------------------------- |
| UD    | Si se utiliza el prefijo [[LOCK]].<br>Si [[CPUID]].[[CPUID(0x80000001)\|80000001H]]:``EDX``.[[RDTSCP]][``bit 27``] = 0. |


## Real-Address Mode Exceptions [¶](https://www.felixcloutier.com/x86/rdtscp#real-address-mode-exceptions)

| UD  | If the [[LOCK]] prefix is used.<br>If [[CPUID]].[[CPUID(0x80000001)\|80000001H]]:``EDX``.[[RDTSCP]][``bit 27``] = 0. |
| --- | -------------------------------------------------------------------------------------------------------------------- |


## Virtual-8086 Mode Exceptions [¶](https://www.felixcloutier.com/x86/rdtscp#virtual-8086-mode-exceptions)

| GP(0) | If the [[TSD]] flag in register [[CR4]] is set.                                                                         |
| ----- | ----------------------------------------------------------------------------------------------------------------------- |
| UD    | Si se utiliza el prefijo [[LOCK]].<br>Si [[CPUID]].[[CPUID(0x80000001)\|80000001H]]:``EDX``.[[RDTSCP]][``bit 27``] = 0. |


## Compatibility Mode Exceptions [¶](https://www.felixcloutier.com/x86/rdtscp#compatibility-mode-exceptions)
Same exceptions as in protected mode.

## 64-Bit Mode Exceptions [¶](https://www.felixcloutier.com/x86/rdtscp#64-bit-mode-exceptions)
Same exceptions as in protected mode.

----

https://community.intel.com/t5/Intel-Software-Guard-Extensions/Timestamp-Cycle-Counter-TSC/m-p/1177414
Hello Amr,

Here is an excerpt from the [[SGX]] manual on this question:

[[RDTSC]] and [[RDTSCP]] are legal inside an enclave for processors that support SGX2 (subject to the value of CR4.TSD).  
For processors which support SGX1 but not SGX2, [[RDTSC]] and [[RDTSCP]] will cause ``#UD``.  
[[RDTSC]] and [[RDTSCP]] instructions may cause a VM exit when inside an enclave.  
Software developers must take into account that the [[RDTSC]]/[[RDTSCP]] results are not immune to influences by other  
software, e.g. the [[TSC]] can be manipulated by software outside the enclave.

Please refer to section of "39.6.1 Illegal Instructions" in the System Programming Guide at

[https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3d-part-4-manual.pdf](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3d-part-4-manual.pdf)

for more info.

Thanks,

Hoang

----

https://stackoverflow.com/questions/27693145/rdtscp-versus-rdtsc-cpuid
# [RDTSCP versus RDTSC + CPUID](https://stackoverflow.com/questions/27693145/rdtscp-versus-rdtsc-cpuid)
I'm doing some Linux Kernel timings, specifically in the Interrupt Handling path. I've been using RDTSC for timings, however I recently learned it's not necessarily accurate as the instructions could be happening out of order.

I then tried:
1. [[RDTSC]] + [[CPUID]] (in reverse order, here) to flush the pipeline, and **incurred up to a 60x overhead (!)** on a Virtual Machine (my working environment) due to hypercalls and whatnot. This is both with and without HW Virtualization enabled.
    
2. Most recently I've come across the [[RDTSCP]]* instruction, which seems to do what [[RDTSC]]+[[CPUID]] did, but more efficiently as it's a newer instruction - only a 1.5x-2x overhead, relatively.
    

My question: Is **RDTSCP** truly accurate as a point of measurement, and is it the "correct" way of doing the timing?

Also to be more clear, my timing is essentially like this, internally:

- Save the current cycle counter value
- Perform one type of benchmark (i.e.: disk, network)
- Add the delta of the current and previous cycle counter to an accumulator value and increment a counter, per individual interrupt
- At the end, divide the delta/accumulator by the number of interrupts to get the average cycle cost per interrupt.

*[http://www.intel.de/content/dam/www/public/us/en/documents/white-papers/ia-32-ia-64-benchmark-code-execution-paper.pdf](http://www.intel.de/content/dam/www/public/us/en/documents/white-papers/ia-32-ia-64-benchmark-code-execution-paper.pdf) page 27


A full discussion of the overhead you're seeing from the cpuid instruction is available at [this stackoverflow thread](https://stackoverflow.com/questions/12631856/difference-between-rdtscp-rdtsc-memory-and-cpuid-rdtsc). When using rdtsc, you need to use cpuid to ensure that no additional instructions are in the execution pipeline. The rdtscp instruction flushes the pipeline intrinsically. (The referenced SO thread also discusses these salient points, but I addressed them here because they're part of your question as well).

You only "need" to use cpuid+rdtsc if your processor does not support rdtscp. Otherwise, rdtscp is what you want, and will accurately give you the information you are after.

Both instructions provide you with a 64-bit, monotonically increasing counter that represents the number of cycles on the processor. If this is your pattern:

```c
uint64_t s, e;
s = rdtscp();
do_interrupt();
e = rdtscp();

atomic_add(e - s, &acc);
atomic_add(1, &counter);
```

You may still have an off-by-one in your average measurement depending on where your read happens. For instance:

```c
   T1                              T2
t0 atomic_add(e - s, &acc);
t1                                 a = atomic_read(&acc);
t2                                 c = atomic_read(&counter);
t3 atomic_add(1, &counter);
t4                                 avg = a / c;
```

It's unclear whether "[a]t the end" references a time that could race in this fashion. If so, you may want to calculate a running average or a moving average in-line with your delta.

Side-points:

1. If you do use cpuid+rdtsc, you need to subtract out the cost of the cpuid instruction, which may be difficult to ascertain if you're in a VM (depending on how the VM implements this instruction). This is really why you should stick with rdtscp.
2. Executing rdtscp inside a loop is usually a bad idea. I somewhat frequently see microbenchmarks that do things like

----

```c
for (int i = 0; i < SOME_LARGEISH_NUMBER; i++) {
   s = rdtscp();
   loop_body();
   e = rdtscp();
   acc += e - s;
}

printf("%"PRIu64"\n", (acc / SOME_LARGEISH_NUMBER / CLOCK_SPEED));
```

While this will give you a decent idea of the overall performance in cycles of whatever is in `loop_body()`, it defeats processor optimizations such as pipelining. In microbenchmarks, the processor will do a pretty good job of branch prediction in the loop, so measuring the loop overhead is fine. Doing it the way shown above is also bad because you end up with 2 pipeline stalls per loop iteration. Thus:

```c
s = rdtscp();
for (int i = 0; i < SOME_LARGEISH_NUMBER; i++) {
   loop_body();
}
e = rdtscp();
printf("%"PRIu64"\n", ((e-s) / SOME_LARGEISH_NUMBER / CLOCK_SPEED));
```

Will be more efficient and probably more accurate in terms of what you'll see in Real Life versus what the previous benchmark would tell you.

----

The 2010 Intel paper [How to Benchmark Code Execution Times on Intel ® IA-32 and IA-64 Instruction Set Architectures](https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/ia-32-ia-64-benchmark-code-execution-paper.pdf) can be considered as outdated when it comes to its recommendations to combine RDTSC/RDTSCP with CPUID.

Current Intel reference documentation recommends fencing instructions as more efficient alternatives to CPUID:

> Note that the SFENCE, LFENCE, and MFENCE instructions provide a more efficient method of controlling memory ordering than the CPUID instruction.

([Intel® 64 and IA-32 Architectures Software Developer’s Manual: Volume 3, Section 8.2.5, September 2016](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-system-programming-manual-325384.pdf))

> If software requires RDTSC to be executed only after all previous instructions have executed and all previous loads and stores are globally visible, it can execute the sequence MFENCE;LFENCE immediately before RDTSC.

([Intel RDTSC](https://www.felixcloutier.com/x86/rdtsc))

Thus, to get the TSC start value you execute this instruction sequence:

```c
mfence
lfence
rdtsc
shl     rdx, 0x20
or      rax, rdx
```

At the end of your benchmark, to get the TSC stop value:

```c
rdtscp
lfence
shl     rdx, 0x20
or      rax, rdx
```

Note that in contrast to CPUID, the lfence instruction doesn't clobber any registers, thus it isn't necessary to rescue the `EDX:EAX` registers before executing the serializing instruction.

Relevant documentation snippet:

> If software requires RDTSCP to be executed prior to execution of any subsequent instruction (including any memory accesses), it can execute LFENCE immediately after RDTSCP ([Intel RDTSCP](https://www.felixcloutier.com/x86/rdtscp))

As an example how to integrate this into a C program, see also [my GCC inline assembler implementations of the above operations](https://github.com/gsauthof/osjitter/blob/4545f212f99c0b232b64c175f4d45a51ea23f954/osjitter.c#L556-L612).

----

> Is RDTSCP truly accurate as a point of measurement, and is it the "correct" way of doing the timing?

Modern x86 CPUs can dynamically adjust the frequency to save power by under clocking (e.g. Intel's SpeedStep) and to boost performance for heavy load by over-clocking (e.g. Intel's Turbo Boost). The time stamp counter on these modern processors however counts at a constant rate (e.g. look for "constant_tsc" flag in Linux's /proc/cpuinfo).

So the answer to your question depends on what you really want to know. Unless, dynamic frequency scaling is disabled (e.g. in the BIOS) the time stamp counter can no longer be relied on to determine the number of cycles that have elapsed. However, the time stamp counter can still be relied on to determine the time that has elapsed (with some care - but I use `clock_gettime` in C - see the end of my answer).

To benchmark my matrix multiplication code and compare it to the theoretical best I need to know both the time elapsed and the cycles elapsed (or rather the effective frequency during the test).

Let me present three different methods to determine the number of cycles elapsed.

1. Disable dynamic frequency scaling in the BIOS and use the time stamp counter.
2. For Intel processors request the `core clock cycles` from the performance monitor counter.
3. [Measure the frequency under load](https://stackoverflow.com/questions/11706563/how-can-i-programmatically-find-the-cpu-frequency-with-c/25400230#25400230).

The first method is the most reliable but it requires access to BIOS and affects the performance of everything else you run (when I disable dynamic frequency scaling on my i5-4250U it runs at a constant 1.3 GHz instead of a base of 2.6 GHz). It's also inconvenient to change the BIOS only for benchmarking.

The second method is useful when you don't want to disable dynamic frequency scale and/or for systems you don't have physical access to. However, the performance monitor counters require privileged instructions which only the kernel or device drivers have access to.

The third method is useful on systems where you don't have physical access and do not have privileged access. This is the method I use most in practice. It's in principle the least reliable but in practice it's been as reliable as the second method.

Here is how I determine the time elapsed (in seconds) with C.

```c
#define TIMER_TYPE CLOCK_REALTIME

timespec time1, time2;
clock_gettime(TIMER_TYPE, &time1);
foo();
clock_gettime(TIMER_TYPE, &time2);
double dtime = time_diff(time1,time2);

double time_diff(timespec start, timespec end)
{
    timespec temp;
    if ((end.tv_nsec-start.tv_nsec)<0) {
        temp.tv_sec = end.tv_sec-start.tv_sec-1;
        temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
    } else {
        temp.tv_sec = end.tv_sec-start.tv_sec;
        temp.tv_nsec = end.tv_nsec-start.tv_nsec;
    }
    return (double)temp.tv_sec +  (double)temp.tv_nsec*1E-9;
}
```

----

The following code will ensure that `rdstcp` kicks in at exactly the right time. `RDTSCP` cannot execute too early, but it **can** execute to late because the CPU can move instructions after `rdtscp` to execute before it.

In order to prevent this we create a false dependency chain based on the fact that `rdstcp` puts its output in edx:eax

```js
rdtscp       ;rdstcp is read serialized, it will not execute too early.
;also ensure it does not execute too late
mov r8,rdx   ;rdtscp changes rdx and rax, force dependency chain on rdx
xor r8,rbx   ;push rbx, do not allow push rbx to execute OoO
xor rbx,rdx  ;rbx=r8
xor rbx,r8   ;rbx = 0
push rdx
push rax
mov rax,rbx  ;rax = 0, but in a way that excludes OoO execution.
cpuid
pop rax
pop rdx
mov rbx,r8
xor rbx,rdx  ;restore rbx
```

Note that even though this time is accurate up to a single cycle.  
You still need to run your sample many many times and take the **lowest** time of those many runs in order to get the actual running time.