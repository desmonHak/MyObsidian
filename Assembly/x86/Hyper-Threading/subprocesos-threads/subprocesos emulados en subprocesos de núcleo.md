https://stackoverflow.com/questions/714905/is-it-possible-to-create-threads-without-system-calls-in-linux-x86-gas-assembly

Ya es un poco tarde, pero me interesaba este tipo de tema. De hecho, no hay nada especial en los subprocesos que requieran específicamente la intervención del núcleo, EXCEPTO para la paralelización/rendimiento.

BLUF obligatorio:

P1: No. Al menos se necesitan llamadas iniciales al sistema para crear múltiples subprocesos del núcleo en los distintos núcleos/hiperprocesos de la CPU.

P2: Depende. Si creas/destruyes subprocesos que realizan operaciones pequeñas, estás desperdiciando recursos (el proceso de creación de subprocesos superaría en gran medida el tiempo que utiliza el subproceso antes de que finalice). Si creas N subprocesos (donde N es ~# de núcleos/hiperprocesos en el sistema) y los reasignas, la respuesta PODRÍA ser sí, dependiendo de tu implementación.

P3: PODRÍAS optimizar la operación si CONOCIES de antemano un método preciso para ordenar las operaciones. En concreto, podría crear lo que equivale a una cadena ROP (o una cadena de llamadas hacia adelante, pero esto puede terminar siendo más complejo de implementar). Esta cadena ROP (ejecutada por un hilo) ejecutaría continuamente instrucciones 'ret' (a su propia pila) donde esa pila se antepone continuamente (o se agrega en el caso de que vuelva al principio). En un modelo así (¡raro!) el programador mantiene un puntero al 'final de la cadena ROP' de cada hilo y escribe nuevos valores en él, por lo que el código circula por la memoria ejecutando código de función que finalmente da como resultado una instrucción ret. Nuevamente, este es un modelo extraño, pero intrigante de todos modos.

Pasemos a mi contenido de dos centavos.

Recientemente creé lo que funciona efectivamente como hilos en ensamblaje puro al administrar varias regiones de pila (creadas a través de mmap) y mantener un área dedicada para almacenar la información de control/individualización para los "hilos". Es posible, aunque no lo diseñé de esta manera, crear un único bloque grande de memoria a través de mmap que subdivido en el área "privada" de cada hilo. De este modo, solo se requeriría una única llamada al sistema (aunque sería inteligente tener páginas de protección entre ellas, ya que requerirían llamadas al sistema adicionales).

Esta implementación utiliza solo el hilo de núcleo base creado cuando se genera el proceso y solo hay un único hilo de modo usuario durante toda la ejecución del programa. El programa actualiza su propio estado y se programa a sí mismo a través de una estructura de control interna. La E/S y demás se manejan a través de opciones de bloqueo cuando es posible (para reducir la complejidad), pero esto no es estrictamente necesario. Por supuesto, hice uso de mutex y semáforos.

Para implementar este sistema (completamente en el espacio de usuario y también a través de acceso no root si se desea) se requirió lo siguiente:

Una noción de lo que los hilos se reducen a: Una pila para operaciones de pila (algo bastante obvio y que se explica por sí solo) Un conjunto de instrucciones para ejecutar (también obvio) Un pequeño bloque de memoria para almacenar contenidos de registros individuales

A lo que se reduce un planificador: Un administrador para una serie de hilos (tenga en cuenta que los procesos nunca se ejecutan realmente, solo lo hacen sus hilos) en una lista ordenada especificada por el planificador (generalmente por prioridad).

Un conmutador de contexto de hilo: Un MACRO inyectado en varias partes del código (generalmente los coloco al final de las funciones de alto rendimiento) que equivale aproximadamente a 'rendimiento de hilo', que guarda el estado del hilo y carga el estado de otro hilo.

Por lo tanto, es posible (completamente en ensamblaje y sin llamadas al sistema que no sean mmap y mprotect iniciales) crear construcciones similares a hilos en modo usuario en un proceso que no sea root.

Solo agregué esta respuesta porque menciona específicamente el ensamblaje x86 y esta respuesta se derivó completamente a través de un programa autónomo escrito completamente en ensamblaje x86 que logra los objetivos (menos las capacidades de múltiples núcleos) de minimizar las llamadas del sistema y también minimiza la sobrecarga de subprocesos del lado del sistema.