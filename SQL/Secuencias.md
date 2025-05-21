[Pagina sobre secuencias](https://www.tutorialesprogramacionya.com/oracleya/temarios/descripcion.php?cod=193)

```sql
-- sec_codigolibros.nextval -> siguiente valor de la secuencia
-- sec_codigolibros.currval -> valor actual de la secuencia
create sequence secuencia_id_persona
    start with 1
    increment by 1
    maxvalue 9999999
    minvalue 1;
```