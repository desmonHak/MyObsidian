https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-kuser_shared_data#requirements

https://www.geoffchappell.com/studies/windows/km/ntoskrnl/inc/api/ntexapi_x/kuser_shared_data/index.htm

en el modo usr esta en ``0x7FFE0000`` y en modo kernel, en ``0xFFFFF78000000300``

La dirección preestablecida para el acceso desde el modo kernel se define simbólicamente en WDM.H como ``KI_USER_SHARED_DATA``. Es útil durante la depuración recordar que es ``0xFFDF0000`` o ``0xFFFFF78000000000``, respectivamente, en Windows de 32 y 64 bits. También se define un símbolo conveniente, ``SharedUserData``, que convierte esta dirección constante en un puntero con el tipo adecuado:
```c
#define SharedUserData ((KUSER_SHARED_DATA * const) KI_USER_SHARED_DATA)
```

## Modo de usuario
La dirección de modo de usuario de solo lectura para los datos compartidos es ``0x7FFE0000``, tanto en Windows de 32 bits como de 64 bits. La única definición formal entre los encabezados del Kit de controladores de Windows (WDK) o el Kit de desarrollo de software (SDK) se encuentra en los encabezados de lenguaje ensamblador: ``KS386.INC`` del WDK y ``KSAMD64.INC`` del SDK definen ``MM_SHARED_USER_DATA_VA`` para la dirección de modo de usuario. El hecho de que también definan ``USER_SHARED_DATA`` para la dirección de modo kernel sugiere que también están destinados a la programación en modo kernel, aunque de un tipo que al menos tenga en cuenta qué dirección funciona para el acceso en modo usuario.

El soporte formal que es inequívoco para el acceso en modo usuario se publica solo para los procesadores ARM. Para bien o para mal, estos procesadores se ignoran normalmente para este estudio de Windows. Un encabezado en lenguaje C llamado ``NTARM.H`` que Microsoft publicó en algunas ediciones del WDK para Windows 10 define tanto ``MM_SHARED_USER_DATA_VA`` como ``USER_SHARED_DATA`` para la dirección de modo de usuario. Este último, al igual que SharedUserData, es conveniente para ser tipificado apropiadamente. Ninguna de las definiciones en este encabezado específico de ARM es de ayuda inmediata para la programación ``x86`` y ``x64``. Los encabezados que corresponden a ``NTARM.H`` pero para programación ``x86`` y ``x64`` parecen no haber sido publicados nunca por Microsoft. Sin embargo, ciertamente existen: los archivos de símbolos privados para componentes de modo de usuario como ``URLMON.DLL`` se han suministrado en paquetes de símbolos públicos desde hace mucho tiempo, como Windows 8, y confirman la existencia de encabezados llamados ``NTI386.H`` y ``NTAMD64.H``. Dado que son los correspondientes ``x86`` y x64 del ``NTARM.H`` publicado, es una inferencia sólida que estos también definen ``MM_SHARED_USER_DATA_VA`` y ``USER_SHARED_DATA`` para la dirección de modo de usuario.

La exposición mucho menor de la dirección de modo de usuario se debe presumiblemente a que el uso previsto es por parte de módulos de bajo nivel de Microsoft para admitir funciones API. Todo software de modo de usuario de nivel superior, si está bien escrito, llamaría a estas funciones API, ciertamente si están documentadas, en lugar de inspeccionar directamente ``KUSER_SHARED_DATA``.

## Estado de la documentación
La estructura ``KUSER_SHARED_DATA`` está documentada, pero solo como un desarrollo muy reciente. La propia fecha de Microsoft es el 19 de agosto de 2019 y no veo motivos para no creerla. Decir que está documentada es, de todos modos, una exageración. Lo que se había proporcionado cuando consulté el 20 de octubre de 2020 no era más que un esqueleto: una definición en lenguaje C y una lista de miembros sin explicación. Al volver a consultar dos años después, el 14 de octubre de 2022, veo que Microsoft ha ampliado la documentación transfiriendo comentarios de la definición en lenguaje C publicada: es mejor que nada.

Desde el lanzamiento del ``Device Driver Kit`` (``DDK``) para Windows 2000, se ha podido encontrar una definición en lenguaje C de ``KUSER_SHARED_DATA`` en ``NTDDK.H``. Incluso durante las décadas en las que la estructura no estaba documentada, era bien conocida por los programadores en modo kernel y posiblemente era la más conocida de todas las estructuras de Windows no documentadas, tanto que fácilmente podría no haber recibido la atención de un sitio web que intenta documentar lo no documentado. El hecho de que se tabule aquí se debe a que el programador que depura código de Windows de bajo nivel (o, no muy diferente, el ingeniero inverso que estudia Windows) probablemente encuentre referencias a los miembros de esta estructura, generalmente con direcciones codificadas, y puede enfrentar dos problemas.

Uno es que, por más que circule una definición en lenguaje C, posiblemente no sea documentación, incluso si está respaldada por comentarios exhaustivos, lo que no ocurre con la definición de ``KUSER_SHARED_DATA``. La documentación que Microsoft ha publicado desde entonces no es más que un marcador de posición (o, más recientemente, poco más), el tipo de cosa que se presenta sin más efecto que tener algo que señalar como nueva apertura por parte de un nuevo Microsoft. La alternativa que puedo ofrecer debe ser, durante años, si no para siempre, imperfecta para la mayor parte de la estructura. Aun así, no puede dejar de ayudar.

