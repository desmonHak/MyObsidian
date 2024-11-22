`format (archetype, string-index, first-to-check)`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-format-function-attribute)

El atributo `format` especifica que una función toma argumentos del estilo `printf`, `scanf`, `strftime` o `strfmon` que deben ser comprobados contra una cadena de formato. Por ejemplo, la declaración

```c
extern int
my_printf (void *my_object, const char *my_format, ...)
      __attribute__ ((format(printf, 2, 3)));
```

hace que el compilador compruebe si los argumentos de las llamadas a `my_printf` son consistentes con el argumento de cadena de formato estilo `printf` `my_format`.

El parámetro arquetipo determina cómo se interpreta la cadena de formato, y debe ser `printf`, `scanf`, `strftime`, `gnu_printf`, `gnu_scanf`, `gnu_strftime` o `strfmon`. (También puedes utilizar `__printf__`, `__scanf__`, `__strftime__` o `__strfmon__`). En objetivos ``MinGW``, `ms_printf`, `ms_scanf`, y `ms_strftime` también están presentes. Los valores de arquetipo como `printf` se refieren a los formatos aceptados por la biblioteca de tiempo de ejecución C del sistema, mientras que los valores prefijados con `gnu_` siempre se refieren a los formatos aceptados por la Biblioteca C de GNU. En Microsoft Windows, los valores prefijados con 'ms_' se refieren a los formatos aceptados por la biblioteca ``msvcrt.dll``. El parámetro ``string-index`` especifica qué argumento es el argumento de la cadena de formato (empezando por 1), mientras que ``first-to-check`` es el número del primer argumento a comprobar con la cadena de formato. Para funciones donde los argumentos no están disponibles para ser comprobados (como `vprintf`), especifique el tercer parámetro como cero. En este caso, el compilador sólo comprueba la coherencia de la cadena de formato. Para los formatos `strftime`, se requiere que el tercer parámetro sea cero. Dado que los métodos C++ no estáticos tienen un argumento implícito `this`, los argumentos de dichos métodos deben contarse a partir de dos, no de uno, cuando se dan valores para ``string-index`` y ``first-to-check``.

En el ejemplo anterior, la cadena de formato (`my_format`) es el segundo argumento de la función `my_print`, y los argumentos a comprobar empiezan por el tercer argumento, por lo que los parámetros correctos para el atributo ``format`` son 2 y 3.

El atributo `format` le permite identificar sus propias funciones que toman cadenas de formato como argumentos, de forma que ``GCC`` pueda comprobar las llamadas a estas funciones en busca de errores. El compilador siempre (a menos que se utilice ``-ffreestanding`` o ``-fno-builtin``) comprueba los formatos para las funciones de la biblioteca estándar `printf`, `fprintf`, `sprintf`, `scanf`, `fscanf`, `sscanf`, `strftime`, `vprintf`, `vfprintf` y `vsprintf` siempre que se soliciten dichas advertencias (utilizando ``-Wformat``), por lo que no es necesario modificar el fichero de cabecera ``stdio.h``. En modo ``C99``, también se comprueban las funciones `snprintf`, `vsnprintf`, `vscanf`, `vfscanf` y `vsscanf`. Excepto en los modos C estándar estrictamente conformes, la función X/Open `strfmon` también se comprueba, así como `printf_unlocked` y `fprintf_unlocked`. Véase [Options Controlling C Dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html).

Para los dialectos de Objective-C, se reconoce `NSString` (o `__NSString__`) en el mismo contexto. Las declaraciones que incluyen estos atributos de formato se analizan para comprobar que la sintaxis es correcta; sin embargo, el resultado de la comprobación de dichas cadenas de formato aún no está definido, y esta versión del compilador no lo lleva a cabo.

El objetivo también puede proporcionar tipos adicionales de comprobaciones de formato. Véase [Format Checks Specific to Particular Target Machines](https://gcc.gnu.org/onlinedocs/gcc/Target-Format-Checks.html).