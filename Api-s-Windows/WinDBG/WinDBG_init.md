Vea [[Api-s-Windows/Nt-api/Recursos#^8f60c6|WinDBG]]
https://samsclass.info/126/WI2021.htm

## Activar la depuración en modo de red
En el campo `hostip:` especificar la [[IP]] de su equipo local y en el capo `port:` especificar el puerto a usar. En ``key:`` indicar una clave a usar:
```ruby
bcdedit /debug on
bcdedit /set TESTSIGNING ON
bcdedit /dbgsettings net hostip:192.168.1.46 port:50000 key:flap.jack.dog.frog
bcdedit /dbgsettings
```
![[Pasted image 20240911203224.png]]
### Iniciar depuración en red
desde la maquina remota abrir ``WinGDB`` y ir al apartado `Attach to kernel`, donde ingresar los datos antes mencionados. En el campo `Target` pondremos la [[IP]] de la maquina destino:
![[Pasted image 20240911203438.png]]