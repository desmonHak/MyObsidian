[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

Es similar a [[__cdecl]] en que los argumentos se desplazan de derecha a izquierda. ``EAX``, ``ECX`` y ``EDX`` no se conservan. El tamaño de la lista de parámetros en palabras dobles se pasa en ``AL``.

``Syscall`` es la convención de llamada estándar para la API ``OS/2`` de ``32 bits``.
