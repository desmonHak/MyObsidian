[SQL SELECT TOP, LIMIT, FETCH FIRST ROWS ONLY, ROWNUM](https://www.w3schools.com/sqL/sql_top.asp)
```sql
select ca.nombre, sum(p_m)
from w_municipio    join provincia using(codpro)
                    join ca using(codca)
    group by ca.nombre
    order by sum(p_m) desc
    fetch first 3 row only; // obtiene las 3 primeras filas
```