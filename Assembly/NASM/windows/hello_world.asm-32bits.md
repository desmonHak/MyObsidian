vea también [[hello_world.asm-64bits]].

Compilar con:
```bash
nasm -f win32 hello_world.asm
gcc hello_world.obj -o hello_world.exe -nostartfiles -luser32 -lgdi32 -luser32 -m32
```

Para especificar que usaremos código de 32bits, llamamos a la directiva ``[bits 32]``.

Con `section .text` especificaremos la sección de código y con `section .data` la de datos. Además con las directivas `exec` y ``write`` especificaremos que la sección de datos será ejecutable y escribible.

Con `msg: db "Hola mundo", 0xa, 0x0` creeremos una etiqueta que contiene en este caso el texto``"Hola mundo\n\0"``, siendo el salto de linea el valor hexadecimal ``0xa`` y el carácter nulo y final del string el valor hexadecimal ``0x0``.

Con `global _WinMain@16` especificamos que la ``_WinMain@16`` que definiremos mas adelante, deberá ser publica/global/exportable para el ``linker``. Además con el `@16` especificaremos que se limpie la pila después de que esta función sea llamada, limpiándose ``16bytes`` pues dicha función recibe 4 parenteros de ``4bytes`` cada uno por lo tanto la suma de estos son ``16``:
```c
int __clrcall WinMain(
   [in]           HINSTANCE hInstance,     [ 4bytes ]
   [in, optional] HINSTANCE hPrevInstance, [ 4bytes ]
   [in]           LPSTR     lpCmdLine,     [ 4bytes ]
   [in]           int       nShowCmd       [ 4bytes ]
                                           [16bytes ]
);
```

Con las directivas `extern` de `extern _GetStdHandle@4`, `extern _ExitProcess@4` y `extern _WriteFile@20` indicamos que estas funciones nos las vamos a definir nosotros, sino que se definen en una librería externa que mas tarde enlazaremos usando el ``linker``. Estas funciones en el ejecutable se verán en el apartado de importaciones.

Para definir la función `_WinMain@16` primero guardaremos el antiguo ``stack frame``, consulte [[sp-bp-pila]] , para esto, guardamos la base de la antigua pila del ``stack frame`` anterior con `push ebp` y luego indicaremos que la nueva base de la pila, para el marco de pila actual, será el valor del tope de la pila `mov ebp, esp`.

Ahora reservaremos memoria en la pila, consulto de nuevo [[sp-bp-pila]]. Vamos a reservar en este caso ``8bytes`` pues queremos crear dos variables de tipo ``uint32_t``, es decir variables de ``4bytes``. Para esto restamos al tope de la pila `esp` la cantidad de memoria a reservar que queremos, tal como haría la instrucción ``push``. Para restar usamos ``sub`` de esta manera:
```js
sub esp, 8
```
Ahora podemos acceder a estas dos variable de la siguiente forma:
```c
DWORD NumberOfBytesWritten; // [esp+0] o [ebp-8] 
HANDLE hFile;               // [esp+4] o [ebp-4]
```

La primera, `NumberOfBytesWritten` puede accederse usando `[esp + 0]` o `[ebp - 8]`. Para acceder a la segunda variable, ``hFile`` se puede usando `[esp + 4]` o `[ebp - 4]`.

Una vez hecho esto, podemos guardar el tamaño del ``string``, que es solo un valor numérico, en esta variable usando lo siguiente:
```js
mov dword [ebp + 8], len       ; DWORD  my_len = len
```
Recuerda que len, no es una etiqueta tal como msg, sino que simplemente es una valor que se colocara en donde se indique como si de una macro se tratara, por lo tanto esto no nos vale, pues la función `_WriteFile@20` espera un puntero con el numero de bytes a escribir, y por lo tanto necesitamos esta variable.

A continuación necesitaremos llamar `_GetStdHandle@4` para poder imprimir por consola, para esto ponemos el valor `STD_OUTPUT_HANDLE` que equivale a `-11`, por lo tanto con ``push -11`` ponemos el valor en la pila para que la función lo use y con la instrucción ``call`` llamaremos a la función. El valor retornado es un ``HANDLE``, es decir, un valor de ``32bits`` por lo tanto se almaceno como `eax`, este valor lo guardaremos en `hfile`:
```js
mov [ebp - 4], eax       ; HANDLE my_handle = eax
```

