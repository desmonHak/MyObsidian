
```sql
-- 1. Mostrar el número de clientes que existen en la BD
SELECT COUNT(*) AS "CANTIDAD DE CLIENTES" FROM CLIENTE;

-- 2. Mostrar la edad promedio de los clientes redondeada a 2 decimales.

-- Obtener cuanto pesa y mide un piloto de media, redondeando a 
-- dos decimales, ademas se obtiene la fecha de nacimiento media
--SELECT 
        -- ROUND: Redondea al número entero más cercano.
        --ROUND(
            -- AVG: Calcula la media de esos valores numéricos.
            --AVG( 
                -- Convierte las fechas en un número (días desde 1970-01-01).
                -- TO_NUMBER: Se asegura de que la fecha sea tratada como un número.
                --TO_NUMBER(FECHA_NAC - DATE '1970-01-01')
            --), 0
            -- '+ DATE '1970-01-01'': Convierte el número promedio de vuelta a una fecha.
        --) AS "Fecha media de nacimiento"
--FROM cliente;
    
SELECT AVG(TRUNC ( ( 
TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) -  TO_NUMBER(TO_CHAR(FECHA_NAC,'YYYYMMDD') ) 
) / 10000)) AS EDAD FROM CLIENTE;

-- restar dos fechas devuelve el numero de dias
SELECT ROUND((AVG(SYSDATE - FECHA_NAC)/ 365), 2) FROM CLIENTE;


--3. Mostrar el identificador de la parcela con mayor tamaño.
SELECT *  FROM PARCELA WHERE TAMAÑO = (
    SELECT MAX(TAMAÑO) FROM PARCELA
);

--4. Mostrar el promedio del tamaño de las parcelas redondeado a 2 decimales.
SELECT ROUND(AVG(TAMAÑO),2) FROM PARCELA;

--5. Mostrar el número de reservas que hay por cada parcela.
SELECT ID, COUNT(*) 
    FROM RESERVA 
    GROUP BY ID
    ORDER BY COUNT(*) DESC;
    

--6. Mostrar el ide de la parcela más reservada, junto al número de veces que ha  sido reservada.
-- no seria del todo correctos pues no mostraria todos los registros con el valor max
SELECT ID, COUNT(*) 
    FROM RESERVA 
    GROUP BY ID
    ORDER BY COUNT(*) DESC
    FETCH NEXT 1 ROW ONLY;
    
SELECT ID, COUNT(*)
            FROM RESERVA
    GROUP BY ID
    HAVING COUNT(*) = (
        SELECT COUNT(*) -- cantidad de veces que una parcela a sido reservada mas
        FROM RESERVA
        GROUP BY ID
        ORDER BY COUNT(*) DESC
        FETCH NEXT 1 ROW ONLY
    );


--7. Mostrar el nombre y apellidos de cada cliente, junto a su edad en años.
SELECT NOMBRE, APELLIDOS, TRUNC ((SYSDATE - FECHA_NAC) / 365) AS "EDAD" FROM CLIENTE ;

--8. Mostrar la superficie total de todas las parcelas.
SELECT SUM(TAMAÑO) AS "SUPERFICIE SUMANDO TODAS LAS SUPERFICIES DE LAS PARCELAS" FROM PARCELA;

--9. Mostrar el nombre completo de los clientes que han realizado alguna reserva.
SELECT concat(concat(nombre, ' '), apellidos) 
FROM CLIENTE JOIN RESERVA USING(DNI) 
    GROUP BY concat(concat(nombre, ' '), apellidos);


select nombre || ' ' || apellidos
from CLIENTE 
where exists (
    select * -- donde existe registros con dni
    from reserva
    where CLIENTE.dni = reserva.dni
);

--10. Mostrar el nombre completo y la fecha de nacimiento de los clientes que han realizado una reserva en una parcela específica (P1).
SELECT (nombre || ' ' || apellidos), FECHA_NAC 
    FROM RESERVA
    JOIN CLIENTE USING(DNI)
    where id = 'P001';

--11. Mostrar los dni de los clientes que han realizado una reserva en alguna parcela con tamaño mayor a 200.
SELECT DISTINCT DNI 
FROM RESERVA JOIN PARCELA USING(ID)
WHERE TAMAÑO > 200;

--12. Mostrar nombre y apellidos del cliente de mayor edad.
SELECT NOMBRE, APELLIDOS  
FROM CLIENTE  
WHERE ROUND (MONTHS_BETWEEN(SYSDATE, FECHA_NAC)) = (  
    SELECT MAX(ROUND(MONTHS_BETWEEN(SYSDATE, FECHA_NAC))) FROM CLIENTE  
);  
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, FECHA_NAC)/12) FROM CLIENTE;

--13. Mostrar nombre y apellidos de los clientes junto al número de reservas  que han realizado (ordenado por número de reservas en orden descendente).
SELECT NOMBRE || ' ' || APELLIDOS AS NOMBRE, COUNT(*)  
FROM CLIENTE JOIN RESERVA USING(DNI)  
GROUP BY NOMBRE || ' ' || APELLIDOS    
ORDER BY COUNT(*) DESC;

--14. Mostrar el número de reservas por año.
SELECT EXTRACT(YEAR FROM(F_ENTRADA)) AS AÑO, COUNT(*) AS "Nº DE RESERVAS"  
FROM RESERVA  
GROUP BY EXTRACT(YEAR FROM (F_ENTRADA))  
ORDER BY AÑO;

--15. Mostrar el número de clientes nacidos por cada año.
SELECT EXTRACT (YEAR FROM(FECHA_NAC)) AS AÑO, COUNT(*) AS "Nº DE CLIENTE"  
FROM CLIENTE  
GROUP BY EXTRACT(YEAR FROM(FECHA_NAC))  
ORDER BY AÑO;
```