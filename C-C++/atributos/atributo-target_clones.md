`target_clones (options)`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-target_005fclones-function-attribute)

El atributo `target_clones` se utiliza para especificar que una función se clone en varias versiones compiladas con opciones de destino diferentes a las especificadas en la línea de comandos. Las opciones admitidas y las restricciones son las mismas que para el [[atributo-target]].

Por ejemplo, en un ``x86``, puede compilar una función con `target_clones("sse4.1,avx")`. ``GCC`` crea dos clones de función, uno compilado con ``-msse4.1`` y otro con ``-mavx``.

En un ``PowerPC``, puede compilar una función con `target_clones("cpu=power9,default")`. ``GCC`` creará dos clones de función, uno compilado con ``-mcpu=power9`` y otro con las opciones predeterminadas. ``GCC`` debe estar configurado para usar ``GLIBC 2.23`` o más reciente para poder usar el atributo `target_clones`.

También crea una función de resolución (consulte el atributo `ifunc` más arriba) que selecciona dinámicamente un clon adecuado para la arquitectura actual. El resolver se crea solo si hay un uso de una función con el atributo `target_clones`.

Tenga en cuenta que cualquier llamada posterior de una función sin `target_clone` desde un llamador `target_clone` no provocará la copia (clon de destino) de la función llamada. Si desea aplicar dicho comportamiento, recomendamos declarar la función que llama con el [[atributo-flatten]].