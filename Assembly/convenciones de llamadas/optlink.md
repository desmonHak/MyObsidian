[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

basado en [[__cdecl]] los argumentos se introducen de derecha a izquierda. Los tres primeros argumentos (más a la izquierda) se pasan en ``EAX``, ``EDX`` y ``ECX`` y hasta cuatro argumentos de coma flotante se pasan en ``ST0`` a ``ST3``, aunque se reserva espacio para ellos en la lista de argumentos de la pila. Los resultados se devuelven en ``EAX`` o ``ST0``. Los registros ``EBP``, ``EBX``, ``ESI`` y ``EDI`` se conservan.

``Optlink`` es utilizado por los compiladores ``IBM VisualAge``.