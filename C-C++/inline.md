## inline para GCC
https://stackoverflow.com/questions/22767523/what-inline-attribute-always-inline-means-in-the-function
![[Pasted image 20240823213958.png]]

He encontrado la siguiente definición de función:

```c
static inline __attribute__((always_inline)) int fn(const char *s)
{
  return (!s || (*s == '\0'));
}
```

Y quiero saber el significado de `inline __attribute__((always_inline))`?

La documentación de ``gcc`` a menudo referenciada para ``always_inline`` es incompleta.

El atributo ``always_inline`` hace al compilador ``gcc``:

Ignore ` -fno-inline` (esto es lo que dice la documentación).
Ignora los **límites de inline** por lo que inlinea la función a pesar de todo. También inlinea funciones con llamadas ``alloca``, que la palabra clave ``inline`` nunca hace.

No produce una definición externa de una función con enlace externo si está marcada con `always_inline`.
La fuente de la información anterior es el código fuente de gcc, y, por lo tanto, está sujeta a cambios sin previo aviso.

Un bechmark interesante: el rendimiento de always_inline:
https://indico.cern.ch/event/386232/sessions/159923/attachments/771039/1057534/always_inline_performance.pdf

Obliga al compilador a alinear la función incluso si las optimizaciones están desactivadas. Consulte esta documentación para obtener más información.

https://gcc.gnu.org/onlinedocs/gcc/Inline.html
![[Pasted image 20240823214526.png]]
Una función en línea es tan rápida como una macro
Declarando una función inline, puede dirigir a GCC para que las llamadas a esa función sean más rápidas. Una forma en la que GCC puede conseguirlo es integrando el código de esa función en el código de sus llamadas. Esto hace que la ejecución sea más rápida al eliminar la sobrecarga de la llamada a la función; además, si alguno de los valores reales de los argumentos es constante, sus valores conocidos pueden permitir simplificaciones en tiempo de compilación de forma que no sea necesario incluir todo el código de la función inline. El efecto sobre el tamaño del código es menos predecible; el código objeto puede ser mayor o menor con la función inline, dependiendo del caso particular. También puede indicar a GCC que intente integrar todas las funciones «``suficientemente simples``» en sus llamadas con la opción ``-finline-functions``.

GCC implementa tres semánticas diferentes de declarar una función inline. Una está disponible con ``-std=gnu89`` o ``-fgnu89-inline`` o cuando el atributo ``gnu_inline`` está presente en todas las declaraciones inline, otra cuando se utiliza ``-std=c99``, ``-std=gnu99`` o una opción para una versión de C posterior (sin ``-fgnu89-inline``), y la tercera se utiliza al compilar C++.

Para declarar una función ``inline``, utilice la palabra clave inline en su declaración, de la siguiente manera:
```c
static inline int inc (int *a) {
  return (*a)++;
}
```

Si está escribiendo un archivo de cabecera para incluirlo en programas ISO C90, escriba ``__inline__`` en lugar de ``inline``. Consulte Palabras clave alternativas.

Los tres tipos de inlining se comportan de forma similar en dos casos importantes: cuando la palabra clave ``inline`` se utiliza en una función estática, como en el ejemplo anterior, y cuando una función se declara primero sin utilizar la palabra clave ``inline`` y luego se define con ``inline``, como en este caso:

```c
extern int inc (int *a);
inline int inc (int *a) {
  return (*a)++;
}
```

En estos dos casos comunes, el programa se comporta igual que si no hubiera utilizado la palabra clave ``inline``, excepto por su velocidad.

Cuando una función es tanto ``inline`` como ``static``, si todas las llamadas a la función están integradas en el llamador, y la dirección de la función nunca se usa, entonces el propio código ensamblador de la función nunca es referenciado. En este caso, GCC no genera código ensamblador para la función, a menos que especifique la opción ``-fkeep-inline-functions``. Si hay una llamada no integrada, entonces la función se compila a código ensamblador como de costumbre. La función también debe compilarse como de costumbre si el programa hace referencia a su dirección, ya que ésta no puede inlinearse.

