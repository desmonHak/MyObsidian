https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html

`fd_arg`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-fd_005farg-function-attribute)
`fd_arg (N)`

El atributo `fd_arg` puede aplicarse a una función que toma un descriptor de fichero abierto como argumento referenciado N.

Indica que el descriptor de fichero pasado no debe haber sido cerrado. Por lo tanto, cuando el analizador está habilitado con -``fanalyzer``, el analizador puede emitir un diagnóstico ``-Wanalyzer-fd-use-after-close`` si detecta una ruta de código en la que una función con este atributo es llamada con un descriptor de fichero cerrado.

El atributo también indica que se debe comprobar la validez del descriptor de archivo antes de utilizarlo. Por lo tanto, ``analyzer`` puede emitir un diagnóstico`` -Wanalyzer-fd-use-without-check`` si detecta una ruta de código en la que se llama a una función con este atributo con un descriptor de archivo cuya validez no se ha comprobado.