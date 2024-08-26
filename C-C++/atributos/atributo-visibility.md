`visibility ("visibility_type")`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-visibility-function-attribute)

Este atributo afecta la vinculación de la declaración a la que está asociado. Se puede aplicar a variables (consulte [Atributos de variables comunes](https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html)) y tipos (consulte [Atributos de tipos comunes](https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html)) así como a funciones.

Hay cuatro valores de ``visibility_type`` admitidos: predeterminado, oculto, protegido o visibilidad interna.
```c
void __attribute__ ((visibility ("protected")))
f () { /* Do something. */; }
int i __attribute__ ((visibility ("hidden")));
```

Los valores posibles de ``visibility_type`` corresponden a las configuraciones de visibilidad en la g[[ABI]] [[ELF]].

`default`
La visibilidad predeterminada es el caso normal para el formato de archivo de objeto. Este valor está disponible para que el atributo de visibilidad anule otras opciones que puedan cambiar la visibilidad asumida de las entidades.

En [[ELF]], la visibilidad predeterminada significa que la declaración es visible para otros módulos y, en bibliotecas compartidas, significa que la entidad declarada puede ser anulada.

En ``Darwin``, la visibilidad predeterminada significa que la declaración es visible para otros módulos.

La visibilidad predeterminada corresponde a un “enlace externo” en el lenguaje.

`hidden`
La visibilidad oculta indica que la entidad declarada tiene una nueva forma de enlace, que llamamos “enlace oculto”. Dos declaraciones de un objeto con enlace oculto hacen referencia al mismo objeto si están en el mismo objeto compartido.

`internal`
La visibilidad interna es como la visibilidad oculta, pero con semántica adicional específica del procesador. A menos que ps[[ABI]] especifique lo contrario, ``GCC`` define la visibilidad interna como que una función _nunca_ es llamada desde otro módulo. Compárese esto con las funciones ocultas que, si bien no pueden ser referenciadas directamente por otros módulos, pueden ser referenciadas indirectamente a través de punteros de función. Al indicar que una función no puede ser llamada desde fuera del módulo, ``GCC`` puede, por ejemplo, omitir la carga de un registro ``PIC`` ya que se sabe que la función que llama cargó el valor correcto.

`protected`
La visibilidad protegida es como la visibilidad predeterminada excepto que indica que las referencias dentro del módulo de definición se vinculan a la definición en ese módulo. Es decir, la entidad declarada no puede ser anulada por otro módulo.

Todas las visibilidades son compatibles con muchos, pero no todos, los objetivos [[ELF]] (compatibles cuando el ensamblador admite la pseudooperación '``.visibility``'). La visibilidad predeterminada es compatible en todas partes. La visibilidad oculta es compatible con los objetivos ``Darwin``.

El atributo de visibilidad debe aplicarse solo a las declaraciones que de otro modo tendrían un enlace externo. El atributo debe aplicarse de manera consistente, de modo que no se deba declarar la misma entidad con diferentes configuraciones del atributo.

En ``C++``, el atributo de visibilidad se aplica a los tipos, así como a las funciones y los objetos, porque en ``C++`` los tipos tienen vínculos. Una clase no debe tener mayor visibilidad que sus bases y tipos de datos miembros no estáticos, y los miembros de la clase tienen como valor predeterminado la visibilidad de su clase. Además, una declaración sin visibilidad explícita está limitada a la visibilidad de su tipo.

En ``C++``, puede marcar funciones miembro y variables miembro estáticas de una clase con el atributo de visibilidad. Esto es útil si sabe que un método particular o una variable miembro estática solo se deben usar desde un objeto compartido; luego puede marcarlo como oculto mientras el resto de la clase tiene la visibilidad predeterminada. Se debe tener cuidado para evitar romper la regla de una definición; por ejemplo, generalmente no es útil marcar un método en línea como oculto sin marcar toda la clase como oculta.

Una declaración de espacio de nombres de ``C++`` también puede tener el atributo de visibilidad.

```cpp
namespace nspace1 __attribute__ ((visibility ("protected")))
{ /* Do something. */; }
```

Este atributo se aplica únicamente al cuerpo del espacio de nombres en particular, no a otras definiciones del mismo espacio de nombres; es equivalente a usar ‘``#pragma GCC transparency``’ antes y después de la definición del espacio de nombres (consulte [Pragmas de visibilidad](https://gcc.gnu.org/onlinedocs/gcc/Visibility-Pragmas.html)).

En ``C++``, si un argumento de plantilla tiene una visibilidad limitada, esta restricción se propaga implícitamente a la instanciación de la plantilla. De lo contrario, las instanciaciones de plantilla y las especializaciones tienen como valor predeterminado la visibilidad de su plantilla.

Si tanto la plantilla como la clase que la encierra tienen visibilidad explícita, se utiliza la visibilidad de la plantilla.