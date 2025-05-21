![[BC2_Ejercicios_1.png]]

1. Se crea tantas tablas como entidades, y se pondrá los atributos existentes:![[Pasted image 20241025095601.png]]
2. Si hay relaciones N:M, como Cursa, se creara una tabla:
   ![[Pasted image 20241025095613.png]]
En este caso, código de modulo y numero de expediente del alumno, pasan a ser atributos de la tabla Cursa.

3. Ahora será necesario añadir las claves ajenas:![[Pasted image 20241025100206.png]]

# Segundo ejemplo
![[Pasted image 20241025100533.png]]
1. hacer tabla de cada entidad del modelo E/R:
   ![[Pasted image 20241025100903.png]]
   no es población, es potencia. no es tijo, es tipo
1. se vuelve un entidad las relaciones N:M:![[Pasted image 20241025101408.png]]
2. Las relaciones tipo 1:n hace que la clave primaria de la entidad "1", sea la clave ajena de la entidad N:
![[Pasted image 20241025101729.png]]
Como PAQUETE es N de CAMIONERO y N de PROVINCIA, sus claves primarias serán claves ajenas de PAQUETE.
![[Pasted image 20241025102004.png]]
