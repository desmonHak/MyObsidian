Ver [[Condicionales-bucles]], [[Triggers]], [[Funciones&Procedimientos]], [[record-registros]], [[rowtype]], [[Conceptos|Conceptos de bases de datos]]

Ejercicios
1. [[BC4_Ejercicios_1]]
2. [[BC4_Ejercicios_4 -Bucles]]
3. [[BC4_Ejercicios_8-Procedimientos y funcionesBiblioteca]]
4. [[BC4_Ejercicios_9-Procedimientos y funcionesCamping]]

```sql
DECLARE
    -- variables con prefijo v
    vNumlibros NUMBER;
    vDNIconsulta VARCHAR2(10) := '&dni'; -- eje: 123456789A
    
BEGIN

    select count(*) into vNumlibros -- vNumlibros = count(*)
    from libro
    where dni = vDNIconsulta;
    
    -- habilitar en ver > Salida DBMS
    DBMS_OUTPUT.PUT_LINE('El escritor con DNI ' || vDNIconsulta || ' tiene ' || vNumlibros || ' libros' );
END; 
```
Todo bloque PL/SQL tiene un BEGIN-DECLARE, mientras, el DECLARE es opcional.

`vDNIconsulta` será una "variable de sustitución", el valor se indica en tiempo de ejecución con una ventanita.


Para que `DBMS_OUTPUT.PUT_LINE` función, es necesario habilitar la salida `DBMS`:
![[Pasted image 20250312105122.png]]

```sql
DECLARE
    -- variables con prefijo v
    vNumlibros NUMBER;
    vDNIconsulta LIBRO.DNI % TYPE; -- eje: determinar el tipo segun sea el campo LIBRO.DNI

BEGIN
    vDNIconsulta := '&dni';
    select count(*) into vNumlibros
    from libro
    where dni = vDNIconsulta;
    
    -- habilitar en ver > Salida DBMS
    DBMS_OUTPUT.PUT_LINE('El escritor con DNI ' || vDNIconsulta || ' tiene ' || vNumlibros || ' libros' );
END; 
```

En este caso el `LIBRO.DNI % TYPE` permite indicar que la variable `vDNIconsulta` será del mismo tipo que el campo DNI de la tabla LIBRO.

```sql
DECLARE
    -- variables con prefijo v
    vNombrelibro LIBRO.NOMBRE_L % TYPE;
    vPrecio LIBRO.PRECIO % TYPE; -- eje: determinar el tipo segun sea el campo LIBRO.DNI

BEGIN
    select NOMBRE_L, PRECIO into vNombrelibro, vPrecio
    from libro
    where isbN = '9781234567890';
    
    -- habilitar en ver > Salida DBMS
    DBMS_OUTPUT.PUT_LINE(
        'El LIBRO CON isbn 9781234567890 se llama ' || vNombrelibro || 
        ' y tiene un precio de ' || vPrecio || ' euros' );
END; 
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
        vI2 := vI2 + 1;
    end loop;
    
    DBMS_OUTPUT.PUT_LINE('Suma total: ' || vSum);
END;
/

-- dada una temperatura en grados celsius pasarlo a fahrenheit
declare 
    vCelsius NUMBER := &grados;
begin
    -- 35,6 grados F (2 grados C)  -   33,8 grados F (1 grados C) = 1.8 grados F por cada C
    DBMS_OUTPUT.PUT_LINE('Celsius ' || vCelsius  ||  ' : fahrenheit ' || (vCelsius * 1.8 + 32));
end;
/

DECLARE 
    vMes NUMBER := &mes;
    vDias NUMBER := 0;
BEGIN
-- DBMS_RANDOM.VALUE(low => 13, high => 100);
    case
        when vMes = 2 THEN
            vDias := 28;
        when vMes = 1 OR vMes = 3 OR vMes = 5 or (vMES >= 7 and vMES <=10) OR vMes = 12  THEN
            vDias := 31;
        when vMes = 6 OR vMes = 4 OR vMes = 9 OR vMes = 11 THEN
            vDias := 30;
        ELSE
            vDias := 0;
    end case;
    DBMS_OUTPUT.PUT_LINE('Numero de dias ' || vDias);
END; 
/

```