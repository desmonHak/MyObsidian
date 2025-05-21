```js
<operation>{cond}{S} Rd,Rn,Operand2
```

- `BIC` – _Bitwise Clear_
    - Rd := Rn AND NOT Operand2

- `BIC r11, r11, #1`
    - R11 &= ~1