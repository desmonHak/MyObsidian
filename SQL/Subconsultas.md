```sql
-- actualiza los datos del profesor con codigo 110 con los datos del 109
update profesor
set salpro= (
	select salpro
	from profesor
	where = 109
)
where numpro = 110;

-- cambiar los campos del 110 con los del 109
update profesor
set (salpro, compro) = (
	select salpro, compro
	from profesor
	where = 109
)
where numpro = 110;


-- subconsultas mono-registro:

select nompro
from profesor
where salpro > (
	select salpro -- la subconsulta(sub-select) genera un valor
	from profesor
	where mumpro = 105
);

-- obtiene todos los profesores donde su media sea mayor que salario
select nompro, fnapro 
from profesor 
where salpro > (
	select avg(salpro) 
	from profesor
);

select nompro
from profesor
where upper(esppro) = 'WEB' and salpro > (
	select salpro
	from profesor
	where numpro = 106
);

-- obtener todos los profesores que tiene misma especialidad
-- que Rufino Delgado, y ademas no mostrar a Rufino Delgado en los 
-- resultados, para eso usamos minus
select * from profesor where esppro = (
	select espro, from profesor
	where nompro = 'Rufino Delgado'
) 
minus  -- permite quitar un registro
select nompro -- profesor.nompro != "Rufino Delgado"
from profesor
where nompro = 'Rufino Delgado';

-- Subconsultas multi-registro
-- IN - Igual a los valores de cierta lista
-- ANY | SOME - compara los valores spor cada valor devuelto de la subconsulta
-- ALL - comprar los valores con cada uno (todos) los valores devueltos por la subsonsulta
-- NOT - Niega el operador, NOT ANY, NOT IN, NOT ALL
-- Los operadores ALL y ANY van siempre acompañados de los operadores <, > o =
-- = ANY
-- < ANY
-- > ANY
-- 
-- = ALL
-- < ALL
-- > ALL


-- mostrar n ombre de profesores cuyo salario sea menor que el de cualquier profesor de especializadad 'Software' y excluyendo a estos.
select nompro 
from profesor 
where salpro < any ( -- menor que cualquiera que salga (< any)
    select salpro -- la subconsulta devuelve mas de un registro
    from profesor
    where esppro = 'Software'
) and  esppro <> 'Software'; -- y espro sea diferente a 'Software'

-- mostrar nombre de profesores que ganan un salario igual a cualquiera 
-- de los minimos por especilidad.
select nompro 
from profesor 
where salpro = any ( -- igual que cualquiera que salga (= any)
    select min(salpro) 
    from profesor
    group by esppro
);
select nompro 
from profesor 
where salpro in ( -- mientras salpto este en los dato s devueltos(sea igual)
    select min(salpro) 
    from profesor
    group by esppro
);

-- mostrar nombre y salario de aquellos cuyo salario sea inferior a la media de los salarios por especialidad
-- tiene que se mejor todos
select nompro , salpro
from profesor 
where salpro < all ( -- igual que cualquiera que salga (= any)
    select avg(salpro)
    from profesor
    group by esppro
);



-- subconsultas multicolumna

-- mostrar nombre y fecha de nacimiento de profesores cuyo salario y comision se corresponda con salario y comision de cualquie profesor de especialidad web.
-- consulta entre pares:
select nompro, fnapro
from profesor 
where (salpro, compro) in (
    select salpro, nvl(compro, 0) -- si se encuentra un null, cambiarlo por 0
    from profesor
    where esppro = 'Web'
);

```