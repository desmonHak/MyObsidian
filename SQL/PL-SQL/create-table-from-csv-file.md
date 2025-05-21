[Using CSV data as external table in Oracle DB – Schneide Blog](https://schneide.blog/2020/06/16/using-csv-data-as-external-table-in-oracle-db/ "https://schneide.blog/2020/06/16/using-csv-data-as-external-table-in-oracle-db/")

```sql
LOAD DATA
	INFILE example.csv
	INTO TABLE example_table
	FIELDS TERMINATED BY ';'
	(ID, NAME, AMOUNT, DESCRIPTION)
```

Para este caso posiblemente debe usarse:
```sql
CREATE OR REPLACE DIRECTORY dir_read as 'C:\app\desmon0xff\product\21c\data';
GRANT ALL ON DIRECTORY dir_read TO PUBLIC;
```
antes de:
```sql
CREATE TABLE example_table (  
	id NUMBER(4,0),  
	name VARCHAR2(50),  
	amount NUMBER(8,0)  
) ORGANIZATION EXTERNAL (  
	DEFAULT DIRECTORY external_tables_dir  
		ACCESS PARAMETERS (  
		    RECORDS DELIMITED BY NEWLINE  
		    FIELDS TERMINATED BY ';'  
	) LOCATION ('example.csv')   
);
```

```sql
CREATE OR REPLACE DIRECTORY dir_read as 'C:\app\desmon0xff\product\21c\data';
GRANT ALL ON DIRECTORY dir_read TO PUBLIC;

SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM DBA_DIRECTORIES;

DROP TABLE PRUEBA_EXT CASCADE CONSTRAINTS;

CREATE TABLE PRUEBA_EXT (
    NOMBRE varchar2(20),
    edad number
) ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY DIR_READ
	ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        LOGFILE 'PRUEBA_EXT.log'
        BADFILE 'PRUEBA_EXT.bad'
        DISCARDFILE 'PRUEBA_EXT.dsc'
        FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"' LRTRIM(
            nombre CHAR,
            edad CHAR
        )
    ) LOCATION (DIR_READ:'Libro1.csv')

)
    REJECT LIMIT 100
    --NOPARALLEL
    --NOMONITORING;
```