El atributo `format_arg` especifica que una función toma una o más cadenas de formato para una función de estilo `printf`, `scanf`, `strftime` o `strfmon` y la modifica (por ejemplo, para traducirla a otro idioma), de modo que el resultado puede pasarse a una función de estilo `printf`, `scanf`, `strftime` o `strfmon` (con el resto de argumentos de la función de formato iguales a los que habrían sido para la cadena no modificada). Se pueden aplicar múltiples atributos `format_arg` a la misma función, cada uno designando un parámetro distinto como cadena de formato. Por ejemplo, la declaración
```c
extern char *
my_dgettext (char *my_domain, const char *my_format)
      __attribute__ ((format_arg (2)));
```

hace que el compilador compruebe los argumentos en las llamadas a una función de tipo `printf`, `scanf`, `strftime` o `strfmon`, cuyo argumento de cadena de formato es una llamada a la función `my_dgettext`, para ver si son consistentes con el argumento de cadena de formato `my_format`. Si no se hubiera especificado el atributo `format_arg`, todo lo que el compilador podría decir en tales llamadas a funciones de formato sería que el argumento de cadena de formato no es constante; esto generaría una advertencia cuando se utiliza ``-Wformat-nonliteral``, pero las llamadas no podrían comprobarse sin el atributo.

En las llamadas a una función declarada con más de un atributo `format_arg`, cada uno con un valor de argumento distinto, los argumentos reales correspondientes de la función se comprueban con todas las cadenas de formato designadas por los atributos. Esta capacidad está diseñada para soportar la familia de funciones GNU `ngettext`.

El parámetro ``string-index`` especifica qué argumento es la cadena de formato (empezando por uno). Dado que los métodos C++ no estáticos tienen un argumento implícito `this`, los argumentos de dichos métodos deben contarse a partir de dos.

El atributo `format_arg` le permite identificar sus propias funciones que modifican cadenas de formato, de forma que ``GCC`` pueda comprobar las llamadas a funciones de tipo `printf`, `scanf`, `strftime` o `strfmon` cuyos operandos sean una llamada a una de sus propias funciones. El compilador siempre trata `gettext`, `dgettext`, y `dcgettext` de esta manera excepto cuando se solicita soporte ``ISO C`` estricto mediante ``-ansi`` o una opción ``-std`` apropiada, o se utiliza ``-ffreestanding`` o ``-fno-builtin``. Véase [Options Controlling C Dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html).

Para dialectos ``Objective-C``, el atributo `format-arg` puede referirse a una referencia `NSString` por compatibilidad con el atributo `format` anterior.

El objetivo también puede permitir tipos adicionales en los atributos `format-arg`. Véase [Format Checks Specific to Particular Target Machines](https://gcc.gnu.org/onlinedocs/gcc/Target-Format-Checks.html).