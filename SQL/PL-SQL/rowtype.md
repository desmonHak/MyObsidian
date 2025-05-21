```sql

-- 6. Realiza un programa PL/SQL que solicite un ISBN y muestre por pantalla todos 
-- los datos de ese libro, excepto su ISBN, código editorial y DNI.
-- El formato de salida será: Nombre del libro: (nombre libro) Precio: (precio) 
-- Fecha de publicación: (fecha publicación).
declare
    -- un tipo registro
    /*type rlibro_completo is record (
        vISBN libro.isbn%type,
        vnombre_l libro.nombre_l%type,
        vprecio libro.precio%type,
        vcod libro.cod%type,
        vdni libro.dni%type,
        vfecha_publicacion libro.fecha_publicacion%type
    );
    vLibro rlibro_completo;
    */
    -- alternativa:
    vLibro libro%rowtype;
    vISBN libro.isbn%type := '&isbn';
begin 
    select *  into vLibro
    from libro
    where isbn = vISBN;
    
    dbms_output.put_line(' Nombre del libro: ' || vLibro.nombre_l );
    dbms_output.put_line('Precio: ' || vLibro.precio);
    dbms_output.put_line(' Fecha de publicación: ' ||  vLibro.fecha_publicacion);
end;
```