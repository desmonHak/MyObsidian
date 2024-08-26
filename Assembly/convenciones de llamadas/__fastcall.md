[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/fastcall?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/fastcall?view=msvc-170)

**Específicos de Microsoft**
La convención de llamada **`__fastcall`** especifica que los argumentos de las funciones deben pasarse en registros siempre que sea posible. Esta convención de llamada solo se aplica a la arquitectura x86. En la lista siguiente se muestra la implementación de esta convención de llamada.

|Elemento|Implementación|
|---|---|
|Orden de paso de argumento|Los dos `DWORD` primeros o más pequeños argumentos que se encuentran en la lista de argumentos de izquierda a derecha se pasan en los registros ECX y EDX; todos los demás argumentos se pasan en la pila de derecha a izquierda.|
|Responsabilidad de mantenimiento de pila|Al llamar a la función aparece el argumento de la pila.|
|Convención de creación de nombres representativos|Al signo (@) se le asigna el prefijo a los nombres; un signo seguido del número de bytes (en decimal) de la lista de parámetros se sufijo a los nombres.|
|Convención de traducción de mayúsculas y minúsculas|No se lleva a cabo una traducción de mayúsculas y minúsculas.|
|Clases, estructuras y uniones|Se trata como tipos "multibyte" (independientemente del tamaño) y pasados en la pila.|
|Enumeraciones y clases de enumeración|Pasado por registro si el registro pasa su tipo subyacente. Por ejemplo, si el tipo subyacente es `int` o `unsigned int` de tamaño 8, 16 o 32 bits.|
Los compiladores dirigidos a las arquitecturas ARM y x64 aceptan y omiten la palabra clave **`__fastcall`**; en un chip x64, por convención, los primeros cuatro argumentos se pasan en registros cuando sea posible y los argumentos adicionales se pasan en la pila. Para obtener más información, vea [Convención de llamadas x64](https://learn.microsoft.com/es-es/cpp/build/x64-calling-convention?view=msvc-170). En un chip ARM, se puede pasar hasta cuatro argumentos enteros y ocho argumentos de punto flotante en los registros; los argumentos adicionales se pasan en la pila.