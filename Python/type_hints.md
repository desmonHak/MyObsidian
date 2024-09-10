En ``Python``, se puede indicar el tipo de parámetro que una función espera recibir utilizando _type hints_ (anotaciones de tipo). Las _type hints_ permiten especificar el tipo esperado para cada argumento de una función, así como el tipo de retorno de la función. Sin embargo, estas anotaciones no son obligatorias y no imponen restricciones en tiempo de ejecución, sino que son una guía para los desarrolladores y herramientas de análisis estático.

Ejemplo:
```python
def suma(a: int, b: int) -> int:
    return a + b
```

- `a: int` indica que el parámetro `a` se espera que sea de tipo `int`.
- `b: int` indica que el parámetro `b` se espera que sea de tipo `int`.
- `-> int` indica que la función `suma` debería devolver un valor de tipo `int`.

```python
from typing import List, Dict, Union, Optional

# Función que toma una lista de enteros y devuelve un entero
def sumar_lista(numeros: List[int]) -> int:
    return sum(numeros)

# Función que toma un diccionario con claves tipo string y valores tipo int y devuelve un string
def dict_a_string(datos: Dict[str, int]) -> str:
    return ', '.join([f"{key}: {value}" for key, value in datos.items()])

# Función que toma un parámetro que puede ser int o float y devuelve un float
def cuadrado(num: Union[int, float]) -> float:
    return num ** 2

# Función que puede devolver un entero o None
def obtener_valor(opcional: Optional[int] = None) -> Optional[int]:
    if opcional is not None:
        return opcional * 2
    return None
```

- `List[int]`: Indica que se espera una lista de enteros.
- `Dict[str, int]`: Indica que se espera un diccionario con claves de tipo `str` y valores de tipo `int`.
- `Union[int, float]`: Indica que el parámetro puede ser de tipo `int` o `float`.
- `Optional[int]`: Indica que el parámetro o el valor de retorno puede ser de tipo `int` o `None`.