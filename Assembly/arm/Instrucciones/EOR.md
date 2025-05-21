equivalente a [[XOR]] en x64
```js
<operation>{cond}{S} Rd,Rn,Operand2
```

- `EOR` – _Exclusive OR_
    - Rd := Rn EOR Operand2
- `EOR r11, r11, #1`
    - R11 ^= 1