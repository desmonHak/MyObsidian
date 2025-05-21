Ver también [[Condicionales-bucles]]

1. para hacer el cursor, se debe declarar primero en el ``delcare``.
```sql
CURSOR cursorAutores is 
        -- select del cursor:
        select DNI, count(*) as numLibros
        from autor join libro using(dni)
        group by dni
        order by numLibros desc;
begin
```
La ``select`` del cursor puede ser tan compleja como se dese. En este caso la consulta devuelve dos columnas y múltiples filas.

2. Se debe abrir el cursor con la sentencia ``OPEN`` en el ``begin``:
```sql
-- el el cursor cursorAutores
OPEN cursorAutores;
```

3. Se debe usar la sentencia ``FETCH`` para obtener un registro (conjunto de valores de una fila).
4. Se debe cerrar el cursor cuando no queden mas datos sobre los que iterar:
```sql
-- cerrar el cursor:
CLOSE cursorAutores;
```

Los cursores también pueden recibir argumentos:
```sql
    CURSOR c_puntuaciones (num_ciclistas NUMBER) IS
        SELECT C.nombre, E.DESCRIPCION, p.posicion
        from participa p JOIN ciclista c on p.ciclista_id = c.id
        join etapa e on p.etapa_num = e.num
        where c.id = num_ciclistas
        order by p.POSICION;
```


uso:
```sql
    OPEN c_puntuaciones(v_id_ciclista);

    FETCH c_puntuaciones into v_nombre_ciclista, v_nombre_etapa, v_posicion;
    DBMS_OUTPUT.PUT_LINE('Participaciones con puntuacion del ciclista: ' || v_nombre_ciclista);
    DBMS_OUTPUT.PUT_LINE('******************************************************************');
    

    WHILE c_puntuaciones % found loop

        DBMS_OUTPUT.PUT_LINE('Etapa: ' || v_nombre_etapa || ' posicion: '  || v_posicion);

        FETCH c_puntuaciones into v_nombre_ciclista, v_nombre_etapa, v_posicion;
    end loop;

    close c_puntuaciones;
```

Al hacer el `OPEN` se debe pasar el parámetro al cursor:
![[Pasted image 20250409100818.png]]
## [[Condicionales-bucles#^e71c42|LOOP]]:
```sql
declare
    vDNI AUTOR.DNI % TYPE;
    vNumLibros NUMBER := 0;
    
    CURSOR cursorAutores is 
        -- select del cursor:
        select DNI, count(*) as numLibros
        from autor join libro using(dni)
        group by dni
        order by numLibros desc;
begin

    -- el el cursor cursorAutores
    OPEN cursorAutores;
    
    LOOP
    
        -- en el into, a de ir los campos en el mismo orden que la select del cursor
        FETCH cursorAutores INTO vDNI, vNumLibros;
        
        -- si el cursor no contiene mas registros, salir del bucle:
        EXIT WHEN cursorAutores % NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vDNI || ' == ' || vNumLibros);
    
    END LOOP;

    -- cerrar el cursor:
    CLOSE cursorAutores;

end;
/
```

## [[Condicionales-bucles#^196002|WHILE]]:
```sql
declare
    vDNI AUTOR.DNI % TYPE;
    vNumLibros NUMBER := 0;
    
    CURSOR cursorAutores is 
        -- select del cursor:
        select DNI, count(*) as numLibros
        from autor join libro using(dni)
        group by dni
        order by numLibros desc;
begin

    -- el el cursor cursorAutores
    OPEN cursorAutores;
    
    FETCH cursorAutores INTO vDNI, vNumLibros;
    
    --  % FOUND  -> indica si aun hay datos
    WHILE cursorAutores % FOUND LOOP

        -- el fetch, no debe ir aqui, debe hacerse una pre-lectura
        -- FETCH cursorAutores INTO vDNI, vNumLibros;
        
        DBMS_OUTPUT.PUT_LINE(vDNI || ' == ' || vNumLibros);
        FETCH cursorAutores INTO vDNI, vNumLibros;
    END LOOP;

    -- cerrar el cursor:
    CLOSE cursorAutores;

end;
/
```
## [[Condicionales-bucles#^a7a0fb|FOR]]:
Usando `FOR` no es necesario abrir ni cerrar el cursor, el ``FOR`` se encarga de abrir y cerrar el cursor, y de hacer un ``FETCH`` almacenando el resultado de cada iteración en `vAutores` el cual es un [[record-registros|RECORD.]]
```sql
declare
    CURSOR cursorAutores is 
        -- select del cursor:
        select DNI, count(*) as numLibros
        from autor join libro using(dni)
        group by dni
        order by numLibros desc;
begin

    FOR vAutores in cursorAutores LOOP
        DBMS_OUTPUT.PUT_LINE(vAutores.DNI || ' == ' || vAutores.NumLibros);
    END LOOP;

end;
/
```

----
# Registros de tipo cursor
Se debe usar ``%ROWTYPE`` para crear la variable de tipo cursor.
```sql
declare
    CURSOR cAutores is 
        -- select del cursor:
        select DNI, count(*) as numLibros
        from autor join libro using(dni)
        group by dni
        order by numLibros desc;
        
    rAutores cAutores % ROWTYPE;
begin
    OPEN cAutores;
    LOOP
        FETCH cAutores INTO rAutores;
        DBMS_OUTPUT.PUT_LINE(rAutores.DNI || ' == ' || rAutores.NumLibros);
        EXIT WHEN cAutores % NOTFOUND;
    END LOOP;
    CLOSE cAutores;

end;
/
```


# Usando registros de tipo [[record-registros|RECORD.]]
```sql
declare
    TYPE registroAutor IS RECORD(
        vDNI AUTOR.DNI % TYPE,
        vNumLibros NUMBER 
    );
    
    libroAutor registroAutor;

    CURSOR cAutores is 
        -- select del cursor:
        select DNI, count(*) as numLibros
        from autor join libro using(dni)
        group by dni
        order by numLibros desc;

begin
    OPEN cAutores;
    LOOP
        FETCH cAutores INTO libroAutor;
        DBMS_OUTPUT.PUT_LINE(libroAutor.vDNI || ' == ' || libroAutor.vNumLibros);
        EXIT WHEN cAutores % NOTFOUND;
    END LOOP;
    CLOSE cAutores;

end;
/
```



```sql
declare

    TYPE recordLibros IS RECORD(
        COD EDITORIAL.COD% TYPE,
        num_libros NUMBER,
        precio_medio NUMBER
    );

    CURSOR cLibros is 
        -- select del cursor:
        SELECT COD, COUNT(*) as "num_libros", AVG(PRECIO) as "precio_medio" FROM LIBRO
        GROUP BY COD;
        
    rLibros recordLibros;

begin
    OPEN cLibros;
    LOOP
        FETCH cLibros INTO rLibros;
        DBMS_OUTPUT.PUT_LINE(rLibros.COD || ' == ' || ' cantidad: '  || rLibros.num_libros || ' media: ' || rLibros.precio_medio );
        EXIT WHEN cLibros % NOTFOUND;
    END LOOP;
    CLOSE cLibros;

end;
/
```
![[Pasted image 20250328094156.png]]
