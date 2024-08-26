`null_terminated_string_arg`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-null_005fterminated_005fstring_005farg-function-attribute)
`null_terminated_string_arg (N)`

El atributo `null_terminated_string_arg` se puede aplicar a una función que toma un `char *` o `const char *` en el argumento referenciado N.

Indica que el argumento pasado debe ser una cadena terminada en nulo al estilo C. Específicamente, la presencia del atributo implica que, si el puntero no es nulo, la función puede escanear el búfer referenciado en busca del primer byte cero.

En particular, cuando el analizador está habilitado (a través de ``-fanalyzer``), si el puntero no es nulo, simulará el escaneo del primer byte cero en el búfer referenciado y potencialmente emitirá ``-Wanalyzer-use-of-uninitialized-value`` o ``-Wanalyzer-out-of-bounds`` en búferes terminados incorrectamente.

Por ejemplo, dado lo siguiente:

```c
char *example_1 (const char *p)
  __attribute__((null_terminated_string_arg (1)));
```

el analizador comprobará que todos los punteros no nulos que se pasen a la función estén terminados de forma válida.

Si el parámetro debe ser no nulo, es adecuado utilizar tanto este atributo como el atributo `nonnull`, como en:

```c
extern char *example_2 (const char *p)
  __attribute__((null_terminated_string_arg (1),
                 nonnull (1)));
```

Consulte el atributo `nonnull` para obtener más información y advertencias.

Si el argumento del puntero también se menciona mediante un atributo `access` en la función con modo de acceso `read_only` o `read_write` y el último atributo tiene el argumento opcional ``size-index`` que hace referencia a un argumento ``size``, esto expresa el tamaño máximo del acceso. Por ejemplo, dado lo siguiente:

```c
extern char *example_fn (const char *p, size_t n)
  __attribute__((null_terminated_string_arg (1),
                 access (read_only, 1, 2),
                 nonnull (1)));
```

el analizador requerirá que el primer parámetro no sea nulo y que esté terminado en nulo de forma válida o que sea legible de forma válida hasta el tamaño especificado por el segundo parámetro.







