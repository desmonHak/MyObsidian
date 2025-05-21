ARM tiene un formato de tres direcciones:

**Rd**: registro de destino
**Rn**: registro de origen
**Rm**: registro de origen

p. ej., ADD R0,R1,R2.

Rn se utiliza directamente, pero **Rm** se pasa a través del desplazador de barril, una unidad funcional que puede rotar y desplazar valores. El resultado se denomina Operando2.
![[org@2x.png]]
Aunque es un registro, mostramos el CPSR por separado en el diagrama para indicar que se puede utilizar tanto en la etapa de cambio de barril como en la etapa ALU.