Tenga en cuenta que algunos usos de la definición de una función pueden hacerla inadecuada para la sustitución en línea. Entre estos usos están: funciones variádicas, uso de ``alloca``, uso de ``goto`` computado (ver Labels as Values), uso de ``goto`` no local, uso de funciones anidadas, uso de setjmp, uso de ``__builtin_longjmp`` y uso de ``__builtin_return`` o ``__builtin_apply_args``. El uso de ``-Winline`` avisa cuando una función marcada como ``inline`` no ha podido ser sustituida, y da la razón del fallo.

Como requiere`` ISO C++``, GCC considera que las funciones miembro definidas dentro del cuerpo de una clase están marcadas ``inline`` incluso si no están explícitamente declaradas con la palabra clave ``inline``. Puede anular esto con ``-fno-default-inline``; vea Opciones que controlan el dialecto C++.

GCC no inlinea cualquier función cuando no optimiza a menos que especifique el atributo '``always_inline``' para la función, así:
```c
/* Prototype.  */
inline void foo (const char) __attribute__((always_inline));
```
El resto de esta sección es específica para ``GNU C90 inlining``.

Cuando una función ``inline`` no es estática, entonces el compilador debe asumir que puede haber llamadas desde otros ficheros fuente; dado que un símbolo global sólo puede definirse una vez en cualquier programa, la función no debe definirse en los otros ficheros fuente, por lo que las llamadas en ellos no pueden integrarse. Por lo tanto, una función ``inline`` no estática siempre se compila por sí sola de la forma habitual.

Si especifica tanto ``inline`` como ``extern`` en la definición de la función, entonces la definición se utiliza sólo para inlining. En ningún caso se compila la función por sí sola, ni siquiera si se hace referencia explícita a su dirección. Dicha dirección se convierte en una referencia externa, como si sólo hubiera declarado la función y no la hubiera definido.

Esta combinación de ``inline`` y ``extern`` tiene casi el efecto de una macro. La forma de utilizarla es poner una definición de función en un fichero de cabecera con estas palabras clave, y poner otra copia de la definición (sin ``inline`` y ``extern``) en un fichero de biblioteca. La definición en el fichero de cabecera hace que la mayoría de las llamadas a la función sean ``inline``. Si queda algún uso de la función, se refiere a la copia única en la biblioteca.

## inline para Clang
https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html
![[Pasted image 20240823222014.png]]
Hay varias opciones que controlan las llamadas que el analizador considerará para inlining. La principal es ``-analyzer-config ipa``:

``analyzer-config ipa=none`` - Todo el inlining está deshabilitado. Este es el único modo disponible en LLVM 3.1 y anteriores y en Xcode 4.3 y anteriores.

``analyzer-config ipa=basic-inlining`` - Activa el inlining para funciones C, funciones miembro estáticas y bloques C++.
y bloques - esencialmente, las llamadas que se comportan como simples llamadas a funciones C. Este es esencialmente el modo utilizado en Xcode 4.4.

``analyzer-config ipa=inlining`` - Activa el inlining cuando podemos encontrar con seguridad el cuerpo de la función/método correspondiente a la llamada. (``Funciones C``, ``funciones estáticas``, ``métodos C++ desvirtualizados``, ``métodos de clase Objective-C``, ``métodos de instancia Objective-C cuando ExprEngine confía en el tipo dinámico de la instancia``).

``analyzer-config ipa=dynamic`` - Métodos de instancia ``inline`` para los que el tipo se determinado en tiempo de ejecución y no estamos 100% seguros de que nuestra información de tipo sea correcta. Para llamadas virtuales, ``inline`` la definición más plausible.

``analyzer-config ipa=dynamic-bifurcate`` - Igual que ``-analyzer-config ipa=dynamic``,
pero la ruta se divide. Hacemos inline en una rama y no lo hacemos en la otra. Este modo no reduce la cobertura en los casos en que la clase padre tiene código que sólo se ejecuta cuando se sobrescriben algunos de sus métodos.

Actualmente,`` -analyzer-config ipa=dynamic-bifurcate`` es el modo por defecto.

Mientras que ``-analyzer-config ipa`` determina en general la agresividad con la que el analizador intentará inlinear funciones, varias opciones adicionales controlan qué tipos de funciones pueden inlinearse, de forma todo o nada. Estas opciones utilizan la tabla de configuración del analizador, por lo que se especifican de la siguiente manera:

