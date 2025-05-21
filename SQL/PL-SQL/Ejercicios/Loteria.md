Generar 25 números aleatorios de loteria y obtener los 6 primeros numeros con mas  frecuencia.

Los números de la lotería van del 1 al 49

```sql
/*create table if not exists Numeros (
    Numero NUMBER
);*/
DROP TABLE Numeros CASCADE CONSTRAINTS;
create TABLE Numeros (
    Numero NUMBER
);

DROP TABLE NApariciones CASCADE CONSTRAINTS;
create TABLE NApariciones (
    Numero NUMBER,
    Apariciones NUMBER
);


DECLARE
    vRand Number :=  ROUND(DBMS_RANDOM.VALUE(low => 1, high => 49));
    vApariciones NUMBER := 0;
    
    CURSOR cNumeros is
        select DISTINCT Numero from Numeros;
    
BEGIN

    -- generar numeros aleatorios para la tabla:
    for i in 1 .. 25 loop
        INSERT INTO Numeros values (vRand);
        vRand :=  ROUND(DBMS_RANDOM.VALUE(low => 1, high => 49));
    end loop;
    
    -- obtener los distintos numeros
    FOR rNumeros in cNumeros loop
        select count(*) into vApariciones 
        from Numeros where Numero = rNumeros.Numero;
        
        DBMS_OUTPUT.PUT_LINE('El numero: ' || rNumeros.Numero || ' aparece una cantidad de veces de: ' || vApariciones);
        INSERT INTO NApariciones values (rNumeros.Numero, vApariciones);
    end loop;
    
END;
/

select * from NApariciones 
order by Apariciones desc
fetch first 6 row only;
```