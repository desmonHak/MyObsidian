https://learn.microsoft.com/es-es/windows-hardware/drivers/kernel/system-sleeping-states
Los estados [[S1]], [[S2]], [[S3]] y [[S4]] son los estados de suspensión. Un sistema en uno de estos estados no realiza ninguna tarea computacional y parece estar desactivada. A diferencia de un sistema en estado de apagado ([[S5]]), sin embargo, un sistema en suspensión conserva el estado de memoria, ya sea en RAM o en disco, tal como se especifica para cada estado de alimentación que se muestra a continuación en **las secciones Contexto** de hardware del sistema. No es necesario reiniciar el sistema operativo para devolver el equipo al estado de trabajo.

Algunos dispositivos pueden reactivar el sistema desde un estado de suspensión cuando se producen determinados eventos. Además, en algunos equipos, un indicador externo indica al usuario que el sistema simplemente está durmiendo.

Con cada estado de suspensión sucesivo, de [[S1]] a [[S4]], se apaga más del equipo. Todos los equipos compatibles con [[ACPI]] apagan sus relojes de procesador en [[S1]] y pierden el contexto de hardware del sistema en S4 (a menos que se escriba un archivo de hibernación antes del apagado), como se muestra en las secciones siguientes.

Los detalles de los estados intermedios de suspensión pueden variar en función de cómo el fabricante haya diseñado la máquina. Por ejemplo, en algunas máquinas ciertas chips de la placa base podrían perder energía en S3, mientras que en otros tales chips conservan la potencia hasta S4. Además, es posible que algunos dispositivos puedan reactivar el sistema solo desde S1 y no desde estados de suspensión más profundos.

Use `powercfg /a` para enumerar todos los estados de suspensión disponibles en un sistema. Un usuario puede especificar la acción que se debe realizar cuando se presiona el botón de encendido de suspensión mediante la [acción](https://learn.microsoft.com/es-es/windows-hardware/customize/power-settings/power-button-and-lid-settings-sleep-button-action) Botón de suspensión.

Normalmente, cuando el usuario presiona el botón de suspensión, el sistema va al estado de alimentación del sistema S3.