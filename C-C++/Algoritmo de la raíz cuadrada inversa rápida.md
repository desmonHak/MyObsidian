s[https://es.wikipedia.org/wiki/Algoritmo_de_la_raíz_cuadrada_inversa_rápida](https://es.wikipedia.org/wiki/Algoritmo_de_la_raíz_cuadrada_inversa_rápida)

La raíz cuadrada inversa rápida, a veces conocida como ``Fast InvSqrt()`` o por la constante [hexadecimal](https://es.wikipedia.org/wiki/Sistema_hexadecimal "Sistema hexadecimal") ``0x5F3759DF``, es un [algoritmo](https://es.wikipedia.org/wiki/Algoritmo "Algoritmo") que estima ![{\displaystyle {\frac {1}{\sqrt {x}}}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/080a33b7fb940dfde4d893093e55096f6bf149dc), el recíproco (o inverso multiplicativo) de la raíz cuadrada de un número en [punto flotante](https://es.wikipedia.org/wiki/Punto_flotante "Punto flotante") de 32 [bits](https://es.wikipedia.org/wiki/Bit "Bit"). Esta operación se utiliza en el procesamiento digital de señales para normalizar un [vector](https://es.wikipedia.org/wiki/Vector "Vector"), es decir, convertirlo en un [vector de módulo 1](https://es.wikipedia.org/wiki/Vector_unitario "Vector unitario"). Por ejemplo, los programas de gráficos por ordenador utilizan las raíces cuadradas inversas para calcular los ángulos de incidencia y reflexión para la iluminación y el sombreado. El algoritmo es más conocido por su implementación en 1999 en el código fuente del videojuego de disparos en primera persona [Quake III Arena](https://es.wikipedia.org/wiki/Quake_III_Arena "Quake III Arena"),  que hacía un gran uso de los [gráficos en 3D](https://es.wikipedia.org/wiki/Gr%C3%A1ficos_3D_por_computadora "Gráficos 3D por computadora"). El algoritmo no empezó a aparecer en foros públicos como [Usenet](https://es.wikipedia.org/wiki/Usenet "Usenet") hasta 2002 o 2003. El cálculo de las raíces cuadradas suele depender de muchas operaciones de división, que para los números en coma flotante son computacionalmente costosas. El cuadrado inverso rápido genera una buena [aproximación](https://es.wikipedia.org/wiki/Aproximaci%C3%B3n "Aproximación") con un solo paso de división. Se han descubierto otros videojuegos anteriores a Quake 3 que utilizan un algoritmo similar, aunque la implementación de Quake sigue siendo el ejemplo más conocido.

El algoritmo acepta un número en coma flotante de 32 bits como entrada y almacena un valor dividido a la mitad para su uso posterior. A continuación, tratando los bits que representan el número en punto flotante como un entero de 32 bits, se realiza un desplazamiento lógico a la derecha de un bit y el resultado se resta del número ``0x5F3759DF`` (en [notación decimal](https://es.wikipedia.org/wiki/Sistema_de_numeraci%C3%B3n_decimal "Sistema de numeración decimal"): ``1.597.463.007``), que es una representación en punto flotante de una aproximación de 2127![{\displaystyle {\sqrt {2^{127}}}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/903828d9dfadc6c3ed0b52f9f7a79af1f431a13d) . Esto resulta en la primera aproximación de la raíz cuadrada inversa de la entrada. Tratando los bits de nuevo como un número en punto flotante, se ejecuta una iteración del [método de Newton](https://es.wikipedia.org/wiki/M%C3%A9todo_de_Newton "Método de Newton"), produciendo una aproximación más precisa.

El algoritmo se atribuyó originalmente a [John Carmack](https://es.wikipedia.org/wiki/John_Carmack "John Carmack"), pero una investigación demostró que el código tenía raíces más profundas tanto en el [hardware](https://es.wikipedia.org/wiki/Hardware "Hardware") como en el [software](https://es.wikipedia.org/wiki/Software "Software") de los gráficos por ordenador. Los ajustes y alteraciones pasaron por [Silicon Graphics](https://es.wikipedia.org/wiki/Silicon_Graphics "Silicon Graphics") y 3dfx Interactive, y la constante original se derivó de una colaboración entre [Cleve Moler](https://es.wikipedia.org/wiki/Cleve_Moler "Cleve Moler") y Gregory Walsh, mientras Gregory trabajaba para Ardent Computing a finales de la década de los 80. Walsh y Moler adaptaron su versión a partir de un documento inédito de [William Kahan](https://es.wikipedia.org/wiki/William_Kahan "William Kahan") y K.C. Ng difundido en mayo de 1986.

Con los posteriores avances en el [hardware](https://es.wikipedia.org/wiki/Hardware "Hardware"), especialmente los `rsqrtss` en instrucciones SSE para x86, este método no es aplicable en general a la informática de propósito general, aunque sigue siendo un ejemplo interesante históricamente, así como para máquinas más limitadas, como los sistemas de bajo coste. Sin embargo, cada vez son más los fabricantes que incluyen aceleradores trigonométricos y otros aceleradores matemáticos como [CORDIC](https://es.wikipedia.org/wiki/CORDIC "CORDIC"), obviando la necesidad de estos algoritmos.

```c
float Q_rsqrt( float number )
{
	long i;
	float x2, y;
	const float threehalfs = 1.5F;

	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;                       // evil floating point bit level hacking
	i  = 0x5f3759df - ( i >> 1 );               // what the fuck? 
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
//	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed

	return y;
}
```