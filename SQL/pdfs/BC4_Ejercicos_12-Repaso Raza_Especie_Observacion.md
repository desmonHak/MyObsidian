```sql
--**************************************************
--
-- SCRIPT DE RAZA, ESPECIE, OBSERVACION
--
--**************************************************


-- Borrar tablas Raza, Especie, Observacion
DROP TABLE Raza CASCADE CONSTRAINTS;
DROP TABLE Especie CASCADE CONSTRAINTS;
DROP TABLE Observacion CASCADE CONSTRAINTS;

-- Borrar secuencias si existen
DROP SEQUENCE especie_seq;
DROP SEQUENCE raza_seq;
DROP SEQUENCE observacion_seq;

-- Crear secuencias para los IDs
CREATE SEQUENCE especie_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE raza_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE observacion_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Creación de tabla de ESPECIE 
CREATE TABLE especie (
    especie_id NUMBER DEFAULT especie_seq.NEXTVAL,
    nombre_cientifico VARCHAR2(100) NOT NULL UNIQUE,
    nombre_comun VARCHAR2(100),
    familia VARCHAR2(50) NOT NULL,
    habitat VARCHAR2(100),
    CONSTRAINT pk_especie PRIMARY KEY (especie_id)
);

-- Creación de tabla de RAZA 
CREATE TABLE raza (
    raza_id NUMBER DEFAULT raza_seq.NEXTVAL,
    especie_id NUMBER NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    region_origen VARCHAR2(100),
    es_domestica NUMBER(1) DEFAULT 0 CHECK (es_domestica IN (0, 1)),
    CONSTRAINT pk_raza PRIMARY KEY (raza_id),
    CONSTRAINT fk_raza_especie FOREIGN KEY (especie_id) REFERENCES especie(especie_id)
);

-- Creación de tabla de OBSERVACION 
CREATE TABLE observacion (
    observacion_id NUMBER DEFAULT observacion_seq.NEXTVAL,
    raza_id NUMBER NOT NULL,
    ubicacion VARCHAR2(200) NOT NULL,
    fecha_observacion DATE NOT NULL,
    cantidad NUMBER DEFAULT 1,
    CONSTRAINT pk_observacion PRIMARY KEY (observacion_id),
    CONSTRAINT fk_observacion_raza FOREIGN KEY (raza_id) REFERENCES raza(raza_id)
);


-- Insertar datos en la tabla ESPECIE
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Canis lupus', 'Lobo', 'Canidae', 'Bosques');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Felis catus', 'Gato', 'Felidae', 'Zonas urbanas');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Equus ferus caballus', 'Caballo', 'Equidae', 'Praderas');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Panthera leo', 'León', 'Felidae', 'Sabana');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Ursus arctos', 'Oso pardo', 'Ursidae', 'Bosques templados');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Ailuropoda melanoleuca', 'Panda gigante', 'Ursidae', 'Bosques de bambú');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Giraffa camelopardalis', 'Jirafa', 'Giraffidae', 'Sabana');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Delphinus delphis', 'Delfín común', 'Delphinidae', 'Océanos');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Elephas maximus', 'Elefante asiático', 'Elephantidae', 'Selvas tropicales');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Struthio camelus', 'Avestruz', 'Struthionidae', 'Desiertos y sabanas');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Orcinus orca', 'Orca', 'Delphinidae', 'Océanos');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Balaenoptera musculus', 'Ballena azul', 'Balaenopteridae', 'Océanos');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Carcharodon carcharias', 'Tiburón blanco', 'Lamnidae', 'Océanos');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Acinonyx jubatus', 'Guepardo', 'Felidae', 'Sabana');
INSERT INTO especie (nombre_cientifico, nombre_comun, familia, habitat) VALUES ('Loxodonta africana', 'Elefante africano', 'Elephantidae', 'Sabana');


-- Insertar datos en la tabla RAZA
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (1, 'Lobo ibérico', 'Península Ibérica', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'Siamés', 'Tailandia', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (3, 'Pura sangre inglés', 'Inglaterra', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (4, 'León africano', 'África', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (5, 'Oso pardo europeo', 'Europa', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (6, 'Panda de Sichuan', 'China', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (7, 'Jirafa masai', 'África oriental', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (8, 'Delfín mular', 'Atlántico', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (9, 'Elefante de Sri Lanka', 'Sri Lanka', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (10, 'Avestruz del Sahara', 'África del Norte', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (1, 'Lobo ártico', 'Ártico', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'Ragdoll', 'Estados Unidos', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (3, 'Frisón', 'Países Bajos', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'Sphynx', 'Canadá', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (3, 'Percherón', 'Francia', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'British Shorthair', 'Reino Unido', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'Persa', 'Irán', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (3, 'Mustang', 'América del Norte', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (4, 'León asiático', 'India', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (5, 'Oso kodiak', 'Alaska', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (6, 'Panda de Qinling', 'China', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (7, 'Jirafa reticulada', 'África del Este', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (8, 'Delfín del Indo-Pacífico', 'Océano Índico', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (9, 'Elefante de Borneo', 'Borneo', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (10, 'Avestruz somalí', 'África oriental', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (11, 'Orca del Pacífico', 'Océano Pacífico', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (12, 'Ballena azul antártica', 'Océano Antártico', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (13, 'Tiburón blanco australiano', 'Océano Austral', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (14, 'Guepardo sudafricano', 'Sudáfrica', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (15, 'Elefante africano de sabana', 'África subsahariana', 0);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'Maine Coon', 'Estados Unidos', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (3, 'Andaluz', 'España', 1);
INSERT INTO raza (especie_id, nombre, region_origen, es_domestica) VALUES (2, 'Bengalí', 'India', 1);


-- Insertar datos en la tabla OBSERVACION usando TO_DATE para formato explícito
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (1, 'Sierra de la Culebra', TO_DATE('15-10-2023', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (2, 'Madrid', TO_DATE('20-09-2023', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (3, 'Sevilla', TO_DATE('10-08-2023', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (4, 'Serengeti', TO_DATE('01-07-2023', 'DD-MM-YYYY'), 7);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (5, 'Pirineos', TO_DATE('12-06-2023', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (6, 'Montañas de Sichuan', TO_DATE('25-05-2023', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (7, 'Reserva Masai Mara', TO_DATE('30-04-2023', 'DD-MM-YYYY'), 8);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (8, 'Golfo de Cádiz', TO_DATE('15-03-2023', 'DD-MM-YYYY'), 12);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (9, 'Selva de Borneo', TO_DATE('10-02-2023', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (10, 'Desierto del Sahara', TO_DATE('05-01-2023', 'DD-MM-YYYY'), 6);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (11, 'Groenlandia', TO_DATE('20-12-2022', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (12, 'Teherán', TO_DATE('15-11-2022', 'DD-MM-YYYY'), 1);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (13, 'Montañas Rocosas', TO_DATE('10-10-2022', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (14, 'Parque Nacional Gir', TO_DATE('05-09-2022', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (15, 'Isla Kodiak', TO_DATE('01-08-2022', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (16, 'Montañas Qinling', TO_DATE('25-07-2022', 'DD-MM-YYYY'), 1);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (17, 'Reserva Samburu', TO_DATE('20-06-2022', 'DD-MM-YYYY'), 6);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (18, 'Océano Índico', TO_DATE('15-05-2022', 'DD-MM-YYYY'), 10);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (19, 'Selva de Borneo', TO_DATE('10-04-2022', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (20, 'África Oriental', TO_DATE('05-03-2022', 'DD-MM-YYYY'), 7);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (1, 'Montes Cantábricos', TO_DATE('01-02-2022', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (2, 'Barcelona', TO_DATE('25-01-2022', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (3, 'Córdoba', TO_DATE('20-12-2021', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (4, 'Kruger', TO_DATE('15-11-2021', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (2, 'Valencia', TO_DATE('12-09-2023', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (3, 'Londres', TO_DATE('05-08-2023', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (13, 'París', TO_DATE('20-07-2023', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (14, 'Nueva York', TO_DATE('15-06-2023', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (15, 'Tokio', TO_DATE('10-05-2023', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (16, 'Berlín', TO_DATE('25-04-2023', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (17, 'Roma', TO_DATE('30-03-2023', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (18, 'Sídney', TO_DATE('15-02-2023', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (19, 'Toronto', TO_DATE('10-01-2023', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (20, 'Melbourne', TO_DATE('05-12-2022', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (5, 'Alpes', TO_DATE('10-10-2021', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (6, 'Reserva Wolong', TO_DATE('05-09-2021', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (7, 'Serengeti', TO_DATE('01-08-2021', 'DD-MM-YYYY'), 9);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (8, 'Mar Mediterráneo', TO_DATE('25-07-2021', 'DD-MM-YYYY'), 11);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (9, 'Parque Nacional Gunung', TO_DATE('20-06-2021', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (10, 'Reserva de Namib', TO_DATE('15-05-2021', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (11, 'Islas Árticas', TO_DATE('10-04-2021', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (12, 'Teherán', TO_DATE('05-03-2021', 'DD-MM-YYYY'), 1);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (13, 'Montañas Rocosas', TO_DATE('01-02-2021', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (14, 'Parque Nacional Gir', TO_DATE('25-01-2021', 'DD-MM-YYYY'), 3);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (15, 'Isla Kodiak', TO_DATE('20-12-2020', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (16, 'Montañas Qinling', TO_DATE('15-11-2020', 'DD-MM-YYYY'), 1);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (17, 'Reserva Samburu', TO_DATE('10-10-2020', 'DD-MM-YYYY'), 6);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (18, 'Océano Índico', TO_DATE('05-09-2020', 'DD-MM-YYYY'), 10);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (19, 'Selva de Borneo', TO_DATE('01-08-2020', 'DD-MM-YYYY'), 4);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (20, 'África Oriental', TO_DATE('25-07-2020', 'DD-MM-YYYY'), 7);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (1, 'Sierra de la Culebra', TO_DATE('15-10-2023', 'DD-MM-YYYY'), 5);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (2, 'Madrid', TO_DATE('20-09-2023', 'DD-MM-YYYY'), 2);
INSERT INTO observacion (raza_id, ubicacion, fecha_observacion, cantidad) VALUES (3, 'Sevilla', TO_DATE('10-08-2023', 'DD-MM-YYYY'), 3);
COMMIT;

```