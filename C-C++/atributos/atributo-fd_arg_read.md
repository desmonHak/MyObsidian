https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
`fd_arg_read`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-fd_005farg_005fread-function-attribute)
`fd_arg_read (N)`

La función `fd_arg_read` es idéntica a `fd_arg`, pero con el requisito adicional de que puede leer del descriptor de fichero, y por tanto, el descriptor de fichero no debe haber sido abierto como sólo escritura.

El analizador puede emitir un diagnóstico -Wanalyzer-access-mode-mismatch si detecta una ruta de código en la que una función con este atributo es llamada en un descriptor de fichero abierto con `O_WRONLY`.