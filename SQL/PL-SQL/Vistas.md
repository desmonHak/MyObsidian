```sql
CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW vista [(alias[, alias2...])] AS 
consultaSELECT
[WITH CHECK OPTION [CONSTRAINT restricción]]
[WITH READ ONLY [CONSTRAINT restricción]]
```


```sql
CREATE VIEW resumen 
-- alias 
(id_localidad, localidad, poblacion, n_provincia, provincia,superficie, capital_provincia, id_comunidad, comunidad, capital_comunidad)
AS 
(  SELECT l.id_localidad, l.nombre, l.poblacion, 
          n_provincia, p.nombre, p.superficie, l2.nombre, 
          id_comunidad, c.nombre, l3.nombre
  FROM localidades l
  JOIN provincias p USING (n_provincia)
  JOIN comunidades c USING (id_comunidad)
  JOIN localidades l2 ON (p.id_capital=l2.id_localidad)
  JOIN localidades l3 ON (c.id_capital=l3.id_localidad)
);

-- uso de la vista:
SELECT DISTINCT (comunidad, capital_comunidad) 
FROM resumen; 
/* La vista pasa a utilizarse como si fuera una tabla normal*/
```
Las vistas permiten la trata de datos de una manera mas sencilla sin ocupar espacio, los datos de la vista residen en sus tablas originales. La excepción a esto son las listas materializadas.