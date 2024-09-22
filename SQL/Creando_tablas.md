https://dev.mysql.com/doc/refman/8.4/en/creating-tables.html
Crear la base de datos es la parte fácil, pero en este momento está vacía, como le indica [`SHOW TABLES`](https://dev.mysql.com/doc/refman/8.4/en/show-tables.html "15.7.7.39 SHOW TABLES Statement"):
```sql
mysql> SHOW TABLES;
Empty set (0.00 sec)
```
La parte más difícil es decidir cuál debe ser la estructura de su base de datos: qué tablas necesita y qué columnas debe haber en cada una de ellas.

Quieres una tabla que contenga un registro para cada una de tus ``mascotas``. Puede llamarse tabla de ``mascotas`` y debe contener, como mínimo, el _nombre de cada animal_. Como el nombre por sí solo no es muy interesante, la tabla debería contener otra información. Por ejemplo, si más de una persona de su familia tiene mascotas, puede que quiera anotar el _propietario de cada animal_. También puedes anotar algunos datos descriptivos básicos, _como la especie_ y el _sexo_.

**¿Y la edad? Puede ser interesante, pero no es bueno almacenarla en una base de datos. La edad cambia con el paso del tiempo, lo que significa que tendrías que actualizar los registros a menudo.** **_En su lugar, es mejor almacenar un valor fijo, como la fecha de nacimiento_**. Entonces, cuando necesites la edad, puedes calcularla como la diferencia entre la fecha actual y la fecha de nacimiento. ``MySQL`` proporciona funciones para hacer aritmética de fechas, así que esto no es difícil. Almacenar la fecha de nacimiento en lugar de la edad también tiene otras ventajas:

- Puede utilizar la base de datos para tareas como generar recordatorios para los próximos cumpleaños de su mascota. (_Si cree que este tipo de consulta es algo tonta, tenga en cuenta que es la misma pregunta que podría hacer en el contexto de una base de datos empresarial para identificar a los clientes a los que necesita enviar felicitaciones de cumpleaños en la semana o el mes en curso, para darles ese toque personal asistido por computadora_).

- Puede calcular la edad en relación con fechas distintas a la fecha actual. Por ejemplo, si almacena la fecha de fallecimiento en la base de datos, puede calcular fácilmente la edad que tenía una mascota cuando murió.

Probablemente puedas pensar en otros tipos de información que serían útiles en la tabla `pet`/`mascotas`, pero los identificados hasta ahora son suficientes: nombre, propietario, especie, sexo, nacimiento y muerte.

Utiliza una instrucción [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.4/en/create-table.html "15.1.20 CREATE TABLE Statement") para especificar el diseño de tu tabla:
```sql
mysql> CREATE TABLE pet (
	name    VARCHAR(20), 
    owner   VARCHAR(20),
	species VARCHAR(20), 
	sex CHAR(1), 
	birth DATE, 
	death DATE
);
```

[[Tipos_datos#^b1d260|VARCHAR(20)]] indicia que el tipo será un 'string' de 20 caracteres, mientras que [[Tipos_datos#^000a8c|CHAR(1)]] indica que la variable solo usara un carácter. [[Tipos_datos#^911355|DATE]] es un tipo de dato para fechas, vea [[Tipos_datos|tipos de datos en SQL.]]

[`VARCHAR`](https://dev.mysql.com/doc/refman/8.4/en/char.html "13.3.2 Los tipos CHAR y VARCHAR") es una buena opción para las columnas `name`, `owner` y `species` porque los valores de las columnas varían en longitud. Las longitudes en esas definiciones de columna no necesitan ser todas iguales, y no necesitan ser `20`. Normalmente puede elegir cualquier longitud desde `1` hasta `65535`, lo que le parezca más razonable. Si hace una mala elección y resulta más tarde que necesita un campo más largo, ``MySQL`` proporciona una [`ALTER TABLE`](https://dev.mysql.com/doc/refman/8.4/en/alter-table.html "15.1.9 Declaración ALTER TABLE") .

Se pueden elegir varios tipos de valores para representar el sexo en los registros de animales, como `'m'` y `'f'`, o quizás `'macho'` y `'hembra'`. Lo más simple es usar los caracteres individuales `'m'` y `'f'`.

El uso del tipo de datos [`DATE`](https://dev.mysql.com/doc/refman/8.4/en/datetime.html "13.2.2 Los tipos DATE, DATETIME y TIMESTAMP") para las columnas `birth` y `death` es una opción bastante obvia.

Una vez que haya creado una tabla, [`SHOW TABLES`](https://dev.mysql.com/doc/refman/8.4/en/show-tables.html "15.7.7.39 SHOW TABLES Statement") debería producir algún resultado:
```sql
mysql> SHOW TABLES;
+---------------------+
| Tables in menagerie |
+---------------------+
| pet                 |
+---------------------+
```

Para verificar que su tabla se creó de la manera esperada, utilice una declaración [`DESCRIBE`](https://dev.mysql.com/doc/refman/8.4/en/describe.html "15.8.1 DESCRIBE Statement"):
```sql
DESCRIBE pet;
```
Puede utilizar [`DESCRIBE`](https://dev.mysql.com/doc/refman/8.4/en/describe.html "15.8.1 DESCRIBE Statement") en cualquier momento, por ejemplo, si olvida los nombres de las columnas de su tabla o qué tipos tienen.
![[Pasted image 20240912182536.png]]

Para obtener más información sobre los tipos de datos de ``MySQL``, consulte el [Capítulo 13, Tipos de datos.](https://dev.mysql.com/doc/refman/8.4/en/data-types.html "Chapter 13 Data Types").