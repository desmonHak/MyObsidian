https://gcc.gnu.org/onlinedocs/gcc/Alternate-Keywords.html

``-ansi`` y las diversas opciones ``-std`` deshabilitan ciertas palabras clave. Esto causa problemas cuando se quieren usar extensiones ``GNU C``, o un fichero de cabecera de propósito general que debería ser usado por todos los programas, incluyendo los programas ``ISO C``. Las palabras clave asm, ``typeof`` e inline no están disponibles en programas compilados con ``-ansi`` o ``-std`` (aunque inline puede usarse en un programa compilado con ``-std=c99`` o un estándar posterior). La palabra clave ``restrict`` de ``ISO C99`` sólo está disponible cuando se utiliza ``-std=gnu99`` (que con el tiempo será el valor predeterminado) o ``-std=c99`` (o el equivalente ``-std=iso9899:1999``), o una opción para una versión posterior de la norma.

La forma de resolver estos problemas es poner '``__``' al principio y al final de cada palabra clave problemática. Por ejemplo, utilice ``__asm__`` en lugar de ``asm``, y ``__inline__`` en lugar de ``inline``.

Otros compiladores de C no aceptarán estas palabras clave alternativas; si desea compilar con otro compilador, puede definir las palabras clave alternativas como macros para sustituirlas por las palabras clave habituales. Se parece a esto:
```c
#ifndef __GNUC__
#define __asm__ asm
#endif
```

``-pedantic`` y otras opciones generan advertencias para muchas extensiones de C de GNU. Puede suprimir dichas advertencias utilizando la palabra clave ``__extension__``. Específicamente:
- Escribir ``__extension__`` antes de una expresión evita advertencias sobre extensiones dentro de esa expresión.
- En C, escribir: 
```c
[[__extension__ …]]
```

suprime las advertencias sobre el uso de atributos ‘``[[]]``’ en versiones de C anteriores a ``C23``.