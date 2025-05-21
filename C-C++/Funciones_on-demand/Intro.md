"Funciones on-demand" en C se refieren a aquellas funciones cuya carga, inicialización o resolución se pospone hasta que son realmente necesarias. Esto puede implicar dos técnicas principales:

1. **Carga dinámica de bibliotecas:**  
    Mediante funciones como `dlopen`/`dlsym` en sistemas Unix (o `LoadLibrary`/`GetProcAddress` en Windows), se pueden cargar en tiempo de ejecución partes de código que no se vinculan de manera estática al inicio del programa. Esto es útil en sistemas modulares o basados en plugins, donde se desea que ciertos módulos se descarguen o activen únicamente cuando el usuario solicita esa funcionalidad.
    
2. **Inicialización perezosa (lazy initialization) de funciones:**  
    Se puede implementar una función "on-demand" definiendo un puntero a función que inicialmente apunte a una función "thunk" de inicialización. La primera vez que se llama, esta función de inicialización realiza la configuración necesaria (por ejemplo, resolver la dirección real de la función, cargar recursos o incluso realizar la carga dinámica) y luego reemplaza el puntero con la dirección de la función real. Las llamadas posteriores se ejecutan directamente en la función ya inicializada, evitando el coste de la inicialización repetida.
    

### Casos de uso y ventajas

- **Optimización de recursos y tiempos de carga:**  
    En aplicaciones grandes o con funcionalidades opcionales, cargar todo el código en el arranque puede aumentar el tiempo de inicio y el uso de memoria. Con funciones on-demand, solo se carga lo que se necesita.
    
- **Sistemas modulares y de plugins:**  
    Permiten extender la funcionalidad de una aplicación sin tener que recompilar o reiniciar todo el sistema, ya que los módulos se integran en tiempo de ejecución.
    
- **Flexibilidad y escalabilidad:**  
    Útil en aplicaciones embebidas o en aquellas en las que ciertos componentes se usan rara vez. Se mejora la eficiencia al activar componentes bajo demanda.
### Ejemplo de inicialización perezosa

El siguiente ejemplo muestra cómo implementar una función on-demand usando un puntero a función:

```c
#include <stdio.h>

// Definición de un tipo para el puntero a función
typedef int (*FuncType)(int);

// Declaración de la función real
int real_func(int x) {
    printf("Ejecutando real_func\n");
    return x * 2;
}

// Declaración anticipada de la función de inicialización
int init_func(int x);

// Puntero a función inicialmente asignado a init_func (la función de inicialización)
FuncType func_ptr = init_func;

// Función de inicialización: se ejecuta solo la primera vez que se llama
int init_func(int x) {
    printf("Inicializando y reemplazando puntero...\n");
    // Aquí se puede realizar, por ejemplo, la carga dinámica de una biblioteca.
    // En este ejemplo, simplemente asignamos el puntero a la función real.
    func_ptr = real_func;
    // Llamamos a la función real para completar la operación
    return func_ptr(x);
}

int main(void) {
    int result;
    // Primera llamada: se ejecuta init_func, que inicializa y actualiza func_ptr.
    result = func_ptr(10);
    printf("Resultado: %d\n", result);
    
    // Segunda llamada: ahora se llama directamente a real_func gracias a la actualización del puntero.
    result = func_ptr(20);
    printf("Resultado: %d\n", result);
    
    return 0;
}
```

**Explicación:**
- Inicialmente, `func_ptr` apunta a `init_func`.
- En la primera llamada, `init_func` se encarga de inicializar el sistema (o de resolver la dirección de `real_func`) y actualiza `func_ptr` para que apunte a `real_func`.
- Las llamadas subsiguientes invocan directamente `real_func` sin incurrir en el coste de la inicialización.

### Conclusión
Implementar funciones en C de manera "on-demand" ayuda a mejorar la eficiencia y modularidad de una aplicación, permitiendo que el código y los recursos se carguen o inicialicen únicamente cuando son realmente necesarios. Esto es especialmente útil en aplicaciones grandes, sistemas modulares, o entornos con recursos limitados, ya que reduce tiempos de carga, optimiza el uso de memoria y facilita la extensión de la funcionalidad sin afectar el rendimiento general.
