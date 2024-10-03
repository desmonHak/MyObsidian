1. Los procesos de Erlang son procesos emulados por la máquina virtual de Erlang (BEAM), no son procesos reales del sistema operativo.
2. Estos procesos son extremadamente ligeros. Como se mencionó, típicamente ocupan alrededor de 2KB de memoria en sistemas de 64 bits.
3. La ligereza de estos procesos permite que un solo nodo Erlang pueda ejecutar cientos de miles o incluso millones de procesos concurrentes sin afectar significativamente al rendimiento del sistema.
4. Los procesos de Erlang son gestionados por el planificador de la máquina virtual BEAM, no por el sistema operativo. Esto permite una gestión más eficiente y adaptada a las necesidades específicas de Erlang.
5. Cada proceso Erlang tiene su propio recolector de basura, stack, y buzón de mensajes, todo gestionado dentro de la máquina virtual.
6. La comunicación entre procesos se realiza mediante paso de mensajes, no mediante memoria compartida, lo que es una característica fundamental del modelo de concurrencia de Erlang.
7. Aunque son procesos emulados, pueden interactuar con recursos del sistema operativo a través de interfaces proporcionadas por la máquina virtual.