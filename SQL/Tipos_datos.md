https://www.ibm.com/docs/es/iis/11.5?topic=stage-sql-data-types
Al importar metadatos de la tabla de base de datos, el controlador [[ODBC]] correlaciona estos tipos de datos con tipos de datos ``SQL`` adecuados. Puede ver los tipos de datos utilizados en la definición de tabla del repositorio o cuando edite una etapa en el diseño del trabajo.

La etapa [[BCPLoad]] soporta los siguientes tipos de datos de ``SQL Server``:
- Bit
- Char ^5b5bd8
- DateTime
- Decimal
- Float
- Entero
- Money
- Numeric
- Real
- SmallDateTime
- SmallInt
- SmallMoney
- TinyInt
- VarChar

La etapa [[BCPLoad]] no soporta los siguientes tipos de datos de ``SQL Server``:
- Binario
- VarBinary
- Imagen
- Text (texto largo de tipo binario)

# Tipos según Microsoft:
https://learn.microsoft.com/es-es/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver16
### Valores numéricos exactos
- [tinyint](https://learn.microsoft.com/es-es/sql/t-sql/data-types/int-bigint-smallint-and-tinyint-transact-sql?view=sql-server-ver16)
- [smallint](https://learn.microsoft.com/es-es/sql/t-sql/data-types/int-bigint-smallint-and-tinyint-transact-sql?view=sql-server-ver16)
- [int](https://learn.microsoft.com/es-es/sql/t-sql/data-types/int-bigint-smallint-and-tinyint-transact-sql?view=sql-server-ver16)
- [bigint](https://learn.microsoft.com/es-es/sql/t-sql/data-types/int-bigint-smallint-and-tinyint-transact-sql?view=sql-server-ver16)
- [bit](https://learn.microsoft.com/es-es/sql/t-sql/data-types/bit-transact-sql?view=sql-server-ver16) 1
- [decimal](https://learn.microsoft.com/es-es/sql/t-sql/data-types/decimal-and-numeric-transact-sql?view=sql-server-ver16) 2
- [numeric](https://learn.microsoft.com/es-es/sql/t-sql/data-types/decimal-and-numeric-transact-sql?view=sql-server-ver16) 2
- [money](https://learn.microsoft.com/es-es/sql/t-sql/data-types/money-and-smallmoney-transact-sql?view=sql-server-ver16)
- [smallmoney](https://learn.microsoft.com/es-es/sql/t-sql/data-types/money-and-smallmoney-transact-sql?view=sql-server-ver16)
1 El **tipo de datos bit** se usa para almacenar valores booleanos.
2 Los **tipos de datos decimales** y **numéricos** son idénticos.
### Valores numéricos aproximados
- [float](https://learn.microsoft.com/es-es/sql/t-sql/data-types/float-and-real-transact-sql?view=sql-server-ver16)
- [real](https://learn.microsoft.com/es-es/sql/t-sql/data-types/float-and-real-transact-sql?view=sql-server-ver16)
### Fecha y hora
- [date](https://learn.microsoft.com/es-es/sql/t-sql/data-types/date-transact-sql?view=sql-server-ver16) ^911355
- [time](https://learn.microsoft.com/es-es/sql/t-sql/data-types/time-transact-sql?view=sql-server-ver16)
- [datetime2](https://learn.microsoft.com/es-es/sql/t-sql/data-types/datetime2-transact-sql?view=sql-server-ver16)
- [datetimeoffset](https://learn.microsoft.com/es-es/sql/t-sql/data-types/datetimeoffset-transact-sql?view=sql-server-ver16)
- [datetime](https://learn.microsoft.com/es-es/sql/t-sql/data-types/datetime-transact-sql?view=sql-server-ver16)
- [smalldatetime](https://learn.microsoft.com/es-es/sql/t-sql/data-types/smalldatetime-transact-sql?view=sql-server-ver16)
### Cadenas de caracteres
- [char](https://learn.microsoft.com/es-es/sql/t-sql/data-types/char-and-varchar-transact-sql?view=sql-server-ver16) ^000a8c
- [varchar](https://learn.microsoft.com/es-es/sql/t-sql/data-types/char-and-varchar-transact-sql?view=sql-server-ver16) ^b1d260
- [text](https://learn.microsoft.com/es-es/sql/t-sql/data-types/ntext-text-and-image-transact-sql?view=sql-server-ver16)
### Cadenas de caracteres Unicode
- [nchar](https://learn.microsoft.com/es-es/sql/t-sql/data-types/nchar-and-nvarchar-transact-sql?view=sql-server-ver16)
- [nvarchar](https://learn.microsoft.com/es-es/sql/t-sql/data-types/nchar-and-nvarchar-transact-sql?view=sql-server-ver16)
- [ntext](https://learn.microsoft.com/es-es/sql/t-sql/data-types/ntext-text-and-image-transact-sql?view=sql-server-ver16)

### Cadenas binarias
- [binary](https://learn.microsoft.com/es-es/sql/t-sql/data-types/binary-and-varbinary-transact-sql?view=sql-server-ver16)
- [varbinary](https://learn.microsoft.com/es-es/sql/t-sql/data-types/binary-and-varbinary-transact-sql?view=sql-server-ver16)
- [image](https://learn.microsoft.com/es-es/sql/t-sql/data-types/ntext-text-and-image-transact-sql?view=sql-server-ver16)

### Otros tipos de datos
- [cursor](https://learn.microsoft.com/es-es/sql/t-sql/data-types/cursor-transact-sql?view=sql-server-ver16)
- [geography](https://learn.microsoft.com/es-es/sql/t-sql/spatial-geography/spatial-types-geography?view=sql-server-ver16) 1
- [geometry](https://learn.microsoft.com/es-es/sql/t-sql/spatial-geometry/spatial-types-geometry-transact-sql?view=sql-server-ver16) 1
- [hierarchyid](https://learn.microsoft.com/es-es/sql/t-sql/data-types/hierarchyid-data-type-method-reference?view=sql-server-ver16)
- [json](https://learn.microsoft.com/es-es/sql/t-sql/data-types/json-data-type?view=sql-server-ver16)
- [rowversion](https://learn.microsoft.com/es-es/sql/t-sql/data-types/rowversion-transact-sql?view=sql-server-ver16)
- [sql_variant](https://learn.microsoft.com/es-es/sql/t-sql/data-types/sql-variant-transact-sql?view=sql-server-ver16)
- [table](https://learn.microsoft.com/es-es/sql/t-sql/data-types/table-transact-sql?view=sql-server-ver16)
- [uniqueidentifier](https://learn.microsoft.com/es-es/sql/t-sql/data-types/uniqueidentifier-transact-sql?view=sql-server-ver16)
- [xml](https://learn.microsoft.com/es-es/sql/t-sql/xml/xml-transact-sql?view=sql-server-ver16)
1 Los **tipos de datos geography** y **geometry** son _tipos_ espaciales.