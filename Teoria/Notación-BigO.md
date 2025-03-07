https://www.youtube.com/watch?v=MyAiCtuhiqQ
https://www.youtube.com/watch?v=dqFS-CXCEVQ
https://www.geeksforgeeks.org/how-to-analyse-complexity-of-recurrence-relation/
https://towardsdatascience.com/understanding-time-complexity-with-python-examples-2bda6e8158a7
https://old.chuidiang.org/clinux/herramientas/profiler.php
## notación asintótica Big O (limite superior)
Permite medir la velocidad de nuestro programa. La [[Notación-BigO]] nos permite saber la velocidad de nuestro programa en el peor de los casos según la entrada.
![[Pasted image 20241217212648.png]]
```c
╔══════════════════╦═════════════════╗  
║   Name           ║ Time Complexit  ║  
╠══════════════════╬═════════════════╣  
║ Constant Time    ║ O(1)            ║  
╠══════════════════╬═════════════════╣  
║ Logarithmic Time ║ O(log n)        ║  
╠══════════════════╬═════════════════╣  
║ Linear Time      ║ O(n)            ║  
╠══════════════════╬═════════════════╣  
║ Quasilinear Time ║ O(n log n)      ║  
╠══════════════════╬═════════════════╣  
║ Quadratic Time   ║ O(n^2)          ║  
╠══════════════════╬═════════════════╣  
║ Exponential Time ║ O(2^n)          ║  
╠══════════════════╬═════════════════╣  
║ Factorial Time   ║ O(n!)           ║  
╚══════════════════╩═════════════════╝
```

## Coste O(1)
Se dice que un algoritmo tiene un tiempo constante cuando no depende de los datos de entrada (n). No importa el tamaño de los datos de entrada, el tiempo de ejecución siempre será el mismo. Por ejemplo:
```python
if a > b:  
    return True  
else:  
    return False
```

Ahora, echemos un vistazo a la función ``get_first`` que devuelve el primer elemento de una lista.
```python
def get_first(data):  
    return data[0]  
      
if __name__ == '__main__':  
    data = [1, 2, 9, 8, 3, 4, 7, 6, 5]  
    print(get_first(data))
```
Independientemente del tamaño de los datos de entrada, siempre tendrá el mismo tiempo de ejecución, ya que solo obtiene el primer valor de la lista.

Un algoritmo con complejidad temporal constante es excelente, ya que no tenemos que preocuparnos por el tamaño de entrada.

## Coste O(log n) 
Se dice que un algoritmo tiene una complejidad temporal logarítmica cuando reduce el tamaño de los datos de entrada en cada paso (no necesita mirar todos los valores de los datos de entrada), por ejemplo:
```python
for index in range(0, len(data), 3):  
	print(data[index])
```
Los algoritmos con complejidad temporal logarítmica se encuentran comúnmente en operaciones con árboles binarios o cuando se utiliza la búsqueda binaria. Veamos un ejemplo de una búsqueda binaria, donde necesitamos encontrar la posición de un elemento en una lista ordenada:
```python
def binary_search(data, value):
    n = len(data)
    left = 0
    right = n - 1
    while left <= right:
        middle = (left + right) // 2
        if value < data[middle]:
            right = middle - 1
        elif value > data[middle]:
            left = middle + 1
        else:
            return middle
    raise ValueError('Value is not in the list')
    
if __name__ == '__main__':
    data = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    print(binary_search(data, 8))
```
Pasos de la búsqueda binaria:

- Calcular el punto medio de la lista.
- Si el valor buscado es menor que el valor en el medio de la lista, establecer un nuevo límite derecho.
- Si el valor buscado es mayor que el valor en el medio de la lista, establecer un nuevo límite izquierdo.
- Si el valor buscado es igual al valor en el medio de la lista, devolver el punto medio (el índice).
- Repetir los pasos anteriores hasta que se encuentre el valor o hasta que el límite izquierdo sea igual o mayor que el límite derecho.
Es importante entender que un algoritmo que debe acceder a todos los elementos de sus datos de entrada no puede tomar tiempo logarítmico, ya que el tiempo que toma leer una entrada de tamaño n es del orden de n.

