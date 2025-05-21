```sql
select substr(emaalu, 1,instr(emaalu, '@')-1) from alumno;

SELECT TRANSLATE (NOMALU, 'áéíóúÁÉÍÓÚ', 'aeiouAEIOU') AS NOMBRE_APELLIDOS  
FROM ALUMNO;
```