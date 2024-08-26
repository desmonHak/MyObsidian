https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html

`error ("message")`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-error-function-attribute)
`warning ("message")`

Si se utiliza el atributo `error` o `warning` en una declaración de función y no se elimina una llamada a dicha función mediante la eliminación de código muerto u otras optimizaciones, se diagnostica un error o advertencia (respectivamente) que incluye mensaje. Esto es útil para la comprobación en tiempo de compilación, especialmente junto con `__builtin_constant_p` y funciones en línea donde la comprobación de los argumentos de la función en línea no es posible mediante trucos `extern char [(condition) ? 1 : -1];`.

Aunque es posible dejar la función sin definir y así invocar un fallo de enlace (definir la función con un mensaje en la sección `.gnu.warning*`), cuando se usan estos atributos el problema se diagnostica antes y con la localización exacta de la llamada incluso en presencia de funciones en línea o cuando no se emite información de depuración.