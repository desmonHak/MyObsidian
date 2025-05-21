Ejemplo más completo que ilustra un sistema de plugins en C usando carga dinámica (con dlopen/dlsym) combinado con inicialización perezosa ("lazy initialization"). En este ejemplo, el programa principal no vincula de forma estática la función de un “plugin” (una biblioteca compartida) sino que, en la primera llamada, la carga y resuelve; las llamadas siguientes usan directamente el puntero actualizado.

### 1. Código del plugin (plugin.c)

Este archivo se compila como una biblioteca compartida (por ejemplo, libplugin.so):
````c
// plugin.h
#ifndef PLUGIN_H
#define PLUGIN_H

// Declaramos el tipo de la función que procesará la cadena.
typedef char* (*process_func_t)(const char* input);

#endif // PLUGIN_H
````

```c
// plugin.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "plugin.h"

// Función que invierte la cadena y la convierte a mayúsculas.
char* process_string(const char* input) {
    size_t len = strlen(input);
    char* result = malloc(len + 1);
    if (!result) return NULL;
    for (size_t i = 0; i < len; i++) {
        // Toma el carácter desde el final y lo convierte a mayúscula.
        result[i] = toupper(input[len - i - 1]);
    }
    result[len] = '\0';
    return result;
}

```

Para compilar el plugin en Linux:
```bash
gcc -shared -fPIC -o libplugin.so plugin.c
```

### 2. Código del programa principal (main.c)
El programa principal define un puntero global a la función del plugin, inicialmente nulo. La primera vez que se necesite, se llama a una función de "lazy initialization" que carga la biblioteca y resuelve la dirección de `process_string`. Luego, el puntero se actualiza para llamadas futuras.
```c
// main.c
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#include "plugin.h"

// Puntero global a la función del plugin; inicialmente es NULL.
process_func_t process_string_ptr = NULL;

// Función de inicialización perezosa: carga la biblioteca y resuelve el símbolo.
char* lazy_process_string(const char* input) {
    static void* lib_handle = NULL; // Mantenemos el handle de la biblioteca.
    
    // Si aún no se ha cargado la biblioteca, la cargamos.
    if (!lib_handle) {
        lib_handle = dlopen("./libplugin.so", RTLD_LAZY);
        if (!lib_handle) {
            fprintf(stderr, "Error al cargar el plugin: %s\n", dlerror());
            return NULL;
        }
    }
    
    // Resolvemos el símbolo "process_string" de la biblioteca.
    process_func_t func = (process_func_t)dlsym(lib_handle, "process_string");
    if (!func) {
        fprintf(stderr, "Error al resolver el símbolo: %s\n", dlerror());
        return NULL;
    }
    
    // Actualizamos el puntero global para que en futuras llamadas se use directamente la función real.
    process_string_ptr = func;
    
    // Llamamos a la función real.
    return process_string_ptr(input);
}

// Función envoltorio que llama a la función del plugin, usando inicialización perezosa.
char* process_input(const char* input) {
    if (!process_string_ptr) {
        // Primera llamada: se realiza la carga y resolución.
        return lazy_process_string(input);
    }
    // Llamadas posteriores: se usa directamente la función resuelta.
    return process_string_ptr(input);
}

int main(void) {
    char input[256];
    printf("Introduce una cadena: ");
    if (!fgets(input, sizeof(input), stdin)) {
        fprintf(stderr, "Error al leer la entrada.\n");
        return 1;
    }
    // Eliminamos el salto de línea si existe.
    size_t len = strlen(input);
    if (len > 0 && input[len - 1] == '\n') {
        input[len - 1] = '\0';
    }
    
    // Se procesa la cadena usando la función on-demand.
    char* output = process_input(input);
    if (output) {
        printf("Cadena procesada: %s\n", output);
        free(output);
    }
    return 0;
}

```

Para compilar el programa principal en Linux:
```bash
gcc main.c -ldl -o main
```

1. **Inicialización perezosa:**  
    El puntero global `process_string_ptr` es inicialmente `NULL`. La función `process_input` comprueba si es `NULL`. Si es así, llama a `lazy_process_string`, que:
    - Usa `dlopen` para cargar `libplugin.so`.
    - Usa `dlsym` para obtener la dirección de la función `process_string`.
    - Actualiza `process_string_ptr` para que las llamadas siguientes usen la función real sin necesidad de volver a resolver.

2. **Ejecución:**  
    En la primera llamada, se realiza la carga dinámica y se resuelve el símbolo. Luego, se procesa la cadena (se invierte y se pasa a mayúsculas). En llamadas posteriores, la función se llama directamente usando el puntero actualizado.
    
3. **Ventajas prácticas:**
    - **Optimización del arranque:** Solo se carga el código del plugin cuando se necesita, reduciendo el tiempo y la memoria inicial.
    - **Modularidad:** Permite extender la funcionalidad de la aplicación mediante la adición o actualización de plugins sin recompilar el programa principal.
    - **Flexibilidad:** Se puede combinar con mecanismos para recargar o actualizar módulos en tiempo de ejecución, ideal en sistemas con características de plugin.