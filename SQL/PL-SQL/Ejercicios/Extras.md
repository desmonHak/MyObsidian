```sql
--*************************************************
--*************************************************
-- EJERCICIO VUELTA CICLISTA 
-- PARA CALCULAR LOS PUNTOS:
-- 1º 100
-- 2º 90
-- 3º 80
-- 4º 70
-- 5º 60
--*************************************************
--*************************************************

DROP TABLE CICLISTA CASCADE CONSTRAINT;
DROP TABLE EQUIPO CASCADE CONSTRAINT;
DROP TABLE ETAPA CASCADE CONSTRAINT;
DROP TABLE PARTICIPA CASCADE CONSTRAINT;

CREATE TABLE ciclista (
    id           NUMBER NOT NULL,
    nombre       VARCHAR2(25),
    edad         NUMBER,
    nacionalidad VARCHAR2(25),
    puntos       NUMBER DEFAULT 0,
    equipo_cod   NUMBER NOT NULL
);

ALTER TABLE ciclista ADD CONSTRAINT ciclista_pk PRIMARY KEY ( id );

CREATE TABLE equipo (
    cod    NUMBER NOT NULL,
    nombre VARCHAR2(25)
);

ALTER TABLE equipo ADD CONSTRAINT equipo_pk PRIMARY KEY ( cod );

CREATE TABLE etapa (
    num         NUMBER NOT NULL,
    descripcion VARCHAR2(50),
    tipo        VARCHAR2(25),
    fecha       DATE,
    distancia   NUMBER
);

ALTER TABLE etapa
    ADD CHECK ( tipo IN ( 'Contrarreloj Individual', 'Contrarreloj por Equipos', 'Larga', 'Montaña' ) );

ALTER TABLE etapa ADD CONSTRAINT etapa_pk PRIMARY KEY ( num );

CREATE TABLE participa (
    etapa_num   NUMBER NOT NULL,
    ciclista_id NUMBER NOT NULL,
    posicion    NUMBER
);

ALTER TABLE participa ADD CONSTRAINT participa_pk PRIMARY KEY ( etapa_num,
                                                                ciclista_id );

ALTER TABLE ciclista
    ADD CONSTRAINT ciclista_equipo_fk FOREIGN KEY ( equipo_cod )
        REFERENCES equipo ( cod );

ALTER TABLE participa
    ADD CONSTRAINT participa_ciclista_fk FOREIGN KEY ( ciclista_id )
        REFERENCES ciclista ( id );

ALTER TABLE participa
    ADD CONSTRAINT participa_etapa_fk FOREIGN KEY ( etapa_num )
        REFERENCES etapa ( num );

        
-- Inserción de registros

INSERT INTO equipo (cod, nombre) VALUES (1, 'Movistar Team');
INSERT INTO equipo (cod, nombre) VALUES (2, 'Ineos Grenadiers');
INSERT INTO equipo (cod, nombre) VALUES (3, 'Jumbo-Visma');
INSERT INTO equipo (cod, nombre) VALUES (4, 'UAE Team Emirates');
INSERT INTO equipo (cod, nombre) VALUES (5, 'Bahrain Victorious');
INSERT INTO equipo (cod, nombre) VALUES (6, 'Alpecin-Deceuninck');
INSERT INTO equipo (cod, nombre) VALUES (7, 'Soudal-QuickStep');
INSERT INTO equipo (cod, nombre) VALUES (8, 'Team DSM');
INSERT INTO equipo (cod, nombre) VALUES (9, 'EF Education-EasyPost');
INSERT INTO equipo (cod, nombre) VALUES (10, 'Groupama-FDJ');



INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (1, 'Jonas Vingegaard', 27, 'Dinamarca', 2);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (2, 'Primoz Roglic', 34, 'Eslovenia', 2);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (3, 'Sepp Kuss', 29, 'Estados Unidos', 2);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (4, 'Remco Evenepoel', 24, 'Bélgica', 3);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (5, 'Mattia Cattaneo', 33, 'Italia', 3);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (6, 'Egan Bernal', 27, 'Colombia', 4);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (7, 'Geraint Thomas', 38, 'Reino Unido', 4);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (8, 'Enric Mas', 29, 'España', 1);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (9, 'Carlos Verona', 31, 'España', 1);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (10, 'Juan Ayuso', 21, 'España', 5);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (11, 'Joao Almeida', 26, 'Portugal', 5);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (12, 'Aleksandr Vlasov', 28, 'Rusia', 6);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (13, 'Jai Hindley', 28, 'Australia', 6);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (14, 'Rigoberto Urán', 37, 'Colombia', 7);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (15, 'Hugh Carthy', 30, 'Reino Unido', 7);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (16, 'Mikel Landa', 34, 'España', 8);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (17, 'Santiago Buitrago', 24, 'Colombia', 8);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (18, 'Ben O’Connor', 28, 'Australia', 9);
INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (19, 'Geoffrey Bouchard', 32, 'Francia', 9);

INSERT INTO ciclista (id, nombre, edad, nacionalidad, equipo_cod) VALUES (20, 'Thibaut Pinot', 34, 'Francia', 10);



INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (1, 'Barcelona a Barcelona', 'Contrarreloj Individual', TO_DATE('2024-08-26', 'YYYY-MM-DD'), 14.6);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (2, 'Mataró a Barcelona', 'Larga', TO_DATE('2024-08-27', 'YYYY-MM-DD'), 181.3);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (3, 'Súria a Arinsal (Andorra)', 'Montaña', TO_DATE('2024-08-28', 'YYYY-MM-DD'), 158.5);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (4, 'Andorra la Vella a Tarragona', 'Larga', TO_DATE('2024-08-29', 'YYYY-MM-DD'), 183.7);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (5, 'Tarragona a Burriana', 'Larga', TO_DATE('2024-08-30', 'YYYY-MM-DD'), 186.5);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (6, 'La Vall d’Uixó a Castellón', 'Montaña', TO_DATE('2024-08-31', 'YYYY-MM-DD'), 148.2);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (7, 'Utiel a Oliva', 'Larga', TO_DATE('2024-09-01', 'YYYY-MM-DD'), 201.5);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (8, 'Dénia a Xorret de Catí', 'Montaña', TO_DATE('2024-09-02', 'YYYY-MM-DD'), 165.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (9, 'Cartagena a Caravaca de la Cruz', 'Montaña', TO_DATE('2024-09-03', 'YYYY-MM-DD'), 180.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (10, 'Vélez-Málaga a Córdoba', 'Larga', TO_DATE('2024-09-04', 'YYYY-MM-DD'), 198.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (11, 'Antequera a Valdepeñas de Jaén', 'Montaña', TO_DATE('2024-09-05', 'YYYY-MM-DD'), 175.5);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (12, 'Jaén a Córdoba', 'Larga', TO_DATE('2024-09-06', 'YYYY-MM-DD'), 193.2);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (13, 'Alcalá la Real a Sierra de La Pandera', 'Montaña', TO_DATE('2024-09-07', 'YYYY-MM-DD'), 160.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (14, 'La Pandera a Sierra Nevada', 'Montaña', TO_DATE('2024-09-08', 'YYYY-MM-DD'), 153.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (15, 'Martos a Jaén', 'Contrarreloj por Equipos', TO_DATE('2024-09-09', 'YYYY-MM-DD'), 32.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (16, 'Linares a Puertollano', 'Larga', TO_DATE('2024-09-10', 'YYYY-MM-DD'), 182.5);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (17, 'Puertollano a Toledo', 'Larga', TO_DATE('2024-09-11', 'YYYY-MM-DD'), 200.7);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (18, 'Alcalá de Henares a Madrid', 'Larga', TO_DATE('2024-09-12', 'YYYY-MM-DD'), 195.5);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (19, 'Madrid a Guadarrama', 'Montaña', TO_DATE('2024-09-13', 'YYYY-MM-DD'), 145.2);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (20, 'Guadarrama a Madrid', 'Larga', TO_DATE('2024-09-14', 'YYYY-MM-DD'), 101.0);
INSERT INTO etapa (num, descripcion, tipo, fecha, distancia) VALUES (21, 'Las Rozas a Madrid (Paseo de la Castellana)', 'Larga', TO_DATE('2024-09-15', 'YYYY-MM-DD'), 105.8);


-- Ciclistas participando en diferentes etapas y posiciones

-- Etapa 1: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (1, 1, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (1, 2, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (1, 9, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (1, 4, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (1, 6, 5);  

-- Etapa 2: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (2, 2, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (2, 1, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (2, 3, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (2, 5, 4); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (2, 4, 5); 

-- Etapa 3: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (3, 7, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (3, 3, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (3, 10, 3);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (3, 8, 4); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (3, 5, 5); 

-- Etapa 4: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (4, 6, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (4, 9, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (4, 4, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (4, 11, 4);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (4, 12, 5);

-- Etapa 5: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (5, 3, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (5, 1, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (5, 2, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (5, 6, 4); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (5, 10, 5);

-- Etapa 6: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (6, 7, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (6, 1, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (6, 2, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (6, 5, 4); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (6, 6, 5); 

-- Etapa 7: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (7, 3, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (7, 4, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (7, 8, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (7, 12, 4);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (7, 5, 5); 

-- Etapa 8: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (8, 2, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (8, 6, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (8, 7, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (8, 1, 4); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (8, 4, 5); 

-- Etapa 9: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (9, 3, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (9, 5, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (9, 2, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (9, 8, 4); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (9, 4, 5); 

-- Etapa 10: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (10, 9, 1);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (10, 1, 2);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (10, 7, 3);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (10, 6, 4);
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (10, 2, 5);

-- Etapa 11: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (11, 12, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (11, 3, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (11, 6, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (11, 2, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (11, 4, 5);  

-- Etapa 12: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (12, 8, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (12, 5, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (12, 7, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (12, 1, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (12, 9, 5);  

-- Etapa 13: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (13, 4, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (13, 7, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (13, 2, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (13, 6, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (13, 12, 5); 

-- Etapa 14: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (14, 2, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (14, 3, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (14, 5, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (14, 6, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (14, 12, 5); 

-- Etapa 15: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (15, 7, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (15, 4, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (15, 1, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (15, 5, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (15, 8, 5);  

-- Etapa 16: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (16, 3, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (16, 6, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (16, 12, 3); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (16, 2, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (16, 5, 5);  

-- Etapa 17: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (17, 4, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (17, 8, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (17, 5, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (17, 7, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (17, 6, 5);  

-- Etapa 18: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (18, 12, 1); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (18, 3, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (18, 6, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (18, 2, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (18, 5, 5);  

-- Etapa 19: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (19, 4, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (19, 2, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (19, 7, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (19, 1, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (19, 5, 5);  

-- Etapa 20: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (20, 9, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (20, 12, 2); 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (20, 6, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (20, 2, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (20, 5, 5);  

-- Etapa 21: 
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (21, 4, 1);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (21, 3, 2);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (21, 1, 3);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (21, 2, 4);  
INSERT INTO participa (etapa_num, ciclista_id, posicion) VALUES (21, 5, 5);  

COMMIT;





DECLARE

    v_ID_CICLISTA CICLISTA.ID%TYPE:=&ID;
    v_nombre_ciclista ciclista.nombre%TYPE;
    v_NOMBRE_ETAPA ETAPA.DESCRIPCION%TYPE;
    v_POSICION participa.posicion%TYPE;
    

    CURSOR c_puntuaciones (num_ciclistas NUMBER) IS
        SELECT C.nombre, E.DESCRIPCION, p.posicion
        from participa p JOIN ciclista c on p.ciclista_id = c.id
        join etapa e on p.etapa_num = e.num
        where c.id = num_ciclistas
        order by p.POSICION;

    -- R_puntuaciones c_puntuaciones % rowtype;

BEGIN

    OPEN c_puntuaciones(v_id_ciclista);

    FETCH c_puntuaciones into v_nombre_ciclista, v_nombre_etapa, v_posicion;
    DBMS_OUTPUT.PUT_LINE('Participaciones con puntuacion del ciclista: ' || v_nombre_ciclista);
    DBMS_OUTPUT.PUT_LINE('******************************************************************');
    

    WHILE c_puntuaciones % found loop

        DBMS_OUTPUT.PUT_LINE('Etapa: ' || v_nombre_etapa || ' posicion: '  || v_posicion);

        FETCH c_puntuaciones into v_nombre_ciclista, v_nombre_etapa, v_posicion;
    end loop;

    close c_puntuaciones;

END;
/

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
declare 
    v_nums NUMBER;
begin 
    -- paso de parametros nominal
    consultar_ciclistas(v_equipo => 1, v_nacionalidad => 'España', v_num => v_nums);
    DBMS_OUTPUT.PUT_LINE('Cantidad de ciclistas entontrados ' || v_nums);
end;
/




-- FUNCION QUE RECIBA UNA EDAD Y DEVUELVA EL NUMERO DE CICLISTA DE TODOS LOS 
-- EQUIPOS CON EDAD INFERIOR
CREATE OR REPLACE FUNCTION f_CICLISTA_EDAD_INFERIOR(vedad NUMBER) return NUMBER is
    vNum NUMBER;
begin
    select count(*) into vNum
    from ciclista
    where edad < vedad;
    
    return vNUM;
end;


-- FUNCION QUE RECIBA UNA EDAD Y DEVUELVA EL NUMERO DE CICLISTA DE TODOS LOS 
-- EQUIPOS CON EDAD INFERIOR
begin
    DBMS_OUTPUT.PUT_LINE(f_CICLISTA_EDAD_INFERIOR(30));
end;
/
```