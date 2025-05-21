```js
<operation>{cond}{S} Rd,Operand2
```
`<operation>`

- `MOV` – move
    - Rd := Operand2
- `MVN` – move NOT
    - Rd := 0xFFFFFFFF EOR Operand2

- `MOV r0, #42`
    - Move the constant 42 into register R0.
- `MOV r2, r3`
    - Move the contents of register R3 into register R2.
- `MVN r1, r0`
    - R1 = NOT(R0) = -43
- `MOV r0, r0`
    - A NOP (no operation) instruction.