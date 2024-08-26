[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/vectorcall?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/vectorcall?view=msvc-170)
 [https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)
 
**Específicos de Microsoft**

La convención de llamada **`__vectorcall`** especifica que los argumentos de las funciones deben pasarse en registros siempre que sea posible. **`__vectorcall`** usa más registros para argumentos que [`__fastcall`](https://learn.microsoft.com/es-es/cpp/cpp/fastcall?view=msvc-170) o al usar de forma predeterminada la [convención de llamada x64](https://learn.microsoft.com/es-es/cpp/build/x64-calling-convention?view=msvc-170). La convención de llamada **`__vectorcall`** solo se admite en código nativo en procesadores x86 y x64 que incluyen Extensiones SIMD de streaming 2 (SSE2) y versiones posteriores. Use **`__vectorcall`** para acelerar funciones que pasan varios argumentos de punto flotante o argumentos vectoriales SIMD y llevan a cabo operaciones en las que se usan los argumentos cargados en registros. En la lista siguiente se muestran las características en común con las implementaciones x86 y x64 de **`__vectorcall`**. Las diferencias se explican más adelante en este artículo.

| Elemento                                               | Implementación                                                                                                                  |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- |
| Convención de creación de nombres representativos de C | Los nombres de función se sufijon con dos signos "at" (@@) seguidos del número de bytes (en decimal) de la lista de parámetros. |
| Convención de traducción de mayúsculas y minúsculas    | No se lleva a cabo la traducción de mayúsculas y minúsculas.                                                                    |
Puede pasar tres tipos de argumentos por registro en las funciones **`__vectorcall`**: valores de _tipo entero_, valores de _tipo vectorial_ y valores de _agregado vectorial homogéneo_ (HVA).

Un tipo entero cumple dos requisitos: se ajusta al tamaño de registro nativo del procesador (por ejemplo, 4 bytes en una máquina x86 o 8 bytes en una máquina x64) y se puede convertir en un entero de longitud de registro y de nuevo sin cambiar su representación de bits. Por ejemplo, es un tipo entero cualquier tipo que se pueda promover a **`int`** en x86 (**`long long`** en x64) —por ejemplo, **`char`** o **`short`**—o que se pueda convertir a **`int`** (**`long long`** en x64) y de nuevo a su tipo original sin cambios. Los tipos de enteros son puntero, referencia y los tipos **`struct`** o **`union`** de 4 bytes (8 bytes en x64) o menos. En las plataformas x64, los tipos **`struct`** y **`union`** mayores se pasan por referencia a la memoria asignada por el autor de llamada; en las plataformas x86, se pasan por valor en la pila.

Un tipo vectorial es un tipo de punto flotante (por ejemplo, **`float`** o **`double`**) o un tipo de vector SIMD (por ejemplo, **`__m128`** o **`__m256`**).

Un tipo HVA es un tipo compuesto de hasta cuatro miembros de datos que tienen tipos vectoriales idénticos. Un tipo HVA tiene el mismo requisito de alineación que el tipo vectorial de sus miembros. Este es un ejemplo de una definición **`struct`** HVA que contiene tres tipos de vector idénticos y tiene una alineación de 32 bytes:
```c
typedef struct {
   __m256 x;
   __m256 y;
   __m256 z;
} hva3;    // 3 element HVA type on __m256
```

Declare las funciones explícitamente con la palabra clave **`__vectorcall`** en archivos de encabezado para que el código compilado por separado se enlace sin errores. Las funciones deben crear prototipos para usar **`__vectorcall`** y no pueden usar una `vararg` lista de argumentos de longitud variable.

Una función miembro se puede declarar con el especificador **`__vectorcall`**. El registro pasa el puntero **`this`** oculto como el primer argumento de tipo entero.

En equipos ARM, el compilador acepta y omite **`__vectorcall`**. En el caso de ARM64EC, el compilador no admite y rechaza **`__vectorcall`**.

En ``Visual Studio 2013``, Microsoft introdujo la convención de llamadas \_\_vectorcall en respuesta a las preocupaciones de eficiencia de los desarrolladores de juegos, gráficos, vídeo/audio y códecs. El esquema permite que los tipos vectoriales más grandes (``float``, ``double``, ``__m128``, ``__m256``) se pasen en registros en lugar de en la pila[10].

Para código ``IA-32`` y ``x64``, ``__vectorcall`` es similar a [[__fastcall]] y a las convenciones de llamada originales de ``x64`` respectivamente, pero las extiende para soportar el paso de argumentos vectoriales usando registros ``SIMD``. En ``IA-32,`` los valores enteros se pasan como es habitual, y los seis primeros registros ``SIMD`` (``XMM``/``YMM0-5``) contienen hasta seis valores de coma flotante, vectoriales o ``HVA`` secuencialmente de izquierda a derecha, sin tener en cuenta las posiciones reales causadas, por ejemplo, por un argumento ``int`` que aparezca entre ellos. En ``x64``, sin embargo, se sigue aplicando la regla de la convención original de ``x64``, de modo que ``XMM``/``YMM0-5`` sólo contienen argumentos de coma flotante, vectoriales o ``HVA`` cuando resultan ser del primero al sexto[11].

``__vectorcall`` añade soporte para pasar valores de agregados vectoriales homogéneos (``HVA``), que son tipos compuestos (``structs``) formados únicamente por hasta cuatro tipos vectoriales idénticos, utilizando los mismos seis registros. Una vez asignados los registros para los argumentos de tipo vectorial, los registros no utilizados se asignan a los argumentos ``HVA`` de izquierda a derecha. Se siguen aplicando las reglas de posicionamiento. Los valores de tipo vectorial y ``HVA`` resultantes se devuelven utilizando los cuatro primeros registros ``XMM``/``YMM``[11].

El compilador ``Clang`` y el compilador ``Intel C++`` también implementan ``vectorcall``.[12] ICC tiene una convención anterior similar llamada [[__regcall]];[13] también está soportada por ``Clang``.[14]