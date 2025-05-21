Oracle Database 21c Express Edition 

[Oracle Database Express Edition (XE) Downloads | Oracle España](https://www.oracle.com/es/database/technologies/xe-downloads.html "https://www.oracle.com/es/database/technologies/xe-downloads.html") 

Oracle SQL Developer Data Modeler  

[Herramientas de modelado de datos | Oracle SQL Developer Data Modeler | Oracle España](https://www.oracle.com/es/database/sqldeveloper/technologies/sql-data-modeler/ "https://www.oracle.com/es/database/sqldeveloper/technologies/sql-data-modeler/") 

Oracle SQL Developer 23 

[Oracle SQL Developer Downloads](https://www.oracle.com/database/sqldeveloper/technologies/download/ "https://www.oracle.com/database/sqldeveloper/technologies/download/")

ruta de archivos de configuración: ``C:\app\desmon0xff\product\21c\homes\OraDB21Home1\network\admin``

[oracle11g - How to connect to Oracle 11g database remotely - Stack Overflow](https://stackoverflow.com/questions/8108320/how-to-connect-to-oracle-11g-database-remotely)
Abrir el siguiente archivo y poner el nombre de la maquina:
*hacer una copia antes!*
![[Pasted image 20241113101128.png]]

En el archivo `tnsnames.ora` también habrá que sustituir los dos host's por `localhost`:
*hacer una copia antes!*
![[Pasted image 20241113101315.png]]

detener los siguientes servicios de Oracle:
![[Pasted image 20241113101714.png]]

y volver a iniciarlos para recargar la configuración:
![[Pasted image 20241113101923.png]]


Ahora podremos crear una conexión en SQL DEVELOPER. Deberemos crear un usuario pues SYSTEM nunca deberá crear tablas. Oracle tiene una forma muy estructurita en la creación de contraseñas y usuario, para evitar esto ejecutaremos la siguiente consulta:
```sql
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
```
Buscaremos la carpeta usuarios y haremos ``click`` derecho y crear:
![[Pasted image 20241113110001.png]]
Una vez creado el usuario(el nombre debe ser en mayúsculas) con nuestros datos y estableceremos los siguientes roles, `DBA`, `RESOURCES` y `CONNECT`:
![[Pasted image 20241113110320.png]]

le daremos al mas verde y creamos la nueva conexion:
![[Pasted image 20241113105607.png]]

y creara un usuario