``-analyzer-config OPTION=VALUE``

## 3.2.1. c++-inlining[](https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html#c-inlining "Permalink to this heading")

Esta opción controla qué funciones miembro de C++ pueden ser inlineadas.

> `-analyzer-config c++-inlining=[none | methods | constructors | destructors]`

Cada uno de estos modos implica que todos los tipos de funciones miembro anteriores también serán inlineados; no tiene sentido inlinear destructores sin inlinear constructores, por ejemplo.

El modo c++-inlining por defecto es 'destructors', lo que significa que todas las funciones miembro con definiciones visibles serán consideradas para inlining. En algunos casos, el analizador puede decidir no alinear la función.

Tenga en cuenta que en «constructores», los constructores de tipos con destructores no triviales no se alinearán. Además, ninguna función miembro de C++ se alineará bajo ``-analyzer-config ipa=none`` o ``-analyzer-config ipa=basic-inlining``, independientemente de la configuración del modo c++-inlining.

### 3.2.1.2. c++-stdlib-inlining[](https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html#c-stdlib-inlining «Permalink to this heading»)

Esta opción controla si las funciones de la librería estándar de C++, incluyendo los métodos de las clases contenedoras de la Standard Template Library, deben ser consideradas para inlining.

> `-analyzer-config c++-stdlib-inlining=[true | false]`

Actualmente, las funciones de la biblioteca estándar de C++ se consideran para inlining por defecto.

Las funciones de la biblioteca estándar y la STL en particular se utilizan de forma lo suficientemente ubicua como para que nuestra tolerancia a los falsos positivos sea aún menor en este caso. Un falso positivo debido a un mal modelado de la STL conduce a una mala experiencia de usuario, ya que la mayoría de los usuarios no se sentirían cómodos añadiendo aserciones a las cabeceras del sistema con el fin de silenciar las advertencias del analizador.

### 3.2.1.3. c++-container-inlining[](https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html#c-container-inlining «Permalink to this heading»)

Esta opción controla si los constructores y destructores de tipos «contenedores» deben ser considerados para inlining.

> `-analyzer-config c++-container-inlining=[true | false]`

Actualmente, estos constructores y destructores NO son considerados para inlining por defecto.
La implementación actual de este ajuste comprueba si un tipo tiene un miembro llamado 'iterador' o un miembro llamado 'begin'; estos nombres son idiomáticos en C++, con el último especificado en el estándar C++11. El analizador actualmente hace un trabajo bastante pobre al modelar ciertas invariantes de estructura de datos de objetos tipo contenedor. Por ejemplo, estas tres expresiones deberían ser equivalentes:

```cpp
std::distance(c.begin(), c.end()) == 0
c.begin() == c.end()
c.empty()
```

Muchos de estos problemas se evitan si los contenedores tienen siempre un estado simbólico desconocido, que es lo que ocurre cuando sus constructores se tratan como opacos. En el futuro, podemos decidir que determinados contenedores son «seguros» de modelar mediante inlining, u optar por modelarlos directamente utilizando comprobadores.

## 3.2.2. Fundamentos de la implementación
El mecanismo de bajo nivel de inlining de una función se maneja en ``ExprEngine::inlineCall`` y ``ExprEngine::processCallExit``.

Si se dan las condiciones para inlining, se crea un nodo ``CallEnter`` y se añade a la lista de trabajo de análisis. El nodo ``CallEnter`` marca el cambio a un nuevo ``LocationContext`` que representa la función llamada, y su estado incluye el contenido del nuevo marco de pila. Cuando el nodo ``CallEnter`` es realmente procesado, su único sucesor será una arista al primer bloque ``CFG`` de la función.

Salir de una función inlined es un poco más de trabajo, afortunadamente dividido en pasos razonables:

El ``CoreEngine`` se da cuenta de que estamos al final de una llamada inlined y genera un nodo ``CallExitBegin``.

``ExprEngine`` toma el relevo (en ``processCallExit``) y encuentra el valor de retorno de la función, si lo tiene. Éste se vincula a la expresión que desencadenó la llamada. (En el caso de llamadas sin expresiones de origen, como los destructores, este paso se omite).

