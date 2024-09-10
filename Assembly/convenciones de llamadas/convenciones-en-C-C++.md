https://www.geeksforgeeks.org/calling-conventions-in-c-cpp/
En la programación en ``C/C++``, una convención de llamada es un conjunto de reglas que especifican cómo se llamará a una función. Es posible que haya visto palabras clave como [[__cdecl]] o [[__stdcall]] cuando recibe errores de enlace. Por ejemplo:

```ruby
error LNK2019: símbolo externo no resuelto "void **__cdecl** A(void)" (?A@@YAXXZ) referenciado en la función _main
```
Aquí, vemos que se utiliza [[__cdecl]]. Es una de las convenciones de llamada en ``C/C++``. También puede ver código como este en bibliotecas de terceros.

#### Por ejemplo:

```c
extern __m128i __cdecl _mm256_mask_cvtepi32_epi16(__m128i, __mmask8, __m256i);
```

#### ¿Qué son el llamador(``caller``) y el destinatario(``callee``)?
Cuando llamamos a una función, se le asigna un [[stack-frame]](marco de pila), se le pasan argumentos y, una vez que la función realiza su trabajo, se libera el [[stack-frame]](marco de pila) asignado y se pasa el control a la función que llama.

La función que llama a la subrutina se denomina ``caller``. La función que recibe la llamada (es decir, la subrutina) del llamador se denomina ``callee``.
```cpp
// C++ Program to illustrate the caller and callee 
#include <iostream> 
  
// callee 
void func() { std::cout << "Geeks"; } 
  
// caller 
int main() 
{ 
  
    // function call 
    func(); 
  
    return 0; 
}
```
#### Convenciones de llamada
Las convenciones de llamada en ``C/C++`` son las pautas que determinan:
- Cómo se pasan los argumentos a la pila.
- ¿Quién limpiará la pila, el que llama o el que recibe la llamada?
- ¿Qué registros se utilizarán y cómo?
#### Sintaxis

La siguiente sintaxis muestra cómo utilizar la convención de llamada:
```c
return_type calling_convention function_name { 
    // statements__  
}
```
El código ``C++`` se convierte en código objeto al final de la etapa de compilación. Luego obtenemos el archivo objeto. Los archivos objeto se vinculan entre sí para crear un archivo binario (``exe``, ``lib``, ``dll``).

Antes de la creación del archivo objeto, podemos indicarle al compilador que se detenga y nos entregue el archivo ``.asm``. Este es el archivo de ensamblaje que se convertirá en un archivo objeto. Diferentes convenciones de llamada producen diferentes códigos de ensamblaje. Para ``GCC``, se puede usar ``-S`` para este propósito. Simplemente pase este indicador mientras compila el código.

```bash
gcc -S sourceFileName.c -masm=intel
```

#### Diferentes convenciones de llamada
Existen muchas convenciones de llamada para diferentes plataformas. Vamos a ver las convenciones de llamada ``x86`` de ``32 bits``.
[[__cdecl]]
[[__stdcall]]
[[__fastcall]]
[[__thiscall]] (solo ``C++``)

