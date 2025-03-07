
https://visualgdb.com/gdbreference/commands/set_disassemble-next-line
https://www.zeuthen.desy.de/unix/unixguide/infohtml/gdb/Continuing-and-Stepping.html

ver registro con:
```c
p $r8
```

usar `set step-mode on` para activar el modo paso-a-paso y usar `set disassemble-next-line on` para habilitar el desensamblado en cada linea.

Usar instrucción `step` o  `s` para hacer el siguiente paso. Puedes desensamblar usando la instrucción `disas`. 

Usar comando `r` para ejecutar el programa. 
Usar comando `c` para continuar el programa después de un break. 
Establecer un breakpoint usando:
```c
b main
```
o para una dirección en especifico:
```c
b *0x000055555555546f
```

Si un programa estalla, podemos correrlo con `run` y usar `bt`(backtrace) para ver las funciones llamadas
![[Pasted image 20250125215328.png]]