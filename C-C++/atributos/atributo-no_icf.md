`no_icf`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005ficf-function-attribute)

Este atributo de función evita que una función se fusione con otra función semánticamente equivalente.

El atributo `no_icf` en GCC se utiliza para prevenir que una función o variable sea optimizada mediante la **Identical Code Folding** (ICF).

### ¿Qué es **Identical Code Folding (ICF)**?

ICF es una técnica de optimización que busca identificar funciones o bloques de código idénticos en un programa y combinarlos en uno solo para reducir el tamaño del binario. Esto es útil porque si múltiples funciones hacen exactamente lo mismo, solo se necesita una copia de ese código en el binario, lo que ahorra espacio.

### ¿Qué hace el atributo `no_icf`?

Cuando se aplica el atributo `no_icf` a una función o variable, se le indica al compilador que no debe aplicar ICF sobre ese elemento. Es decir, aunque el compilador encuentre funciones o variables idénticas en cuanto a su código o datos, no las combinará, y cada una mantendrá su propia copia en el binario final.

### Ejemplo de uso:

```c
__attribute__((no_icf))
void func1() {
    // Código que no será fusionado con otros similares
    printf("Func1 ejecutada.\n");
}

void func2() {
    // Código idéntico a func1 pero no será fusionado debido a no_icf
    printf("Func2 ejecutada.\n");
}

int main() {
    func1();
    func2();
    return 0;
}

```

### Explicación:
- En el ejemplo, `func1` y `func2` contienen el mismo código. Si ICF estuviera habilitado sin restricciones, el compilador podría combinar estas dos funciones en una sola, eliminando la duplicación.
- Al aplicar el atributo `no_icf` a `func1`, se previene que `func1` sea combinada con otras funciones que tengan código idéntico, como `func2` en este caso. Esto garantiza que `func1` y `func2` se mantengan como funciones independientes en el binario final.

### ¿Cuándo usar `no_icf`?
- **Funciones críticas:** Cuando necesitas que una función específica permanezca única en el binario, por ejemplo, en casos de funciones con propósitos específicos como debugging, seguridad o manejo de errores.
- **Variables con significados diferentes:** Si dos variables tienen valores idénticos pero significados diferentes, `no_icf` asegura que no se combinen accidentalmente.

`no_icf` se utiliza para evitar que el compilador aplique la optimización de ICF, garantizando que las funciones o variables a las que se aplica se mantengan separadas, aunque sean idénticas.