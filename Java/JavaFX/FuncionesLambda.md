Es necesario conocer los [[TiposGenericos]].

```java
import java.util.Arrays;  
import java.util.List;  
  
public class EjemploComparator {  
    public static void main(String[] args) {  
        List<Integer> numeros = Arrays.asList(5, 3, 10, 1, 4);  
        // Se usa una lambda para definir el Comparator que ordena de forma ascendente  
        numeros.sort((a, b) -> a.compareTo(b));  
        System.out.println("Ordenados: " + numeros);  
    }  
}
```

```java
import java.util.Arrays;  
import java.util.List;  
  
public class EjemploForEach {  
    public static void main(String[] args) {  
        List<String> mensajes = Arrays.asList("mensaje1", "mensaje2", "mensaje3");  
        // Se pasa una lambda al método forEach para imprimir cada elemento de la lista  
        mensajes.forEach(mensaje -> System.out.println(mensaje));  
    }  
}
```

Interfaz necesaria:
```java
@FunctionalInterface  
interface Operacion {  
    int calcular(int a, int b);  
}
```

```java
public class EjemploLambda {  
public static void main(String[] args) {  
    // Lambda que define una suma  
    int resultadoSuma = ejecutarOperacion(5, 3, (x, y) -> {  
            return x + y;  
        }  
    );  
    System.out.println("Suma: " + resultadoSuma);  
  
    // Lambda que define una multiplicación  
    int resultadoMultiplicacion = ejecutarOperacion(5, 3, (x, y) -> {  
        return x * y;  
    });  
    System.out.println("Multiplicación: " + resultadoMultiplicacion);  
  
      
    Operacion Resta = (a, b) -> a - b;  
    int resultadoResta = Resta.calcular(5, 3);  
    System.out.println("Resta: " + resultadoResta);  
      
    Operacion Division = (a, b) -> a / b;  
    int resultadoDivision = Division.calcular(5, 3);  
    System.out.println("Division: " + resultadoDivision);  
}
```


```java
public class EjemploRunnable {  
    public static void main(String[] args) {  
        // Se crea un Runnable con una lambda que imprime un mensaje  
        Runnable tarea = () -> System.out.println("Hola desde un hilo usando lambda");  
  
        // Se crea e inicia un nuevo hilo que ejecuta la lambda  
        new Thread(tarea).start();  
    }  
}
```



```java
public class EjemploLambdaPersonalizado {
    public static void main(String[] args) {
        // Lambda para calcular el cuadrado de un número
        OperacionUnaria cuadrado = x -> x * x;
        System.out.println("Cuadrado de 5: " + aplicarOperacionUnaria(5, cuadrado));

        // Lambda para calcular el cubo de un número
        OperacionUnaria cubo = x -> x * x * x;
        System.out.println("Cubo de 3: " + aplicarOperacionUnaria(3, cubo));

        // Lambda para verificar si un número es par
        OperacionBooleana esPar = x -> x % 2 == 0;
        System.out.println("¿Es 6 par?: " + aplicarOperacionBooleana(6, esPar));

        // Lambda para verificar si un número es primo
        OperacionBooleana esPrimo = x -> {
            if (x <= 1) return false;
            for (int i = 2; i <= Math.sqrt(x); i++) {
                if (x % i == 0) return false;
            }
            return true;
        };
        System.out.println("¿Es 17 primo?: " + aplicarOperacionBooleana(17, esPrimo));
    }

	// Interfaz funcional para operaciones unarias (un solo parámetro)  
	@FunctionalInterface  
	interface OperacionUnaria {  
	    int aplicar(int x);  
	}  
	  
	// Interfaz funcional para operaciones booleanas  
	@FunctionalInterface  
	interface OperacionBooleana {  
	    boolean evaluar(int x);  
	}

    // Método para aplicar una operación unaria
    static int aplicarOperacionUnaria(int valor, OperacionUnaria operacion) {
        return operacion.aplicar(valor);
    }

    // Método para aplicar una operación booleana
    static boolean aplicarOperacionBooleana(int valor, OperacionBooleana operacion) {
        return operacion.evaluar(valor);
    }
}

```