Con nuestros argumentos listos, podemos llamar a la función para que imprima, para esto, pondremos los parámetros del final como primeros valores a ``'pushear'``. Es decir, si `lpOverlapped` es el ultimo argumento de `_WriteFile`, será e primero en ponerse en la pila:
```js
push 0x0             ; LPOVERLAPPED lpOverlapped      = 0
lea eax, [ebp - 8]			   
push eax             ; LPDWORD lpNumberOfBytesWritten = &len
push len             ; DWORD nNumberOfBytesToWrite = my_len
push msg             ; LPCVOID lpBuffer            = msg
push dword [ebp - 4] ; HANDLE   hFile              = my_handle
call _WriteFile@20   ; WriteFile(my_handle, msg, len, &my_len, 0)
```
la instrucción ``lea`` cargara la dirección de memoria que resulte de restar al puntero de `ebp` el valor `8`.

Con la instrucción `leave` haremos lo contrario a:
```js
push ebp
mov  ebp, esp   
```
es decir:
```js
mov esp, ebp
pop ebp
```
Restaurándose el ``stack frame`` anterior para luego mediante la instrucción `ret`  retornar.

```js
[bits 32]

section .data exec write
   msg: db "Hola mundo", 0xa, 0x0
   len: equ $ - msg

; definiciones globales:
global _WinMain@16
; int __clrcall WinMain(
;   [in]           HINSTANCE hInstance,     [ 4bytes ]
;   [in, optional] HINSTANCE hPrevInstance, [ 4bytes ]
;   [in]           LPSTR     lpCmdLine,     [ 4bytes ]
;   [in]           int       nShowCmd       [ 4bytes ]
;                                           [16bytes ]
; );
; se coloca @16 pues la cantidad de bytes a limpiar de la pila, son 16

; definiciones externas:
extern _GetStdHandle@4  ; @4  pues se limpia  4bytes de la pila
   ; HANDLE WINAPI GetStdHandle(
   ;   _In_ DWORD nStdHandle                [ 4bytes ]
   ; );
   ;
   ; Recupera un identificador del dispositivo estándar especificado 
   ; (entrada estándar, salida estándar o error estándar).

extern _ExitProcess@4   ; @4  pues se limpia  4bytes de la pila
   ; void ExitProcess(
   ;  [in] UINT uExitCode                    [ 4bytes ]
   ; );
   ;
   ; Finaliza el proceso de llamada y todos sus subprocesos
   
extern _WriteFile@20    ; @20 pues se limpia 20bytes de la pila
   ; BOOL WriteFile(
   ;   [in]                HANDLE       hFile,                   [ 4bytes ]
   ;   [in]                LPCVOID      lpBuffer,                [ 4bytes ]
   ;   [in]                DWORD        nNumberOfBytesToWrite,   [ 4bytes ]
   ;   [out, optional]     LPDWORD      lpNumberOfBytesWritten,  [ 4bytes ]
   ;   [in, out, optional] LPOVERLAPPED lpOverlapped             [ 4bytes ]
   ;                                                             [20bytes ]
   ; );
   ;
   ; Escribe datos en el archivo o en el dispositivo de entrada y salida 
   ; (E/S) especificados. Esta función está diseñada para la operación 
   ; sincrónica y asincrónica.

section .text
   
   _WinMain@16:

      push ebp
      mov ebp, esp   
   
      sub esp, 8  ; HANDLE my_handle
                  ; DWORD  my_len    = len, no podemos usar len directamente pues 
                  ;                     este es una directiva equ y no una variable
                  ; y la funcion _WriteFile rquiere un puntero a una variable con la 
                  ; longitud de lpBuffer

      mov dword [ebp + 8], len       ; DWORD  my_len = len
   
      ; HANDLE my_handle = GetStdHandle(nStdHandle = STD_OUTPUT_HANDLE[-11]);
      push -11
      call _GetStdHandle@4 ; eax = GetStdHandle(-11);
      mov [ebp - 4], eax       ; HANDLE my_handle = eax
   
      push 0x0             ; LPOVERLAPPED lpOverlapped = 0
      lea eax, [ebp - 8]			   
      push eax             ; LPDWORD      lpNumberOfBytesWritten = &len
      push len             ; DWORD        nNumberOfBytesToWrite  = my_len
      push msg             ; LPCVOID      lpBuffer               = msg
      push dword [ebp - 4] ; HANDLE       hFile                  = my_handle
      call _WriteFile@20   ; WriteFile(my_handle, msg, len, &my_len, 0)
     
      leave
      ret
```

