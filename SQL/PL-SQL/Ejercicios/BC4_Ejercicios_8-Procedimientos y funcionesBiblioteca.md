```sql
-- 1. Realiza un procedimiento que acepte como parámetro de entrada el dni de 
-- un autor y devuelva como parámetro de salida, el número de libros que ha 
-- publicado. 

-- 2. Realiza una función que acepte como parámetros un precio y un DNI, y 
-- devuelva el número de libros de dicho DNI con precio inferior al indicado. 

-- 3. Realiza un procedimiento que acepte como parámetro de entrada/salida 
-- un número (porcentaje de subida). El procedimiento debe aumentar el precio 
-- de todos los libros en dicho porcentaje y devolver en el mismo parámetro el 
-- precio medio de los libros resultante. 

-- 4. Realiza una función que devuelva el precio medio de los libros de un
-- autor cuyo DNI se pasa por parámetro.
CREATE OR REPLACE PROCEDURE precioMedio (vDNI IN varchar2, precioMedio OUT NUMBER) is
begin

    select avg(precio) into precioMedio
    from libro where dni = vDNI;
    
end;
    

declare
    vPrecio libro.precio % type;
begin
    precioMedio('022345678T', vPrecio);
    dbms_output.put_line('El precio medio es ' || vPrecio);
end;
```
