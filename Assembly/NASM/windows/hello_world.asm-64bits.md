vea también [[hello_world.asm-32bits]].

Compilar con:
```bash
nasm -f win64 hello_world.asm
gcc hello_world.obj -o hello_world.exe -nostartfiles -luser32 -lgdi32 -luser32 -m64
```

```js
default rel         ; Utiliza por defecto el direccionamiento relativo RIP como [rel msg].

section .data exec write
   msg: db "Hola mundo", 0xa, 0x0
   len: equ $ - msg

; definiciones globales:
global WinMain

; definiciones externas:
extern GetStdHandle
extern ExitProcess 
extern WriteFile

section .text
   
   WinMain:
      ; Establecer el marco de pila
      push rbp
      mov rbp, rsp
      sub rbp, 12 ; HANDLE my_handle
                  ; DWORD  my_len    = len, no podemos usar len directamente pues 
                  ;                     este es una directiva equ y no una variable
                  ; y la funcion _WriteFile rquiere un puntero a una variable con la 
                  ; longitud de lpBuffer
  
      mov dword [rbp - 4], len ; DWORD my_len = len;

      mov rcx, -11
      call GetStdHandle    ; GetStdHandle(rcx = -11)
      mov [rbp - 8], rax   ; HANDLE my_handle = eax
   
      ; Llamada a WriteFile
      mov rcx, [rbp - 8]       ; hFile en rcx
      mov rdx, msg             ; lpBuffer en rdx
      mov r8d, len             ; nNumberOfBytesToWrite en r8d (tamaño DWORD)
      lea r9, [rbp - 4]        ; lpNumberOfBytesWritten en r9 (puntero a DWORD)
      mov rax, 0               ; lpOverlapped en rax (registro que usa rsp para más argumentos)
      call WriteFile
   
      ; Salir del programa
      mov rcx, 0               ; Código de salida 0
      call ExitProcess

      ; Restaurar la pila y salir
      mov rsp, rbp
      pop rbp

      ret  
```