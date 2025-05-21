```sql
-- Contar la cntidad de ciclistas que hay?
SELECT COUNT(*) FROM ciclista;

-- mostrar los ciclista que tiene de edad 25 y pertenecen al equipo 1
SELECT COUNT(*) FROM ciclista where edad=25 and equipo_cod=1;

-- mostar las distintatas nacionalidad
select DISTINCT nacionalidad from ciclista;

-- mostar las distintatas nacionalidad
select DISTINCT nacionalidad from ciclista order by nacionalidad DESC;

-- Obtener cuantas nacionalidades(en numero) hay
select count(distinct nacionalidad) from ciclista;

-- mostrar la meda de edad(avg) redondeando el nuevo a 1 decimal(round)
select Round( Avg(edad), 1) from ciclista where nacionalidad='España';

-- mostrar la meda de edad(avg) troncando el valor, obteniendo solo la parte entera
select trunc( Avg(edad)) from ciclista where nacionalidad='España';

-- mostrar la edad, nacionaidad y el equipo de las columna con naacionalidad que comienze por 'E'
select edad, equipo_cod, nacionalidad from ciclista where nacionalidad like 'E%';

-- mostrar las tablas ordenadas por equipo y edad
select edad, equipo_cod, nacionalidad from ciclista where nacionalidad like 'E%' order by equipo_cod, edad;

-- mostrar el nombre de los ciclistas cuya edad sea 24, 28 o 32 o 33 años
select edad, nombre from ciclista where edad = 24 or edad = 28 or edad = 32 or edad = 33;

-- lo mismopero mejor
select edad, nombre from ciclista where edad in (24,28,32,33);

-- seleccionar los que estan entre 30 y 35
select edad, nombre from ciclista where edad between 30 and 35;

-- seleccionar los que estan entre 30 y 35, y ordenarlos por edad
select edad, nombre from ciclista where edad between 30 and 35 order by edad;


-- seleccionar los que estan entre 175 y 200, y ordenarlos por edad
select * from etapas where distancia >= 175 and distancia <= 200 order by distancia;

-- agrupar atraves de la edad
select edad, count(*) from ciclista group by edad  order by edad;

-- ordenar por edad y nacionalidad
select edad, nacionalidad, count(*) from ciclista group by edad, nacionalidad  order by edad;

-- agrupar atraves de la edad y muestra los count(*) mayor que 1, es decir, la cantidad de personas que tiene la misma edad
-- en caso de que solo haya una persona con una edad, no se incluye
select edad, count(*) from ciclista group by edad having count(*) > 1 order by edad;

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

-- obtener el numero de filas que tiene 'LARGA'
select count(*) from etapas where upper(tipo)='LARGA';

-- numero de etapas por tipo de etapas
select tipo, count(*) from etapas group by tipo;

-- obtener cuantos ciclistas hay de cada nacionalidad
select nacionalidad, count(*) from ciclista group by nacionalidad;

-- etapas que salen o llegan a madrid
select descripcion from etapas where descripcion like '%Madrid%' ;
-- %Madrid los que llegan a madrid, Madrid% los que salen de madrid
-- %Madrid% lo que llegan y salen de madrid

-- numero de etapas que salen o llegan a madrid
select count(*) from etapas where descripcion like '%Madrid%' ;
-- %Madrid los que llegan a madrid, Madrid% los que salen de madrid
-- %Madrid% lo que llegan y salen de madrid

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

-- permite realizar un guardado de los datos, que permite revertir lo hecho via ROLLBACK
-- COMMIT y ROLLBACL es TCL. La propia herramienta hace un commit al cerrarse, lo que
-- permite guardar los datos al salir, pero se puede deciri cuando hacerlo a lo largo
-- del script
COMMIT; 

-- cambiar la edad de todos y equipo de todos los elementos de la tabla(esto rompera la tabla sobrescribiendo los campos con el mismo valor)
-- update cambia uno o varios registros
update ciclista
set edad=59, equipo_cod = 1;

-- Ctrl + z de sql, me permite revertir lo cambios
ROLLBACK;

-- esta es la forma correcta de actualizar un solo registro, es necesario indicar una condicion
-- con where:
update ciclista
set edad=59, equipo_cod = 1 where id = 18;


-- es necesario especificar una condicion en where o tambien se eliminara toda la tabla
-- ciclista
delete from ciclista where nombre = 'Miguel Endurare';
delete from equipo where cod = 99; -- como el cod 99 tiene asociado ciclistas, no se permitira la eliminacion

delete from equipo; -- permite eliminar todos los registros de la tabla
truncate table equipo; -- permite eliminar todos los registros de la tabla

-- obtener tiempo actual
Select SYSDATE from dual;

-- operar aritmeticamente
Select 12*12 from dual;

describe dual; -- dual es una tabla de trabajo

-- restar fechas da los dias, se uda round para redondear, trunc corta el decimal
select fecha, ROUND(SYSDATE - fecha,2) from etapas;

-- el alias permite mostrar otro nombre en la columna
select nombre,edad,equipo_cod as "codigo de equipo" from ciclista;

-- ordenar por edad
select edad, count(*) as numeros from ciclista group by edad order by edad;

-- no puede haber dos columnas que se llamen igual en un select, se necesitara un alias para las tablas y las columnas
-- con join se une/cruza las tablas.
select ciclista.nombre as "nombre ciclista", equipo.nombre as "nombre equipo" 
from equipo join ciclista on equipo.cod = ciclista.equipo_cod order by equipo.nombre;
-- un join crea un producto cartesiano, si equipo son 20 y hay 10 ciclista la tabla resultante es 200.
-- con ON limitamos, si tuviera el mismo nombre, COD, COD, de podria usar un USING. en este caso se asocia cod con equipo_code
--select ciclista.nombre as "nombre ciclista", equipo.nombre as "nombre equipo"  from equipo join using cod;

-- con 'e' y 'c' son alias de tablas
select c.nombre as "nombre ciclista", e.nombre as "nombre equipo" 
from equipo e join ciclista c on c.equipo_cod = e.cod order by e.nombre;

-- mostrar el nombre del ciclista de etapa de las que participan y formacion
select descripcion, nombre,  posicion 
from participa join ciclista on participa.ciclista_id = ciclista.ID
               join etapas on participa.etapa_num = etapas.num 
order by descripcion, posicion;
```



