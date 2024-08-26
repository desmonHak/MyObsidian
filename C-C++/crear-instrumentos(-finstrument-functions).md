### ¿Qué significa "instrumentar"?

En el contexto de compilación, **instrumentar** significa añadir automáticamente código extra a una función para realizar tareas adicionales, como:

- **``Profiling``**: Medir el tiempo de ejecución.
- **``Tracing``**: Seguir la ejecución del programa.
- **``Coverage``**: Medir la cobertura de pruebas.

GCC tiene la capacidad de instrumentar todas las funciones de un programa para que llamen a funciones específicas cuando se ingresan (`__cyg_profile_func_enter`) y cuando se salen (`__cyg_profile_func_exit`). Esto es útil para tareas como el ``profiling`` y ``debugging``, pero en algunos casos, puede ser indeseable o problemático para ciertas funciones.
### ¿Qué hace el atributo `no_instrument_function`?

Cuando aplicas [[atributo-no_instrument_function]] a una función, le indicas al compilador que no debe añadir el código de instrumentación a esa función específica, incluso si la instrumentación está habilitada globalmente.