#### Ejemplo de convención de llamada
El siguiente programa ilustra cómo utilizar la convención de llamada.
```cpp
// C++ Program to demonstrate the calling convention 
#include <iostream> 
  
// __cdecl calling convention 
int __cdecl cdeclAdd(int a, int b) 
{ 
    int c = a + b; 
    return c; 
} 
  
// __stdcall calling convention 
int __stdcall stdcallAdd(int a, int b) 
{ 
    int c = a + b; 
    return c; 
} 
  
// __fastcall calling convention 
int __fastcall fastcallAdd(int a, int b, int c, int d) 
{ 
    int e = a + b + c + d; 
    return e; 
} 
  
// __thiscall calling convention 
class Temp { 
public: 
    int __thiscall thiscallAdd(int a, int b) 
    { 
        int c = a + b; 
        return c; 
    } 
}; 
  
// driver code 
int main() 
{ 
    int result; 
    Temp obj; 
  
    // Function calls and output 
    result = cdeclAdd(1, 2); 
    std::cout << "Result: " << result << std::endl; 
  
    result = stdcallAdd(3, 4); 
    std::cout << "Result: " << result << std::endl; 
  
    result = fastcallAdd(7, 8, 9, 10); 
    std::cout << "Result: " << result << std::endl; 
  
    result = obj.thiscallAdd(5, 6); 
    std::cout << "Result: " << result << std::endl; 
}
```
Aquí tenemos 4 funciones: ``cdeclAdd()``, ``stdcallAdd()``, ``fastcallAdd()`` y ``thiscallAdd()`` con convenciones de llamada [[__cdecl]], [[__stdcall]], [[__fastcall]] y [[__thiscall]] respectivamente. Las llama el llamador, es decir, ``main()``. Veamos cada una de ellas una por una.

## [[__cdecl]]
La convención de llamada [[__cdecl]] es la convención de llamada **** predeterminada **** en ``C/C++``. En esta convención de llamada:

> - Los argumentos se envían de **Derecha a Izquierda** (de modo que el primer argumento esté más cerca de la parte superior de la pila).
> - **El llamador limpia la pila**. 
> - Crea ejecutables más grandes que [[__stdcall]], porque requiere que cada llamada de función incluya código de limpieza de la pila.

A medida que el llamador limpia la pila en esta convención, podemos proporcionar argumentos variables a las funciones con la convención de llamada [[__cdecl]].

Al compilar el programa anterior en modo de depuración usando código ensamblador, obtenemos:
**main()::result = cdeclAdd(1, 2);**
```r
line 42:     
    push    2
    push    1
    call    ?cdeclAdd@@YAHHH@Z            ; cdeclAdd 
    add    esp, 8
    mov    DWORD PTR _result$[ebp], eax
```

> ****Nota:**** Si usa el modo de lanzamiento(`Release`), es posible que no vea las variables que pasan a la pila de esta manera, ya que el compilador producirá código optimizado.

La función con convención de llamada [[__cdecl]] es ``cdeclAdd()``, que se llama en la ``línea 42`` de la función ``main``.
```r
?cdeclAdd@@YAHHH@Z PROC                    ; cdeclAdd, COMDAT
; File c:\users\ruchit\documents\code\visual studio\visual studio\source.cpp 
; Line 6
    push    ebp 
    mov    ebp, esp 
    sub    esp, 204                ; 000000ccH 
    push    ebx 
    push    esi 
    push    edi 
    lea    edi, DWORD PTR [ebp-204] 
    mov    ecx, 51                    ; 00000033H
    mov    eax, -858993460                ; ccccccccH 
    rep stosd 
    mov    ecx, OFFSET __F81044A6_source@cpp
    call    @__CheckForDebuggerJustMyCode@4
; Line 7
    mov    eax, DWORD PTR _a$[ebp] 
    add    eax, DWORD PTR _b$[ebp] 
    mov    DWORD PTR _c$[ebp], eax 
; Line 8
    mov    eax, DWORD PTR _c$[ebp] 
; Line 9
    pop    edi 
    pop    esi 
    pop    ebx 
    add    esp, 204                ; 000000ccH 
    cmp    ebp, esp 
    call    __RTC_CheckEsp 
    mov    esp, ebp 
    pop    ebp 
    ret    0
?cdeclAdd@@YAHHH@Z ENDP                    ; cdeclAdd
```
**Explicación**: Cuando observamos el código ensamblador de ``cdeclAdd()``, la última declaración es: ``ret 0``. Esto significa que el destinatario no hará nada con el puntero de pila y el control regresa a ``main()``.

