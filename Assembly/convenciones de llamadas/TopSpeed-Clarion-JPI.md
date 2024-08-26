[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

Los cuatro primeros parámetros enteros se pasan en los registros eax, ebx, ecx y edx. Los parámetros de coma flotante se pasan a la pila de coma flotante: registros st0, st1, st2, st3, st4, st5 y st6. Los parámetros de estructura se pasan siempre a la pila. Los parámetros añadidos se pasan a la pila una vez agotados los registros. Los valores enteros se devuelven en eax, los punteros en edx y los tipos de coma flotante en st0.