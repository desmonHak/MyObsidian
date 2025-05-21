```sql

DROP TABLE AUTOR CASCADE CONSTRAINTS;
CREATE TABLE AUTOR (
    DNI VARCHAR(10) PRIMARY KEY,
    NOMBRE_A VARCHAR(30) NOT NULL
);

DROP TABLE EDITORIAL CASCADE CONSTRAINTS;
CREATE TABLE EDITORIAL (
    COD VARCHAR(10) PRIMARY KEY,
    NOMBRE_E VARCHAR(30) NOT NULL
);

DROP TABLE LIBRO CASCADE CONSTRAINTS;
CREATE TABLE LIBRO (
    ISBN VARCHAR(13) PRIMARY KEY,
    NOMBRE_L VARCHAR(40) NOT NULL,
    PRECIO NUMBER(10,2) NOT NULL,
    COD VARCHAR(10) NULL,
    DNI VARCHAR(10) NULL,
    FOREIGN KEY (COD) 
REFERENCES EDITORIAL(COD) on delete set null,
    FOREIGN KEY (DNI) 
REFERENCES AUTOR(DNI) on delete set null
);



ALTER TABLE LIBRO
ADD (FECHA_PUBLICACION DATE);



INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('12345678A', 'Gabriel García Márquez');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('23456789B', 'Isabel Allende');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('34567890C', 'George Orwell');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('45678901D', 'J.K. Rowling');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('56789012E', 'Miguel de Cervantes');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('67890123F', 'Jane Austen');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('78901234G', 'Ernest Hemingway');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('89012345H', 'Haruki Murakami');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('90123456I', 'Tolkien J.R.R.');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('01234567J', 'Stephen King');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('11111111K', 'Virginia Woolf');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('22222222L', 'Agatha Christie');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('33333333M', 'James Joyce');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('44444444N', 'Herman Melville');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('55555555O', 'Oscar Wilde');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('66666666P', 'Mark Twain');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('77777777Q', 'Leo Tolstoy');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('88888888R', 'F. Scott Fitzgerald');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('99999999S', 'Victor Hugo');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('00000000T', 'Franz Kafka');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('12341234U', 'J.D. Salinger');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('23452345V', 'Charles Dickens');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('34563456W', 'Gabriela Mistral');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('45674567X', 'Mario Vargas Llosa');
INSERT INTO AUTOR (DNI, NOMBRE_A) VALUES ('56785678Y', 'Arthur Conan Doyle');
COMMIT;

INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED001', 'Penguin Random House');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED002', 'Planeta');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED003', 'HarperCollins');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED004', 'Alfaguara');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED005', 'Seix Barral');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED006', 'Santillana');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED007', 'Salamandra');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED008', 'Tusquets');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED009', 'Anagrama');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED010', 'Siruela');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED011', 'Debolsillo');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED012', 'Ediciones B');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED013', 'Minotauro');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED014', 'RBA Libros');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED015', 'Cátedra');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED016', 'Espasa Calpe');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED017', 'SM');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED018', 'Esfera de los Libros');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED019', 'Akal');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED020', 'Noguer Ediciones');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED021', 'Nordica Libros');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED022', 'Blackie Books');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED023', 'Alianza Editorial');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED024', 'Barcanova');
INSERT INTO EDITORIAL (COD, NOMBRE_E) VALUES ('ED025', 'ZigZag Editorial');
COMMIT;

INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780060883287', 'Cien años de soledad', 25.99, 'ED001', '12345678A', TO_DATE('05-06-1967', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780060883294', 'La casa de los espíritus', 20.49, 'ED004', '23456789B', TO_DATE('15-09-1982', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780451524935', '1984', 18.99, 'ED003', '34567890C', TO_DATE('08-06-1949', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780545010221', 'Harry Potter y la piedra filosofal', 22.50, 'ED002', '45678901D', TO_DATE('26-06-1997', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9788491050564', 'Don Quijote de la Mancha', 30.00, 'ED005', '56789012E', TO_DATE('16-01-2005', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780679783268', 'Orgullo y prejuicio', 15.99, 'ED006', '67890123F', TO_DATE('28-01-1813', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780743297332', 'El viejo y el mar', 17.99, 'ED007', '78901234G', TO_DATE('01-09-1952', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9788466351043', 'Tokio Blues', 19.50, 'ED008', '89012345H', TO_DATE('15-04-1987', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780261103573', 'El Señor de los Anillos', 45.00, 'ED009', '90123456I', TO_DATE('29-07-1954', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9781501142970', 'It', 35.99, 'ED010', '01234567J', TO_DATE('15-09-1986', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780156628709', 'Mrs. Dalloway', 14.99, 'ED011', '11111111K', TO_DATE('14-05-1925', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780062073488', 'Diez negritos', 12.99, 'ED012', '22222222L', TO_DATE('06-11-1939', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780140186475', 'Ulises', 28.00, 'ED013', '33333333M', TO_DATE('02-02-1922', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780142437247', 'Moby Dick', 23.50, 'ED014', '44444444N', TO_DATE('18-10-1851', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780451531896', 'El retrato de Dorian Gray', 19.99, 'ED015', '55555555O', TO_DATE('20-06-1890', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780486280615', 'Las aventuras de Tom Sawyer', 13.50, 'ED016', '66666666P', TO_DATE('15-03-1876', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780199232765', 'Guerra y paz', 40.00, 'ED017', '77777777Q', TO_DATE('01-01-1867', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780743273565', 'El gran Gatsby', 16.50, 'ED018', '88888888R', TO_DATE('10-04-1925', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780486452401', 'Los miserables', 35.50, 'ED019', '99999999S', TO_DATE('03-04-1862', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780141187561', 'La metamorfosis', 11.99, 'ED020', '00000000T', TO_DATE('03-12-1915', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780316769488', 'El guardián entre el centeno', 14.50, 'ED021', '12341234U', TO_DATE('16-07-1951', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780141439563', 'Grandes esperanzas', 18.50, 'ED022', '23452345V', TO_DATE('01-08-1861', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9788483108959', 'Desolación', 15.99, 'ED023', '34563456W', TO_DATE('15-10-1922', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9788439737866', 'La fiesta del chivo', 24.00, 'ED024', '45674567X', TO_DATE('01-06-2000', 'DD-MM-YYYY'));
INSERT INTO LIBRO (ISBN, NOMBRE_L, PRECIO, COD, DNI, FECHA_PUBLICACION) 
VALUES ('9780140439082', 'Sherlock Holmes: Estudio en escarlata', 18.99, 'ED025', '56785678Y', TO_DATE('01-12-1887', 'DD-MM-YYYY'));

COMMIT;

--------------------------------------------------------------------------------

-- 1. Seleccionar todos los libros y sus autores
select libro.nombre_l, autor.nombre_a from libro 
join autor on autor.dni = libro.dni 
group by libro.nombre_l, autor.nombre_a;

-- 2. Seleccionar el nombre de todas las editoriales y el número de libros que publican
select editorial.nombre_e, count(*) as "Libros de la editorial" from editorial 
join libro on editorial.cod = libro.cod
group by editorial.nombre_e;

-- 3. Seleccionar el nombre de todos los libros escritos por un autor específico
select libro.nombre_l, autor.nombre_a from libro 
join autor on autor.dni = libro.dni 
group by libro.nombre_l, autor.nombre_a
having autor.nombre_a = 'Autor 3';

-- 4. Seleccionar el precio promedio de los libros publicados por una editorial específica
select round(avg(precio),2) from libro 
join editorial using (cod)
where nombre_e = 'Anaya';

-- 5. Seleccionar el nombre de todos los autores que han escrito más de un libro
select count(*), autor.nombre_a from libro 
join autor on autor.dni = libro.dni 
group by autor.nombre_a
having count(libro.isbn) > 1;

-- 6. Seleccionar el nombre de todos los autores que han escrito al menos un libro cuyo precio sea mayor a 20
select autor.nombre_a 
from autor join libro on autor.dni = libro.dni 
where precio > 20
group by autor.nombre_a
having count(libro.isbn) >= 1;

-- 7. Seleccionar el nombre de todos los libros publicados por una editorial específica y escritos por un autor específico
select nombre_l 
from libro join editorial using(cod)
join autor using(dni)
where nombre_a = 'Autor 1' and nombre_e = 'Anaya';

-- 8. Seleccionar el nombre de todas las editoriales que han publicado al menos un libro escrito por un autor específico
select nombre_e
from editorial join libro using(cod)
join(autor) using(dni)
where nombre_a = 'Autor 1'
group by nombre_e
having count(*) >= 1;

-- 9. Seleccionar el nombre de todos los libros que tienen un precio mayor al promedio de los libros escritos por un autor específico
select nombre_l 
from libro
where precio > any (
    select avg(precio) 
    from libro 
    where libro.dni = '12345678A'
);

-- 10. Seleccionar el nombre y el precio de los libros que tienen un precio mayor al promedio de los libros publicados por una editorial específica
select nombre_l , precio
from libro
where precio > any (
    select avg(libro.precio)
    from libro 
    where cod = 'ED001'
);


-- 11. Seleccionar el nombre del autor y el precio máximo de sus libros
select nombre_a, max(precio)
from autor join libro using(dni)
group by nombre_a;

-- 12. Seleccionar el nombre de la editorial y el precio mínimo de sus libros
select nombre_a, min(precio)
from autor join libro using(dni)
group by nombre_a;

-- 13. Seleccionar el nombre de los autores y la cantidad de libros que han escrito, mostrando solo aquellos que han escrito más de 3 libros
select nombre_a, count(*) from autor
join libro using(dni) 
group by nombre_a
having count(*) > 3;

-- 14. Seleccionar el nombre de las editoriales y el precio promedio de los libros que publican, mostrando solo aquellas que tienen un promedio de precio mayor a 15


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


-- añadir la columna cache de tipo float a la tabla artista
ALTER TABLE artista ADD CACHE float;

-- actualizar los datos ya existente con su cache (lo que cobran cada uno).
UPDATE ARTISTA SET CACHE = 100000 WHERE ID_ARTISTA = 1;
UPDATE ARTISTA SET CACHE = 20000 WHERE ID_ARTISTA = 2;
UPDATE ARTISTA SET CACHE = 30000 WHERE ID_ARTISTA = 3;
UPDATE ARTISTA SET CACHE = 40000 WHERE ID_ARTISTA = 4;
UPDATE ARTISTA SET CACHE = 15000 WHERE ID_ARTISTA = 5;
UPDATE ARTISTA SET CACHE = 35000 WHERE ID_ARTISTA = 6;

-- añadir la columna afoto de tipo Number a la tabla artista
ALTER TABLE ACTUACION ADD AFORO number;

-- actualizar actuaciones:
UPDATE ACTUACION SET AFORO = 10000  WHERE ID_ACTUACION = 1;
UPDATE ACTUACION SET AFORO = 756    WHERE ID_ACTUACION = 2;
UPDATE ACTUACION SET AFORO = 345235 WHERE ID_ACTUACION = 3;
UPDATE ACTUACION SET AFORO = 40045  WHERE ID_ACTUACION = 4;
UPDATE ACTUACION SET AFORO = 15021  WHERE ID_ACTUACION = 5;

```