## Coste O(n) 
Se dice que un algoritmo tiene una complejidad temporal lineal cuando el tiempo de ejecución aumenta como máximo de manera lineal con el tamaño de los datos de entrada. Esta es la mejor complejidad temporal posible cuando el algoritmo debe examinar todos los valores de los datos de entrada. Por ejemplo:
```python
for value in data:
    print(value)
```
Veamos el ejemplo de una búsqueda lineal, donde necesitamos encontrar la posición de un elemento en una lista desordenada:
```python
def linear_search(data, value):  
    for index in range(len(data)):  
        if value == data[index]:  
            return index  
    raise ValueError('Value not found in the list')  
      
if __name__ == '__main__':  
    data = [1, 2, 9, 8, 3, 4, 7, 6, 5]  
    print(linear_search(data, 7))
```
Tenga en cuenta que en este ejemplo, debemos mirar todos los valores de la lista para encontrar el valor que estamos buscando.

## Coste O(n log n) 
Se dice que un algoritmo tiene una complejidad temporal ``cuasilineal`` cuando cada operación en los datos de entrada tiene una complejidad temporal logarítmica. Esto se observa comúnmente en algoritmos de ordenamiento (por ejemplo, [[mergesort]], [[timsort]], [[heapsort]]).

Por ejemplo: para cada valor en data1 (O(n)) utilice la búsqueda binaria (O(log n)) para buscar el mismo valor en data2.
```python
for value in data1:  
    result.append(binary_search(data2, value))
```

Otro ejemplo más complejo se puede encontrar en el algoritmo [[mergesort]]. [[mergesort]] es un algoritmo de ordenamiento eficiente, de propósito general y basado en comparaciones que tiene una complejidad temporal cuasilineal. Veamos un ejemplo:
```python
def merge_sort(data):  
    if len(data) <= 1:  
        return  
      
    mid = len(data) // 2  
    left_data = data[:mid]  
    right_data = data[mid:]  
      
    merge_sort(left_data)  
    merge_sort(right_data)  
      
    left_index = 0  
    right_index = 0  
    data_index = 0  
      
    while left_index < len(left_data) and right_index < len(right_data):  
        if left_data[left_index] < right_data[right_index]:  
            data[data_index] = left_data[left_index]  
            left_index += 1  
        else:  
            data[data_index] = right_data[right_index]  
            right_index += 1  
        data_index += 1  
      
    if left_index < len(left_data):  
        del data[data_index:]  
        data += left_data[left_index:]  
    elif right_index < len(right_data):  
        del data[data_index:]  
        data += right_data[right_index:]  
      
if __name__ == '__main__':  
    data = [9, 1, 7, 6, 2, 8, 5, 3, 4, 0]  
    merge_sort(data)  
    print(data)
```
La siguiente imagen ejemplifica los pasos que sigue el algoritmo de ordenación por combinación([[mergesort]]):
![[Pasted image 20241217213551.png]]
Tenga en cuenta que en este ejemplo la clasificación se realiza en el lugar.

## Coste O(n²) 
Se dice que un algoritmo tiene una complejidad temporal cuadrática cuando necesita realizar una operación temporal lineal para cada valor de los datos de entrada, por ejemplo:
```python
for x in data:
    for y in data:
        print(x, y)
```

