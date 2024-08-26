`externally_visible`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-externally_005fvisible-function-attribute)

Este atributo, adjunto a una variable global o función, anula el efecto de la opción de línea de comandos ``-fwhole-program``, por lo que el objeto permanece visible fuera de la unidad de compilación actual.

Si ``-fwhole-program`` se utiliza junto con ``-flto`` y ``gold`` se utiliza como plugin enlazador, los atributos ``externally_visible`` se añaden automáticamente a las funciones (aún no variables debido a un problema actual de ``gold``) a las que se accede fuera de los objetos ``LTO`` según el archivo de resolución producido por ``gold``. Para otros enlazadores que no pueden generar el archivo de resolución, los atributos ``externally_visible`` explícitos siguen siendo necesarios.
