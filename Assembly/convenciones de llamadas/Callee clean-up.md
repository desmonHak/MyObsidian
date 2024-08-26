[[convenciones-de-llamadas]]
[https://en.wikipedia.org/wiki/X86_calling_conventions](https://en.wikipedia.org/wiki/X86_calling_conventions)

Callee clean-up(Limpieza de la llamada), en estas convenciones, el "callee" limpia los argumentos de la pila. Las funciones que utilizan estas convenciones son fáciles de reconocer en código ASM porque [desenrollan la pila](https://en.wikipedia.org/wiki/Call_stack#STACK-UNWINDING) después de retornar. La instrucción ``x86`` ``ret`` permite un parámetro opcional de ``16 bits`` que especifica el número de bytes de pila a liberar después de retornar al llamador. Un código de este tipo es el siguiente

```js
ret 12
```

Las convenciones llamadas [[__fastcall]] o register no han sido estandarizadas, y han sido implementadas de forma diferente, dependiendo del proveedor del compilador[1]. Típicamente las convenciones de llamada basadas en registros pasan uno o más argumentos en registros, lo que reduce el número de accesos a memoria requeridos para la llamada y por lo tanto las hace normalmente más rápidas.
