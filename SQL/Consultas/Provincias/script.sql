ALTER table ca add constraint CA_PK primary key (codca);

// RESTRICCIONES DE PROVINCIAS:
alter table provincia add constraint PROVINCIA_PK PRIMARY KEY (CODPRO); // CLABLE PRIMARIA
alter table provincia // CLABLE AGENA
    add constraint PROVINCIA_CODCA_FK 
        FOREIGN KEY ( CODCA ) 
            REFERENCES CA ( CODCA );

// RESTRICIONES DE MUNICIPIO:
alter table MUNICIPIO add constraint MUNICIPIO_PK PRIMARY KEY (CODPRO, CODMUM);
alter table MUNICIPIO add constraint MUNICIPIO_CODPRO_FK FOREIGN KEY ( CODPRO ) REFERENCES provincia ( CODPRO ); // CLABLE AGENA
alter table municipio add constraint MUNICIPIO_CODPRO_FK FOREIGN KEY (CODPRO) REFERENCES PROVINCIA (CODPRO);
 
select count(*) from municipio where codPRO = 49;
select count(*) from municipio join provincia using(codPRO)
    where upper(provincia.nombre) = 'ZAMORA';

// cantidad de munucipios por comunidad autonomas
select count(*), CA.nombre from ca 
    join provincia using(codCA)
    join municipio using(codPRO)
    group by ca.nombre
    order by count(*);
    
// comunidad autonomas con mas de 500 municipios
select count(*), CA.nombre from ca 
    join provincia using(codCA)
    join municipio using(codPRO)
    group by ca.nombre
    having count(*) > 500
    order by count(*);
    
// mostrar la cantidad de municipios de una cada provincia de una comunidad autonoma
select count(*), provincia.nombre from CA
    join provincia using(codCA)
    join municipio using(codPRO)
    where ca.nombre Like '%Valencia%'
    group by provincia.nombre;
    
// numero de provincias que empiezan por C
select count(*), ca.nombre from provincia
    join CA using(codCA)
    where provincia.nombre like 'C%' 
    group by ca.nombre
    order by ca.nombre;
    
// numero de municipios de asturias, cataluña, murica y navarra

select count(*), provincia.nombre from ca
    join provincia using(codCA)
    join municipio using(codPRO)
    where ca.nombre like 'A%'
    group by provincia.nombre;
    
    
select codMUm, nombre, p_total, p_h, p_m 
from municipio
where codpro = 47 and p_total = (
    select min(p_total)
    from municipio
    where codpro = 47
);

-- alterar las tablas municipio para crear nuevos campos.
alter table municipio
    add p_total number(20);
alter table municipio
    add p_h number(20);
alter table municipio
    add p_m number(20);
    
-- p_total por CA:
select ca.nombre, sum(p_total) as total
from ca
join provincia using(codca)
    join municipio using(codpro)
    group by ca.nombre
    order by total desc;
    
-- p_total por CA, con mas de 1.000.000:
select ca.nombre, sum(p_total) as total
from ca
join provincia using(codca)
    join municipio using(codpro)
    group by ca.nombre
    having sum(p_total) > 1000000 -- no se puede usar el alias
    order by total desc;
    
-- numero de municipios por provincia
select provincia.nombre, 
        count(*)        as n_municipios, 
        sum(p_total)    as "habitanttes por provincia",
        sum(p_h),
        sum(p_m)
    from provincia
    join w_municipio using(codpro)
    group by provincia.nombre
    having sum(p_h) < sum(p_m) -- mostrar provincias con mas mujeres que hombres
    order by count(*) desc;

-- mostrar provincias con mas de 50municipios:
select provincia.nombre, 
        count(*)        as n_municipios, 
        sum(p_total)    as "habitanttes por provincia",
        sum(p_h),
        sum(p_m)
    from provincia
    join w_municipio using(codpro)
    group by provincia.nombre
    having count(*) > 50 -- mostrar provincias con mas mujeres que hombres
    order by count(*) desc;
    
