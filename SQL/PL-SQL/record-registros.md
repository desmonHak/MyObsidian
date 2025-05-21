```sql
-- 5. Realiza un programa PL/SQL que solicite un ISBN por teclado e imprima por 
-- pantalla todos los datos de ese libro.
-- El formato de salida será: ISBN: (número ISBN) Nombre del libro: (nombre 
-- libro) Precio: (precio) Código editorial: (código) DNI: (DNI) Fecha de 
-- publicación: (fecha publicación).
declare
    -- un tipo registro
    type rlibro_completo is record (
        vISBN libro.isbn%type,
        vnombre_l libro.nombre_l%type,
        vprecio libro.precio%type,
        vcod libro.cod%type,
        vdni libro.dni%type,
        vfecha_publicacion libro.fecha_publicacion%type
    );
    vLibro rlibro_completo;
    vISBN libro.isbn%type := '&isbn';
begin 
    select *  into vLibro
    from libro
    where isbn = vISBN;
    
    dbms_output.put_line('ISBN: ' || vISBN ||' Nombre del libro: ' || vLibro.vnombre_l );
    dbms_output.put_line('Precio: ' || vLibro.vprecio || ' Código editorial: ' || vLibro.vcod);
    dbms_output.put_line('DNI: ' || vLibro.vdni || ' Fecha de publicación: ' ||  vLibro.vfecha_publicacion);
end;

```