-- AUTOR(DNI, NOMBRE_A)
-- EDITORIAL(COD, NOMBRE_E)
-- LIBRO(ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 

-- • Las PRIMARY KEY están indicadas en negrita.
-- • En la tabla LIBRO, COD-EDITORIAL es una FOREIGN KEY que apunta a EDITORIAL y DNI es otra FOREIGN KEY que apunta a AUTOR

-- 1. Mostrar nombre y precio de los libros de la editorial “Bruño” cuyo precio sea  mayor que todos los de la editorial “Anaya”.
select NOMBRE_L, PRECIO FROM AUTOR

-- 2. Mostrar nombre y precio de los libros escritos por “Autor 1” cuyo precio sea mayor que alguno de los libros escritos por “Autor 5”.
SELECT NOMBRE_L, PRECIO 
FROM LIBRO
JOIN AUTOR USING(DNI)
WHERE NOMBRE_A = ""

-- 3. Mostrar el precio y el número de libros de cada precio, siempre que este número sea superior a 1. Mostrar la información ordenada por precio.


-- 4. Mostrar nombre y precio de los libros de la editorial “Everest” cuyo precio sea mayor que algún libro de la editorial “Anaya”.
SELECT PRECIO, NOMBRE_L
FROM LIBRO JOIN EDITORIAL USING(COD)
WHERE NOMBRE_E = "Everest" AND PRECIO > (
    SELECT PRECIO
    FROM LIBRO JOIN EDITORIAL USING(COD)
    WHERE NOMBRE_E = "“Anaya”"
)

-- 5. Mostrar nombre del libro, autor y editorial, junto a la fecha de publicación y precio, pero solo de aquellos libros cuyo precio sea superior a la media. La información debe aparecer ordenada por nombre de precio en orden descendente.
SELECT NOMBRE_L, NOMBRE_A, NOMBRE_E, FECHA_PUBLICACION, PRECIO
FROM LIBBRO JOIN AUTOR USING(DNI)
            JOIN EDITORIAL USING(COD)
            WHERE PRECIO > (
                SELECT AVG(PRECIO)
                FROM LIBRO
) ORDER BY PRECIO DESC;

-- 6. Mostrar los nombres de autores, editoriales y libros.
SELECT NOMBRE_L, NOMBRE_A, NOMBRE_E
FROM AUTOR JOIN LIBBRO USING(DNI)
            JOIN EDITORIAL USING(COD);

-- 7. Mostrar nombre y precio de los libros escritos por “Autor 3” cuyo precio sea mayor que todos los libros escritos por “Autor 5”.
SELECT NOMBRE_L, PRECIO
FROM LIBRO JOIN AUTOR USING(DNI)
WHERE NOMBRE_A = "Autor 3" AND PRECIO > ALL (
    SELECT PRECIO
    FROM LIBRO JOIN AUTOR USING(DNI)
    WHERE NOMBRE_A = "Autor 5"
);

-- 8. Mostrar nombre del libro, autor y editorial, junto a la fecha de publicación y precio, ordenados por nombre de libro.


-- 9. Mostrar el precio y el número de libros de cada precio para la editorial “Everest” ordenado por precio.


-- 10. Mostrar el número de libros cuyo precio sea inferior a la media del precio de los libros de la editorial “Bruño”.

