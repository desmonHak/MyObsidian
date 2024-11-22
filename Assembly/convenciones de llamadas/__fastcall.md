[[convenciones-de-llamadas]]
[https://learn.microsoft.com/es-es/cpp/cpp/fastcall?view=msvc-170](https://learn.microsoft.com/es-es/cpp/cpp/fastcall?view=msvc-170)
https://book.hacktricks.xyz/es/macos-hardening/macos-security-and-privilege-escalation/macos-apps-inspecting-debugging-and-fuzzing/introduction-to-x64

https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/linux-x64-calling-convention-stack-frame

vea la versión [[__fastcall]] para sistemas Microsoft [[__msfastcall]]

**Específicos de Microsoft**
La convención de llamada **`__fastcall`** especifica que los argumentos de las funciones deben pasarse en registros siempre que sea posible. Esta convención de llamada solo se aplica a la arquitectura x86. En la lista siguiente se muestra la implementación de esta convención de llamada.

|Elemento|Implementación|
|---|---|
|Orden de paso de argumento|Los dos `DWORD` primeros o más pequeños argumentos que se encuentran en la lista de argumentos de izquierda a derecha se pasan en los registros ECX y EDX; todos los demás argumentos se pasan en la pila de derecha a izquierda.|
|Responsabilidad de mantenimiento de pila|Al llamar a la función aparece el argumento de la pila.|
|Convención de creación de nombres representativos|Al signo (@) se le asigna el prefijo a los nombres; un signo seguido del número de bytes (en decimal) de la lista de parámetros se sufijo a los nombres.|
|Convención de traducción de mayúsculas y minúsculas|No se lleva a cabo una traducción de mayúsculas y minúsculas.|
|Clases, estructuras y uniones|Se trata como tipos "multibyte" (independientemente del tamaño) y pasados en la pila.|
|Enumeraciones y clases de enumeración|Pasado por registro si el registro pasa su tipo subyacente. Por ejemplo, si el tipo subyacente es `int` o `unsigned int` de tamaño 8, 16 o 32 bits.|
Los compiladores dirigidos a las arquitecturas ARM y x64 aceptan y omiten la palabra clave **`__fastcall`**; en un chip x64, por convención, los primeros cuatro argumentos se pasan en registros cuando sea posible y los argumentos adicionales se pasan en la pila. Para obtener más información, vea [Convención de llamadas x64](https://learn.microsoft.com/es-es/cpp/build/x64-calling-convention?view=msvc-170). En un chip ARM, se puede pasar hasta cuatro argumentos enteros y ocho argumentos de punto flotante en los registros; los argumentos adicionales se pasan en la pila.

La convención de llamadas x64 varía entre sistemas operativos. Por ejemplo:
- **Windows**: Los primeros **cuatro parámetros** se pasan en los registros `**rcx**`, `**rdx**`, `**r8**`, y `**r9**`. Los parámetros adicionales se empujan en la pila. El valor de retorno está en `**rax**`.

- **System V (comúnmente utilizado en sistemas similares a UNIX)**: Los primeros **seis parámetros enteros o punteros** se pasan en los registros `**rdi**`, `**rsi**`, `**rdx**`, `**rcx**`, `**r8**`, y `**r9**`. El valor de retorno también está en `**rax**`

| Argument # | Location   | Variable | Value | Colour |
| ---------- | ---------- | -------- | ----- | ------ |
| 1          | RDI        | a        | 0x1   | Red    |
| 2          | RSI        | b        | 0x2   | Red    |
| 3          | RDX        | c        | 0x3   | Red    |
| 4          | RCX        | d        | 0x4   | Red    |
| 5          | R8         | e        | 0x5   | Orange |
| 6          | R9         | f        | 0x6   | Orange |
| 7          | RSP + 0x10 | g        | 0x7   | Lime   |
| 8          | RSP + 0x18 | h        | 0x8   | Lime   |
| 9          | RSP + 0x20 | i        | 0x9   | Lime   |