La razón más importante y quizás más duradera es que los cambios de la estructura entre (e incluso dentro de) las versiones de Windows no se rastrean en los encabezados de Microsoft. Es cierto que los cambios parecen ser casi intrascendentes para el código de modo de usuario de nivel superior (de hecho, para cualquier código muy por encima de ``NTDLL``). Sin embargo, casi intrascendente no es ignorablemente intrascendente. La diferencia a veces importa, e incluso ha afectado a la seguridad. Existen casos en los que se han deslizado cosas en ``KUSER_SHARED_DATA`` pero sería mejor que no se hubieran expuesto tan fácilmente al software de modo de usuario y, en particular, al malware.

Por ejemplo, en muchas versiones de Windows de 32 bits anteriores a Windows 8, la participación de esta estructura en las llamadas del modo usuario al modo kernel tenía como efecto secundario que todas esas llamadas pasaban por una o dos ubicaciones muy predecibles, lo que ayudaba en gran medida al software (que lamentablemente no se limita solo al malware) que busca interceptar esas llamadas de otros o hacer sus propias llamadas con una probabilidad reducida de detección. Al principio, el miembro ``SystemCall`` de esta estructura contenía el código para llamar. Más tarde, todas las llamadas al modo kernel pasan por las funciones ``NTDLL`` exportadas ``KiFastSystemCall`` y ``KiIntSystemCall`` después de pasar por ``SystemCall`` como puntero.

Otro ejemplo que se eliminó para Windows 8 es que la protección de ``Address Space Layout Randomization`` (``ASLR``), en lo que respecta a predecir las direcciones de tiempo de ejecución de sitios conocidos en NTDLL, se redujo mediante los miembros ``SystemDllNativeRelocation`` y ``SystemDllWowRelocation`` de esta estructura.

Ejemplos como estos son errores bastante graves, especialmente si se tiene en cuenta el contexto en el que ambos surgieron como detalles de implementación de funciones que se anunciaron en su momento como mejoras en la seguridad. Por mucho que la supervisión e incluso los errores evidentes sean inevitables en el software de sistemas, es mejor guardar algunos registros para la historia. O eso es lo que he argumentado a lo largo de mi carrera, y por eso la documentación de ``KUSER_SHARED_DATA`` parece convincente.

## Diseño
Entre las estructuras relativamente grandes, ``KUSER_SHARED_DATA`` es muy poco común porque tiene exactamente el mismo diseño en Windows de 32 y 64 bits. Esto se debe a que la instancia debe ser accesible simultáneamente tanto para el código de 32 bits como para el de 64 bits en Windows de 64 bits, y se desea que el código de modo de usuario de 32 bits pueda ejecutarse sin cambios en Windows de 32 y 64 bits.

Grandes porciones de la estructura no cambian o apenas cambian entre versiones de Windows. Los cambios en ``KUSER_SHARED_DATA`` se deben principalmente al crecimiento al final. Sin embargo, ha habido cambios dentro de la estructura, incluido el traslado de miembros de un desplazamiento a otro entre compilaciones, sin importar que un comentario en ``NTDDK.H`` diga "El diseño en sí no puede cambiar ya que esta estructura se ha exportado en ``ntddk``, ``ntifs.h`` y ``nthal.h`` durante algún tiempo". La realidad es que la estructura ha cambiado lo suficiente como para que su presentación en una variedad de versiones no sea sencilla.

Se conocen los siguientes tamaños (con las salvedades que aparecen a continuación de la tabla):

|Version|Size|
|---|---|
|3.50|0x2C|
|3.51|0x0238|
|early 4.0 (before SP3)|0x02B4|
|mid 4.0 (SP3)|0x02BC|
|late 4.0 (SP4 and higher)|0x02D4|
|5.0|0x02D8|
|early 5.1 (before SP2)|0x0320|
|late 5.1 (SP2 and higher)|0x0338|
|early 5.2 (before SP1)|0x0330|
|late 5.2 (SP1 and higher)|0x0378|
|6.0|0x03B8|
|6.1 to 6.3|0x05F0|
|10.0 to 1903|0x0708|
|2004|0x0720|
Estos tamaños, y los desplazamientos, tipos y nombres de las tablas que siguen, proceden de los encabezados publicados para Windows 2000 y versiones posteriores, respaldados por la información de tipos de los archivos de símbolos públicos de Microsoft para el núcleo o para ``NTDLL`` para Windows 2000 SP3 y versiones posteriores. Una forma temprana de esta información de tipos se abrió camino de alguna manera hacia dos bibliotecas enlazadas estáticamente que Microsoft publicó con los DDK para Windows NT 3.51 y Windows NT 4.0. De lo contrario, lo que se conoce de los nombres y tipos de Microsoft para las versiones anteriores se infiere del uso que se ve que hacen ``NTOSKRNL``, ``NTDLL``, ``KERNEL32`` y otros binarios de los datos compartidos en sus direcciones conocidas. Para la versión 3.50, anterior a la disponibilidad de información de tipos, ni siquiera el tamaño de la estructura se conoce con certeza ya que el cargador asigna (y pone en cero) la memoria para ``KUSER_SHARED_DATA`` como una página completa, es decir, sin ningún registro en el código que muestre qué parte de la página está destinada a la estructura.


## Original (Windows NT 3.50)
Algunas variaciones son tan simples como un cambio de tipo o nombre, como lo demuestra el cambio del primer miembro de la estructura de ``TickCountLow`` a ``TickCountLowDeprecated``.

La función de API Win32 de apariencia normal llamada ``GetTickCount`` solía implementarse de manera tan simple como una multiplicación de 64 bits del volátil ``TickCountLow`` de 32 bits (que es una copia de los 32 bits más bajos del conteo de ticks de 64 bits del núcleo) por la constante ``TickCountMultiplier`` y luego un desplazamiento a la derecha de 24 bits como una forma rápida de convertir de los conteos de ticks del modo núcleo en cualquier unidad de medida que use el núcleo a los conteos de ticks del modo usuario en milisegundos.

