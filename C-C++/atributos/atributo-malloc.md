`malloc`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-malloc-function-attribute)
`malloc (deallocator)`
`malloc (deallocator, ptr-index)`

El atributo `malloc` indica que una función es similar a `malloc`, es decir, que el ``puntero P`` devuelto por la función no puede ser alias de ningún otro puntero válido cuando la función retorna, y además no hay punteros a objetos válidos en ningún almacenamiento direccionado por ``P``. Además, GCC predice que una función con el atributo retorna un valor distinto de nulo en la mayoría de los casos.

Independientemente, la forma del atributo con uno o dos argumentos asocia a `deallocator` como una función de desasignación adecuada para punteros devueltos desde la función similar a `malloc`. ``ptr-index`` indica el argumento posicional al que, cuando se pasa el puntero en llamadas a `deallocator`, tiene el efecto de desasignarlo.

El uso del atributo sin argumentos está diseñado para mejorar la optimización al confiar en la propiedad de alias que implica. Las funciones como `malloc` y `calloc` tienen esta propiedad porque devuelven un puntero a un almacenamiento recién obtenido, no inicializado o puesto a cero. Sin embargo, funciones como `realloc` no tienen esta propiedad, ya que pueden devolver punteros a un almacenamiento que contiene punteros a objetos existentes. Además, dado que se supone que todas estas funciones devuelven null solo con poca frecuencia, los llamadores se pueden optimizar en función de esa suposición.

Asociar una función con un ``deallocator`` ayuda a detectar llamadas a funciones de asignación y desasignación no coincidentes y a diagnosticarlas bajo el control de opciones como ``-Wmismatched-dealloc``. También permite diagnosticar intentos de desasignar objetos que no fueron asignados dinámicamente, mediante ``-Wfree-nonheap-object``. Para indicar que una función de asignación satisface la propiedad de ``no aliasing`` y tiene un desasignador asociado, se deben utilizar tanto la forma simple del atributo como la que tiene el argumento de desasignador. La misma función puede ser tanto un asignador como un desasignador. Dado que la inclusión en línea de una de las funciones asociadas pero no de la otra podría dar lugar a desajustes aparentes, esta forma del atributo `malloc` no se acepta en funciones en línea. Por la misma razón, el uso del atributo evita que tanto las funciones de asignación como de desasignación se expandan en línea.

Por ejemplo, además de indicar que las funciones devuelven punteros que no son alias de otros, las siguientes declaraciones hacen que `fclose` sea un desasignador adecuado para los punteros devueltos desde todas las funciones excepto `popen`, y que `pclose` sea el único desasignador adecuado para los punteros devueltos desde `popen`. Las funciones de desasignador deben declararse antes de que se pueda hacer referencia a ellas en el atributo.
```c
int fclose (FILE*);
int pclose (FILE*);

__attribute__ ((malloc, malloc (fclose, 1)))
  FILE* fdopen (int, const char*);
  
__attribute__ ((malloc, malloc (fclose, 1)))
  FILE* fopen (const char*, const char*);
  
__attribute__ ((malloc, malloc (fclose, 1)))
  FILE* fmemopen(void *, size_t, const char *);
  
__attribute__ ((malloc, malloc (pclose, 1)))
  FILE* popen (const char*, const char*);
  
__attribute__ ((malloc, malloc (fclose, 1)))
  FILE* tmpfile (void);
```

Las advertencias guardadas por ``-fanalyzer`` respetan los pares de asignación y desasignación marcados con `malloc`. En particular:

- El analizador emite un diagnóstico ``-Wanalyzer-mismatching-deallocation`` si hay una ruta de ejecución en la que el resultado de una llamada de asignación se pasa a un desasignador diferente.
- El analizador emite un diagnóstico ``-Wanalyzer-double-free`` si hay una ruta de ejecución en la que un valor se pasa más de una vez a una llamada de desasignación.
- El analizador considera la posibilidad de que una función de asignación pueda fallar y devolver un valor nulo. Si hay rutas de ejecución en las que un resultado no verificado de una llamada de asignación se desreferencia o se pasa a una función que requiere un argumento no nulo, emite los diagnósticos ``-Wanalyzer-possible-null-dereference`` y ``-Wanalyzer-possible-null-argument``. Si el asignador siempre devuelve un valor distinto de nulo, utilice `__attribute__ ((returns_nonnull))` para suprimir estas advertencias. Por ejemplo:
```c
char *xstrdup (const char *)
  __attribute__((malloc (free), returns_nonnull));
```
El analizador emite un diagnóstico ``-Wanalyzer-use-after-free`` si hay una ruta de ejecución en la que la memoria pasada por puntero a una llamada de desasignación se utiliza después de la desasignación.
El analizador emite un diagnóstico ``-Wanalyzer-malloc-leak`` si hay una ruta de ejecución en la que se filtra el resultado de una llamada de asignación (sin pasarse a la función de desasignación).
El analizador emite un diagnóstico ``-Wanalyzer-free-of-non-heap`` si se utiliza una función de desasignación en una variable global o en la pila.
El analizador supone que los desasignadores pueden manejar correctamente el puntero nulo. Si este no es el caso, el desasignador se puede marcar con ``__attribute__((nonnull))`` para que ``-fanalyzer`` pueda emitir un diagnóstico ``-Wanalyzer-possible-null-argument`` para las rutas de código en las que se llama al desasignador con un valor nulo.