Si observamos el código ensamblador en ``main()``, después de la llamada a la función, hay otra declaración: ``add esp, 8``. Cuando el control regresa a ``main``, agregará en el puntero de pila(``esp``) ``8 bytes``. Agregar en memoria significa que estamos sacando de la pila o limpiando la pila. Si restamos de ``esp``, esto significa que estamos empujando a la pila. La pila crece en orden inverso con respecto a la memoria. Véase [[sp-bp-pila]].
> ****Nota:**** Aquí estamos incrementando `8 bytes` en `esp` porque estamos eliminando 2 variables enteras pasadas. Dado que cada variable entera en la arquitectura de `32 bits` tiene `4 bytes`, estamos borrando `8 bytes` de memoria para ambas variables.

Esto significa que quien llama(**caller**) (es decir, ``main``) limpiará la pila y no el llamado(**callee**) (es decir, ``cdeclAdd``).

## [[__stdcall]]

Esta es una convención de llamada específica de Microsoft que utilizan las funciones de la [[WinApi]] en ``32bits``. Para la [[WinApi]] en 64bits se usa [[__fastcall]]. En esta convención:

> - Los argumentos se envían de derecha a izquierda.
> - El destinatario limpia la pila.

****main()::result = stdcallAdd(3, 4);****
```r
line 45:     
    push    4
    push    3
    call    ?stdcallAdd@@YGHHH@Z            ; stdcallAdd 
    mov    DWORD PTR _result$[ebp], eax
```
Al igual que ``cdeclAdd()``, vemos que los argumentos se pasan de derecha a izquierda.

En la ``línea 42`` del código de ensamblaje, vemos que los argumentos se pasan de derecha a izquierda para la llamada de función: ``stdcallAdd(3, 4)``

La función con la convención de llamada [[__stdcall]] es ``stdcallAdd()``, que se llama en la ``línea 42`` de la función ``main``. Si observamos el código de ensamblaje de ``main(),`` después de la llamada de función, no hay ninguna declaración para el puntero de pila. Termina con la llamada de función.
****stdcallAdd()****
```r
?stdcallAdd@@YGHHH@Z PROC                ; stdcallAdd, COMDAT
; File c:\users\ruchit\documents\code\visual studio\visual studio\source.cpp 
; Line 13
    push    ebp 
    mov    ebp, esp 
    sub    esp, 204                ; 000000ccH 
    push    ebx 
    push    esi 
    push    edi 
    lea    edi, DWORD PTR [ebp-204] 
    mov    ecx, 51                    ; 00000033H
    mov    eax, -858993460                ; ccccccccH 
    rep stosd 
    mov    ecx, OFFSET __F81044A6_source@cpp
    call    @__CheckForDebuggerJustMyCode@4
; Line 14
    mov    eax, DWORD PTR _a$[ebp] 
    add    eax, DWORD PTR _b$[ebp] 
    mov    DWORD PTR _c$[ebp], eax 
; Line 15
    mov    eax, DWORD PTR _c$[ebp] 
; Line 16
    pop    edi 
    pop    esi 
    pop    ebx 
    add    esp, 204                ; 000000ccH 
    cmp    ebp, esp 
    call    __RTC_CheckEsp 
    mov    esp, ebp 
    pop    ebp 
    ret    8
?stdcallAdd@@YGHHH@Z ENDP                ; stdcallAdd
```

**Explicación**: Cuando observamos el código ensamblador de ``stdcallAdd()``, la última instrucción es: ``ret 8``. Esto significa que incrementa el puntero de pila en ``8 bytes`` y elimina las 2 variables que se le pasaron. Luego, el control regresa a ``main()``.

Esto significa que el destinatario (es decir, ``stdcallAdd``) limpiará la pila y no el autor de la llamada (es decir, ``main``).

## [[__fastcall]]

En la convención de llamada [[__fastcall]], los argumentos se pasan al registro si es posible.

> - Los dos primeros argumentos se pasan en el registro `ECX` y `EDX`. Los argumentos restantes se pasan en la pila de derecha a izquierda.
> - El destinatario de la llamada limpia la pila.

