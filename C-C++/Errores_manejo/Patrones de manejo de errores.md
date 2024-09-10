# [Error handling patterns](https://andreabergia.com/blog/2023/05/error-handling-patterns/)

El manejo de errores es un aspecto fundamental de la programación. A menos que estés escribiendo "hola mundo", necesitarás manejar errores en tu código. En esta publicación, analizaré un poco los enfoques más comunes utilizados por varios lenguajes de programación.

## Códigos de error de retorno [](https://andreabergia.com/blog/2023/05/error-handling-patterns/#return-error-codes)

Esta es una de las estrategias más antiguas: si una función puede fallar, simplemente puede devolver un código de error, a menudo un número negativo o "``null``". Esto es extremadamente común en C, por ejemplo:
```c
FILE* fp = fopen("file.txt" , "w");
if (!fp) {
  // some error occurred
}
```

Este enfoque es muy simple, tanto para implementar como para comprender. También es extremadamente eficiente para ejecutar, ya que solo implica una llamada de función estándar, con un valor de retorno - no se necesita soporte en tiempo de ejecución ni asignaciones. Sin embargo, tiene algunas desventajas:

- es fácil para los usuarios de las funciones olvidarse del manejo de errores. Por ejemplo, `printf` en C _puede_ fallar, ¡pero no he visto muchos programas que verifiquen su código de retorno!
- es molesto propagar errores a lo largo de la pila de llamadas, especialmente si su código tiene que manejar múltiples fallas diferentes (abrir un archivo, escribir en él, leer de otro...)
- a menos que su lenguaje de programación admita múltiples valores de retorno, es molesto si tiene que devolver un valor válido _o_ un error. Esto lleva a que muchas funciones en C y C++ tengan que pasar el almacenamiento para el valor de retorno de "éxito" como un puntero que será llenado por la función, haciendo algo como:

```c
my_struct *success_result;
int error_code = my_function(&success_result);
if (!error_code) {
  // puede utilizar success_result
}
```

