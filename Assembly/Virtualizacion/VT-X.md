VT-x
Un procesador lógico ingresa a la operación [[VMX]] ejecutando ``vmxon``; tan pronto como se ingresa al modo, el procesador se encuentra en modo raíz.
El modo raíz es el modo del [[VMM]], puede iniciar, reanudar y manejar las ``VM``.

Luego, el [[VMM]] establece la [[VMCS]] (estructura de control de ``VM``) actual con ``vmptrld``; la [[VMCS]] contiene todos los metadatos necesarios para virtualizar un invitado.
La [[VMCS]] se lee y escribe no con accesos directos a la memoria‡ sino con instrucciones ``vmread`` y ``vmwrite``.

Finalmente, el [[VMM]] ejecuta ``vmlaunch`` para comenzar a ejecutar el invitado.