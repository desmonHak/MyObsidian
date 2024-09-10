Ahora el procesador lógico se está ejecutando en un entorno virtualizado.
Supongamos que el invitado es un [[VMM]] en sí mismo y lo llamaremos [[VMM]] ``no raíz``: debe repetir los pasos anteriores.

Pero Intel es claro en sus manuales (``Manual 3 - Capítulo 25.1.2``):

Las siguientes instrucciones hacen que la máquina virtual salga cuando se ejecutan en una operación ``no raíz`` de [[VMX]]:
[...] Esto también es cierto para las instrucciones introducidas con [[VMX]], que incluyen:
[...], ``VMLAUNCH``, ``VMPTRLD``, [...] y ``VMXON``

``vmxon`` esta instrucción hace que la máquina virtual salga, la [[VMM]] ``raíz`` se reanuda desde la instrucción después de su último ``vmlaunch``, puede inspeccionar el [[VMCS]] para determinar el motivo de la salida y tomar la acción adecuada.
No soy un escritor experimentado de [[VMM]], por lo que no estoy seguro de qué tiene que hacer exactamente la [[VMM]] ``raíz`` para emular esta instrucción. Dado que ejecutar un ``vmxon`` en modo raíz de [[VMX]] fallará y hacer un ``vmxoff`` seguido de un ``vmxon`` con la región de [[VM]] proporcionada por la [[VMM]] ``no raíz`` parece una vulnerabilidad de seguridad (o una pista hacia ella), creo que todo lo que tiene que hacer la [[VMM]] ``raíz`` es registrar que el invitado ahora está en "``modo raíz de`` [[VMX]]".
Las comillas son necesarias aquí: este modo existe solo en el software cuando la [[VMM]] ``raíz`` manejará el control de regreso a la [[VMM]] ``no raíz``, la ``CPU`` estará en modo [[VMX]] ``no raíz``.

Después de eso, la [[VMM]] ``no raíz`` intentará usar ``vmptrld`` para configurar el [[VMCS]] actual.
``vmptrld`` inducirá una salida de la [[VM]] y la [[VMM]] ``raíz`` volverá a tener el control. Si la ``CPU`` no admite el [[shadowing-de-VMCS]], la [[VMM]] ``raíz`` debe registrar que el puntero dado por la [[VMM]] ``no raíz`` es ahora la [[VMCS]] actual. Si la ``CPU`` admite el [[shadowing-de-VMCS]], la [[VMM]] establece el campo de puntero de enlace de [[VMCS]] de su [[VMCS]] (el que se utiliza para virtualizar la [[VMM]] ``no raíz``) en el [[VMCS]] dado por la [[VMM]] ``no raíz``.
De una forma u otra, la [[VMM]] sabe qué [[VMCS]] virtualizado está activo.

``vmread`` y ``vmwrite`` ejecutados por la [[VMM]] ``no raíz`` provocarán o no una salida de la [[VM]].
Si el [[shadowing-de-VMCS]] está activo, la ``CPU`` no realizará una salida de la [[VM]] y, en su lugar, leerá el [[VMCS]] apuntado por el puntero de enlace de [[VMCS]] en el [[VMCS]] activo (llamado [[VMCS-shadow]]).
Esto acelerará la virtualización de las [[VM]] anidadas.
Si el [[shadowing-de-VMCS]] no está activo, la ``CPU`` saldrá de la [[VM]] y la [[VMM]] ``raíz`` tiene que emular la lectura/escritura.

Finalmente, la [[VMM]] ``no raíz`` iniciará su [[VM]] (esta es una [[VM]] anidada).
``vmlaunch`` activará una salida de [[VM]].
La [[VMM]] ``raíz`` tiene que hacer algunas cosas:

Guardar su [[VMCS]] en algún lugar.
Fusionar el [[VMCS]] actual y el [[VMCS]] de la [[VMM]] ``no raíz``: dado que el [[VMCS]] controla, por ejemplo, qué eventos provocan una salida de [[VM]], el fusionado debe ser la unión de los dos en este sentido.
Cargar el [[VMCS]] fusionado como el actual de la ``CPU``
Ejecutar un ``vmlaunch``/``vmresume``.