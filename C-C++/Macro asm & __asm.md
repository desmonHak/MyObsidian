
https://gcc.gnu.org/onlinedocs/gcc/Using-Assembly-Language-with-C.html

## 6.50.1 Instrucciones básicas de ensamblador sin operandos
Una sentencia básica de ensamblador tiene la siguiente sintaxis:

```c
asm asm-qualifiers ( AssemblerInstructions )
```

Para el lenguaje C, la palabra clave asm es una extensión de GNU. Al escribir código C que se pueda compilar con ``-ansi`` y las opciones ``-std`` que seleccionan dialectos de C sin extensiones de GNU, utilice ``__asm__`` en lugar de asm (consulte [[Palabras clave alternativas]]). 
Para el lenguaje C++, asm es una palabra clave estándar, pero se puede utilizar ``__asm__`` para código compilado con ``-fno-asm``.

**Calificadores**
``volatile``
El calificador opcional volátil no tiene efecto. Todos los bloques básicos de ensamblador son implícitamente volátiles.

``inline``
Si utiliza el calificador inline, entonces, para fines de incrustación en línea, el tamaño de la sentencia asm se toma como el tamaño más pequeño posible (consulte [[Tamaño del código en la macro asm]]).

**Parámetros**
``AssemblerInstructions``
Esta es una cadena literal que especifica el código ensamblador. La cadena puede contener cualquier instrucción reconocida por el ensamblador, incluidas las directivas. GCC no analiza las instrucciones del ensamblador en sí mismas y no sabe qué significan o incluso si son una entrada de ensamblador válida.

Puede colocar varias instrucciones del ensamblador juntas en una sola cadena ``asm``, separadas por los caracteres que se usan normalmente en el código ensamblador del sistema. Una combinación que funciona en la mayoría de los lugares es una nueva línea para romper la línea, más un carácter de tabulación (escrito como '``\n\t``'). Algunos ensambladores permiten puntos y coma como separador de línea. Sin embargo, tenga en cuenta que algunos dialectos del ensamblador usan puntos y coma para comenzar un comentario.

### 6.50.2 Instrucciones de ensamblador extendidas con operandos de expresión C
Con asm extendido puedes leer y escribir variables C desde ensamblador y realizar saltos desde código ensamblador a etiquetas C. La sintaxis asm extendida usa dos puntos (‘:’) para delimitar los parámetros de los operandos después de la plantilla de ensamblador:
```c
asm asm-qualifiers ( AssemblerTemplate 
                 : OutputOperands 
                 [ : InputOperands
                 [ : Clobbers ] ])

asm asm-qualifiers ( AssemblerTemplate 
                      : OutputOperands
                      : InputOperands
                      : Clobbers
                      : GotoLabels)
```
donde en la última forma, ``asm-qualifiers`` contiene ``goto`` (y en la primera forma, no).
La palabra clave ``asm`` es una extensión de GNU. 

**Calificadores**
``volatile``
El uso típico de las sentencias asm extendidas es manipular valores de entrada para producir valores de salida. Sin embargo, sus sentencias asm también pueden producir efectos secundarios. Si es así, es posible que deba utilizar el calificador volátil para deshabilitar ciertas optimizaciones. Consulte Volátil.

``inline``
Si utiliza el calificador ``inline``, entonces, para fines de inserción en línea, el tamaño de la sentencia asm se toma como el tamaño más pequeño posible (consulte [[Tamaño del código en la macro asm]]).

``goto``
Este calificador informa al compilador que la sentencia ``asm`` puede realizar un salto a una de las etiquetas enumeradas en ``GotoLabels``. Consulte ``GotoLabels``.

**Parámetros**
``AssemblerTemplate``
Esta es una cadena literal que es la plantilla para el código ensamblador. Es una combinación de texto fijo y tokens que hacen referencia a los parámetros de entrada, salida y ``goto``. Consulte ``AssemblerTemplate``. Con ``gnu++11`` o posterior, también puede ser una expresión constante dentro de paréntesis (consulte asm ``constexprs``).

