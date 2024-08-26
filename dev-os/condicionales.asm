cmp x, y 
je target ; jump if equal ( x == y)
jne target ; jump if not equal ( x != y)
jl target ; jump if less than ( x < y)
jle target ; jump if less than or equal ( x <= y)
jg target ; jump if greater than ( x > y)
jge target ; jump if greater than or equal ( x >= y)
jmp spl

target: 
    jmp target
