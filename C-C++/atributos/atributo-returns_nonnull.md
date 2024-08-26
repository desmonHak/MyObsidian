El atributo returns_nonnull especifica que el valor de retorno de la función debe ser un puntero no nulo. Por ejemplo, la declaración:

```c
extern void *
mymalloc (size_t len) __attribute__((returns_nonnull));
```

permite al compilador optimizar los invocadores basándose en el conocimiento de que el valor de retorno nunca será nulo.