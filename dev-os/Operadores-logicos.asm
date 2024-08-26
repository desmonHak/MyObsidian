; cls && nasm -f bin Operadores-logicos.asm -o Operadores-logicos.bin && objdump -b binary -M intel -m i386 -D Operadores-logicos.bin

; La instrucion AND:
; La operación AND bit a bit devuelve 1, 
; si los bits coincidentes de ambos 
; operandos son 1; de lo contrario, 
; devuelve 0. Por ejemplo:
;              Operand1: 	0101
;              Operand2: 	0011
; ----------------------------
; After AND -> Operand1:	0001

; La operación AND se puede utilizar para 
; borrar uno o más bits. Por ejemplo, supongamos 
; que el registro BL contiene 0011 1010. 
; Si necesita borrar los bits de orden superior 
; a cero, haga AND con 0FH.
mov bl, 00111010b   
; b3       3a
and	bl, 00001111b   ; Esto establece BL a 0000 1010
; 80 e3    0f

;               Operand1:   0011 1010
;               Operand2:   0000 1111 = 0xF
; ---------------------------------------
; After AND -> Operand1:	0000 1010

; Si desea verificar si un número dado es 
; impar o par, una prueba simple sería verificar 
; el bit menos significativo del número. 
; Si esto es 1, el número es impar, de lo 
; contrario el número es par.
; Suponiendo que el número está en el registro AL,
; podemos escribir:
mov al, 11111110b     ; numero 14 (par)
; b0        fe
and	al, 00000001b     ; And con 0000 0001
; 24       01
jz    NUMERO_PAR      ; Jump is Zero
; 74 00
NUMERO_PAR:
    ret ; = c3




; La instrucción OR:
; La instrucción OR se utiliza para admitir 
; expresiones lógicas mediante la realización 
; de una operación OR bit a bit. El operador OR
; bit a bit devuelve 1, si los bits coincidentes 
; de uno o ambos operandos son uno. Devuelve 0, 

; si ambos bits son cero.
;               Operand1:   0101
;               Operand2:   0011
; ---------------------------------------
; After OR  -> Operand1:	0111

; La operación OR se puede utilizar para establecer
; uno o más bits. Por ejemplo, supongamos que el 
; registro BL contiene 0011 1010, necesita establecer 
; los cuatro bits de orden inferior, puede realizar 
; operaciones OR con un valor 0000 1111.
mov bl, 00111010b
; b3       3a
or  bl, 00001111b      ; Esto establece BL a 0011 1111
; 80 cb     0f




; La instrucción XOR:
; La instrucción XOR implementa la operación XOR 
; bit a bit. La operación XOR establece el bit 
; resultante en 1, si y solo si los bits de los 
; operandos son diferentes. Si los bits de los 
; operandos son iguales (ambos 0 o ambos 1), 
; el bit resultante se borra a 0.

; si ambos bits son cero.
;               Operand1:   0101
;               Operand2:   0011
; ---------------------------------------
; After XOR -> Operand1:    0110

; Hacer XOR en un operando consigo mismo 
; cambia el operando a 0. Esto se usa para 
; borrar un registro.
xor eax, eax
; 66 31 c0




; La instrucción PRUEBA:
; La instrucción TEST funciona igual que la 
; operación AND, pero a diferencia de la 
; instrucción AND, no cambia el primer operando. 
; Entonces, si necesitamos verificar si un número 
; en un registro es par o impar, también podemos 
; hacerlo usando la instrucción TEST sin cambiar 
; el número original.
test    al, 00000001b
;    a8        01
jz      NUMERO_PAR
; 74 f3




; La instrucción NOT:
; La instrucción NOT implementa la operación NOT 
; bit a bit. El operador NOT invierte los bits 
; en un operando. El operador puede estar en un 
; registro o en la memoria.
;              Operand1:    0101 0011
; After NOT -> Operand1:    1010 1100