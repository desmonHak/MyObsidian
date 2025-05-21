Antes de cada `CREATE TABLE` se añade `DROP TABLE` para que si exista la tabla, se elimine en cascada:
```sql
DROP TABLE ciclista CASCADE CONSTRAINT;
```


```sql
-- Generado por Oracle SQL Developer Data Modeler 24.3.0.240.1210
--   en:        2024-11-13 09:50:15 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

DROP TABLE ciclista CASCADE CONSTRAINT;
CREATE TABLE ciclista (
    dorsal               NUMBER NOT NULL,
    vueltas              NUMBER NOT NULL,
    edad                 NUMBER,
    nacionalidad         VARCHAR2(15) NOT NULL,
    equipo_identificador NUMBER NOT NULL,
    puntos               NUMBER DEFAULT 0 NOT NULL
);

ALTER TABLE ciclista ADD CONSTRAINT ciclista_pk PRIMARY KEY ( dorsal );

DROP TABLE equipo CASCADE CONSTRAINT;
CREATE TABLE equipo (
    identificador NUMBER NOT NULL,
    nombre        VARCHAR2(15) NOT NULL
);

ALTER TABLE equipo ADD CONSTRAINT equipo_pk PRIMARY KEY ( identificador );

DROP TABLE etapas CASCADE CONSTRAINT;
CREATE TABLE etapas (
    tipo          NUMBER NOT NULL,
    fecha         DATE NOT NULL,
    identificador NUMBER NOT NULL,
    distancia     NUMBER NOT NULL,
    descripcion   VARCHAR2(20) NOT NULL
);

ALTER TABLE etapas ADD CONSTRAINT etapas_pk PRIMARY KEY ( identificador );

DROP TABLE participa CASCADE CONSTRAINT;
CREATE TABLE participa (
    ciclista_dorsal      NUMBER NOT NULL,
    etapas_identificador NUMBER NOT NULL,
    posicion             NUMBER
);

ALTER TABLE participa ADD CONSTRAINT participa_pk PRIMARY KEY ( ciclista_dorsal,
                                                                etapas_identificador );

ALTER TABLE ciclista
    ADD CONSTRAINT ciclista_equipo_fk FOREIGN KEY ( equipo_identificador )
        REFERENCES equipo ( identificador );

ALTER TABLE participa
    ADD CONSTRAINT participa_ciclista_fk FOREIGN KEY ( ciclista_dorsal )
        REFERENCES ciclista ( dorsal );

ALTER TABLE participa
    ADD CONSTRAINT participa_etapas_fk FOREIGN KEY ( etapas_identificador )
        REFERENCES etapas ( identificador );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             4
-- CREATE INDEX                             0
-- ALTER TABLE                              7
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

```