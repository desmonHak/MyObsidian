`noinline`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noinline-function-attribute)
Este atributo de función evita que una función se considere para la inserción en línea. También deshabilita algunas otras optimizaciones interprocedimentales; es preferible utilizar el atributo ``noipa`` más completo en su lugar si ese es su objetivo.

Incluso si una función se declara con el atributo ``noinline``, existen optimizaciones distintas a la inserción en línea que pueden hacer que las llamadas se optimicen si no tienen efectos secundarios, aunque la llamada a la función esté activa. Para evitar que dichas llamadas se optimicen, coloque

```c
asm ("");
```

(consulte [Extended Asm - Assembler Instructions with C Expression Operands](https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html)) en la función llamada, para que sirva como un efecto secundario especial.