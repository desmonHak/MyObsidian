```sql
-- 1. Realiza un programa PL/SQL que solicite un DNI e imprima por pantalla el 
-- precio medio de los libros de ese autor.
-- El formato de salida será: El precio medio de los libros del autor con DNI 
-- (número DNI) es (precio medio) €.
DECLARE
    vdni autor.dni % TYPE := '&dni';
    vpreciomedio NUMBER;
BEGIN
    SELECT AVG(precio) INTO vpreciomedio
    FROM libro
    WHERE dni = vdni;
    
    dbms_output.put_line(
        'el autor con dni ' || vdni || 
        ' tiene libros con un precio medio de ' || vpreciomedio || ' euros' );
END;

-- 2. Realiza un programa PL/SQL que muestre por pantalla el DNI y número de libros 
-- de 'Autor 1'.
-- El formato de salida será: El Autor 1 con DNI (número DNI) tiene (número 
-- libros) libros.
declare
    vdni autor.dni % TYPE;
    vCantLibros Number;
begin
    
    select dni into vdni
    from autor
    where nombre_a = 'Gabriel Garcia Marquez';
    
    select count(*) into vCantLibros
    from libro 
    group by dni
    having dni = vdni;
    
    /*
    // alternativa
    select dni, count(*) into vdni, vCantLibros
    from libro
    join autor using(dni)
    where autor.nombre_a = 'Gabriel Garcia Marquez'
    group by dni;
    */
    dbms_output.put_line(
        'el autor con dni ' || vdni || 
        ' tiene una cantidad de ' || vCantLibros || ' libros' );
end;

-- 3. Realiza un programa PL/SQL que muestre por pantalla el nombre de la editorial 
-- con el libro más caro.
-- El formato de salida será: La editorial que tiene el libro más caro es 
-- (nombre editorial).
declare
    vPrecioLibro Libro.precio % type;
    vNombreEditorial EDITORIAL.nombre_e % type;
begin

    select max(precio)  into vpreciolibro
    from libro;
    
    select  nombre_e into vNombreEditorial
    from editorial
    join libro using(cod)
    where precio = vPrecioLibro;
    
    /*
    // alternativa
    select  nombre_e into vNombreEditorial
    from editorial
    join libro using(cod)
    where precio >= (
        select max(precio)  
        from libro
    );*/
    
    
    dbms_output.put_line(
        'El formato de salida será: La editorial que tiene el libro más caro es ' || vNombreEditorial
    );
end;

-- 4. Realiza un programa PL/SQL que muestre por pantalla el número de libros más 
-- baratos que la media.
-- El formato de salida será: Hay un total de (número de libros) más baratos que 
-- la media.
declare
    vCantLibro Number;
begin

    select count(*) into vCantLibro
    from libro
    where precio < (
        select avg(precio) from libro
    );

    dbms_output.put_line(
        'cantidad de libros ' || vCantLibro
    );

end;

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



-- 7. Realiza un programa PL/SQL que muestre por pantalla la editorial con mayor 
-- número de libros y la cantidad de libros.
-- El formato de salida será: La editorial con mayor número de libros es (nombre 
-- editorial) y tiene (número libros) libros.
declare
    vCanLibros Number;
    vNombreEditorial editorial.nombre_e%type;
begin 
    select count(cod), nombre_e into vCanLibros, vNombreEditorial
    from libro 
    join editorial using(cod)
    group by nombre_e
    order by count(*) desc
    fetch first 1 row only; 
    
    dbms_output.put_line(' La editorial con mayor número de libros es ' || vNombreEditorial || ' y tiene ' || vCanLibros || ' libros.');
end;



-- 8. Realiza un programa PL/SQL que muestre por pantalla el número de meses que no 
-- ha habido publicación de libros.
-- El formato de salida será: El número de meses sin publicar libros ha sido de: 
-- (número de meses) meses.

-- 9. Realiza un programa PL/SQL que solicite un número de mes por teclado e 
-- imprima por pantalla el número de libros publicados ese mes.
-- El formato de salida será: El número de libros publicados en el mes (número 
-- de mes) es: (número de libros).

-- 10. Realiza un programa PL/SQL que solicite un nombre de libro e imprima el 
-- número de días que han transcurrido desde su publicación.
-- El formato de salida será: El libro (nombre del libro) ha sido publicado hace 
-- (número de días) días.
```