[Go](https://go.dev/) ha elegido este enfoque para su manejo de errores. Sin embargo, dado que ``Go`` permite múltiples valores de retorno de una función, este patrón se vuelve un poco más ergonómico y muy común:

```go
user, err = FindUser(username)
if err != nil {
    return err
}
```

La variante ``Go`` del patrón es simple, efectiva y permite la propagación de errores al autor de la llamada. Por otro lado, siento que es bastante repetitiva y distrae un poco de la lógica empresarial real. ¡Sin embargo, no he escrito suficiente ``Go`` como para saber si esa impresión desaparece después de un tiempo! 😅

## Excepciones [](https://andreabergia.com/blog/2023/05/patrones-de-manejo-de-errores/#exceptions)
Las excepciones son probablemente el patrón de manejo de errores más utilizado. El enfoque `try/catch/finally` funciona bastante bien y es bastante sencillo de usar. Las excepciones se volvieron extremadamente populares durante los años 90 y 2000 y han sido adoptadas por muchos lenguajes como ``Java``, ``C#`` o ``Python``.

En comparación con los códigos de error, las excepciones tienen algunas ventajas:

- conducen naturalmente a una separación entre el "camino feliz" y el camino de manejo de errores
- se expandirán automáticamente a través de la pila de llamadas
- ¡y no puedes olvidarte de manejar los errores!

Sin embargo, también tienen algunas desventajas: requieren un soporte específico en tiempo de ejecución y generalmente suponen una sobrecarga de rendimiento considerable. Además, y mucho más importante, tienen un efecto de “largo alcance”: una excepción podría ser lanzada por algún código y detectada por un controlador de excepciones muy alejado en la pila de llamadas, lo que perjudica la claridad.

Además, no es obvio si una función lanzará alguna excepción con solo mirar su firma.

C++ intentó solucionar este problema con la causa `throws`, que se usó tan poco que terminó siendo [obsoleta en C++17](https://en.cppreference.com/w/cpp/language/except_spec) y eliminada en ``C++20``. Desde entonces, intentó introducir [`noexcept`](https://en.cppreference.com/w/cpp/language/noexcept_spec), pero no he escrito suficiente C++ moderno como para saber lo popular que es.

``Java`` intentó usar ["excepciones comprobadas"](https://www.baeldung.com/java-checked-unchecked-exceptions), es decir, excepciones que _tenías_ que declarar como parte de la firma, pero ese enfoque se consideró un fracaso tal que los marcos modernos como ``Spring`` solo usan "excepciones en tiempo de ejecución", y los lenguajes ``JVM`` como ``Kotlin`` [se deshicieron del concepto](https://kotlinlang.org/docs/exceptions.html#the-nothing-type) por completo. Al final, no hay una buena manera de saber si una llamada a un método arrojará o no una excepción, y por lo tanto terminas con un poco de lío.

## Devoluciones de llamadas de error [](https://andreabergia.com/blog/2023/05/error-handling-patterns/#error-callbacks)

Otro enfoque, muy común en el mundo de ``JavaScript``, es utilizar [devoluciones de llamadas](https://kotlinlang.org/docs/exceptions.html#the-nothing-type) que se invocarán cuando una función tenga éxito o falle. Esto a menudo se combina con la programación ``asincrónica``, donde la ``E/S`` se realiza en segundo plano sin bloquear el flujo de ejecución.

Por ejemplo, es bastante común que las funciones de ``E/S`` de ``Node``.JS acepten una devolución de llamada con dos argumentos `(error, resultado)`, por ejemplo:

```javascript
const fs = require('fs');
fs.readFile('some_file.txt', (err, result) => {
  if (err) {
    console.error(err);
    return;
  }

  console.log(result);
});
```

Sin embargo, este enfoque a menudo conduce al llamado problema del [[Callback Hell]] [“infierno de las devoluciones de llamadas”](http://callbackhell.com/), ya que una devolución de llamada podría necesitar invocar más `E/S` `asincrónicas`, lo que a su vez necesita más devoluciones de llamadas, etc., terminando con un código desordenado y difícil de seguir.

Las versiones modernas de ``JavaScript`` han intentado hacer que el código sea más legible introduciendo [_promesas_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise):

```javascript
fetch("https://example.com/profile", {
      method: "POST", // or 'PUT'
})
  .then(response => response.json())
  .then(data => data['some_key'])
  .catch(error => console.error("Error:", error));
```

El paso final en el patrón de promesas ha sido la adopción por parte de JavaScript del patrón `async/await`, popularizado [por C#](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/async-scenarios), que hace que la ``E/S asincrónica`` termine pareciéndose bastante al código sincrónico con excepciones clásicas:

```javascript
async function fetchData() {
  try {
    const response = await fetch("my-url");
    if (!response.ok) {
      throw new Error("Network response was not OK");
    }
    return response.json()['some_property'];
  } catch (error) {
    console.error("There has been a problem with your fetch operation:", error);
  }
}
```

El uso de devoluciones de llamadas [[callbacks]] para el manejo de errores es un patrón importante que se debe conocer, no solo en ``JavaScript`` (la gente lo ha estado usando en C durante años, por ejemplo). Sin embargo, ya no es muy común: es probable que estés usando alguna forma de `async/await`.
## Resultado de lenguajes funcionales [](https://andreabergia.com/blog/2023/05/error-handling-patterns/#result-from-functional-languages)

El último patrón que quiero comentar tiene su origen en lenguajes funcionales, como [Haskell](https://hackage.haskell.org/package/base-4.18.0.0/docs/Data-Either.html), pero se ha vuelto un poco más común dada la explosión de popularidad de [Rust](https://andreabergia.com/blog/2022/11/languages-opinion-part-two-rust/).

La idea es tener un tipo `Result` como:

```rust
enum Result<S, E> {
  Ok(S),
  Err(E)
}
```

Este es un tipo que tiene dos variantes: una expresa éxito y la otra, un fracaso. Una función que devuelve un resultado devolverá la variante `Ok`, opcionalmente con algunos datos, o la variante `Err` con algunos detalles del error. El llamador de la función normalmente utilizará la coincidencia de patrones para manejar ambos casos.

Para hacer que los errores aparezcan en la pila de llamadas, normalmente escribirías un código como este:

```rust
let result = match my_fallible_function() {
  Err(e) => return Err(e),
  Ok(some_data) => some_data,
};
```

Este patrón es tan común que ``Rust`` introdujo un _operador_ completo en el lenguaje (el signo de interrogación `?`) para simplificar el código anterior:

```rust
let result = my_fallible_function()?;   // Notice the "?"
```

La ventaja de este enfoque es que hace que el manejo de errores sea explícito y seguro en cuanto a tipos, ya que el compilador garantiza que se manejen todos los resultados posibles.

En los lenguajes que lo admiten, `Result` es típicamente [Monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)), lo que permite componer funciones que pueden fallar sin tener que usar bloques ``try/catch`` o declaraciones ``if`` anidadas.
En los lenguajes que lo admiten, `Result` es típicamente [Monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)) [[Monad]], lo que permite componer funciones que pueden fallar sin tener que usar bloques ``try/catch`` o declaraciones if anidadas.

# Conclusiones [](https://andreabergia.com/blog/2023/05/patrones-de-manejo-de-errores/#conclusiones)

Dependiendo del lenguaje de programación que uses y de tu proyecto, terminarás usando mayoritariamente o exclusivamente uno de estos patrones.

Sin embargo, yo diría que el patrón `Result` es mi favorito. Por supuesto, su adopción no se limita a los lenguajes funcionales; por ejemplo, en mi empleador [lastminute.com](https://lastminute.com/) usamos la biblioteca [Arrow](https://arrow-kt.io/) en ``Kotlin``, que contiene un tipo `Either` muy inspirado en ``Haskell``. Planeo escribir una publicación al respecto, así que gracias por leer esto y estad atentos 😊.