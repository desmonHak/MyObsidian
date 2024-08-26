`symver ("name2@nodename")`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-symver-function-attribute)

En los destinos [[ELF]], este atributo crea una versión del símbolo. La parte ``name2`` del parámetro es el nombre real del símbolo por el que se hará referencia externamente. La parte `nodename` debe ser el nombre de un nodo especificado en el script de versión proporcionado al enlazador al crear una biblioteca compartida. El símbolo versionado debe definirse y debe exportarse con visibilidad predeterminada.

```c
__attribute__ ((__symver__ ("foo@VERS_1"))) int
foo_v1 (void)
{
}
```

Producirá una directiva `.symver foo_v1, foo@VERS_1` en la salida del ensamblador.

También se pueden definir varias versiones para un símbolo determinado (a partir de ``binutils 2.35``).

```c
__attribute__ ((__symver__ ("foo@VERS_2"), __symver__ ("foo@VERS_3")))
int symver_foo_v1 (void)
{
}
```

Este ejemplo crea un nombre de símbolo `symver_foo_v1`, que será la versión `VERS_2` y `VERS_3` de `foo`.

Si tiene una versión anterior de ``binutils``, se debe utilizar un alias de símbolo:

```c
__attribute__ ((__symver__ ("foo@VERS_2")))
int foo_v1 (void)
{
  return 0;
}
__attribute__ ((__symver__ ("foo@VERS_3")))
__attribute__ ((alias ("foo_v1")))
int symver_foo_v1 (void);
```

Finalmente, si el parámetro es `"name2@@nodename"` además de crear una versión del símbolo (como si se hubiera usado `"name2@nodename"` ), la versión también se usará para resolver ``name2`` por el enlazador.