[bits 16]         ; Se quiere escribir codigo de 16 bits
jmp start         ; Saltamos directamente a la etiqueta
                  ; que contiene el codigo de nuestro
                  ; bootloader.


start:
    mov ah, 0x00  ; Servicio de modo video
    mov al, 0x00  ; Modo de video 0x00
    int 0x10      ; Interupcion 10H al BIOS

    mov ah, 0x0e  ; Servicio de texto en Modo teletipo
    mov al, 'H'   ; Mover el valor del caracter 'H' al registro al
    int 0x10      ; Interrupcion al BIOS mediante 10h

    jmp $


times 510 -( $ - $$ ) db 0 ; Rellenar con valores nulos
                           ; hasta que se alcance 510 bytes
dw 0xaa55                  ; escribir al final del binario 
                           ; los bytes 0xaa y 0x55 para
                           ; firmar el MBR