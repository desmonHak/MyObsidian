![[Pasted image 20250313095823.png]]

# Listar bases
![[Pasted image 20250313100001.png]]

# Insertar datos:
![[Pasted image 20250313100109.png]]

# Ver todos los datos de un usuario
![[Pasted image 20250313100219.png]]

# Ver todas las colecciones
![[Pasted image 20250313100340.png]]

# Eliminar datos
![[Pasted image 20250313100330.png]]

# Ejercicio:
![[Pasted image 20250313100608.png]]
1. Introducir a Ana
![[Pasted image 20250313100728.png]]
2. introducir a Carlos
![[Pasted image 20250313100841.png]]

3. introducir al resto usando multi insert:![[Pasted image 20250313101332.png]]
![[Pasted image 20250313101403.png]]


# Buscar alumnos de 20 años
![[Pasted image 20250313101520.png]]

# Buscar alumnos de la clase FOL
![[Pasted image 20250313101604.png]]

# Eliminar datos:
![[Pasted image 20250313101752.png]]

# Eliminar usuario David:
![[Pasted image 20250313101954.png]]

# Referenciación de datos
![[Pasted image 20250313102607.png]]
![[Pasted image 20250313102503.png]]**No es lo ideal trabajar con referenciación pero se puede**

# Buscar alumnos con operadores
1. alumnos igual a 20 años (equals -> e1)
![[Pasted image 20250313103032.png]]

2. buscar menores de 22 (less than -> lt)
![[Pasted image 20250313103100.png]]

Buscar mayores de 22 (grate than -> gt)
![[Pasted image 20250313103211.png]]


![[Pasted image 20250313103144.png]]

# Buscar alumnos menores de 22 años o que se han de la clase FOL
![[Pasted image 20250313103609.png]]

# Buscar alumnos con mas de 18 años que son de la clase programación
![[Pasted image 20250313103753.png]]

# Operación ``Update``
![[Pasted image 20250313103952.png]]

![[Pasted image 20250313104236.png]]

# Cambiar edad del alumno 
![[Pasted image 20250313104409.png]]

# Proyección de datos
![[Pasted image 20250313104542.png]]

- 1 para mostrar el campo, 0 para no mostrarlo, en este caso se indica que se quiere mostrar el campo nombre y edad
```json
db.estudiantes.find({}, {'nombre':1, 'edad':1, '_id':0})
```
![[Pasted image 20250313104924.png]]
![[Pasted image 20250313105102.png]]

# MongoDB Compas
![[Pasted image 20250313105320.png]]

![[Pasted image 20250313105542.png]]pass: changeme


```python
from pymongo 			    import MongoClient as mg
from pygments 			    import highlight
from pygments.lexers 		import get_lexer_by_name
from pygments.formatters 	import Terminal256Formatter
from pygments.lexers.data 	import JsonLexer

HOST 		= "localhost"
PORT 		= 27017

# conexion:
client 		= mg("mongodb://{}:{}/".format(HOST, PORT))
db 		    = client["escuela"] # base de datos

collection 	= db["estudiantes"] # coleccion

collection.delete_many({})

# create
estudiantes = [
	{
		"nombre"	    :"Ana",
		"edad"  	    :19,
		"clase" 	    :"FOL"
	},{
        "nombre"        :"Carlos",
        "edad"          :25,
        "clase"         :"Redes"
	},{
        "nombre"        :"Lucia",
        "edad"          :20,
        "clase"         :"FOL"
	},{
        "nombre"        :"Maria",
        "edad"          :22,
        "clase"         :"Base de Datos"
	},{
        "nombre"        :"David",
        "edad"          :24,
        "clase"         :"Programacion"
	},{
        "nombre"        :"Mateo",
        "edad"          :18,
        "clase"         :"Redes"
	}
]

# db.estudiantes.insertMany
collection.insert_many(estudiantes)

# read find. db.estudiantes.find({})
print("Consultando todos los documentos en 'estudiantes'...")
for estudiante in collection.find():
	print(
		highlight(
			code=str(estudiante),
			lexer=JsonLexer(),
			formatter=Terminal256Formatter(style="dracula")
		)
	)


print("buscando estudiantes con mas de 20 aÃ±os")
# consulta con filtro, buscamos estudiantes con mas de 20 aÃ±os
for estudiante in collection.find({"edad":20}):
	print(estudiante)

print("Actualizar la clase de Ana a base de datos")
# Update - modificar un documento
# db.estudiantes.updateOne
collection.update_one(
	{
		"nombre": "Ana",
	}, {
		"$set" : {
			"clase" : "Redes"
		}
	}
)
for estudiante in collection.find({"nombre":"Ana"}):
         print(estudiante)

# Delete db.alumnos.deleteOne()
collection.delete_one({"nombre":"Carlos"})
print("Se ha eliminado a Carlos")

for alumno in collection.find({}):
	print(alumno)

# Cerrar conexion con la DB
client.close()
```