Los símbolos y enlaces muertos se eliminan del estado, incluyendo cualquier enlace local.

Se genera un nodo ``CallExitEnd``, que marca la transición de vuelta al ``LocationContext`` del llamante.

Se procesan las comprobaciones personalizadas posteriores a la llamada y los nodos finales se devuelven a la lista de trabajo para que pueda continuar la evaluación de la persona que llama.

## 3.2.2.1. Reintento sin inlining
En algunos casos, nos gustaría reintentar el análisis sin inlining de una llamada en particular.

Actualmente, utilizamos esta técnica para recuperar la cobertura en caso de que dejemos de analizar una ruta debido a que se supera el número máximo de bloques dentro de una función inline.

Cuando se detecta esta situación, recorremos la ruta hasta encontrar el primer nodo antes de que se iniciara el inlineado y lo ponemos en cola en la ``WorkList`` con un bit especial ``ReplayWithoutInlining`` añadido (``ExprEngine::replayWithoutInlining``). A continuación, la ruta se vuelve a analizar desde ese punto sin inlining esa llamada en particular.

3.2.2.2. Decidir cuándo inlinear
En general, el analizador intenta alinear tanto como sea posible, ya que proporciona un mejor resumen de lo que realmente ocurre en el programa. Sin embargo, hay algunos casos en los que el analizador decide no hacer inline:

Si no hay una definición disponible para la función o método llamado. En este caso, no hay oportunidad de hacer inline.

Si no se puede construir la CFG para una función llamada, o no se puede calcular la liveness. Estos son prerrequisitos para analizar el cuerpo de una función, con o sin inlining.

Si la cadena ``LocationContext`` para un ``ExplodedNode`` dado alcanza una profundidad de corte máxima. Esto evita el análisis ilimitado debido a la recursión infinita, pero también sirve como límite útil por razones de rendimiento.

Si la función es variádica. No se trata de una limitación estricta, sino de una limitación de ingeniería.

Rastreado por: <rdar://problem/12147064> Apoyar el inlining de funciones variádicas.


En C++, los constructores no se inlinean a menos que la llamada al destructor vaya a ser procesada por el ``ExprEngine``. Así, si el CFG fue construido sin nodos para destructores implícitos, o si los destructores para el objeto dado no están representados en el CFG, el constructor no será inlineado. (Como excepción, los constructores para objetos con constructores triviales aún pueden ser inlineados). Véase «Caveats C++» más adelante.

En C++, ExprEngine no inlinea implementaciones personalizadas del operador 'new' o del operador 'delete', ni inlinea los constructores y destructores asociados con estos. Consulte «Advertencias de C++» más adelante.

Las llamadas que resultan en un «envío dinámico» se tratan de forma especial. Véase más abajo.

El mapa ``FunctionSummaries`` almacena información adicional sobre las declaraciones, parte de la cual se recopila en tiempo de ejecución basándose en análisis anteriores. No se inlinean funciones que no eran rentables de inlinear en un contexto diferente (por ejemplo, si se excedía el número máximo de bloques; véase «Reintentar sin inlinear»).

## 3.2.2.4. DynamicTypeInfo
A medida que el analizador analiza una ruta, puede acumular información para refinar el conocimiento sobre el tipo de un objeto. Esto se puede utilizar para tomar mejores decisiones sobre el método de destino de una llamada.

Esta información de tipo se registra como ``DynamicTypeInfo``. Se trata de datos sensibles a la ruta que se almacenan en ``ProgramState``, que define una asignación de ``MemRegions`` a un ``DynamicTypeInfo`` (opcional).

Si no se ha definido explícitamente ningún ``DynamicTypeInfo`` para una ``MemRegion``, se deducirá perezosamente del tipo de la región o del símbolo asociado. La información de las regiones simbólicas es más débil que la de las regiones de tipo real.

```
EJEMPLO: Se sabe que un objeto C++ declarado «A obj» tiene la clase 'A', pero una referencia
referencia «A &ref» puede ser dinámicamente una subclase de 'A'.
```

El comprobador ``DynamicTypePropagation`` recopila y propaga ``DynamicTypeInfo``, actualizándola a medida que se observa información a lo largo de una ruta que puede refinar esa información de tipo para una región.

