[https://rvsec0n.wordpress.com/2019/09/13/routines-utilizing-tebs-and-pebs/](https://rvsec0n.wordpress.com/2019/09/13/routines-utilizing-tebs-and-pebs/)

FS: [0x00] En otras palabras, fs: 0 representa la dirección del manejador SEH actual. SEH también se utiliza como una técnica anti-depuración, por lo que es probablemente una de las formas más visibles con frecuencia. Cuando ocurre una excepción, el sistema busca la parte superior de la cadena SEH. Esta dirección está contenida en FS: [0x0]. Por supuesto, debido a que la estructura de la trama SEH consiste en la dirección del manejador y el puntero a la dirección del siguiente manejador, es suficiente conocer sólo la dirección de Top cuando se hace referencia a SEH.

```c
PUSH 0x0040184
XOR EAX, EAX
PUSH DWORD PTR FS:[EAX]
MOV DWORD PTR FS:[EAX], ESP
```

O de otras formas.
```c
PUSH 0x0040184
PUSH DWORD PTR FS:[0] ; [FS:0x00000000] = [0x00379000] = 0x0019FFCC
..
MOV DWORD PTR FS:[0], EAX
```

La rutina anterior es la rutina de instalación del manejador SEH. Después de empujar la dirección del manejador, la dirección que representa el tope de la cadena SEH es obtenida y empujada a través de FS [0x0]. Debido a que el manejador SEH actual será el tope de la cadena, necesitamos apuntar al marco SEH que fue previamente Top.

Por supuesto, ponemos la dirección del último marco SEH instalado en FS: [0x0] para que Top apunte al marco SEH que acabamos de instalar. Para su información, la dirección del registro FS se puede poner directamente a 0, como FS: [0], o se puede usar FS: [EAX] después de inicializar EAX a 0 mediante la instrucción ``XOR EAX, EAX``. Tenga en cuenta que x64 no utiliza este mecanismo para el manejo de excepciones.