[https://www.nasm.us/xdoc/2.15/html/nasmdoc5.html](https://www.nasm.us/xdoc/2.15/html/nasmdoc5.html)
Para hacer la declaración de estructuras NASM nos da `ISTRUC`, `AT` e `IEND`
las cuales son directivas de preprocesador para declarar una estructura en el segmento de datos. NASM llama a esto "``instanciar una estructura``".
Poniendo de caso que tenemos definida esta estructura:
```js
struc mytype 
	.long: resd 1 
	.word: resw 1 
	.byte: resb 1 
	.str:  resb 32 
endstruc
```
nosotros podemos declarar una estructura de tipo ``mytype`` en la sección de datos, por ejemplo, de esta manera:
```c
mystruc:
    istruc mytype
        at long, dd  123456
        at word, dw  1024
        at word, db  'x'
        at str,  db  'hello, world', 13, 10, 0
    iend

```

La directiva `AT` se utiliza para posicionar correctamente los datos en el punto específico del campo de la estructura y declarar los datos correspondientes. Es importante que los campos de la estructura se declaren en el mismo orden en que fueron especificados en la definición de la estructura.

Si los datos de un campo de la estructura requieren más de una línea de código, puedes continuar especificando los datos en las líneas siguientes después de la línea `AT`. Por ejemplo:
```c
at mt_str, db 123, 134, 145, 156, 167, 178, 189
           db 190, 100, 0
```

También puedes omitir la parte del código en la línea `AT` y empezar la declaración de los datos del campo en la línea siguiente:
```js
at mt_str
    db 'hello, world'
    db 13, 10, 0
```

Ahora pongamos que tienes una estructura dentro de otra estructura, ejemplo de la definicion:
```js
; Estructura Interna
struc InnerStruct
    .inner_field1 resd 1
    .inner_field2 resw 1
endstruc

; Estructura Externa
struc OuterStruct
    .outer_field1 resd 1
    
    .inner_struct istruc InnerStruct
        at InnerStruct.inner_field1, resd 1
        at InnerStruct.inner_field2, resw 1
    iend
    
    .outer_field2 resb 1
endstruc
```
Declaración:
```js
my_outer_struct:
    istruc OuterStruct
        at OuterStruct.outer_field1, dd  123456
        
        at InnerStruct.inner_field1, dd  789012
        at InnerStruct.inner_field2, dw  3456
        
        at OuterStruct.outer_field2, db  'A'
    iend
```

Esto es equivalente en C a hacer:
```c
typedef struct {
    unsigned int inner_field1;
    unsigned short inner_field2;
} InnerStruct;

typedef struct {
    unsigned int outer_field1;
    InnerStruct inner_struct;
    unsigned char outer_field2;
} OuterStruct;

OuterStruct my_outer_struct = {
    .outer_field1 = 123456,
    .inner_struct = {
        .inner_field1 = 789012,
        .inner_field2 = 3456
    },
    .outer_field2 = 'A'
};

```