disk_load :
    push dx ; Store DX on stack so later we can recall
    ; how many sectors were request to be read ,
    ; even if it is altered in the meantime

    mov ah , 0x02 ; BIOS read sector function
    mov al , dh   ; Read DH sectors
    mov ch , 0x00 ; Select cylinder 0
    mov dh , 0x00 ; Select head 0
    mov cl , 0x02 ; Start reading from second sector ( i.e.
    ; after the boot sector )
    int 0x13      ; BIOS interrupt

    jc disk_error ; Jump if error ( i.e. carry flag set )
    pop dx        ; Restore DX from the stack

    cmp dh , al    ; if AL ( sectors read ) != DH ( sectors expected )
    jne disk_error ; display error message
    ret

;mov bx , 0x9000 ; Load 5 sectors to 0x0000 (ES ):0x9000 (BX)
;mov dh , 5 ; from the boot disk.
;mov dl , 0
;call disk_load
;mov si , [0x9000]
;call print




;mov ah , 0x02 ;funcion de lectura del bios
;mov dl , 0 ; leer drive 0 ( primer floppy drive )
;mov ch , 3 ; selecionar el cilindro 3
;mov dh , 1 ; Select the track on 2nd side of floppy
; disk , since this count has a base of 0
;mov cl , 4 ;slecionar el cuarto sector del track - not
; the 5th , since this has a base of 1.
;mov al , 5 ; lee 5 sectors desde el punto de entrada
; despues , cambia la direcion that we ’d like BIOS to read the
; sectors to , which BIOS expects to find in ES:BX
; ( i.e. segment ES with offset BX).
;mov bx , 0xa000 ; cambiamos ES a 0xa000 de forma indirecta
;mov es , bx
;mov bx , 0x1234 ; cambiamos BX a 0x1234
; en este caso , leemos los datos entre 0xa000:0x1234
; , which the CPU will translate to physical address 0 xa1234
;int 0x13 ; Now issue the BIOS interrupt to do the actual read.
;jc disk_error ; jc is another jumping instruction , that jumps
; only if the carry flag was set.
;actually read in AL is not equal to the number we expected.
;cmp al , < no. sectors expected >
;jne disk_error
disk_error:
    mov ah , 0x0e ; int 10/ ah = 0eh -> scrolling teletype BIOS routine
    mov si , DISK_ERROR_MSG
    .repeat:
	    lodsb				; Get char from string
        ;lods al, BYTE PTR ds:[si]
	    cmp al, 0
	    je .done			; If char is zero, end of string
	    int 0x10    		; Otherwise, print it
	    jmp short .repeat

    .done:
        ret

    DISK_ERROR_MSG : db " Disk read error !" , 0

