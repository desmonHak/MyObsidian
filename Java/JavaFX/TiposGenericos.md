
**Uso de `<T>`:**
Se utiliza `<T>` al definir clases, interfaces o métodos genéricos que operan sobre un tipo específico determinado en tiempo de compilación. Este enfoque permite que el código sea flexible y seguro respecto al tipo de datos con el que trabaja.

**Uso de `<?>`:**
El comodín `<?>` se utiliza cuando el tipo exacto no es relevante o no se conoce, permitiendo mayor flexibilidad en métodos que pueden operar sobre colecciones de diferentes tipos.

```java
public class Caja<T> {
    /*
    * <T>: Define un parámetro de tipo específico en una
    *       clase o metodo genérico.
    * <?>: Es un comodín que representa un tipo desconocido,
    *       útil cuando no es necesario especificar el tipo exacto.
    *
    * Se utiliza <T> al definir clases, interfaces o métodos genéricos
    * que operan sobre un tipo específico determinado en tiempo de
    * compilación. Este enfoque permite que el código sea flexible
    * y seguro respecto al tipo de datos con el que trabaja.
    *
    * El comodín <?> se utiliza cuando el tipo exacto no es
    * relevante o no se conoce, permitiendo mayor flexibilidad
    * en métodos que pueden operar sobre colecciones de
    * diferentes tipos.
     * */
    private T contenido;

    public void setContenido(T contenido) {
        this.contenido = contenido;
    }

    public T getContenido() {
        return contenido;
    }
}
```

```java
import java.util.ArrayList;  
import java.util.List;  
  
public class EjemploConCaja {  
    public static void imprimirLista(List<?> lista) {  
        for (Object elemento : lista) {  
            System.out.println(elemento);  
        }  
    }  
  
    public static void main(String[] args) {  
        Caja<String> cajaDeString = new Caja<>();  
        cajaDeString.setContenido("Hola");  
        String mensaje = cajaDeString.getContenido();  
        System.out.println(mensaje);  
  
        Caja<Integer> cajaDeInteger = new Caja<>();  
        cajaDeInteger.setContenido(1);  
        int numero = cajaDeInteger.getContenido();  
        System.out.println(numero);  
  
        ArrayList a = new ArrayList();  
        for (int i = 0; i <= 100; i+=10) {  
            a.add(i);  
        }  
        imprimirLista(a);  
    }  
}
```