-- Generado por Oracle SQL Developer Data Modeler 24.3.0.240.1210
--   en:        2025-02-21 08:55:36 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE actuacion (
    id_actuacion       NUMBER NOT NULL,
    fecha              DATE,
    ciudad             VARCHAR2(100),
    artista_id_artista NUMBER NOT NULL
);

ALTER TABLE actuacion ADD CONSTRAINT actuacion_pk PRIMARY KEY ( id_actuacion );

CREATE TABLE artista (
    id_artista                     NUMBER NOT NULL,
    nombre_artista                 VARCHAR2(100),
    genero                         VARCHAR2(50),
    representante_id_representante NUMBER NOT NULL
);

ALTER TABLE artista ADD CONSTRAINT artista_pk PRIMARY KEY ( id_artista );

CREATE TABLE representante (
    id_representante     NUMBER NOT NULL,
    nombre_representante VARCHAR2(200),
    telefono             VARCHAR2(20)
);

ALTER TABLE representante ADD CONSTRAINT representante_pk PRIMARY KEY ( id_representante );

ALTER TABLE actuacion
    ADD CONSTRAINT actuacion_artista_fk FOREIGN KEY ( artista_id_artista )
        REFERENCES artista ( id_artista );

ALTER TABLE artista
    ADD CONSTRAINT artista_representante_fk FOREIGN KEY ( representante_id_representante )
        REFERENCES representante ( id_representante );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             3
-- CREATE INDEX                             0
-- ALTER TABLE                              5
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
