Algunas funciones de la biblioteca estándar, como ``abort`` y ``exit``, no pueden regresar. ``GCC`` lo sabe automáticamente. Algunos programas definen sus propias funciones que nunca regresan. Puede declararlas como ``noreturn`` para informarle al compilador sobre este hecho. Por ejemplo:
```c
void fatal () __attribute__ ((noreturn));

void fatal (/* … */) {
  /* … */ /* Print error message. */ /* … */
  exit (1);
}
```
La palabra clave ``noreturn`` le indica al compilador que asuma que fatal no puede regresar. Luego puede optimizar sin tener en cuenta lo que sucedería si fatal alguna vez regresara. Esto produce un código ligeramente mejor. Más importante aún, ayuda a evitar advertencias falsas de variables no inicializadas.

La palabra clave ``noreturn`` no afecta la ruta excepcional cuando eso aplica: una función marcada como ``noreturn`` aún puede regresar al llamador lanzando una excepción o llamando a [[longjmp]].

Para preservar los [[backtraces]], GCC nunca convertirá las llamadas a funciones ``noreturn`` en llamadas de cola.

No asuma que los registros guardados por la función que llama se restauran antes de llamar a la función ``noreturn``.

No tiene sentido que una función ``noreturn`` tenga un tipo de retorno distinto de ``void``.
