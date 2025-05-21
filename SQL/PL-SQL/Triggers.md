Los trigger o disparadores son bloques de códigos que se "disparan" automáticamente ósea se ejecutan automáticamente cuando ocurre un evento especifico, como un INSERT, UPDATE O DELETE sobre una tabla, un DDL (CREATE o ALTER) o un evento del sistema (STARTUP o LOGON).

A diferencia de procedimientos almacenados los trigger no se invocan explícitamente por lo cual no hace falta llamarlos en ningún lado, simplemente permanecen habilitados o deshabilitado y el motor de Oracle los ejecuta cuando se da la condición configurada

### Tipos de [[Triggers]]:

#### Según momento de ejecución:

- **BEFORE** : Se ejecutan antes de que la operación modifique la tabla, útiles para validar o modificar datos de entrada.
- **AFTER** : Se ejecutan tras la operación, idóneos para auditoria o acciones dependientes de cambios confirmados
- **INSTEAD OF** : Solo para vistas, remplazan la operación DML y permiten actualizar vistas complejas

#### Según el nivel:

- **STATEMENT-LEVEL** : Un único disparo por sentencia, independientemente de cuantas filas afecte
- **ROW-LEVEL (FOR EACH ROW)** : Se dispara una vez por cada fila modificada; se permite usar `:NEW` y `:OLD` para acceder a valores fila a fila 

#### [[Triggers]] del sistema:

- Se disparan ante eventos globales como ``logon``, ``logoff``, ``startup`` o ``shutdown`` de la base de datos

#### Pseudoregistros :NEW y :OLD:

- En los triggers de fila, Oracle proporciona dos Pseudoregistros
	- **:OLD** Valores antes de la operación (Solo ``UPDATE`` y ``DELETE``)
	- **:NEW** Valores después de la operación (solo ``INSERT`` y ``UPDATE``) Sirven para validaciones, auditorias o para derivar otros valores

### Sintaxis básica de un [[Triggers]]:

```sql
CREATE [OR REPLACE] TRIGGER nombre_trigger
-- Creacion del trigger
  {BEFORE | AFTER | INSTEAD OF}
-- Cuando se ejecutara
  {INSERT [OR] | UPDATE [OF columna_list] [OR] | DELETE}
-- Como se ejecutara (Al actualizar, insertar o eliminar)
  ON objeto (tabla o vista)
-- En que campo (Objeto) de que tabla o vista
  [REFERENCING OLD AS o NEW AS n]
-- Uso de pseudoelementos
  [FOR EACH ROW]
-- Uso de auto ejecucion en cada fila modificada
  [WHEN (condición_plsql)]
-- Condicion que tendra el trigger
DECLARE
  -- sección de declaraciones opcional
BEGIN
  -- acciones del trigger
EXCEPTION
  -- manejador de excepciones opcional
END;
```

### Ejemplos prácticos:

```sql
CREATE OR REPLACE TRIGGER trg_audit_employees
-- Creacion del trigger
AFTER INSERT OR UPDATE OR DELETE ON employees
-- Despues de insertar o actualizar o eliminar valores en empleados
FOR EACH ROW
-- Se ejecutara en cada fila modificada
BEGIN
  -- Lo que ejecutara el trigger
  INSERT INTO audit_employees(emp_id, action, action_date)
  VALUES(NVL(:OLD.employee_id, :NEW.employee_id),
         CASE
           WHEN INSERTING THEN 'INSERT'
           WHEN UPDATING THEN 'UPDATE'
           WHEN DELETING THEN 'DELETE'
         END,
         SYSDATE);
END;
```

```sql
CREATE OR REPLACE TRIGGER trg_check_salary
-- Creacion del trigger
BEFORE INSERT OR UPDATE OF salary ON employees
-- Antes de insertar o actualizar salarios en empleados
FOR EACH ROW
-- Actualize en cada fila
WHEN (NEW.salary < 0 OR NEW.salary > 100000)
-- Condicion
BEGIN
  -- Codigo que ejecutara el trigger
  RAISE_APPLICATION_ERROR(-20001, 'Salario fuera de rango permitido');
END;
```



```sql
-- Ejercicio 3: Restriccion por duracion maxima.
-- Crea un trigger que impida insertar una reserva si el cliente tiene menos 
-- de 18 años en la fecha de entrada.
CREATE OR REPLACE TRIGGER trq_duracion_maxima
BEFORE INSERT OR UPDATE ON RESERVA
FOR EACH ROW
BEGIN
    -- si la fecha nueva de salida - fecha nueva de entrada (dias de reserva)
    -- son mayor a 30, generar una excepcion.
    IF :NEW.f_salida - :NEW.f_entrada > 30 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La duracion de la reserva no puede \
        superar los 30 dias');
    END IF;
END;
/

-- Ejercicio 4: Control de edad minima
-- Crea un trigger que impida insertar una reserva si el cliente tiene menos 
-- de 18 años en la fecha de entrada.
CREATE OR REPLACE TRIGGER trq_edad_minimo
BEFORE INSERT ON RESERVA
FOR EACH ROW
DECLARE
    v_fecha_nac DATE;
BEGIN
    SELECT fecha_nac INTO v_fecha_nac
    from cliente
    where dni = :NEW.dni:
    -- 216 = 18 años * 12 meses
    IF MONTHS_BETWEEN(:NEW.f_entrada, v_fecha_nac) < 216 then
        RAISE_APPLICATION_ERROR(-20003, 'El cliente debe ser nayor de 18 \
        años en la fecha de entrada.')
    END IF;
END:
/
```

Como ambos [[Triggers]] trabajan sobre la misma tabla, puede ocurrir que ambos [[Triggers]] salten a la vez, en ese caso, nada asegura el orden de ejecución de los dos [[Triggers]] anterior. Para asegurar la buena ejecución, es ideal crear un único [[Triggers]] con toda la lógica para la tabla reserva en lugar de hacer varios [[Triggers]].