El atributo `malloc` en ``GCC (GNU Compiler Collection)`` se utiliza para indicar que una función se comporta de manera similar a la función `malloc`. Este atributo tiene varias funciones y formas, las cuales explico a continuación:

### 1. **Comportamiento tipo `malloc`**:

- El atributo indica que la función devuelve un puntero `P` que no puede alias con ningún otro puntero que sea válido en el momento en que la función retorna. Es decir, el puntero que retorna la función es único y no comparte memoria con otros punteros existentes.
- Además, se asume que las funciones marcadas con este atributo generalmente no devuelven `null`, lo que permite optimizaciones en el código generado, basándose en la suposición de que la función casi siempre tendrá éxito.

### 2. **Asociación con una función de desasignación (deallocator)**:

- Cuando el atributo se utiliza con uno o dos argumentos, el primer argumento (`deallocator`) indica qué función es adecuada para liberar el puntero devuelto por la función tipo `malloc`.
- El segundo argumento (`ptr-index`) es opcional y denota la posición del argumento en la llamada a la función `deallocator` que libera la memoria asignada.

```c
__attribute__ ((malloc, malloc (fclose, 1))) FILE* fopen(const char*, const char*);
```

Aquí, `fclose` es la función de desasignación adecuada para los punteros devueltos por `fopen`, y el índice `1` indica que el puntero que se debe liberar es el primer argumento en `fclose`.

### 3. **Optimización y Diagnóstico**:

- Usar este atributo sin argumentos puede mejorar la optimización del código debido a las propiedades de aliasing que implica.
- Asociar una función con un `deallocator` adecuado ayuda a detectar y diagnosticar posibles errores, como:
    - Uso de funciones de desasignación no coincidentes.
    - Intentos de liberar memoria que no fue asignada dinámicamente.
    - Uso de memoria después de haber sido liberada.
    - Fugas de memoria por no haber liberado la memoria asignada.

### 4. **Restricciones**:

- No se puede usar este atributo en funciones `inline` porque podría resultar en inconsistencias si una función de asignación se expande `inline` y la de desasignación no.

En resumen, el atributo `malloc` se utiliza para indicar que una función asigna memoria de una manera que no causa aliasing con otras direcciones de memoria válidas y para asociar esa asignación con una función específica de desasignación. Esto ayuda tanto en la optimización del código como en la detección de errores relacionados con la gestión de la memoria.

Ejemplo:
```c
#include <stdlib.h>
#include <stdio.h>

// Función de desasignación (deallocator)
void custom_free(void* ptr) {
    free(ptr);
    printf("Memoria liberada.\n");
}

// Función de asignación de memoria con el atributo malloc
__attribute__((malloc, malloc(custom_free, 1)))
void* custom_malloc(size_t size) {
    void* ptr = malloc(size);
    if (ptr) {
        printf("Memoria asignada de %zu bytes.\n", size);
    }
    return ptr;
}

int main() {
    // Uso de la función custom_malloc
    int* numbers = (int*)custom_malloc(10 * sizeof(int));
    
    if (numbers != NULL) {
        // Uso del array numbers
        for (int i = 0; i < 10; i++) {
            numbers[i] = i;
            printf("%d ", numbers[i]);
        }
        printf("\n");
        
        // Liberación de la memoria con custom_free
        custom_free(numbers);
    }

    return 0;
}

```
1. **Función `custom_malloc`**:
    - Esta función asigna memoria usando `malloc`.
    - Se le ha aplicado el atributo `malloc` con `custom_free` como la función de desasignación adecuada. El `1` indica que el puntero que debe liberarse está en el primer (y único) argumento de `custom_free`.
    
1. **Función `custom_free`**:
    - Esta función es responsable de liberar la memoria asignada y se asegura de que la memoria asignada por `custom_malloc` sea correctamente liberada.
    
1. **Uso en `main`**:
    - Se llama a `custom_malloc` para asignar memoria para un array de 10 enteros.
    - Luego, se usa el array para almacenar valores y, al finalizar, se libera la memoria con `custom_free`.

### ¿Por qué usar el atributo `malloc` aquí?

- Al aplicar el atributo `malloc`, el compilador puede optimizar mejor el uso de la memoria y diagnosticar posibles errores, como el uso de una función de desasignación incorrecta o intentar liberar memoria que no fue asignada dinámicamente.

Este ejemplo muestra cómo se puede crear una función personalizada para manejar la asignación y desasignación de memoria de manera segura y eficiente, aprovechando el atributo `malloc` de GCC.