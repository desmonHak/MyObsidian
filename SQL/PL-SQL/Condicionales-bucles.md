
# IF:
```sql
DECLARE
    -- Camel case
    vNumLibros NUMBER;
    vNumBarato NUMBER;
    vNumCaro NUMBER;
    vPrecio NUMBER := &valor;
BEGIN

    SELECT count(*) into vNumLibros from libro;
    SELECT count(*) into vNumCaro from libro
        where precio > vPrecio;
    vNumBarato := vNumLibros - vNumCaro;
    
    IF vNumBarato*0.5 > 5 THEN
        DBMS_OUTPUT.PUT_LINE('lA MAYORIA(50%) SON BARATOS ' || vNumBarato);
    ELSIF vNumBarato*0.25 > 3 THEN
        DBMS_OUTPUT.PUT_LINE('lA MAYORIA(25%) SON ALGO BARTOS ' || vNumBarato);
    ELSE
        DBMS_OUTPUT.PUT_LINE('lA MAYORIA SON CAROS ' || vNumBarato);
    END IF;

END;
/
```

# Switch case
```sql
DECLARE
    -- Camel case
    vNumLibros NUMBER;
    vNumBarato NUMBER;
    vNumCaro NUMBER;
    vPrecio NUMBER := &valor;
BEGIN

    SELECT count(*) into vNumLibros from libro;
    SELECT count(*) into vNumCaro from libro
        where precio > vPrecio;
    vNumBarato := vNumLibros - vNumCaro;
    
    CASE
        WHEN vNumBarato*0.5 > 5 THEN
            DBMS_OUTPUT.PUT_LINE('lA MAYORIA(50%) SON BARATOS ' || vNumBarato);
        WHEN vNumBarato*0.25 > 3 THEN
            DBMS_OUTPUT.PUT_LINE('lA MAYORIA(25%) SON ALGO BARTOS ' || vNumBarato);
        ELSE
            DBMS_OUTPUT.PUT_LINE('lA MAYORIA SON CAROS ' || vNumBarato);
    END CASE;

END;
/
```

# LOOP

^e71c42

```sql
CREATE TABLE TABLAREGISTRO (
    vContador NUMBER NOT NULL,
    vTexto VARCHAR(100)
);
DECLARE 
    vContador NUMBER := 1;
    vTexto VARCHAR2(100);
    
BEGIN 

    LOOP
        vTexto := 'Esste es el registro numero: '  || vContador;
        INSERT INTO TABLAREGISTRO VALUES(vContador, vTexto);
        vContador := vContador + 1;
        EXIT WHEN vContador > 100;
    END LOOP;
END;
/
```

# WHILE

^196002

```sql
DECLARE
    vContador NUMBER := 101;
    vTexto VARCHAR2(100);
BEGIN
    WHILE vContador <= 200 loop
        vTexto := 'Esste es el registro numero: '  || vContador;
        INSERT INTO TABLAREGISTRO VALUES(vContador, vTexto);
        vContador := vContador + 1;
    end loop;
END;
/
```

# FOR

^a7a0fb

```sql
DECLARE
    vTexto VARCHAR2(100);
BEGIN
    FOR vContador IN 201 .. 300 loop
        vTexto := 'Esste es el registro numero: '  || vContador;
        INSERT INTO TABLAREGISTRO VALUES(vContador, vTexto);
    end loop;
END;
/
```

Incrementos de dos en dos
```sql
DECLARE
    vTexto VARCHAR2(100);
BEGIN
    FOR vContador IN 301 .. 400 by 2 loop
        vTexto := 'Esste es el registro numero: '  || vContador;
        INSERT INTO TABLAREGISTRO VALUES(vContador, vTexto);
    end loop;
END;
/
```


```sql
-- Suma total de los primeros N numeros naturales
DECLARE 
    vLim NUMBER := &lim;
    vSum NUMBER := 0; -- importante definir el valor
    vI2 NUMBER  := 0; -- comentar para el FOR
BEGIN
    -- forma 1:
    /*
    FOR vI IN 0 .. vLim LOOP
        vSum := vSum + vI;
    END LOOP;
    */
    
    -- forma 2:
    while vI2 < vLim loop
        vSum := vSum + vI2;
        vI2  := vI2 + 1;
    end loop;
    
    DBMS_OUTPUT.PUT_LINE('Suma total: ' || vSum);
END;
/
```
