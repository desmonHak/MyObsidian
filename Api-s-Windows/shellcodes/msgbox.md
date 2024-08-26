Compilar con:
```bash
nasm -f win64 output.asm
gcc output.obj -o output.exe -nostartfiles -luser32 -lgdi32 -luser32
```

Código 1:
```js
default rel         ; Utiliza por defecto el direccionamiento relativo RIP como [rel msg].

; funciones globales a exportar:
global WinMain

extern ExitProcess  ; funciones externas en las bibliotecas del sistema
extern MessageBoxA

section .text
WinMain:
    push rbp
    mov rbp, rsp
    and rsp, 0fffffffffffffff0h ; asegúrese de que la pila está alineada a 16 bytes   

    sub rsp, 32

    %define BASE_STACk rbp
    mov byte  [BASE_STACk-0x2], 0x00 ; var = n holaaaaaaa mundo\0
    mov rax, 0x6f646e756d206161 ; var =  holaaaaaaa mundo\0
    mov   [BASE_STACk-0xa], RAX ; var =  holaaaaaaa mundo\0
    mov rax, 0x61616161616c6f68 ; var =  holaaaaaaa mundo\0
    mov   [BASE_STACk-0x12], RAX ; var =  holaaaaaaa mundo\0


    ;sub rsp, 28h      ; reservar shadow space y hacer RSP % 16 == 0

    ; int MessageBoxA(
    ;   [in, optional] HWND   hWnd      = HWND_DESKTOP,
    ;   [in, optional] LPCSTR lpText    = BASE_STACk - 0x12,
    ;   [in, optional] LPCSTR lpCaption = BASE_STACk - 0x12,
    ;   [in]           UINT   uType     = MB_OK
    ; );

    mov rcx, 0                   ; hWnd = HWND_DESKTOP
    ;lea rdx, [rax]              ; LPCSTR lpText
    lea rdx, [BASE_STACk - 0x12] ; LPCSTR lpText
    lea r8,  [BASE_STACk - 0x12] ; LPCSTR lpCaption
    mov r9d, 0                   ; uType = MB_OK
    call MessageBoxA             ; eax = MessageBoxA(HWND_DESKTOP, mssg, mssg, MB_OK)

    mov  ecx, eax                ; exit status = return value of MessageBoxA
    call ExitProcess             ; ExitProcess(ecx = eax)

    ;add rsp, 28h                ; si fueras a retirarte, restaura RSP

    ret
```

Código 2:
```js
default rel         ; Utiliza por defecto el direccionamiento relativo RIP como [rel msg].

; funciones globales a exportar:
global WinMain

extern ExitProcess  ; funciones externas en las bibliotecas del sistema
extern MessageBoxA

section .text
WinMain:
    push rbp
    mov rbp, rsp
    and rsp, 0fffffffffffffff0h ; asegúrese de que la pila está alineada a 16 bytes   

    jmp salt
    mssg:    db 'Hello world!', 0
    salt:

    ;sub rsp, 28h      ; reservar shadow space y hacer RSP % 16 == 0

    ; int MessageBoxA(
    ;   [in, optional] HWND   hWnd       = HWND_DESKTOP,
    ;   [in, optional] LPCSTR lpText     = BASE_STACk - 0x12,
    ;   [in, optional] LPCSTR lpCaption,
    ;   [in]           UINT   uType
    ; );

    mov rcx, 0        ; hWnd = HWND_DESKTOP
    ;lea rdx, [rax]   ; LPCSTR lpText
    lea rdx, [mssg]   ; LPCSTR lpText
    lea r8,  [mssg]   ; LPCSTR lpCaption
    mov r9d, 0        ; uType = MB_OK
    call MessageBoxA  ; eax = MessageBoxA(HWND_DESKTOP, mssg, mssg, MB_OK)

    mov  ecx, eax     ; exit status = return value of MessageBoxA
    call ExitProcess  ; ExitProcess(ecx = eax)

    ;add rsp, 28h     ; si fueras a retirarte, restaura RSP

    ret
```

```c
int MessageBoxA(
  [in, optional] HWND   hWnd,
  [in, optional] LPCSTR lpText,
  [in, optional] LPCSTR lpCaption,
  [in]           UINT   uType
);
```

Normalmente, un trozo de memoria "empieza" en la dirección más baja y "acaba" en la dirección más alta del intervalo.
```c
0 ...  <-------------------------->  ...
       |                           |
       Comienzo                  final
```

La [pila](sp-bp-pila) es diferente, la [pila](sp-bp-pila) crece hacia abajo. Una nueva asignación que haces "empieza" en una dirección más alta y "termina" en una dirección más baja. 
```c
0 ...  <-------------------------->  ...
       |                           |
       Comienzo                  Final
       Nuevo RSP                Antiguo RSP
       Top-Of-Stack 
```

Para aumentar la confusión, esta dirección inferior ahora recibe el nombre de ``"Top-Of-Stack"(parte superior de la pila)``, que definitivamente tampoco es intuitivo para la palabra 'top'. (Nada de esta confusión existiría si sólo la pila creciera hacia arriba...)

```js
push rbp
mov rbp, rsp
sub rsp, 16
mov [rbp - 8], rdi
mov [rbp - 16], rsi
```
Tu fragmento de código contiene 2 asignaciones de memoria de pila: ``push rbp`` solicita ``8 bytes``, y ``sub rsp, 16`` solicita ``16 bytes``. Una vez asignada, eres libre de leer/escribir desde/a esta memoria. En el caso de ``push rbp`` es la CPU la que escribe en la memoria.
```c
0 ...  <---RSI------RDI------RBP-->  ...
       |         |        |        |
       Comienzo  |        |      Final
       Nuevo RSP |        |     Antiguo RSP
       Nuevo Top-Of-Stack |     Antiguo Top-Of-Stack
       |         |        |
       [RBP-16]  [RBP-8]  [RBP]
```

La pila en 64bits a de estar alineada a 16bytes, para eso puede hacer esta operación:
```js
and rsp, 0x0fffffffffffffff0 ; asegúrese de que la pila está alineada a 16 bytes
```

En ``64bits`` para poder llamar a funciones Windows de la [[WinApi]] es necesario usar la convención [[__fastcall]] mientras que para 32bits se usa la [[__stdcall]]