El hecho de que el conteo de ticks del modo usuario se pueda leer ejecutando un puñado de instrucciones en modo usuario sin el gasto de transiciones hacia y desde el modo núcleo es quizás la motivación original del área de datos compartidos. Sin embargo, usar sólo los 32 bits más bajos del conteo de ticks del núcleo significa que el conteo de ticks del modo usuario en milisegundos se reinicia a cero no sólo cuando el resultado de 32 bits de la conversión se reinicia cada 49 días aproximadamente, sino también cuando la entrada a la conversión, es decir, los 32 bits más bajos del conteo del núcleo, se reinicia. Este segundo reinicio es un problema adicional, incluso si su ocurrencia en el mundo real se hace mucho menos probable al tener que dejar Windows funcionando durante aproximadamente 2 años.

El primer reinicio es notorio, pero el otro casi nunca se ha mencionado, aunque no puede haber sido desconocido. Para solucionarlo, lo que llamó la atención de Microsoft después de casi una década, ``KUSER_SHARED_DATA`` necesitaba los 64 bits completos del conteo del núcleo. Ampliar el ``TickCountLow`` de 32 bits a 64 bits habría cambiado de manera incompatible todo lo que sigue. En cambio, se definió un nuevo ``TickCount`` de 64 bits en lo que entonces era el final de la estructura (consulte el desplazamiento ``0x0320``) y el antiguo ``TickCountLow`` de 32 bits pasó a ser un espacio sin uso. Por lo tanto, ``TickCountLow`` pasó a ser ``TickCountLowDeprecated``:

| Offset                        | Definition                           | Versions        | Remarks             |
| ----------------------------- | ------------------------------------ | --------------- | ------------------- |
| 0x00                          | ULONG volatile TickCountLow;         | 3.50 to 5.1     |                     |
| ULONG TickCountLowDeprecated; | 5.2 and higher                       | truly not used  |                     |
| 0x04                          | ULONG TickCountMultiplier;           | 3.50 and higher |                     |
| 0x08                          | KSYSTEM_TIME volatile InterruptTime; | 3.50 and higher |                     |
| 0x14                          | KSYSTEM_TIME volatile SystemTime;    | 3.50 and higher |                     |
| 0x20                          | KSYSTEM_TIME volatile TimeZoneBias;  | 3.50 and higher | last member in 3.50 |

