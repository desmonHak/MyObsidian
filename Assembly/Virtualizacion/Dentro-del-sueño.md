## Para [[VT-X]]:

Ahora la ``CPU`` está ejecutando la [[VM]] anidada (una [[VVM]], ¿[[VM-virtual]]?).
¿Qué sucede cuando una instrucción sensible o un evento provoca una salida de la [[VM]]?

Desde el punto de vista del procesador, solo hay dos niveles de virtualización: el modo [[VMX]] ``raíz`` y el modo [[VMX]] ``no raíz``.
Como el invitado está en modo [[VMX]] ``no raíz``, el control se transfiere nuevamente al código del modo [[VMX]] ``raíz``, es decir, la [[VMM]] ``raíz``.

La [[VMM]] raíz ahora debe comprender si ese evento proviene de su [[VM]] o de la [[VM]] de su [[VM]].
Esto se puede hacer rastreando el uso de ``vmlaunch``/``vmresume`` y verificando los bits en el [[VMCS]].

Si la salida de la [[VM]] se dirige a la [[VMM]] ``no raíz``, la [[VMM]] ``raíz`` tiene que cargar su [[VMCS]] original, eventualmente establecer en él el vínculo con la [[VMM]] ``no raíz``, actualizar los bits de estado del [[VMCS]] de la [[VMM]] ``no raíz`` y realizar un ``vmresume``.
Si la salida de la [[VM]] se dirige a ella, la [[VMM]] ``raíz`` la manejará como cualquier otra salida de [[VM]].

## Para [[AMD-V]]:
Hemos configurado una [[VM]] dentro de una [[VM]] de forma relativamente sencilla. ¿Qué sucede ahora cuando una [[VM]] sale?
La [[VMM]] ``raíz`` recibe la salida y, si se la dirige a la [[VMM]] ``no raíz``, debe restaurar su [[VMCB]] original y reanudar la ejecución (es decir, utilizar ``vmrun`` con su [[VMCB]] original).

[[AMD-V]] admite una virtualización rápida de las instrucciones ``vmsave`` y ``vmload`` al considerar sus direcciones como direcciones de invitado y, por lo tanto, sujetas a la virtualización de anidación de páginas habitual.

### Volviendo a up Inception again
Al igual que en el caso de ``Intel``, la virtualización se puede volver a anidar siempre que el soporte [[VMM]] lo permita.

La advertencia de seguridad crítica que se menciona para el caso de ``Intel`` también es válida para el de ``AMD``.

‡ Debido a su formato definido por la implementación y al hecho de que el área de memoria se puede usar simplemente como un área de derrame que no se actualiza en tiempo real