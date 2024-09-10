https://stackoverflow.com/questions/42597774/is-it-possible-to-use-vmx-cpu-instructions-inside-vm

#### Cuestión:
```ruby
¿Es posible que un proceso dentro de una máquina virtual invitada utilice las instrucciones de CPU VMX (AMD-V, VT-x), que luego son procesadas por la máquina virtual invitada externa en lugar de directamente en la CPU?

Editar: Supongamos que la máquina virtual externa utiliza la propia VMX para administrar su máquina virtual invitada (es decir, se ejecuta en el anillo -1).

Si es posible, ¿existen implementaciones de máquinas virtuales invitadas que admitan emular o interceptar llamadas VMX (VMware, Parallels, KVM, etc.)?
```

#### Respuesta:
```ruby
Ni el VT-x de Intel ni el AMD-V de AMD admiten una virtualización totalmente recursiva en hardware, donde la CPU mantiene una jerarquía de entornos virtualizados anidados de la misma manera que un par call/ret.

Un procesador lógico sólo admite dos modos de funcionamiento: el modo host (llamado modo raíz VMX en la terminología de Intel, hipervisor en la de AMD) y el modo invitado (llamado así en los manuales de AMD y modo no raíz VMX en los de Intel).
Esto implica una jerarquía aplanada donde la CPU trata a todos los entornos virtualizados de la misma manera, sin saber cuántos niveles de profundidad tiene la jerarquía de máquinas virtuales.

Un intento de utilizar las instrucciones de virtualización dentro de un invitado cederá el control al monitor (VMM).
Pero recientemente ha aparecido cierto soporte para acelerar las instrucciones virtuales de uso frecuente, lo que hace posible la virtualización anidada.

Intentaré analizar los problemas a los que nos enfrentamos para implementar una virtualización anidada. No me ocupo de todo el asunto; solo estoy considerando el caso base, dejando de lado toda la parte que tiene que ver con la virtualización del hardware; una parte que en sí misma es tan problemática como la virtualización del software.

Nota
No soy un experto en tecnología de virtualización y no tengo experiencia en absoluto en ella; las correcciones son bienvenidas.
El propósito de esta respuesta es hacer que el lector crea conceptualmente que la virtualización anidada es posible y describir los problemas a enfrentar.
```
Ver: [[VT-X]], [[AMD-V]] 