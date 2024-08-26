GCC implementa un mecanismo de protección contra desbordamiento de búfer limitado que puede prevenir algunos ataques de desbordamiento de búfer al determinar los tamaños de los objetos en los que se van a escribir los datos y evitar las escrituras cuando el tamaño no es suficiente. Las funciones integradas que se describen a continuación producen los mejores resultados cuando se utilizan juntas y cuando la optimización está habilitada. Por ejemplo, para detectar tamaños de objetos a través de los límites de funciones o para seguir asignaciones de punteros a través de un flujo de control no trivial, se basan en varios pasos de optimización habilitados con ``-O2``. Sin embargo, en una medida limitada, también se pueden utilizar sin optimización.

Función incorporada: `size_t` **``__builtin_object_size``** `(const void * ptr, int type)`[](https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html#index-_005f_005fbuiltin_005fobject_005fsize)

Es una construcción incorporada que devuelve un número constante de bytes desde ``ptr`` hasta el final del objeto al que apunta ``ptr`` (si se conoce en tiempo de compilación). Para determinar los tamaños de los objetos asignados dinámicamente, la función se basa en las funciones de asignación a las que se llama para obtener el almacenamiento que debe declararse con el atributo `alloc_size` (véase [Common Function Attributes](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html)). `__builtin_object_size` nunca evalúa sus argumentos en busca de efectos secundarios. Si hay algún efecto secundario en ellos, devuelve `(size_t) -1` para tipo ``0`` o ``1`` y `(size_t) 0` para tipo ``2`` o ``3``. Si hay múltiples objetos a los que ``ptr`` puede apuntar y todos ellos son conocidos en tiempo de compilación, el número devuelto es el máximo de los recuentos de bytes restantes en esos objetos si ``type`` ``& 2`` es ``0`` y el mínimo si es distinto de cero. Si no es posible determinar a qué objetos apunta ``ptr`` en tiempo de compilación, `__builtin_object_size` debería devolver `(size_t) -1` para tipo 0 o 1 y `(size_t) 0` para tipo 2 o 3.

``type`` es una constante entera de ``0`` a ``3``. Si el bit menos significativo está despejado, los objetos son variables enteras, si está establecido, un subobjeto circundante más cercano se considera el objeto al que apunta un puntero. El segundo bit determina si se calcula el máximo o el mínimo de bytes restantes.
```c
struct V { char buf1[10]; int b; char buf2[10]; } var;
char *p = &var.buf1[1], *q = &var.b;

/* Aquí el objeto al que apunta p es var.  */
assert(__builtin_object_size(p, 0) == sizeof(var) - 1);
/* El subobjeto al que apunta p es var.buf1.  */
assert(__builtin_object_size(p, 1) == sizeof(var.buf1) - 1);
/* El objeto al que apunta q es var.  */
assert(__builtin_object_size(q, 0)
        == (char *)(&var + 1) - (char *) &var.b);
/* El subobjeto al que apunta q es var.b.  */
assert(__builtin_object_size(q, 1) == sizeof(var.b));
```