`noplt` [¶](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noplt-function-attribute)

El atributo ``noplt`` es el equivalente a la opción ``-fno-plt``. Las llamadas a funciones marcadas con este atributo en código independiente de la posición no utilizan el [[PLT]].

```c
/* Externally defined function foo.  */
int foo () __attribute__ ((noplt));

int
main (/* … */)
{
  /* … */
  foo ();
  /* … */
}
```
El atributo ``noplt`` de la función ``foo`` le indica al compilador que asuma que la función ``foo`` está definida externamente y que la llamada a ``foo`` debe evitar la [[PLT]] en el código independiente de la posición.

En el código dependiente de la posición, algunos destinos también convierten las llamadas a funciones que están marcadas para no usar la [[PLT]] y usar la [[GOT]] en su lugar.