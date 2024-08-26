El atributo `ifunc` se utiliza para marcar una función como una función indirecta utilizando la extensión de tipo de símbolo ``STT_GNU_IFUNC`` al estándar [[ELF]]. Esto permite que la resolución del valor del símbolo se determine dinámicamente en el momento de la carga, y que se seleccione una versión optimizada de la rutina para el procesador particular u otras características del sistema determinadas en ese momento. Para utilizar este atributo, primero defina las funciones de implementación disponibles y una función de resolución que devuelva un puntero a la función de implementación seleccionada. Las declaraciones de las funciones de implementación deben coincidir con la API de la función que se está implementando. La resolución debe declararse como una función que no toma argumentos y devuelve un puntero a una función del mismo tipo que la implementación. Por ejemplo:
```c
void *my_memcpy (void *dst, const void *src, size_t len)
{
  …
  return dst;
}

static void * (*resolve_memcpy (void))(void *, const void *, size_t)
{
  return my_memcpy; // Siempre seleccionaremos esta rutina
}
```
El archivo de encabezado exportado que declara la función que llama el usuario contendría:
```c
extern void *memcpy (void *, const void *, size_t);
```
Permitir al usuario llamar a ``memcpy`` como una función normal, sin conocer la implementación real. Por último, la función indirecta debe definirse en la misma unidad de traducción que la función de resolución:
```c
void *memcpy (void *, const void *, size_t)
     __attribute__ ((ifunc ("resolve_memcpy")));
```
En C++, el atributo ``ifunc`` toma una cadena que es el nombre alterado de la función de resolución. Una resolución de C++ para una función miembro no estática de la clase C debe declararse para que devuelva un puntero a una función no miembro que tome el puntero a C como primer argumento, seguido de los mismos argumentos que la función de implementación. C++ verifica las firmas de las dos funciones y emite una advertencia ``-Wattribute-alias`` para detectar discrepancias. Para suprimir una advertencia para la conversión necesaria de un puntero a la función miembro de implementación al tipo de la función no miembro correspondiente, utilice la opción ``-Wno-pmf-conversions``. Por ejemplo:
```cpp
class S {
	private:
	  int debug_impl (int);
	  int optimized_impl (int);
	  typedef int Func (S*, int);
	  static Func* resolver ();
	  
	public:
		  int interface (int);
};
int S::debug_impl (int) { /* … */ }
int S::optimized_impl (int) { /* … */ }

S::Func* S::resolver (){
	int (S::*pimpl) (int) = getenv ("DEBUG") ? &S::debug_impl : &S::optimized_impl;
  // Activadores de lanzamiento -Wno-pmf-conversions.
	return reinterpret_cast<Func*>(pimpl);
}

int S::interface (int) __attribute__ ((ifunc ("_ZN1S8resolverEv")));
```
Las funciones indirectas no pueden ser débiles. Para utilizar esta función se requiere la versión 2.20.1 o superior de ``Binutils`` y la versión 2.11.1 de la biblioteca C de GNU.