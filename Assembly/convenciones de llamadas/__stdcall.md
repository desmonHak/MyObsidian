[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/stdcall?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/stdcall?view=msvc-170)

La convención de llamada **`__stdcall`** se usa para llamar a funciones de la API de Win32. El destinatario limpia la pila, por lo que el compilador hace funciones `vararg`[[__cdecl]]. Las funciones que usan esta convención de llamada requieren un prototipo de función. El modificador **`__stdcall`** es específico de Microsoft.

## Sintaxis
> _return-type_ **`__stdcall`** _function-name_ \[**`(` _argument-list_`)`**\]
## Comentarios
En la lista siguiente se muestra la implementación de esta convención de llamada.

|Elemento|Implementación|
|---|---|
|Orden de paso de argumento|De derecha a izquierda.|
|Convención para pasar argumentos|Por valor, a menos que se pase un puntero o un tipo de referencia.|
|Responsabilidad de mantenimiento de pila|La función a la que se llama saca sus propios argumentos de la pila.|
|Convención de creación de nombres representativos|Un subrayado (`_`) precede al nombre. El nombre va seguido del signo (`@`) seguido del número de bytes (en decimal) en la lista de argumentos. Por consiguiente, la función declarada como `int func( int a, double b )` se representa de la manera siguiente: `_func@12`|
|Convención de traducción de mayúsculas y minúsculas|None|
La convención de llamada ``stdcall``[5] es una variación de la convención [[Pascal-calling-convention]] en la que el llamante es responsable de limpiar la pila, pero los parámetros se introducen en la pila en orden de derecha a izquierda, como en la convención de llamada [[__cdecl]]. Los registros ``EAX``, ``ECX`` y ``EDX`` se designan para su uso dentro de la función. Los valores de retorno se almacenan en el registro ``EAX``.

``stdcall`` es la convención de llamada estándar para la [[WinApi]] de Microsoft y para [Open Watcom C++](https://en.wikipedia.org/wiki/Watcom_C/C%2B%2B).