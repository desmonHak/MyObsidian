
Aleatorios con decimales:
```sql
declare 
    vRand Number :=  DBMS_RANDOM.VALUE(low => 13, high => 100);
begin
    DBMS_OUTPUT.PUT_LINE('NUM RANDM: '|| VRand);
end; 
/
```

Sin decimales:
```sql
declare 
    vRand Number :=  ROUND(DBMS_RANDOM.VALUE(low => 13, high => 100));
begin
    DBMS_OUTPUT.PUT_LINE('NUM RANDM: '|| VRand);
end; 
/
```