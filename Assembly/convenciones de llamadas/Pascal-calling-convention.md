[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

Basado en la convención de llamadas del lenguaje  [Borland](https://en.wikipedia.org/wiki/Borland "Borland") [Turbo Pascal](https://en.wikipedia.org/wiki/Turbo_Pascal "Turbo Pascal"), los parámetros se introducen en la pila en orden de izquierda a derecha (``LTR``) (opuesto a [[__cdecl]]), y el llamante es responsable de eliminarlos de la pila.

El resultado se devuelve de la siguiente manera:
Los valores ordinales se devuelven en ``AL`` (valores de ``8 bits``), ``AX`` (valores de ``16 bits``), ``EAX`` (valores de ``32 bits``) o ``DX:AX`` (valores de ``32 bits`` en sistemas de ``16 bits``).
Los valores reales se devuelven en ``DX:BX:AX``.
Los valores de coma flotante (``8087``) se devuelven en ``ST0``.
Los punteros se devuelven en ``EAX`` en sistemas de ``32 bits`` y en ``AX`` en sistemas de ``16 bits``.
Las cadenas se devuelven en una ubicación temporal apuntada por el símbolo @Result.
Esta convención de llamada era común en las siguientes APIs de 16 bits: [OS/2](https://en.wikipedia.org/wiki/OS/2 "OS/2") 1.x, [Microsoft](https://en.wikipedia.org/wiki/Microsoft_Windows "Microsoft Windows"), y  [Borland](https://en.wikipedia.org/wiki/Borland "Borland") [Delphi](https://en.wikipedia.org/wiki/Delphi_(software) "Delphi (software)") version 1.x. Las versiones modernas de la [[WinApi]] utilizan [[__stdcall]], que todavía tiene el ``callee`` restaurando la pila como en la convención de Pascal, pero los parámetros ahora se empujan de derecha a izquierda.