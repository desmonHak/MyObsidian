[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

[Watcom](https://en.wikipedia.org/wiki/Watcom) no soporta la palabra clave [[__fastcall]] excepto para alias a ``null``. La convención de llamada al registro puede ser seleccionada por un interruptor en la línea de comandos. (Sin embargo, IDA utiliza [[__fastcall]] de todas formas por uniformidad).

Se asignan hasta 4 registros a los argumentos en el orden ``EAX``, ``EDX``, ``EBX``, ``ECX``. Los argumentos se asignan a los registros de izquierda a derecha. Si algún argumento no puede asignarse a un registro (por ejemplo, porque es demasiado grande), éste y todos los argumentos siguientes se asignan a la pila. Los argumentos asignados a la pila se empujan de derecha a izquierda. Los nombres se modifican añadiendo un guión bajo como sufijo.

Las funciones ``variádicas`` vuelven a la convención de llamada basada en la pila de ``Watcom``.

El compilador C/C++ de ``Watcom`` también utiliza la directiva ``#pragma`` ``aux``[20] que permite al usuario especificar su propia convención de llamada. Como se indica en el manual, "es probable que muy pocos usuarios necesiten este método, pero si es necesario, puede ser un salvavidas".
