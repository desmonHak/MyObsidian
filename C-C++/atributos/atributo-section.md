`section ("section-name")`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-section-function-attribute)

Normalmente, el compilador coloca el código que genera en la sección `text`. Sin embargo, a veces necesitas secciones adicionales o necesitas que ciertas funciones particulares aparezcan en secciones especiales. El atributo `section` especifica que una función se encuentra en una sección en particular. Por ejemplo, la declaración:

```c
extern void foobar (void) __attribute__ ((section ("bar")));
```

coloca la función `foobar` en la sección `bar`.

Algunos formatos de archivo no admiten secciones arbitrarias, por lo que el atributo `section` no está disponible en todas las plataformas. Si necesita asignar todo el contenido de un módulo a una sección en particular, considere usar las funciones del enlazador.