-- media de poblacion masculina
select ca.nombre, round(avg(p_h), 2) as media
    from ca join provincia using(codca)
            join w_municipio using(codpro)
    group by ca.nombre
    order by media;
    
-- 7. Relación hombres/mujeres por Comunidad Autónoma (mayor a 1.05)
select ca.nombre, sum(p_m) / sum(p_h)
from municipio join provincia using(codpro)
join ca using(codca)
group by ca.nombre    
having sum(p_m) / sum(p_h) < 1.05;

-- 8. Municipios con población total entre 10.000 y 50.000 habitantes por Comunidad Autónoma
select c.nombre, count(m.nombre)
from municipio M join provincia e using(codpro)
join ca c using(codca)
where p_total BETWEEN 10000 and 50000
    group by c.nombre;
    
-- 9. Comunidad Autónoma con la mayor población femenina
select ca.nombre, sum(p_m)
from w_municipio    join provincia using(codpro)
                    join ca using(codca)
    group by ca.nombre
    order by sum(p_m) desc
    fetch first 3 row only; // obtiene las 3 primeras filas
    
-- 10 Provincias con Municipios que tienen más de 20% de población masculina respecto al total
select p.nombre, sum(p_h), sum(p_total)
    from w_municipio m join provincia p on m.codpro = p.codpro
    group by p.nombre
    having sum(p_m) / sum(p_total)> 0.2;
    
-- 11. Media de población total por Provincia en cada Comunidad Autónoma
select ca.nombre as "nombre ca", provincia.nombre as "nombre provincia", round(avg(p_total),2) as media
from ca join provincia using(codca) 
        join municipio using(codpro)
group by ca.nombre, provincia.nombre
order by media;

-- 12. Municipios con un nombre que empieza con 'San' y su población tota
select nombre
from municipio
where nombre  like 'San%';

-- 13. Municipios con población total entre 5.000 y 20.000 habitantes por Provincia
select p_total, nombre
FROM municipio 
where p_total BETWEEN 5000 and 20000
order by p_total;
select provincia.nombre, count(*)
FROM municipio join provincia using(codpro)
where p_total BETWEEN 5000 and 20000
group by provincia.nombre;

-- 14. Provincias con Municipios que tienen nombres específicos
-- osea, que varios municipios tiene el mismo nombre
select municipio.nombre, count(*)
from municipio
group by municipio.nombre
having count(*) > 1;



-- 15. Seleccionar el nombre de los libros y la cantidad de veces que aparecen, mostrando solo aquellos que aparecen más de 2 veces
-- 16. Seleccionar el nombre de los autores y la cantidad de libros que han escrito, mostrando solo aquellos que han escrito libros con precio mayor a 20
-- 17. Seleccionar el nombre de las editoriales y la cantidad de libros publicados, mostrando solo aquellas que han publicado más de 5 libros
-- 18. Seleccionar todos los campos de las editoriales y libros, mostrando solo las editoriales que han publicado al menos un libro con precio mayor a 25


select nombre from ciclista C
where edad > (
    select avg(edad)
    from ciclista 
    where nacionalidad = C.nacionalidad
);


-- 1. Mostrar el nombre de los autores que han escrito 2 o 3 libros.
SELECT NOMBRE_A, COUNT(*)
FROM AUTOR, LIBRO
WHERE AUTOR.DNI = LIBRO.DNI
GROUP BY NOMBRE_A
HAVING COUNT(*) BETWEEN 2 AND 3; -- CRUZAR TABLAS SIN USAR JOIN

-- 2. Ordenar por nombre la consulta anterior y mostrar únicamente los 4 primeros.

SELECT NOMBRE_A, COUNT(*)
FROM AUTOR, LIBRO
WHERE AUTOR.DNI = LIBRO.DNI
GROUP BY NOMBRE_A
HAVING COUNT(*) BETWEEN 2 AND 3 
ORDER BY NOMBRE_A
FETCH FIRST 4 ROW ONLY;

-- 3. Mostrar el nombre de editorial junto al nombre del libro, ordenados por nombre de editorial.
SELECT NOMBRE_E, NOMBRE_L
FROM EDITORIAL JOIN LIBRO USING(COD)
ORDER BY NOMBRE_E;

