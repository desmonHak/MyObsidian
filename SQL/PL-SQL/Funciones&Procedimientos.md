Ver también [[Cursores]], [[Triggers]]

# Procedimientos:

```sql
CREATE OR REPLACE PROCEDURE consultarlibro(

    vdni IN VARCHAR2,
    vnombre_l OUT VARCHAR2,
    vprecio OUT NUMBER
    
) IS
BEGIN

    SELECT nombre_l, precio INTO vnombre_l, vprecio
    FROM libro 
    WHERE dni = vdni;
    
EXCEPTION

    WHEN no_data_found THEN
        dbms_output.put_line('la consulta no a devuelto ninguna fila');
    WHEN too_many_rows THEN
        dbms_output.put_line('la consulta devuelve demasiadas filas');

END;
```

llamador por método posicional (El orden de los parámetros importa):
```sql
declare
    vDNI libro.dni % type;
    vNombre_l libro.nombre_l % type;
    vPrecio libro.precio %  type;
begin

    vdni := '&dni';
    consultarlibro(vDNI, vNombre_l, vprecio);
    dbms_output.put_line(vNombre_l);
    dbms_output.put_line(vprecio);
end;
```

llamador nominal(el orden no importa y los argumentos se identifican por su nombre):
```sql
declare
    vDNI libro.dni % type;
    vNombre_l libro.nombre_l % type;
    vPrecio libro.precio %  type;
begin

    vdni := '&dni';
    consultarlibro(vprecio => vprecio, vnombre_l => vNombre_l, vdni => vDNI);
    dbms_output.put_line(vNombre_l);
    dbms_output.put_line(vprecio);
end;
```

llamador mixto(se puede mezclar ambos tipos de paso de parámetros, pero primero ira los nominales):
```sql
declare
    vDNI libro.dni % type;
    vNombre_l libro.nombre_l % type;
    vPrecio libro.precio %  type;
begin

    vdni := '&dni';
    consultarlibro(vprecio => vprecio, vdni => vDNI, vNombre_l);
    dbms_output.put_line(vNombre_l);
    dbms_output.put_line(vprecio);
end;
```

Ejemplo de procedimiento con cursor:
```sql
create or replace procedure consultar_ciclistas(
    v_equipo in equipo.cod % type,
    v_nacionalidad in ciclista.nacionalidad % type,
    v_num out NUMBER -- cantidad de ciclistas encontrados
) is
    CURSOR get_ciclistas (
        vv_equipo in equipo.cod % type,
        vv_nacionalidad in ciclista.nacionalidad % type
    ) is 
        select ciclista.* from ciclista
        join equipo on ciclista.equipo_cod = cod
        where cod = vv_equipo and
        vv_nacionalidad = ciclista.nacionalidad;
        
    Rget_ciclistas get_ciclistas % rowtype;
begin
    v_num := 0;
    OPEN get_ciclistas(v_equipo, v_nacionalidad);
    
    FETCH get_ciclistas into Rget_ciclistas;
    while get_ciclistas %  found loop 
        v_num := v_num +1;
    
        DBMS_OUTPUT.PUT_LINE(Rget_ciclistas.id || Rget_ciclistas.nacionalidad || ' => nombre (' || Rget_ciclistas.nombre  ||
        ') edad (' || Rget_ciclistas.edad || ')'
        );
    
        FETCH get_ciclistas into Rget_ciclistas;
    end loop;
    
    CLOSE get_ciclistas;

end;
```

llamada:
```sql
declare 
    v_nums NUMBER;
begin 
    -- paso de parametros nominal
    consultar_ciclistas(v_equipo => 1, v_nacionalidad => 'España', v_num => v_nums);
    DBMS_OUTPUT.PUT_LINE('Cantidad de ciclistas entontrados ' || v_nums);
end;
/
```
![[Pasted image 20250409103847.png]]
# Funciones:
```sql
CREATE OR REPLACE FUNCTION consultarPrecio (vPrecio NUMBER) return number is
    vNumero Number := 0;
begin

    select count(*) into vNumero
    from libro
    where precio > vPrecio;
    
    return vNumero;
    
end;
```

llamador:
```sql
declare
    vNumeroFuncion Number := 0;
    vPrecio libro.precio % type;
begin
    vPrecio := &precio;
    vNumeroFuncion := consultarPrecio(vPrecio);
    dbms_output.put_line('Hay ' || vNumeroFuncion || ' libros con un precio superior a ' || vPrecio);
end;
```