El ordenamiento de burbuja[[[Bubble sort](https://en.wikipedia.org/wiki/Bubble_sort)]] es un gran ejemplo de complejidad temporal cuadrática, ya que para cada valor debe compararse con todos los demás valores de la lista. Veamos un ejemplo:
```python
def bubble_sort(data):
    swapped = True
    while swapped:
        swapped = False
        for i in range(len(data)-1):
            if data[i] > data[i+1]:
                data[i], data[i+1] = data[i+1], data[i]
                swapped = True
    
if __name__ == '__main__':
    data = [9, 1, 7, 6, 2, 8, 5, 3, 4, 0]
    bubble_sort(data)
    print(data)

```
## Coste O(2^n) 
Se dice que un algoritmo tiene una complejidad temporal exponencial cuando el crecimiento se duplica con cada adición al conjunto de datos de entrada. Este tipo de complejidad temporal suele observarse en algoritmos de fuerza bruta.
Como lo ejemplifica Vicky Lai:

>En criptografía, un ataque de fuerza bruta puede comprobar sistemáticamente todos los elementos posibles de una contraseña iterando a través de subconjuntos. Si se utiliza un algoritmo exponencial para hacer esto, resulta increíblemente costoso en términos de recursos descifrar por fuerza bruta una contraseña larga en lugar de una más corta. Esta es una de las razones por las que una contraseña larga se considera más segura que una más corta.

Otro ejemplo de un algoritmo de tiempo exponencial es el cálculo recursivo de números [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_number):
```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```
Si no sabes qué es una función recursiva, aclarémoslo rápidamente: una función recursiva puede describirse como una función que se llama a sí misma en condiciones específicas. Como habrás notado, la complejidad temporal de las funciones recursivas es un poco más difícil de definir, ya que depende de cuántas veces se llama a la función y de la complejidad temporal de una sola llamada a la función.

Tiene más sentido cuando observamos el árbol de recursión. El siguiente árbol de recursión fue generado por el algoritmo de Fibonacci utilizando n = 4:
![[Pasted image 20241217213958.png]]
Tenga en cuenta que se llamará a sí mismo hasta que llegue a las hojas. Al llegar a las hojas, devuelve el valor en sí.

Ahora, observe cómo crece el árbol de recursión simplemente aumentando n a 6:
![[Pasted image 20241217214213.png]]
Puedes encontrar una explicación más completa sobre la complejidad temporal del algoritmo recursivo de Fibonacci [here](https://stackoverflow.com/a/360773/4946821) en StackOverflow.

## Coste O(n!):
Se dice que un algoritmo tiene una complejidad temporal factorial cuando crece de forma factorial en función del tamaño de los datos de entrada, por ejemplo:
```python
2! = 2 x 1 = 2  
3! = 3 x 2 x 1 = 6  
4! = 4 x 3 x 2 x 1 = 24  
5! = 5 x 4 x 3 x 2 x 1 = 120  
6! = 6 x 5 x 4 x 3 x 2 x 1 = 720  
7! = 7 x 6 x 5 x 4 x 3 x 2 x 1 = 5.040  
8! = 8 x 7 x 6 x 5 x 4 x 3 x 2 x 1 = 40.320
```
Como puede ver, crece muy rápido, incluso para una entrada de tamaño pequeño.

Un gran ejemplo de un algoritmo que tiene una complejidad temporal factorial es el algoritmo Heap, que se utiliza para generar todas las permutaciones posibles de n objetos.

According to [Wikipedia](https://en.wikipedia.org/wiki/Heap%27s_algorithm):
>Heap encontró un método sistemático para elegir en cada paso un par de elementos para cambiar, con el fin de producir cada permutación posible de estos elementos exactamente una vez.

```python
def heap_permutation(data, n):
    if n == 1:
        print(data)
        return
    
    for i in range(n):
        heap_permutation(data, n - 1)
        if n % 2 == 0:
            data[i], data[n-1] = data[n-1], data[i]
        else:
            data[0], data[n-1] = data[n-1], data[0]
    
if __name__ == '__main__':
    data = [1, 2, 3]
    heap_permutation(data, len(data))
```

The result will be:
```c
[1, 2, 3]  
[2, 1, 3]  
[3, 1, 2]  
[1, 3, 2]  
[2, 3, 1]  
[3, 2, 1]
```
Tenga en cuenta que crecerá de forma factorial, en función del tamaño de los datos de entrada, por lo que podemos decir que el algoritmo tiene una complejidad temporal factorial O(n!).

Otro gran ejemplo es el [Travelling Salesman Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)(problema del viajante).

## Notas importantes
Es importante tener en cuenta que, al analizar la complejidad temporal de un algoritmo con varias operaciones, debemos describir el algoritmo en función de la mayor complejidad entre todas las operaciones. Por ejemplo:
```python
def my_function(data):  
    first_element = data[0]  
      
    for value in data:  
        print(value)  
      
    for x in data:  
        for y in data:  
            print(x, y)
```
Aunque las operaciones en ‘my_function’ no tienen sentido, podemos ver que tiene múltiples complejidades temporales: O(1) + O(n) + O(n²). Por lo tanto, al aumentar el tamaño de los datos de entrada, el cuello de botella de este algoritmo será la operación que toma O(n²). En base a esto, podemos describir la complejidad temporal de este algoritmo como O(n²).

# Hoja de trucos de Big-O
Para hacerte la vida más fácil, aquí podrás encontrar una hoja con la complejidad temporal de las operaciones en las estructuras de datos más comunes.
![[Pasted image 20241217214650.png]]
