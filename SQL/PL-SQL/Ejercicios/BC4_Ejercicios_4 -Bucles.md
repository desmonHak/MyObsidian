```sql
-- 1. Realiza un programa PL/SQL que muestre por pantalla el siguiente texto, 
-- dependiendo del número de reservas que tiene la parcela de mayor tamaño. • Si 
-- el número de reservas es mayor que 2: La parcela de mayor tamaño está muy 
-- solicitada. Tiene (número reservas) reservas. • Si el número de reservas es 
-- mayor o igual que 1: La parcela de mayor tamaño está algo solicitada. Tiene 
-- (número reservas) reservas. • En cualquier otro caso se mostrará el texto: La 
-- parcela de mayor tamaño no tiene todavía reservas. Tiene (número reservas) 
-- reservas.

declare
    vNumero NUMBER := 0;
begin
    select count(*) into vNumero
    from reserva join parcela using(id)
    where tamaño = (
        select max(tamaño)
        from parcela;
    )
    if vNumero > 2 then
    end if
    
end;

-- 2. Realiza un programa PL/SQL que solicite un DNI por teclado y muestre por 
-- pantalla: • El nombre y apellidos en mayúsculas de ese cliente si el día de 
-- hoy es par. • El nombre y apellidos en minúsculas de ese cliente si el día 
-- de hoy es impar. El formato de salida será: El cliente con DNI (número DNI) 
-- es (nombre y apellidos).
declare
    vDNI cliente.dni % type := '&dni';
    vNombre cliente.nombre % type;
    vApellidos cliente.apellidos % type;
begin
    select nombre, apellidos into vNombre, vApellidos
    from cliente
    where dni = vDNI;
    
    dbms_output.put_line(SYSDATE);
    if (mod(TO_CHAR(SYSDATE, 'DD'), 2) = 0) then
        dbms_output.put_line(upper(vNombre || ' ' || vApellidos));
    else
        dbms_output.put_line(lower(vNombre || ' ' || vApellidos));
    end if;
end;

select substr('aaabbb', 4, 1) SUBSTRING from dual;

-- 5. Realiza un programa PL/SQL que imprima por pantalla los apellidos al 
-- revés de un cliente concreto, introduciendo su DNI por teclado.
declare
    vDNI cliente.dni % type := '&dni';
    vNombre cliente.nombre % type;
    vApellidos cliente.apellidos % type;
begin 
    select nombre, apellidos into vNombre, vApellidos
    from cliente
    where dni = vDNI;
    
    for i in  1 .. LENGTH(vNombre) loop
        dbms_output.put(substr(vNombre, LENGTH(vNombre) - i+1, 1));
    end loop;
    dbms_output.put_line('');
    
    -- LENGTH -> tamño del str
    for i in  1 .. LENGTH(vApellidos) loop
        dbms_output.put(substr(vApellidos, LENGTH(vApellidos) - i +1, 1));
    end loop;
    dbms_output.put_line('');
end;

```



```sql
-- Cada cliente tiene un numero de reservas. Mostrar los clientes que tienen un numero
-- de reserva, mayor que la media de numeros de reserva de todos los clientes
declare
    vDNI RESERVA.DNI % TYPE;
    vCantidadReservas NUMBER;
    
    CURSOR cReservas is 
        select DNI, COUNT(*) from reserva
        group by DNI
        having count(*) > (
            -- numero medio de reservas:
            select avg(num) from (
                select count(*) as num from reserva  group by DNI
            )
        );
begin
    OPEN cReservas;
    
    LOOP
        EXIT WHEN cReservas % NOTFOUND;
        FETCH cReservas INTO vDNI, vCantidadReservas;
        
        DBMS_OUTPUT.PUT_LINE('DNI -> ' || vDNI || ' A RESERVADO UNA CANTIDAD DE VECES DE: ' || vCantidadReservas || ' LO CUAL ES SUPERIOR A LA CANTIDAD DE VECES RESERVADAS DE MEDIA');
    END LOOP;
    
    CLOSE cReservas;
end;
/
```