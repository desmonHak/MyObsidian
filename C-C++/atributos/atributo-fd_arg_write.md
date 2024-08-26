`fd_arg_write`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-fd_005farg_005fwrite-function-attribute)
`fd_arg_write (N)`

El `fd_arg_write` es idéntico a [[atributo-fd_arg_read]] excepto que el analizador puede emitir un diagnóstico ``-Wanalyzer-access-mode-mismatch`` si detecta una ruta de código en la que una función con este atributo es llamada en un descriptor de fichero abierto con `O_RDONLY`.