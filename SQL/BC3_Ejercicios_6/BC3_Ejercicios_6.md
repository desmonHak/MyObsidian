
```sql
-- Generado por Oracle SQL Developer Data Modeler 24.3.0.240.1210
--   en:        2025-02-21 08:55:36 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g


DROP TABLE REPRESENTANTE CASCADE CONSTRAINTS;
DROP TABLE ARTISTA CASCADE CONSTRAINTS;
DROP TABLE ACTUACION CASCADE CONSTRAINTS;

CREATE TABLE ACTUACION (
    ID_ACTUACION       NUMBER NOT NULL,
    FECHA              DATE,
    CIUDAD             VARCHAR2(100),
    ARTISTA_ID_ARTISTA NUMBER NOT NULL
);

ALTER TABLE ACTUACION ADD CONSTRAINT ACTUACION_PK PRIMARY KEY ( ID_ACTUACION );

CREATE TABLE ARTISTA (
    ID_ARTISTA                     NUMBER NOT NULL,
    NOMBRE_ARTISTA                 VARCHAR2(100),
    GENERO                         VARCHAR2(50),
    REPRESENTANTE_ID_REPRESENTANTE NUMBER
);

ALTER TABLE ARTISTA ADD CONSTRAINT ARTISTA_PK PRIMARY KEY ( ID_ARTISTA );

CREATE TABLE REPRESENTANTE (
    ID_REPRESENTANTE     NUMBER NOT NULL,
    NOMBRE_REPRESENTANTE VARCHAR2(200),
    TELEFONO             VARCHAR2(20)
);

ALTER TABLE REPRESENTANTE ADD CONSTRAINT REPRESENTANTE_PK PRIMARY KEY ( ID_REPRESENTANTE );

ALTER TABLE ACTUACION
    ADD CONSTRAINT ACTUACION_ARTISTA_FK FOREIGN KEY ( ARTISTA_ID_ARTISTA )
        REFERENCES ARTISTA ( ID_ARTISTA );

ALTER TABLE ARTISTA
    ADD CONSTRAINT ARTISTA_REPRESENTANTE_FK FOREIGN KEY ( REPRESENTANTE_ID_REPRESENTANTE )
        REFERENCES REPRESENTANTE ( ID_REPRESENTANTE );

--**************************************************

INSERT INTO REPRESENTANTE VALUES (1, 'Luis López', '912345678');
INSERT INTO REPRESENTANTE VALUES (2, 'Pedro García', '923456789');
INSERT INTO REPRESENTANTE VALUES (3, 'María Pérez', '934567890');
INSERT INTO REPRESENTANTE VALUES (4, 'Teresa Martínez', '945678901');
INSERT INTO REPRESENTANTE VALUES (5, 'Rosa Fernández', '956789012');
INSERT INTO ARTISTA VALUES (1, 'Marta Sánchez', 'Pop', 1);
INSERT INTO ARTISTA VALUES (2, 'David Bisbal', 'Pop', 2);
INSERT INTO ARTISTA VALUES (3, 'Alejandro Sanz', 'Pop', 3);
INSERT INTO ARTISTA VALUES (4, 'Joaquín Sabina', 'Rock', 1);
INSERT INTO ARTISTA VALUES (5, 'Ana Belén', 'Pop', 2);
INSERT INTO ARTISTA VALUES (6, 'Jacinto Huerta', 'Pop', NULL); -- ?
INSERT INTO ACTUACION VALUES (1, '20-03-2024', 'Madrid', 1);
INSERT INTO ACTUACION VALUES (2, '20-05-2024', 'Barcelona', 2);
INSERT INTO ACTUACION VALUES (3, '11-04-2024', 'Valencia', 3);
INSERT INTO ACTUACION VALUES (4, '08-03-2024', 'Sevilla', 5);
INSERT INTO ACTUACION VALUES (5, '19-03-2024', 'Málaga', 5);

COMMIT;

--**************************************************
-- 1. Obtener por cada representante, el número de artistas que representan
SELECT REPRESENTANTE.NOMBRE_REPRESENTANTE, COUNT(*) AS "CANTIDAD DE ARTISTAS"
FROM ARTISTA 
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
GROUP BY REPRESENTANTE.NOMBRE_REPRESENTANTE;

-- lo mismo pero obtiendo tambien los nulls
SELECT REPRESENTANTE.NOMBRE_REPRESENTANTE, COUNT(*) AS "CANTIDAD DE ARTISTAS"
FROM ARTISTA 
LEFT JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
GROUP BY REPRESENTANTE.NOMBRE_REPRESENTANTE;
 
 
-- 2. Obtener artistas y representantes que tengan actuaciones en ciudades que comienzan con 'M'
SELECT REPRESENTANTE.*, ARTISTA.* FROM REPRESENTANTE
JOIN ARTISTA ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
WHERE UPPER(ACTUACION.CIUDAD) LIKE 'M%';
 
-- 3. Obtener representantes que tienen al menos un artista de género 'Pop'
 SELECT * FROM REPRESENTANTE
JOIN ARTISTA ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
WHERE UPPER(ARTISTA.GENERO) = 'POP';

-- 4. Obtener actuaciones de artistas representados por 'María Pérez' 
SELECT ACTUACION.* FROM ARTISTA
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
WHERE ARTISTA.REPRESENTANTE_ID_REPRESENTANTE = (
    SELECT ID_REPRESENTANTE 
    FROM REPRESENTANTE 
    WHERE UPPER(NOMBRE_REPRESENTANTE) = 'MARÍA PÉREZ'
);
 
-- 5. Obtener la fecha más reciente de actuación para cada artista
SELECT ARTISTA.ID_ARTISTA, MAX(ACTUACION.FECHA) FROM ARTISTA
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
GROUP BY ARTISTA.ID_ARTISTA;
 
-- 6. Obtener artistas que no tienen representante asignado
SELECT * 
FROM ARTISTA
WHERE REPRESENTANTE_ID_REPRESENTANTE IS NULL;
 
-- 7. Obtener representantes que tienen al menos dos artistas
 SELECT REPRESENTANTE.NOMBRE_REPRESENTANTE, COUNT(*) AS "CANTIDAD DE ARTISTAS"
FROM ARTISTA 
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
GROUP BY REPRESENTANTE.NOMBRE_REPRESENTANTE
HAVING COUNT(*) >= 2;

-- 8. Obtener representantes que tienen al menos un artista de género 'ROCK' 
-- y otro de género 'Pop'
SELECT REPRESENTANTE.NOMBRE_REPRESENTANTE FROM REPRESENTANTE
JOIN ARTISTA ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
WHERE UPPER(ARTISTA.GENERO) = 'POP'
INTERSECT
SELECT REPRESENTANTE.NOMBRE_REPRESENTANTE FROM REPRESENTANTE
JOIN ARTISTA ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
WHERE UPPER(ARTISTA.GENERO) = 'ROCK';


-- 9. Obtener actuaciones que ocurrieron entre el 1 de marzo 
-- y el 30 de abril de 2024
SELECT *
FROM ACTUACION
WHERE 
    SYSDATE - ACTUACION.FECHA >=
    SYSDATE - TO_DATE('30-04-2024', 'dd-mm-yyyy') AND
    SYSDATE - ACTUACION.FECHA <=
    SYSDATE - TO_DATE('01-03-2024', 'dd-mm-yyyy');
 
-- 10. Mostrar artistas con más de 1 actuación
SELECT ARTISTA.NOMBRE_ARTISTA, COUNT(*) AS "NUMERO DE ACTUACIONES"
FROM ARTISTA
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
GROUP BY ARTISTA.NOMBRE_ARTISTA
HAVING COUNT(*) >= 2;

-- 11. Mostrar los nombres de artistas y representantes
SELECT REPRESENTANTE.NOMBRE_REPRESENTANTE 
FROM REPRESENTANTE
UNION 
SELECT ARTISTA.NOMBRE_ARTISTA 
FROM ARTISTA;

-- 12. Mostrar los distintos géneros de los artistas cuyo representante sea Pedro García
SELECT DISTINCT GENERO FROM ARTISTA WHERE ID_ARTISTA = (
    SELECT ID_REPRESENTANTE 
    FROM REPRESENTANTE 
    WHERE UPPER(NOMBRE_REPRESENTANTE) = 'PEDRO GARCÍA'
);

-- 13. Insertar un nuevo artista sin representante asignado
INSERT INTO ARTISTA VALUES (7, 'Juan Perez', 'Rock', NULL); 

-- 14. Crear una copia de la tabla artista
DROP TABLE ARTISTA_CPY CASCADE CONSTRAINTS;
CREATE TABLE ARTISTA_CPY (
    ID_ARTISTA                     NUMBER NOT NULL,
    NOMBRE_ARTISTA                 VARCHAR2(100),
    GENERO                         VARCHAR2(50),
    REPRESENTANTE_ID_REPRESENTANTE NUMBER
);
INSERT INTO ARTISTA_CPY SELECT * FROM ARTISTA;

CREATE TABLE ARTISTA_W AS 
SELECT * FROM ARTISTA;


-- añadir la columna cache de tipo float a la tabla artista
ALTER TABLE ARTISTA ADD CACHE FLOAT;

-- actualizar los datos ya existente con su cache (lo que cobran cada uno).
UPDATE ARTISTA SET CACHE = 100000 WHERE ID_ARTISTA = 1;
UPDATE ARTISTA SET CACHE = 20000 WHERE ID_ARTISTA = 2;
UPDATE ARTISTA SET CACHE = 30000 WHERE ID_ARTISTA = 3;
UPDATE ARTISTA SET CACHE = 40000 WHERE ID_ARTISTA = 4;
UPDATE ARTISTA SET CACHE = 15000 WHERE ID_ARTISTA = 5;
UPDATE ARTISTA SET CACHE = 35000 WHERE ID_ARTISTA = 6;

-- añadir la columna afoto de tipo Number a la tabla artista
ALTER TABLE ACTUACION ADD AFORO NUMBER;

-- actualizar actuaciones:
UPDATE ACTUACION SET AFORO = 10000  WHERE ID_ACTUACION = 1;
UPDATE ACTUACION SET AFORO = 756    WHERE ID_ACTUACION = 2;
UPDATE ACTUACION SET AFORO = 345235 WHERE ID_ACTUACION = 3;
UPDATE ACTUACION SET AFORO = 40045  WHERE ID_ACTUACION = 4;
UPDATE ACTUACION SET AFORO = 15021  WHERE ID_ACTUACION = 5;
COMMIT;

-- mostrar el nombre de artista con mas de dos actuaciones junto a su cache.
SELECT ARTISTA.NOMBRE_ARTISTA, ARTISTA.CACHE, COUNT(*) AS "NUMERO DE ACTUACIONES"
FROM ARTISTA
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
GROUP BY ARTISTA.NOMBRE_ARTISTA, ARTISTA.CACHE
HAVING COUNT(*) >= 2;

-- muestra las ciudad con un aforo igual o mayor a 10k.
SELECT CIUDAD 
FROM ACTUACION
WHERE AFORO >= 10000;

-- mostrar la media de cache de los artista:
SELECT AVG(CACHE) FROM ARTISTA; 

-- media de aforo para los cantanttes con mas de dos actuaciones
SELECT AVG(ACTUACION.AFORO), A.NOMBRE_ARTISTA FROM ARTISTA A 
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
WHERE A.ID_ARTISTA = ANY (
    SELECT ID_ARTISTA AS "NUMERO DE ACTUACIONES"
    FROM ARTISTA
    JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
    JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
    GROUP BY ARTISTA.ID_ARTISTA
    HAVING COUNT(*) >= 2
)
GROUP BY A.NOMBRE_ARTISTA;

-- mostrar los artistas sin actuaciones
--    FROMA 1:
SELECT NOMBRE_ARTISTA, CACHE
FROM ARTISTA 
LEFT JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
WHERE ARTISTA_ID_ARTISTA IS NULL;


--    FROMA 2:
SELECT NOMBRE_ARTISTA, CACHE
FROM ARTISTA A1
WHERE NOT EXISTS (
    SELECT *
    FROM ACTUACION A2
    WHERE A1.ID_ARTISTA = A2.ARTISTA_ID_ARTISTA
);

-- nombre del representante cuyo cache sea superior a la media del cache de los 
-- artistas de genero pop:
SELECT NOMBRE_REPRESENTANTE 
FROM ARTISTA A1
JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
WHERE CACHE > (
    SELECT AVG(CACHE)
    FROM ARTISTA A2
    WHERE GENERO = 'Pop'
);

-- numero de artista cuyo cacge sea mayor a la media
SELECT COUNT(*)
FROM ARTISTA
WHERE CACHE > (
    SELECT AVG(CACHE)
    FROM ARTISTA
);

-- nombre de artistas que tienen dos actuaciones en 2024
SELECT A.NOMBRE_ARTISTA
FROM ARTISTA A 
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
WHERE FECHA BETWEEN '01/01/2024' AND '31/12/2024'
GROUP BY A.NOMBRE_ARTISTA
HAVING COUNT(ID_ACTUACION) = 2;


INSERT INTO ACTUACION VALUES (6, '25/05/2024', 'León', 4, 722);
UPDATE ACTUACION SET CIUDAD = 'León' WHERE ID_ACTUACION = 6;
INSERT INTO ACTUACION VALUES (7, '15/06/2024', 'Valladolid', 4, 732);

-- artista con 2 o 3 actuaciones
SELECT NOMBRE_ARTISTA 
FROM ARTISTA 
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
GROUP BY NOMBRE_ARTISTA 
HAVING COUNT(*) IN (2, 3);

-- 6 RENOMBRAR CACHE A SALARIO

-- 7 MOSTRAR LOS ARTISTAS CUYO SALARIO SEA INFERIOR A LA MEDIA DEL SALARIO DE LOS ARTISTAS QUE NO SEAN DE GENERO POP
 
-- 8 MOSTRAR EL NUMERO DE ARTISTAS POR GENERO
SELECT GENERO, COUNT(*) FROM ARTISTA
GROUP BY GENERO
ORDER BY COUNT(*);

-- 9 MOSTRAR LA MEDIA DEL AFORO DE LAS CIUDADES QUE COMIENZAN POR V
SELECT AVG(AFORO)
FROM ACTUACION
WHERE CIUDAD LIKE 'V%';

-- 10 MOSTARAR LAS CIUDADES Y AFORO DE LAS ACTUACIONES DE JOAQUIN SABINA
SELECT NOMBRE_ARTISTA, CIUDAD, AFORO
FROM ARTISTA
JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
WHERE NOMBRE_ARTISTA = 'Joaquín Sabina';
 
-- 11 MOSTRAR EL NUMERO DE ACTUACIONES POR MES
SELECT TO_CHAR(FECHA, 'MM') AS MES, COUNT(*) AS NUMERO_ACTUACIONES
FROM ACTUACION
GROUP BY TO_CHAR(FECHA, 'MM');

-- nombre de representantes sin artisttas
SELECT NOMBRE_REPRESENTANTE
FROM REPRESENTANTE R
WHERE NOT EXISTS (
    SELECT *
    FROM ARTISTA A
    WHERE R.ID_REPRESENTANTE = A.REPRESENTANTE_ID_REPRESENTANTE
);

-- numero de actuaciones por representante(POR ENDE, TAMBIEN CON SU NOMBRE)
SELECT NOMBRE_REPRESENTANTE, COUNT(*)
FROM ARTISTA 
    JOIN ACTUACION ON ARTISTA_ID_ARTISTA = ID_ARTISTA
    JOIN REPRESENTANTE ON REPRESENTANTE_ID_REPRESENTANTE = ID_REPRESENTANTE
GROUP BY NOMBRE_REPRESENTANTE;
```