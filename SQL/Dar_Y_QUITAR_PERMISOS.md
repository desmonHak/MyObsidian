
dar permisor al usuario DAM8 el permiso para hacer selects
```sql
GRANT SELECT ON ARTISTA TO DAM8;
```

hacer una select a una tabla del usuario DAM4
![[Pasted image 20250305095915.png]]

```sql
revoke SELECT ON ARTISTA TO DAM4;
```

dar permisos a varios usuarios
```sql
GRANT SELECT ON REPRESENTANTE TO DAM4, DAM3, DAM6;
GRANT SELECT ON ARTISTA TO DAM4, DAM3, DAM6;
GRANT SELECT ON ACTUACION TO DAM4, DAM3, DAM6;
```

Los inserts de las tablas no aparecen hasta que haces un commit.