[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/cdecl?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/cdecl?view=msvc-170)
**`__cdecl`** es la convención de llamada predeterminada de los programas C y C++. Como el autor de la llamada limpia la pila, puede realizar funciones `vararg`. La convención de llamada **`__cdecl`** crea archivos ejecutables mayores que **[``stdcall``](https://learn.microsoft.com/es-es/cpp/cpp/stdcall?view=msvc-170)**, porque requiere que cada llamada a función incluya código de limpieza de la pila. En la lista siguiente se muestra la implementación de esta convención de llamada. El modificador **``__cdecl``** es específico de Microsoft

|Elemento|Implementación|
|---|---|
|Orden de paso de argumento|De derecha a izquierda.|
|Responsabilidad de mantenimiento de pila|Al llamar a la función, se extraen los argumentos de la pila.|
|Convención de creación de nombres representativos|El carácter de subrayado (_) tiene como prefijo los nombres, excepto cuando se exportan __cdecl funciones que usan la vinculación de C.|
|Convención de traducción de mayúsculas y minúsculas|No se lleva a cabo una traducción de mayúsculas y minúsculas.|
En los procesadores ARM y x64, se acepta el uso de **`__cdecl`**, pero el compilador lo omite normalmente. Por convención en ARM y x64, los argumentos se pasan en registros siempre que es posible y los argumentos subsiguientes se pasan en la pila. En código x64, use **`__cdecl`** para invalidar la opción del compilador **/Gv** y usar la convención de llamada predeterminada de x64.

[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)
__cdecl == Caller clean-up(Limpieza de la llamada)

En este tipo de convenciones de llamada, el invocador limpia los argumentos de la pila (restablece el estado de la pila tal y como estaba antes de llamar a la función invocada).
### cdecl
La cdecl (que significa declaración C) es una convención de llamada para el lenguaje de programación C y es utilizada por muchos compiladores C para la arquitectura x86.[1] En ``cdecl``, los argumentos de la subrutina se pasan a la pila. Si los valores de retorno son enteros o direcciones de memoria, el llamante los coloca en el registro ``EAX``, mientras que los valores de coma flotante se colocan en el registro ST0 ``x87``. Los registros ``EAX``, ``ECX``, y ``EDX`` son guardados por el llamante, y el resto son guardados por el llamante. Los registros x87 de coma flotante ``ST0`` a ``ST7`` deben estar vacíos (``popped`` o ``freed``) al llamar a una nueva función, y ``ST1`` a ``ST7`` deben estar vacíos al salir de una función. ST0 también debe estar vacío cuando no se utilice para devolver un valor.

En el contexto del lenguaje C, los argumentos de función se introducen en la pila en el orden de derecha a izquierda (``RTL``), es decir, el último argumento se introduce primero.

Considere el siguiente fragmento de código fuente C:
```c
int callee(int, int, int);

int caller(void)
{
	return callee(1, 2, 3) + 5;
}
```

En x86, podría producir el siguiente código ensamblador (sintaxis Intel):
```js
caller:
    ; hacer nuevo marco de llamada
    ; (algunos compiladores pueden producir una instrucción 'enter' en su lugar)
    push    ebp       ; save old call frame
    mov     ebp, esp  ; initialize new call frame
    
  ; empujar argumentos de llamada, a la inversa
    ; (algunos compiladores pueden restar el espacio necesario del puntero de la pila,
    ; luego escribir cada argumento directamente, ver abajo.
    ; La instrucción 'enter' también puede hacer algo similar)
    ; sub esp, 12 : La instrucción 'enter' podría hacer esto por nosotros
    ; mov [ebp-4], 3 : o mov [esp+8], 3
    ; mov [ebp-8], 2 : o mov [esp+4], 2
    ; mov [ebp-12], 1 : or mov [esp], 1
    
    push    3
    push    2
    push    1
    call    callee    ; llamar subrutina 'callee'
    add     esp, 12   ; eliminar los argumentos de llamada del marco
    add     eax, 5    ; modifica el resultado de la subrutina
                      ; (eax es el valor de retorno de nuestro callee,
                      ; asi que no tenemos que moverlo a una variable local)
    ; restaurar el antiguo marco de llamada
    ; (algunos compiladores pueden producir una instrucción 'leave' en su lugar)
    mov     esp, ebp  ; la mayoría de las convenciones de llamada dictan que ebp
				      ; sea guardado por la llamada,
                      ; es decir, se preserva después de llamar a la llamada.
                      ; Por lo tanto, sigue apuntando al inicio de nuestra pila.
                      ; Debemos asegurarnos de que
                      ; que el callee no modifique (o restaure) ebp,
                      ; así que tenemos que asegurarnos
                      ; utilice una convención de llamada que haga esto
    pop     ebp       ; restaurar el antiguo marco de llamada
    ret               ; retornar
```
El llamador limpia la pila después de que la llamada a la función retorne.

La convención de llamada ``cdecl`` suele ser la convención de llamada por defecto de los compiladores x86 C, aunque muchos compiladores proporcionan opciones para cambiar automáticamente las convenciones de llamada utilizadas. Para definir manualmente que una función sea ``cdecl``, algunos soportan la siguiente sintaxis:
```c
return_type __cdecl func_name();
```

### Variaciones
Existen algunas variaciones en la interpretación de ``cdecl``. Como resultado, los programas x86 compilados para diferentes plataformas de sistemas operativos y/o por diferentes compiladores pueden ser incompatibles, incluso si ambos utilizan la convención "``cdecl``" y no llaman al entorno subyacente.

Con respecto a cómo devolver valores, algunos compiladores devuelven estructuras de datos simples con una longitud de 2 registros o menos en el par de registros ``EAX:EDX``, y las estructuras más grandes y los objetos de clase que requieren un tratamiento especial por parte del gestor de excepciones (por ejemplo, un constructor, destructor o asignación definidos) se devuelven en memoria. Para pasar "en memoria", el invocador asigna memoria y pasa un puntero a la misma como primer parámetro oculto; el invocador rellena la memoria y devuelve el puntero, haciendo saltar el puntero oculto al volver[2].

En Linux, GCC establece el estándar de facto para las convenciones de llamada. Desde la versión 4.5 de GCC, la pila debe estar alineada a un límite de ``16 bytes`` cuando se llama a una función (las versiones anteriores sólo requerían una alineación de ``4 bytes``)[1][3].

Una versión de cdecl se describe en [[System V ABI]] para sistemas ``i386``.[4]
