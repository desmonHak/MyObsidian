```js
<operation>{cond}{S} Rd,Rn,Operand2
```

Esta es la forma general de las instrucciones aritméticas y lógicas. Muchas instrucciones tienen una sintaxis similar, pero no son idénticas.

En la línea de sintaxis, las llaves indican las partes opcionales.

El registro Rd más a la izquierda es el destino.

Las instrucciones suelen ser de un solo ciclo (excepto la escritura en PC y el desplazamiento controlado por registro).

Existe una versión revisada del lenguaje ensamblador, introducida recientemente por ARM, llamada UAL (Lenguaje Ensamblador Unificado). Entre otros cambios, esta permite que el código de condición vaya después de las banderas.

`<operation>`

- `ADD` – Add
    - Rd := Rn + Operand2
- `ADC` – Add with Carry
    - Rd := Rn + Operand2 + Carry
- `SUB` – Subtract
    - Rd := Rn − Operand2
- `SBC` – Subtract with Carry
    - Rd := Rn − Operand2 − NOT(Carry)
- `RSB` – Reverse Subtract
    - Rd := Operand2 − Rn
- `RSC` – Reverse Subtract with Carry
    - Rd := Operand2 − Rn − NOT(Carry)

`RSB` and `RSC` subtract in reverse order (e.g. y - x not x - y).
## Examples of Arithmetic Instructions
- `ADD r0, r1, r2`
    - R0 = R1 + R2
- `SUB r5, r3, #10`
    - R5 = R3 − 10
- `RSB r2, r5, #0xFF00`
    - R2 = 0xFF00 − R5