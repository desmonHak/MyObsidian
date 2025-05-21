[PayloadsAllTheThings/SQL Injection/OracleSQL Injection.md at master · swisskyrepo/PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/SQL%20Injection/OracleSQL%20Injection.md)

```sql
-- Hostname	
SELECT UTL_INADDR.get_host_name FROM dual;
-- Hostname	
SELECT UTL_INADDR.get_host_name('10.0.0.1') FROM dual;
-- Hostname	
SELECT UTL_INADDR.get_host_address FROM dual;
-- Hostname	
SELECT host_name FROM v$instance;
-- Database name	
SELECT global_name FROM global_name;
-- Database name	
SELECT name FROM V$DATABASE;
-- Database name	
SELECT instance_name FROM V$INSTANCE;
-- Database name	
SELECT SYS.DATABASE_NAME FROM DUAL;
-- Database name	
SELECT sys_context('USERENV', 'CURRENT_SCHEMA') FROM dual;

-- get users from db
SELECT username FROM all_users;
```