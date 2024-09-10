_sched_setaffinity_(2)       System Calls Manual      _sched_setaffinity_(2)

## [NAME](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#NAME)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       sched_setaffinity, sched_getaffinity - set and get a thread's CPU
       affinity mask

## [LIBRARY](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#LIBRARY)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       Standard C library (_libc_, _-lc_)

## [SYNOPSIS](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#SYNOPSIS)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
```c
       #define _GNU_SOURCE             /* See feature_test_macros(7) */
       #include <sched.h>

       int sched_setaffinity(pid_t pid, size_t cpusetsize, const cpu_set_t *mask);
       int sched_getaffinity(pid_t pid, size_t cpusetsize,cpu_set_t *mask);
```

## [DESCRIPTION](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#DESCRIPTION)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       A thread's CPU affinity mask determines the set of CPUs on which
       it is eligible to run.  On a multiprocessor system, setting the
       CPU affinity mask can be used to obtain performance benefits.
       For example, by dedicating one CPU to a particular thread (i.e.,
       setting the affinity mask of that thread to specify a single CPU,
       and setting the affinity mask of all other threads to exclude
       that CPU), it is possible to ensure maximum execution speed for
       that thread.  Restricting a thread to run on a single CPU also
       avoids the performance cost caused by the cache invalidation that
       occurs when a thread ceases to execute on one CPU and then
       recommences execution on a different CPU.

       A CPU affinity mask is represented by the _cpu_set_t_ structure, a
       "CPU set", pointed to by _mask_.  A set of macros for manipulating
       CPU sets is described in [CPU_SET(3)](https://man7.org/linux/man-pages/man3/CPU_SET.3.html).

       **sched_setaffinity**() sets the CPU affinity mask of the thread
       whose ID is _pid_ to the value specified by _mask_.  If _pid_ is zero,
       then the calling thread is used.  The argument _cpusetsize_ is the
       length (in bytes) of the data pointed to by _mask_.  Normally this
       argument would be specified as _sizeof(cpu_set_t)_.

       If the thread specified by _pid_ is not currently running on one of
       the CPUs specified in _mask_, then that thread is migrated to one
       of the CPUs specified in _mask_.

       **sched_getaffinity**() writes the affinity mask of the thread whose
       ID is _pid_ into the _cpu_set_t_ structure pointed to by _mask_.  The
       _cpusetsize_ argument specifies the size (in bytes) of _mask_.  If
       _pid_ is zero, then the mask of the calling thread is returned.

## [RETURN VALUE](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#RETURN_VALUE)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       On success, **sched_setaffinity**() and **sched_getaffinity**() return 0
       (but see "C library/kernel differences" below, which notes that
       the underlying **sched_getaffinity**() differs in its return value).
       On failure, -1 is returned, and _[errno](https://man7.org/linux/man-pages/man3/errno.3.html)_ is set to indicate the
       error.

## [ERRORS](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#ERRORS)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       **EFAULT** A supplied memory address was invalid.

       **EINVAL** The affinity bit mask _mask_ contains no processors that are
              currently physically on the system and permitted to the
              thread according to any restrictions that may be imposed
              by _cpuset_ cgroups or the "cpuset" mechanism described in
              [cpuset(7)](https://man7.org/linux/man-pages/man7/cpuset.7.html).

       **EINVAL** (**sched_getaffinity**() and, before Linux 2.6.9,
              **sched_setaffinity**()) _cpusetsize_ is smaller than the size
              of the affinity mask used by the kernel.

       **EPERM**  (**sched_setaffinity**()) The calling thread does not have
              appropriate privileges.  The caller needs an effective
              user ID equal to the real user ID or effective user ID of
              the thread identified by _pid_, or it must possess the
              **CAP_SYS_NICE** capability in the user namespace of the
              thread _pid_.

       **ESRCH**  The thread whose ID is _pid_ could not be found.

## [STANDARDS](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#STANDARDS)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       Linux.

## [HISTORY](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#HISTORY)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       Linux 2.5.8, glibc 2.3.

       Initially, the glibc interfaces included a _cpusetsize_ argument,
       typed as _unsigned int_.  In glibc 2.3.3, the _cpusetsize_ argument
       was removed, but was then restored in glibc 2.3.4, with type
       _size_t_.

## [NOTES](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#NOTES)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       After a call to **sched_setaffinity**(), the set of CPUs on which the
       thread will actually run is the intersection of the set specified
       in the _mask_ argument and the set of CPUs actually present on the
       system.  The system may further restrict the set of CPUs on which
       the thread runs if the "cpuset" mechanism described in [cpuset(7)](https://man7.org/linux/man-pages/man7/cpuset.7.html)
       is being used.  These restrictions on the actual set of CPUs on
       which the thread will run are silently imposed by the kernel.

       There are various ways of determining the number of CPUs
       available on the system, including: inspecting the contents of
       _/proc/cpuinfo_; using [sysconf(3)](https://man7.org/linux/man-pages/man3/sysconf.3.html) to obtain the values of the
       **_SC_NPROCESSORS_CONF** and **_SC_NPROCESSORS_ONLN** parameters; and
       inspecting the list of CPU directories under
       _/sys/devices/system/cpu/_.

       [sched(7)](https://man7.org/linux/man-pages/man7/sched.7.html) has a description of the Linux scheduling scheme.

       The affinity mask is a per-thread attribute that can be adjusted
       independently for each of the threads in a thread group.  The
       value returned from a call to [gettid(2)](https://man7.org/linux/man-pages/man2/gettid.2.html) can be passed in the
       argument _pid_.  Specifying _pid_ as 0 will set the attribute for the
       calling thread, and passing the value returned from a call to
       [getpid(2)](https://man7.org/linux/man-pages/man2/getpid.2.html) will set the attribute for the main thread of the
       thread group.  (If you are using the POSIX threads API, then use
       [pthread_setaffinity_np(3)](https://man7.org/linux/man-pages/man3/pthread_setaffinity_np.3.html) instead of **sched_setaffinity**().)

       The _isolcpus_ boot option can be used to isolate one or more CPUs
       at boot time, so that no processes are scheduled onto those CPUs.
       Following the use of this boot option, the only way to schedule
       processes onto the isolated CPUs is via **sched_setaffinity**() or
       the [cpuset(7)](https://man7.org/linux/man-pages/man7/cpuset.7.html) mechanism.  For further information, see the kernel
       source file _Documentation/admin-guide/kernel-parameters.txt_.  As
       noted in that file, _isolcpus_ is the preferred mechanism of
       isolating CPUs (versus the alternative of manually setting the
       CPU affinity of all processes on the system).

       A child created via [fork(2)](https://man7.org/linux/man-pages/man2/fork.2.html) inherits its parent's CPU affinity
       mask.  The affinity mask is preserved across an [execve(2)](https://man7.org/linux/man-pages/man2/execve.2.html).

   **C library/kernel differences**
       This manual page describes the glibc interface for the CPU
       affinity calls.  The actual system call interface is slightly
       different, with the _mask_ being typed as _unsigned long *_,
       reflecting the fact that the underlying implementation of CPU
       sets is a simple bit mask.

       On success, the raw **sched_getaffinity**() system call returns the
       number of bytes placed copied into the _mask_ buffer; this will be
       the minimum of _cpusetsize_ and the size (in bytes) of the
       _cpumask_t_ data type that is used internally by the kernel to
       represent the CPU set bit mask.

   **Handling systems with large CPU affinity masks**
       The underlying system calls (which represent CPU masks as bit
       masks of type _unsigned long *_) impose no restriction on the size
       of the CPU mask.  However, the _cpu_set_t_ data type used by glibc
       has a fixed size of 128 bytes, meaning that the maximum CPU
       number that can be represented is 1023.  If the kernel CPU
       affinity mask is larger than 1024, then calls of the form:

           sched_getaffinity(pid, sizeof(cpu_set_t), &mask);

       fail with the error **EINVAL**, the error produced by the underlying
       system call for the case where the _mask_ size specified in
       _cpusetsize_ is smaller than the size of the affinity mask used by
       the kernel.  (Depending on the system CPU topology, the kernel
       affinity mask can be substantially larger than the number of
       active CPUs in the system.)

       When working on systems with large kernel CPU affinity masks, one
       must dynamically allocate the _mask_ argument (see [CPU_ALLOC(3)](https://man7.org/linux/man-pages/man3/CPU_ALLOC.3.html)).
       Currently, the only way to do this is by probing for the size of
       the required mask using **sched_getaffinity**() calls with increasing
       mask sizes (until the call does not fail with the error **EINVAL**).

       Be aware that [CPU_ALLOC(3)](https://man7.org/linux/man-pages/man3/CPU_ALLOC.3.html) may allocate a slightly larger CPU set
       than requested (because CPU sets are implemented as bit masks
       allocated in units of _sizeof(long)_).  Consequently,
       **sched_getaffinity**() can set bits beyond the requested allocation
       size, because the kernel sees a few additional bits.  Therefore,
       the caller should iterate over the bits in the returned set,
       counting those which are set, and stop upon reaching the value
       returned by [CPU_COUNT(3)](https://man7.org/linux/man-pages/man3/CPU_COUNT.3.html) (rather than iterating over the number
       of bits requested to be allocated).

## [EXAMPLES](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#EXAMPLES)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)
       The program below creates a child process.  The parent and child
       then each assign themselves to a specified CPU and execute
       identical loops that consume some CPU time.  Before terminating,
       the parent waits for the child to complete.  The program takes
       three command-line arguments: the CPU number for the parent, the
       CPU number for the child, and the number of loop iterations that
       both processes should perform.

       As the sample runs below demonstrate, the amount of real and CPU
       time consumed when running the program will depend on intra-core
       caching effects and whether the processes are using the same CPU.

       We first employ [lscpu(1)](https://man7.org/linux/man-pages/man1/lscpu.1.html) to determine that this (x86) system has
       two cores, each with two CPUs:

           $ **lscpu | egrep -i 'core.*:|socket'**
           Thread(s) per core:    2
           Core(s) per socket:    2
           Socket(s):             1

       We then time the operation of the example program for three
       cases: both processes running on the same CPU; both processes
       running on different CPUs on the same core; and both processes
       running on different CPUs on different cores.

           $ **time -p ./a.out 0 0 100000000**
           real 14.75
           user 3.02
           sys 11.73
           $ **time -p ./a.out 0 1 100000000**
           real 11.52
           user 3.98
           sys 19.06
           $ **time -p ./a.out 0 3 100000000**
           real 7.89
           user 3.29
           sys 12.07

   **Program source**
Ejemplo [[afinidad.c]]
```c

#define _GNU_SOURCE
#include <err.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

/*
 *
 * El siguiente programa crea un proceso hijo.  El padre y 
 * el hijo se asignan cada uno a una CPU específica y ejecutan 
 * bucles idénticos que consumen algo de tiempo de CPU.  
 * Antes de terminar, el proceso padre espera a que el proceso 
 * hijo termine.  El programa toma tres argumentos de la 
 * línea de comandos: 
 *      el número de CPU para el proceso padre, 
 *      el número de CPU para el proceso hijo y 
 *      el número de iteraciones de bucle que ambos 
 *          procesos deben realizar. 
 * Como demuestran las siguientes ejecuciones de ejemplo, 
 * la cantidad de tiempo real y de CPU consumido al ejecutar 
 * el programa dependerá de los efectos de la caché 
 * intra-núcleo y de si los procesos están utilizando la misma CPU.
 */

int main(int argc, char *argv[])

{
    int parentCPU, childCPU;
    cpu_set_t set;
    unsigned int nloops;

    if (argc != 4)
    {
        fprintf(stderr, "Usage: %s parent-cpu child-cpu num-loops\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    parentCPU = atoi(argv[1]);
    childCPU = atoi(argv[2]);
    nloops = atoi(argv[3]);

    CPU_ZERO(&set);

    switch (fork())
    {
    case -1:
        /* Error */ err(EXIT_FAILURE, "fork");
    
    /*
     * El sistema de archivos cpuset es una interfaz pseudo-sistema
     * de archivos para el mecanismo cpuset del núcleo, que se utiliza 
     * para controlar la ubicación de los procesos en el procesador y 
     * en la memoria.  Normalmente se monta en /dev/cpuset.
     * 
     * En sistemas con kernels compilados con soporte integrado para 
     * cpusets, todos los procesos se adjuntan a un cpuset, y los 
     * cpusets están siempre presentes. 
     * 
     * Los cpusets se integran con el mecanismo de afinidad de 
     * programación sched_setaffinity(2) y con los mecanismos de 
     * asignación de memoria mbind(2) y set_mempolicy(2).
     * los mecanismos de colocación de memoria mbind(2) y 
     * set_mempolicy(2) en el kernel del núcleo.  Ninguno de estos 
     * mecanismos permite a un proceso utilizar una CPU o un nodo 
     * de memoria que no esté permitido por la cpuset.  
     * Si los cambios en la colocación de cpuset de un proceso entran 
     * en conflicto con estos otros mecanismos, entonces la colocación 
     * de la cpuset es forzada incluso si significa anular estos 
     * otros mecanismos.  El núcleo lleva a cabo este
     * restringiendo silenciosamente las CPUs y los nodos de 
     * memoria solicitados por estos otros mecanismos a los permitidos 
     * por la cpuset del proceso invocador. Esto puede resultar en que 
     * estas otras llamadas devuelvan un error, 
     * si por ejemplo, dicha llamada termina solicitando un conjunto 
     * vacío de CPUs o nodos de memoria, después de que la petición 
     * esté restringida al cpuset del proceso invocador.
     */
    case 0:
        /* Child */ CPU_SET(childCPU, &set);

        if (sched_setaffinity(getpid(), sizeof(set), &set) == -1)
            err(EXIT_FAILURE, "sched_setaffinity");

        for (unsigned int j = 0; j < nloops; j++)
            getppid();
            
        exit(EXIT_SUCCESS);
        
    default:
        /* Parent */ CPU_SET(parentCPU, &set);
        if (sched_setaffinity(getpid(), sizeof(set), &set) == -1)
            err(EXIT_FAILURE, "sched_setaffinity");

        for (unsigned int j = 0; j < nloops; j++)
            getppid();

        wait(NULL); /* Wait for child to terminate */
        exit(EXIT_SUCCESS);

    }
}
```

## [SEE ALSO](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#SEE_ALSO)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)

       [lscpu(1)](https://man7.org/linux/man-pages/man1/lscpu.1.html), [nproc(1)](https://man7.org/linux/man-pages/man1/nproc.1.html), [taskset(1)](https://man7.org/linux/man-pages/man1/taskset.1.html), [clone(2)](https://man7.org/linux/man-pages/man2/clone.2.html), [getcpu(2)](https://man7.org/linux/man-pages/man2/getcpu.2.html),
       [getpriority(2)](https://man7.org/linux/man-pages/man2/getpriority.2.html), [gettid(2)](https://man7.org/linux/man-pages/man2/gettid.2.html), [nice(2)](https://man7.org/linux/man-pages/man2/nice.2.html), [sched_get_priority_max(2)](https://man7.org/linux/man-pages/man2/sched_get_priority_max.2.html),
       [sched_get_priority_min(2)](https://man7.org/linux/man-pages/man2/sched_get_priority_min.2.html), [sched_getscheduler(2)](https://man7.org/linux/man-pages/man2/sched_getscheduler.2.html),
       [sched_setscheduler(2)](https://man7.org/linux/man-pages/man2/sched_setscheduler.2.html), [setpriority(2)](https://man7.org/linux/man-pages/man2/setpriority.2.html), [CPU_SET(3)](https://man7.org/linux/man-pages/man3/CPU_SET.3.html), [get_nprocs(3)](https://man7.org/linux/man-pages/man3/get_nprocs.3.html),
       [pthread_setaffinity_np(3)](https://man7.org/linux/man-pages/man3/pthread_setaffinity_np.3.html), [sched_getcpu(3)](https://man7.org/linux/man-pages/man3/sched_getcpu.3.html), [capabilities(7)](https://man7.org/linux/man-pages/man7/capabilities.7.html),
       [cpuset(7)](https://man7.org/linux/man-pages/man7/cpuset.7.html), [sched(7)](https://man7.org/linux/man-pages/man7/sched.7.html), [numactl(8)](https://man7.org/linux/man-pages/man8/numactl.8.html)

## [COLOPHON](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#COLOPHON)         [top](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html#top_of_page)

       This page is part of the _man-pages_ (Linux kernel and C library
       user-space interface documentation) project.  Information about
       the project can be found at 
       ⟨[https://www.kernel.org/doc/man-pages/](https://www.kernel.org/doc/man-pages/)⟩.  If you have a bug report
       for this manual page, see
       ⟨[https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING](https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUTING)⟩.
       This page was obtained from the tarball man-pages-6.9.1.tar.gz
       fetched from
       ⟨[https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/](https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/)⟩ on
       2024-06-26.  If you discover any rendering problems in this HTML
       version of the page, or you believe there is a better or more up-
       to-date source for the page, or you have corrections or
       improvements to the information in this COLOPHON (which is _not_
       part of the original manual page), send a mail to
       man-pages@man7.org

Linux man-pages 6.9.1          2024-06-15           _sched_setaffinity_(2)

---

Pages that refer to this page: [systemd-nspawn(1)](https://man7.org/linux/man-pages/man1/systemd-nspawn.1.html),  [taskset(1)](https://man7.org/linux/man-pages/man1/taskset.1.html),  [getcpu(2)](https://man7.org/linux/man-pages/man2/getcpu.2.html),  [gettid(2)](https://man7.org/linux/man-pages/man2/gettid.2.html),  [sched_get_priority_max(2)](https://man7.org/linux/man-pages/man2/sched_get_priority_max.2.html),  [sched_setattr(2)](https://man7.org/linux/man-pages/man2/sched_setattr.2.html),  [sched_setparam(2)](https://man7.org/linux/man-pages/man2/sched_setparam.2.html),  [sched_setscheduler(2)](https://man7.org/linux/man-pages/man2/sched_setscheduler.2.html),  [syscalls(2)](https://man7.org/linux/man-pages/man2/syscalls.2.html),  [CPU_SET(3)](https://man7.org/linux/man-pages/man3/CPU_SET.3.html),  [numa(3)](https://man7.org/linux/man-pages/man3/numa.3.html),  [pthread_attr_setaffinity_np(3)](https://man7.org/linux/man-pages/man3/pthread_attr_setaffinity_np.3.html),  [pthread_create(3)](https://man7.org/linux/man-pages/man3/pthread_create.3.html),  [pthread_setaffinity_np(3)](https://man7.org/linux/man-pages/man3/pthread_setaffinity_np.3.html),  [systemd.exec(5)](https://man7.org/linux/man-pages/man5/systemd.exec.5.html),  [capabilities(7)](https://man7.org/linux/man-pages/man7/capabilities.7.html),  [cpuset(7)](https://man7.org/linux/man-pages/man7/cpuset.7.html),  [credentials(7)](https://man7.org/linux/man-pages/man7/credentials.7.html),  [pthreads(7)](https://man7.org/linux/man-pages/man7/pthreads.7.html),  [sched(7)](https://man7.org/linux/man-pages/man7/sched.7.html),  [migratepages(8)](https://man7.org/linux/man-pages/man8/migratepages.8.html),  [numactl(8)](https://man7.org/linux/man-pages/man8/numactl.8.html)