
https://github.com/udosteinberg/NOVA/issues/6


### Admite la configuración de fsbase y gsbase para un contexto de ejecución de host
``@bjorn3``
``bjorn3 comentó el 1 de febrero``
```ruby
Ya sea configurando el bit FSGSBASE de CR4 para habilitar las instrucciones rdfsbase, rdgsbase, wrfsbase y wrgsbase en el espacio de usuario, o mediante otros medios como agregarlas al UTCB para los contextos de ejecución del host. No estoy seguro de cómo puedo implementar el almacenamiento local de subprocesos sin esto.
```

``@udosteinberg``
``Propietario``
``udosteinberg comentó la semana pasada``
```ruby
Implementamos el almacenamiento local de subprocesos de una manera independiente de la arquitectura (es decir, sin registros de segmentos) redondeando (hacia arriba o hacia abajo) el puntero de pila de cada subproceso para llegar al área TLS, que se asigna adyacente a la pila del subproceso.
```

``@bjorn3``
``Autor``
``bjorn3 comentó la semana pasada``
```ruby
Esa es una forma inteligente de implementar TLS. No funciona cuando se hace un cambio de pila, pero supongo que ninguno de los casos de uso previstos para NOVA realmente lo necesita. Tampoco parece ser compatible con la relajación de __tls_get_addr a mov rax, %fs:-some_offset que el enlazador hace para los accesos TLS en el ejecutable principal. ¿Estás omitiendo por completo el manejo de TLS ELF a favor de llamadas manuales a las funciones de acceso TLS?
```

``@udosteinberg``
``Propietario``
``udosteinberg comentó la semana pasada``
```ruby
Sí, hacemos TLS sin la ayuda del enlazador.
No me opongo totalmente a hacer algo diferente, pero lo que hagamos debe funcionar para todas las arquitecturas compatibles y debe ser liviano. Prefiero redondear un puntero de pila (que es efectivamente una instrucción AND) en lugar de pagar la sobrecarga de cambiar registros de segmento todo el tiempo.
```
