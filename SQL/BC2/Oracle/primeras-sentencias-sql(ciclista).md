[SQL COUNT() Function](https://www.w3schools.com/sql/sql_count.asp)
Obtener cuantas nacionalidades(en numero) hay:
```sql
select count(distinct nacionalidad) from ciclista;
```


obtener las lista de nacionalidades de los ciclistas en orden descendente: 
```sql
-- mostar las distintatas nacionalidad
select DISTINCT nacionalidad from ciclista order by nacionalidad DESC;
```

```sql
-- Contar la cntidad de ciclistas que hay?
SELECT COUNT(*) FROM ciclista;

-- mostrar los ciclista que tiene de edad 25 y pertenecen al equipo 1
SELECT COUNT(*) FROM ciclista where edad=25 and equipo_cod=1;

-- mostar las distintatas nacionalidad
select DISTINCT nacionalidad from ciclista;
```

Hacer medias:
```sql
-- mostrar la meda de edad(avg) redondeando el nuevo a 1 decimal(round)
select Round( Avg(edad), 1) from ciclista where nacionalidad='España';

-- mostrar la meda de edad(avg) troncando el valor, obteniendo solo la parte entera
select trunc( Avg(edad)) from ciclista where nacionalidad='España';
```

Mostrar datos mediante ``regex`` y ordenarlos después por equipo y edad:
```sql
-- mostrar la edad, nacionaidad y el equipo de las columna con naacionalidad que comienze por 'E'
select edad, equipo_cod, nacionalidad from ciclista where nacionalidad like 'E%';

-- mostrar las tablas ordenadas por equipo y edad
select edad, equipo_cod, nacionalidad from ciclista where nacionalidad like 'E%' order by equipo_cod, edad;
```

Obtener elementos a través de rangos y listas:
```sql
-- mostrar el nombre de los ciclistas cuya edad sea 24, 28 o 32 o 33 años
select edad, nombre from ciclista where edad = 24 or edad = 28 or edad = 32 or edad = 33;

-- lo mismopero mejor
select edad, nombre from ciclista where edad in (24,28,32,33);

-- seleccionar los que estan entre 30 y 33
select edad, nombre from ciclista where edad between 30 and 33;
```

ordenar haciendo grupos:
```sql
-- ordenar por edad y nacionalidad
select edad, nacionalidad, count(*) from ciclista group by edad, nacionalidad  order by edad;

-- agrupar atraves de la edad y muestra los count(*) mayor que 1, es decir, la cantidad de personas que tiene la misma edad
-- en caso de que solo haya una persona con una edad, no se incluye
select edad, count(*) from ciclista group by edad having count(*) > 1 order by edad;
```

Ordenar la edad por nacionalidad y hacer grupos:
```sql

-- ordenar por edad y nacionalidad que sean colombianos, estado unidenses o australianos
select edad, count(*) 
from ciclista 
where nacionalidad 
in ('Colombia','Estados Unidos', 'Australia') 
group by edad 
having count(*) > 1 
order by edad;

-- agrupar por edad para las nacionalidades que no se han colombiandos, estado unidenses, o australianos
select edad, count(*) 
from ciclista 
where nacionalidad 
not in ('Colombia','Estados Unidos', 'Australia') 
group by edad 
having count(*) > 1 
order by edad;
```

Listar cantidad de un tipo:
```sql
-- obtener el numero de filas que tiene 'LARGA'
select count(*) from etapas where upper(tipo)='LARGA';

-- numero de etapas por tipo de etapas
select tipo, count(*) from etapas group by tipo;

-- obtener cuantos ciclistas hay de cada nacionalidad
select nacionalidad, count(*) from ciclista group by nacionalidad;
```

Saber quien cuantos salen o llegan a Madrid:
```sql
-- etapas que salen o llegan a madrid
select descripcion from etapas where descripcion like '%Madrid%' ;
-- %Madrid los que llegan a madrid, Madrid% los que salen de madrid
-- %Madrid% lo que llegan y salen de madrid
```

Saber cuantos salen o llegan de Madrid:
```sql
-- numero de etapas que salen o llegan a madrid
select count(*) from etapas where descripcion like '%Madrid%' ;
```

Aplicar restricciones a un campo de la tabla, en este caso la tabla "etapa", el atributo "tipo", que es un ``VARCHAR2(25)``, limitamos los valores que puede recibir a `('Contrarreloj Individual', 'Contrarreloj por Equipos', 'Larga', 'Montaña', 'Prologo' )` :
```sql
ALTER TABLE etapa
    ADD CHECK ( tipo IN ('Contrarreloj Individual', 'Contrarreloj por Equipos', 'Larga', 'Montaña', 'Prologo' ) );
```

Crear una tabla con valores por defecto, es necesario poner `DEFAULT` y un valor por defecto, como `DEFAULT 0`:
```sql
CREATE TABLE ciclista (
    id           NUMBER NOT NULL,
    nombre       VARCHAR2(25),
    edad         NUMBER,
    nacionalidad VARCHAR2(25),
    puntos       NUMBER DEFAULT 0,
    equipo_cod   NUMBER NOT NULL
);
```

Eliminar una tabla en cascada si existe:
```sql
DROP TABLE CICLISTA CASCADE CONSTRAINT;
DROP TABLE EQUIPO CASCADE CONSTRAINT;
DROP TABLE ETAPAS CASCADE CONSTRAINT;
DROP TABLE PARTICIPA CASCADE CONSTRAINT;
```

insertar datos en tablas:
```sql

-- insertar datos en la tabla etapas, como 'PROLOGO' no es parte de las restricciones que se aplico en las consultas,
-- es necesario volver al data modeler y añadir la opcion PROLOGO. Los daots han de ingresarse en el mismo orde
-- que el de las tabla
INSERT INTO etapas values(0,'presentacion vuelta CICLISTA', 'PROLOGO', '25/08/24', 25);

-- como solo num es obligatorio, se podria hacer un INSERT INTO etapas (NUM) values (99);
INSERT INTO etapas (NUM, tipo) values (999, 'Prologo');

-- insertar un nuevo ciclista. como ciclista tiene un campo "identificador", perteneciente
-- a la tabla equipos, los valores que puede tomas ciclista para su campo EQUIPO_COD
-- han de estar en la tabla EQUIPO.
-- anteriormente se ingreso los valores (21, 'Miguel Endurare', 60, 'España', 0, 6)
-- pero es erroneo, ya que 21 deberia el id  ((id), 'Miguel Endurare', 60, 'España', 0, 6)
insert into ciclista values (21, 'Miguel Endurare', 60, 'España', 0, 99);

-- insertamos un nuevo equipo para insertar un ciclista nuevo:
insert into equipo  values (99, 'INVITADOS');
insert into ciclista  (id,nombre,edad,nacionalidad,equipo_cod) values (22, 'Bernand Rinault', 60, 'España', 99);
```

commit y rollback:
```sql
-- permite realizar un guardado de los datos, que permite revertir lo hecho via ROLLBACK
-- COMMIT y ROLLBACL es TCL. La propia herramienta hace un commit al cerrarse, lo que
-- permite guardar los datos al salir, pero se puede deciri cuando hacerlo a lo largo
-- del script
COMMIT; 

-- codigo sql que luego sera revertido....

-- Ctrl + z de sql, me permite revertir lo cambios
ROLLBACK;
```

actualizar un registro o varios:
```sql
-- cambiar la edad de todos y equipo de todos los elementos de la tabla(esto rompera la tabla sobrescribiendo los campos con el mismo valor)
-- update cambia uno o varios registros
update ciclista
set edad=59, equipo_cod = 1;


-- esta es la forma correcta de actualizar un solo registro, es necesario indicar una condicion
-- con where:
update ciclista
set edad=59, equipo_cod = 1 where id = 18;
```

operador ``delete`` y ``truncate``:
```sql
-- es necesario especificar una condicion en where o tambien se eliminara toda la tabla
-- ciclista
delete from ciclista where nombre = 'Miguel Endurare';
delete from equipo where cod = 99; -- como el cod 99 tiene asociado ciclistas, no se permitira la eliminacion

delete from equipo; -- permite eliminar todos los registros de la tabla
truncate table equipo; -- permite eliminar todos los registros de la tabla
```

```sql
-- obtener tiempo actual
Select SYSDATE from dual;

-- operar aritmeticamente
Select 12*12 from dual;

describe dual; -- dual es una tabla de trabajo
```

alias:
```sql
-- restar fechas da los dias, se uda round para redondear, trunc corta el decimal
select fecha, ROUND(SYSDATE    - fecha,2) from etapas;

-- el alias permite mostrar otro nombre en la columna
select nombre,edad,equipo_cod as "codigo de equipo" from ciclista;
```

Joins:
```sql
-- no puede haber dos columnas que se llamen igual en un select, se necesitara un alias para las tablas y las columnas
-- con join se une/cruza las tablas.
select ciclista.nombre as "nombre ciclista", equipo.nombre as "nombre equipo" 
from equipo join ciclista on equipo.cod = ciclista.equipo_cod order by equipo.nombre;
-- un join crea un producto cartesiano, si equipo son 20 y hay 10 ciclista la tabla resultante es 200.
-- con ON limitamos, si tuviera el mismo nombre, COD, COD, de podria usar un USING. en este caso se asocia cod con equipo_code
--select ciclista.nombre as "nombre ciclista", equipo.nombre as "nombre equipo"  from equipo join using cod;

-- con 'e' y 'c' son alias de tablas
select c.nombre as "nombre ciclista", e.nombre as "nombre equipo" from equipo e join ciclista c on c.equipo_cod = e.cod order by e.nombre;

-- mostrar el nombre del ciclista de etapa de las que participan y formacion
select descripcion, nombre,  posicion 
from participa join ciclista on participa.ciclista_id = ciclista.ID
               join etapas on participa.etapa_num = etapas.num 
order by descripcion, posicion;
```

Crear secuencias:
```sql
/*
sequence_name – Hace referencia al nombre del objeto de secuencia que queremos producir.
START WITH – Seguido del valor inicial que queremos usar. Aquí hemos proporcionado 1 como valor inicial.
INCREMENT BY – Seguido del valor por el que desea incrementar. Aquí queremos incrementar las claves subsiguientes en 1.
CACHE – Seguido del número máximo de valores que se almacenarán para un acceso más rápido.
*/
-- eliminar la secuencia si ya existe, sino se maneja el error capturandolo
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE secuencia_escuderia';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/
CREATE SEQUENCE secuencia_escuderia MINVALUE 0 START WITH 1 INCREMENT BY 1 CACHE 10; 
```
