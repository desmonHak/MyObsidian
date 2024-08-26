`nonnull`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-nonnull-function-attribute)
`nonnull (arg-index, …)`

El atributo `nonnull` se puede aplicar a una función que toma al menos un argumento de un tipo puntero. Indica que los argumentos a los que se hace referencia deben ser punteros no nulos. Por ejemplo, la declaración:

```c
extern void *
my_memcpy (void *dest, const void *src, size_t len)
        __attribute__((nonnull (1, 2)));
```

informa al compilador que, en las llamadas a `my_memcpy`, los argumentos `dest` y `src` deben ser distintos de nulos.

El atributo tiene efecto tanto en las llamadas a funciones como en las definiciones de funciones.

Para llamadas a funciones:

- Si el compilador determina que se pasa un puntero nulo en una ranura de argumento marcada como no nula, y la opción ``-Wnonnull`` está habilitada, se emite una advertencia. Consulte [Opciones para solicitar o suprimir advertencias](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html).

- La opción ``-fisolate-erroneous-paths-attribute`` se puede especificar para que GCC transforme las llamadas con argumentos nulos a funciones no nulas en trampas. Consulte [Opciones que controlan la optimización](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html).

- El compilador también puede realizar optimizaciones basándose en el conocimiento de que ciertos argumentos de función no pueden ser nulos. Estas optimizaciones se pueden desactivar con la opción ``-fno-delete-null-pointer-checks``. Consulte [Opciones que controlan la optimización](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html).

Para definiciones de funciones:
- Si el compilador determina que un parámetro de función que está marcado como ``nonnull`` se compara con ``null``, y la opción ``-Wnonnull-compare`` está habilitada, se emite una advertencia. Consulte [Opciones para solicitar o suprimir advertencias](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html).

- El compilador también puede realizar optimizaciones basándose en el conocimiento de que los parámetros "``nonnull``" no pueden ser nulos. Esto actualmente no se puede desactivar excepto eliminando el atributo ``nonnull``.

Si no se proporciona ningún índice de argumentos al atributo `nonnull`, todos los argumentos de puntero se marcan como no nulos. Para ilustrarlo, la siguiente declaración es equivalente al ejemplo anterior:

```c
extern void *
my_memcpy (void *dest, const void *src, size_t len)
        __attribute__((nonnull));
```