`patchable_function_entry` [¶](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-patchable_005ffunction_005fentry-function-attribute)

En caso de que el segmento de texto del objetivo se pueda hacer escribible en tiempo de ejecución por cualquier medio, se puede rellenar la entrada de función con una cantidad de NOP para proporcionar una herramienta universal para la instrumentación.

El atributo de función `patchable_function_entry` se puede utilizar para cambiar la cantidad de NOP a cualquier valor deseado. La sintaxis de dos valores es la misma que para el modificador de línea de comandos ``-fpatchable-function-entry=N,M``, que genera N ``NOP``, con el punto de entrada de la función antes de la instrucción ``NOP`` Mth. M tiene el valor predeterminado 0 si se omite, por ejemplo, el punto de entrada de la función está antes del primer NOP.

Si las entradas de funciones parcheables se habilitan globalmente mediante la opción de línea de comandos ``-fpatchable-function-entry=N,M``, entonces debe deshabilitar la instrumentación en todas las funciones que son parte del marco de instrumentación con el atributo `patchable_function_entry (0)` para evitar la recursión.



El atributo `patchable_function_entry` en C/C++ se utiliza para facilitar la instrumentación de funciones en tiempo de ejecución, especialmente en entornos donde el código puede necesitar ser modificado dinámicamente. Este atributo se usa para agregar un relleno de instrucciones `NOP` (no operación) en la entrada de una función, lo que permite a las herramientas de instrumentación insertar código adicional en puntos específicos sin alterar el código original de la función.

### Cómo Funciona `patchable_function_entry`

Cuando se aplica el atributo `patchable_function_entry`, el compilador agrega un número específico de instrucciones `NOP` al principio de la función. Esto crea un espacio que se puede usar para insertar código adicional en el punto de entrada de la función sin afectar el flujo original de la ejecución.

#### Sintaxis del Atributo

El atributo puede ser especificado con uno o dos valores:

- `__attribute__((patchable_function_entry(N, M)))`: Aquí, `N` es el número de instrucciones `NOP` a insertar. `M` indica la posición relativa del punto de entrada de la función respecto al primer `NOP`. Si `M` no se proporciona, se considera como `0`, lo que significa que el punto de entrada de la función es antes del primer `NOP`.

#### Ejemplos

1. **Aplicar el Atributo con Valores Específicos:**
    
    
```c
void __attribute__((patchable_function_entry(4, 2))) my_function() {
// Código de la función. 
}
```
 En este caso, el compilador insertará 4 instrucciones `NOP` al inicio de `my_function`. El punto de entrada real de la función será antes del tercer `NOP` (contando desde el primer `NOP` como 1).
    
2. **Aplicar el Atributo con un Valor Predeterminado:**
    
```c
void __attribute__((patchable_function_entry(3))) my_function() {
// Código de la función. 
}
```
Aquí, se insertarán 3 instrucciones `NOP` al inicio de `my_function`, y el punto de entrada real de la función será antes del primer `NOP`.

### Uso y Beneficios

1. **Instrumentación Dinámica:** La principal ventaja de `patchable_function_entry` es que permite a las herramientas de instrumentación o depuración insertar código adicional (por ejemplo, contadores, registros de eventos, etc.) al inicio de una función sin modificar el código original.
    
2. **Facilidad de Modificación:** Al tener un espacio relleno de `NOPs`, se facilita la inserción y modificación del código en tiempo de ejecución, lo que puede ser útil en sistemas de análisis de rendimiento, perfiles de ejecución, o técnicas de monitoreo dinámico.
    
3. **Prevención de Recursión:** Si se habilitan entradas de funciones parcheables globalmente con la opción de línea de comandos `-fpatchable-function-entry=N,M`, se debe desactivar la instrumentación en todas las funciones que forman parte del marco de instrumentación usando `patchable_function_entry(0)` para evitar problemas de recursión.
    

### Consideraciones

- **Compatibilidad con el Entorno:** El uso de `patchable_function_entry` puede depender de la capacidad del sistema para modificar el segmento de texto (código ejecutable) en tiempo de ejecución. No todos los entornos permiten esto por razones de seguridad.
    
- **Interferencia con el Código:** La inserción de instrucciones `NOP` puede afectar al rendimiento si se usan en exceso, por lo que se debe utilizar con moderación y con conocimiento de su impacto.
    

En resumen, el atributo `patchable_function_entry` proporciona un mecanismo flexible para la instrumentación de funciones al permitir la inserción de código adicional mediante el uso de relleno `NOP` al inicio de la función. Esto es particularmente útil en aplicaciones de depuración y análisis de rendimiento.