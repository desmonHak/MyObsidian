Propias de NASM:
```c
%define GET_DATE         __DATE__         ; "2010-01-01" 
%define GET_TIME         __TIME__         ; "00:00:42" 
%define GET_DATE_NUM     __DATE_NUM__     ; 20100101 
%define GET_TIME_NUM     __TIME_NUM__     ; 000042 
%define GET_UTC_DATE     __UTC_DATE__     ; "2009-12-31" 
%define GET_UTC_TIME     __UTC_TIME__     ; "21:00:42" 
%define GET_UTC_DATE_NUM __UTC_DATE_NUM__ ; 20091231 
%define GET_UTC_TIME_NUM __UTC_TIME_NUM__ ; 210042 
%define GET_POSIX_TIME   __POSIX_TIME__   ; 1262293242
```

Estas macros de NASM son para codificaciones:
```c
; The special operators __utf16__, __utf16le__, __utf16be__, 
; __utf32__, __utf32le__ and __utf32be__ allows definition of 
; Unicode strings. They take a string in UTF-8 format and 
; converts it to UTF-16 or UTF-32, respectively. Unless the be 
; forms are specified, the output is littleendian.

%define u(x) __utf16__(x)
%define w(x) __utf32__(x)

dw u('C:\WINDOWS'), 0       ; Pathname in UTF-16
dd w(`A + B = \u206a`), 0   ; String in UTF-32
```

Macros para aumentar legibilidad de los [[saltos]]
```c
; OF = 1 
%define JumpIfOverflow(symbol) jo symbol
; OF = 0 
%define JumpIfNotOverflow(symbol) jno symbol
; SF = 1 
%define JumpIfSign(symbol) js symbol
; SF = 0 
%define JumpIfNotSign(symbol) jns symbol
; ZF = 1 	 
%define JumpIfEqual(symbol) je symbol
;ZF = 0
%define JumpIfNotEqual(symbol) jne symbol
; ZF = 1 	 
%define JumpIfZero(symbol) jz symbol
; ZF = 0 
%define JumpIfNotZero(symbol) jnz symbol
```

macros para usar [[Registros|registros]] del tamaño de palabra de la CPU: 
```c
%if __BITS__ == 64
%define SIZE_T_DATA DQ  
%define SIZE_T_BSS  RESQ 
%define RESB_size_t  RESQ
%define SIZE_T_SIZE_OPERATION QWORD
%define TOP_STACk   RSP
%define BASE_STACk  RBP
%define SIZE_T_INDEICE_ORIGEN  RSI
%define SIZE_T_INDEICE_DESTINO RDI
%define SIZE_T_ACUMLADOR       RAX
%define SIZE_T_BASE            RBX
%define SIZE_T_CONTADOR        RCX
%define SIZE_T_DATOS           RDX
%elif __BITS__ == 32
%define SIZE_T_DATA DD  
%define SIZE_T_BSS  RESD 
%define RESB_size_t  RESD 
%define SIZE_T_SIZE_OPERATION DWORD
%define TOP_STACk   ESP
%define BASE_STACk  EBP
%define SIZE_T_INDEICE_ORIGEN  ESI
%define SIZE_T_INDEICE_DESTINO EDI
%define SIZE_T_ACUMLADOR       EAX
%define SIZE_T_BASE            EBX
%define SIZE_T_CONTADOR        ECX
%define SIZE_T_DATOS           EDX
%elif __BITS__ == 16
%define SIZE_T_DATA DW  
%define SIZE_T_BSS   RESW 
%define RESB_size_t  RESW 
%define SIZE_T_SIZE_OPERATION WORD
%define TOP_STACk   SP
%define BASE_STACk  BP
%define SIZE_T_INDEICE_ORIGEN  SI
%define SIZE_T_INDEICE_DESTINO DI
%define SIZE_T_ACUMLADOR       AX
%define SIZE_T_BASE            BX
%define SIZE_T_CONTADOR        CX
%define SIZE_T_DATOS           DX
%endif
```

Macros para guardar y restaurar el antiguo [[stack frame]]:
```c
%macro SAVE_OLD_STACK_FRAME 0
    push BASE_STACk
    mov  BASE_STACk, TOP_STACk
%endmacro

%macro GET_OLD_STACK_FRAME 0
    %if __BITS__ == 32 || __BITS__ == 64
        leave  
    %elif __BITS__ == 16
        mov TOP_STACk, BASE_STACk
        pop BASE_STACk
    %endif
    ret
%endmacro
```

En [[win_const.asm]] se define algunas macros para windows.