ADVERTENCIA: No todo el código existente del analizador ha sido adaptado para utilizar
``DynamicTypeInfo``, ni es universalmente apropiado. En particular, ``DynamicTypeInfo`` siempre se aplica a una región con todos los moldes eliminados, pero a veces la información proporcionada por los moldes puede ser útil.

## 3.2.2.5. RuntimeDefinition
La base de la desvirtualización es el método ``getRuntimeDefinition()`` de ``CallEvent``, que devuelve un objeto ``RuntimeDefinition``. Cuando se les pide que proporcionen una definición, los ``CallEvents`` para llamadas dinámicas utilizarán el ``DynamicTypeInfo`` en su ``ProgramState`` para intentar desvirtualizar la llamada. En el caso de no envío dinámico, o desvirtualización perfectamente restringida, el ``RuntimeDefinition`` resultante contiene un ``Decl`` correspondiente a la definición de la función llamada, y ``RuntimeDefinition::mayHaveOtherDefinitions`` devolverá FALSE.

En el caso de envío dinámico donde nuestra información no es perfecta, ``CallEvent`` puede hacer una suposición, pero ``RuntimeDefinition::mayHaveOtherDefinitions`` devolverá TRUE. El objeto ``RuntimeDefinition`` también incluirá una ``MemRegion`` correspondiente al objeto que está siendo llamado (es decir, el «receptor» en lenguaje ``Objective-C``), que ``ExprEngine`` utiliza para decidir si la llamada debe ser inlineada o no.

## 3.2.2.6. Llamadas dinámicas inlining
La opción ``-analyzer-config ipa`` tiene cinco modos diferentes: ``none``, ``basic-inlining``, ``inlining``, ``dynamic`` y ``dynamic-bifurcate``. Bajo ``-analyzer-config ipa=dynamic``, todas las llamadas dinámicas se inlinean, estemos seguros o no de que ésta será realmente la definición utilizada en tiempo de ejecución. Con ``-analyzer-config ipa=inlining``, sólo se inlinean* las llamadas desvirtualizadas «casi perfectas», y el resto de llamadas dinámicas se evalúan de forma conservadora (como si no hubiera ninguna definición disponible).

Actualmente, no se inlinea ningún mensaje ``Objective-C`` bajo ``-analyzer-config ipa=inlining``, incluso si estamos razonablemente seguros del tipo del receptor. Tenemos previsto activar esta opción una vez que hayamos probado nuestra heurística más a fondo.

La última opción, ``-analyzer-config ipa=dynamic-bifurcate``, se comporta de forma similar a «dynamic», pero realiza una invalidación conservadora en el caso virtual general además de inlining. Los detalles de esto se discuten más adelante.

Como se ha indicado anteriormente,`` -analyzer-config ipa=basic-inlining`` no inlinea ninguna función miembro de C++ ni llamadas a métodos de ``Objective-C``, aunque no sean virtuales o puedan desvirtualizarse con seguridad.

## 3.2.2.7. Bifurcación
``ExprEngine::BifurcateCall`` implementa el modo ``-analyzer-config ipa=dynamic-bifurcate``.

Cuando se realiza una llamada sobre un objeto con información de tipo dinámica imprecisa (``RuntimeDefinition::mayHaveOtherDefinitions()`` evalúa a ``TRUE``), ``ExprEngine`` bifurca la ruta y marca la región del objeto (recuperada del objeto ``RuntimeDefinition``) con un «modo» sensible a la ruta en el ``ProgramState``.

Actualmente, existen 2 modos:

``DynamicDispatchModeInlined`` - Modela el caso en el que la información de tipo dinámico
del receptor (``MemoryRegion``) se supone perfectamente restringida, de modo que se espera que una definición dada de un método sea el código realmente llamado. Cuando se establece este modo, ``ExprEngine`` utiliza el ``Decl`` de ``RuntimeDefinition`` para inline cualquier llamada despachada dinámicamente enviada a este receptor porque se considera que la definición de la función está totalmente resuelta.

``DynamicDispatchModeConservative`` - Modela el caso en el que la información de tipo dinámico
es incorrecta, por ejemplo, implica que la definición del método se sobrescribe en una subclase. En tales casos, ``ExprEngine`` no inlinea los métodos enviados al receptor (``MemoryRegion``), incluso si hay una definición candidata disponible. Este modo es conservador a la hora de simular los efectos de una llamada.

