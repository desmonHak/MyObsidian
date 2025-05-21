``Predicate`` funciona con [[FuncionesLambda]].

En Java, la interfaz `Predicate<T>` es una interfaz funcional introducida en Java 8 que representa una función que toma un argumento de tipo `T` y devuelve un valor booleano (`true` o `false`). Esencialmente, se utiliza para evaluar una condición o predicado sobre un objeto dado.

[docs.oracle.com](https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html)
**Métodos principales de `Predicate`:**
- **`test(T t)`**: Método abstracto que evalúa el predicado en el argumento dado y devuelve `true` si se cumple la condición, o `false` en caso contrario.
- **`and(Predicate<? super T> other)`**: Devuelve un predicado que representa la conjunción lógica (AND) de este predicado y otro.
- **`or(Predicate<? super T> other)`**: Devuelve un predicado que representa la disyunción lógica (OR) de este predicado y otro.
- **`negate()`**: Devuelve un predicado que representa la negación lógica de este predicado.

```java
import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/*
 *  Java, la interfaz Predicate<T> es una interfaz funcional introducida en
 * Java 8 que representa una función que toma un argumento de tipo T y devuelve
 * un valor booleano (true o false). Esencialmente, se utiliza para
 * evaluar una condición o predicado sobre un objeto dado.
 * Métodos principales de Predicate:
 * test(T t): Metodo abstracto que evalúa el predicado en el
 * argumento dado y devuelve true si se cumple la condición, o false
 * en caso contrario.
 *
 * and(Predicate<? super T> other): Devuelve un predicado que
 * representa la conjunción lógica (AND) de este predicado y otro.
 *
 * or(Predicate<? super T> other): Devuelve un predicado que
 * representa la disyunción lógica (OR) de este predicado y otro.
 *
 * negate(): Devuelve un predicado que representa la negación
 * lógica de este predicado.
 *
 */
public class EjemploPredicate {
    public static void main(String[] args) {
        // Se crea un Predicate que verifica si un número es par
        Predicate<Integer> esPar = num -> num % 2 == 0;
        System.out.println("4 es par? " + esPar.test(4));  // Imprime true
        System.out.println("7 es par? " + esPar.test(7));  // Imprime false



        List<Integer> numeros = Arrays.asList(5, 12, 8, 20, 3);

        // Definimos un predicado que verifica si un número es mayor que 10
        Predicate<Integer> esMayorQueDiez = num -> num > 10;

        // Filtramos la lista utilizando el predicado
        List<Integer> resultado = numeros.stream()
                .filter(esMayorQueDiez)
                .collect(Collectors.toList());

        System.out.println(resultado); // Imprime: [12, 20]
    }
}

```