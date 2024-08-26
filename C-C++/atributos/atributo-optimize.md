`optimize (level, …)`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-optimize-function-attribute)
`optimize (string, …)`

El atributo `optimize` se utiliza para especificar que una función se compilará con opciones de optimización diferentes a las especificadas en la línea de comandos. Los argumentos del atributo optimized de una función se comportan como si se adjuntaran a la línea de comandos.

Los argumentos válidos son cadenas y números enteros no negativos constantes. Cada argumento numérico especifica un nivel de optimización. Cada argumento de cadena consta de una o más subcadenas separadas por comas. Cada subcadena que comienza con la letra `O` hace referencia a una opción de optimización como ``-O0`` u ``-Os``. Otras subcadenas se toman como sufijos del prefijo `-f` y forman conjuntamente el nombre de una opción de optimización. Consulte [Opciones que controlan la optimización](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html).

‘``#pragma GCC optimized``’ se puede utilizar para establecer opciones de optimización para más de una función. Consulte [Pragmas de opciones específicas de función](https://gcc.gnu.org/onlinedocs/gcc/Function-Specific-Option-Pragmas.html) para obtener detalles sobre el pragma.

Proporcionar múltiples cadenas como argumentos separados por comas para especificar múltiples opciones es equivalente a separar los sufijos de opción con una coma (‘,’) dentro de una sola cadena. No se permiten espacios dentro de las cadenas.

No todas las opciones de optimización que comienzan con el prefijo ``-f`` especificado por el atributo necesariamente tienen un efecto en la función. El atributo `optimize` debe usarse solo con fines de depuración. No es adecuado en código de producción.