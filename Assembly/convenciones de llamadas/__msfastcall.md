[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)
https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/windows-x64-calling-convention-stack-frame

La convención [[__fastcall]] de Microsoft (también conocida como \_\_msfastcall) pasa los dos primeros argumentos (evaluados de izquierda a derecha) que caben, a ``ECX`` y ``EDX``.[6] Los argumentos restantes se introducen en la pila de derecha a izquierda. Cuando el compilador compila para ``IA64`` o ``AMD64``, ignora la palabra clave [[__fastcall]] (o cualquier otra palabra clave de convención de llamada aparte de [[__vectorcall]]) y utiliza en su lugar la convención de llamada de ``64 bits`` por defecto de Microsoft.

Otros compiladores como [GCC](https://en.wikipedia.org/wiki/GNU_Compiler_Collection "GNU Compiler Collection"),[7](https://en.wikipedia.org/wiki/X86_calling_conventions#cite_note-7) [Clang](https://en.wikipedia.org/wiki/Clang "Clang"),[8](https://en.wikipedia.org/wiki/X86_calling_conventions#cite_note-8) and [ICC](https://en.wikipedia.org/wiki/Intel_C%2B%2B_Compiler) proporcionan convenciones de llamada "``fastcall``" similares, aunque no son necesariamente compatibles entre sí o con ``Microsoft`` [[__fastcall]][9].

Considere el siguiente fragmento de C:
```c
__attribute__((fastcall)) void printnums(int num1, int num2, int num3){
	printf("The numbers you sent are: %d %d %d", num1, num2, num3);
}

int main(){
	printnums(1, 2, 3);
	return 0;
}
```

La descompilación x86 de la función main tendrá el siguiente aspecto (en sintaxis Intel)
```js
main:
	              ; stack setup
	push ebp
	mov ebp, esp
	
	push 3        ; inmediato 3 (tercer argumento es empujado a la pila)
	mov edx, 0x2  ; el inmediato 2 (segundo argumento) se copia al registro edx.
	mov ecx, 0x1  ; el inmediato 1 (primer argumento) se copia en el registro 
	call printnums
	
	mov eax, 0    ; retorna 0
	leave
	retn
```
Los dos primeros argumentos se pasan en el orden de izquierda a derecha, y el tercer argumento se coloca en la pila. No hay limpieza de pila, ya que ésta la realiza la función llamada. El desensamblado de la función ``callee`` es:

```js
printnums:
	; stack setup
	push ebp
	mov ebp, esp
	sub esp, 0x08
	
	mov [ebp-0x04], ecx  ; en x86, ecx = primer argumento.
	mov [ebp-0x08], edx  ; arg2
	
	push [ebp+0x08]      ; arg3 es empujado a la pila.
	push [ebp-0x08]      ; arg2 es empujado.
	push [ebp-0x04]      ; arg1 es empujado
	push 0x8065d67       ; "Los números que enviaste son %d %d %d"
	call printf
					     ; limpieza de pila
	add esp, 0x10
	nop
	leave
	retn 0x04
```
Como los dos argumentos fueron pasados a través de los registros y sólo un parámetro fue empujado en la pila, el valor empujado está siendo limpiado por la instrucción ``retn``, ya que ``int`` tiene un tamaño de ``4 bytes`` en sistemas x86.

# Cuando se llama a una función en un binario de Windows x64, el marco de pila se utiliza de la siguiente manera:
https://learn.microsoft.com/en-us/cpp/build/stack-usage?view=msvc-170&viewFallbackFrom=vs-2019

Cuando se llama a una función en un binario de Windows x64, el marco de pila se utiliza de la siguiente manera:

- Los primeros cuatro argumentos enteros se pasan a los registros ``RCX``, ``RDX``, ``R8`` y ``R9`` según corresponda (verde)
- Los argumentos 5, 6 y siguientes se colocan en la pila (azul).
- La dirección de retorno a la que se inserta la siguiente instrucción del llamador se encuentra en ``RSP + 0x0`` (amarillo)
- Debajo de la dirección de retorno (``RSP + 0x0``) siempre se asignan ``32 bytes`` para ``RCX``, ``RDX``, ``R8`` y ``R9``, incluso si el llamador utiliza menos de 4 argumentos
- Las variables locales y los registros no volátiles se almacenan sobre la dirección de retorno (rojo)
- ``RBP`` no se utiliza para hacer referencia a variables locales/argumentos de función (excepto cuando las funciones utilizan ``alloca()``) como solía ser el caso para X86. ``RSP`` es responsable de eso, por lo tanto, el valor de ``RSP`` no cambia en todo el cuerpo de la función ([[PUSH]] y [[POP]] solo se utilizan para el epílogo/prólogo).
![[Pasted image 20241103172106.png]]

Como ejemplo, echemos un vistazo a la función msv1_0.``LsaInitializePackage`` en Ghidra.
A continuación, se muestra cómo se almacenan los primeros cuatro argumentos en ``ECX`` (parte inferior de ``RCX``), ``RDX``, ``R8`` y ``R9``:
![[Pasted image 20241103172216.png]]