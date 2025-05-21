[documentación de NASM para estructuras oficial](https://www.nasm.us/xdoc/2.15/html/nasmdoc5.html)

Pongamos de ejemplo la siguiente estructura en C, ejemplo de definición de la estructura ``UNICODE_STRING`` para ensamblador:
```c
//0x10 bytes (sizeof)
struct _UNICODE_STRING
{
    USHORT Length;                                                          //0x0
    USHORT MaximumLength;                                                   //0x2
    WCHAR* Buffer;                                                          //0x8
}; 
```

la macro ``RESB_size_t`` se usa para indicar que el miembro buffer es del tamaño de palabra de la CPU, esto implica que para una CPU de 16bits como el [[8086]] buffer será del tamaño de 16bits, mientras que para una CPU de 32bits como el procesador [[i80386]], esta será de 32bits. Puede encontrar esta macro en [[Assembly/NASM/Macros]].

``RESB_int_16`` se usa para reservar 16bits.
```c
%if __BITS__ == 64
%define SIZE_T_DATA           DQ  
%define SIZE_T_SIZE_OPERATION QWORD
%define RESB_size_t           RESQ

%elif __BITS__ == 32
%define SIZE_T_DATA            DD  
%define SIZE_T_SIZE_OPERATION  DWORD
%define RESB_size_t            RESD

%elif __BITS__ == 16
%define SIZE_T_DATA            DW  
%define SIZE_T_SIZE_OPERATION  WORD
%define RESB_size_t            RESW
%endif
```

Hay que recordar que ``NASM`` no tiene una forma directa para trabajar con los campo de bits como si lo tiene C en este ejemplo:
```c
        struct
        {
            ULONG PackagedBinary:1;                                         //0x68
			...
        };
```
Por lo tanto no tenemos una forma de definir algo similar de forma directa.

Para poder hacer nuestra estructura deberemos definir lo siguiente:
```c
struc nombre_estructura
    .nombre_miembro_1:  nombre_tipo tamaño_del_miembro
    .nombre_miembro_2:  nombre_tipo tamaño_del_miembro
    .nombre_miembro_3:  nombre_tipo tamaño_del_miembro
endstruc
```

> [!documentación de NASM:]
>STRUC recibe uno o dos parámetros. El primer parámetro es el nombre del tipo de datos. El segundo parámetro, opcional, es el desplazamiento base de la estructura. El nombre del tipo de datos se define como un símbolo con el valor del desplazamiento base, y el nombre del tipo de datos con el sufijo _size añadido se define como un EQU que indica el tamaño de la estructura. Una vez que se ha emitido STRUC, se está definiendo la estructura, y se deben definir los campos utilizando la familia de pseudoinstrucciones RESB, y luego invocar ENDSTRUC para terminar la definición.
>
Ejemplo de documentación de NASM:
```c
struc mytype 
	mt_largo:   resd 1 
	mt_palabra: resw 1 
	mt_byte:    resb 1 
	mt_cadena:  resb 32 
endstruc
```
Esto equivaldría en C a hacer un:
```c
typedef struct mytype {
	uint32_t mt_largo;
	uint16_t mt_palabra;
	uint8_t  mt_byte;
	uint8_t  mt_cadena[32];
} mytype;
```
> [!documentación de NASM:]
La razón por la que el nombre del tipo de estructura se define en cero por defecto es un efecto secundario de permitir que las estructuras trabajen con el mecanismo de etiqueta local: si los miembros de tu estructura tienden a tener los mismos nombres en más de una estructura, puedes definir la estructura anterior de esta manera:
```c
struc mytype 
	.long: resd 1 
	.word: resw 1 
	.byte: resb 1 
	.str:  resb 32 
endstruc
```

La ultima opción es mas favorable si dicha estructura sera usada por otras como ya se menciono anteriormente, esto permite acceder a la estructura usando ``mytype.long``, ``mytype.word``, ``mytype.byte`` y ``mytype.str``.

A de tener en cuenta que la manera de manejar esta estructuras no es como en lenguajes como C, donde usted accede a ``mystruc.str``  al miembro ``str`` de la estructura ``mystruc``, sino que cada miembro que se define entre ``struct - endstruct`` son constantes que se suman a la dirección base del la estructura.

Caso de ejemplo donde se accede de forma incorrecta:
```c
mov ax, [mystruc.word]
```
Ponga el caso en el que tiene una estructura, que si su primer miembro es de 2 bytes o de tamaño `word` y su segundo miembro es de tipo ``dword`` o 4 bytes y quiere acceder a este ultimo, usted deberá calcular su offset con la suma de miembros anteriores a este, en este caso 0 + 2, pues el primer miembro es de 2 bytes. A continuación deberemos sumar este offset a la dirección base del puntero de la estructura, esto es lo que hace NASM en el fondo.

Caso practico, suponiendo que en ``ax`` esta la dirección de la estructura:
```c
mov ax, [ax + mystruc.word]
```
debemos recordar que el registro que contenga el puntero, a de ser del tamaño de palabra de la CPU, pues el tamaño de una dirección de memoria es del mismo tamaño que el 'size' de palabra que la CPU tenga. Por ende en este caso al usar ``ax``, un registro de 16bits, el lector puede asumir que esto solo funcionara en 16bits, pues para 32bits debería usarse ``eax`` o `rax` en 64bits.
Suponiendo que en `ax`contengamos la dirección base ```0x1000``` de nuestra estructura, y queremos acceder al miembro ``word``, NASM lo que hará será sustituir el `+ mystruc.word` por el valor ``+ 4``, pues necesitamos acceder a los 4bytes posteriores, sino accederíamos al miembro `long` que ocupa el offset 0 y los primeros 4bytes de la estructura

Volviendo al ejemplo inicial de `UNICODE_STRING`, primero declaremos el miembro ``Length``, este es de tipo `USHORT` o `Unsigned short`, si buscamos en la documentación de Microsoft el tamaño del tipo [https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types) podemos encontrar que este es de 16bits, su correspondencia en NASM seria `resw` ``reservar Word(palabra),`` recordemos que un ``word`` es 16bits en NASM, por lo tanto:
```c
.Length:        resw 1
.MaximumLength: resw 1
```
Ahora el siguiente miembro es un ``Buffer`` de tipo `WCHAR*` debemos tener en cuenta aquí consideraciones. Todo valor que sea un puntero, será del mismo tamaño de palabra que la CPU, por lo tanto deberemos usar `resw` para 16bits, ``resd`` para 32bits, y `resq` para 64bits, para los campos que se han punteros. Por lo tanto a de tener cuidado si sus implementaciones son para CPU's donde esto pueda influir. La solución mas eficiente para no tener que preocuparnos por esto, es definir una macro tal como se hace en [[Assembly/NASM/Macros]] para poder usar estos de forma dinámica:
```c
%if __BITS__ == 64
%define RESB_size_t       RESQ
%elif __BITS__ == 32
%define RESB_size_t       RESD
%elif __BITS__ == 16
%define RESB_size_t       RESW
%endif
```
Con esto tendremos una macro `RESB_size_t` que cambiara acorde a si la cpu es de 16, 32 y 64bits, pudiendo declarar estructuras con punteros sin preocuparnos por lo anterior, por lo tanto la estructura quedaría finalmente asi:
```c
struc _UNICODE_STRING 
	.Length:        resw 1
	.MaximumLength: resw 1
	.Buffer:        RESB_size_t 1
endstruc
```

Después de la definición, ya podemos hacer la [[declaración de estructuras]]