``OutputOperands``
Una lista separada por comas de las variables C modificadas por las instrucciones en ``AssemblerTemplate``. Se permite una lista vacía. Consulte ``OutputOperands``. Con ``gnu++11`` o posterior, las cadenas también pueden ser expresiones constantes dentro de paréntesis (consulte asm ``constexprs``).

``InputOperands``
Una lista separada por comas de expresiones C leídas por las instrucciones en ``AssemblerTemplate``. Se permite una lista vacía. Consulte ``InputOperands``. Con ``gnu++11`` o posterior, las cadenas también pueden ser expresiones constantes dentro de paréntesis (ver asm ``constexprs``)

``Clobbers``
Una lista separada por comas de registros u otros valores modificados por ``AssemblerTemplate``, más allá de los que se enumeran como salidas. Se permite una lista vacía. Ver ``Clobbers`` y Scratch ``Registers``. Con ``gnu++11`` o posterior, las cadenas también pueden ser expresiones constantes dentro de paréntesis (ver asm ``constexprs``)

``GotoLabels``
Cuando se utiliza la forma ``goto`` de asm, esta sección contiene la lista de todas las etiquetas C a las que puede saltar el código en ``AssemblerTemplate``. Ver ``GotoLabels``.

Las instrucciones asm no pueden realizar saltos a otras instrucciones asm, solo a las ``GotoLabels`` enumeradas. Los optimizadores de GCC no conocen otros saltos; por lo tanto, no pueden tenerlos en cuenta al decidir cómo optimizar.

El número total de operandos de ``entrada`` + ``salida`` + ``goto`` está limitado a 30.

### Observaciones
Observaciones
La declaración asm le permite incluir instrucciones de ensamblaje directamente dentro del código C. Esto puede ayudarlo a maximizar el rendimiento en código sensible al tiempo o a acceder a instrucciones de ensamblaje que no están disponibles para los programas C.

