`zero_call_used_regs ("choice")`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-zero_005fcall_005fused_005fregs-function-attribute)

El atributo `zero_call_used_regs` hace que el compilador ponga a cero un subconjunto de todos los registros usados ​​por la llamada[6](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#FOOT6) en el retorno de la función. Esto se utiliza para aumentar la seguridad del programa, ya sea mitigando los ataques de ``Return-Oriented Programming``(``Programación Orientada al Retorno``) ([[ROP]]) o evitando la fuga de información a través de los registros.

Para satisfacer a los usuarios con diferentes necesidades de seguridad y controlar la sobrecarga en tiempo de ejecución al mismo tiempo, el parámetro choice proporciona una forma flexible de elegir el subconjunto de los registros usados ​​por la llamada que se pondrán a cero. Los cuatro valores básicos de choice son:

- ‘``skip``’ no pone a cero ningún registro usado por la llamada.
- ‘``used``’ solo pone a cero los registros usados ​​por la llamada que se usan en la función. Un registro “``used``” es uno cuyo contenido se ha establecido o referenciado en la función.
- ‘``all``’ pone a cero todos los registros utilizados en la llamada.
- ‘``leafy``’ se comporta como ‘``used``’ en una función ``leaf``, y como ‘``all``’ en una función que no es ``leaf``. Esto permite una puesta a cero más eficiente en las funciones ``leaf``, donde se conoce el conjunto de registros utilizados, y eso puede ser suficiente para algunos propósitos de puesta a cero de registros.

Además de estas tres opciones básicas, es posible modificar ‘``used``’, ‘``all``’ y ‘``leafy``’ de la siguiente manera:

- Agregar ‘``-gpr``’ restringe la puesta a cero a los registros de propósito general.
- Agregar ‘``-arg``’ restringe la puesta a cero a los registros que a veces se pueden usar para pasar argumentos de función. Esto incluye todos los registros de argumentos definidos por la conversión de llamada de la plataforma, independientemente de si la función usa esos registros para argumentos de función o no.

Los modificadores se pueden usar individualmente o juntos. Si se usan juntos, deben aparecer en el orden anterior.

La lista completa de opciones es, por lo tanto:

`skip`
no pone a cero ningún registro usado en la llamada.

`used`
solo pone a cero los registros usados ​​en la llamada que se usan en la función.

`used-gpr`
solo pone a cero los registros de propósito general usados ​​en la llamada que se usan en la función.

`used-arg`
solo pone a cero los registros usados ​​en la llamada que se usan en la función y pasan argumentos.

`used-gpr-arg`
solo pone a cero los registros de propósito general usados ​​en la llamada que se usan en la función y pasan argumentos.

`all`
pone a cero todos los registros usados ​​en la llamada.

`all-gpr`
pone a cero todos los registros de propósito general usados ​​en la llamada.

`all-arg`
pone a cero todos los registros usados ​​en la llamada que pasan argumentos.

`all-gpr-arg`
pone a cero todos los registros de propósito general usados ​​en la llamada que pasan argumentos.

`leafy`
Igual que ‘``used``’ en una función de hoja, y lo mismo que ‘``all``’ en una función que no es de hoja.

`leafy-gpr`
Igual que ‘``used-gpr``’ en una función de hoja, y lo mismo que ‘``all-gpr``’ en una función que no es de hoja.

`leafy-arg`
Igual que ‘``used-arg``’ en una función de hoja, y lo mismo que ‘``all-arg``’ en una función que no es de hoja.

`leafy-gpr-arg`
Igual que ‘``used-gpr-arg``’ en una función de hoja, y lo mismo que ‘``all-gpr-arg``’ en una función que no es de hoja.

De esta lista, ‘``used-arg``’, ‘``used-gpr-arg``’, ‘``all-arg``’, ‘``all-gpr-arg``’, ‘``leafy-arg``’ y ‘``leafy-gpr-arg``’ se utilizan principalmente para la mitigación de [[ROP]].

El valor predeterminado para el atributo está controlado por ``-fzero-call-used-regs``.