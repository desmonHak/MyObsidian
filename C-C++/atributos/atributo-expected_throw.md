`expected_throw`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-expected_005fthrow-function-attribute)

https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html

Este atributo, asociado a una función, indica al compilador que es más probable que la función lance o propague una excepción que que retorne, haga un bucle eterno o termine el programa.

En la mayoría de los casos, el compilador ignora esta sugerencia. El único efecto se produce cuando se aplica a funciones `noreturn` y '``-fharden-control-flow-redundancy``' está activado, y '``-fhardcfr-check-noreturn-calls=not-always``' no está anulado.