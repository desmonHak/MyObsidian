https://dev.mysql.com/doc/refman/8.4/en/creating-database.html

Crear la base de datos `menagerie`:
```sql
CREATE DATABASE menagerie;
```
En ``Unix``, los nombres de bases de datos distinguen entre mayúsculas y minúsculas (a diferencia de las palabras clave de ``SQL``), por lo que siempre debe referirse a su base de datos como ``menagerie``, no como ``Menagerie``, ``MENAGERIE`` o alguna otra variante. Lo mismo ocurre con los nombres de las tablas. (En ``Windows``, esta restricción no se aplica, aunque debe referirse a las bases de datos y a las tablas utilizando la misma letra mayúscula y minúscula en toda la consulta. Sin embargo, por diversas razones, la práctica recomendada es utilizar siempre la misma letra que se utilizó cuando se creó la base de datos).

```sql
Nota
Si obtiene un error como ERROR 1044 (42000): Acceso denegado para el usuario 'micah'@'localhost' a la base de datos 'menagerie' al intentar crear una base de datos, significa que su cuenta de usuario no tiene los privilegios necesarios para hacerlo. Coméntelo con el administrador o consulte la Sección 8.2, «Control de acceso y gestión de cuentas».
```

La creación de una base de datos no la selecciona para su uso; debe hacerlo explícitamente. Para hacer que ``menagerie`` sea la base de datos actual, utilice esta sentencia
```sql
mysql> USE menagerie
Base de datos modificada
```
**Su base de datos sólo necesita ser creada una vez**, pero debe seleccionarla para su uso cada vez que inicie una sesión [**mysql**](https://dev.mysql.com/doc/refman/8.4/en/mysql.html "6.5.1 mysql — The MySQL Command-Line Client"). Puede hacerlo emitiendo una sentencia [`USE`](https://dev.mysql.com/doc/refman/8.4/en/use.html "15.8.4 USE Statement") como se muestra en el ejemplo. Alternativamente, puede seleccionar la base de datos en la línea de comandos cuando invoque [**mysql**](https://dev.mysql.com/doc/refman/8.4/en/mysql.html "6.5.1 mysql — The MySQL Command-Line Client"). Simplemente especifique su nombre después de cualquier parámetro de conexión que necesite proporcionar. Por ejemplo:
```sql
$> mysql -h host -u user -p menagerie
Enter password: ********
```

Ejemplo creando la base de datos ``mydatabase``:
```sql
CREATE DATABASE mydatabase

```
Una vez creada, seleccionarla con `USE`, en este ejemplo se creo una tabla `customers` con datos. Ejemplo:
```sql
USE mydatabase;
SELECT * FROM customers
```

Una vez seleccionada, se puede usar el estamento [[Recuperación_de_información_de_una_tabla|SELECT]] para mostrar/obtener todos los datos de la tabla `customers`:
![[Pasted image 20240912175627.png]]

Con el comando [`SHOW TABLES`](https://dev.mysql.com/doc/refman/8.4/en/show-tables.html "15.7.7.39 SHOW TABLES Statement") puede verse las [[Creando_tablas|tablas existentes ya creadas]].
![[Pasted image 20240912175703.png]]