Compilar sin optimizaciones:

```bash
gcc -O0 hash_table.c -o  hash_table.exe -pg
```

Luego ejecutamos el ejecutable y generara un archivo `gmon.out`, este archivo se deberá analizar con `grpof`:
```bash
gprof hash_table.exe gmon.out
```

salida:
```c
Flat profile:

Each sample counts as 0.01 seconds.
 no time accumulated

  %   cumulative   self              self     total           
 time   seconds   seconds    calls  Ts/call  Ts/call  name    
  0.00      0.00     0.00        6     0.00     0.00  hash
  0.00      0.00     0.00        3     0.00     0.00  insert_in_file
  0.00      0.00     0.00        3     0.00     0.00  lookup_in_memory
  0.00      0.00     0.00        1     0.00     0.00  create_hash_table
  0.00      0.00     0.00        1     0.00     0.00  free_hash_table
  0.00      0.00     0.00        1     0.00     0.00  load_hash_table


granularity: each sample hit covers 4 byte(s) no time propagated

index % time    self  children    called     name
                0.00    0.00       3/6           insert_in_file [2]
                0.00    0.00       3/6           lookup_in_memory [3]
[1]      0.0    0.00    0.00       6         hash [1]
-----------------------------------------------
                0.00    0.00       3/3           main [12]
[2]      0.0    0.00    0.00       3         insert_in_file [2]
                0.00    0.00       3/6           hash [1]
-----------------------------------------------
                0.00    0.00       3/3           main [12]
[3]      0.0    0.00    0.00       3         lookup_in_memory [3]
                0.00    0.00       3/6           hash [1]
-----------------------------------------------
                0.00    0.00       1/1           main [12]
[4]      0.0    0.00    0.00       1         create_hash_table [4]
-----------------------------------------------
                0.00    0.00       1/1           main [12]
[5]      0.0    0.00    0.00       1         free_hash_table [5]
-----------------------------------------------
                0.00    0.00       1/1           main [12]
[6]      0.0    0.00    0.00       1         load_hash_table [6]
-----------------------------------------------
```
- **`% time`**: Todas las funciones muestran **0% de tiempo**, lo cual significa que ninguna consumió tiempo medible.
- **`calls`**: Indica cuántas veces se llamó cada función:
    - La función `hash` fue llamada **6 veces**.
    - `insert_in_file` y `lookup_in_memory` se llamaron **3 veces** cada una.
    - El resto de funciones se llamaron **1 vez**.
- **`self seconds` y `total seconds`**: Ambas columnas son **0.00**, lo que confirma que las funciones se ejecutaron demasiado rápido.

- La función `hash` (**[1]**) fue llamada **6 veces** en total:
    - **3 veces** por `insert_in_file` (**[2]**).
    - **3 veces** por `lookup_in_memory` (**[3]**).
- Las funciones `insert_in_file` y `lookup_in_memory` fueron llamadas por `main`.