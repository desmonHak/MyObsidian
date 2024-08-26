`deprecated`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-deprecated-function-attribute)
`deprecated (msg)`

El atributo `deprecated` provoca una advertencia si la función se utiliza en cualquier parte del fichero fuente. Esto resulta útil para identificar funciones que se espera que sean eliminadas en una versión futura de un programa. La advertencia también incluye la ubicación de la declaración de la función obsoleta, para permitir a los usuarios encontrar fácilmente más información sobre por qué la función está obsoleta, o lo que deberían hacer en su lugar. Tenga en cuenta que las advertencias sólo se producen para los usos

```c
int old_fn () __attribute__ ((deprecated));
int old_fn ();
int (*fn_ptr)() = old_fn;
```

produce una advertencia en la línea 3 pero no en la línea 2. El argumento opcional msg, que debe ser una cadena, se imprime en la advertencia si está presente.

El atributo `deprecated` también puede utilizarse para variables y tipos (véase [Especificación de atributos de variables](https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html), véase [Especificación de atributos de tipos](https://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html).)

El mensaje adjunto al atributo se ve afectado por la configuración de la opción ``-fmessage-length``.