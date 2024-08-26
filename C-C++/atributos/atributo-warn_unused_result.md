`warn_unused_result`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute)

El atributo `warn_unused_result` hace que se emita una advertencia si un llamador de la función con este atributo no utiliza su valor de retorno. Esto es útil para funciones en las que no verificar el resultado es un problema de seguridad o siempre un error, como `realloc`.

```c
int fn () __attribute__ ((warn_unused_result));
int foo ()
{
  if (fn () < 0) return -1;
  fn();
  return 0;
}
```

resulta en advertencia en la línea 5.