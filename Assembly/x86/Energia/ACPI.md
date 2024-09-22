https://www.intel.la/content/www/xl/es/support/articles/000006619/processors/intel-core-processors.html#:~:text=C0%20-%20Activo%3A%20La%20CPU%20está,ejecución%20de%20forma%20casi%20instantánea.
[[ACPI]] es un sistema estandarizado, pero usado principalmente en los equipos de la familia ``x86``. Los ``ARM`` para dispositivos móviles suelen usar sistemas ligeramente diferentes, como los clusters de núcleos heterogéneos como ``big.LITTLE`` o similares. De esta forma pueden gestionar el consumo y la temperatura según la carga de trabajo del software.

En cuanto a las **funciones o pretensiones de [[ACPI]]** destacan:
- Se puede establecer el tiempo de encendido o apagado de un dispositivo.
- El ordenador puede cerrar automáticamente los programas de baja prioridad cuando la batería se esté agotando para optimizar el uso de la energía.
- Si una aplicación no requiere toda la [velocidad del procesador](https://www.profesionalreview.com/2022/05/20/intel-turbo-boost-max-3-0/), el sistema operativo puede reducirla o se pueden apagar núcleos que estén inactivos. Aquí es donde entran los [[C-States]] y [[P-States]].
- Si un equipo no se está utilizando, puede entrar en modo de espera. Si está en modo de espera, la energía de su módem permanece encendida para poder recibir los correos/faxes entrantes.

**[[ACPI]] (configuración avanzada e interfaz de alimentación)***  
El [[ACPI]] en el Bus de capacidad de administración del sistema permite el modo de suspensión de bajo consumo de energía y conserva la energía cuando un sistema está inactivo.

**Administración de energía**  
Cómo se dirige la alimentación de manera eficiente a diferentes componentes de un sistema. La administración de energía es especialmente importante para los dispositivos portátiles que dependen de la alimentación de la batería. Al reducir la potencia a componentes que no se están utilizando, un buen sistema de administración de energía puede duplicar o triplicar la vida útil de una batería.

**Suspensión más profunda**  
Trabaja junto con Intel® [[QuickStart]] technology en procesadores Intel® para equipos portátiles. El suspensión más profunda es un modo de administración dinámica de energía que ofrece una mayor duración de la batería. Un suspensión más profunda minimiza el consumo de energía de la CPU cuando detecta un período prolongado de inactividad por parte del usuario. Reduce la energía cuando está en espera y restaura rápidamente la CPU a un estado activo tan pronto como el usuario reanuda el uso del sistema. Reduce el voltaje del procesador por debajo del voltaje de funcionamiento mínimo mientras conserva el estado del procesador. El suspensión más profunda es funcionalmente idéntico al estado de suspensión profunda, pero con un voltaje 66 % menor.

**Tecnología QuickStart**  
Extiende la duración de la batería al ingresar en un estado de bajo consumo de energía durante las pausas más breves de la actividad del usuario, como entre golpes de tecla. Regresa instantáneamente al estado de energía completa cuando se le indique.

**Intel® Enhanced [[Deeper_Sleep]] con tamaño de caché dinámico**  
Este nuevo mecanismo de ahorro de energía limpia la memoria del sistema dinámicamente, según la demanda o durante períodos de inactividad. El ahorro de energía se produce cuando las maneras de la caché se apagan una vez que los datos se guardaron en la memoria. La integridad de los datos de caché L2 determina los límites de voltaje mínimo de suspensión más profundos para el procesador Intel® Core**™** Duo. Una vez que la función de tamaño de caché dinámico vacía toda la caché L2 a la memoria, el procesador pasa a Intel® Enhanced [[Deeper_Sleep]]. Esto permite que el procesador reduzca el voltaje por debajo del voltaje mínimo de suspensión más profundo para mayores ahorros de energía o eficiencias.