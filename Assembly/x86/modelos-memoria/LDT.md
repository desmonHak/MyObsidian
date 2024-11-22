https://wiki.osdev.org/Local_Descriptor_Table
Vea [[GDT]], [[Descriptor-de-segmento]]
# Local Descriptor Table ([[LDT]]) (tabla de descriptores locales)
Una `tabla de descriptores locales` ([[LDT]]) es como la `tabla de descriptores globales`([[GDT]]) en el sentido de que contiene `descriptores de segmentos` para acceder a la memoria. La diferencia es que cada tarea o `subproceso`/`Thread` puede tener su propia [[LDT]] y el sistema operativo puede cambiar el registro [[LDT]] ([[LDTR]]) en cada cambio de tarea.
Cada programa recibirá del sistema operativo una serie de segmentos de memoria diferentes para su uso. Las características de cada segmento de memoria local se almacenan en una estructura de datos denominada tabla de descriptores locales ([[LDT]]). La [[GDT]] contiene punteros a cada [[LDT]].

Eso significa que cada programa puede tener su propia lista de [[Descriptor-de-segmento|Descriptores de segmento]]
de memoria y __mantenerlos privados__ de otros programas:
Los segmentos de `código`, `datos` y `Heap`(montón) pueden ser **privados** en la [[LDT]] (_separados de otros programas, pero disponibles para este programa_); 
Cada tarea o `subproceso`/`Thread` dentro de este programa _puede tener su propia pila_ en la [[LDT]] y, _aun así, poder acceder a los segmentos anteriores_; 
El uso compartido dentro del programa es automático: solo hay que "__conocer__" la referencia de descriptor correcta; **Si otro programa (con otra [[LDT]]) intentara acceder a uno de estos segmentos, accedería al segmento de su propia [[LDT]] en lugar del segmento de destino**.

### La [[LDT]] se diferencia de la [[GDT]] en varios aspectos:
- No puede contener muchos tipos de descriptores;
- La [[GDT]] contiene una referencia a la [[LDT]] (la `base` y el `límite` de la tabla en la memoria);
- Solo es accesible para `tarea`/`subproceso`/`Thread` _con el mismo valor de registro de tabla de descriptores locales ([[LDTR]])_.

### Solo ciertos descriptores

Dado que la [[LDT]] es local para la `tarea`/`subproceso`/`Thread` actual, hay muchas cosas que la [[LDT]] no debería (y de hecho no puede) contener:

- Código para controladores de interrupciones;
- Datos para recursos de todo el sistema (por ejemplo, búfer de teclado);
- Segmentos del sistema (segmentos de estado de tarea([[TSS]]) y tablas de descriptores locales([[LDT]]) (_Solo la [[GDT]] puede tener tablas [[LDT]]_)).

Si lo piensa, esto tiene sentido: si se produce una interrupción o un cambio de tarea, no se puede esperar que la tarea actual contenga todas las referencias posibles para cada estructura del sistema; ¡para eso está la [[GDT]]!

### [[GDT]] contiene referencia
Si el sistema debe conocer la [[LDT]], entonces debe cumplir con el mismo ideal de seguridad que el resto del sistema. ¡_No querría que una tarea no autorizada defina una [[LDT]] que pueda acceder a la memoria sensible_! Por lo tanto, la [[LDT]] se define como un segmento de memoria "normal" dentro de la [[GDT]], simplemente con una dirección de memoria `base` y un `limit`. __Pero el hecho de que se identifique con un tipo de descriptor específico__ ([[LDT]]`=0x02`) _significa que el descriptor no se puede cargar en un registro de segmento estándar_([[CS]], [[DS]], [[ES]], [[FS]], [[GS]], [[SS]]): la única forma en que el registro de tabla de descriptores locales ([[LDTR]]) se puede cargar con este valor es a través de la instrucción [[LLDT]] o a través de un segmento de estado de tarea ([[TSS]]); así es: si utiliza el mecanismo de asignación de tareas de hardware del i386, el [[TSS]] contiene la [[LDT]] de la tarea y se carga automáticamente en un conmutador de tareas.

### Solo accesible dentro de la tarea actual
El objetivo de usar una [[LDT]] es localizar los segmentos de este programa solo para ciertas tareas. Cada programa definiría sus propios segmentos de código, datos y `Heap`, y un segmento de pila para cada tarea dentro del programa. Cualquier intento de acceder al segmento desde fuera del programa es inútil: solo accedería a la [[LDT]] de la tarea de referencia (consulte la Introducción anterior).

### ¿Cómo se definen y se accede a las [[LDT]]?
Una [[LDT]] es un `bloque de memoria (lineal)` de hasta `64K` de tamaño, al igual que la [[GDT]]. Se puede paginar a través del mecanismo estándar, por lo que se trata como una memoria normal en ese sentido. _La diferencia con la [[GDT]] está en los descriptores que puede almacenar y el método utilizado para acceder a ellos_.

En el [[Assembly/MODOS/modo-protegido]], se utiliza un [[registros-segmento-selectores-segmento|selector de segmento]] ([[CS]], [[DS]], [[ES]], [[FS]], [[GS]], [[SS]]) para indexar un descriptor de una tabla de descriptores. El selector de segmentos de `16 bits` está formado por tres campos:

| Index           | T   | PL   |
| --------------- | --- | ---- |
| 0b1111110000000 | 0b0 | 0b00 |
| 5432109876543   | 2   | 0b10 |
`Index`(`Índice`) = Índice dentro de la tabla de descriptores.
`T` = ¿Qué tabla?: `0 = `[[GDT]], `1 = `[[LDT]]
 = Nivel de privilegio solicitado ([[Descriptor-de-segmento#^1e145d|RPL]]) *
* El [[Descriptor-de-segmento#^1e145d|RPL]] se compara con el nivel de privilegio codificado dentro del descriptor (nivel de privilegio del descriptor - [[Descriptor-de-segmento#^1e145d|DPL]]), Vea [[ARPL]].
Si no hay coincidencias, la solicitud genera un error.

Entonces:
- `0x0000-0x0003` cargados en un Registro de Segmento funcionan, pero intentar usar ese Registro de Segmento causa una Falla de Protección General (`GPF`) - la entrada cero del [[GDT]] está reservada para permitir un `Selector NULL`;
- `0x0004-0x0007` hace referencia al Descriptor `0x000` en el [[LDT]] (actual) (con un [[RPL]] de 0-3);
- `0x0008` hace referencia al Descriptor `0x001` en el [[GDT]] (con un [[RPL]] de 0);
- `0x000C` hace referencia al Descriptor `0x001` en el [[LDT]] (actual) (con un [[RPL]] de 0);
- `0xF002` hace referencia al Descriptor `0x1E0` en el [[GDT]] (con un [[RPL]] de 2);
- `0xF006` hace referencia al descriptor `0x1E0` en la [[LDT]] (actual) (con un [[RPL]] de 2).