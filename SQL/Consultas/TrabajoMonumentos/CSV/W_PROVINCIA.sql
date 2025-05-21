--------------------------------------------------------
-- Archivo creado  - jueves-febrero-06-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table W_PROVINCIA
--------------------------------------------------------

  CREATE TABLE "DAVID"."W_PROVINCIA" 
   (	"POBLACION_PROVINCIA" VARCHAR2(32 BYTE), 
	"CODPRO" NUMBER(38,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into DAVID.W_PROVINCIA
SET DEFINE OFF;
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Ávila','5');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Burgos','9');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('León','24');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Palencia','34');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Salamanca','37');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Segovia','40');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Soria','42');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Valladolid','47');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Zamora','49');
Insert into DAVID.W_PROVINCIA (POBLACION_PROVINCIA,CODPRO) values ('Sin Poblacion','0');
