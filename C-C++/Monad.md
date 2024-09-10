---
tags:
---
https://en.wikipedia.org/wiki/Monad_(functional_programming)

En [programación funcional](https://en.wikipedia.org/wiki/Functional_programming "Programación funcional"), una **[[Monad]]** es una estructura que combina fragmentos de programa ([funciones](https://en.wikipedia.org/wiki/Function_(computer_programming) "Función (programación informática)")) y envuelve sus [valores de retorno](https://en.wikipedia.org/wiki/Return_value "Valor de retorno") en un [tipo](https://en.wikipedia.org/wiki/Type_system "Sistema de tipos") con computación adicional. Además de definir un tipo ``monádico`` envolvente, las mónadas definen dos [operadores](https://en.wikipedia.org/wiki/Operator_(computer_programming) "Operador (programación informática)"): uno para envolver un valor en el tipo de mónada y otro para componer funciones que generen valores del tipo de mónada (se conocen como **funciones ``monádicas``**). Los lenguajes de propósito general usan mónadas para reducir el [código repetitivo](https://en.wikipedia.org/wiki/Boilerplate_code "Código repetitivo") necesario para operaciones comunes (como tratar con valores indefinidos o funciones falibles, o encapsular código de contabilidad). Los lenguajes funcionales usan mónadas para convertir secuencias complicadas de funciones en canales sucintos que abstraen el [flujo de control](https://en.wikipedia.org/wiki/Control_flow "Flujo de control") y los [efectos secundarios](https://en.wikipedia.org/wiki/Side-effect_(computer_science) "Efecto secundario (informática)").(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-RealWorldHaskell-1)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Wadler1990-2)

Tanto el concepto de [[Monad]] como el término provienen originalmente de la [teoría de categorías](https://en.wikipedia.org/wiki/Category_theory "Teoría de categorías"), donde una [[Monad]] se define como un [functor](https://en.wikipedia.org/wiki/Functor "Functor") con estructura adicional.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-4) Las investigaciones que comenzaron a fines de la década de 1980 y principios de la de 1990 establecieron que las mónadas podían reunir problemas informáticos aparentemente dispares bajo un modelo funcional unificado. La teoría de categorías también proporciona algunos requisitos formales, conocidos como las **[leyes de la mónada](https://en.wikipedia.org/wiki/Monad_(functional_programming)#Definition)**, que cualquier mónada debería satisfacer y que se pueden utilizar para [verificar](https://en.wikipedia.org/wiki/Formal_verification "Verificación formal") código monádico.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Moggi1991-3)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Wadler1992-5)

Dado que las mónadas hacen que la [semántica](https://en.wikipedia.org/wiki/Semantics_(computer_science) "Semántica (informática)") sea explícita para un tipo de cálculo, también se pueden utilizar para Implementar características de lenguaje convenientes. Algunos lenguajes, como ``Haskell``, incluso ofrecen definiciones predefinidas en sus bibliotecas centrales para la estructura general de mónadas y las instancias comunes.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-RealWorldHaskell-1)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-GentleIntroHaskell-6)

## Descripción general

[[editar](https://en.wikipedia.org/w/index.php?title=Monad_(functional_programming)&action=edit&section=1 "Editar sección: Descripción general")]

"Para una [[Monad]] `m`, un valor de tipo `m a` representa tener acceso a un valor de tipo `a` dentro del contexto de la mónada". —C. A. McCann(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-so3322540-7)

Más exactamente, una [[Monad]] se puede utilizar cuando el acceso sin restricciones a un valor es inapropiado por razones específicas del escenario. En el caso de la [[Monad]] ``Maybe``, es porque el valor puede no existir. En el caso de la [[Monad]] IO, es porque el valor puede no ser conocido todavía, como cuando la [[Monad]] representa una entrada del usuario que solo se proporcionará después de que se muestre un mensaje. En todos los casos, los escenarios en los que el acceso tiene sentido se capturan mediante la operación de enlace definida para la mónada; para la [[Monad]] Maybe, un valor se enlaza solo si existe, y para la mónada IO, un valor se enlaza solo después de que se hayan realizado las operaciones anteriores en la secuencia.

Una mónada se puede crear definiendo un [constructor de tipo] (https://en.wikipedia.org/wiki/Type_constructor "Constructor de tipo") _M_ y dos operaciones:

- `return:: a -> M a` (a menudo también llamado _unit_), que recibe un valor de tipo `a` y lo envuelve en un _valor monádico_ de tipo `M a`, y
- `bind:: (M a) -> (a -> M b) -> (M b)` (normalmente representado como `>>=`), que recibe un valor ``monádico`` `M a` y una función `f` que acepta valores del tipo base `a`. Bind desenvuelve `a`, le aplica `f` y puede procesar el resultado de `f` como un valor ``monádico`` `M b`.

(En la sección posterior _[§ Derivación de functores](https://en.wikipedia.org/wiki/Monad_(functional_programming)#Derivation_from_functors)_ se puede encontrar una construcción alternativa pero [equivalente](https://en.wikipedia.org/wiki/Monad_(functional_programming)#muIsJoin) que utiliza la función `join` en lugar del operador `bind`.)

Con estos elementos, el programador compone una secuencia de llamadas de función (una "``tubería``") con varios operadores _bind_ encadenados en una expresión. Cada llamada de función transforma su valor de tipo simple de entrada, y el operador bind maneja el valor monádico devuelto, que se introduce en el siguiente paso de la secuencia.

Normalmente, el operador bind `>>=` puede contener código exclusivo de la mónada que realiza pasos de cálculo adicionales que no están disponibles en la función recibida como parámetro. Entre cada par de llamadas de función compuestas, el operador de enlace puede inyectar en el valor monádico `m a` alguna información adicional que no es accesible dentro de la función `f`, y pasarla a lo largo del proceso de ejecución. También puede ejercer un control más preciso del flujo de ejecución, por ejemplo, llamando a la función solo bajo ciertas condiciones, o ejecutando las llamadas de función en un orden particular.

### Un ejemplo: Maybe

[[edit](https://en.wikipedia.org/w/index.php?title=Monad_(functional_programming)&action=edit&section=2 "Edit section: An example: Maybe")]

Más información: [Tipo de opción](https://en.wikipedia.org/wiki/Option_type "Tipo de opción")

Ver también: [Mónada (teoría de categorías) § La mónada Maybe](https://en.wikipedia.org/wiki/Monad_(category_theory)#La_mónada_maybe "Mónada (teoría de categorías)")

Un ejemplo de mónada es el tipo `Maybe`. Los resultados nulos indefinidos son un problema particular que muchos lenguajes procedimentales no proporcionan herramientas específicas para tratar, requiriendo el uso del [patrón de objeto nulo](https://en.wikipedia.org/wiki/Null_object_pattern "Patrón de objeto nulo") o verificaciones para probar valores no válidos en cada operación para manejar valores indefinidos. Esto causa errores y hace que sea más difícil construir software robusto que maneje errores con elegancia. El tipo `Maybe` obliga al programador a lidiar con estos resultados potencialmente indefinidos definiendo explícitamente los dos estados de un resultado: `Just ⌑result⌑` o `Nothing`. Por ejemplo, el programador podría estar construyendo un analizador, que debe devolver un resultado intermedio, o bien señalar una condición que el analizador ha detectado y que el programador también debe manejar. Con solo un poco de condimento funcional adicional, este tipo `Maybe` se transforma en una mónada con todas las funciones.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-gHutton2ndMaybe-9): 12.3 páginas 148–151

En la mayoría de los lenguajes, la [[Monad]] Maybe también se conoce como un [tipo de opción](https://en.wikipedia.org/wiki/Option_type "Tipo de opción"), que es solo un tipo que marca si contiene o no un valor. Por lo general, se expresan como algún tipo de [tipo enumerado](https://en.wikipedia.org/wiki/Enumerated_type "Tipo enumerado"). En este ejemplo de [Rust](https://en.wikipedia.org/wiki/Rust_(programming_language) "Rust (lenguaje de programación)") lo llamaremos `Maybe<T>` y las variantes de este tipo pueden ser un valor de [tipo genérico](https://en.wikipedia.org/wiki/Generic_type "Tipo genérico") `T`, o la variante vacía: `Nothing`.
```rust
// The <T> represents a generic type "T"
enum Maybe<T> {
    Just(T),
    Nothing,
}
```

`Maybe<T>` también puede entenderse como un tipo "envolvente", y aquí es donde entra en juego su conexión con las mónadas. En lenguajes con alguna forma del tipo `Maybe`, hay funciones que ayudan en su uso, como componer **funciones monádicas** entre sí y probar si un `Maybe` contiene un valor.

En el siguiente ejemplo codificado de forma rígida, se utiliza un tipo `Maybe` como resultado de funciones que pueden fallar; en este caso, el tipo no devuelve nada si hay una [división por cero](https://en.wikipedia.org/wiki/Divide-by-zero "División por cero").
```rust
fn divide(x: Decimal, y: Decimal) -> Maybe<Decimal> {
    if y == 0 { return Nothing }
    else { return Just(x / y) }
}
// divide(1.0, 4.0) -> returns Just(0.25)
// divide(3.0, 0.0) -> returns Nothing
```
Una forma de comprobar si un ``Maybe`` contiene o no un valor es utilizar declaraciones ``if``.
```rust
let m_x = divide(3.14, 0.0); // ver la función de división anterior
// La declaración if extrae x de m_x si m_x es la variante Just de Maybe
if let Just(x) = m_x {
    println!("answer: ", x)
} else {
    println!("division failed, divide by zero error...")
}
```

Otros idiomas pueden tener coincidencia de patrones:
```c
let result = divide(3.0, 2.0);
match result {
    Just(x) => println!("Answer: ", x),
    Nothing => println!("division failed; we'll get 'em next time."),
}
```

Las [[Monad]] pueden componer funciones que devuelvan ``Maybe``, uniéndolas. Un ejemplo concreto podría ser una función que tome varios parámetros ``Maybe`` y devuelva un único ``Maybe`` cuyo valor sea ``Nothing`` cuando alguno de los parámetros sea ``Nothing``, como en el siguiente ejemplo:
```rust
fn chainable_division(maybe_x: Maybe<Decimal>, maybe_y: Maybe<Decimal>) -> Maybe<Decimal> {
    match (maybe_x, maybe_y) {
        (Just(x), Just(y)) => { //Si ambas entradas son Just, verifique la división por cero y divida en consecuencia
            if y == 0 { return Nothing }
            else { return Just(x / y) }
        },
        _ => return Nothing // De lo contrario no devuelve nada
    }
}
chainable_division(chainable_division(Just(2.0), Just(0.0)), Just(1.0)); // Dentro de chainable_division falla, fuera de chainable_division no devuelve nada
```

En lugar de repetir expresiones ``Just``, podemos usar algo llamado operador de enlace (también conocido como "``map``", "``flatmap``" o "``shove``"8: 2205s ). Esta operación toma una [[Monad]] y una función que devuelve una [[Monad]] y ejecuta la función en el valor interno de la [[Monad]] pasada, devolviendo la [[Monad]] desde la función.
```rust
// Ejemplo de Rust que utiliza ".map". maybe_x se pasa a través de dos funciones que devuelven Maybe<Decimal> y Maybe<String> respectivamente.
// Al igual que con la composición de funciones normal, las entradas y salidas de las funciones que se alimentan entre sí deben coincidir con los tipos encapsulados. (es decir, la función add_one debe devolver un Maybe<Decimal> que luego se puede descomponer en un Decimal para la función decimal_to_string)
let maybe_x: Maybe<Decimal> = Just(1.0)
let maybe_result = maybe_x.map(add_one).map(decimal_to_string)
```

En ``Haskell``, hay un operador ``bind``, o ``(>>=)`` que permite esta composición monádica en una forma más elegante similar a la composición de funciones.c: 150–151
```haskell
halve :: Int -> Maybe Int
halve x
  | even x = Just (x `div` 2)
  | odd x  = Nothing
 -- This code halves x twice. it evaluates to Nothing if x is not a multiple of 4
halve x >>= halve
```
Con ``>>=`` disponible, ``chainable_division`` se puede expresar de forma mucho más sucinta con la ayuda de funciones anónimas (es decir, ``lambdas``). Observe en la expresión a continuación cómo las dos ``lambdas anidadas`` operan cada una sobre el valor encapsulado en la mónada ``Maybe`` pasada usando el operador de enlace.d: 93
```haskell
chainable_division(mx,my) =   mx >>=  ( λx ->   my >>= (λy -> Just (x / y))   )
```
Lo que se ha demostrado hasta ahora es básicamente una mónada, pero para ser más concisos, a continuación se presenta una lista estricta de cualidades necesarias para una mónada, tal como se define en la siguiente sección.

**_Tipo monádico_**
Un tipo (`Maybe`)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-gHutton2ndMaybe-9): 148–151

**_Operación unitaria_**
Un conversor de tipos (`Just(x)`)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-gHutton2ndJust-12): 93

**_Operación de enlace_**
Un combinador para funciones monádicas ( `>>=` o `.flatMap()`)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-gHutton2ndBind-11): 150–151

Estas son las 3 cosas necesario para formar una mónada. Otras mónadas pueden incorporar procesos lógicos diferentes y algunas pueden tener propiedades adicionales, pero todas ellas tendrán estos tres componentes similares.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-RealWorldHaskell-1)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Spivey1990-13)

### Definición

[[editar](https://en.wikipedia.org/w/index.php?title=Monad_(functional_programming)&action=edit&section=3 "Editar sección: Definición")]

La definición más común de mónada en programación funcional, utilizada en el ejemplo anterior, se basa en realidad en una [triple de Kleisli](https://en.wikipedia.org/wiki/Kleisli_triple "Triple de Kleisli") ⟨T, η, μ⟩ en lugar de la definición estándar de la teoría de categorías. Sin embargo, las dos construcciones resultan ser matemáticamente equivalentes, por lo que cualquiera de las dos definiciones producirá una mónada válida. Dados tipos básicos bien definidos T, U, una mónada consta de tres partes:

- Un [constructor de tipos](https://en.wikipedia.org/wiki/Type_constructor "Constructor de tipos") M que construye un tipo monádico MT(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-14)
- Un [conversor de tipos](https://en.wikipedia.org/wiki/Type_conversion "Conversión de tipos"), a menudo llamado **unidad** o **retorno**, que incorpora un objeto x en la mónada:

`unidad: T → MT`(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-15)

- Un [combinador](https://en.wikipedia.org/wiki/Combinator "Combinador"), normalmente llamado **``bind``** (como en [vincular una variable](https://en.wikipedia.org/wiki/Bound_variable "Variable vinculada")) y representado con un [operador infijo](https://en.wikipedia.org/wiki/Infix_notation#Usage "Notación infija") `>>=` o un método llamado **``flatMap``**, que desenvuelve una variable monádica y luego la inserta en una función/expresión monádica, lo que da como resultado un nuevo valor monádico:

`(>>=) : (M T, T → M U) → M U`(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-bindIsaLift-16) así si `mx : M T` y `f : T → M U`, entonces `(mx >>= f) : M U`

Sin embargo, para calificar completamente como una mónada, estas tres partes también deben respetar algunas leyes:

- ``unit`` es una [identidad izquierda](https://en.wikipedia.org/wiki/Identity_element "Elemento de identidad") para ``bind``:

`unit(x) >>= f` **↔** `f(x)`

- ``unit`` también es una identidad derecha para ``bind````:``

`ma >>= unit` **↔** `ma`

- ``bind`` es esencialmente [asociativo](https://en.wikipedia.org/wiki/Associative "Asociativo"):(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-18)

`ma >>= λx → (f(x) >>= g)` **↔** `(ma >>= f) >>= g`(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-RealWorldHaskell-1)

Algebraicamente, esto significa que cualquier mónada da lugar a una categoría (llamada la [categoría de Kleisli](https://en.wikipedia.org/wiki/Kleisli_category "Categoría de Kleisli")) _y_ a [monoide](https://en.wikipedia.org/wiki/Monoid "Monoide") en la categoría de ``funtores`` (desde valores hasta cálculos), con composición monádica como operador binario en la monoide(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Beckerman-10): 2450s  y unidad como identidad en la mónada.

### Uso

[[editar](https://en.wikipedia.org/w/index.php?title=Monad_(functional_programming)&action=edit&section=4 "Editar sección: Uso")]

El valor del patrón mónada va más allá de simplemente condensar el código y proporcionar un vínculo al razonamiento matemático. Cualquiera sea el lenguaje o el [paradigma de programación](https://en.wikipedia.org/wiki/Programming_paradigm "Paradigma de programación") predeterminado que use un desarrollador, seguir el patrón mónada aporta muchos de los beneficios de la [programación puramente funcional](https://en.wikipedia.org/wiki/Purely_functional_programming "Programación puramente funcional"). Al [reificar](https://en.wikipedia.org/wiki/Reification_(computer_science) "Reificación (informática)") un tipo específico de computación, una mónada no solo [encapsula](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming) "Encapsulación (programación informática)") los tediosos detalles de ese patrón computacional, sino que lo hace de manera [declarativa](https://en.wikipedia.org/wiki/Declarative_programming "Programación declarativa"), mejorando la claridad del código. Como los valores monádicos representan explícitamente no solo valores calculados, sino también _efectos_ calculados, una expresión monádica se puede reemplazar con su valor en posiciones [transparentes referencialmente](https://en.wikipedia.org/wiki/Referential_transparency "Transparencia referencial"), de manera muy similar a las expresiones puras, lo que permite muchas técnicas y optimizaciones basadas en la [reescritura](https://en.wikipedia.org/wiki/Rewriting "Reescritura").(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Wadler1992-5)

Normalmente, los programadores usarán ``bind`` para encadenar funciones monádicas en una secuencia, lo que ha llevado a algunos a describir las mónadas como "punto y coma programables", una referencia a cuántos lenguajes [imperativos](https://en.wikipedia.org/wiki/Imperative_programming "Programación imperativa") usan punto y coma para separar [declaraciones](https://en.wikipedia.org/wiki/Statement_(computer_programming) "Declaración (programación informática)").(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-RealWorldHaskell-1)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-GentleIntroHaskell-6) Sin embargo, las mónadas en realidad no ordenan los cálculos; incluso en lenguajes que las usan como características centrales, una composición de funciones más simple puede organizar los pasos dentro de un programa. La utilidad general de una mónada radica más bien en simplificar la estructura de un programa y mejorar la [separación de preocupaciones](https://en.wikipedia.org/wiki/Separation_of_concerns "Separación de preocupaciones") a través de la abstracción.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Wadler1992-5)(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-MonadsAreNot-19)

La estructura de la mónada también puede verse como una variación exclusivamente matemática y de [tiempo de compilación](https://en.wikipedia.org/wiki/Compile_time "Tiempo de compilación") del [patrón decorador](https://en.wikipedia.org/wiki/Decorator_pattern "Patrón decorador"). Algunas mónadas pueden pasar datos adicionales que son inaccesibles para las funciones, y algunas incluso ejercen un control más preciso sobre la ejecución, por ejemplo, llamando a una función solo bajo ciertas condiciones. Debido a que permiten a los programadores de aplicaciones implementar [lógica de dominio](https://en.wikipedia.org/wiki/Domain_logic "Lógica de dominio") mientras descargan código repetitivo en módulos desarrollados previamente, las mónadas pueden incluso considerarse una herramienta para la [programación orientada a aspectos](https://en.wikipedia.org/wiki/Aspect-oriented_programming "Programación orientada a aspectos").(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-deMeuter1997-20)

Otro uso notable de las mónadas es aislar efectos secundarios, como [entrada/salida](https://en.wikipedia.org/wiki/Input/output "Entrada/salida") o [estado](https://en.wikipedia.org/wiki/State_(computer_science) "Estado (informática)") mutable, en código que de otro modo sería puramente funcional. Incluso los lenguajes puramente funcionales _pueden_ todavía implementar estos cálculos "impuros" sin mónadas, a través de una intrincada mezcla de composición de funciones y [estilo de paso de continuación](https://en.wikipedia.org/wiki/Continuation-passing_style "Estilo de paso de continuación") (CPS) en particular.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Wadler1990-2) Sin embargo, con las mónadas, gran parte de este andamiaje se puede abstraer, esencialmente tomando cada patrón recurrente en el código CPS y agrupándolo en una mónada distinta.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-Wadler1992-5)

Si un lenguaje no admite mónadas de forma predeterminada, aún es posible implementar el patrón, a menudo sin mucha dificultad. Cuando se traduce de la teoría de categorías a términos de programación, la estructura de la mónada es un [concepto genérico](https://en.wikipedia.org/wiki/Concept_(generic_programming) "Concepto (programación genérica)") y se puede definir directamente en cualquier lenguaje que admita una característica equivalente para el [polimorfismo acotado](https://en.wikipedia.org/wiki/Polimorfismo_paramétrico#Polimorfismo_paramétrico_limitado "Polimorfismo paramétrico"). La capacidad de un concepto de permanecer agnóstico respecto de los detalles operativos mientras trabaja con los tipos subyacentes es poderosa, pero las características únicas y el comportamiento estricto de las mónadas las distinguen de otros conceptos.(https://en.wikipedia.org/wiki/Monad_(functional_programming)#cite_note-MonadSansMetaphors-21)