Tenga en cuenta que las declaraciones ``asm`` extendidas deben estar dentro de una función. Solo las asm básicas pueden estar fuera de las funciones (consulte [Ensamblador básico: instrucciones de ensamblador sin operandos](https://gcc.gnu.org/onlinedocs/gcc/Basic-Asm.html)). Las funciones declaradas con el atributo ``naked`` también requieren asm básico (consulte [Declaración de atributos de funciones](https://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html)).

Si bien los usos de asm son muchos y variados, puede resultar útil pensar en una declaración asm como una serie de instrucciones de bajo nivel que convierten los parámetros de entrada en parámetros de salida. Por lo tanto, un ejemplo simple (si bien no particularmente útil) para ``i386`` que utiliza ``asm`` podría verse así:
```c
int src = 1;
int dst;   

asm ("mov %1, %0\n\t"
    "add $1, %0"
    : "=r" (dst) 
    : "r" (src));

printf("%d\n", dst);
```

### 6.50.2.1 Volátil
Los optimizadores de GCC a veces descartan las sentencias asm si determinan que no hay necesidad de las variables de salida. Además, los optimizadores pueden sacar el código de los bucles si creen que el código siempre devolverá el mismo resultado (es decir, ninguno de sus valores de entrada cambia entre llamadas). El uso del calificador ``volátil`` deshabilita estas optimizaciones. Las sentencias asm que no tienen operandos de salida y las sentencias asm ``goto`` son implícitamente volátiles.

Este código ``i386`` demuestra un caso que no utiliza (o requiere) el calificador volátil. Si está realizando una comprobación de aserciones, este código utiliza asm para realizar la validación. De lo contrario, ningún código hace referencia a ``dwRes``. Como resultado, los optimizadores pueden descartar la sentencia asm, lo que a su vez elimina la necesidad de toda la rutina ``DoCheck``. Al omitir el calificador ``volátil`` cuando no es necesario, permite que los optimizadores produzcan el código más eficiente posible.
```c
void DoCheck(uint32_t dwSomeValue)
{
   uint32_t dwRes;

   // Assumes dwSomeValue is not zero.
   asm ("bsfl %1,%0"
     : "=r" (dwRes)
     : "r" (dwSomeValue)
     : "cc");

   assert(dwRes > 3);
}
```

El siguiente ejemplo muestra un caso en el que los optimizadores pueden reconocer que la entrada (``dwSomeValue``) nunca cambia durante la ejecución de la función y, por lo tanto, pueden mover el ``asm`` fuera del bucle para producir un código más eficiente. Nuevamente, el uso del calificador volátil deshabilita este tipo de optimización.
```c
void do_print(uint32_t dwSomeValue)
{
   uint32_t dwRes;

   for (uint32_t x=0; x < 5; x++)
   {
      // Assumes dwSomeValue is not zero.
      asm ("bsfl %1,%0"
        : "=r" (dwRes)
        : "r" (dwSomeValue)
        : "cc");

      printf("%u: %u %u\n", x, dwSomeValue, dwRes);
   }
}
```
El siguiente ejemplo demuestra un caso en el que es necesario utilizar el calificador volátil. Utiliza la instrucción ``rdtsc`` x86, que lee el contador de marca de tiempo de la computadora. Sin el calificador volátil, los optimizadores podrían suponer que el bloque asm siempre devolverá el mismo valor y, por lo tanto, optimizarían la segunda llamada.
```c
uint64_t msr;

asm volatile ( "rdtsc\n\t"    // Returns the time in EDX:EAX.
        "shl $32, %%rdx\n\t"  // Shift the upper bits left.
        "or %%rdx, %0"        // 'Or' in the lower bits.
        : "=a" (msr)
        : 
        : "rdx");

printf("msr: %llx\n", msr);

// Do other work...

// Reprint the timestamp
asm volatile ( "rdtsc\n\t"    // Returns the time in EDX:EAX.
        "shl $32, %%rdx\n\t"  // Shift the upper bits left.
        "or %%rdx, %0"        // 'Or' in the lower bits.
        : "=a" (msr)
        : 
        : "rdx");

printf("msr: %llx\n", msr);
```
Los optimizadores de GCC no tratan este código como el código no volátil de los ejemplos anteriores. No lo sacan de los bucles ni lo omiten asumiendo que el resultado de una llamada anterior sigue siendo válido.

Tenga en cuenta que el compilador puede mover incluso instrucciones asm volátiles en relación con otro código, incluso entre instrucciones de salto. Por ejemplo, en muchos destinos hay un registro del sistema que controla el modo de redondeo de las operaciones de punto flotante. Configurarlo con una declaración asm volátil, como en el siguiente ejemplo de PowerPC, no funciona de manera confiable.
```c
asm volatile("mtfsf 255, %0" : : "f" (fpenv));
sum = x + y;
```
  
El compilador puede mover la adición hacia atrás antes de la declaración del ensamblado volátil. Para que funcione como se espera, agregue una dependencia artificial al ensamblado haciendo referencia a una variable en el código subsiguiente, por ejemplo:
```c
asm volatile ("mtfsf 255,%1" : "=X" (sum) : "f" (fpenv));
sum = x + y;
```
En determinadas circunstancias, GCC puede duplicar (o eliminar duplicados de) su código ensamblador al optimizar. Esto puede provocar errores inesperados de símbolos duplicados durante la compilación si su código ensamblador define símbolos o etiquetas. El uso de ‘%=’ (consulte [AssemblerTemplate]([AssemblerTemplate](https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#AssemblerTemplate))) puede ayudar a resolver este problema.

### 6.50.2.2 Plantilla de ensamblador
Una plantilla de ensamblador es una cadena literal que contiene instrucciones de ensamblador. El compilador reemplaza los tokens en la plantilla que hacen referencia a ``entradas``, ``salidas`` y etiquetas ``goto``, y luego envía la cadena resultante al ensamblador. La cadena puede contener cualquier instrucción reconocida por el ensamblador, incluidas las directivas. GCC no analiza las instrucciones de ensamblador en sí mismas y no sabe qué significan o incluso si son una entrada de ensamblador válida. Sin embargo, cuenta las instrucciones.

Puede colocar varias instrucciones de ensamblador juntas en una sola cadena de ensamblador, separadas por los caracteres que se usan normalmente en el código de ensamblador para el sistema. Una combinación que funciona en la mayoría de los lugares es una nueva línea para romper la línea, más un carácter de tabulación para pasar al campo de instrucción (escrito como '``\n\t``'). Algunos ensambladores permiten puntos y coma como separador de línea. Sin embargo, tenga en cuenta que algunos dialectos de ensamblador usan puntos y coma para comenzar un comentario.

No espere que una secuencia de instrucciones asm permanezca perfectamente consecutiva después de la compilación, incluso cuando esté usando el calificador volátil. Si ciertas instrucciones necesitan permanecer consecutivas en la salida, colóquelas en una única instrucción asm de múltiples instrucciones.

El acceso a datos de programas C sin usar operandos de entrada/salida (por ejemplo, mediante el uso de símbolos globales directamente desde la plantilla de ensamblador) puede no funcionar como se espera. De manera similar, llamar a funciones directamente desde una plantilla de ensamblador requiere una comprensión detallada del ensamblador de destino y la ``ABI``.

Dado que GCC no analiza la plantilla de ensamblador, no tiene visibilidad de ningún símbolo al que haga referencia. Esto puede provocar que GCC descarte esos símbolos como no referenciados a menos que también se incluyan como operandos de entrada, salida o ``goto``.

Cadenas de formato especial
Además de los tokens descritos por los operandos de entrada, salida y goto, estos tokens tienen significados especiales en la plantilla del ensamblador:

``‘%%’``
Emite un solo ‘%’ en el código del ensamblador.

``‘%=’``
Emite un número que es único para cada instancia de la instrucción asm en toda la compilación. Esta opción es útil cuando se crean etiquetas locales y se hace referencia a ellas varias veces en una sola plantilla que genera varias instrucciones del ensamblador.

``‘%{’``
``‘%|’``
``‘%}’``
Emite los caracteres ‘{’, ‘|’ y ‘}’ (respectivamente) en el código del ensamblador. Cuando no se escapan, estos caracteres tienen un significado especial para indicar varios dialectos del ensamblador, como se describe a continuación.

### Varios dialectos de ensamblador en plantillas asm
En destinos como x86, GCC admite varios dialectos de ensamblador. La opción ``-masm`` controla qué dialecto utiliza GCC como predeterminado para el ensamblador en línea. La documentación específica del destino para la opción`` -masm`` contiene la lista de dialectos compatibles, así como el dialecto predeterminado si no se especifica la opción. Esta información puede ser importante de entender, ya que el código de ensamblador que funciona correctamente cuando se compila utilizando un dialecto probablemente fallará si se compila utilizando otro. Consulte Opciones x86.

Si su código necesita admitir varios dialectos de ensamblador (por ejemplo, si está escribiendo encabezados públicos que necesitan admitir una variedad de opciones de compilación), use construcciones de este formato:

``{ dialect0 | dialect1 | dialect2... }``

Esta construcción genera ``dialect0 ``cuando se usa el dialecto n.° 0 para compilar el código, ``dialect1`` para el dialecto n.° 1, etc. Si hay menos alternativas dentro de las llaves que la cantidad de dialectos que admite el compilador, la construcción no genera nada.

Por ejemplo, si un compilador ``x86`` admite dos dialectos ('``att``', '``intel``'), una plantilla de ensamblador como esta:

```c
"bt{l %[Offset],%[Base] | %[Base],%[Offset]}; jc %l2"
```
es equivalente a uno de los siguientes:
```c
"btl %[Offset],%[Base] ; jc %l2" /* dialecto att */
"bt %[Base],%[Offset]; jc %l2" /* dialecto intel */
```
Usando ese mismo compilador, este código:

```c
"xchg{l}\t{%%}ebx, %1"
```
corresponde a cualquiera de los dos:

```c
"xchgl\t%%ebx, %1" /* dialecto att */
"xchg\tebx, %1" /* dialecto intel */
```
No hay soporte para anidar alternativas de dialecto.

### 6.50.2.3 Operandos de salida
Una declaración asm tiene cero o más operandos de salida que indican los nombres de las variables C modificadas por el código ensamblador.

En este ejemplo ``i386``, old (mencionado en la cadena de plantilla como %0) y ``*Base`` (como %1) son salidas y Offset (%2) es una entrada:
```c
bool old;

__asm__ ("btsl %2,%1\n\t" // Activa el bit [[Offset]] basado en cero en Base.
"sbb %0,%0" // Utiliza el CF para calcular el valor antiguo.
: "=r" (antiguo), "+rm" (*Base)
: "Ir" (Desplazamiento)
: "cc");

return old;
```
Los operandos se separan con comas. Cada operando tiene este formato:
```c
[ [asmSymbolicName] ] constraint (cvariablename)
```
``asmSymbolicName``
Especifica un nombre simbólico para el operando. Haga referencia al nombre en la plantilla del ensamblador encerrándolo entre corchetes (es decir, ‘%[Value]’). El alcance del nombre es la declaración asm que contiene la definición. Se acepta cualquier nombre de variable C válido, incluidos los nombres ya definidos en el código circundante. No hay dos operandos dentro de la misma declaración asm que puedan usar el mismo nombre simbólico.

Cuando no se utiliza un ``asmSymbolicName``, se utiliza la posición (basada en cero) del operando en la lista de operandos de la plantilla del ensamblador. Por ejemplo, si hay tres operandos de salida, se utiliza ‘%0’ en la plantilla para hacer referencia al primero, ‘%1’ para el segundo y ‘%2’ para el tercero.

``Restricción``
Constante de cadena que especifica restricciones sobre la ubicación del operando; consulte Restricciones para los operandos asm para obtener más detalles.

Las restricciones de salida deben comenzar con ‘=’ (una variable que sobrescribe un valor existente) o ‘+’ (al leer y escribir). Cuando utilice ‘=’, no asuma que la ubicación contiene el valor existente en la entrada al asm, excepto cuando el operando esté vinculado a una entrada; consulte Operandos de entrada.

Después del prefijo, debe haber una o más restricciones adicionales (consulte Restricciones para los operandos asm) que describan dónde reside el valor. Las restricciones comunes incluyen ‘r’ para registro y ‘m’ para memoria. Cuando enumera más de una ubicación posible (por ejemplo, "=rm"), el compilador elige la más eficiente según el contexto actual. Si enumera tantas alternativas como permita la declaración asm, permite que los optimizadores produzcan el mejor código posible. Si debe utilizar un registro específico, pero las restricciones de su máquina no proporcionan el control suficiente para seleccionar el registro específico que desea, las variables de registro locales pueden proporcionar una solución (consulte Especificación de registros para variables locales).

``cvariablename``
Especifica una expresión de valor l de C para almacenar la salida, normalmente un nombre de variable. Los paréntesis que encierran son una parte obligatoria de la sintaxis.

Cuando el compilador selecciona los registros que se utilizarán para representar los operandos de salida, no utiliza ninguno de los registros modificados (consulte Modificaciones y registros modificados).

Las expresiones de operandos de salida deben ser valores l. El compilador no puede comprobar si los operandos tienen tipos de datos que sean razonables para la instrucción que se está ejecutando. Para las expresiones de salida que no se pueden direccionar directamente (por ejemplo, un campo de bits), la restricción debe permitir un registro. En ese caso, GCC utiliza el registro como salida del asm y, a continuación, almacena ese registro en la salida.

Los operandos que utilizan el modificador de restricción ‘+’ cuentan como dos operandos (es decir, como entrada y como salida) para el máximo total de 30 operandos por instrucción asm.

Utilice el modificador de restricción ‘&’ (consulte Caracteres modificadores de restricción) en todos los operandos de salida que no deben superponerse a una entrada. De lo contrario, GCC puede asignar el operando de salida en el mismo registro que un operando de entrada no relacionado, suponiendo que el código ensamblador consume sus entradas antes de producir salidas. Esta suposición puede ser falsa si el código ensamblador en realidad consta de más de una instrucción.

El mismo problema puede ocurrir si un parámetro de salida (a) permite una restricción de registro y otro parámetro de salida (b) permite una restricción de memoria. El código generado por GCC para acceder a la dirección de memoria en b puede contener registros que podrían ser compartidos por a, y GCC considera que esos registros son entradas al asm. Como se indicó anteriormente, GCC supone que dichos registros de entrada se consumen antes de que se escriban las salidas. Esta suposición puede dar como resultado un comportamiento incorrecto si la declaración asm escribe en a antes de usar b. La combinación del modificador ‘&’ con la restricción de registro en a garantiza que la modificación de a no afecte la dirección a la que hace referencia b. De lo contrario, la ubicación de b no está definida si se modifica a antes de usar b.

asm admite modificadores de operandos en operandos (por ejemplo, ‘%k2’ en lugar de simplemente ‘%2’). Los modificadores de operandos genéricos enumeran los modificadores que están disponibles en todos los destinos. Otros modificadores dependen del hardware. Por ejemplo, la lista de modificadores admitidos para x86 se encuentra en Modificadores de operandos x86.

Si el código C que sigue al asm no hace uso de ninguno de los operandos de salida, utilice volátil para la declaración asm para evitar que los optimizadores descarten la declaración asm por innecesaria (consulte Volátil).

Este código no utiliza el asmSymbolicName opcional. Por lo tanto, hace referencia al primer operando de salida como %0 (si hubiera un segundo, sería %1, etc.). El número del primer operando de entrada es uno mayor que el del último operando de salida. En este ejemplo i386, eso hace que Mask se haga referencia como %1:
```c
uint32_t Mask = 1234;
uint32_t Index;

  asm ("bsfl %1, %0"
     : "=r" (Index)
     : "r" (Mask)
     : "cc");
```

Aquí, d puede estar en un registro o en la memoria. Dado que el compilador ya puede tener el valor actual de la ubicación uint32_t a la que apunta e en un registro, puede habilitarlo para que elija la mejor ubicación para d especificando ambas restricciones.

### 6.50.2.4 Operandos de salida de indicadores
Algunos destinos tienen un registro especial que contiene los “indicadores” para el resultado de una operación o comparación. Normalmente, el contenido de ese registro no es modificado por el ensamblador, o se considera que la declaración del ensamblador destruye el contenido.

En algunos destinos, existe una forma especial de operando de salida por la cual las condiciones en el registro de indicadores pueden ser salidas del ensamblador. El conjunto de condiciones admitidas son específicas del destino, pero la regla general es que la variable de salida debe ser un entero escalar y el valor es booleano. Cuando se admite, el destino define el símbolo de preprocesador ``__GCC_ASM_FLAG_OUTPUTS__``.

Debido a la naturaleza especial de los operandos de salida de indicadores, la restricción puede no incluir alternativas.

La mayoría de las veces, el objetivo tiene solo un registro de indicadores y, por lo tanto, es un operando implícito de muchas instrucciones. En este caso, no se debe hacer referencia al operando dentro de la plantilla del ensamblador a través de %0, etc., ya que no hay un texto correspondiente en el lenguaje ensamblador.

x86 family

The flag output constraints for the x86 family are of the form ‘=@cccond’ where cond is one of the standard conditions defined in the ISA manual for `jcc` or `setcc`.

`a`

“above” or unsigned greater than

`ae`

“above or equal” or unsigned greater than or equal

`b`

“below” or unsigned less than

`be`

“below or equal” or unsigned less than or equal

`c`

carry flag set

`e`

`z`

“equal” or zero flag set

`g`

signed greater than

`ge`

signed greater than or equal

`l`

signed less than

`le`

signed less than or equal

`o`

overflow flag set

`p`

parity flag set

`s`

sign flag set

`na`

`nae`

`nb`

`nbe`

`nc`

`ne`

`ng`

`nge`

`nl`

`nle`

`no`

`np`

`ns`

`nz`

“not” flag, or inverted versions of those above

s390