Volviendo al código ensamblador de la función ``main``, la declaración
****main()::return = fastcallAdd(7, 8, 9, 10);****
```r
; Line 48
    push    10                    ; 0000000aH 
    push    9
    mov    edx, 8
    mov    ecx, 7
    call    ?fastcallAdd@@YIHHHHH@Z            ; fastcallAdd 
    mov    DWORD PTR _result$[ebp], eax
```

En ``fastcallAdd``, los argumentos se introducen en la pila en orden de derecha a izquierda, luego los 2 argumentos que quedan se introducen en los registros ``EDX`` y ``ECX`` respectivamente. (O podemos decir que los 2 primeros argumentos se pasan a ``ECX`` y ``EDX`` en orden de izquierda a derecha)

La función con la convención de llamada [[__fastcall]] es ``fastcallAdd()``, que se llama en la ``línea 48`` de la función ``main``. Hemos visto cómo se pasan los argumentos a la pila. Sabemos que, dado que el llamador, es decir, ``main``, no hace nada con el puntero de la pila, es el trabajo del llamador limpiar la pila.

```r
?fastcallAdd@@YIHHHHH@Z PROC                ; fastcallAdd, COMDAT
; _a$ = ecx 
; _b$ = edx 
; File c:\users\ruchit\documents\code\visual studio\visual studio\source.cpp 
; Line 20
    push    ebp 
    mov    ebp, esp 
    sub    esp, 228                ; 000000e4H 
    push    ebx 
    push    esi 
    push    edi 
    push    ecx 
    lea    edi, DWORD PTR [ebp-228] 
    mov    ecx, 57                    ; 00000039H
    mov    eax, -858993460                ; ccccccccH 
    rep stosd 
    pop    ecx 
    mov    DWORD PTR _b$[ebp], edx 
    mov    DWORD PTR _a$[ebp], ecx 
    mov    ecx, OFFSET __F81044A6_source@cpp
    call    @__CheckForDebuggerJustMyCode@4
; Line 21
    mov    eax, DWORD PTR _a$[ebp] 
    add    eax, DWORD PTR _b$[ebp] 
    add    eax, DWORD PTR _c$[ebp] 
    add    eax, DWORD PTR _d$[ebp] 
    mov    DWORD PTR _e$[ebp], eax 
; Line 22
    mov    eax, DWORD PTR _e$[ebp] 
; Line 23
    pop    edi 
    pop    esi 
    pop    ebx 
    add    esp, 228                ; 000000e4H 
    cmp    ebp, esp 
    call    __RTC_CheckEsp 
    mov    esp, ebp 
    pop    ebp 
    ret    8
?fastcallAdd@@YIHHHHH@Z ENDP                ; fastcallAdd
```

****Explicación****
Aquí, podemos ver que el puntero de la pila se incrementa solo con ``8 bytes``. Solo estamos extrayendo dos enteros de ``4 bytes`` de la pila. Esto se debe a que los otros 2 argumentos se pasan a los registros ``ECX`` y ``EDX``. Por lo tanto, solo necesitamos extraer los 2 argumentos que están en la pila.

## [[__thiscall]]

La convención de llamada [[__thiscall]] es la convención de llamada predeterminada que utilizan los métodos dentro de una clase. Es por eso que solo es posible en ``C++`` pero no en C. En esta convención:

> - Los argumentos se insertan en la pila de derecha a izquierda.
> - El puntero `this` se pasa a través del registro `ECX` y no en la pila.
> - Dado que también pasamos el puntero `this`, no podemos usar esta convención de llamada para funciones que no sean miembros.
> - El destinatario limpia la pila.

Veamos el código ensamblador para main():
****result = obj.thiscallAdd(5, 6);****
```r
; Line 51
    push    6
    push    5
    lea    ecx, DWORD PTR _obj$[ebp] 
    call    ?thiscallAdd@Temp@@QAEHHH@Z        ; Temp::thiscallAdd
    mov    DWORD PTR _result$[ebp], eax 
```