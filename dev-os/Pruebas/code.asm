bits 16    ; se especifica que se hara un bin de 16 bits
; cls && nasm -f bin code.asm -o code.bin && objdump -b binary -M intel -m i8086 -D code.bin
; qemu-system-x86_64 code.bin
[org 0x7c00]   ; Cargar codigo en la posicion 0x7c00
               ; no es una instrucion org = origen
               ; Sino una directiva, esta le indica
               ; a nasm, que el codigo de aqui en adelante
               ; se aloje apartir de dicha direcion.
               ; El sector de arranque inicia en la direcion 
               ; de memoria 0x7c00 y finaliza en 0x7e00, lo que
               ; nos otorga unos 512bytes de sector de arranque.
               ; entre 0x7e00 hasta la direcion 0x9fc00. Podemos
               ; situar un area libre de unos 638Kb que podemos
               ; usar como necesitemos. La cantidad de sectores
               ; que tenemos libres con 638Kb es (638*1024)/512
               ; suponiendo que hablamos de sectores de 512bytes,
               ; esto nos da un resultado de 1276 sectores libres.


jmp start      ; Saltamos a la etiqueta con codigo a ejecutar
KERNEL_OFFSET equ 0x1000 ; This is the memory offset to which we will load our kernel
START_SECTOR_BOOT : dw 0x7c00 ; direcion de inicio de arraque
FINALL_SECTOR_BOOT: dw 0x7e00 ; direcion final de arranque
;IN_PROTECT_MODE: db 0         ; Lo cambiaremos a 1 cuando estemos en el modo protegido
HELLO_MSG: db "Hola Mundo", 0xa, 0x0
MSG_LOAD_KERNEL: db "Cargando Kernel...", 0x0
BOOT_DRIVE db 0
MSG_REAL_MODE db " Iniciando en 16 - bit Modo Real" , 0x0
MSG_PROT_MODE db " Se a cambiado a 32 - bit Modo Protegido " , 0x0
%include "code-32.asm"
%include "read_disk.asm"
%include "gdt.asm"
%include "switch-to-pm.asm"
start:                   ; Etiqueta con codigo principal
    mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL , so it ’s
                         ; best to remember this for later.

    mov bp , FINALL_SECTOR_BOOT ; Asignado el puntero base a la zona superior
                    ; del sector de arranque para usarlo como stack.
    mov sp , bp     ; Asignacion de sp para usar la pila.

    ;mov ah, 0x0     ; Cambiar modo de video
    ;mov al, 0x6a    ; 800×600 16-color
    ;int 0x10


    ;mov ah, 0x0C
    ;mov al, 0xA
    ;mov cx, 0x0; /* x location, from 0..3
    ;mov dx, 0xFF; /* y location, from 0..1
    ;.all1:
        ;cmp cx, 0xffff
        ;add cx, 0xf
        ;add dx, 0x1
        ;int 0x10
        ;jne .all1

    ;mov ah, 0x0C    
    ;mov al, 0xD
    ;mov cx, 0xff; /* x location, from 0..3
    ;mov dx, 0x00; /* y location, from 0..1
    ;.all:
        ;cmp dx, 0xffff
        ;add cx, 0x9
        ;add dx, 0xf
        ;int 0x10
        ;jne .all

    mov ah, 0x0     ; Cambiar modo de video
    mov al, 0x02    
    int 0x10
    mov ah , 0x0e ; int 10/ ah = 0eh -> scrolling teletype BIOS routine
    mov si , HELLO_MSG
    .repeat:
	    lodsb				; Get char from string
        ;lods al, BYTE PTR ds:[si]
	    cmp al, 0
	    je .done			; If char is zero, end of string
	    int 0x10    		; Otherwise, print it
	    jmp short .repeat

    .done:
        call load_kernel
        call switch_to_pm

    
    jmp $

[ bits 16]
; load_kernel
load_kernel :
    mov si , MSG_LOAD_KERNEL    ; Print a message to say we are loading the kernel
    .repeat:
	    lodsb				; Get char from string
        ;lods al, BYTE PTR ds:[si]
	    cmp al, 0
	    je .done			; If char is zero, end of string
	    int 0x10    		; Otherwise, print it
	    jmp short .repeat
    .done:

    mov bx , KERNEL_OFFSET      ; Set -up parameters for our disk_load routine , so
    mov dh , 15                 ; that we load the first 15 sectors ( excluding
    mov dl , [ BOOT_DRIVE ]     ; the boot sector ) from the boot disk ( i.e. our
    call disk_load              ; kernel code ) to address KERNEL_OFFSET
    ret




[ bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM :
    mov ebx , MSG_PROT_MODE ; Use our 32 - bit print routine to
    call print_string_pm ; announce we are in protected mode
    call KERNEL_OFFSET ; Now jump to the address of our loaded
    ; kernel code , assume the brace position ,
    ; and cross your fingers. Here we go!


times 510 -( $ - $$ ) db 0 ; calcular los valores 0 de relleno 
               ; para el binario, hasta alcanzar los 510 bytes.
               ; La operacion que realiza es, Tamaño del codigo
               ; mas datos anterior a esta directiva, menos 510: 
               ; 510 - (size_codigo + size_datos).
dw 0xaa55      ; escribir los bytes 0xaa 0x55 al final de archivo 