Son los llamados estados globales o [[G-States]] y estarán asociados también a estados C en algunos casos. Estos estados son:

- **G0/S0**: la computadora está trabajando (working).
- **G1**: durmiendo (sleeping):
    - **G1/S1**: encendido-suspendido. Se conserva el estado del sistema, manteniendo la CPU y memoria cache.
    - **G1/S2**: ``CPU`` apagada. Se pierden los datos.
    - **G1/S3**: ``standby``, sleep, ``o`` suspendido. La ``RAM`` del sistema permanece alimentada para que no se pierdan los datos.
    - **G1/S4**: hibernación o suspensión de disco. Todo se almacena en la memoria no volátil o secundaria. Así se libera a la ``RAM`` para apagarla también y que no se pierdan los datos.
- **G2/S5**: ``soft-off``, apagado suave. Se produce un apagado del equipo, pero se mantiene un mínimo de alimentación para que un evento pueda arrancar.
- **G3**: apagado duro. Se desconecta la fuente de alimentación mediante el interruptor físico. Solo funcionarán cosas como el [[RTC]] que está alimentado por pila.