`alias («objetivo»)`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alias-function-attribute)

El atributo `alias` hace que la declaración se emita como un alias para otro símbolo, que debe haber sido declarado previamente con el mismo tipo, y para variables, también el mismo tamaño y alineación. Declarar un alias con un tipo diferente al del objetivo es indefinido y puede ser diagnosticado. Como ejemplo, las siguientes declaraciones:

```c
void __f () { /* Do something. */; }
void f () __attribute__ ((weak, alias ("__f")));
```

define '``f``' como un alias débil para '``__f``'. En C++, se debe utilizar el nombre ``mangled`` para el objetivo. Es un error si '``__f``' no está definido en la misma unidad de traducción.

Este atributo requiere soporte de ensamblador y archivo objeto, y puede no estar disponible en todos los objetivos.