No es casualidad que todos los miembros originales de ``KUSER_SHARED_DATA`` tengan algo que ver con el tiempo. Obtener el tiempo de manera eficiente desde el modo de usuario parece haberle costado a Microsoft bastante en los primeros años de Windows. Al mismo tiempo que se introdujo ``KUSER_SHARED_DATA`` para el acceso directo al recuento de ``ticks`` del modo kernel, copiado en ``TickCountLow``, la versión 3.50 también dedicó una interrupción, la número ``0x2A``, para obtener el recuento de ticks del modo usuario de manera más eficiente que ``NtGetTickCount`` (todavía llamando al kernel pero con mucha menos sobrecarga que pasar por la interrupción 0x2E (que maneja la generalidad de las llamadas del sistema, de las cuales ``NtGetTickCount`` es solo una). Curiosamente, aunque algunos de los otros números de interrupción dedicados de las primeras versiones se han reutilizado, la interrupción ``0x2A`` sobrevive en el kernel x86 incluso hasta Windows 10, pero nunca he sabido de ningún llamador en modo usuario en ninguna versión.


## TickCount
Tanto si ``KUSER_SHARED_DATA`` tiene el ``TickCount`` de 64 bits como si solo tiene el ``TickCountLow`` de 32 bits, el tick que se cuenta no es en realidad una interrupción de ningún dispositivo temporizador. Es, en cambio, una abstracción de una interrupción del temporizador. Aunque solo sea para mí, los programadores en general parecen no haber comprendido nunca esta distinción, que tal vez ya merezca unas pocas palabras de explicación.

Para estar al tanto del paso del tiempo sin tener que seguir preguntando la hora, el núcleo (a través de la HAL) programa un dispositivo temporizador para que interrumpa periódicamente. El período debe ser lo suficientemente pequeño como para cumplir con las expectativas de precisión, tanto del núcleo como del software en general, pero no tan pequeño como para que la capacidad de respuesta general se degrade por la sobrecarga de las interrupciones frecuentes. Se permite que el período varíe, incluso por orden del software de modo usuario que desea que sus tiempos en milisegundos se tomen como exactos. Los períodos mínimos y máximos que son posibles para el reloj elegido se aprenden de la HAL en la inicialización y luego son constantes para el resto de la ejecución del núcleo. No importa cómo varíe el núcleo el período, no importa cuál sea la frecuencia de las interrupciones reales, el núcleo mantiene el ``TickCount`` como si las interrupciones se repitieran con el período máximo.

Desde Windows 8.1, el núcleo limita el período máximo a no ser mayor que un sesenta y cuatroavo de segundo, es decir, ``15,625 ms``, que se ha convertido en la duración típica de un tic del temporizador en la experiencia ordinaria, tanto que algunos programadores (o comentaristas no programadores) piensan que debe ser así.

## TickCountMultiplier
Como en la versión 3.50 se podría decir que era el mejor equilibrio de eficiencia entre el manejo de interrupciones del temporizador en modo kernel y las solicitudes en modo usuario para el conteo de ticks en milisegundos, ``TickCountLow`` y en versiones posteriores ``TickCount`` de 64 bits son conteos sin procesar de los ticks en modo kernel. La conversión a milisegundos se realiza solo cuando alguien lo desea, como al llamar a ``GetTickCount`` o ``GetTickCount64``.

La conversión consiste en multiplicar el conteo de ticks sin procesar por el período máximo, ahora entendido como la longitud de un tick en unidades de ``100 ns``, y dividir por ``10 000``. Para que las funciones ``GetTickCount`` puedan ser más rápidas para evitar la división, el kernel precalcula un multiplicador y lo coloca también en ``KUSER_SHARED_DATA``. Este ``TickCountMultiplier`` (constante) es el período máximo, ampliado a cero hasta 64 bits, desplazado a la izquierda 24 bits y luego dividido por 10 000. Cada conversión de ``TickCount`` a milisegundos es entonces una multiplicación por ``TickCountMultiplier`` y un desplazamiento a la derecha de 24 bits.

Sorprendentemente, este cálculo previo sencillo del multiplicador, que muchos esperarían que se realice en una sola instrucción C, se realiza en cambio como una rutina propia de, probablemente, diez instrucciones C. Esta rutina, llamada ``ExComputeTickCountMultiplier``, parece haberse mantenido sin cambios durante unos 30 años. La nomino como el código de kernel más antiguo sin cambios. Además, no es código muerto: se ejecuta cada vez que se inicia Windows.

No es que quiera recomendarlo para programación, pero sabiendo cómo se calcula ``TickCountMultiplier`` puedes aprender el período máximo sin llamar al núcleo: multiplica ``TickCountMultiplier`` por ``10 000``, redondea al siguiente múltiplo de 2 a la potencia de 24 y desplaza a la derecha 24 bits. Por ejemplo, los multiplicadores comúnmente observados 0x0FA00000 y 0x0F99A027 corresponden respectivamente a períodos máximos de 156 250 y 156 001 (recuerda, en unidades de 100 ns).


## InterruptTime y SystemTime
Esta noción del tic del temporizador como una interrupción idealizada con un período que es constante a lo largo de toda la ejecución del núcleo data de la versión 3.50. Se desarrolló de forma bastante natural a partir de la versión 3.10, que no tiene flexibilidad para el período de la interrupción del temporizador: el tic del temporizador en la versión 3.10 es realmente la interrupción. Si la documentación moderna parece no distinguir el tic del temporizador de la interrupción del temporizador real, entonces al menos una explicación es que alguna vez no había nada que distinguir. Vea, por ejemplo, que el texto del título de la función ``KeQueryTickCount`` en modo kernel incluso hoy, 20 de octubre de 2020, dice "mantiene un recuento de las interrupciones del temporizador de intervalo que han ocurrido desde que se inició el sistema". Esta descripción no ha cambiado exactamente, palabra por palabra, desde la documentación de la función en el DDK para Windows NT 3.1 en 1993, cuando era correcta. Para desentrañar esto, no puedo pensar en una mejor manera que seguir la historia.

En la versión 3.10, el núcleo mantiene un recuento de ticks y una hora del sistema como variables internas. El recuento de ticks comienza en cero y, literalmente, es solo un recuento de interrupciones, comenzando desde el momento en que, durante la inicialización del núcleo, lo que sea que sirva como temporizador comenzó a interrumpir. La hora del sistema está destinada a relacionarse con el mundo exterior, como el tiempo desde el inicio de 1601 en unidades de 100 ns. Su valor inicial se aprende de la HAL durante la inicialización del núcleo, pero luego se puede cambiar a través de interfaces, incluso desde el modo de usuario con privilegios suficientes. Las interrupciones del temporizador se repiten con un período constante. Cada una aumenta el recuento de ticks en 1 y la hora del sistema en el período en unidades de 100 ns.

En la versión 3.50, el núcleo aún mantiene el recuento de ticks como una variable en sus propios datos, aunque ahora se exporta (como ``KeTickCount``) y se amplía (no solo a 64 bits, sino que se extiende a una estructura ``KSYSTEM_TIME``). Lo nuevo en el conteo de ticks es que el núcleo también mantiene una copia de los 32 bits bajos como ``TickCountLow`` en ``KUSER_SHARED_DATA`` para un fácil acceso desde el modo de usuario. El tiempo del sistema en la versión 3.50 ya no es una variable interna en el núcleo. En su lugar, el núcleo mantiene un tiempo de interrupción y un tiempo del sistema en ``KUSER_SHARED_DATA`` como ``InterruptTime`` y ``SystemTime``. El tiempo de interrupción es nuevo. Es como el conteo de ticks en el sentido de que comienza como cero, pero es como el tiempo del sistema en el sentido de que tiene ``100 ns`` como su unidad de medida. Otra novedad es que el tiempo entre interrupciones puede variar. Siguen siendo periódicas, pero el período se puede reprogramar entre un mínimo y un máximo que son constantes. Cada interrupción aumenta el ``InterruptTime`` por el período actual en unidades de ``100 ns``. Si, al producirse una interrupción, el núcleo ve que se habría producido una interrupción idealizada con el período máximo desde la última interrupción real, entonces aumenta el ``TickCount`` en 1 y el ``SystemTime`` en el período máximo en unidades de ``100 ns``.

El esquema se ha elaborado a lo largo de las décadas, pero en lo que respecta a estos primeros miembros de ``KUSER_SHARED_DATA``, la esencia de la historia temprana aún se mantiene. El ``TickCount`` y el ``InterruptTime`` comienzan desde cero durante la inicialización del núcleo. El ``InterruptTime`` y el ``SystemTime`` están en unidades de ``100 ns``. El ``InterruptTime`` es la noción de tiempo más reciente del núcleo, tal como se aprende de las interrupciones reales. El ``TickCount`` y el ``SystemTime`` se mantienen en las interrupciones reales, pero el ``TickCount`` y, antes de Windows Vista, el ``SystemTime`` se actualizan solo como si las interrupciones tuvieran el período máximo.

Aunque lo que se quiere de ``TickCount``, ``InterruptTime`` y ``SystemTime`` son 64 bits cada uno, se almacenan como estructuras KSYSTEM_TIME de 12 bytes. Esto es una consideración de x86, pero también se aplica al núcleo x64 a través de su soporte para software en modo usuario que ejecuta el conjunto de instrucciones x86. El x86 no puede leer o escribir 64 bits en una instrucción sin un prefijo de bloqueo, lo que sería mejor evitar, y de todos modos la instrucción (``cmpxchg8b``) que permite esto ni siquiera estaba disponible para las primeras versiones. Desde el principio, entonces, se necesita una defensa eficiente contra lecturas y escrituras entremezcladas. La defensa puede ser altamente especializada debido al control estricto de la lectura y la escritura. Solo el núcleo escribirá estos miembros. Los lectores son más variados pero son pocos y lo ideal es que solo los escriba Microsoft. Lo más importante es que la naturaleza de las escrituras es que la palabra dword alta cambia con mucha menos frecuencia que la baja. Para los miembros que normalmente solo aumentan como un tiempo medido en unidades de 100 ns, la palabra dword alta cambia un poco menos de cada 7 minutos y sus valores antiguos nunca pueden volver a aparecer en decenas de miles de años. El único cambio que necesita defensa es el de la palabra dword alta. El diseño de ``KSYSTEM_TIME`` es que el valor de 64 bits es seguido por un duplicado de su parte alta. El núcleo siempre escribe la segunda parte alta y solo entonces las partes baja y alta habituales. Excepto por el propio núcleo cuando sabe que no puede ser interrumpido, los lectores del valor de 64 bits siguen leyendo la segunda parte alta y comprobando la igualdad con la primera: si difieren, el lector sabe que debe volver a intentarlo.

En la práctica, la lectura la realizan únicamente los componentes de bajo nivel de Microsoft, que exponen los resultados a través de interfaces. La función que el software en modo kernel con buen comportamiento solicita para leer ``SystemTime`` es ``KeQuerySystemTime``. Curiosamente, no se proporcionó ningún equivalente para ``InterruptTime`` hasta que el kernel de la versión 5.0 exporta ``KeQueryInterruptTime``.

La interfaz de modo usuario igualmente directa para leer 64 bits de ``SystemTime`` es ``GetSystemTimeAsFileTime``, que se exporta desde ``KERNEL32.DLL`` en la versión 3.51 y posteriores. ``GetSystemTime``, menos directa pero más antigua, lee ``SystemTime`` pero lo vuelve a empaquetar en una estructura SYSTEMTIME. La exposición en modo usuario de ``InterruptTime`` a través de una función documentada tuvo que esperar a ``QueryInterruptTime`` en la versión 10.0. La función WINMM ``timeGetTime`` lee ``InterruptTime`` en la versión 3.50 y superiores, pero no devuelve los 64 bits: divide por 10 000 para informar solo milisegundos enteros.

## TimeZoneBias
La hora del mundo real descrita por ``SystemTime`` es lo que en mi infancia se conocía como ``Greenwich Mean Time`` (``GMT``), pero que incluso entonces estaba estandarizada como ``Coordinated Universal Time`` (UTC). Aunque a veces parece que los programadores estadounidenses, si no los estadounidenses en general, no piensan mucho en un mundo que escribe la fecha de forma diferente, todos saben que su hora del día no es la de un célebre observatorio naval no muy lejos de Londres. Lo que los usuarios de ordenadores de todo el mundo quieren casi siempre es su propia hora local.

``TimeZoneBias`` es lo que debe restarse de la hora del sistema para producir la ``hora local``. El núcleo lo aprende del registro inicialmente, pero se puede cambiar a través de interfaces, incluso desde el modo de usuario. Aunque el sesgo solo se especifica como un número entero de minutos, el núcleo lo establece en ``KUSER_SHARED_DATA`` como un número de unidades de 100 ns para que la resta de ``SystemTime`` sea sencilla.

Al igual que con ``TickCount``, pero a diferencia de ``InterruptTime`` y ``SystemTime``, el ``TimeZoneBias`` en ``KUSER_SHARED_DATA`` es solo para acceso en modo usuario. Es una copia de una variable en los datos propios del núcleo. Las funciones del núcleo que funcionan con el sesgo utilizan la variable interna. Ninguna función en modo usuario la lee solo para revelarla, solo para usarla para una resta o suma que convierte a o desde la hora local.

Una implicación posiblemente subestimada de la dependencia de las funciones de API en el ``TimeZoneBias`` en ``KUSER_SHARED_DATA`` para convertir a y desde la hora local es que la hora local es global para todos los procesos.


```c
typedef struct _KUSER_SHARED_DATA {
  ULONG                         TickCountLowDeprecated;
  ULONG                         TickCountMultiplier;
  KSYSTEM_TIME                  InterruptTime;
  KSYSTEM_TIME                  SystemTime;
  KSYSTEM_TIME                  TimeZoneBias;
  USHORT                        ImageNumberLow;
  USHORT                        ImageNumberHigh;
  WCHAR                         NtSystemRoot[260];
  ULONG                         MaxStackTraceDepth;
  ULONG                         CryptoExponent;
  ULONG                         TimeZoneId;
  ULONG                         LargePageMinimum;
  ULONG                         AitSamplingValue;
  ULONG                         AppCompatFlag;
  ULONGLONG                     RNGSeedVersion;
  ULONG                         GlobalValidationRunlevel;
  LONG                          TimeZoneBiasStamp;
  ULONG                         NtBuildNumber;
  NT_PRODUCT_TYPE               NtProductType;
  BOOLEAN                       ProductTypeIsValid;
  BOOLEAN                       Reserved0[1];
  USHORT                        NativeProcessorArchitecture;
  ULONG                         NtMajorVersion;
  ULONG                         NtMinorVersion;
  BOOLEAN                       ProcessorFeatures[PROCESSOR_FEATURE_MAX];
  ULONG                         Reserved1;
  ULONG                         Reserved3;
  ULONG                         TimeSlip;
  ALTERNATIVE_ARCHITECTURE_TYPE AlternativeArchitecture;
  ULONG                         BootId;
  LARGE_INTEGER                 SystemExpirationDate;
  ULONG                         SuiteMask;
  BOOLEAN                       KdDebuggerEnabled;
  union {
    UCHAR MitigationPolicies;
    struct {
      UCHAR NXSupportPolicy : 2;
      UCHAR SEHValidationPolicy : 2;
      UCHAR CurDirDevicesSkippedForDlls : 2;
      UCHAR Reserved : 2;
    };
  };
  USHORT                        CyclesPerYield;
  ULONG                         ActiveConsoleId;
  ULONG                         DismountCount;
  ULONG                         ComPlusPackage;
  ULONG                         LastSystemRITEventTickCount;
  ULONG                         NumberOfPhysicalPages;
  BOOLEAN                       SafeBootMode;
  union {
    UCHAR VirtualizationFlags;
    struct {
      UCHAR ArchStartedInEl2 : 1;
      UCHAR QcSlIsSupported : 1;
    };
  };
  UCHAR                         Reserved12[2];
  union {
    ULONG SharedDataFlags;
    struct {
      ULONG DbgErrorPortPresent : 1;
      ULONG DbgElevationEnabled : 1;
      ULONG DbgVirtEnabled : 1;
      ULONG DbgInstallerDetectEnabled : 1;
      ULONG DbgLkgEnabled : 1;
      ULONG DbgDynProcessorEnabled : 1;
      ULONG DbgConsoleBrokerEnabled : 1;
      ULONG DbgSecureBootEnabled : 1;
      ULONG DbgMultiSessionSku : 1;
      ULONG DbgMultiUsersInSessionSku : 1;
      ULONG DbgStateSeparationEnabled : 1;
      ULONG SpareBits : 21;
    } DUMMYSTRUCTNAME2;
  } DUMMYUNIONNAME2;
  ULONG                         DataFlagsPad[1];
  ULONGLONG                     TestRetInstruction;
  LONGLONG                      QpcFrequency;
  ULONG                         SystemCall;
  ULONG                         Reserved2;
  ULONGLONG                     FullNumberOfPhysicalPages;
  ULONGLONG                     SystemCallPad[1];
  union {
    KSYSTEM_TIME TickCount;
    ULONG64      TickCountQuad;
    struct {
      ULONG ReservedTickCountOverlay[3];
      ULONG TickCountPad[1];
    } DUMMYSTRUCTNAME;
  } DUMMYUNIONNAME3;
  ULONG                         Cookie;
  ULONG                         CookiePad[1];
  LONGLONG                      ConsoleSessionForegroundProcessId;
  ULONGLONG                     TimeUpdateLock;
  ULONGLONG                     BaselineSystemTimeQpc;
  ULONGLONG                     BaselineInterruptTimeQpc;
  ULONGLONG                     QpcSystemTimeIncrement;
  ULONGLONG                     QpcInterruptTimeIncrement;
  UCHAR                         QpcSystemTimeIncrementShift;
  UCHAR                         QpcInterruptTimeIncrementShift;
  USHORT                        UnparkedProcessorCount;
  ULONG                         EnclaveFeatureMask[4];
  ULONG                         TelemetryCoverageRound;
  USHORT                        UserModeGlobalLogger[16];
  ULONG                         ImageFileExecutionOptions;
  ULONG                         LangGenerationCount;
  ULONGLONG                     Reserved4;
  ULONGLONG                     InterruptTimeBias;
  ULONGLONG                     QpcBias;
  ULONG                         ActiveProcessorCount;
  UCHAR                         ActiveGroupCount;
  UCHAR                         Reserved9;
  union {
    USHORT QpcData;
    struct {
      UCHAR QpcBypassEnabled;
      UCHAR QpcReserved;
    };
  };
  LARGE_INTEGER                 TimeZoneBiasEffectiveStart;
  LARGE_INTEGER                 TimeZoneBiasEffectiveEnd;
  XSTATE_CONFIGURATION          XState;
  KSYSTEM_TIME                  FeatureConfigurationChangeStamp;
  ULONG                         Spare;
  ULONG64                       UserPointerAuthMask;
  XSTATE_CONFIGURATION          XStateArm64;
  ULONG                         Reserved10[210];
} KUSER_SHARED_DATA, *PKUSER_SHARED_DATA;
```

## Members

`TickCountLowDeprecated`
Current low 32-bit of tick count.

`TickCountMultiplier`
Tick count multiplier.

`InterruptTime`
Current 64-bit interrupt time in 100ns units.

`SystemTime`
Current 64-bit system time in 100ns units.

`TimeZoneBias`
Current 64-bit time zone bias.

`ImageNumberLow`
Low image magic number for the host system.

`ImageNumberHigh`
High image magic number for the host system.

`NtSystemRoot[260]`
Copy of system root in unicode. This field must be accessed via the **RtlGetNtSystemRoot** API for an accurate result.

`MaxStackTraceDepth`
Maximum stack trace depth if tracing enabled.

`CryptoExponent`
Crypto exponent value.

`TimeZoneId`
Time zone ID.

`LargePageMinimum`
Defines the **ULONG** member **LargePageMinimum**.

`AitSamplingValue`
This value controls the AIT sampling rate.

`AppCompatFlag`
This value controls switchback processing.

`RNGSeedVersion`
Current kernel root RNG state seed version.

`GlobalValidationRunlevel`
This value controls assertion failure handling.

`TimeZoneBiasStamp`
Defines the **LONG** member **TimeZoneBiasStamp**.

`NtBuildNumber`
The shared collective build number undecorated with C or F. **GetVersionEx** hides the real number.

`NtProductType`
Product type. This field must be accessed via the **RtlGetNtProductType** API for an accurate result.

`ProductTypeIsValid`
Defines the **BOOLEAN** member **ProductTypeIsValid**.

`Reserved0[1]`
Reserved for future use.

`NativeProcessorArchitecture`
Defines the **USHORT** member **NativeProcessorArchitecture**.

`NtMajorVersion`
The NT major version. Each process sees a version from its PEB, but if the process is running with an altered view of the system version, this field is used to correctly identify the version.

`NtMinorVersion`
The NT minor version. Each process sees a version from its PEB, but if the process is running with an altered view of the system version, this field is used to correctly identify the version.

`ProcessorFeatures[PROCESSOR_FEATURE_MAX]`
Processor features.

`Reserved1`
Reserved for future use.

`Reserved3`
Reserved for future use.

`TimeSlip`
Time slippage while in debugger.

`AlternativeArchitecture`
Alternative system architecture. For example, NEC PC98xx on x86.

`BootId`
Boot sequence, incremented for each boot attempt by the OS loader.

`SystemExpirationDate`
If the system is an evaluation unit, the following field contains the date and time that the evaluation unit expires. A value of 0 indicates that there is no expiration. A non-zero value is the UTC absolute time that the system expires.

`SuiteMask`
Suite support. This field must be accessed via the RtlGetSuiteMask API for an accurate result.

`KdDebuggerEnabled`
TRUE if a kernel debugger is connected/enabled.

`MitigationPolicies`
Mitigation policies.

`NXSupportPolicy`
Defines the **UCHAR** member **NXSupportPolicy**.

`SEHValidationPolicy`
Defines the **UCHAR** member **SEHValidationPolicy**.

`CurDirDevicesSkippedForDlls`
Defines the **UCHAR** member **CurDirDevicesSkippedForDlls**.

`Reserved`
Reserved for future use.

`CyclesPerYield`
Measured duration of a single processor yield, in cycles. This is used by lock packages to determine how many times to spin waiting for a state change before blocking.

`ActiveConsoleId`
Current console session Id. Always zero on non-TS systems. This field must be accessed via the **RtlGetActiveConsoleId** API for an accurate result.

`DismountCount`
Force-dismounts cause handles to become invalid. Rather than always probe handles, a serial number of dismounts is maintained that clients can use to see if they need to probe handles.

`ComPlusPackage`
This field indicates the status of the 64-bit COM+ package on the system. It indicates whether the Intermediate Language (IL) COM+ images need to use the 64-bit COM+ runtime or the 32-bit COM+ runtime.

`LastSystemRITEventTickCount`
Time in tick count for system-wide last user input across all terminal sessions. For MP performance, it is not updated all the time (for example, once a minute per session). It is used for idle detection.

`NumberOfPhysicalPages`
Number of physical pages in the system. This can dynamically change as physical memory can be added or removed from a running system.

`SafeBootMode`
True if the system was booted in safe boot mode.

`VirtualizationFlags`
Virtualization flags.

`ArchStartedInEl2`
Keep this bitfield in sync with the one in arc.w.

`QcSlIsSupported`
Keep this bitfield in sync with the one in arc.w.

`Reserved12[2]`
Reserved for future use.

`DUMMYUNIONNAME2`
This is a packed bitfield that contains various flags concerning the system state. They must be manipulated using interlocked operations. **DbgMultiSessionSku** must be accessed via the **RtlIsMultiSessionSku** API for an accurate result.

`DUMMYUNIONNAME2.SharedDataFlags`
Defines the **ULONG** member **SharedDataFlags**.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2`
Defines the **DUMMYSTRUCTNAME2** structure.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgErrorPortPresent`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgElevationEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgVirtEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgInstallerDetectEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgLkgEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgDynProcessorEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgConsoleBrokerEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgSecureBootEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgMultiSessionSku`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgMultiUsersInSessionSku`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.DbgStateSeparationEnabled`
For debugger only. Do not use. Use the bit definitions instead.

`DUMMYUNIONNAME2.DUMMYSTRUCTNAME2.SpareBits`
For the debugger only. Do not use. Use the bit definitions instead.

`DataFlagsPad[1]`
Defines the **ULONG** member **DataFlagsPad**.

`TestRetInstruction`
Depending on the processor, the code for fast system call will differ. This field is only used on 32-bit systems.

`QpcFrequency`
Defines the **LONGLONG** member **QpcFrequency**.

`SystemCall`
On AMD64, this value is initialized to a nonzero value if the system operates with an altered view of the system service call mechanism.
El campo **SystemCall** se encuentra dentro de la estructura **KUSER_SHARED_DATA** a un offset fijo; en la mayoría de las versiones modernas de Windows éste se sitúa a 0x308 bytes desde el inicio de la estructura. Debido a que **KUSER_SHARED_DATA** está mapeado en modo usuario en la dirección 0x7FFE0000, el campo se encuentra en 0x7FFE0308 cuando se accede desde espacio de usuario. En modo kernel, la misma estructura se mapea en 0xFFFFF78000000000, de modo que el campo **SystemCall** se encuentra en 0xFFFFF78000000308.

Con respecto a qué mecanismo de llamada se utiliza:

- **Cuando el valor de SystemCall es cero:**  
    La rutina en **ntdll.dll** (y otros stubs de llamada al sistema) utilizará la instrucción **syscall** para realizar la transición de usuario a kernel, que es el método habitual en arquitecturas AMD64.
    
- **Cuando SystemCall es distinto de cero (normalmente 1):**  
    Esto indica que el kernel se ha iniciado “con una vista alterada” del mecanismo de llamada al sistema. En concreto, si ciertas condiciones de arranque están presentes (por ejemplo, cuando el cargador de arranque y la configuración del sistema –vía variables como **KiSystemCallSelector** y bits en el bloque de parámetros de arranque– indican que el sistema opera en un entorno “enlightened” o virtualizado), el kernel establece este campo a 1. En ese caso, los stubs de **ntdll.dll** realizan la transición mediante la interrupción **int 0x2E** en lugar de usar **syscall**.
    

Esta dualidad permite al sistema ajustar internamente el método de transición según las necesidades (por ejemplo, para mejorar la compatibilidad o seguridad en entornos virtualizados) sin que las aplicaciones de usuario tengan que modificar su forma de invocar los servicios del kernel.

[](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-kuser_shared_data)

`Reserved2`
Reserved for future use.

`FullNumberOfPhysicalPages`
Reserved for future use.

`SystemCallPad[1]`
Reserved for future use.

`DUMMYUNIONNAME3`
The 64-bit tick count.

`DUMMYUNIONNAME3.TickCount`
Defines the **KSYSTEM_TIME** member **TickCount**.

`DUMMYUNIONNAME3.TickCountQuad`
Defines the **ULONG64** member **TickCountQuad**.

`DUMMYUNIONNAME3.DUMMYSTRUCTNAME`
Defines **DUMMYSTRUCTNAME**.

`DUMMYUNIONNAME3.DUMMYSTRUCTNAME.ReservedTickCountOverlay[3]`
Defines the **ULONG** member **ReservedTickCountOverlay**.

`DUMMYUNIONNAME3.DUMMYSTRUCTNAME.TickCountPad[1]`
Defines the **ULONG** member **TickCountPad**.

`Cookie`
Cookie for encoding pointers system wide.

`CookiePad[1]`
Reserved for future use.

`ConsoleSessionForegroundProcessId`
Client id of the process having the focus in the current active console session id. This field must be accessed via the **RtlGetConsoleSessionForegroundProcessId** API for an accurate result.

`TimeUpdateLock`
Placeholder for the (internal) time update lock. This data is used to implement the precise time services. It is aligned on a 64-byte cache-line boundary and arranged in the order of typical accesses.

`BaselineSystemTimeQpc`
The performance counter value used to establish the current system time.

`BaselineInterruptTimeQpc`
The performance counter value used to compute the last interrupt time.

`QpcSystemTimeIncrement`
The scaled number of system time seconds represented by a single performance count (this value may vary to achieve time synchronization).

`QpcInterruptTimeIncrement`
The scaled number of interrupt time seconds represented by a single performance count (this value is constant after the system is booted).

`QpcSystemTimeIncrementShift`
The scaling shift count applied to the performance counter system time increment.

`QpcInterruptTimeIncrementShift`
The scaling shift count applied to the performance counter interrupt time increment.

`UnparkedProcessorCount`
The count of unparked processors.

`EnclaveFeatureMask[4]`
A bitmask of enclave features supported on this system. This field must be accessed via the **RtlIsEnclareFeaturePresent** API for an accurate result.

`TelemetryCoverageRound`
Current coverage round for telemetry based coverage.

`UserModeGlobalLogger[16]`
The following field is used for ETW user mode global logging (UMGL).

`ImageFileExecutionOptions`
Settings that can enable the use of Image File Execution Options from HKCU in addition to the original HKLM.

`LangGenerationCount`
Generation of the kernel structure holding system language information.

`Reserved4`
Reserved for future use.

`InterruptTimeBias`
Current 64-bit interrupt time bias in 100ns units.

`QpcBias`
Current 64-bit performance counter bias, in performance counter units before the shift is applied.

`ActiveProcessorCount`
Number of active processors.

`ActiveGroupCount`
Number of active groups.

`Reserved9`
Reserved for future use.

`QpcData`
Defines the **USHORT** member QpcData.

`QpcBypassEnabled`
A boolean indicating whether performance counter queries can read the counter directly (bypassing the system call).

`QpcReserved`
Reserved for future use.

`TimeZoneBiasEffectiveStart`
Defines the **LARGE_INTEGER** member **TimeZoneBiasEffectiveStart**.

`TimeZoneBiasEffectiveEnd`
Defines the **LARGE_INTEGER** member **TimeZoneBiasEffectiveEnd**.

`XState`
Extended processor state configuration.

`FeatureConfigurationChangeStamp`
Defines the **KSYSTEM_TIME** member **FeatureConfigurationChangeStamp**.

`Spare`
Defines the **ULONG** member **Spare**.

`UserPointerAuthMask`
Defines the **ULONG64** member **UserPointerAuthMask**.

`XStateArm64`

`Reserved10[210]`