```sql
-- 1. Seleccionar todos los ciclistas
select * from ciclista;

-- 2. Seleccionar todos los equipos
select * from equipo;

-- 3. Seleccionar todas las etapas
select * from etapas;

-- 4. Seleccionar todas las participaciones
select * from participa;

-- 5. Seleccionar los nombres de todos los ciclistas
select nombre from ciclista ;

-- 6. Seleccionar los nombres de todos los equipos
select nombre from equipo ;

-- 7. Seleccionar las descripciones de todas las etapas
select descripcion from etapas;

-- 8. Seleccionar los nombres y edad de los ciclistas
select nombre, edad from ciclista;

-- 9. Seleccionar los ciclistas que tienen más de 30 años
select * from ciclista where edad > 30;

-- 10. Seleccionar las etapas de tipo 'Montaña'
select * from etapas where tipo = 'Montaña';

-- 11. Seleccionar las participaciones de la etapa número 1
select * from participa where etapa_num = 1;

-- 12. Seleccionar los ciclistas de nacionalidad 'España'
select * from ciclista where nacionalidad = 'España';

-- 13. Seleccionar los ciclistas que tienen más de 100 puntos
select * from ciclista where puntos > 100;

-- 14. Seleccionar las etapas con una distancia mayor a 150 km
select * from etapas where distancia > 150;

-- 15. Seleccionar las nacionalidades distintas de los ciclistas
select nacionalidad from ciclista;

-- 16. Seleccionar el número de ciclistas por equipo
select equipo_cod, count(*) from ciclista group by equipo_cod order by equipo_cod;

-- 17. Seleccionar el número de etapas por tipo
select tipo, count(*) from etapas group by tipo order by tipo;

-- 18. Seleccionar el número de participaciones por ciclista
select ciclista_id, count(*) from participa group by ciclista_id order by ciclista_id;

-- 19. Seleccionar el número de participaciones por etapa
select etapa_num, count(*) from participa group by etapa_num order by etapa_num;

-- 20. Seleccionar el número de ciclistas por nacionalidad
select nacionalidad, count(*) from ciclista group by nacionalidad order by nacionalidad;

-- 21. Seleccionar el total de puntos por equipo
select puntos from ciclista join equipo on equipo_cod = cod;

-- 22. Seleccionar el promedio de edad por equipo
--select avg(edad) from ciclista join equipo on equipo_cod = cod;
select equipo_cod, avg(edad) from ciclista group by equipo_cod order by equipo_cod;
select equipo.nombre, avg(edad) from ciclista join equipo on equipo_cod = cod group by equipo.nombre order by equipo.nombre;

-- 23. Seleccionar el promedio de distancia de las etapas por tipo
--select avg(distancia) from etapas join participa on num = participa.etapa_num;
select tipo, round(avg(distancia), 2) from ciclista group by equipo_cod;

-- 24. Seleccionar el número de ciclistas por equipo con más de 100 puntos
select puntos, count(*) from ciclista join equipo on equipo_cod = cod where puntos > 100 group by puntos;

-- 25. Seleccionar el número de etapas por tipo con distancia mayor a 150 km
select etapas.tipo, count(*) from etapas where distancia > 150 group by etapas.tipo;

-- 26. Seleccionar el número de ciclistas por nacionalidad con más de 30 años
SELECT NACIONALIDAD, COUNT(*) FROM CICLISTA WHERE EDAD > 30 GROUP BY NACIONALIDAD;

-- 27. Seleccionar el número de participaciones por ciclista con posición 1
SELECT ciclista_id, COUNT(*) 
FROM participa WHERE posicion = 1 
GROUP BY ciclista_id ORDER BY ciclista_id;

-- 28. Seleccionar el número de etapas por tipo con más de 5 participaciones
SELECT tipo, COUNT(*) 
FROM participa JOIN etapas ON etapas.NUM = participa.etapa_num 
GROUP BY tipo having count(*) > 5;
-- having es el where para los grupos

-- 29. Seleccionar el total de puntos por nacionalidad
select sum(puntos), count(*) from ciclista group by nacionalidad;

-- 30. Seleccionar el promedio de edad de los ciclistas por nacionalidad
select nacionalidad, round(avg(edad),2) from ciclista group by nacionalidad;

-- 31. Seleccionar el número de ciclistas por equipo con edad mayor a 25 años
select count(*), equipo_cod as "codigo de equipo" 
from ciclista where edad > 25 group by equipo_cod ;

-- mostrar los equipos con mas de 3 ciclistas
select equipo_cod, count(*) from ciclista group by equipo_cod having count(*)>3; 

-- 32. Seleccionar el número de etapas por tipo con fecha después del 2024-09-01
select count(*), tipo from etapas 
where fecha > to_date('01-09-2024', 'dd/mm/yyyy') 
group by tipo;

-- 33. Seleccionar el número de ciclistas por equipo con nacionalidad 'España'
select equipo_cod, count(*) from ciclista 
where nacionalidad = 'España' group by equipo_cod;
-- sacando el nombre del equipo tambien
select e.nombre, count(*) from ciclista c join equipo e on c.equipo_cod = e.cod
where nacionalidad = 'España' group by e.nombre;

-- 34. Seleccionar el número de etapas por tipo con distancia menor a 100 km
select tipo, count(*) as nombre from etapas where distancia < 100 group by tipo order by nombre;

-- 35. Seleccionar el número de ciclistas por equipo con puntos entre 50 y 100
select equipo_cod, count(*) from ciclista where puntos between 50 and 100 group by equipo_cod;
select equipo_cod, count(*) from ciclista where puntos >= 50 and 100 >= puntos group by equipo_cod;

-- selectionar el numero de etapas que pasan por valladolid
select count(*)
from etapas
where descripcion like '%Madrid%';




-- 36. Seleccionar los ciclistas que tienen más puntos que cualquier ciclista del equipo 1


-- 37. Seleccionar los ciclistas que tienen más puntos que todos los ciclistas del equipo 2
-- 38. Seleccionar los ciclistas que tienen menos puntos que algún ciclista del equipo 3
-- 39. Seleccionar los ciclistas que tienen más de 30 años y pertenecen a equipos con más de 5  ciclistas
-- 40. Seleccionar los equipos que tienen ciclistas de nacionalidad 'España'
-- 41. Seleccionar las etapas que tienen más de 5 participaciones
-- 42. Seleccionar los ciclistas que han participado en todas las etapas
-- 43. Seleccionar los ciclistas que no han participado en ninguna etapa
-- 44. Seleccionar los ciclistas que han participado en alguna etapa de tipo 'Montaña'
-- 45. Seleccionar los ciclistas que han ganado alguna etapa
-- 46. Seleccionar los ciclistas que han ganado todas las etapas en las que han participado
-- 47. Seleccionar los ciclistas que han participado en más de 3 etapas3
-- 48. Seleccionar los ciclistas que han participado en menos de 3 etapas
-- 49. Seleccionar los ciclistas que han participado en etapas con una distancia mayor a 150 km
-- 50. Seleccionar los ciclistas que han participado en etapas con una distancia menor a 100 km
-- 51. Seleccionar los ciclistas que han participado en etapas después del 2024-09-01
-- 52. Seleccionar los ciclistas que han participado en etapas antes del 2024-09-01
-- 53. Seleccionar los ciclistas que tienen más puntos que el promedio de puntos de todos los ciclistas
-- 54. Seleccionar los ciclistas que tienen menos puntos que el promedio de puntos de todos los ciclistas
-- 55. Seleccionar los ciclistas que tienen la misma nacionalidad que algún ciclista del equipo 1
-- 56. Seleccionar los ciclistas que tienen más de 30 años o pertenecen al equipo 1
-- 57. Seleccionar los ciclistas que tienen más de 30 años y pertenecen al equipo 1
-- 58. Seleccionar los ciclistas que tienen más de 30 años pero no pertenecen al equipo 1
-- 59. Seleccionar los ciclistas que han participado en etapas de tipo 'Montaña' o 'Larga'
-- 60. Seleccionar los ciclistas que han participado en etapas de tipo 'Montaña' pero no en 'Larga
```