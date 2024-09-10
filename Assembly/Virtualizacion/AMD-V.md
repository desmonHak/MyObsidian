En [[AMD-V]] no existe un modo ``root`` o ``no root``, la ``CPU`` comienza a ejecutar una [[VM]] con ``vmrun`` que lleva un puntero a un [[VMCB]] (``VM Control Block``) que cumple la misma función que el [[VMCS]] de Intel.
Tras un ``vmrun``, la ``CPU`` está en modo invitado.

El [[VMCB]] se almacena en caché, pero solo se puede leer con los accesos habituales a la memoria.

Las instrucciones ``vmload``/``vmsave`` cargan y guardan explícitamente en la caché los campos [[VMCB]] sujetos al almacenamiento en caché.

Esta interfaz es más sencilla que la de Intel, pero es igual de potente, incluso cuando se trata de anidar virtualización.

Supongamos que estamos dentro de una [[VM]] y el código ejecuta un ``vmrun``; por lo tanto, estamos virtualizando un [[VMM]].

Técnicamente, un [[VMM]] puede elegir cuándo ``vmrun`` activará o no una salida de [[VM]]. En la práctica, sin embargo, ``AMD-v`` actualmente requiere que siempre se dé lo primero:

Las siguientes condiciones se consideran combinaciones de estados ilegales: [...]
* El bit de intercepción de ``VMRUN`` está claro

Por lo tanto, el [[VMM]] ``raíz`` (usaré la misma terminología que en el caso de Intel) obtendrá el control y tiene que emular un ``vmrun`` (ya que el hardware solo admite un único nivel de virtualización).

El [[VMM]] ``raíz`` puede guardar y fusionar el [[VMCB]] actual con el [[VMCB]] del [[VMM]] ``no raíz`` y continuar con el ``vmrun`` como en el caso de ``Intel``.

Al salir, el [[VMM]] ``raíz`` tiene que determinar si la salida se dirigió a él o al [[VMM]] ``no raíz``; nuevamente, esto se puede hacer rastreando el ``vmrun`` y los bits de control en el [[VMCB]].