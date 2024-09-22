https://learn.microsoft.com/es-es/cpp/data/odbc/odbc-basics?view=msvc-170

[[ODBC]] es una interfaz de nivel de llamada que permite que las aplicaciones tengan acceso a los datos de cualquier base de datos en la que haya un controlador [[ODBC]]. La utilización de [[ODBC]] permite crear aplicaciones de base de datos con acceso a cualquier base de datos en la que el usuario final tenga un controlador [[ODBC]]. [[ODBC]] proporciona una API que permite que la aplicación sea independiente del sistema de administración de bases de datos ([[DBMS]]) de origen.

[[ODBC]] es la parte de base de datos de la Arquitectura de servicios abiertos de Microsoft Windows ([[WOSA]]), una interfaz que permite que las aplicaciones de escritorio basadas en Windows se conecten a varios entornos de computación sin tener que volver a crear la aplicación para cada plataforma.

## ¿Qué es el [[ODBC]]?
https://www.uv.es/jac/guia/gestion/gestion3.htm
### Open Data Base Conectivity
O lo que es lo mismo, **conectividad abierta de bases de datos**. Si escribimos una aplicación para acceder a las tablas de una ``DB`` de ``Access``, ¿qué ocurrirá si después queremos que la misma aplicación, y sin reescribir nada, utilice tablas de ``SQL Server`` u otra ``DB`` cualquiera? La respuesta es sencilla: no funcionará. Nuestra aplicación, diseñada para un motor concreto, no sabrá dialogar con el otro. Evidentemente, si todas las ``DB`` funcionaran igual, no tendríamos este problema.... aunque eso no es probable que ocurra nunca.

Pero si hubiera un elemento que por un lado sea siempre igual, y por el otro sea capaz de dialogar con una ``DB`` concreta, solo tendríamos que ir cambiando este elemento, y nuestra aplicación siempre funcionaría sin importar lo que hay al otro lado... algo así como ir cambiando las boquillas de una manguera. A esas piezas intercambiables las llamaremos **orígenes de datos** de [[ODBC]]

Casi todas las ``DB`` actuales tienen un [[ODBC]]. Debido a que este elemento impone ciertas limitaciones, ya que no todo lo que la ``DB`` sabe hacer es compatible con la aplicación, como velocidad de proceso, tiempos de espera, máxima longitud de registro, número máximo de registros, versión de ``SQL``, etc., está cayendo en desuso a cambio de otras técnicas de programación, pero aún le quedan muchos años de buen servicio.

Todo lo referido aquí funciona con ``Windows NT Server 4.0`` con el ``Service Pack 4`` o superior instalado (el último publicado es el 6). El ``Option Pack 4`` para actualizar el ``IIS`` y las extensiones ``ASP``. ``SQL Server 6.5`` y ``Access 97``. Por supuesto, también funciona con las versiones modernas de servidores como ``2003 Server``, y también ``XP PRO``, que lleva un ``IIS 5.0`` de serie. Igualmente es posible utilizar bases de datos de ``Access 2000`` o ``2003``.

Esas otras técnicas de programación antes mencionadas, se utilizan ya en el nuevo Windows 2003, Office 2003 y SQL Server 2000, que además de [[ODBC]] pueden utilizar.... pero esa es otra historia.

Esta es la idea: por un lado el [[ODBC]] provee de unas caracteríisticas siempre homogéneas, y por el otro permite distintos controladores que aseguran la conectividad de la aplicación con diferentes bases de datos.
![[Pasted image 20240912181720.png]]

# Open Database Connectivity ([[ODBC]])
https://es.wikipedia.org/wiki/Open_Database_Connectivity
``Open DataBase Connectivity`` ([[ODBC]]) es un estándar de acceso a bases de datos desarrollado por ``SQL Access Group`` ([[SAG]]) en 1992. El objetivo de [[ODBC]] es hacer posible el acceso a cualquier dato desde cualquier aplicación, independientemente del sistema de gestión de bases de datos ([[SGBD]]) que almacene los datos. [[ODBC]] lo consigue insertando una capa intermedia, denominada capa de interfaz de cliente SQL (``CLI``), entre la aplicación y el [[SGBD]]. El propósito de esta capa es traducir las consultas de datos de la aplicación en comandos que el [[SGBD]] entienda. Para que esto funcione, tanto la aplicación como el [[SGBD]] deben ser compatibles con [[ODBC]], es decir, la aplicación debe ser capaz de producir comandos [[ODBC]] y el [[SGBD]] debe ser capaz de responder a ellos. Desde la versión 2.0, el estándar es compatible con [[SAG]] (``SQL Access Group``) y ``SQL``.

El software funciona de dos modos, con un controlador de software en el cliente, o con una filosofía ``cliente-servidor``. En el primer modo, el controlador interpreta las conexiones y las llamadas ``SQL`` y las traduce de la ``API`` [[ODBC]] al [[SGBD]]. En el segundo modo, para conectarse a la base de datos, se crea un DSN dentro del [[ODBC]] que define los parámetros, la ruta y las características de la conexión en función de los datos solicitados por el creador o fabricante.

``Java Database Connectivity`` ([[JDBC]]) es un derivado inspirado en el mismo, una interfaz de programación de aplicaciones que permite la ejecución de operaciones sobre bases de datos desde el lenguaje de programación ``Java`` independientemente del sistema. 