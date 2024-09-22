https://dev.mysql.com/doc/refman/8.4/en/loading-tables.html
Después de [[Creando_tablas|crear la tabla]], hay que rellenarla. Las sentencias [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.4/en/load-data.html "15.2.9 LOAD DATA Statement") e [`INSERT`](https://dev.mysql.com/doc/refman/8.4/en/insert.html "15.2.7 INSERT Statement") son útiles para ello.

Suponga que sus registros de mascotas pueden describirse como se muestra aquí. (Observe que ``MySQL`` espera fechas en formato '``AAAA-MM-DD``'; esto puede diferir de lo que usted está acostumbrado).

| name     | owner  | species | sex | birth      | death      |
| -------- | ------ | ------- | --- | ---------- | ---------- |
| Fluffy   | Harold | cat     | f   | 1993-02-04 |            |
| Claws    | Gwen   | cat     | m   | 1994-03-17 |            |
| Buffy    | Harold | dog     | f   | 1989-05-13 |            |
| Fang     | Benny  | dog     | m   | 1990-08-27 |            |
| Bowser   | Diane  | dog     | m   | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f   | 1998-09-11 |            |
| Whistler | Gwen   | bird    |     | 1997-12-09 |            |
| Slim     | Benny  | snake   | m   | 1996-04-29 |            |
Como se empieza con una tabla vacía, una forma sencilla de rellenarla es crear un archivo de texto que contenga una fila por cada animal y, a continuación, cargar el contenido del archivo en la tabla con una única sentencia.

Puede crear un archivo de texto ``pet.txt`` que contenga un registro por línea, con los valores separados por tabuladores y en el orden en el que se enumeraron las columnas en la sentencia [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.4/en/create-table.html "15.1.20 CREATE TABLE Statement"). Para los valores que faltan (como sexos desconocidos o fechas de muerte de animales que aún viven), puede utilizar valores ``NULL``. Para representarlos en el archivo de texto, utilice ``\N`` (barra invertida, ``N`` mayúscula). Por ejemplo, el registro del pájaro ``Whistler`` tendría este aspecto (donde el espacio en blanco entre valores es un único carácter de tabulación):
```sql
Whistler Gwen bird \N 1997-12-09 \N
```

Para cargar el archivo de texto pet.txt en la tabla ``pet.txt``, utilice esta declaración:
```sql
LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet;
```

Si creó el archivo en Windows con un editor que utiliza ``\r\n`` como terminador de línea, debe utilizar esta declaración en su lugar:
```sql
LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet LINES TERMINATED BY '\r\n';
```

En una máquina ``Apple`` que ejecute ``macOS``, probablemente desee utilizar `LINES TERMINATED BY '\r'`.)

Puede especificar el separador de valores de columna y el marcador de fin de línea explícitamente en la instrucción [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.4/en/load-data.html "15.2.9 LOAD DATA Statement") si lo desea, pero los valores predeterminados son tabulación y salto de línea. Estos son suficientes para que la instrucción lea el archivo `pet.txt` correctamente.

Si la instrucción falla, es probable que su instalación de ``MySQL`` no tenga habilitada la capacidad de archivo local de manera predeterminada. Consulte la [Sección 8.1.6, “Consideraciones de seguridad para LOAD DATA LOCAL”](https://dev.mysql.com/doc/refman/8.4/en/load-data-local-security.html "8.1.6 Consideraciones de seguridad para LOAD DATA LOCAL") para obtener información sobre cómo cambiar esto.

Cuando desee agregar nuevos registros de a uno por vez, la instrucción [`INSERT`](https://dev.mysql.com/doc/refman/8.4/en/insert.html "15.2.7 Instrucción INSERT") es útil. En su forma más simple, debe proporcionar valores para cada columna, en el orden en que se enumeraron las columnas en la instrucción [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.4/en/create-table.html "15.1.20 Instrucción CREATE TABLE"). Supongamos que ``Diane`` consigue un nuevo ``hámster`` llamado "``Puffball``". Podrías agregar un nuevo registro usando una declaración [`INSERT`](https://dev.mysql.com/doc/refman/8.4/en/insert.html "15.2.7 Instrucción INSERT") como esta:
```sql
INSERT INTO pet VALUES (
	'Puffball',
	'Diane',
	'hamster',
	'f',
	'1999-03-30',
	NULL
);
```
Los valores de cadena y fecha se especifican aquí como cadenas entre comillas. Además, con [`INSERT`](https://dev.mysql.com/doc/refman/8.4/en/insert.html "15.2.7 INSERT Statement"), puede insertar ``NULL`` directamente para representar un valor faltante. No se utiliza ``\N`` como se hace con [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.4/en/load-data.html "15.2.9 LOAD DATA Statement").

A partir de este ejemplo, debería poder ver que habría mucho más trabajo de escritura involucrado para cargar sus registros inicialmente utilizando varias declaraciones [`INSERT`](https://dev.mysql.com/doc/refman/8.4/en/insert.html "15.2.7 INSERT Statement") en lugar de una sola declaración [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.4/en/load-data.html "15.2.9 LOAD DATA Statement").

![[Pasted image 20240912183939.png]]
Se puede ver que en este caso se pudo ingresar dos entradas iguales en la ``DB``.