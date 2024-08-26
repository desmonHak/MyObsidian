[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/clrcall?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/clrcall?view=msvc-170)

Especifica que solo se puede llamar a una función desde código administrado. Utilice **__clrcall** para todas las funciones virtuales a las que solo se llamará desde código administrado. Sin embargo esta convención de llamada no se puede utilizar para las funciones a las que llamará desde código nativo. El modificador **__clrcall** es específico de Microsoft.

Utilice **__clrcall** para mejorar el rendimiento cuando se llame desde una función administrada a una función administrada virtual o desde una función administrada a una función administrada mediante puntero.

Los puntos de entrada son funciones independientes generadas por el compilador. Si una función tiene puntos de entrada nativos y administrados, uno de ellos será la función real con la implementación de la función. La otra función será una función independiente (un código thunk) que llama a la función real y deja que Common Language Runtime realice PInvoke. Cuando se marca una función como **__clrcall**, se indica que la implementación de la función debe ser MSIL y que la función de punto de entrada nativo no se generará.

Cuando se toma la dirección de una función nativa si no se especifica **__clrcall**, el compilador usa el punto de entrada nativo. **__clrcall** indica que la función es una función administrada y no es necesario realizar la transición de administrada a nativa. En ese caso, el compilador usa el punto de entrada administrado.