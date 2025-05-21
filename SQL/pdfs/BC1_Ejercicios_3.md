![[Pasted image 20240920085912.png]]

Datos a acceder:
```c
343940247Julia     Rodrigez            Martinez            643667393
3436426e3Marta     Iglesias            Alonso              643627793
362246245Juan      Martín              Moreno Martinez     643623393
341240407Antonio   Vidal               Sánchez             643627493
```

Índice de acceso(por apellido):
```c
Iglesias  -> 3436426e3Marta     Iglesias            Alonso              643627793
Martín    -> 362246245Juan      Martín              Moreno Martinez     643623393
Rodrigez  -> 343940247Julia     Rodrigez            Martinez            643667393
Vidal     -> 341240407Antonio   Vidal               Sánchez             643627493
```
Se obtiene los nombres y ¿se crea una tabla se hash? (``key == indice de accesso``) datos de la tabla de acceso, cada entrada del registro. Una vez obtenido los ``hash's``, se puede acceder a ordenar las entradas con algoritmos de ``sortting``