Avanzando a lo largo de la ruta de ejecución simbólica, ``ExprEngine`` consulta el modo de la ``MemRegion`` del receptor para tomar decisiones sobre si las llamadas deben ser inlineadas o no, lo que asegura que haya como máximo una división por región.

A alto nivel, el «modo bifurcación» permite aumentar la cobertura semántica en los casos en que el método padre contiene código que sólo se ejecuta cuando se subclasifica la clase. Las desventajas de este modo son un impacto (¿considerable?) en el rendimiento y la posibilidad de falsos positivos en la ruta en la que se utiliza el modo conservador.

### 3.2.2.8. Heurística de mensajes Objective-C[](https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html#objective-c-message-heuristics «Permalink to this heading»)

ExprEngine se basa en un conjunto de heurísticas para particionar el conjunto de llamadas a métodos Objective-C en aquellas que requieren bifurcación y aquellas que no. A continuación se indican los casos en los que el DynamicTypeInfo del objeto se considera preciso (no puede ser una subclase):

> - Si el objeto fue creado con +`alloc` o +`new` e inicializado con un método -init.
>     
> - Si las llamadas son accesos a propiedades utilizando la sintaxis de puntos. Esto se basa en la suposición de que los hijos rara vez anulan propiedades, o lo hacen de una manera esencialmente compatible.
>     
> - Si la interfaz de la clase se declara dentro del fichero fuente principal. En este caso es poco probable que sea subclasificada.
>     
> - Si el método no está declarado fuera del fichero fuente principal, ni por la clase del receptor ni por ninguna superclase.

### 3.2.2.9. C++ Caveats[](https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html#c-caveats «Permalink to this heading»)

C++11 [class.cdtor]p4 describe cómo la vtable de un objeto se modifica a medida que se construye o destruye; es decir, el tipo del objeto depende de qué constructores base se han completado. Esto se rastrea utilizando DynamicTypeInfo en el comprobador DynamicTypePropagation.

Hay varias limitaciones en la implementación actual:

- Los temporales están mal modelados ahora mismo porque no estamos seguros de la ubicación de sus destructores en la CFG. Actualmente no alineamos sus constructores a menos que el destructor sea trivial, y no procesamos sus destructores en absoluto, ni siquiera para invalidar la región.
    
- new' está mal modelado debido a algunos problemas desagradables de CFG/diseño. Esto es objeto de seguimiento en PR12014. delete' no está modelado en absoluto.
    
- Las matrices de objetos se modelan muy mal ahora mismo. ExprEngine actualmente sólo simula el primer constructor y el primer destructor. Debido a esto, ExprEngine no inline ningún constructor o destructor para arrays.
### 3.2.2.10. CallEvent[¶](https://clang.llvm.org/docs/analyzer/developer-docs/IPA.html#callevent «Permalink to this heading»)

Un ``CallEvent`` representa una llamada específica a una función, método u otro cuerpo de código. Es sensible a la ruta, contiene tanto el estado actual (``ProgramStateRef``) como el espacio de pila (``LocationContext``), y proporciona acceso uniforme a los valores de los argumentos y al tipo de retorno de una llamada, independientemente de cómo esté escrita la llamada en el código fuente o de qué tipo de cuerpo de código se esté invocando.

> NOTA: Para aquellos familiarizados con Cocoa, `CallEvent` es aproximadamente equivalente a
> 	`NSInvocation.`

``CallEvent`` debería usarse siempre que haya lógica que trate con llamadas a funciones a las que no les importe cómo se ha producido la llamada.

Los ejemplos incluyen la comprobación de que los argumentos satisfacen las condiciones previas (como ``__attribute__((nonnull))``), y el intento de alinear una llamada.

Los ``CallEvents`` son objetos contados por referencia gestionados por un ``CallEventManager``. Si bien no hay ningún problema inherente con la persistencia de ellos (por ejemplo, en un GDM de ``ProgramState``), están destinados a un uso de corta duración, y pueden ser recreados a partir de ``CFGElements`` o ``StackFrameContexts`` de nivel no superior con bastante facilidad.