-- 4. Mostrar el DNI y el nombre de los autores que han escrito más libros que 
-- la  media. La información debe aparecer ordenada por el número de libros en 
-- orden  descendente.
SELECT DNI, NOMBRE_A, COUNT(*)
FROM AUTOR JOIN LIBRO USING(DNI)
GROUP BY DNI, NOMBRE_A
HAVING COUNT(*) > (
    SELECT AVG(COUNT(*))
    FROM LIBRO JOIN AUTOR USING(DNI)
    GROUP BY NOMBRE_A
) ORDER BY COUNT(*) DESC;

-- 5. Mostrar el dni y nombre del autor, junto a la media del precio de sus 
-- libros redondeada a 2 decimales. La información debe aparecer ordenada por 
-- el número  de libros en orden ascendente.
SELECT DNI, NOMBRE_A, ROUND(AVG(PRECIO), 2)
FROM AUTOR JOIN LIBRO USING(DNI)
GROUP BY DNI, NOMBRE_A
ORDER BY COUNT(*);



// OBTENER NUMERO, NOMBRE, Y TIPO DE SALARIO
// PARA CADA PROFESOR SEGUN LA SIGUIENTE CLASIFICACIÓN
// SALARIO BAJO: < 1500
// SALARIO MEDIO  >= 1500 Y < 2000
// SALARIO ALTO > 2000
SELECT NUMPRO, NOMPRO, (
    CASE 
    WHEN SALPRO < 1500 THEN 'SALARIO BAJO'
    WHEN SALPRO >= 1500 AND SALPRO < 2000 THEN 'SALARIO MEDIO'
    ELSE 'SALARIO BAJO'
    END
) TIPOSALARIO
FROM PROFESOR;

-- 6. Mostrar el dni, nombre del autor y número de libros que sean de la editorial Santillana.
SELECT DNI, NOMBRE_A, COUNT(*)
FROM AUTOR  JOIN LIBRO USING(DNI)
            JOIN EDITORIAL USING(COD)
WHERE NOMBRE_E = 'Salamandra'
GROUP BY DNI, NOMBRE_A;

-- 7. Mostrar el nombre de los libros cuyo precio sea superior a la media.
-- 8. Mostrar el nombre y precio de los libros cuyo precio sea inferior a la media de los libros de un autor específico.
-- 9. Mostrar el nombre de todas las editoriales que han publicado al menos un libro escrito por dos autores específicos.
-- 10. Mostrar el nombre y precio de todos los libros que tienen un precio menor al promedio de los libros escritos por un autor específico.
-- 11. Mostrar el número de libros por mes.
-- 12. Mostrar el nombre de la editorial, el año de publicación y el nombre del libro.
-- 13. Mostrar el número de libros por mes de la editorial Bruño.
-- 14. Mostrar el número de libros por mes de un autor específico.
-- 15. Mostrar el nombre de los autores que han publicado más de 2 libros.
-- 16. Consulta que muestre la suma de los precios de los libros publicados por cada editorial.
-- 17. Consulta que muestre la cantidad de libros publicados por cada autor.
-- 18. Consulta que muestre los autores que han publicado más de dos libros.



select provincia.nombre, sum(p_total)
from provincia join municipio using(codpro)
where provincia.nombre like 'M%'
group by provincia.nombre
having sum(p_total) between 2500000 and 5000000;

-- error
select provincia.nombre, avg(count(codmum))
from provincia join municipio using(codpro)
group by provincia.nombre;

-- provincias de castilla 
select provincia.nombre, sum(p_total)
from provincia join municipio using (codpro)
join ca using(codca)
where upper(ca.nombre) like 'CASTILLA Y LE%'
group by provincia.nombre
order by sum(p_total) desc
fetch first 1 rows only;

select count(*)
from provincia join municipio using (codpro)
join ca using(codca)
where p_m > p_h and upper(ca.nombre) = 'ANDALUCÍA';
