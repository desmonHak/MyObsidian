https://dev.mysql.com/doc/refman/8.4/en/retrieving-data.html

[5.3.4.1 Selecting All Data](https://dev.mysql.com/doc/refman/8.4/en/selecting-all.html)
[5.3.4.2 Selecting Particular Rows](https://dev.mysql.com/doc/refman/8.4/en/selecting-rows.html)
[5.3.4.3 Selecting Particular Columns](https://dev.mysql.com/doc/refman/8.4/en/selecting-columns.html)
[5.3.4.4 Sorting Rows](https://dev.mysql.com/doc/refman/8.4/en/sorting-rows.html)
[5.3.4.5 Date Calculations](https://dev.mysql.com/doc/refman/8.4/en/date-calculations.html)
[5.3.4.6 Working with NULL Values](https://dev.mysql.com/doc/refman/8.4/en/working-with-null.html)
[5.3.4.7 Pattern Matching](https://dev.mysql.com/doc/refman/8.4/en/pattern-matching.html)
[5.3.4.8 Counting Rows](https://dev.mysql.com/doc/refman/8.4/en/counting-rows.html)
[5.3.4.9 Using More Than one Table](https://dev.mysql.com/doc/refman/8.4/en/multiple-tables.html)

La instrucción [`SELECT`](https://dev.mysql.com/doc/refman/8.4/en/select.html "15.2.13 Instrucción SELECT") se utiliza para extraer información de una tabla. La forma general de la instrucción es:

```sql
SELECT qué_seleccionar
FROM cual_tabla
WHERE condiciones_a_satisfacer;
```

_`qué_seleccionar`_ indica lo que desea ver. Puede ser una lista de columnas o `*` para indicar “todas las columnas”. _`cual_tabla`_ indica la tabla de la que desea recuperar datos. La cláusula `WHERE` es opcional. Si está presente, _`condiciones_a_satisfacer`_ especifica una o más condiciones que las filas deben satisfacer para calificar para la recuperación.

#### 5.3.4.1 Selecting All Data
La forma más simple de [`SELECT`](https://dev.mysql.com/doc/refman/8.4/en/select.html "15.2.13 Instrucción SELECT") recupera todo de una tabla:

```sql
mysql> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 1993-02-04 | NULL       |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny  | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | NULL       |
| Whistler | Gwen   | bird    | NULL | 1997-12-09 | NULL       |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
| Puffball | Diane  | hamster | f    | 1999-03-30 | NULL       |
+----------+--------+---------+------+------------+------------+
```

Esta forma de [`SELECT`](https://dev.mysql.com/doc/refman/8.4/en/select.html "15.2.13 Instrucción SELECT") usa `*`, que es una abreviatura de "``seleccionar todas las columnas``". Esto es útil si desea revisar toda su tabla, por ejemplo, después de haberla cargado con su conjunto de datos inicial. Por ejemplo, puede pensar que la fecha de nacimiento de ``Bowser`` no parece del todo correcta. Al consultar sus documentos de pedigrí originales, descubre que el año de nacimiento correcto debería ser ``1989``, no ``1979``.

Hay al menos dos formas de solucionar este problema:
- Edite el archivo `pet.txt` para corregir el error, luego vacíe la tabla y vuelva a cargarla usando [`DELETE`](https://dev.mysql.com/doc/refman/8.4/en/delete.html "15.2.2 Declaración DELETE") y [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.4/en/load-data.html "15.2.9 Declaración LOAD DATA"):
```sql
DELETE FROM pet;
LOAD DATA LOCAL INFILE 'pet.txt' INTO TABLE pet;
```

Sin embargo, si hace esto, también debe volver a ingresar el registro de ``Puffball``.
- Corrija solo el registro erróneo con una instrucción [`UPDATE`](https://dev.mysql.com/doc/refman/8.4/en/update.html "15.2.17 Instrucción UPDATE"):
```sql
UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser';
```
La instrucción [`UPDATE`](https://dev.mysql.com/doc/refman/8.4/en/update.html "15.2.17 Instrucción UPDATE") cambia solo el registro en cuestión y no requiere que vuelva a cargar la tabla.

Hay una excepción al principio de que `SELECT *` selecciona todas las columnas. Si una tabla contiene columnas invisibles, `*` no las incluye. Para obtener más información, consulte la [Sección 15.1.20.10, “Columnas invisibles”](https://dev.mysql.com/doc/refman/8.4/en/invisible-columns.html "15.1.20.10 Columnas invisibles").

#### 5.3.4.2 Selecting Particular Rows
Como se muestra en la sección anterior, es fácil recuperar una tabla completa. Simplemente omita la cláusula `WHERE` de la instrucción [`SELECT`](https://dev.mysql.com/doc/refman/8.4/en/select.html "15.2.13 Instrucción SELECT"). Pero, por lo general, no desea ver la tabla completa, en particular cuando se vuelve grande. En cambio, generalmente está más interesado en responder una pregunta en particular, en cuyo caso especifica algunas restricciones sobre la información que desea. Veamos algunas consultas de selección en términos de preguntas sobre sus mascotas que responden.

Puede seleccionar solo filas particulares de su tabla. Por ejemplo, si desea verificar el cambio que realizó en la fecha de nacimiento de ``Bowser``, seleccione el registro de ``Bowser`` de esta manera:
```sql
mysql> SELECT * FROM pet WHERE name = 'Bowser';
+--------+-------+---------+------+------------+------------+
| nombre | dueño | especie | sexo | nacimiento | muerte     |
+--------+-------+---------+------+------------+------------+
| Bowser | Diane |  perro  |   m  | 1989-08-31 | 1995-07-29 |
+--------+-------+---------+------+------------+------------+
```
El resultado confirma que el año está registrado correctamente como ``1989``, no ``1979``.

Las comparaciones de cadenas **_normalmente** no distinguen entre mayúsculas y minúsculas_, por lo que puede especificar el nombre como `'bowser'`, `'BOWSER'`, etc. El resultado de la consulta es el mismo.

Puede especificar condiciones en cualquier columna, no solo en `name`. Por ejemplo, si desea saber qué animales nacieron durante o después de ``1998``, pruebe la columna `birth`:
```sql
mysql> SELECT * FROM pet WHERE birth >= '1998-1-1';
+----------+-------+---------+------+------------+-------+
| name     | owner | species | sex  | birth      | death |
+----------+-------+---------+------+------------+-------+
| Chirpy   | Gwen  | bird    | f    | 1998-09-11 | NULL  |
| Puffball | Diane | hamster | f    | 1999-03-30 | NULL  |
+----------+-------+---------+------+------------+-------+
```

Puedes combinar condiciones, por ejemplo, para localizar perras:
```sql
mysql> SELECT * FROM pet WHERE species = 'dog' AND sex = 'f';
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+
```

[`AND`](https://dev.mysql.com/doc/refman/8.4/en/logical-operators.html#operator_and) y [`OR`](https://dev.mysql.com/doc/refman/8.4/en/logical-operators.html#operator_or) se pueden mezclar, aunque [`AND`](https://dev.mysql.com/doc/refman/8.4/en/logical-operators.html#operator_and) tiene mayor precedencia que [`OR`](https://dev.mysql.com/doc/refman/8.4/en/logical-operators.html#operator_or). Si utiliza ambos operadores, es una buena idea utilizar paréntesis para indicar explícitamente cómo se deben agrupar las condiciones:
```sql
mysql> SELECT * FROM pet WHERE (
		species = 'cat' AND sex = 'm'
	) OR ( 
		species = 'dog' AND sex = 'f'
	);
+-------+--------+---------+------+------------+-------+
| name  | owner  | species | sex  | birth      | death |
+-------+--------+---------+------+------------+-------+
| Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
| Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
+-------+--------+---------+------+------------+-------+
```

#### 5.3.4.3 Selección de columnas específicas
https://dev.mysql.com/doc/refman/8.4/en/selecting-columns.html
Si no desea ver filas completas de su tabla, simplemente nombre las columnas que le interesan, separadas por comas. Por ejemplo, si desea saber cuándo nacieron sus animales, seleccione las columnas `nombre` y `nacimiento`:
```sql
mysql> SELECT name, birth FROM pet;
+----------+------------+
| name     | birth      |
+----------+------------+
| Fluffy   | 1993-02-04 |
| Claws    | 1994-03-17 |
| Buffy    | 1989-05-13 |
| Fang     | 1990-08-27 |
| Bowser   | 1989-08-31 |
| Chirpy   | 1998-09-11 |
| Whistler | 1997-12-09 |
| Slim     | 1996-04-29 |
| Puffball | 1999-03-30 |
+----------+------------+
```

Ejemplo usando la sentencia [[SELECT]], seleccionado la columna ``name`` y ``birth`` y filtrando aquellas macotas que nacieron después de ``1995-1-1``
![[Pasted image 20240912193304.png]]

Para saber quién tiene mascotas, utilice esta consulta:
```sql
mysql> SELECT owner FROM pet;
+--------+
| owner  |
+--------+
| Harold |
| Gwen   |
| Harold |
| Benny  |
| Diane  |
| Gwen   |
| Gwen   |
| Benny  |
| Diane  |
+--------+
```

Tenga en cuenta que la consulta simplemente recupera la columna `propietario` de cada registro, y algunos de ellos aparecen más de una vez. Para minimizar la salida, recupere cada registro de salida único solo una vez agregando la palabra clave [[DISTINCT]]:
```sql
mysql> SELECT DISTINCT owner FROM pet;
+--------+
| owner  |
+--------+
| Benny  |
| Diane  |
| Gwen   |
| Harold |
+--------+
```

Puede utilizar una cláusula `WHERE` para combinar la selección de filas con la selección de columnas. Por ejemplo, para obtener las fechas de nacimiento de perros y gatos únicamente, utilice esta consulta:
```sql
mysql> SELECT name, species, birth FROM pet
       WHERE species = 'dog' OR species = 'cat';
+--------+---------+------------+
| name   | species | birth      |
+--------+---------+------------+
| Fluffy | cat     | 1993-02-04 |
| Claws  | cat     | 1994-03-17 |
| Buffy  | dog     | 1989-05-13 |
| Fang   | dog     | 1990-08-27 |
| Bowser | dog     | 1989-08-31 |
+--------+---------+------------+
```