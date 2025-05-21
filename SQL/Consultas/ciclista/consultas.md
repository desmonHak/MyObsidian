```sql
-- actualizar el campo puntos de piloto con la suma de los puntos totales
UPDATE CICLISTA 
SET puntos = (
    SELECT SUM(
            CASE 
                WHEN PARTICIPA.POSICION = 1 THEN 100
                WHEN PARTICIPA.POSICION = 2 THEN 90
                WHEN PARTICIPA.POSICION = 3 THEN 80
                WHEN PARTICIPA.POSICION = 4 THEN 70
                WHEN PARTICIPA.POSICION = 5 THEN 60
                ELSE 0
            END
        )
    FROM PARTICIPA
    WHERE PARTICIPA.CICLISTA_ID = CICLISTA.ID
    GROUP BY PARTICIPA.CICLISTA_ID
) WHERE EXISTS (
    SELECT 1
    FROM PARTICIPA
    WHERE PARTICIPA.CICLISTA_ID = CICLISTA.ID
);

-- averiguar cuantas veces un piloto quedo en una misma posicion:
select posicion, count(*) from(
    select ciclista_id, posicion 
    from participa
    where ciclista_id = 1
) group by posicion;

-- ciclistas que hayan puntuado en todas las etapas
select distinct etapa_num
from participa
order by etapa_num desc
fetch first 1 row only;

select ciclista_id, count(*)
from participa
group by ciclista_id
having count(*) = (
    select distinct etapa_num
    from participa
    order by etapa_num desc
    fetch first 1 row only
);

SELECT NOMBRE
FROM CICLISTA
WHERE EXISTS (
    SELECT CICLISTA_ID, COUNT(*)
    FROM PARTICIPA
    WHERE CICLISTA.ID = PARTICIPA.CICLISTA_ID
    GROUP BY CICLISTA_ID
    HAVING COUNT(*) > 10
);

-- nombre de los ciclista cuya edad  sea superior a la media de su equipo
SELECT NOMBRE, EDAD
FROM CICLISTA C1
WHERE EDAD > (
    SELECT AVG(EDAD) 
    FROM CICLISTA C2
    
    -- necesario enlazar la select de fuera con la de dentro para
    -- conusltar los datos se esta sub tabla
    WHERE C1.EQUIPO_COD = C2.EQUIPO_COD
);

```