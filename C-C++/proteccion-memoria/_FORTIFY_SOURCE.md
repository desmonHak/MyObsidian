https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html

https://developers.redhat.com/blog/2021/04/16/broadening-compiler-checks-for-buffer-overflows-in-_fortify_source#in_the_very_long_term__everything_is_dynamic
## Comprobación del tamaño de los objetos y fortificación de la fuente
El endurecimiento de las llamadas a funciones mediante la macro ``_FORTIFY_SOURCE`` es uno de los usos clave de las funciones incorporadas de comprobación del tamaño de los objetos. Para hacer más cómoda la implementación de estas características y mejorar la optimización y el diagnóstico, se han añadido funciones incorporadas para muchas funciones comunes de operación de cadenas, por ejemplo, para ``memcpy`` se proporciona la función incorporada ``__builtin___memcpy_chk``. Este ``built-in`` tiene un último argumento adicional, que es el número de bytes restantes en el objeto al que apunta el argumento ``dest`` o ``(size_t) -1`` si no se conoce el tamaño.

Las funciones incorporadas se optimizan en las funciones normales de cadena como ``memcpy`` si el último argumento es ``(size_t) -1`` o si se sabe en tiempo de compilación que el objeto de destino no se desbordará. Si el compilador puede determinar en tiempo de compilación que el objeto siempre se desbordará, emite una advertencia.
```c
#undef memcpy
#define bos0(dest) __builtin_object_size (dest, 0)
#define memcpy(dest, src, n) \
  __builtin___memcpy_chk (dest, src, n, bos0 (dest))

char *volatile p;
char buf[10];
/* It is unknown what object p points to, so this is optimized
   into plain memcpy - no checking is possible.  */
memcpy (p, "abcde", n);
/* Destination is known and length too.  It is known at compile
   time there will be no overflow.  */
memcpy (&buf[5], "abcde", 5);
/* Destination is known, but the length is not known at compile time.
   This will result in __memcpy_chk call that can check for overflow
   at run time.  */
memcpy (&buf[5], "abcde", n);
/* Destination is known and it is known at compile time there will
   be overflow.  There will be a warning and __memcpy_chk call that
   will abort the program at run time.  */
memcpy (&buf[6], "abcde", 5);
```
Tales funciones incorporadas se proporcionan para ``memcpy``, ``mempcpy``, ``memmove``, ``memset``, ``strcpy``, ``stpcpy``, ``strncpy``, ``strcat`` y ``strncattrncat``.

#### 6.62.2.1 Función de salida con formato Comprobación[](https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html#Formatted-Output-Function-Checking)

Función incorporada: `int` **``__builtin___sprintf_chk``** `(char *s, int flag, size_t os, const char *fmt, ...)`[](https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html#index-_005f_005fbuiltin_005f_005f_005fsprintf_005fchk)

Función incorporada: `int` **``__builtin___snprintf_chk``** `(char *s, size_t maxlen, int flag, size_t os, const char *fmt, ...)`[](https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html#index-_005f_005fbuiltin_005f_005f_005fsnprintf_005fchk)

Función incorporada: `int` **``__builtin___vsprintf_chk``** `(char *s, int flag, size_t os, const char *fmt, va_list ap)`[](https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html#index-_005f_005fbuiltin_005f_005f_005fvsprintf_005fchk)

Función incorporada: `int` **``__builtin___vsnprintf_chk``** `(char *s, size_t maxlen, int flag, size_t os, const char *fmt, va_list ap)`[](https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html#index-_005f_005fbuiltin_005f_005f_005fvsnprintf_005fchk)

El argumento flag añadido se pasa sin cambios a las funciones `__sprintf_chk` etc. y puede contener flags específicos de la implementación sobre qué medidas de seguridad adicionales podría tomar la función de comprobación, como manejar `%n` de forma diferente.

El argumento os es el tamaño del objeto al que apunta s, como en las otras funciones incorporadas. Hay una pequeña diferencia en el comportamiento, sin embargo, si os es `(size_t) -1`, las funciones integradas se optimizan en las funciones de no comprobación sólo si flag es 0, de lo contrario la función de comprobación se llama con el argumento os establecido a `(size_t) -1`.

Además, existen las funciones integradas de comprobación `__builtin___printf_chk`, `__builtin___vprintf_chk`, `__builtin___fprintf_chk` y `__builtin___vfprintf_chk`. Estos tienen un único argumento adicional, flag, justo antes de la cadena de formato fmt. Si el compilador es capaz de optimizarlas a funciones `fputc` etc., lo hace, de lo contrario se llama a la función de comprobación y se le pasa el argumento flag.

| Function | Built-in function           | Prototype                                                                              |
| -------- | --------------------------- | -------------------------------------------------------------------------------------- |
| memcpy   | ``__builtin___memcpy_chk``  | ``void * __builtin___memcpy_chk (void *dest, const void *src, size_t n, size_t os);``  |
| mempcpy  | ``__builtin___mempcpy_chk`` | ``void * __builtin___mempcpy_chk (void *dest, const void *src, size_t n, size_t os);`` |
| memmove  | ``__builtin___memmove_chk`` | ``void * __builtin___memmove_chk (void *dest, const void *src, size_t n, size_t os);`` |
| memset   | ``__builtin___memset_chk``  | ``void * __builtin___memset_chk (void *s, int c, size_t n, size_t os);``               |
| strcpy   | ``__builtin___strcpy_chk``  | ``char * __builtin___strcpy_chk (char *dest, const char *src, size_t os);``            |
| strncpy  | ``__builtin___strncpy_chk`` | ``char * __builtin___strncpy_chk (char *dest, const char *src, size_t n, size_t os);`` |
| stpcpy   | ``__builtin___stpcpy_chk``  | ``char * __builtin___stpcpy_chk (char *dest, const char *src, size_t os);``            |
| strcat   | ``__builtin___strcat_chk``  | ``char * __builtin___strcat_chk (char *dest, const char *src, size_t os);``            |
| strncat  | ``__builtin___strncat_chk`` | ``char * __builtin___strncat_chk (char *dest, const char *src, size_t n, size_t os);`` |

| Function  | Built-in function             | Prototype                                                                                                     |
| --------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------- |
| sprintf   | ``__builtin___sprintf_chk``   | ``int __builtin___sprintf_chk (char *s, int flag, size_t os, const char *fmt, ...);``                         |
| snprintf  | ``__builtin___snprintf_chk``  | ``int __builtin___snprintf_chk (char *s, size_t maxlen, int flag, size_t os);``                               |
| vsprintf  | ``__builtin___vsprintf_chk``  | ``int __builtin___vsprintf_chk (char *s, int flag, size_t os, const char *fmt,va_list ap);``                  |
| vsnprintf | ``__builtin___vsnprintf_chk`` | ``int __builtin___vsnprintf_chk (char *s, size_t maxlen, int flag, size_t os, const char *fmt, va_list ap);`` |
| printf    | ``__builtin___printf_chk``    | ``int __builtin___printf (int flag, const char *format, ...);``                                               |
| vprintf   | ``__builtin___vprintf_chk``   | ``int __builtin___vprintf (int flag, const char *format, va_list ap);``                                       |
| fprintf   | ``__builtin___fprintf_chk``   | ``int __builtin___fprintf (FILE *stream, int flag, const char *format, ...);``                                |
| vfprintf  | ``__builtin___vfprintf_chk``  | ``int __builtin___vfprintf (FILE *stream, int flag, const char *format, va_list ap);``                        |