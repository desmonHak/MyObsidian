`const`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-const-function-attribute)

Las llamadas a funciones cuyo valor de retorno no se ve afectado por cambios en el estado observable del programa y que no tienen efectos observables sobre dicho estado, aparte de devolver un valor, pueden prestarse a optimizaciones como la eliminación de subexpresiones comunes. Declarar tales funciones con el atributo `const` permite a GCC evitar la emisión de algunas llamadas en invocaciones repetidas de la función con los mismos valores de argumento.

Por ejemplo

```c
int square (int) __attribute__ ((const));
```

indica a GCC que las llamadas posteriores a la función `cuadrado` con el mismo valor de argumento pueden ser reemplazadas por el resultado de la primera llamada, independientemente de las sentencias intermedias.

El atributo `const` prohíbe a una función leer objetos que afecten a su valor de retorno entre invocaciones sucesivas. Sin embargo, las funciones declaradas con el atributo pueden leer con seguridad objetos que no cambien su valor de retorno, como las constantes no volátiles.

El atributo `const` impone mayores restricciones a la definición de una función que el atributo similar `pure`. Declarar la misma función tanto con el atributo `const` como con el atributo `pure` está diagnosticado. Dado que una función ``const`` no puede tener efectos secundarios observables, no tiene sentido que devuelva `void`. Se diagnostica la declaración de una función de este tipo.

Observe que una función que tiene argumentos punteros y examina los datos apuntados no debe declararse `const` si los datos apuntados pueden cambiar entre invocaciones sucesivas de la función. En general, dado que una función no puede distinguir los datos que pueden cambiar de los que no, las funciones ``const`` nunca deben tomar argumentos punteros o, en C++, de referencia. Del mismo modo, una función que llama a una función ``no-const`` normalmente no debe ser ``const`` en sí misma.