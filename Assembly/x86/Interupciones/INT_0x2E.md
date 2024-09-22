## System Call Instructions
Los subprocesos en modo de usuario pasan al modo de núcleo cuando realizan llamadas al sistema. Hay tres formas en las que un subproceso en modo de usuario puede realizar esta transición:

- [[INT]] ``2E``
	- Es el método tradicional.
	- Compatible con todas las ``CPUs`` ``x86``.
	- Usa la tabla de descriptores de interrupción ([[IDT]]).
	- Más lenta debido a la sobrecarga del manejo de interrupciones.
- [[SYSENTER]]
	- Introducida por Intel para optimizar las transiciones.
	- Usa el registro [[MSR]] ``SYSENTER_EIP_MSR`` (``0x175``).
	- Aproximadamente tres veces más rápida que [[INT]] ``2E``.
- [[SYSCALL]]
	- Introducida por AMD, similar a SYSENTER.
	- También optimizada para transiciones rápidas.

- **x86 (32-bit)**:
    - NTDLL.dll decide en tiempo de ejecución qué mecanismo usar.
    - Puede usar INT 2E o SYSENTER/SYSCALL dependiendo de la CPU.

- **x64 (64-bit)**: (No confirmado aun)
    - Siempre usa la instrucción SYSCALL.

"``int 2e``" es la forma tradicional de realizar transiciones de usuario a modo kernel y es compatible con todas las CPU x86 existentes en la actualidad. La llamada a "``int 2e``" da como resultado la invocación de la rutina de servicio de interrupción registrada en la tabla de descriptores de interrupción ([[IDT]]) para el vector 0x2e (es decir, ``nt``\![[KiSystemService]]). "``int 2e``" es una interrupción de software genérica y tiene toda la sobrecarga asociada con el manejo de interrupciones. La transición de usuario a modo kernel es una operación que se ejecuta con mucha frecuencia (en un sistema razonablemente ocupado, esto puede ocurrir unas ``5000``-``6000`` veces por segundo). Por lo tanto, es necesario que exista una forma optimizada o rápida de realizar estas transiciones. Para abordar este problema, tanto Intel como ``AMD`` agregaron instrucciones de ``CPU`` para acelerar las transiciones de usuario a modo ``kernel``. Intel agregó "[[SYSENTER]]" y ``AMD`` agregó "[[SYSCALL]]".

**En X86**
```c
0:000> uf ntdll!NtCreateFile
ntdll!ZwCreateFile:
7c90d0ae b825000000      mov     eax,25h
7c90d0b3 ba0003fe7f      mov     edx,offset SharedUserData!SystemCallStub (7ffe0300)
7c90d0b8 ff12            call    dword ptr [edx]
7c90d0ba c22c00          ret     2Ch

0:000> uf poi(7ffe0300)
ntdll!KiIntSystemCall:
7c90e520 8d542408        lea     edx,[esp+8]
7c90e524 cd2e            int     2Eh
7c90e526 c3              ret
```
### SYSENTER/SYSCALL
La instrucción [[SYSENTER]]/[[SYSCALL]] es compatible con Pentium y versiones posteriores de la CPU y se denomina "Transición rápida al punto de entrada de llamada del sistema". El bit 11 (SEP) del registro EDX del resultado de una instrucción CPUID indica si el procesador admite instrucciones [[SYSENTER]]/[[SYSCALL]].

La instrucción utiliza una ruta especial para invocar el controlador de servicio del sistema en modo kernel([[ring-0]]), es decir, nt\![[KiFastCallEntry]]. El kernel registra esta función con la ``CPU`` almacenando un puntero a esta función en el registro específico del modelo de ``CPU`` ([[MSR]]) ``SYSENTER_EIP_MSR`` (``0x175``) durante el inicio del sistema. El cambio al modo kernel mediante [[SYSENTER]]/[[SYSCALL]] es tres veces más rápido que mediante el método "``int 2e``" heredado.

Dado que un binario ``NTDLL.dll`` particular puede ejecutarse en todos los tipos de CPU ``X86``, ``NTDLL`` debe admitir todos los mecanismos para realizar transiciones del usuario al modo kernel. La decisión sobre qué mecanismo utilizar se toma en tiempo de ejecución según el tipo de ``CPU`` del sistema. Sin embargo, en sistemas ``x64``, ``NTDLL`` siempre utiliza la instrucción [[SYSCALL]].

**En X64**
```c
0:000> uf ntdll!NtCreateFile
ntdll!ZwCreateFile:
00000000`76eb02a0 4c8bd1          mov     r10,rcx
00000000`76eb02a3 b852000000      mov     eax,52h
00000000`76eb02a8 0f05            syscall
00000000`76eb02aa c3              ret
```

**En X86**
```c
0:000> uf ntdll!NtCreateFile
ntdll!ZwCreateFile:
7c90d0ae b825000000      mov     eax,25h
7c90d0b3 ba0003fe7f      mov     edx,offset SharedUserData!SystemCallStub (7ffe0300)
7c90d0b8 ff12            call    dword ptr [edx]
7c90d0ba c22c00          ret     2Ch

0:000> uf poi(7ffe0300)
ntdll!KiFastSystemCall:
7c90e510 8bd4            mov     edx,esp
7c90e512 0f34            sysenter
7c90e514 c3              ret
```