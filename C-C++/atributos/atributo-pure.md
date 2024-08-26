`pure`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-pure-function-attribute)

Las llamadas a funciones que no tienen efectos observables en el estado del programa más allá de devolver un valor pueden prestarse a optimizaciones como la eliminación de subexpresiones comunes. Declarar dichas funciones con el atributo `pure` permite a GCC evitar emitir algunas llamadas en invocaciones repetidas de la función con los mismos valores de argumento.

El atributo `pure` prohíbe que una función modifique el estado del programa que es observable por otros medios que no sean inspeccionar el valor de retorno de la función. Sin embargo, las funciones declaradas con el atributo `pure` pueden leer de forma segura cualquier objeto no volátil y modificar el valor de los objetos de una manera que no afecte a su valor de retorno ni al estado observable del programa.

Por ejemplo,

```c
int hash (char *) __attribute__ ((pure));
```

le dice a GCC que las llamadas subsiguientes a la función `hash` con la misma cadena pueden ser reemplazadas por el resultado de la primera llamada siempre que el estado del programa observable por `hash`, incluyendo el contenido de la matriz misma, no cambie entre ellas. Aunque `hash` toma un argumento de puntero no constante, no debe modificar la matriz a la que apunta, o cualquier otro objeto de cuyo valor pueda depender el resto del programa. Sin embargo, el llamador puede cambiar de forma segura el contenido de la matriz entre llamadas sucesivas a la función (al hacerlo se deshabilita la optimización). La restricción también se aplica a los objetos miembro referenciados por el puntero `this` en funciones miembro no estáticas de C++.

Algunos ejemplos comunes de funciones puras son `strlen` o `memcmp`. Las funciones no puras interesantes son funciones con bucles infinitos o aquellas que dependen de memoria volátil u otro recurso del sistema, que pueden cambiar entre llamadas consecutivas (como la función estándar C `feof` en un entorno multihilo).

El atributo `pure` impone restricciones similares pero más flexibles en la definición de una función que el atributo `const`: `pure` permite que la función lea cualquier memoria no volátil, incluso si cambia entre invocaciones sucesivas de la función. Declarar la misma función con los atributos `pure` y `const` se diagnostica. Debido a que una función pura no puede tener ningún efecto secundario observable, no tiene sentido que dicha función devuelva `void`. Declarar dicha función se diagnostica.