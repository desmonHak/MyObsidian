¿Qué sucede si queremos crear una máquina virtual dentro de la máquina virtual anidada? Una especie de máquina virtual virtual ([[VVVM]]).

Hay dos cosas que se deben tener en cuenta:

La [[VMM]] raíz sigue siendo la que se invoca durante cada salida de la máquina virtual.
Incluso si la [[VVVM]] tiene tres niveles de profundidad, la [[VMM]] ``no raíz no raíz ``no es el primer y/o el único administrador utilizado para virtualizarla.
Desde un punto de vista de seguridad, la [[VMM]] ``raíz`` es el eslabón débil.
El hardware no admite realmente una anidación profunda arbitraria.
Es posible que una [[VMM]] no necesite demasiado esfuerzo para pasar de admitir un nivel de anidación a ``n`` niveles de anidación (de nuevo, no soy experto en esto), pero aún se necesita un soporte especial como el que se describe anteriormente.
No es tan fácil como iniciar la máquina virtual y la ``CPU`` se encargará de todo lo demás.