[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/thiscall?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/thiscall?view=msvc-170)

La convención de llamada **específica de Microsoft** **`__thiscall`** se usa en las funciones de los miembros de la clase de C++ en la arquitectura x86. Es la convención de llamada predeterminada que emplean las funciones miembro que no usan argumentos de variable (funciones `vararg`).

En **`__thiscall`**, el destinatario limpia la pila, lo que es imposible para las funciones `vararg`. Los parámetros se insertan en la pila de derecha a izquierda. El puntero **`this`** se pasa a través del registro ECX y no en la pila.

En equipos ARM, ARM64 y x64, el compilador acepta y omite a **`__thiscall`**. Esto se debe a que usan una convención de llamada basada en registros predeterminados.

Un motivo para usar **`__thiscall`** son las clases cuyas funciones miembro usan **`__clrcall`** de forma predeterminada. En ese caso, puede usar **`__thiscall`** para crear funciones miembro individuales que se puedan llamar desde código nativo.

Al compilar con [`/clr:pure`](https://learn.microsoft.com/es-es/cpp/build/reference/clr-common-language-runtime-compilation?view=msvc-170), todas las funciones y los punteros a función son **`__clrcall`** a menos que se especifique lo contrario. Las opciones del compilador **`/clr:pure`** y **`/clr:safe`** han quedado en desuso en Visual Studio 2015 y no se admiten en Visual Studio 2017.

Las funciones miembro `vararg` usan la convención de llamada [[__cdecl]]. Todos los argumentos de función se insertan en la pila, colocándose el puntero **`this`** en el último lugar de la pila.

Como esta convención de llamada solo se aplica a C++, no tiene ningún esquema de decoración de nombres de C.

Al definir una función miembro de clase no estática fuera de línea, especifique el modificador de convención de llamada solo en la declaración. No es necesario volver a especificarlo en la definición fuera de línea. El compilador usa la convención de llamada especificada durante la declaración en el punto de definición.

Esta convención de llamada se utiliza para llamar a funciones miembro no estáticas de C++. Existen dos versiones principales de ``thiscall``, dependiendo del compilador y de si la función utiliza o no un número variable de argumentos.

Para el compilador ``GCC``, ``thiscall`` es casi idéntica a [[__cdecl]]: El invocador limpia la pila, y los parámetros se pasan en orden de derecha a izquierda. La diferencia es la adición del puntero this, que se introduce en la pila en último lugar, como si fuera el primer parámetro del prototipo de la función.

En el compilador ``Microsoft Visual C++``, el puntero ``this`` se pasa en ``ECX`` y es el llamante el que limpia la pila, reflejando la convención [[__stdcall]] utilizada en C para este compilador y en las funciones de la [[WinApi]]. Cuando las funciones utilizan un número variable de argumentos, es el llamante el que limpia la pila (cf. [[__cdecl]]).

La convención de llamada ``thiscall`` sólo puede especificarse explícitamente en ``Microsoft Visual C++ 2005`` y posteriores. En cualquier otro compilador ``thiscall`` no es una palabra clave. (Sin embargo, los desensambladores, como ``IDA``, deben especificarla. Así que ``IDA`` usa la palabra clave ``__thiscall`` para esto).