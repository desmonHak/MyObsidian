ver [[Código_inyectivo_dentro_de_la_tabla_de_importación]]

https://learn.microsoft.com/en-us/windows/win32/debug/pe-format
https://learn.microsoft.com/es-es/windows/win32/api/winnt/ns-winnt-image_section_header?redirectedfrom=MSDN
https://learn.microsoft.com/en-us/archive/msdn-magazine/2002/february/inside-windows-win32-portable-executable-file-format-in-detail

- https://deephacking.tech/anatomia-del-formato-pe-portable-executable-maldev/
- https://lordrna.com/2020/formato-PE-para-dembowseros/
- [Windows PE File Structure – Malcore](https://bible.malcore.io/readme/the-journey/windows-pe-structure)
- [A dive into the PE file format – Introduction – 0xRick](https://0xrick.github.io/win-internals/pe1/)
- [A dive into the PE file format – PE file structure – Part 1: Overview – 0xRick](https://0xrick.github.io/win-internals/pe2/)
- [A dive into the PE file format – PE file structure – Part 2: DOS Header, DOS Stub and Rich Header – 0xRick](https://0xrick.github.io/win-internals/pe3/)
- [A dive into the PE file format – PE file structure – Part 3: NT Headers – 0xRick](https://0xrick.github.io/win-internals/pe4/)
- [A dive into the PE file format – PE file structure – Part 4: Data Directories, Section Headers and Sections – 0xRick](https://0xrick.github.io/win-internals/pe5/)
- [An Introduction to Malware Analysis – PE format – crow](https://youtu.be/-cIxKeJp4xo?si=76LAoadT1qQ8GEuI&t=1110)
- [Portable Executable File Format – kowalczyk](https://blog.kowalczyk.info/articles/pefileformat.html)
- [Portable Executable Format: Made Easy – v0rkath](https://www.v0rkath.com/blog/portable-executable-format/)
- [File formats dissections and more… – corkami](https://github.com/corkami/pics/)
- [Why is 0x00400000 the default base address for an executable?](https://devblogs.microsoft.com/oldnewthing/20141003-00/?p=43923)
- [VA (Virtual Address) & RVA (Relative Virtual Address)](https://stackoverflow.com/questions/2170843/va-virtual-address-rva-relative-virtual-address)
- [/BASE (Base address)](https://learn.microsoft.com/en-us/cpp/build/reference/base-base-address?view=msvc-170)
- [winnt.h – mingw-w64](https://github.com/Alexpux/mingw-w64/blob/master/mingw-w64-tools/widl/include/winnt.h)
- [Windows Portable Executable (PE) Files Structure – filovirid.com](https://blog.filovirid.com/page/Windows-Portable-Executable-Files-Structure)
- [Difference Between Linker and Loader – GeeksForGeeks](https://www.geeksforgeeks.org/difference-between-linker-and-loader/)
- [Compilation process with GCC and C programs – luischaparroc](https://medium.com/@luischaparroc/compilation-process-with-gcc-and-c-programs-344445180ac8)

- **==PE32==**: Archivo ejecutable portable de 32 bits.
- **==PE32+==**: Archivo ejecutable portable de 64 bits.
- **==BYTE==**: Un byte de datos (también conocido como DB).
- **==WORD==**: Dos bytes de datos (también conocido como DW).
- **==DWORD==**: Cuatro bytes de datos (también conocido como DD).
- **==Sección==**: Las secciones son los contenedores de los datos del archivo ejecutable. Cada archivo PE puede tener múltiples secciones, y cada una tiene un nombre y atributos específicos que determinan cómo el sistema operativo debe manejarla.
- **==Archivo de objeto==**: Es el resultado del ensamblador o compilador y suele estar en formato _**COFF** (Common Object File Format)_. Estos archivos sirven como entrada para el _linker_.
- **==Archivo de imagen==**: Es el resultado del linker y se llama archivo de imagen. Puede ser un archivo ejecutable (.exe) o una biblioteca de enlaces dinámicos (.dll). El formato PE _(Portable Executable)_ es una extensión del formato COFF y es el estándar para archivos ejecutables y DLL en sistemas Windows.
- **==Archivo binario==**: Un archivo binario puede ser un archivo de objeto o un archivo de imagen.
- **==Loader de Windows== (**o simplemente _**loader**_**):** Es el código responsable de cargar un archivo PE en la memoria. Cuando un archivo PE se carga en la memoria, su versión en memoria se llama **módulo**.
- ==Desplazamiento (offset)==: Es una referencia a la posición de un dato o instrucción dentro de un archivo o en memoria. El desplazamiento indica cuántos bytes hay que avanzar desde una posición inicial, como el inicio de un archivo o un segmento de memoria, para llegar a una ubicación específica. En los archivos PE, se usa para señalar la posición de diferentes secciones o componentes dentro del archivo.
- ==Mapear==: En el contexto de sistemas operativos y archivos ejecutables, «mapear» significa asignar partes de un archivo directamente a la memoria del sistema para que puedan ser usadas por un programa. Es como crear un enlace entre el contenido del archivo en disco y una zona específica de la memoria, permitiendo que el programa acceda a esa información de manera rápida y eficiente. En el caso de los archivos PE (Portable Executable), el loader de Windows toma las secciones del archivo ejecutable y las coloca en la memoria. Esto establece una correspondencia entre las posiciones del archivo en el disco y las direcciones en la memoria. Gracias a este proceso, el programa puede acceder directamente a sus instrucciones y datos necesarios durante la ejecución, sin tener que cargar todo el archivo completo en memoria de una sola vez.
- ==Encabezados NT==: A veces a los encabezados NT también se le conocen como encabezados PE, por lo que si ves por ahí PE Header en vez de NT Header, que sepas que se refiere a lo mismo.
- 

## winnt.h

A lo largo del artículo vamos a ver muchas definiciones y estructuras de datos distintas, el punto en común de todas ellas es que se encuentran en el archivo de cabecera _**winnt.h**_.

Este archivo está disponible en el repositorio de GitHub de **_mingw-w64_**. Todas las estructuras y definiciones que mencionaremos se pueden consultar directamente en el [siguiente enlace](https://github.com/Alexpux/mingw-w64/blob/master/mingw-w64-tools/widl/include/winnt.h).

----


Con ``Windows 9x/NT``, se requirió un nuevo tipo de archivo ejecutable. Así nació el ejecutable portátil "[[PE]]", que todavía se utiliza. A diferencia de sus predecesores, WIN-PE es un formato de archivo de 32 bits verdadero, que admite código reubicable. Distingue entre TEXTO, DATOS y BSS. Es, de hecho, una versión bastarda del formato [[COFF]].

Si configuró un entorno Cygwin en su máquina Windows, "[[PE]]" es el formato de destino para su cadena de herramientas Cygwin GCC, lo que causa algunos dolores de cabeza a los que no lo saben cuando intentan vincular partes compiladas en Cygwin con partes compiladas en Linux o BSD (que usan el destino ELF por defecto). (Sugerencia: debe compilar un compilador cruzado GCC)

El formato [[PE]] lo utilizan Windows 95 y versiones posteriores, ``Windows NT 3.1`` y versiones posteriores, ``Mobius``, ``ReactOS`` y UEFI. El formato PE también se utiliza como contenedor para ensamblajes ``.NET`` tanto por Microsoft ``.Net`` CLI como por Mono, en cuyo caso en realidad no almacena datos ejecutables sino metadatos ``.Net`` con IL adjunto.

## Dentro del archivo [[PE]]
A continuación, intentaremos explicar los distintos conceptos y partes que componen un archivo [[PE]] en lugar de las estructuras de datos exactas que contienen, ya que eso ocuparía demasiado espacio. El razonamiento es que la mayoría de los recursos sobre archivos [[PE]] tienden a arrojarle un montón de estructuras de datos sin explicar completamente para qué sirven. Por lo tanto, al leer lo siguiente y saber en qué consiste un archivo [[PE]], comprenderá mejor qué esperar y cómo utilizar los recursos de los archivos [[PE]].


## DOS Stub
El formato [[PE]] comienza con un stub ``MS-DOS`` (un encabezado más código ejecutable) que lo convierte en un ejecutable ``MS-DOS`` válido. El encabezado ``MS-DOS`` comienza con el código mágico ``0x5A4D`` y tiene 64 bytes de longitud, seguido de código ejecutable en modo real. El stub estándar que se usa casi universalmente tiene ``128 bytes`` de longitud (incluyendo el encabezado y el código ejecutable) y simplemente muestra "Este programa no se puede ejecutar en modo DOS". **A pesar de que muchas utilidades que usan archivos [[PE]] están codificadas para esperar que el encabezado [[PE]] comience exactamente a los ``128 bytes``, esto es incorrecto** ya que en algunos enlazadores, incluido el propio Link de Microsoft, es posible reemplazar el stub ``MS-DOS`` con uno de su elección, y muchos programas más antiguos hacían esto para permitir que el desarrollador agrupara una versión ``MS-DOS`` y Windows en un solo archivo. La forma correcta es leer una dirección de 4 bytes que antes estaba reservada dentro del encabezado ``MS-DOS`` ubicado en ``0x3C`` (campo conocido comúnmente como ``e_lfanew``) que contiene la dirección en la que se encuentra la firma del archivo [[PE]], y el encabezado del archivo [[PE]] sigue inmediatamente. Por lo general, este es un valor bastante estándar (la mayoría de las veces, este campo está configurado en ``0xE8`` por el stub ``link.exe`` predeterminado). Microsoft aparentemente recomienda alinear el encabezado [[PE]] en un límite de 8 bytes (https://web.archive.org/web/20160609191558/http://msdn.microsoft.com/en-us/gg463119.aspx, página 10, figura 1).

![[Pasted image 20250301203133.png]]
![[Pasted image 20250228210317.png]]

Aunque no es un encabezado que se utilice comúnmente en los sistemas Windows modernos, sigue estando presente por razones de compatibilidad con sistemas más antiguos. Podemos ver la estructura de este encabezado al comprobar la definición de la estructura ==«IMAGE_DOS_HEADER»== ubicada en la librería _[[winnt.h]]_:
```c
typedef struct _IMAGE_DOS_HEADER {      // DOS .EXE header
    WORD   e_magic;                     // Magic number
    WORD   e_cblp;                      // Bytes on last page of file
    WORD   e_cp;                        // Pages in file
    WORD   e_crlc;                      // Relocations
    WORD   e_cparhdr;                   // Size of header in paragraphs
    WORD   e_minalloc;                  // Minimum extra paragraphs needed
    WORD   e_maxalloc;                  // Maximum extra paragraphs needed
    WORD   e_ss;                        // Initial (relative) SS value
    WORD   e_sp;                        // Initial SP value
    WORD   e_csum;                      // Checksum
    WORD   e_ip;                        // Initial IP value
    WORD   e_cs;                        // Initial (relative) CS value
    WORD   e_lfarlc;                    // File address of relocation table
    WORD   e_ovno;                      // Overlay number
    WORD   e_res[4];                    // Reserved words
    WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
    WORD   e_oeminfo;                   // OEM information; e_oemid specific
    WORD   e_res2[10];                  // Reserved words
    LONG   e_lfanew;                    // File address of new exe header
  } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;
```

Aunque este encabezado no sea muy utilizado, si que es cierto que contiene 6 bytes con información importante para el cargador del sistema operativo:

- ==e_magic [2-bytes/WORD]==: Este campo, también llamado «_magic number_«, se posiciona justo en los 2 primeros bytes del archivo PE. Estos primeros dos bytes tienen un valor hexadecimal fijo de ==0x5A4D==, que se traduce como ‘==MZ==‘ en ASCII. Este valor se utiliza para identificar un tipo de archivo compatible con MS-DOS, y por esta razón, sirve como firma para indicar que se trata de un archivo ejecutable MS-DOS válido. Como curiosidad, ‘MZ’ se refiere a [Mark Zbikowski](https://en.wikipedia.org/wiki/Mark_Zbikowski), uno de los desarrolladores de MS-DOS.

## Rich Header
Una vez visto el encabezado DOS y el _DOS Stub_ deberíamos de pasar a los encabezados NT. Sin embargo, antes de ellos, hay un posible fragmento de datos conocido como encabezado _Rich_ que puede o no estar presente. Se trata de una estructura sin documentar que solo está presente en aquellos ejecutables que han sido creados con el conjunto de herramientas de Microsoft. 
![[Pasted image 20250301191634.png]]
![[Pasted image 20250301191652.png]]
Este encabezado está formado por:
- Un conjunto de datos pasados por XOR.
- La palabra clave _Rich_ (en _PE-Bear_ corresponde al campo _Rich ID_).
- Una clave XOR, que por un lado sirve como _checksum_ y por otro como clave en sí para descifrar los datos en XOR.

Esta estructura es generada por el enlazador (_linker_) y contiene algunos metadatos sobre las herramientas utilizadas para construir el ejecutable, por ejemplo:
![[Pasted image 20250301191733.png]]

En la imagen podemos observar el análisis del encabezado _Rich_ de nuestro archivo de imagen usando [rich.py](https://github.com/RichHeaderResearch/RichPE). El script detalla el entorno de compilación, _VS2008 SP1 build 30729_ en este caso. Además, se enumeran diferentes módulos mediante IDs y versiones específicas, junto con un conteo que indica la cantidad de veces que cada módulo fue utilizado durante la construcción de la imagen. Por ejemplo, el módulo con ID 259, versión 33808, aparece 3 veces. Por otro lado, la línea que indica objetos no marcados (_Unmarked objects count=64_) hace referencia a secciones del ejecutable que no están directamente asociadas con herramientas específicas del compilador, pero que aún forman parte del archivo final.

Este campo no solo contiene información relevante sobre el perfil del entorno de compilación, sino que también puede ser muy útil para usarse como firma o _fingerprint_. El count también da posibles indicaciones sobre el tamaño del proyecto, y el _checksum_ también puede ser usado como una firma.

Como contiene información de este tipo, los desarrolladores de malware suelen modificar esta cabecera para no proporcionar esta información o aprovecharse de este encabezado para realizar otras acciones. Si quieres ver mas información dejo por aquí algunos enlaces:

- [The devil’s in the Rich header](https://securelist.com/the-devils-in-the-rich-header/84348/)
- [Rich Header Research](https://github.com/RichHeaderResearch/RichPE)
- [Case studies in Rich Header analysis and hunting](http://ropgadget.com/posts/richheader_hunting.html)
- [Microsoft’s Rich Signature (undocumented)](https://www.ntcore.com/files/richsign.htm)
- [PE File Rich Header](https://offwhitesecurity.dev/malware-development/portable-executable-pe/rich-header/)[](https://github.com/RichHeaderResearch/RichPE#rich-header-research)


Todos los recursos que he leído sobre archivos PE no mencionan esta estructura, sin embargo, cuando busqué sobre Rich Header en sí, encontré una cantidad decente de recursos, y eso tiene sentido porque Rich Header en realidad no es parte de la estructura del formato de archivo PE y se puede eliminar por completo sin interferir con la funcionalidad del ejecutable, es solo algo que Microsoft agrega a cualquier ejecutable creado con su conjunto de herramientas de Visual Studio.

Solo sé sobre Rich Header porque leí los informes sobre el malware Olympic Destroyer, y para aquellos que no saben qué es Olympic Destroyer, es un malware que fue escrito y utilizado por un grupo de amenazas en un intento de interrumpir los Juegos Olímpicos de Invierno de 2018.
Este malware es conocido por tener muchas banderas falsas que se colocaron intencionalmente para causar confusión y atribución errónea; una de las banderas falsas presentes era un Rich Header.
Los autores del malware sobrescribieron el Rich Header original en el ejecutable del malware con el Rich Header de otro malware atribuido al grupo de amenazas Lazarus para que pareciera que era Lazarus.
Puede consultar el informe de Kaspersky para obtener más información al respecto.

El Rich Header consiste en un fragmento de datos XOR seguido de una firma (Rich) y un valor de suma de comprobación de 32 bits que es la clave XOR.
Los datos cifrados consisten en una firma DWORD DanS, 3 DWORD en cero para relleno, luego pares de DWORD, cada par representa una entrada, y cada entrada contiene un nombre de herramienta, su número de compilación y la cantidad de veces que se ha utilizado.
En cada par DWORD, el primer par contiene el ID de tipo o el ID de producto en la PALABRA alta y el ID de compilación en la PALABRA baja; el segundo par contiene el recuento de usos.

PE-bear analiza el encabezado enriquecido automáticamente:
![[Pasted image 20250301195811.png]]
Como puede ver, la firma DanS es lo primero en la estructura, luego hay 3 DWORD con ceros y después vienen las entradas.
También podemos ver las herramientas correspondientes y las versiones de Visual Studi del producto y los identificadores de compilación.
![[Pasted image 20250301195836.png]]

Como ejercicio, escribí un script para analizar este encabezado yo mismo. Es un proceso muy simple: todo lo que tenemos que hacer es aplicar la operación XOR a los datos, luego leer los pares de entradas y traducirlos.

Datos de encabezado enriquecidos(Rich Header):
```css
7E 13 87 AA 3A 72 E9 F9 3A 72 E9 F9 3A 72 E9 F9
33 0A 7A F9 30 72 E9 F9 F1 1D E8 F8 38 72 E9 F9 
F1 1D EC F8 2B 72 E9 F9 F1 1D ED F8 30 72 E9 F9 
F1 1D EA F8 39 72 E9 F9 61 1A E8 F8 3F 72 E9 F9 
3A 72 E8 F9 0A 72 E9 F9 BC 02 E0 F8 3B 72 E9 F9 
BC 02 16 F9 3B 72 E9 F9 BC 02 EB F8 3B 72 E9 F9 
52 69 63 68 3A 72 E9 F9 00 00 00 00 00 00 00 00
```

script:
```python
import textwrap

def xor(data, key):
	return bytearray( ((data[i] ^ key[i % len(key)]) for i in range(0, len(data))) )

def rev_endiannes(data):
	tmp = [data[i:i+8] for i in range(0, len(data), 8)]
	
	for i in range(len(tmp)):
		tmp[i] = "".join(reversed([tmp[i][x:x+2] for x in range(0, len(tmp[i]), 2)]))
	
	return "".join(tmp)

data = bytearray.fromhex("7E1387AA3A72E9F93A72E9F93A72E9F9330A7AF93072E9F9F11DE8F83872E9F9F11DECF82B72E9F9F11DEDF83072E9F9F11DEAF83972E9F9611AE8F83F72E9F93A72E8F90A72E9F9BC02E0F83B72E9F9BC0216F93B72E9F9BC02EBF83B72E9F9")
key  = bytearray.fromhex("3A72E9F9")

rch_hdr = (xor(data,key)).hex()
rch_hdr = textwrap.wrap(rch_hdr, 16)

for i in range(2,len(rch_hdr)):
	tmp = textwrap.wrap(rch_hdr[i], 8)
	f1 = rev_endiannes(tmp[0])
	f2 = rev_endiannes(tmp[1])
	print("{} {} : {}.{}.{}".format(f1, f2, str(int(f1[4:],16)), str(int(f1[0:4],16)), str(int(f2,16)) ))
```

Tenga en cuenta que tuve que invertir el orden de bytes porque los datos se presentaron en formato little-endian.

Después de ejecutar el script, podemos ver un resultado idéntico a la interpretación de PE-bear, lo que significa que el script funciona bien.

![[Pasted image 20250301200152.png]]

Para traducir estos valores a los tipos y versiones de herramientas reales, es necesario recopilar los valores de las instalaciones reales de Visual Studio.
Revisé el código fuente de bearparser (el analizador utilizado en PE-bear) y encontré comentarios que mencionaban de dónde se habían recopilado estos valores.

en ``richheader``([[prodids.py]] && [[rich.py]])
```
//list from: https://github.com/kirschju/richheader
//list based on: https://github.com/kirschju/richheader + pnx's notes
```


```c
typedef struct __RICH_HEADER_INFO {
    int size;
    char* ptrToBuffer;
    int entries;
} RICH_HEADER_INFO, * PRICH_HEADER_INFO;
typedef struct __RICH_HEADER_ENTRY {
    WORD  prodID;
    WORD  buildID;
    DWORD useCount;
} RICH_HEADER_ENTRY, * PRICH_HEADER_ENTRY;
typedef struct __RICH_HEADER {
    PRICH_HEADER_ENTRY entries;
} RICH_HEADER, * PRICH_HEADER;
```

## Diferencia de flujo de ejecución entre un sistema Windows y un MS-DOS

Según lo visto hasta ahora, el comportamiento al ejecutar un archivo de imagen entre ambos sistemas sería la siguiente:
![[Pasted image 20250301200745.png]]
![[Pasted image 20250301191831.png]]

## Encabezado [[PE]]
El encabezado [[PE]] contiene información que concierne al archivo completo en lugar de a partes individuales que aparecerán más adelante. El encabezado mínimo contiene una firma de 4 bytes (``0x00004550`` o ``'PE\0\0'``), el tipo de máquina/arquitectura del código ejecutable en su interior, una marca de tiempo, un puntero a símbolos, así como varios indicadores (¿el archivo es un ejecutable, ``DLL``, la aplicación puede manejar direcciones superiores a ``2 GB``, es necesario copiar el archivo al archivo de intercambio si se ejecuta desde un dispositivo extraíble, etc.). A menos que estés usando un archivo PE enlazado estáticamente muy reducido para ahorrar memoria con un punto de entrada codificado de forma rígida y sin recursos, entonces el encabezado [[PE]] por sí solo no es suficiente.

#### File Header (IMAGE_FILE_HEADER)

Esta estructura almacena información sobre el archivo PE, también es llamado «encabezado de archivo COFF». Está definido en _winnt.h_ como ==«IMAGE_FILE_HEADER»==:
https://wiki.osdev.org/PE
```c
// 1 byte aligned
struct PeHeader {
	uint32_t mMagic; // PE\0\0 or 0x00004550
	uint16_t mMachine;
	uint16_t mNumberOfSections;
	uint32_t mTimeDateStamp;
	uint32_t mPointerToSymbolTable;
	uint32_t mNumberOfSymbols;
	uint16_t mSizeOfOptionalHeader;
	uint16_t mCharacteristics;
};
```

- ==Machine== ==[2-bytes/WORD]==: Especifica la arquitectura de destino para el ejecutable (x86, x64, ARM, etc). Aunque solo nos interesan dos, ``0x8864`` para AMD64 y ``0x14c`` para i386. Se puede ver la lista completa de valores en la [documentación oficial de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#machine-types).
- ==NumberOfSections [2-bytes/WORD]==: Este campo almacena el número de secciones, dicho de otra manera, el numero de encabezados de secciones (tamaño de la tabla de sección).
- ==TimeDateStamp== ==[4-bytes/DWORD]==: Este valor indica la hora de creación o compilación del programa en forma de _epoch timestamp_ (``1728682065``), que mide los segundos transcurridos desde el ``01/01/97 00:00:00``. Un aspecto interesante a tener en cuenta es el riesgo de un _integer overflow_ en 2038 debido al limitado espacio disponible en este campo DWORD.
- ==PointerToSymbolTable y NumberOfSymbols== ==[4-bytes/DWORD]==: Estos dos campos contienen el offset del archivo a la tabla de símbolos [[COFF]] y el número de entradas en esa tabla de símbolos. Sin embargo se ponen a 0 porque la información de depuración [[COFF]] está obsoleta en los archivos [[PE]] modernos (no hay tabla de símbolos [[COFF]] presente).
- ==SizeOfOptionalHeader [2-bytes/WORD]==: Almacena el tamaño del encabezado opcional. Para [[PE]]32 suele ser ``0x00E0`` (224 bytes) y para [[PE]]32+ suele ser ``0X00F0`` (240 bytes).
- ==Characteristics [2-bytes/WORD]==: Contiene _flag_s que indican los atributos del archivo. Estos atributos pueden ser cosas como que el archivo sea ejecutable, que sea un archivo de sistema y no un programa de usuario, y muchas otras cosas. La lista completa de atributos se puede encontrar en la [documentación de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#characteristics), algunos de ellos serían:
    - 0x0002 – Archivo ejecutable
    - 0x0020 – La aplicación puede manejar direcciones mayores a 2 GB
    - **0x0100** – El archivo es una DLL
    - **0x2000** – El archivo es un archivo de sistema.
    - **0x4000** – El archivo es un controlador cargable dinámicamente (_loadable driver_).
    - **0x8000** – El archivo tiene conciencia de medios removibles (_media-aware_).

## Encabezado opcional
El encabezado [[PE]] opcional sigue directamente después del encabezado [[PE]] estándar. 

Este encabezado es el mas importante de los encabezados NT. El cargador del sistema mirará la información dada por este encabezado para ser capaz de cargar y ejecutar el ejecutable. Se llama encabezado opcional debido que algunos tipos de archivo como los archivos de objetos no la llevan, sin embargo, es esencial para los archivos de imagen. Este encabezado no tiene un valor fijo, por eso existe el miembro ==«SizeOfOptionalHeader»== en la estructura ==«IMAGE_FILE_HEADER»==.

Los primeros 8 miembros del encabezado opcional son estándar para cada implementación del formato de archivo [[COFF]], el resto del encabezado es una extensión del encabezado estándar opcional [[COFF]] definido por Microsoft, estos miembros adicionales de la estructura son necesarios para el cargador y enlazador de Windows.

Como se mencionó previamente, existen dos versiones para este encabezado, una para ejecutables de 32 bits y otra para 64. Las dos versiones son diferentes en dos aspectos:

- ==El tamaño de la propia estructura (o el número de miembros definidos dentro de la estructura)==: ==«IMAGE_OPTIONAL_HEADER32»== tiene 31 miembros mientras que ==«IMAGE_OPTIONAL_HEADER64»== sólo tiene 30 miembros, ese miembro adicional en la versión de 32 bits es un DWORD llamado ==«BaseOfData»== que contiene la RVA del comienzo de la sección de datos.
- ==El tipo de datos de algunos de los miembros==: Los siguientes 5 miembros de la estructura ==«IMAGE_OPTIONAL_HEADER»== se definen como tipo de dato DWORD en la versión de 32 bits y como ULONGLONG en la versión de 64 bits:
    - ==«ImageBase»==
    - ==«SizeOfStackReserve»==
    - ==«SizeOfStackCommit»==
    - ==«SizeOfHeapReserve»==
    - ==«SizeOfHeapCommit»==

Su tamaño se especifica en el encabezado [[PE]], que también puede utilizar para saber si existe el encabezado opcional. El encabezado [[PE]] opcional comienza con un código mágico de ``2 bytes`` que representa la arquitectura (``0x010B`` para ``PE32``, ``0x020B`` para ``PE64``, ``0x0107`` ``ROM``). Esto se puede utilizar junto con el tipo de máquina que se ve en el encabezado [[PE]] para detectar si el archivo [[PE]] se está ejecutando en un sistema compatible. Hay algunas otras variables útiles relacionadas con la memoria, incluido el tamaño y la base virtual del código y los datos, así como el número de versión de la aplicación (completamente especificado por el usuario, algunas utilidades de actualización lo utilizan para detectar si hay una versión más nueva disponible), el punto de entrada y cuántos directorios hay (consulte a continuación).

Parte del encabezado opcional es específico de NT. Esto incluye el subsistema (consola, controlador o aplicación GUI), cuánto espacio de pila y montón reservar y el sistema operativo, subsistema y versión de Windows mínimos requeridos. Puede utilizar sus propios valores para todos estos dependiendo de las necesidades de su sistema operativo.


En este header, también existe un Magic Number para especificar que tipo de ejecutable es el que contiene el Optional Header, ``IMAGE_NT_OPTIONAL_HDR32_MAGIC`` (``0x10b``) para el ``Optional Header`` de 32 bits, ``IMAGE_NT_OPTIONAL_HDR64_MAGIC`` (``0x20b``) para el ``Optional Header`` de 64 bits, como nuestro caso, ``IMAGE_ROM_OPTIONAL_HDR_MAGIC`` para un Optional Header en roms. Podemos encontrar en el mismo, otros campos importantes como ``SizeOfCode``, ``SizeOfInitializedData`` y ``SizeOfUninitializedData``, que contienen el tamaño de la información de la sección de código, de datos inicializados y de datos no inicializados, todos estos alineados con respecto a ``FileAlignment`` de esta misma sección. Nos encontramos con quizás uno de los valores más importante a la hora de iniciar ejecución que es ``AddressOfEntryPoint`` (Modificado en técnicas como [[PE]] Injection), el cual nos dice en que dirección, relativa a la base en memoria, se iniciara la ejecución.

En otro orden, podemos encontrar campos como ``BaseOfCode`` que nos dice en que dirección relativa a la base en memoria, iniciara la sección de código, el ``ImageBase``, nos dice que dirección de memoria, será la dirección base en memoria del proceso (Solo aplicable cuando no existe [[ASRL]]), y las alineaciones de las secciones, tanto en memoria (``SectionAlignment``), como en archivo (``FileAlignment``), tanto como el tamaño del ejecutable en memoria (``SizeOfImage``), el cual debe estar alineado al valor de ``SectionAlignment``, el tamaño de todos los Headers en el archivo (``DOS Header``, [[PE]] Header, ``Section Headers``) en ``SizeOfHeaders``, el cual debe estar alineado a ``FileAlignment``. Los tamaños del Stack Inicial (``SizeOfStackCommit``), el total reservado para el Stack (``SizeOfStackReserve``), aumentando el stack, hasta llegar al tamaño máximo reservado, a medida que sea necesario. Los mismos campos existen para el Heap del Sistema Operativo, en ``SizeOfHeapCommit`` y ``SizeOfHeapReserve``, respectivamente.

Al final tendriamos la cantidad de ``Data Directories`` en el final del ``Optional Header`` (``NumberOfRvaAndSizes``), asi como cada uno de los Data Directories al final del ``Optional Header``, en el cual se encuentra el famoso [[IAT]], a través del cual se ejecutan técnicas como [[IAT]] Hooking.
```c
// 1 byte aligned, 96 bytes
struct Pe32OptionalHeader {
	// 
	// Standard fields. 
	//
	uint16_t mMagic; // 0x010b - PE32
	uint8_t  mMajorLinkerVersion;
	uint8_t  mMinorLinkerVersion;
	uint32_t mSizeOfCode;
	uint32_t mSizeOfInitializedData;
	uint32_t mSizeOfUninitializedData;
	uint32_t mAddressOfEntryPoint;
	uint32_t mBaseOfCode;
	uint32_t mBaseOfData;
	
	// 
	// NT additional fields. 
	//
	uint32_t mImageBase;
	uint32_t mSectionAlignment;
	uint32_t mFileAlignment;
	uint16_t mMajorOperatingSystemVersion;
	uint16_t mMinorOperatingSystemVersion;
	uint16_t mMajorImageVersion;
	uint16_t mMinorImageVersion;
	uint16_t mMajorSubsystemVersion;
	uint16_t mMinorSubsystemVersion;
	uint32_t mWin32VersionValue;
	uint32_t mSizeOfImage;
	uint32_t mSizeOfHeaders;
	uint32_t mCheckSum;
	uint16_t mSubsystem;
	uint16_t mDllCharacteristics;
	uint32_t mSizeOfStackReserve;
	uint32_t mSizeOfStackCommit;
	uint32_t mSizeOfHeapReserve;
	uint32_t mSizeOfHeapCommit;
	uint32_t mLoaderFlags;
	uint32_t mNumberOfRvaAndSizes;
};
// 1 byte aligned, 112 bytes
struct Pe32PlusOptionalHeader {
	uint16_t mMagic; // 0x020b - PE32+ (64 bit)
	uint8_t  mMajorLinkerVersion;
	uint8_t  mMinorLinkerVersion;
	uint32_t mSizeOfCode;
	uint32_t mSizeOfInitializedData;
	uint32_t mSizeOfUninitializedData;
	uint32_t mAddressOfEntryPoint;
	uint32_t mBaseOfCode;
	uint64_t mImageBase;
	uint32_t mSectionAlignment;
	uint32_t mFileAlignment;
	uint16_t mMajorOperatingSystemVersion;
	uint16_t mMinorOperatingSystemVersion;
	uint16_t mMajorImageVersion;
	uint16_t mMinorImageVersion;
	uint16_t mMajorSubsystemVersion;
	uint16_t mMinorSubsystemVersion;
	uint32_t mWin32VersionValue;
	uint32_t mSizeOfImage;
	uint32_t mSizeOfHeaders;
	uint32_t mCheckSum;
	uint16_t mSubsystem;
	uint16_t mDllCharacteristics;
	uint64_t mSizeOfStackReserve;
	uint64_t mSizeOfStackCommit;
	uint64_t mSizeOfHeapReserve;
	uint64_t mSizeOfHeapCommit;
	uint32_t mLoaderFlags;
	uint32_t mNumberOfRvaAndSizes;
};

typedef struct _IMAGE_OPTIONAL_HEADER64 {
  WORD                 Magic;
  BYTE                 MajorLinkerVersion;
  BYTE                 MinorLinkerVersion;
  DWORD                SizeOfCode;
  DWORD                SizeOfInitializedData;
  DWORD                SizeOfUninitializedData;
  DWORD                AddressOfEntryPoint;
  DWORD                BaseOfCode;
  ULONGLONG            ImageBase;
  DWORD                SectionAlignment;
  DWORD                FileAlignment;
  WORD                 MajorOperatingSystemVersion;
  WORD                 MinorOperatingSystemVersion;
  WORD                 MajorImageVersion;
  WORD                 MinorImageVersion;
  WORD                 MajorSubsystemVersion;
  WORD                 MinorSubsystemVersion;
  DWORD                Win32VersionValue;
  DWORD                SizeOfImage;
  DWORD                SizeOfHeaders;
  DWORD                CheckSum;
  WORD                 Subsystem;
  WORD                 DllCharacteristics;
  ULONGLONG            SizeOfStackReserve;
  ULONGLONG            SizeOfStackCommit;
  ULONGLONG            SizeOfHeapReserve;
  ULONGLONG            SizeOfHeapCommit;
  DWORD                LoaderFlags;
  DWORD                NumberOfRvaAndSizes;
  IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
} IMAGE_OPTIONAL_HEADER64, *PIMAGE_OPTIONAL_HEADER64;

typedef struct _IMAGE_OPTIONAL_HEADER {
	// 
	// Standard fields. 
	//
  WORD                 Magic;
  BYTE                 MajorLinkerVersion;
  BYTE                 MinorLinkerVersion;
  DWORD                SizeOfCode;
  DWORD                SizeOfInitializedData;
  DWORD                SizeOfUninitializedData;
  DWORD                AddressOfEntryPoint;
  DWORD                BaseOfCode;
  DWORD                BaseOfData;
  	
	// 
	// NT additional fields. 
	//
  DWORD                ImageBase;
  DWORD                SectionAlignment;
  DWORD                FileAlignment;
  WORD                 MajorOperatingSystemVersion;
  WORD                 MinorOperatingSystemVersion;
  WORD                 MajorImageVersion;
  WORD                 MinorImageVersion;
  WORD                 MajorSubsystemVersion;
  WORD                 MinorSubsystemVersion;
  DWORD                Win32VersionValue;
  DWORD                SizeOfImage;
  DWORD                SizeOfHeaders;
  DWORD                CheckSum;
  WORD                 Subsystem;
  WORD                 DllCharacteristics;
  DWORD                SizeOfStackReserve;
  DWORD                SizeOfStackCommit;
  DWORD                SizeOfHeapReserve;
  DWORD                SizeOfHeapCommit;
  DWORD                LoaderFlags;
  DWORD                NumberOfRvaAndSizes;
  IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
} IMAGE_OPTIONAL_HEADER32, *PIMAGE_OPTIONAL_HEADER32;
```


`Magic`
es un campo que identifica el estado de la imagen. La [documentación de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#optional-header-standard-fields-image-only) menciona tres valores comunes:
    - ``0x10B``: Identifica la imagen como un ejecutable [[PE]]32.
    - ``0x20B``: Identifica la imagen como un ejecutable [[PE]]32+ (aka. 64 bits)
    - ``0x107``: Identifica la imagen como ROM.

El valor de este campo es el que determina si el ejecutable es de 32 o 64 bits, el miembro ==«Machine»== de la estructura ==«IMAGE_FILE_HEADER»== es ignorado por el cargador PE de Windows, en su lugar, se utiliza esta.

| Valor                                          | Significado                                                                                                                                                                                          |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **IMAGE_NT_OPTIONAL_HDR_MAGIC**                | El archivo es una imagen ejecutable. Este valor se define como **IMAGE_NT_OPTIONAL_HDR32_MAGIC** en una aplicación de 32 bits y como **IMAGE_NT_OPTIONAL_HDR64_MAGIC** en una aplicación de 64 bits. |
| **IMAGE_NT_OPTIONAL_HDR32_MAGIC**<br><br>0x10b | El archivo es una imagen ejecutable.                                                                                                                                                                 |
| **IMAGE_NT_OPTIONAL_HDR64_MAGIC**<br><br>0x20b | El archivo es una imagen ejecutable.                                                                                                                                                                 |
| **IMAGE_ROM_OPTIONAL_HDR_MAGIC**<br><br>0x107  | El archivo es una imagen rom.                                                                                                                                                                        |
`MajorLinkerVersion`
Indican el número de versión principal y secundario del enlazador utilizado para crear el archivo ejecutable.

`MinorLinkerVersion`
Número de versión secundaria del enlazador.

`SizeOfCode`
Tamaño de la sección de código, en bytes, o la suma de todas estas secciones si hay varias secciones de código.
Almacena el tamaño total, en bytes, de todas las secciones que contienen código ejecutable (normalmente la sección ==.text==).

`SizeOfInitializedData`
Tamaño de la sección de datos inicializado, en bytes, o la suma de todas estas secciones si hay varias secciones de datos inicializadas.
Indica el tamaño total, en bytes, de todas las secciones que contienen datos inicializados (normalmente la sección ==.data==).

`SizeOfUninitializedData`
Tamaño de la sección de datos sin inicializar, en bytes, o la suma de todas estas secciones si hay varias secciones de datos sin inicializar.
Almacena el tamaño total, en bytes, de todas las secciones que contienen datos no inicializados (normalmente la sección ==.bss==).

`AddressOfEntryPoint`
Puntero a la función de punto de entrada, en relación con la dirección base de la imagen. En el caso de los archivos ejecutables, esta es la dirección inicial. En el caso de los controladores de dispositivos, esta es la dirección de la función de inicialización. La función de punto de entrada es opcional para los archivos DLL. Cuando no hay ningún punto de entrada presente, este miembro es cero.

Es una RVA (_Relative Virtual Address_) que señala el punto de entrada de la imagen cuando se carga en memoria. En aplicaciones ejecutables, este valor apunta al inicio de la función principal (por ejemplo, ==main== o ==WinMain==). En controladores de dispositivo, apunta a la función de inicialización. Para DLLs, el punto de entrada es opcional; si no existe, este campo se establece en 0.

`BaseOfCode`
Puntero al principio de la sección de código, en relación con la base de imágenes.
Es una RVA que indica la dirección de inicio de la sección de código (normalmente ==.text==) en memoria una vez cargado el archivo.

`BaseOfData`
Puntero al principio de la sección de datos, en relación con la base de imágenes.
Es una RVA que señala el inicio de la sección de datos (normalmente ==.data==) en memoria tras cargar el archivo. Este campo no existe en el formato [[PE]]32+.

`ImageBase [4-bytes/DWORD en PE32 y 8-bytes/ULONGLONG en PE32+]`
Dirección preferida del primer byte de la imagen cuando se carga en memoria. Este valor es un múltiplo de 64 000 bytes. El valor predeterminado de los archivos DLL es ``0x10000000``. El valor predeterminado de las aplicaciones es ``0x00400000``, excepto en Windows CE donde se ``0x00010000``.

Contiene la dirección base preferida para cargar el primer byte de la imagen en memoria. Este valor debe ser múltiplo de 64 KB. Sin embargo, debido a mecanismos de protección como [[ASLR]] (_Address Space Layout Randomization_) y otras razones, la imagen a menudo no se carga en esta dirección. En ese caso, el cargador PE elige un área de memoria no utilizada para cargar la imagen y luego realiza un proceso llamado reubicación. Durante la reubicación, se ajustan las direcciones internas de la imagen para que funcionen con la nueva base de carga. Existe una sección especial, llamada sección de reubicación (==.reloc==), que contiene información sobre los lugares que necesitan ser ajustados si se requiere una reubicación.

`SectionAlignment [4-bytes/DWORD]`
Alineación de secciones cargadas en memoria, en bytes. Este valor debe ser mayor o igual que el miembro **FileAlignment** . El valor predeterminado es el tamaño de página del sistema.
Especifica la alineación, en bytes, de las secciones cuando se cargan en memoria. Las secciones se alinean en límites que son múltiplos de este valor. Por defecto, suele ser el tamaño de página de la arquitectura (por ejemplo, 4 KB) y no puede ser menor que el valor de ==FileAlignment==.

`FileAlignment [4-bytes/DWORD]`
Alineación de los datos sin procesar de las secciones del archivo de imagen, en bytes. El valor debe ser una potencia de 2 entre 512 y 64K (inclusive). El valor predeterminado es 512. Si el miembro **SectionAlignment** es menor que el tamaño de página del sistema, este miembro debe ser el mismo que **SectionAlignment**.

Especifica la alineación, en bytes, de los datos de las secciones en el archivo (en disco). Si el tamaño real de los datos de una sección es menor que ==FileAlignment==, el resto se rellena con ceros para cumplir con la alineación. Este valor debe ser una potencia de 2 entre 512 y 64 KB. Si ==SectionAlignment== es menor que el tamaño de página de la arquitectura, entonces ==FileAlignment== y ==SectionAlignment== deben ser iguales

`MajorOperatingSystemVersion, MinorOperatingSystemVersion [2-bytes/WORD]`
- `MajorOperatingSystemVersion`
		El número de versión principal del sistema operativo obligatorio.

- `MinorOperatingSystemVersion`
		El número de versión secundaria del sistema operativo obligatorio.

==MajorImageVersion y MinorImageVersion== ==[2-bytes/WORD]==: Indican la versión principal y secundaria de la imagen del archivo. Estas versiones pueden ser utilizadas por herramientas o sistemas para determinar compatibilidad

- `MajorImageVersion`
		El número de versión principal de la imagen.

- `MinorImageVersion`
		El número de versión secundaria de la imagen.

==MajorSubsystemVersion y MinorSubsystemVersion== ==[2-bytes/WORD]==: Especifican la versión principal y secundaria del subsistema requerido. Con subsistema se refiere al entorno de ejecución, que puede ser una aplicación gráfica de Windows (GUI), una aplicación de consola (CUI), un entorno EFI (Entorno de Firmware Extensible), o incluso una aplicación nativa que interactúa directamente con el núcleo del sistema operativo, entre otros.
- `MajorSubsystemVersion`
		El número de versión principal del subsistema.

- `MinorSubsystemVersion`
		El número de versión secundaria del subsistema.

`Win32VersionValue [4-bytes/DWORD]`
Campo reservado que, según la documentación oficial, debe establecerse en 0.

`SizeOfHeaders [4-bytes/DWORD]`
Es el tamaño combinado, en bytes, del ==«stub DOS»==, los encabezados PE (encabezados NT) y los encabezados de sección, redondeado al múltiplo más cercano de ==«FileAlignment»==.

Tamaño combinado de los siguientes elementos, redondeado a un múltiplo del valor especificado en el miembro **FileAlignment** .
- **e_lfanew** miembro de **IMAGE_DOS_HEADER**
- Firma de 4 bytes
- tamaño de [IMAGE_FILE_HEADER](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-image_file_header)
- tamaño del encabezado opcional
- tamaño de todos los encabezados de sección

`CheckSum [4-bytes/DWORD]`
Suma de comprobación del archivo de imagen. Los archivos siguientes se validan en tiempo de carga: todos los controladores, cualquier DLL cargado en tiempo de arranque y cualquier ARCHIVO DLL cargado en un proceso crítico del sistema.

Campo utilizado para almacenar el _checksum_ de la imagen, permitiendo verificar la integridad del archivo. El _checksum_ es un valor calculado a partir del contenido del archivo que actúa como una huella digital. Si algún byte del archivo cambia (por ejemplo, debido a corrupción o manipulación), el _checksum_ resultante también cambiará, lo que permite detectar inconsistencias o daños en el archivo. Si este campo se establece en 0, el _checksum_ no se calcula ni se verifica

`Subsystem [2-bytes/WORD]`
Subsistema necesario para ejecutar esta imagen. Se definen los valores siguientes.
Especifica el subsistema requerido para ejecutar este archivo. Indica el tipo de interfaz que utiliza el programa, como si es una aplicación de consola, una aplicación GUI de Windows, un driver, etc. La lista completa de posibles valores se encuentra en la [documentación de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#windows-subsystem).

| Valor                                                  | Significado                                                                                     |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| **IMAGE_SUBSYSTEM_UNKNOWN**<br><br>0                   | Subsistema desconocido.                                                                         |
| **IMAGE_SUBSYSTEM_NATIVE**<br><br>1                    | No se requiere ningún subsistema (controladores de dispositivo y procesos nativos del sistema). |
| **IMAGE_SUBSYSTEM_WINDOWS_GUI**<br><br>2               | Subsistema de interfaz gráfica de usuario (GUI) de Windows.                                     |
| **IMAGE_SUBSYSTEM_WINDOWS_CUI**<br><br>3               | Subsistema de interfaz de usuario en modo de caracteres (CUI) de Windows.                       |
| **IMAGE_SUBSYSTEM_OS2_CUI**<br><br>5                   | Subsistema CUI del sistema operativo/2.                                                         |
| **IMAGE_SUBSYSTEM_POSIX_CUI**<br><br>7                 | Subsistema POSIX CUI.                                                                           |
| **IMAGE_SUBSYSTEM_WINDOWS_CE_GUI**<br><br>9            | Windows CE sistema.                                                                             |
| **IMAGE_SUBSYSTEM_EFI_APPLICATION**<br><br>10          | Aplicación Extensible Firmware Interface (EFI).                                                 |
| **IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER**<br><br>11  | Controlador EFI con servicios de arranque.                                                      |
| **IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER**<br><br>12       | Controlador EFI con servicios en tiempo de ejecución.                                           |
| **IMAGE_SUBSYSTEM_EFI_ROM**<br><br>13                  | Imagen de EFI ROM.                                                                              |
| **IMAGE_SUBSYSTEM_XBOX**<br><br>14                     | Sistema Xbox.                                                                                   |
| **IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION**<br><br>16 | Aplicación de arranque.                                                                         |


`DLLCharacteristics [2-bytes/WORD]`
Define diversas características del archivo de imagen, tales como soporte para NX (_No eXecute_) o si la imagen puede ser reubicada en tiempo de ejecución. Aunque se llama «==DLLCharacteristics»== por razones históricas, también se aplica a archivos ejecutables normales (EXE). La lista completa de _flags_ disponibles se puede consultar en la [documentación de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#dll-characteristics).
Se definen los valores siguientes.

|Valor|Significado|
|---|---|
|0x0001|Reservado.|
|0x0002|Reservado.|
|0x0004|Reservado.|
|0x0008|Reservado.|
|**IMAGE_DLL_CHARACTERISTICS_HIGH_ENTROPY_VA**<br><br>0x0020|ASLR con espacio de direcciones de 64 bits.|
|**IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE**<br><br>0x0040|El archivo DLL se puede reubicar en tiempo de carga.|
|**IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY**<br><br>0x0080|Se fuerzan las comprobaciones de integridad del código. Si establece esta marca y una sección solo contiene datos sin inicializar, establezca el miembro **PointerToRawData** de [IMAGE_SECTION_HEADER](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-image_section_header) para esa sección en cero; de lo contrario, la imagen no se cargará porque no se puede comprobar la firma digital.|
|**IMAGE_DLLCHARACTERISTICS_NX_COMPAT**<br><br>0x0100|La imagen es compatible con la prevención de ejecución de datos (DEP).|
|**IMAGE_DLLCHARACTERISTICS_NO_ISOLATION**<br><br>0x0200|La imagen es consciente del aislamiento, pero no debe aislarse.|
|**IMAGE_DLLCHARACTERISTICS_NO_SEH**<br><br>0x0400|La imagen no usa el control estructurado de excepciones (SEH). No se puede llamar a ningún controlador en esta imagen.|
|**IMAGE_DLLCHARACTERISTICS_NO_BIND**<br><br>0x0800|No enlaza la imagen.|
|**IMAGE_DLL_CHARACTERISTICS_APPCONTAINER**<br><br>0x1000|La imagen debe ejecutarse en un AppContainer.|
|**IMAGE_DLLCHARACTERISTICS_WDM_DRIVER**<br><br>0x2000|Un controlador WDM.|
|**IMAGE_DLL_CHARACTERISTICS_GUARD_CF**<br><br>0x4000|La imagen admite Protección de flujo de control.|
|**IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE**<br><br>0x8000|La imagen es compatible con terminal Server.|


`SizeOfStackReserve [8-bytes/ULONGLONG]`
Número de bytes que se van a reservar para la pila. Solo se confirma la memoria especificada por el miembro **SizeOfStackCommit** en tiempo de carga; el resto está disponible una página a la vez hasta que se alcance este tamaño de reserva.

Especifica el tamaño total de memoria que se reserva para la pila (_stack_) del hilo principal.

`SizeOfStackCommit [8-bytes/ULONGLONG]`
Número de bytes que se van a confirmar para la pila.
Indica el tamaño inicial de memoria de la pila que se compromete (_commit_).

`SizeOfHeapReserve [8-bytes/ULONGLONG]`
Número de bytes que se van a reservar para el montón local. Solo se confirma la memoria especificada por el miembro **SizeOfHeapCommit** en tiempo de carga; el resto está disponible una página a la vez hasta que se alcance este tamaño de reserva.

Especifica el tamaño total de memoria que se reserva para el heap local del proceso.

`SizeOfHeapCommit [8-bytes/ULONGLONG]`
Número de bytes que se van a confirmar para el montón local.
Indica el tamaño inicial de memoria del heap que se compromete (commit).

**Nota**_:_ Los valores «_reserve_» indican cuánta memoria virtual se reserva, mientras que los valores «_commit_» indican cuánta memoria física se asigna inicialmente. La memoria reservada puede ser comprometida posteriormente según sea necesario.

`LoaderFlags [4-bytes/DWORD]`
Este miembro está obsoleto.
Campo reservado que debe establecerse en 0 según la [documentación oficial de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#optional-header-windows-specific-fields-image-only).

`NumberOfRvaAndSizes [4-bytes/DWORD]`
Número de entradas de directorio en el resto del encabezado opcional. Cada entrada describe una ubicación y un tamaño.
Indica el número de entradas en el array ==«DataDirectory»==. Especifica cuántas estructuras ==«IMAGE_DATA_DIRECTORY»== siguen a continuación.

`DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES]`
Puntero a la primera estructura [IMAGE_DATA_DIRECTORY](https://learn.microsoft.com/es-es/windows/desktop/api/winnt/ns-winnt-image_data_directory) del directorio de datos.
Es un array de estructuras ==«IMAGE_DATA_DIRECTORY»==, donde cada entrada proporciona la dirección y el tamaño de una tabla o información específica, como la tabla de importaciones, exportaciones, recursos, etc. El número de entradas está definido por ==«NumberOfRvaAndSizes»==.

Este parámetro puede ser uno de los valores siguientes.

| Valor                                              | Significado                                       |
| -------------------------------------------------- | ------------------------------------------------- |
| **IMAGE_DIRECTORY_ENTRY_ARCHITECTURE**<br><br>7    | Datos específicos de la arquitectura              |
| **IMAGE_DIRECTORY_ENTRY_BASERELOC**<br><br>5       | Tabla de reubicación base                         |
| **IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT**<br><br>11   | Directorio de importación enlazado                |
| **IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR**<br><br>14 | Tabla de descriptores COM                         |
| **IMAGE_DIRECTORY_ENTRY_DEBUG**<br><br>6           | Directorio de depuración                          |
| **IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT**<br><br>13   | Retrasar la tabla de importación                  |
| **IMAGE_DIRECTORY_ENTRY_EXCEPTION**<br><br>3       | Directorio de excepciones                         |
| **IMAGE_DIRECTORY_ENTRY_EXPORT**<br><br>0          | Exportar directorio                               |
| **IMAGE_DIRECTORY_ENTRY_GLOBALPTR**<br><br>8       | Dirección virtual relativa del puntero global     |
| **IMAGE_DIRECTORY_ENTRY_IAT**<br><br>12            | Importar tabla de direcciones                     |
| **IMAGE_DIRECTORY_ENTRY_IMPORT**<br><br>1          | Importar directorio                               |
| **IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG**<br><br>10    | Cargar directorio de configuración                |
| **IMAGE_DIRECTORY_ENTRY_RESOURCE**<br><br>2        | Directorio del recurso                            |
| **IMAGE_DIRECTORY_ENTRY_SECURITY**<br><br>4        | Directorio de seguridad                           |
| **IMAGE_DIRECTORY_ENTRY_TLS**<br><br>9             | Directorio de almacenamiento local de subprocesos |

El número de directorios no es fijo. Compruebe el miembro **NumberOfRvaAndSizes** antes de buscar un directorio específico.

La estructura real de WinNT.h se denomina **IMAGE_OPTIONAL_HEADER32** y **IMAGE_OPTIONAL_HEADER** se define como **IMAGE_OPTIONAL_HEADER32**. Sin embargo, si **se define _WIN64** , **IMAGE_OPTIONAL_HEADER** se define como **IMAGE_OPTIONAL_HEADER64**.

La estructura del [[PE]] Header, es ``_IMAGE_NT_HEADERS`` para 32 bits e ``_IMAGE_NT_HEADERS64`` para 64 bits, conteniendo la siguiente estructura (ref. ``winnt.h``). La diferencia de ambas estructuras radica en el ``OptionalHeader``, de ambas

El encabezado opcional [[PE]]32+ es similar pero ligeramente diferente: no hay mBaseOfData ni mImageBase y mSizeOf{Stack,Heap}{Reserve,Commit} es 64 en lugar de 32 bits.


| Position (PE/PE32+) | Section                                                                                                                                                                                    |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 96/112              | La dirección y el tamaño de la tabla de exportación. El mismo formato que .edata                                                                                                           |
| 104/120             | La dirección y el tamaño de la tabla de importación. El mismo formato que .idata                                                                                                           |
| 112/128             | La dirección y el tamaño de la tabla de recursos. El mismo formato que .rsc                                                                                                                |
| 120/136             | La dirección y el tamaño de la tabla de excepciones. El mismo formato que .pdata                                                                                                           |
| 128/144             | El desplazamiento y el tamaño de la tabla de certificados de atributos (no RVA). Consulte [Signed PE](https://wiki.osdev.org/PE#Signed_PE_with_Attribute_Certificate_Table) a continuación |
| 136/152             | La dirección y el tamaño de la tabla de reubicación base. El mismo formato que .reloc                                                                                                      |
| 144/160             | La dirección y el tamaño de inicio de los datos de depuración. El mismo formato que .debug                                                                                                 |
| 152/168             | Arquitectura, reservada MBZ                                                                                                                                                                |
| 160/176             | Global Ptr, el RVA del valor que se almacenará en el registro de puntero global. El miembro de tamaño de esta estructura debe establecerse en cero                                         |
| 168/184             | La dirección y el tamaño de la tabla de almacenamiento local ([[TLS]]) de subprocesos. El mismo formato que .tls                                                                           |

### Data Directories (IMAGE_DATA_DIRECTORY)

Como hemos dicho antes, el último miembro de la estructura ==«IMAGE_OPTIONAL_HEADER»== es un array de estructuras ==«IMAGE_DATA_DIRECTORY»==.

```c
IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
```
==«IMAGE_NUMBEROF_DIRECTORY_ENTRIES»== es una constante definida con el valor 16, lo que significa que el archivo [[PE]] estándar puede tener hasta 16 entradas ==«IMAGE_DATA_DIRECTORY»==.

```c
#define IMAGE_NUMBEROF_DIRECTORY_ENTRIES    16
```

La estructura ==«IMAGE_DATA_DIRECTORY»== es la siguiente
```c
typedef struct _IMAGE_DATA_DIRECTORY {
    DWORD   VirtualAddress;
    DWORD   Size;
} IMAGE_DATA_DIRECTORY, *PIMAGE_DATA_DIRECTORY;
```
En comparación con otras estructuras del archivo [[PE]], ==«IMAGE_DATA_DIRECTORY»== es bastante sencilla, ya que solo tiene dos miembros: ==«VirtualAddress»==, que contiene el RVA que apunta al inicio de la entrada que corresponda, y ==«Size»==, que define el tamaño de esa entrada.

Entonces, el miembro ==«Data Directories»== de ==«IMAGE_OPTIONAL_HEADER»== no es mas que una tabla que contiene las direcciones y tamaños a otras partes importantes del ejecutable que son útiles para el cargador del sistema operativo. Por ejemplo, un directorio importante es el ==«Import Directory»==, ya que contiene una lista de funciones externas importadas de otras librerías.

No todos los directorios tienen la misma estructura, el ==«IMAGE_DATA_DIRECTORY.VirtualAddress»== apunta al directorio que sea, pero el tipo de directorio es lo que determina como el bloque (_chunk_) de datos va a ser interpretado.

En la librería de _[[winnt.h]]_ podemos encontrar una serie de ==«Data Directories»== definidos:
```c
// Directory Entries

#define IMAGE_DIRECTORY_ENTRY_EXPORT          0   // Export Directory
#define IMAGE_DIRECTORY_ENTRY_IMPORT          1   // Import Directory
#define IMAGE_DIRECTORY_ENTRY_RESOURCE        2   // Resource Directory
#define IMAGE_DIRECTORY_ENTRY_EXCEPTION       3   // Exception Directory
#define IMAGE_DIRECTORY_ENTRY_SECURITY        4   // Security Directory
#define IMAGE_DIRECTORY_ENTRY_BASERELOC       5   // Base Relocation Table
#define IMAGE_DIRECTORY_ENTRY_DEBUG           6   // Debug Directory
//      IMAGE_DIRECTORY_ENTRY_COPYRIGHT       7   // (X86 usage)
#define IMAGE_DIRECTORY_ENTRY_ARCHITECTURE    7   // Architecture Specific Data
#define IMAGE_DIRECTORY_ENTRY_GLOBALPTR       8   // RVA of GP
#define IMAGE_DIRECTORY_ENTRY_TLS             9   // TLS Directory
#define IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG    10   // Load Configuration Directory
#define IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT   11   // Bound Import Directory in headers
#define IMAGE_DIRECTORY_ENTRY_IAT            12   // Import Address Table
#define IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT   13   // Delay Load Import Descriptors
#define IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR 14   // COM Runtime descriptor
```

![[Pasted image 20250301194539.png]]

Cuando una entrada tiene ambos valores (==«Address»== y ==«Size»==) en cero significa que ese directorio de datos específico no se usa (no existe). A continuación, antes de seguir vamos a mencionar mínimamente el directorio de exportación y la tabla de importación de direcciones, que son dos entradas importantes del ==«Data Directories»==.

###### Export Directory

El directorio de exportación de un archivo de imagen es una estructura de datos que contiene información sobre las funciones y variables que son exportadas desde el ejecutable.

```c
typedef struct _IMAGE_EXPORT_DIRECTORY {
    ULONG   Characteristics;
    ULONG   TimeDateStamp;
    USHORT  MajorVersion;
    USHORT  MinorVersion;
    ULONG   Name;
    ULONG   Base;
    ULONG   NumberOfFunctions;
    ULONG   NumberOfNames;
    PULONG  *AddressOfFunctions;
    PULONG  *AddressOfNames;
    PUSHORT *AddressOfNameOrdinals;
} IMAGE_EXPORT_DIRECTORY, *PIMAGE_EXPORT_DIRECTORY;
```

Contiene las direcciones de las funciones y variables exportadas, que pueden ser utilizadas por otros archivos ejecutables para acceder a dichas funciones y datos. El directorio de exportación se encuentra generalmente en DLLs que exportan funciones (por ejemplo, _kernel32.dll_ exportando _CreateFileA_).

###### Import Address Table (IAT)
La tabla de direcciones de importación es una estructura de datos en un archivo de imagen que contiene información sobre las direcciones de las funciones importadas de otros archivos ejecutables. Estas direcciones se utilizan para acceder a las funciones y datos en otros ejecutables (por ejemplo, _Programita.exe_ importando _CreateFileA_ de _kernel32.dll_).

```c
typedef struct _IMAGE_IMPORT_DESCRIPTOR {
    union {
        DWORD   Characteristics;
        DWORD   OriginalFirstThunk;
    } DUMMYUNIONNAME__;
    DWORD   TimeDateStamp;
    DWORD   ForwarderChain;
    DWORD   Name;
    DWORD   FirstThunk;
} __IMAGE_IMPORT_DESCRIPTOR, * __PIMAGE_IMPORT_DESCRIPTOR;
```

---- 

## Secciones
Un archivo [[PE]] está formado por secciones que consisten en un nombre, desplazamiento dentro del archivo, dirección virtual a la que copiar, así como el tamaño de la sección en el archivo y en la memoria virtual (que puede diferir, en cuyo caso la diferencia debe ser ceros) y los indicadores asociados. Las secciones suelen seguir una nomenclatura universal ("``.text``", "``.rsrc``", etc.), pero esto también puede variar entre enlazadores y en algunos casos puede ser definido por el usuario, por lo que es mejor depender de los indicadores para saber si una sección es ejecutable o escribible. Sin embargo, dicho esto, si tiene datos personalizados que desea incrustar dentro del ejecutable, colocarlos dentro de una sección e identificarlos por el nombre de la sección puede ser una buena idea, ya que no cambiará el formato [[PE]] y su ejecutable seguirá siendo compatible con las herramientas [[PE]].

La ``base virtual relativa`` (``RVA``) es una frase que aparece mucho en la documentación [[PE]]. La ``RVA`` es la dirección en la que existe algo una vez que se carga en la memoria, en lugar de un desplazamiento dentro del archivo. Para calcular la dirección del archivo desde un ``RVA`` sin cargar realmente las secciones en la memoria, puede utilizar la tabla de entradas de sección. Al utilizar la dirección virtual y el tamaño de cada sección, puede encontrar a qué sección pertenece el ``RVA`` y luego restar la diferencia entre la dirección virtual de la sección y el desplazamiento del archivo.

Después del encabezado opcional podemos encontrar lo encabezados de secciones. Estos encabezados contienen información sobre las secciones del archivo PE. Un encabezado de sección es una estructura llamada ==«IMAGE_SECTION_HEADER»== definida en _[[winnt.h]]_:
```c
struct IMAGE_SECTION_HEADER { // size 40 bytes
	char[8]  mName;
	union {
		uint32_t mPhysicalAddress;
		uint32_t mVirtualSize;
	} Misc;
	uint32_t mVirtualAddress;
	uint32_t mSizeOfRawData;
	uint32_t mPointerToRawData;
	uint32_t mPointerToRelocations;
	uint32_t mPointerToLinenumbers;
	uint16_t mNumberOfRelocations;
	uint16_t mNumberOfLinenumbers;
	uint32_t mCharacteristics;
};
```

- ==Name [1-byte/BYTE]==: el primer campo del encabezado de sección es un array del tamaño de ==«IMAGE_SIZEOF_SHORT_NAME»==:

```c
#define IMAGE_SIZEOF_SHORT_NAME 		8
```

Al tener un valor por defecto de 8, significa que el nombre de la sección no puede ser mayor a 8 caracteres. Para los ejecutables se mantiene este valor; para otros tipos de archivos hay algunas opciones para poder establecer nombres más largos.

- ==PhysicalAddress o VirtualSize== ==[4-bytes/DWORD]==: Este campo es una unión y puede denominarse ==«PhysicalAddress»== o ==«VirtualSize»==. En archivos objeto, se llama ==«PhysicalAddress»== y contiene el tamaño total de la sección. En imágenes ejecutables, se llama ==«VirtualSize»== y contiene el tamaño total de la sección cuando se carga en memoria.
- ==VirtualAddress [4-bytes/DWORD]==: Contiene la dirección virtual relativa (RVA) del primer byte de la sección respecto a la base de la imagen cuando se carga en memoria. Para archivos objeto, contiene la dirección del primer byte de la sección antes de que se apliquen las reubicaciones.
- ==SizeOfRawData [4-bytes/DWORD]==: Este campo contiene el tamaño de la sección en disco; debe ser múltiplo de ==«IMAGE_OPTIONAL_HEADER.FileAlignment»==.
- ==PointerToRawData [4-bytes/DWORD]==: Un puntero al inicio de la sección dentro del archivo; para imágenes ejecutables, debe ser un múltiplo de ==«IMAGE_OPTIONAL_HEADER.FileAlignment»==.
- ==PointerToRelocations== ==[4-bytes/DWORD]==: Un puntero de archivo al comienzo de las entradas de reubicación de la sección. Se establece en 0 para archivos ejecutables.
- ==PointerToLineNumbers [4-bytes/DWORD]==: Un puntero de archivo al inicio de las entradas de número de línea [[COFF]] para la sección. Se establece en 0 porque la información de depuración [[COFF]] está obsoleta.
- ==NumberOfRelocations [2-bytes/WORD]==: El número de entradas de reubicación para la sección; se establece en 0 para imágenes ejecutables.
- ==NumberOfLinenumbers [2-bytes/WORD]==: El número de entradas de número de línea [[COFF]] para la sección; se establece en 0 porque la información de depuración [[COFF]] está obsoleta.
- ==Characteristics [4-bytes/DWORD]==: Contiene _flags_ que describen las características de la sección. Estas _flags_ indican si la sección contiene código ejecutable, datos inicializados o no inicializados, si puede compartirse en memoria, entre otros. Una lista completa de estas _flags_ se puede encontrar en la [documentación oficial de Microsoft](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#section-flags).

De todos estos miembros mencionados, un detalle importante es que el valor de ==«SizeOfRawData»== y ==«VirtualSize»== pueden ser distintos. ¿A qué me refiero y por qué pasa esto?

==«SizeOfRawData»== debe ser un múltiplo de ==«IMAGE_OPTIONAL_HEADER.FileAlignment»== (``0x200`` en hexadecimal, 512 en decimal). Por lo tanto, si el tamaño real de la sección en disco es menor que ==«FileAlignment»== o no es un múltiplo de este valor, ==«SizeOfRawData»== se redondeará al siguiente múltiplo más cercano. Por ejemplo, si el tamaño de una sección en disco es de 600 bytes, se redondeará al siguiente múltiplo de 512 (``0x200``), que es 1024 bytes (``0x400``).

Por otro lado, ==«VirtualSize»== representa el tamaño real de la sección en memoria. A diferencia de ==«SizeOfRawData»==, ==«VirtualSize»== no necesita ser un múltiplo de ningún valor de alineación. Sin embargo, la dirección virtual donde comienza la sección (==«VirtualAddress»==) debe estar alineada según ==«IMAGE_OPTIONAL_HEADER.SectionAlignment»== (``0x1000`` en hexadecimal, 4096 en decimal).

Debido a estas diferencias, puede ocurrir que el tamaño de la sección en disco sea mayor que el tamaño de la sección en memoria. Esto sucede porque ==«SizeOfRawData»== se alinea al siguiente múltiplo de ==«FileAlignment»==, lo que puede introducir espacio no utilizado en el archivo.

Por el contrario, también puede suceder que ==«VirtualSize»== sea mayor que ==«SizeOfRawData»==. Esto ocurre si la sección contiene datos no inicializados, como variables globales o estáticas sin valor asignado, comúnmente ubicadas en la sección ==.bss==. Estos datos no inicializados no ocupan espacio en disco porque no hay información real que almacenar, ==«SizeOfRawData»== no incluye su tamaño. Sin embargo, cuando el ejecutable se carga en memoria, el sistema operativo reserva espacio para estos datos, inicializándolos generalmente a cero. De esta manera, la sección se expande en memoria para incluir el espacio necesario para los datos no inicializados, y ==«VirtualSize»== refleja este tamaño mayor.

En resumen, ==«SizeOfRawData»== puede ser mayor que ==«VirtualSize»== debido al alineamiento en disco que agrega espacio no utilizado. Por otro lado, ==«VirtualSize»== puede ser mayor que ==«SizeOfRawData»== cuando la sección incluye datos no inicializados que requieren espacio en memoria pero no ocupan espacio en disco.

Pues con todo esto, los encabezados de sección de nuestro ejecutable en PE-Bear se ven así:
![[Pasted image 20250301195108.png]]

En la imagen podemos observar las siguientes columnas (entre otras):

- ==«Raw. Addr.»== –> ==«IMAGE_SECTION_HEADER.PointerToRawData»==
- ==«Raw Size»== –> ==«IMAGE_SECTION_HEADER.SizeOfRawData»==
- ==«Virtual Addr.»== –> ==«IMAGE_SECTION_HEADER.VirtualAddress»==
- ==«Virtual Size»== –> ==«IMAGE_SECTION_HEADER.VirtualSize»==

Cada par de campos (_Raw_ y _Virtual_) sirven para calcular dónde termina una sección, tanto en disco como en memoria, qué es justamente de lo que hemos estado hablando antes.

Por ejemplo, la sección ==.text== en disco tiene una dirección ``0x400`` y un tamaño de ``0x1200``. Sumando ambos, obtenemos ``0x1600``, que marca el límite final de la sección ==.text== y el inicio de la siguiente. Este valor indica el primer byte inmediatamente después de la sección ==.text== en el archivo en disco.

En memoria, podemos hacer un cálculo similar. La sección ==.text== tiene una dirección virtual (==«VirtualAddress»==) de ``0x1000`` y un tamaño virtual (==«VirtualSize»==) de ``0x10C9``. Aunque el tamaño real de la sección es de 4297 bytes (``0x10C9`` en hexadecimal), las secciones deben comenzar en direcciones que sean múltiplos de ==«IMAGE_OPTIONAL_HEADER.SectionAlignment»== (``0x1000`` en hexadecimal, 4096 en decimal). Esto significa que la sección ==.text== comienza en ``0x1000``.

Debido a que el ==«VirtualSize»== de la sección ==.text== (4297 bytes) excede el tamaño de ==«SectionAlignment»== (4096 bytes), la sección ocupa más de un intervalo de alineación. Al sumar la dirección virtual inicial y el tamaño virtual (``0x1000`` + ``0x10C9``), obtenemos ``0x20C9``, que es donde termina la sección ==.text== en memoria. Sin embargo, las secciones deben comenzar en direcciones que sean múltiplos de ==«SectionAlignment»==, por lo que la siguiente sección comienza en la siguiente dirección alineada después de ``0x20C9``. El siguiente múltiplo de ``0x1000`` después de ``0x20C9`` es ``0x3000``.

Por lo tanto, aunque el ==«VirtualSize»== de la sección ==.text== no es un múltiplo de ==«SectionAlignment»==, el sistema operativo reserva espacio en memoria desde 0x1000 hasta 0x3000 para la sección ==.text==, extendiendo su límite final hasta 0x3000, que es el comienzo de la siguiente sección en memoria, la sección ==.rdata==. Por lo que existe un espacio no utilizado entre el final real de los datos de la sección ==.text== y el inicio de la siguiente sección.

Para acabar, el campo ==«Characteristics»== indica que algunas secciones son de solo lectura, otras permiten lectura y escritura, y algunas son ejecutables. Por otro lado, los campos ==«Ptr to Reloc.»==, ==«Num. of Reloc.»== y ==«Num. of Linenum.»== se encuentran en cero, lo cual es normal al tratarse de un archivo de imagen.
## Código independiente de la posición
Si cada sección especifica en qué dirección virtual cargarla, es posible que se pregunte cómo pueden existir varias ``DLL`` en un espacio de dirección virtual sin que haya conflictos. Es cierto que la mayoría del código que encontrará en un archivo [[PE]] (``DLL`` o de otro tipo) depende de la posición y está vinculado a una dirección específica. Sin embargo, para resolver este problema, existe una estructura llamada Tabla de reubicación que se adjunta a cada entrada de sección. La tabla es básicamente una lista ENORME y larga de todas las direcciones almacenadas en esa sección para que pueda desplazarla a la ubicación donde cargó la sección.

Como las direcciones pueden apuntar a través de los límites de la sección, las reubicaciones se deben realizar después de que cada sección se cargue en la memoria. Luego, repita en cada sección, itere a través de cada dirección en la Tabla de reubicación, descubra en qué sección existe ese ``RVA`` y agregue o reste el desplazamiento entre la dirección virtual vinculada de esa sección y la dirección virtual de la sección en la que lo cargó.

## [[PE]] firmado con tabla de certificado de atributo
Muchos ejecutables [[PE]] (especialmente todas las actualizaciones de Microsoft) están firmados con un certificado. Esta información se almacena en la tabla de certificado de atributo, indicada por la quinta entrada del directorio de datos. Es importante que para la tabla de certificado de atributo no se almacene ningún ``RVA``, sino un desplazamiento de archivo simple. El formato son firmas concatenadas, cada una con la siguiente estructura:

| Offset | Size | Field            | Description                                                                                            |
| ------ | ---- | ---------------- | ------------------------------------------------------------------------------------------------------ |
| 0      | 4    | dwLength         | Especifica la longitud de la entrada del certificado de atributo.                                      |
| 4      | 2    | wRevision        | Contiene el número de versión del certificado, magic ``0x0200`` (``WIN_CERT_REVISION_2_0``).           |
| 6      | 2    | wCertificateType | Especifica el tipo de contenido en ``bCertificate``, magic 0x0002.(``WIN_CERT_TYPE_PKCS_SIGNED_DATA``) |
| 8      | x    | bCertificate     | Contiene una estructura ``PKCS#7``                                                                     |

Para el arranque seguro([Secure Boot](https://wiki.osdev.org/EFI#Secure_Boot)) con [EFI](https://wiki.osdev.org/EFI "EFI"), esta firma es obligatoria. Cabe destacar que el formato PE permite incorporar varios certificados en un único archivo PE, pero las implementaciones de firmware UEFI normalmente solo permiten uno, que debe estar firmado por Microsoft KEK. Si el firmware permite instalar más KEK (no es lo habitual), también puede utilizar otros certificados.

Los datos de ``bCertificate`` son una firma ``PKCS#7`` con certificado, codificada en formato ``ASN.1. Microsoft`` utiliza ``signtool.exe`` para crear estas entradas de firma, pero existe una solución de código abierto, llamada [sbsigntool](git://kernel.ubuntu.com/jk/sbsigntool.git) (también disponible en github con empaquetado debian).

----

## Cargar un archivo [[PE]]
Cargar un archivo PE es bastante sencillo:
1. Extraer del encabezado el punto de entrada y los tamaños de pila y montón.
2. Recorrer cada sección y copiarla del archivo a la memoria virtual (aunque no es obligatorio, es bueno borrar la diferencia entre el tamaño de la sección en la memoria y en el archivo a 0).
3. Encontrar la dirección del punto de entrada buscando la entrada correcta en la tabla de símbolos.
4. Crear un nuevo hilo en esa dirección y comenzar a ejecutar.

Para cargar un archivo [[PE]] que requiere una ``DLL`` dinámica, puede hacer lo mismo, pero verifique la Tabla de importación (a la que se hace referencia mediante el directorio de datos) para encontrar qué símbolos y archivos [[PE]] se requieren, la Tabla de exportación (a la que también se hace referencia mediante el directorio de datos) dentro de ese archivo [[PE]] para ver dónde están esos símbolos y hacer que coincidan una vez que haya cargado las secciones de ese [[PE]] en la memoria (¡y las haya reubicado!). Y, por último, tenga en cuenta que también deberá resolver de forma recursiva las Tablas de importación de cada ``DLL``, y algunas ``DLL`` pueden usar trucos para hacer referencia a un símbolo en la ``DLL`` que lo carga, así que asegúrese de no dejar que su cargador se quede atascado en un bucle. Registrar los símbolos cargados y hacerlos globales puede ser una buena solución.

También puede ser una buena idea verificar la validez de los campos Machine y Magic, no solo la firma [[PE]]. De esta manera, su cargador no intentará cargar un binario de 64 bits en modo de 32 bits (esto seguramente causaría una excepción).

##  [[PE]] de 64 bits
Los [[PE]] de 64 bits son extremadamente similares a los [[PE]] normales, pero el tipo de máquina, si es ``AMD64``, es ``0x8664``, no ``0x14c``. Este campo está directamente después de la firma del [[PE]]. El número mágico también cambia de ``0x10b`` a ``0x20b``. El campo mágico está al principio del encabezado opcional. Además, el miembro ``BaseOfData`` del encabezado opcional no existe. Esto se debe a que el miembro ``ImageBase`` se expande a 64 bits. El ``BaseOfData`` se elimina para dejarle lugar.

## NT Headers (IMAGE_NT_HEADERS)

Los encabezados NT son una estructura definida en la librería _[[winnt.h]]_ como ==«IMAGE_NT_HEADERS»==:
- Para sistemas de 32 Bits:
```c
typedef struct _IMAGE_NT_HEADERS {
  DWORD                   Signature;
  IMAGE_FILE_HEADER       FileHeader;
  IMAGE_OPTIONAL_HEADER32 OptionalHeader;
} IMAGE_NT_HEADERS32, *PIMAGE_NT_HEADERS32;
```

- Para sistemas de 64 Bits:
```c
typedef struct _IMAGE_NT_HEADERS64 {
  DWORD                   Signature;
  IMAGE_FILE_HEADER       FileHeader;
  IMAGE_OPTIONAL_HEADER64 OptionalHeader;
} IMAGE_NT_HEADERS32, *PIMAGE_NT_HEADERS32;
```

Si observamos su definición, podemos encontrar tres miembros:

- ==Signature [4-bytes/DWORD]==
- ==FileHeader [IMAGE_FILE_HEADER/Structure]==
- ==OptionalHeader [IMAGE_OPTIONAL_HEADER/Structure]==

Además, la estructura está definida en dos versiones distintas, una para ejecutables de 32 bits (también referidos como ejecutables PE32) y otra para 64 bits (referidos como PE32+). Aunque si nos fijamos, esta diferencia solo se ve reflejada en el miembro ==«OptionalHeader»==.

----
### Estructura para las secciones
La tabla de secciones se encuentra justo detrás de la cabecera PE. Esta es una tabla que contiene varias estructuras **IMAGE_SECTION_HEADER**. Estas estructuras contienen información sobre las secciones de los binarios para ser cargados en la memoria.

El campo **NumberOfSections** de la estructura **IMAGE_FILE_HEADER** indica cuantas entradas hay en la tabla. **El máximo soportado por Windows es de 96 secciones**.

Un prototipo de una tabla de secciones se ve de la siguiente manera:

| Nombre  | Descripción                                            |
| ------- | ------------------------------------------------------ |
| .text   | El código (instrucciones) del programa                 |
| .bss    | Las variables no inicializadas                         |
| .reloc  | La tabla de relocalizaciones                           |
| .data   | Las variables inicializadas                            |
| .rsrc   | Los recursos del archivo (cursores, sonidos, menús...) |
| .rdata  | Los datos de solo lectura                              |
| .idata  | La tabla de importación                                |
| .upx    | Firma de una compresión UPX, propio de software UPX    |
| .aspack | Firma de un paquete ASPACK, propio de software ASPACK  |
| .adata  | Firma de un paquete ASPACK, propio de software ASPACK  |
```c
#ifndef IMAGE_SIZEOF_SHORT_NAME
#define IMAGE_SIZEOF_SHORT_NAME 8
#endif
typedef struct IMAGE_SECTION_HEADER { // size 40 bytes
	char mName[IMAGE_SIZEOF_SHORT_NAME];
	union {
	    DWORD mPhysicalAddress;
		DWORD VirtualSize;
	} Misc;
	uint32_t mVirtualAddress;
	uint32_t mSizeOfRawData;
	uint32_t mPointerToRawData;
	uint32_t mPointerToRelocations;
	uint32_t mPointerToLinenumbers;
	uint16_t mNumberOfRelocations;
	uint16_t mNumberOfLinenumbers;
	uint32_t mCharacteristics;
} IMAGE_SECTION_HEADER, *PIMAGE_SECTION_HEADER;
```

### Tabla IMPORT
Una sección a mencionar es la tabla de importación de direcciones (en inglés _import address table_ o [[IAT]]), que se usa como una tabla de búsqueda cuando la aplicación llama una función en un módulo diferente. Esto puede darse en forma de importación por ordinal o importación por nombre. Debido a que un programa compilado no puede conocer la ubicación en memoria de las bibliotecas de las que depende directamente, cada vez que se hace una llamada a la API es necesario un salto indirecto. Como el enlazador dinámico carga los módulos y los une, este escribe la dirección actuales en las ranuras [[IAT]], de manera que apuntan a las ubicaciones de memoria correspondientes de la biblioteca de funciones. Aunque esto agrega un salto adicional en el costo de una llamada intra-módulo que resulta en una reducción del rendimiento, ofrece una ventaja clave: se reduce al mínimo el número de páginas de memoria que necesitan ser cambiados [copy-on-write](https://es.wikipedia.org/wiki/Copy-on-write "Copy-on-write") por el cargador, ahorrando memoria y tiempo de I/O de disco. Si el compilador conoce de antemano que será una llamada inter-módulo (mediante el atributo dllimport) puede producir código más optimizado que simplemente se traduce en una llamada indirecta [opcode](https://es.wikipedia.org/wiki/Opcode "Opcode").

La tabla de directorio de importación es un directorio de datos ubicado al principio de la sección ``.idata``.

Consiste en una matriz de estructuras ``IMAGE_IMPORT_DESCRIPTOR``, cada una de ellas para una DLL.
No tiene un tamaño fijo, por lo que el último ``IMAGE_IMPORT_DESCRIPTOR`` de la matriz se pone a cero (se rellena con ``NULL``) para indicar el final de la tabla de directorio de importación.

``IMAGE_IMPORT_DESCRIPTOR`` se define de la siguiente manera:
```c
typedef struct _IMAGE_IMPORT_DESCRIPTOR {
    union {
        DWORD   Characteristics;
        DWORD   OriginalFirstThunk;
    } DUMMYUNIONNAME__;
    DWORD   TimeDateStamp;
    DWORD   ForwarderChain;
    DWORD   Name;
    DWORD   FirstThunk;
} IMAGE_IMPORT_DESCRIPTOR UNALIGNED, *PIMAGE_IMPORT_DESCRIPTOR;
```

- **`OriginalFirstThunk`:** RVA del ILT.
- **`TimeDateStamp`:** Una marca de fecha y hora, que inicialmente se establece en `0` si no está enlazada y se establece en `-1` si está enlazada.
En el caso de una importación no enlazada, la marca de fecha y hora se actualiza a la marca de fecha y hora de la DLL después de enlazar la imagen.
En el caso de una importación enlazada, permanece establecida en `-1` y la marca de fecha y hora real de la DLL se puede encontrar en la Tabla de directorio de importación enlazada en el `IMAGE_BOUND_IMPORT_DESCRIPTOR`  correspondiente.
Hablaremos de las importaciones enlazadas en la siguiente sección.
- **`ForwarderChain`:** El índice de la primera referencia de cadena de reenvío.
Esto es algo responsable del reenvío de DLL. (El reenvío de DLL es cuando una DLL reenvía algunas de sus funciones exportadas a otra DLL).
- **`Name`:** Un RVA de una cadena ASCII que contiene el nombre de la DLL importada.
- **`FirstThunk`:** RVA del [[IAT]].

#### Importaciones enlazadas[Permalink](https://0xrick.github.io/win-internals/pe6/#bound-imports "Permalink")

Una importación enlazada significa básicamente que la tabla de importación contiene direcciones fijas para las funciones importadas.
El enlazador calcula y escribe estas direcciones durante el tiempo de compilación.

El uso de importaciones enlazadas es una optimización de la velocidad, reduce el tiempo que necesita el cargador para resolver las direcciones de las funciones y completar el IAT; sin embargo, si en el tiempo de ejecución las direcciones enlazadas no coinciden con las reales, el cargador tendrá que resolver estas direcciones nuevamente y corregir el IAT.

Al hablar de `IMAGE_IMPORT_DESCRIPTOR.TimeDateStamp`, mencioné que en el caso de una importación enlazada, la marca de fecha y hora se establece en `-1` y la marca de fecha y hora real de la DLL se puede encontrar en el `IMAGE_BOUND_IMPORT_DESCRIPTOR` correspondiente en el Directorio de datos de importación enlazada.

#### Directorio de datos de importación enlazados[Permalink](https://0xrick.github.io/win-internals/pe6/#bound-import-data-directory "Permalink")

El directorio de datos de importación enlazados es similar a la tabla de directorio de importación, sin embargo, como sugiere el nombre, contiene información sobre las importaciones enlazadas.

Consiste en una matriz de estructuras `IMAGE_BOUND_IMPORT_DESCRIPTOR` y termina con un `IMAGE_BOUND_IMPORT_DESCRIPTOR` puesto a cero.

`IMAGE_BOUND_IMPORT_DESCRIPTOR` se define de la siguiente manera:

```c
typedef struct _IMAGE_BOUND_IMPORT_DESCRIPTOR {
    DWORD   TimeDateStamp;
    WORD    OffsetModuleName;
    WORD    NumberOfModuleForwarderRefs;
// Array of zero or more IMAGE_BOUND_FORWARDER_REF follows
} IMAGE_BOUND_IMPORT_DESCRIPTOR,  *PIMAGE_BOUND_IMPORT_DESCRIPTOR;
```

- **`TimeDateStamp`:** La marca de fecha y hora de la DLL importada.
- **`OffsetModuleName`:** Un desplazamiento a una cadena con el nombre de la DLL importada.
Es un desplazamiento desde el primer `IMAGE_BOUND_IMPORT_DESCRIPTOR`
- **`NumberOfModuleForwarderRefs`:** El número de las estructuras `IMAGE_BOUND_FORWARDER_REF` que siguen inmediatamente a esta estructura.
`IMAGE_BOUND_FORWARDER_REF` es una estructura idéntica a `IMAGE_BOUND_IMPORT_DESCRIPTOR`, la única diferencia es que el último miembro está reservado.

Eso es todo lo que necesitamos saber sobre las importaciones enlazadas.

### Tabla de búsqueda de importación (ILT)[Permalink](https://0xrick.github.io/win-internals/pe6/#import-lookup-table-ilt "Permalink")
A veces, la gente se refiere a ella como la Tabla de nombres de importación (INT).

Cada DLL importada tiene una Tabla de búsqueda de importación.
`IMAGE_IMPORT_DESCRIPTOR.OriginalFirstThunk` contiene el RVA de la ILT de la DLL correspondiente.

La ILT es esencialmente una tabla de nombres o referencias, que le dice al cargador qué funciones se necesitan de la DLL importada.

La ILT consiste en una matriz de números de 32 bits (para [[PE]]32) o números de 64 bits (para [[PE]]32+), el último se pone a cero para indicar el final de la ILT.

Cada entrada de estas entradas codifica la información de la siguiente manera:

- **Bit 31/63 (bit más significativo)**: se denomina indicador Ordinal/Nombre y especifica si se debe importar la función por nombre o por ordinal.
- **Bits 15-0:** si el indicador Ordinal/Nombre se establece en `1`, estos bits se utilizan para almacenar el número ordinal de 16 bits que se utilizará para importar la función; los bits 30-15/62-15 para [[PE]]32/[[PE]]32+ deben establecerse en `0`.
- **Bits 30-0:** si el indicador Ordinal/Nombre se establece en `0`, estos bits se utilizan para almacenar un RVA de una tabla Sugerencia/Nombre.

```c
typedef struct __ILT_ENTRY_32 {
    union {
        DWORD ORDINAL           : 16;
        DWORD HINT_NAME_TABE    : 32;
        DWORD ORDINAL_NAME_FLAG  : 1;
    } FIELD_1;
} ILT_ENTRY_32, * PILT_ENTRY_32;
typedef struct __ILT_ENTRY_64 {
    union {
        DWORD ORDINAL           : 16;
        DWORD HINT_NAME_TABE    : 32;
    } FIELD_2;
    DWORD ORDINAL_NAME_FLAG     : 1;
} ILT_ENTRY_64, * PILT_ENTRY_64;
```
#### Tabla de sugerencias/nombres[Permalink](https://0xrick.github.io/win-internals/pe6/#hintname-table "Permalink")
Una tabla de sugerencias/nombres es una estructura definida en [[winnt.h]] como [[#^ac20c7|IMAGE_IMPORT_BY_NAME]]:

```c
typedef struct _IMAGE_IMPORT_BY_NAME {
	WORD Hint;
	CHAR Name[1];
} IMAGE_IMPORT_BY_NAME, *PIMAGE_IMPORT_BY_NAME;
```
^ac20c7
- **`Sugerencia`:** Una palabra que contiene un número, este número se utiliza para buscar la función, ese número se utiliza primero como índice en la tabla de punteros de nombre de exportación, si esa verificación inicial falla, se realiza una búsqueda binaria en la tabla de punteros de nombre de exportación de la DLL.
- **`Nombre`:** Una cadena terminada en nulo que contiene el nombre de la función a importar.
### Tabla de direcciones de importación (IAT)[Permalink](https://0xrick.github.io/win-internals/pe6/#import-address-table-iat "Permalink")
En el disco, la [[IAT]] es idéntica a la ILT, sin embargo, durante la delimitación cuando el binario se carga en la memoria, las entradas de la [[IAT]] se sobrescriben con las direcciones de las funciones que se están importando.

### Resumen[Enlace permanente](https://0xrick.github.io/win-internals/pe6/#summary "Enlace permanente")

Para resumir lo que analizamos en esta publicación, para cada DLL desde la que el ejecutable carga funciones, habrá un `IMAGE_IMPORT_DESCRIPTOR` dentro de la tabla de directorio de imágenes.
El `IMAGE_IMPORT_DESCRIPTOR` contendrá el nombre de la DLL y dos campos que contienen las RVA de la ILT y la [[IAT]].
La ILT contendrá referencias para todas las funciones que se están importando desde la DLL.
La IAT será idéntica a la ILT hasta que el ejecutable se cargue en la memoria, luego el cargador llenará la [[IAT]] con las direcciones reales de las funciones importadas.
Si la importación de DLL es una importación vinculada, entonces la información de importación estará contenida en estructuras `IMAGE_BOUND_IMPORT_DESCRIPTOR` en un Directorio de datos separado llamado Directorio de datos de importación vinculada.
Echemos un vistazo rápido a la información de importación dentro de un archivo PE real.
Aquí está la Tabla del directorio de importación del ejecutable:
![[Pasted image 20250301201934.png]]

Todas estas entradas son `IMAGE_IMPORT_DESCRIPTORS`.

Como puede ver, el `TimeDateStamp` de todas las importaciones está establecido en `0`, lo que significa que ninguna de estas importaciones está vinculada, esto también se confirma en la columna `Bound?` agregada por PE-bear.

Por ejemplo, si tomamos `USER32.dll` y seguimos el RVA de su ILT (referenciado por `OriginalFirstThunk`), encontraremos solo 1 entrada (porque solo se importa una función), y esa entrada se ve así:

![](https://0xrick.github.io/images/wininternals/pe6/2.png)

Este es un ejecutable de 64 bits, por lo que la entrada tiene una longitud de 64 bits.
Como puede ver, el último byte está configurado en `0`, lo que indica que se debe usar un nombre de Sugerencia/Tabla para buscar la función.
Sabemos que el RVA de este nombre de Sugerencia/Tabla debe ser referenciado por los primeros 2 bytes, por lo que debemos seguir el RVA `0x29F8`:

![](https://0xrick.github.io/images/wininternals/pe6/3.png)

![](https://0xrick.github.io/images/wininternals/pe6/4.png)

Ahora estamos viendo una estructura `IMAGE_IMPORT_BY_NAME`, los primeros dos bytes contienen la pista, que en este caso es `0x283`, el resto de la estructura contiene el nombre completo de la función que es `MessageBoxA`.
Podemos verificar que nuestra interpretación de los datos es correcta al observar cómo los analizó PE-bear, y veremos los mismos resultados:

![](https://0xrick.github.io/images/wininternals/pe6/5.png)
### Relocalizaciones

```c
typedef struct __BASE_RELOC_ENTRY {
    WORD OFFSET : 12;
    WORD TYPE : 4;
} BASE_RELOC_ENTRY, * PBASE_RELOC_ENTRY;
```

Los archivos PE no contienen [código independiente de la posición](https://es.wikipedia.org/w/index.php?title=C%C3%B3digo_independiente_de_la_posici%C3%B3n&action=edit&redlink=1 "Código independiente de la posición (aún no redactado)"). En su lugar son compilados a una _dirección base_ preferida, y todas las direcciones emitidas por el compilador/enlazador se fijan previamente. Si un archivo PE no puede ser cargado en su dirección preferida (porque ya fue tomada por algo más), el sistema operativo lo reajustará. Esto implica recalcular cada dirección absoluta y modificar el código para utilizar los nuevos valores. El cargador lo realiza comparando las direcciones de carga actual y preferida, y calculando un valor [delta](https://es.wikipedia.org/wiki/Delta_encoding "Delta encoding"). Esto se añade a continuación a la dirección preferida para llegar a la nueva dirección de la localización de memoria. Las relocalizaciones base son almacenadas en una lista y añadidas, cuando sea necesario, a una posición de memoria existente. El código resultante ahora es privado al proceso y no es más compartido, por lo que muchos de los beneficios de ahorro de memoria de las DLLs se pierden en este escenario. También retrasa la carga del módulo de manera significativa. Por esta razón, el reajuste es evitado siempre que sea posible, y las DLL proporcionadas por Microsoft tienen direcciones base pre-calculadas de manera que no se superpongan. Por lo tanto, en el caso de no reajuste, PE ofrece la ventaja de un código muy eficiente, pero en presencia de reajuste, el éxito en el uso de memoria puede ser costoso. Esto contrasta con ELF, que utiliza código totalmente independiente de la posición y una tabla de desplazamiento global, que abandona tiempo en ejecución contra el uso de memoria en favor de estos últimos.

Cuando se compila un programa, el compilador asume que el ejecutable se cargará en una dirección base determinada, esa dirección se guarda en `IMAGE_OPTIONAL_HEADER.ImageBase`, algunas direcciones se calculan y luego se codifican en el ejecutable según la dirección base.
Sin embargo, por diversas razones, no es muy probable que el ejecutable obtenga la dirección base deseada, se cargará en otra dirección base y eso hará que todas las direcciones codificadas sean inválidas.
Una lista de todos los valores codificados que necesitarán reparación si la imagen se carga en una dirección base diferente se guarda en una tabla especial llamada Tabla de reubicación (un directorio de datos dentro de la sección `.reloc`). El proceso de reubicación (realizado por el cargador) es lo que repara estos valores.

Tomemos un ejemplo, el siguiente código define una variable `int` y un puntero a esa variable:
```c
int test = 2;
int* testPtr = &test;
```

Durante el tiempo de compilación, el compilador asumirá una dirección base, digamos que asume una dirección base de `0x1000`, decide que `test` se ubicará en un desplazamiento de `0x100` y en función de eso le da a `testPtr` un valor de `0x1100`.
Más tarde, un usuario ejecuta el programa y la imagen se carga en la memoria. Obtiene una dirección base de `0x2000`, esto significa que el valor codificado de `testPtr` no será válido, el cargador corrige ese valor agregando la diferencia entre la dirección base asumida y la dirección base real, en este caso es una diferencia de `0x1000` (`0x2000 - 0x1000`), por lo que el nuevo valor de `testPtr` será `0x2100` (`0x1100 + 0x1000`) que es la nueva dirección correcta de `test`.

### Tabla de reubicación[Permalink](https://0xrick.github.io/win-internals/pe7/#relocation-table "Permalink")
Como se describe en la documentación de Microsoft, la tabla de reubicación base contiene entradas para todas las reubicaciones base en la imagen.

Es un directorio de datos ubicado dentro de la sección `.reloc`, está dividido en bloques, cada bloque representa las reubicaciones base para una página de 4K y cada bloque debe comenzar en un límite de 32 bits.

Cada bloque comienza con una estructura `IMAGE_BASE_RELOCATION` seguida de cualquier número de entradas de campo de desplazamiento.

La estructura `IMAGE_BASE_RELOCATION` especifica la RVA de la página y el tamaño del bloque de reubicación.

```c
typedef struct _IMAGE_BASE_RELOCATION {
    DWORD   VirtualAddress;
    DWORD   SizeOfBlock;
} IMAGE_BASE_RELOCATION;
typedef IMAGE_BASE_RELOCATION UNALIGNED * PIMAGE_BASE_RELOCATION;
```

Cada entrada del campo de desplazamiento es una PALABRA(WORD), sus primeros 4 bits definen el tipo de reubicación (consulte la [documentación de Microsoft](https://docs.microsoft.com/en-us/windows/win32/debug/pe-format) para obtener una lista de los tipos de reubicación), los últimos 12 bits almacenan un desplazamiento del RVA especificado en la estructura `IMAGE_BASE_RELOCATION` al comienzo del bloque de reubicación.

Cada entrada de reubicación se procesa agregando el RVA de la página a la dirección base de la imagen, luego, al agregar el desplazamiento especificado en la entrada de reubicación, se puede obtener una dirección absoluta de la ubicación que necesita ser corregida.

El archivo PE que estoy viendo contiene solo un bloque de reubicación, su tamaño es `0x28` bytes:
![[Pasted image 20250301202715.png]]
Sabemos que cada bloque comienza con una estructura de 8 bytes de longitud, lo que significa que el tamaño de las entradas es de `0x20` bytes (32 bytes), el tamaño de cada entrada es de 2 bytes, por lo que el número total de entradas debe ser 16.


---------
### Address Space Layout Randomization (ASLR)
Aleatorización del diseño del espacio de direcciones ([[ASLR]])
Los archivos PE no son independientes de la posición de forma predeterminada; se compilan para ejecutarse en una dirección de memoria fija y específica. Los sistemas operativos modernos utilizan la aleatorización del diseño del espacio de direcciones (ASLR) para dificultar que los atacantes exploten vulnerabilidades relacionadas con la memoria. La ASLR funciona cambiando aleatoriamente la dirección de memoria de partes importantes del programa cada vez que se carga. Esto incluye la dirección base del programa en sí, las bibliotecas compartidas (DLL) y las áreas de memoria como el montón y la pila. La ASLR reorganiza las posiciones del espacio de direcciones de las áreas de datos clave de un proceso, incluida la base del ejecutable y las posiciones de la pila, el montón y las bibliotecas. Al aleatorizar estas direcciones de memoria cada vez que se carga el proceso o la aplicación, la ASLR evita que los atacantes puedan predecir de manera confiable las ubicaciones de la memoria.

--------


https://github.com/torvalds/linux/blob/master/include/linux/pe.h:
```c
/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * Copyright 2011 Red Hat, Inc.
 * All rights reserved.
 *
 * Author(s): Peter Jones <pjones@redhat.com>
 */
#ifndef __LINUX_PE_H
#define __LINUX_PE_H

#include <linux/types.h>

/*
 * Starting from version v3.0, the major version field should be interpreted as
 * a bit mask of features supported by the kernel's EFI stub:
 * - 0x1: initrd loading from the LINUX_EFI_INITRD_MEDIA_GUID device path,
 * - 0x2: initrd loading using the initrd= command line option, where the file
 *        may be specified using device path notation, and is not required to
 *        reside on the same volume as the loaded kernel image.
 *
 * The recommended way of loading and starting v1.0 or later kernels is to use
 * the LoadImage() and StartImage() EFI boot services, and expose the initrd
 * via the LINUX_EFI_INITRD_MEDIA_GUID device path.
 *
 * Versions older than v1.0 may support initrd loading via the image load
 * options (using initrd=, limited to the volume from which the kernel itself
 * was loaded), or only via arch specific means (bootparams, DT, etc).
 *
 * The minor version field must remain 0x0.
 * (https://lore.kernel.org/all/efd6f2d4-547c-1378-1faa-53c044dbd297@gmail.com/)
 */
#define LINUX_EFISTUB_MAJOR_VERSION		0x3
#define LINUX_EFISTUB_MINOR_VERSION		0x0

/*
 * LINUX_PE_MAGIC appears at offset 0x38 into the MS-DOS header of EFI bootable
 * Linux kernel images that target the architecture as specified by the PE/COFF
 * header machine type field.
 */
#define LINUX_PE_MAGIC	0x818223cd

#define MZ_MAGIC	0x5a4d	/* "MZ" */

#define PE_MAGIC		0x00004550	/* "PE\0\0" */
#define PE_OPT_MAGIC_PE32	0x010b
#define PE_OPT_MAGIC_PE32_ROM	0x0107
#define PE_OPT_MAGIC_PE32PLUS	0x020b

/* machine type */
#define	IMAGE_FILE_MACHINE_UNKNOWN	0x0000
#define	IMAGE_FILE_MACHINE_AM33		0x01d3
#define	IMAGE_FILE_MACHINE_AMD64	0x8664
#define	IMAGE_FILE_MACHINE_ARM		0x01c0
#define	IMAGE_FILE_MACHINE_ARMV7	0x01c4
#define	IMAGE_FILE_MACHINE_ARM64	0xaa64
#define	IMAGE_FILE_MACHINE_EBC		0x0ebc
#define	IMAGE_FILE_MACHINE_I386		0x014c
#define	IMAGE_FILE_MACHINE_IA64		0x0200
#define	IMAGE_FILE_MACHINE_M32R		0x9041
#define	IMAGE_FILE_MACHINE_MIPS16	0x0266
#define	IMAGE_FILE_MACHINE_MIPSFPU	0x0366
#define	IMAGE_FILE_MACHINE_MIPSFPU16	0x0466
#define	IMAGE_FILE_MACHINE_POWERPC	0x01f0
#define	IMAGE_FILE_MACHINE_POWERPCFP	0x01f1
#define	IMAGE_FILE_MACHINE_R4000	0x0166
#define	IMAGE_FILE_MACHINE_RISCV32	0x5032
#define	IMAGE_FILE_MACHINE_RISCV64	0x5064
#define	IMAGE_FILE_MACHINE_RISCV128	0x5128
#define	IMAGE_FILE_MACHINE_SH3		0x01a2
#define	IMAGE_FILE_MACHINE_SH3DSP	0x01a3
#define	IMAGE_FILE_MACHINE_SH3E		0x01a4
#define	IMAGE_FILE_MACHINE_SH4		0x01a6
#define	IMAGE_FILE_MACHINE_SH5		0x01a8
#define	IMAGE_FILE_MACHINE_THUMB	0x01c2
#define	IMAGE_FILE_MACHINE_WCEMIPSV2	0x0169
#define	IMAGE_FILE_MACHINE_LOONGARCH32	0x6232
#define	IMAGE_FILE_MACHINE_LOONGARCH64	0x6264

/* flags */
#define IMAGE_FILE_RELOCS_STRIPPED           0x0001
#define IMAGE_FILE_EXECUTABLE_IMAGE          0x0002
#define IMAGE_FILE_LINE_NUMS_STRIPPED        0x0004
#define IMAGE_FILE_LOCAL_SYMS_STRIPPED       0x0008
#define IMAGE_FILE_AGGRESSIVE_WS_TRIM        0x0010
#define IMAGE_FILE_LARGE_ADDRESS_AWARE       0x0020
#define IMAGE_FILE_16BIT_MACHINE             0x0040
#define IMAGE_FILE_BYTES_REVERSED_LO         0x0080
#define IMAGE_FILE_32BIT_MACHINE             0x0100
#define IMAGE_FILE_DEBUG_STRIPPED            0x0200
#define IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP   0x0400
#define IMAGE_FILE_NET_RUN_FROM_SWAP         0x0800
#define IMAGE_FILE_SYSTEM                    0x1000
#define IMAGE_FILE_DLL                       0x2000
#define IMAGE_FILE_UP_SYSTEM_ONLY            0x4000
#define IMAGE_FILE_BYTES_REVERSED_HI         0x8000

#define IMAGE_FILE_OPT_ROM_MAGIC	0x107
#define IMAGE_FILE_OPT_PE32_MAGIC	0x10b
#define IMAGE_FILE_OPT_PE32_PLUS_MAGIC	0x20b

#define IMAGE_SUBSYSTEM_UNKNOWN			 0
#define IMAGE_SUBSYSTEM_NATIVE			 1
#define IMAGE_SUBSYSTEM_WINDOWS_GUI		 2
#define IMAGE_SUBSYSTEM_WINDOWS_CUI		 3
#define IMAGE_SUBSYSTEM_POSIX_CUI		 7
#define IMAGE_SUBSYSTEM_WINDOWS_CE_GUI		 9
#define IMAGE_SUBSYSTEM_EFI_APPLICATION		10
#define IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER	11
#define IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER	12
#define IMAGE_SUBSYSTEM_EFI_ROM_IMAGE		13
#define IMAGE_SUBSYSTEM_XBOX			14

#define IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE          0x0040
#define IMAGE_DLL_CHARACTERISTICS_FORCE_INTEGRITY       0x0080
#define IMAGE_DLL_CHARACTERISTICS_NX_COMPAT             0x0100
#define IMAGE_DLLCHARACTERISTICS_NO_ISOLATION           0x0200
#define IMAGE_DLLCHARACTERISTICS_NO_SEH                 0x0400
#define IMAGE_DLLCHARACTERISTICS_NO_BIND                0x0800
#define IMAGE_DLLCHARACTERISTICS_WDM_DRIVER             0x2000
#define IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE  0x8000

#define IMAGE_DLLCHARACTERISTICS_EX_CET_COMPAT		0x0001
#define IMAGE_DLLCHARACTERISTICS_EX_FORWARD_CFI_COMPAT	0x0040

/* they actually defined 0x00000000 as well, but I think we'll skip that one. */
#define IMAGE_SCN_RESERVED_0	0x00000001
#define IMAGE_SCN_RESERVED_1	0x00000002
#define IMAGE_SCN_RESERVED_2	0x00000004
#define IMAGE_SCN_TYPE_NO_PAD	0x00000008 /* don't pad - obsolete */
#define IMAGE_SCN_RESERVED_3	0x00000010
#define IMAGE_SCN_CNT_CODE	0x00000020 /* .text */
#define IMAGE_SCN_CNT_INITIALIZED_DATA 0x00000040 /* .data */
#define IMAGE_SCN_CNT_UNINITIALIZED_DATA 0x00000080 /* .bss */
#define IMAGE_SCN_LNK_OTHER	0x00000100 /* reserved */
#define IMAGE_SCN_LNK_INFO	0x00000200 /* .drectve comments */
#define IMAGE_SCN_RESERVED_4	0x00000400
#define IMAGE_SCN_LNK_REMOVE	0x00000800 /* .o only - scn to be rm'd*/
#define IMAGE_SCN_LNK_COMDAT	0x00001000 /* .o only - COMDAT data */
#define IMAGE_SCN_RESERVED_5	0x00002000 /* spec omits this */
#define IMAGE_SCN_RESERVED_6	0x00004000 /* spec omits this */
#define IMAGE_SCN_GPREL		0x00008000 /* global pointer referenced data */
/* spec lists 0x20000 twice, I suspect they meant 0x10000 for one of them */
#define IMAGE_SCN_MEM_PURGEABLE	0x00010000 /* reserved for "future" use */
#define IMAGE_SCN_16BIT		0x00020000 /* reserved for "future" use */
#define IMAGE_SCN_LOCKED	0x00040000 /* reserved for "future" use */
#define IMAGE_SCN_PRELOAD	0x00080000 /* reserved for "future" use */
/* and here they just stuck a 1-byte integer in the middle of a bitfield */
#define IMAGE_SCN_ALIGN_1BYTES	0x00100000 /* it does what it says on the box */
#define IMAGE_SCN_ALIGN_2BYTES	0x00200000
#define IMAGE_SCN_ALIGN_4BYTES	0x00300000
#define IMAGE_SCN_ALIGN_8BYTES	0x00400000
#define IMAGE_SCN_ALIGN_16BYTES	0x00500000
#define IMAGE_SCN_ALIGN_32BYTES	0x00600000
#define IMAGE_SCN_ALIGN_64BYTES	0x00700000
#define IMAGE_SCN_ALIGN_128BYTES 0x00800000
#define IMAGE_SCN_ALIGN_256BYTES 0x00900000
#define IMAGE_SCN_ALIGN_512BYTES 0x00a00000
#define IMAGE_SCN_ALIGN_1024BYTES 0x00b00000
#define IMAGE_SCN_ALIGN_2048BYTES 0x00c00000
#define IMAGE_SCN_ALIGN_4096BYTES 0x00d00000
#define IMAGE_SCN_ALIGN_8192BYTES 0x00e00000
#define IMAGE_SCN_LNK_NRELOC_OVFL 0x01000000 /* extended relocations */
#define IMAGE_SCN_MEM_DISCARDABLE 0x02000000 /* scn can be discarded */
#define IMAGE_SCN_MEM_NOT_CACHED 0x04000000 /* cannot be cached */
#define IMAGE_SCN_MEM_NOT_PAGED	0x08000000 /* not pageable */
#define IMAGE_SCN_MEM_SHARED	0x10000000 /* can be shared */
#define IMAGE_SCN_MEM_EXECUTE	0x20000000 /* can be executed as code */
#define IMAGE_SCN_MEM_READ	0x40000000 /* readable */
#define IMAGE_SCN_MEM_WRITE	0x80000000 /* writeable */

#define IMAGE_DEBUG_TYPE_CODEVIEW	2
#define IMAGE_DEBUG_TYPE_EX_DLLCHARACTERISTICS	20

#ifndef __ASSEMBLY__

struct mz_hdr {
	uint16_t magic;		/* MZ_MAGIC */
	uint16_t lbsize;	/* size of last used block */
	uint16_t blocks;	/* pages in file, 0x3 */
	uint16_t relocs;	/* relocations */
	uint16_t hdrsize;	/* header size in "paragraphs" */
	uint16_t min_extra_pps;	/* .bss */
	uint16_t max_extra_pps;	/* runtime limit for the arena size */
	uint16_t ss;		/* relative stack segment */
	uint16_t sp;		/* initial %sp register */
	uint16_t checksum;	/* word checksum */
	uint16_t ip;		/* initial %ip register */
	uint16_t cs;		/* initial %cs relative to load segment */
	uint16_t reloc_table_offset;	/* offset of the first relocation */
	uint16_t overlay_num;	/* overlay number.  set to 0. */
	uint16_t reserved0[4];	/* reserved */
	uint16_t oem_id;	/* oem identifier */
	uint16_t oem_info;	/* oem specific */
	uint16_t reserved1[10];	/* reserved */
	uint32_t peaddr;	/* address of pe header */
	char     message[];	/* message to print */
};

struct mz_reloc {
	uint16_t offset;
	uint16_t segment;
};

struct pe_hdr {
	uint32_t magic;		/* PE magic */
	uint16_t machine;	/* machine type */
	uint16_t sections;	/* number of sections */
	uint32_t timestamp;	/* time_t */
	uint32_t symbol_table;	/* symbol table offset */
	uint32_t symbols;	/* number of symbols */
	uint16_t opt_hdr_size;	/* size of optional header */
	uint16_t flags;		/* flags */
};

/* the fact that pe32 isn't padded where pe32+ is 64-bit means union won't
 * work right.  vomit. */
struct pe32_opt_hdr {
	/* "standard" header */
	uint16_t magic;		/* file type */
	uint8_t  ld_major;	/* linker major version */
	uint8_t  ld_minor;	/* linker minor version */
	uint32_t text_size;	/* size of text section(s) */
	uint32_t data_size;	/* size of data section(s) */
	uint32_t bss_size;	/* size of bss section(s) */
	uint32_t entry_point;	/* file offset of entry point */
	uint32_t code_base;	/* relative code addr in ram */
	uint32_t data_base;	/* relative data addr in ram */
	/* "windows" header */
	uint32_t image_base;	/* preferred load address */
	uint32_t section_align;	/* alignment in bytes */
	uint32_t file_align;	/* file alignment in bytes */
	uint16_t os_major;	/* major OS version */
	uint16_t os_minor;	/* minor OS version */
	uint16_t image_major;	/* major image version */
	uint16_t image_minor;	/* minor image version */
	uint16_t subsys_major;	/* major subsystem version */
	uint16_t subsys_minor;	/* minor subsystem version */
	uint32_t win32_version;	/* reserved, must be 0 */
	uint32_t image_size;	/* image size */
	uint32_t header_size;	/* header size rounded up to
				   file_align */
	uint32_t csum;		/* checksum */
	uint16_t subsys;	/* subsystem */
	uint16_t dll_flags;	/* more flags! */
	uint32_t stack_size_req;/* amt of stack requested */
	uint32_t stack_size;	/* amt of stack required */
	uint32_t heap_size_req;	/* amt of heap requested */
	uint32_t heap_size;	/* amt of heap required */
	uint32_t loader_flags;	/* reserved, must be 0 */
	uint32_t data_dirs;	/* number of data dir entries */
};

struct pe32plus_opt_hdr {
	uint16_t magic;		/* file type */
	uint8_t  ld_major;	/* linker major version */
	uint8_t  ld_minor;	/* linker minor version */
	uint32_t text_size;	/* size of text section(s) */
	uint32_t data_size;	/* size of data section(s) */
	uint32_t bss_size;	/* size of bss section(s) */
	uint32_t entry_point;	/* file offset of entry point */
	uint32_t code_base;	/* relative code addr in ram */
	/* "windows" header */
	uint64_t image_base;	/* preferred load address */
	uint32_t section_align;	/* alignment in bytes */
	uint32_t file_align;	/* file alignment in bytes */
	uint16_t os_major;	/* major OS version */
	uint16_t os_minor;	/* minor OS version */
	uint16_t image_major;	/* major image version */
	uint16_t image_minor;	/* minor image version */
	uint16_t subsys_major;	/* major subsystem version */
	uint16_t subsys_minor;	/* minor subsystem version */
	uint32_t win32_version;	/* reserved, must be 0 */
	uint32_t image_size;	/* image size */
	uint32_t header_size;	/* header size rounded up to
				   file_align */
	uint32_t csum;		/* checksum */
	uint16_t subsys;	/* subsystem */
	uint16_t dll_flags;	/* more flags! */
	uint64_t stack_size_req;/* amt of stack requested */
	uint64_t stack_size;	/* amt of stack required */
	uint64_t heap_size_req;	/* amt of heap requested */
	uint64_t heap_size;	/* amt of heap required */
	uint32_t loader_flags;	/* reserved, must be 0 */
	uint32_t data_dirs;	/* number of data dir entries */
};

struct data_dirent {
	uint32_t virtual_address;	/* relative to load address */
	uint32_t size;
};

struct data_directory {
	struct data_dirent exports;		/* .edata */
	struct data_dirent imports;		/* .idata */
	struct data_dirent resources;		/* .rsrc */
	struct data_dirent exceptions;		/* .pdata */
	struct data_dirent certs;		/* certs */
	struct data_dirent base_relocations;	/* .reloc */
	struct data_dirent debug;		/* .debug */
	struct data_dirent arch;		/* reservered */
	struct data_dirent global_ptr;		/* global pointer reg. Size=0 */
	struct data_dirent tls;			/* .tls */
	struct data_dirent load_config;		/* load configuration structure */
	struct data_dirent bound_imports;	/* no idea */
	struct data_dirent import_addrs;	/* import address table */
	struct data_dirent delay_imports;	/* delay-load import table */
	struct data_dirent clr_runtime_hdr;	/* .cor (object only) */
	struct data_dirent reserved;
};

struct section_header {
	char name[8];			/* name or "/12\0" string tbl offset */
	uint32_t virtual_size;		/* size of loaded section in ram */
	uint32_t virtual_address;	/* relative virtual address */
	uint32_t raw_data_size;		/* size of the section */
	uint32_t data_addr;		/* file pointer to first page of sec */
	uint32_t relocs;		/* file pointer to relocation entries */
	uint32_t line_numbers;		/* line numbers! */
	uint16_t num_relocs;		/* number of relocations */
	uint16_t num_lin_numbers;	/* srsly. */
	uint32_t flags;
};

enum x64_coff_reloc_type {
	IMAGE_REL_AMD64_ABSOLUTE = 0,
	IMAGE_REL_AMD64_ADDR64,
	IMAGE_REL_AMD64_ADDR32,
	IMAGE_REL_AMD64_ADDR32N,
	IMAGE_REL_AMD64_REL32,
	IMAGE_REL_AMD64_REL32_1,
	IMAGE_REL_AMD64_REL32_2,
	IMAGE_REL_AMD64_REL32_3,
	IMAGE_REL_AMD64_REL32_4,
	IMAGE_REL_AMD64_REL32_5,
	IMAGE_REL_AMD64_SECTION,
	IMAGE_REL_AMD64_SECREL,
	IMAGE_REL_AMD64_SECREL7,
	IMAGE_REL_AMD64_TOKEN,
	IMAGE_REL_AMD64_SREL32,
	IMAGE_REL_AMD64_PAIR,
	IMAGE_REL_AMD64_SSPAN32,
};

enum arm_coff_reloc_type {
	IMAGE_REL_ARM_ABSOLUTE,
	IMAGE_REL_ARM_ADDR32,
	IMAGE_REL_ARM_ADDR32N,
	IMAGE_REL_ARM_BRANCH2,
	IMAGE_REL_ARM_BRANCH1,
	IMAGE_REL_ARM_SECTION,
	IMAGE_REL_ARM_SECREL,
};

enum sh_coff_reloc_type {
	IMAGE_REL_SH3_ABSOLUTE,
	IMAGE_REL_SH3_DIRECT16,
	IMAGE_REL_SH3_DIRECT32,
	IMAGE_REL_SH3_DIRECT8,
	IMAGE_REL_SH3_DIRECT8_WORD,
	IMAGE_REL_SH3_DIRECT8_LONG,
	IMAGE_REL_SH3_DIRECT4,
	IMAGE_REL_SH3_DIRECT4_WORD,
	IMAGE_REL_SH3_DIRECT4_LONG,
	IMAGE_REL_SH3_PCREL8_WORD,
	IMAGE_REL_SH3_PCREL8_LONG,
	IMAGE_REL_SH3_PCREL12_WORD,
	IMAGE_REL_SH3_STARTOF_SECTION,
	IMAGE_REL_SH3_SIZEOF_SECTION,
	IMAGE_REL_SH3_SECTION,
	IMAGE_REL_SH3_SECREL,
	IMAGE_REL_SH3_DIRECT32_NB,
	IMAGE_REL_SH3_GPREL4_LONG,
	IMAGE_REL_SH3_TOKEN,
	IMAGE_REL_SHM_PCRELPT,
	IMAGE_REL_SHM_REFLO,
	IMAGE_REL_SHM_REFHALF,
	IMAGE_REL_SHM_RELLO,
	IMAGE_REL_SHM_RELHALF,
	IMAGE_REL_SHM_PAIR,
	IMAGE_REL_SHM_NOMODE,
};

enum ppc_coff_reloc_type {
	IMAGE_REL_PPC_ABSOLUTE,
	IMAGE_REL_PPC_ADDR64,
	IMAGE_REL_PPC_ADDR32,
	IMAGE_REL_PPC_ADDR24,
	IMAGE_REL_PPC_ADDR16,
	IMAGE_REL_PPC_ADDR14,
	IMAGE_REL_PPC_REL24,
	IMAGE_REL_PPC_REL14,
	IMAGE_REL_PPC_ADDR32N,
	IMAGE_REL_PPC_SECREL,
	IMAGE_REL_PPC_SECTION,
	IMAGE_REL_PPC_SECREL16,
	IMAGE_REL_PPC_REFHI,
	IMAGE_REL_PPC_REFLO,
	IMAGE_REL_PPC_PAIR,
	IMAGE_REL_PPC_SECRELLO,
	IMAGE_REL_PPC_GPREL,
	IMAGE_REL_PPC_TOKEN,
};

enum x86_coff_reloc_type {
	IMAGE_REL_I386_ABSOLUTE,
	IMAGE_REL_I386_DIR16,
	IMAGE_REL_I386_REL16,
	IMAGE_REL_I386_DIR32,
	IMAGE_REL_I386_DIR32NB,
	IMAGE_REL_I386_SEG12,
	IMAGE_REL_I386_SECTION,
	IMAGE_REL_I386_SECREL,
	IMAGE_REL_I386_TOKEN,
	IMAGE_REL_I386_SECREL7,
	IMAGE_REL_I386_REL32,
};

enum ia64_coff_reloc_type {
	IMAGE_REL_IA64_ABSOLUTE,
	IMAGE_REL_IA64_IMM14,
	IMAGE_REL_IA64_IMM22,
	IMAGE_REL_IA64_IMM64,
	IMAGE_REL_IA64_DIR32,
	IMAGE_REL_IA64_DIR64,
	IMAGE_REL_IA64_PCREL21B,
	IMAGE_REL_IA64_PCREL21M,
	IMAGE_REL_IA64_PCREL21F,
	IMAGE_REL_IA64_GPREL22,
	IMAGE_REL_IA64_LTOFF22,
	IMAGE_REL_IA64_SECTION,
	IMAGE_REL_IA64_SECREL22,
	IMAGE_REL_IA64_SECREL64I,
	IMAGE_REL_IA64_SECREL32,
	IMAGE_REL_IA64_DIR32NB,
	IMAGE_REL_IA64_SREL14,
	IMAGE_REL_IA64_SREL22,
	IMAGE_REL_IA64_SREL32,
	IMAGE_REL_IA64_UREL32,
	IMAGE_REL_IA64_PCREL60X,
	IMAGE_REL_IA64_PCREL60B,
	IMAGE_REL_IA64_PCREL60F,
	IMAGE_REL_IA64_PCREL60I,
	IMAGE_REL_IA64_PCREL60M,
	IMAGE_REL_IA64_IMMGPREL6,
	IMAGE_REL_IA64_TOKEN,
	IMAGE_REL_IA64_GPREL32,
	IMAGE_REL_IA64_ADDEND,
};

struct coff_reloc {
	uint32_t virtual_address;
	uint32_t symbol_table_index;
	union {
		enum x64_coff_reloc_type  x64_type;
		enum arm_coff_reloc_type  arm_type;
		enum sh_coff_reloc_type   sh_type;
		enum ppc_coff_reloc_type  ppc_type;
		enum x86_coff_reloc_type  x86_type;
		enum ia64_coff_reloc_type ia64_type;
		uint16_t data;
	};
};

/*
 * Definitions for the contents of the certs data block
 */
#define WIN_CERT_TYPE_PKCS_SIGNED_DATA	0x0002
#define WIN_CERT_TYPE_EFI_OKCS115	0x0EF0
#define WIN_CERT_TYPE_EFI_GUID		0x0EF1

#define WIN_CERT_REVISION_1_0	0x0100
#define WIN_CERT_REVISION_2_0	0x0200

struct win_certificate {
	uint32_t length;
	uint16_t revision;
	uint16_t cert_type;
};

#endif /* !__ASSEMBLY__ */

#endif /* __LINUX_PE_H */
```

https://github.com/u-boot/u-boot/blob/master/include/pe.h:
```c
/* SPDX-License-Identifier: GPL-2.0+ */
/*
 *  Portable Executable binary format structures
 *
 *  Copyright (c) 2016 Alexander Graf
 *
 *  Based on wine code
 */

#ifndef _PE_H
#define _PE_H

#include <asm-generic/pe.h>

typedef struct _IMAGE_DOS_HEADER {
	uint16_t e_magic;	/* 00: MZ Header signature */
	uint16_t e_cblp;	/* 02: Bytes on last page of file */
	uint16_t e_cp;		/* 04: Pages in file */
	uint16_t e_crlc;	/* 06: Relocations */
	uint16_t e_cparhdr;	/* 08: Size of header in paragraphs */
	uint16_t e_minalloc;	/* 0a: Minimum extra paragraphs needed */
	uint16_t e_maxalloc;	/* 0c: Maximum extra paragraphs needed */
	uint16_t e_ss;		/* 0e: Initial (relative) SS value */
	uint16_t e_sp;		/* 10: Initial SP value */
	uint16_t e_csum;	/* 12: Checksum */
	uint16_t e_ip;		/* 14: Initial IP value */
	uint16_t e_cs;		/* 16: Initial (relative) CS value */
	uint16_t e_lfarlc;	/* 18: File address of relocation table */
	uint16_t e_ovno;	/* 1a: Overlay number */
	uint16_t e_res[4];	/* 1c: Reserved words */
	uint16_t e_oemid;	/* 24: OEM identifier (for e_oeminfo) */
	uint16_t e_oeminfo;	/* 26: OEM information; e_oemid specific */
	uint16_t e_res2[10];	/* 28: Reserved words */
	uint32_t e_lfanew;	/* 3c: Offset to extended header */
} IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;

typedef struct _IMAGE_FILE_HEADER {
	uint16_t Machine;
	uint16_t NumberOfSections;
	uint32_t TimeDateStamp;
	uint32_t PointerToSymbolTable;
	uint32_t NumberOfSymbols;
	uint16_t SizeOfOptionalHeader;
	uint16_t Characteristics;
} IMAGE_FILE_HEADER, *PIMAGE_FILE_HEADER;

typedef struct _IMAGE_DATA_DIRECTORY {
	uint32_t VirtualAddress;
	uint32_t Size;
} IMAGE_DATA_DIRECTORY, *PIMAGE_DATA_DIRECTORY;

#define IMAGE_NUMBEROF_DIRECTORY_ENTRIES 16

typedef struct _IMAGE_OPTIONAL_HEADER64 {
	uint16_t Magic; /* 0x20b */
	uint8_t  MajorLinkerVersion;
	uint8_t  MinorLinkerVersion;
	uint32_t SizeOfCode;
	uint32_t SizeOfInitializedData;
	uint32_t SizeOfUninitializedData;
	uint32_t AddressOfEntryPoint;
	uint32_t BaseOfCode;
	uint64_t ImageBase;
	uint32_t SectionAlignment;
	uint32_t FileAlignment;
	uint16_t MajorOperatingSystemVersion;
	uint16_t MinorOperatingSystemVersion;
	uint16_t MajorImageVersion;
	uint16_t MinorImageVersion;
	uint16_t MajorSubsystemVersion;
	uint16_t MinorSubsystemVersion;
	uint32_t Win32VersionValue;
	uint32_t SizeOfImage;
	uint32_t SizeOfHeaders;
	uint32_t CheckSum;
	uint16_t Subsystem;
	uint16_t DllCharacteristics;
	uint64_t SizeOfStackReserve;
	uint64_t SizeOfStackCommit;
	uint64_t SizeOfHeapReserve;
	uint64_t SizeOfHeapCommit;
	uint32_t LoaderFlags;
	uint32_t NumberOfRvaAndSizes;
	IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
} IMAGE_OPTIONAL_HEADER64, *PIMAGE_OPTIONAL_HEADER64;

typedef struct _IMAGE_NT_HEADERS64 {
	uint32_t Signature;
	IMAGE_FILE_HEADER FileHeader;
	IMAGE_OPTIONAL_HEADER64 OptionalHeader;
} IMAGE_NT_HEADERS64, *PIMAGE_NT_HEADERS64;

typedef struct _IMAGE_OPTIONAL_HEADER {

	/* Standard fields */

	uint16_t Magic; /* 0x10b or 0x107 */     /* 0x00 */
	uint8_t  MajorLinkerVersion;
	uint8_t  MinorLinkerVersion;
	uint32_t SizeOfCode;
	uint32_t SizeOfInitializedData;
	uint32_t SizeOfUninitializedData;
	uint32_t AddressOfEntryPoint;            /* 0x10 */
	uint32_t BaseOfCode;
	uint32_t BaseOfData;

	/* NT additional fields */

	uint32_t ImageBase;
	uint32_t SectionAlignment;               /* 0x20 */
	uint32_t FileAlignment;
	uint16_t MajorOperatingSystemVersion;
	uint16_t MinorOperatingSystemVersion;
	uint16_t MajorImageVersion;
	uint16_t MinorImageVersion;
	uint16_t MajorSubsystemVersion;          /* 0x30 */
	uint16_t MinorSubsystemVersion;
	uint32_t Win32VersionValue;
	uint32_t SizeOfImage;
	uint32_t SizeOfHeaders;
	uint32_t CheckSum;                       /* 0x40 */
	uint16_t Subsystem;
	uint16_t DllCharacteristics;
	uint32_t SizeOfStackReserve;
	uint32_t SizeOfStackCommit;
	uint32_t SizeOfHeapReserve;              /* 0x50 */
	uint32_t SizeOfHeapCommit;
	uint32_t LoaderFlags;
	uint32_t NumberOfRvaAndSizes;
	IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES]; /* 0x60 */
	/* 0xE0 */
} IMAGE_OPTIONAL_HEADER32, *PIMAGE_OPTIONAL_HEADER32;

typedef struct _IMAGE_NT_HEADERS {
	uint32_t Signature; /* "PE"\0\0 */       /* 0x00 */
	IMAGE_FILE_HEADER FileHeader;         /* 0x04 */
	IMAGE_OPTIONAL_HEADER32 OptionalHeader;       /* 0x18 */
} IMAGE_NT_HEADERS32, *PIMAGE_NT_HEADERS32;

#define IMAGE_SIZEOF_SHORT_NAME 8

typedef struct _IMAGE_SECTION_HEADER {
	uint8_t	Name[IMAGE_SIZEOF_SHORT_NAME];
	union {
		uint32_t PhysicalAddress;
		uint32_t VirtualSize;
	} Misc;
	uint32_t VirtualAddress;
	uint32_t SizeOfRawData;
	uint32_t PointerToRawData;
	uint32_t PointerToRelocations;
	uint32_t PointerToLinenumbers;
	uint16_t NumberOfRelocations;
	uint16_t NumberOfLinenumbers;
	uint32_t Characteristics;
} IMAGE_SECTION_HEADER, *PIMAGE_SECTION_HEADER;

/* Indices for Optional Header Data Directories */
#define IMAGE_DIRECTORY_ENTRY_SECURITY		4
#define IMAGE_DIRECTORY_ENTRY_BASERELOC         5

typedef struct _IMAGE_BASE_RELOCATION
{
        uint32_t VirtualAddress;
        uint32_t SizeOfBlock;
        /* WORD TypeOffset[1]; */
} IMAGE_BASE_RELOCATION,*PIMAGE_BASE_RELOCATION;

typedef struct _IMAGE_RELOCATION
{
	union {
		uint32_t VirtualAddress;
		uint32_t RelocCount;
	} DUMMYUNIONNAME;
	uint32_t SymbolTableIndex;
	uint16_t Type;
} IMAGE_RELOCATION, *PIMAGE_RELOCATION;

#define IMAGE_SIZEOF_RELOCATION 10

/* generic relocation types */
#define IMAGE_REL_BASED_ABSOLUTE                0
#define IMAGE_REL_BASED_HIGH                    1
#define IMAGE_REL_BASED_LOW                     2
#define IMAGE_REL_BASED_HIGHLOW                 3
#define IMAGE_REL_BASED_HIGHADJ                 4
#define IMAGE_REL_BASED_MIPS_JMPADDR            5
#define IMAGE_REL_BASED_ARM_MOV32A              5 /* yes, 5 too */
#define IMAGE_REL_BASED_ARM_MOV32               5 /* yes, 5 too */
#define IMAGE_REL_BASED_RISCV_HI20		5 /* yes, 5 too */
#define IMAGE_REL_BASED_SECTION                 6
#define IMAGE_REL_BASED_REL                     7
#define IMAGE_REL_BASED_ARM_MOV32T              7 /* yes, 7 too */
#define IMAGE_REL_BASED_THUMB_MOV32             7 /* yes, 7 too */
#define IMAGE_REL_BASED_RISCV_LOW12I		7 /* yes, 7 too */
#define IMAGE_REL_BASED_RISCV_LOW12S		8
#define IMAGE_REL_BASED_MIPS_JMPADDR16          9
#define IMAGE_REL_BASED_IA64_IMM64              9 /* yes, 9 too */
#define IMAGE_REL_BASED_DIR64                   10
#define IMAGE_REL_BASED_HIGH3ADJ                11

/* ARM relocation types */
#define IMAGE_REL_ARM_ABSOLUTE          0x0000
#define IMAGE_REL_ARM_ADDR              0x0001
#define IMAGE_REL_ARM_ADDR32NB          0x0002
#define IMAGE_REL_ARM_BRANCH24          0x0003
#define IMAGE_REL_ARM_BRANCH11          0x0004
#define IMAGE_REL_ARM_TOKEN             0x0005
#define IMAGE_REL_ARM_GPREL12           0x0006
#define IMAGE_REL_ARM_GPREL7            0x0007
#define IMAGE_REL_ARM_BLX24             0x0008
#define IMAGE_REL_ARM_BLX11             0x0009
#define IMAGE_REL_ARM_SECTION           0x000E
#define IMAGE_REL_ARM_SECREL            0x000F
#define IMAGE_REL_ARM_MOV32A            0x0010
#define IMAGE_REL_ARM_MOV32T            0x0011
#define IMAGE_REL_ARM_BRANCH20T         0x0012
#define IMAGE_REL_ARM_BRANCH24T         0x0014
#define IMAGE_REL_ARM_BLX23T            0x0015

/* ARM64 relocation types */
#define IMAGE_REL_ARM64_ABSOLUTE        0x0000
#define IMAGE_REL_ARM64_ADDR32          0x0001
#define IMAGE_REL_ARM64_ADDR32NB        0x0002
#define IMAGE_REL_ARM64_BRANCH26        0x0003
#define IMAGE_REL_ARM64_PAGEBASE_REL21  0x0004
#define IMAGE_REL_ARM64_REL21           0x0005
#define IMAGE_REL_ARM64_PAGEOFFSET_12A  0x0006
#define IMAGE_REL_ARM64_PAGEOFFSET_12L  0x0007
#define IMAGE_REL_ARM64_SECREL          0x0008
#define IMAGE_REL_ARM64_SECREL_LOW12A   0x0009
#define IMAGE_REL_ARM64_SECREL_HIGH12A  0x000A
#define IMAGE_REL_ARM64_SECREL_LOW12L   0x000B
#define IMAGE_REL_ARM64_TOKEN           0x000C
#define IMAGE_REL_ARM64_SECTION         0x000D
#define IMAGE_REL_ARM64_ADDR64          0x000E

/* AMD64 relocation types */
#define IMAGE_REL_AMD64_ABSOLUTE        0x0000
#define IMAGE_REL_AMD64_ADDR64          0x0001
#define IMAGE_REL_AMD64_ADDR32          0x0002
#define IMAGE_REL_AMD64_ADDR32NB        0x0003
#define IMAGE_REL_AMD64_REL32           0x0004
#define IMAGE_REL_AMD64_REL32_1         0x0005
#define IMAGE_REL_AMD64_REL32_2         0x0006
#define IMAGE_REL_AMD64_REL32_3         0x0007
#define IMAGE_REL_AMD64_REL32_4         0x0008
#define IMAGE_REL_AMD64_REL32_5         0x0009
#define IMAGE_REL_AMD64_SECTION         0x000A
#define IMAGE_REL_AMD64_SECREL          0x000B
#define IMAGE_REL_AMD64_SECREL7         0x000C
#define IMAGE_REL_AMD64_TOKEN           0x000D
#define IMAGE_REL_AMD64_SREL32          0x000E
#define IMAGE_REL_AMD64_PAIR            0x000F
#define IMAGE_REL_AMD64_SSPAN32         0x0010

/* certificate appended to PE image */
typedef struct _WIN_CERTIFICATE {
	uint32_t dwLength;
	uint16_t wRevision;
	uint16_t wCertificateType;
	uint8_t bCertificate[];
} WIN_CERTIFICATE, *LPWIN_CERTIFICATE;

/* Definitions for the contents of the certs data block */
#define WIN_CERT_TYPE_PKCS_SIGNED_DATA	0x0002
#define WIN_CERT_TYPE_EFI_OKCS115	0x0EF0
#define WIN_CERT_TYPE_EFI_GUID		0x0EF1

#define WIN_CERT_REVISION_1_0		0x0100
#define WIN_CERT_REVISION_2_0		0x0200

#endif /* _PE_H */
```



https://github.com/ainfosec/MoRE/blob/master/pe.c:
```c
/**
	@file
	Defines PE format structures
		
	@date 11/10/2011
***************************************************************/

#ifndef _MORE_PE_H_
#define _MORE_PE_H_

#include "stdint.h"

// Bitmask defines
/** The section contains executable code */
#define IMAGE_SCN_CNT_CODE 0x00000020
/** The section contains initialized data */
#define IMAGE_SCN_CNT_INITIALIZED_DATA 0x00000040
/** The section contains un-initialized data */
#define IMAGE_SCN_CNT_UNINITIALIZED_DATA 0x00000080
/** The section is executable */
#define IMAGE_SCN_MEM_EXECUTE 0x20000000
/** The section is readable */
#define IMAGE_SCN_MEM_READ 0x40000000
/** The section is writable */
#define IMAGE_SCN_MEM_WRITE 0x80000000

/** Defines a high-low relocation type */
#define IMAGE_REL_BASED_HIGHLOW 3
/** Defines an absolute relocation type (unused by PE loader) */
#define IMAGE_REL_BASED_ABSOLUTE 0

#pragma pack(push, pe, 1)

/**
    Structure representing the DOS stub of a PE
    
    @note Known in MS docs as IMAGE_DOS_HEADER
*/
struct ImageDosHeader_s
{
    uint16 e_magic;
    uint16 e_cblp;
    uint16 e_cp;
    uint16 e_crlc;
    uint16 e_cparhdr;
    uint16 e_minalloc;
    uint16 e_maxalloc;
    uint16 e_ss;
    uint16 e_sp;
    uint16 e_csum;
    uint16 e_ip;
    uint16 e_cs;
    uint16 e_lfarlc;
    uint16 e_ovno;
    uint16 e_res[4];
    uint16 e_oemid;
    uint16 e_oeminfo;
    uint16 e_res2[10];
    uint32 e_lfanew;
};

typedef struct ImageDosHeader_s ImageDosHeader;

/**
    Structure representing a PE file header
    
    @note Known as IMAGE_FILE_HEADER in MS docs
*/
struct ImageFileHeader_s
{
    uint16 Machine;
    uint16 NumberOfSections;
    uint32 TimeDateStamp;
    uint32 PointerToSymbolTable;
    uint32 NumberOfSymbols;
    uint16 SizeOfOptionalHeader;
    uint16 Characteristics;
};

typedef struct ImageFileHeader_s ImageFileHeader;

/**
    Structure representing a PE data directory
    
    @note Known as IMAGE_DATA_DIRECTORY in MS docs
*/
struct ImageDataDirectory_s
{
    uint32 VirtualAddress;
    uint32 Size;
};

typedef struct ImageDataDirectory_s ImageDataDirectory;

/**
    Structure representing a PE optional header
    
    @note Known as IMAGE_OPTIONAL_HEADER in MS docs
    @note DataDirectory can have more or less entries than 16
*/
struct ImageOptionalHeader_s
{
    uint16 Magic;
    uint8 MajorLinkerVersion;
    uint8 MinorLinkerVersion;
    uint32 SizeOfCode;
    uint32 SizeOfInitializedData;
    uint32 SizeOfUninitializedData;
    uint32 AddressOfEntryPoint;
    uint32 BaseOfCode;
    uint32 BaseOfData;
    uint32 ImageBase;
    uint32 SectionAlignment;
    uint32 FileAlignment;
    uint16 MajorOperatingSystemVersion;
    uint16 MinorOperatingSystemVersion;
    uint16 MajorImageVersion;
    uint16 MinorImageVersion;
    uint16 MajorSubsystemVersion;
    uint16 MinorSubsystemVersion;
    uint32 Win32VersionValue;
    uint32 SizeOfImage;
    uint32 SizeOfHeaders;
    uint32 CheckSum;
    uint16 Subsystem;
    uint16 DllCharacteristics;
    uint32 SizeOfStackReserve;
    uint32 SizeOfStackCommit;
    uint32 SizeOfHeapReserve;
    uint32 SizeOfHeapCommit;
    uint32 LoaderFlags;
    uint32 NumberOfRvaAndSizes;
    ImageDataDirectory DataDirectory[16];
};

typedef struct ImageOptionalHeader_s ImageOptionalHeader;

/**
    Structure representing a PE NT header
    
    @note Known as IMAGE_NT_HEADERS in MS docs
*/
struct ImageNtHeaders_s
{
    uint32 Signature;
    ImageFileHeader FileHeader;
    ImageOptionalHeader OptionalHeader;
};

typedef struct ImageNtHeaders_s ImageNtHeaders;

/**
    Struct representing the PE relocation header
    
    @note Known as IMAGE_BASE_RELOCATION in MS docs
*/
struct ImageBaseRelocation_s
{
    uint32 VirtualAddress;
    uint32 SizeOfBlock;
};

typedef struct ImageBaseRelocation_s ImageBaseRelocation;

/**
    Structure for a PE relocation
*/
struct PeRelocation_s
{
    uint16 RelocationOffset :12;
    uint16 RelocationType :4;
};

typedef struct PeRelocation_s PeRelocation;

/**
    Structure representing a PE section header
    
    @note Known as IMAGE_SECTION_HEADER in MS docs
*/
struct ImageSectionHeader_s
{
    uint8 Name[8];
    union
    {
        uint32 PhysicalAddress;
        uint32 VirtualSize;
    } Misc;
    uint32 VirtualAddress;
    uint32 SizeOfRawData;
    uint32 PointerToRawData;
    uint32 PointerToRelocations;
    uint32 PointerToLinenumbers;
    uint16 NumberOfRelocations;
    uint16 NumberOfLinenumbers;
    uint32 Characteristics; /**< Bitmask of section characteristics */
};

typedef struct ImageSectionHeader_s ImageSectionHeader;

// Reuse ImageDataDirectory structure for section data
typedef ImageDataDirectory SectionData;

#pragma pack(pop, pe)

/**
    Returns the number of relocations in the section
    
    @param headerPtr Pointer to the relocation table header
    @param realBase The virtual address the PE is loaded into
    @param proc Pointer to the EPROCESS for the target process
    @param apc Pointer to an APC state storage location
    @return Number of relocations in the table
*/
uint32 peGetNumberOfRelocs(uint8 *peBaseAddr, void *realBase, PEPROCESS proc, PKAPC_STATE apc);

/**
    Calculates the 'delta' between the linked and loaded address for 
    relocations
    
    @param peBaseAddr Pointer to mapped in PE structure
    @param realBase The virtual address the PE is loaded into
    @return Difference between the linked and loaded executable
*/
static uint32 peCalculateRelocDiff(uint8 *peBaseAddr, void *realBase);

/**
    Returns the number of bytes in the PE image
    
    @param peBaseAddr Pointer to the base image address
    @return Number of bytes in PE image
*/
uint32 peGetImageSize(uint8 *peBaseAddr);

/**
    Maps a PE header into memory from a physical address
    
    @note Ensure memory is mapped out with peMapOutImage
    @param physAddr Physical address of PE base
    @return Pointer to mapped in PE image header
*/
uint8 * peMapInImageHeader(PHYSICAL_ADDRESS physAddr);

/**
    Unmaps a PE image from virtual memory
    
    @param peBaseAddr Pointer to the base image address
*/
void peMapOutImageHeader(uint8 *peBaseAddr);

/**
    Prints the sections found in a PE
    
    @param peBaseAddr Pointer to the base image address
*/
void pePrintSections(uint8 *peBaseAddr);

/**
    Returns the number of executable sections in the PE image
    
    @param peBaseAddr Pointer to the base image address
    @return Number of sections marked as executable
*/
uint16 peGetNumExecSections(uint8 *peBaseAddr);

/**
    Populates the passed SectionData array with pointers and sizes to each 
    executable section of the PE
    
    @note The sections array must be allocated by caller using the number
    returned by peGetNumExecSections
    @param peBaseAddr Pointer to the base image address
    @param sections Pointer to array memory location to store the section data
*/
void peGetExecSections(uint8 *peBaseAddr, SectionData *sections);

/**
    Returns a simple checksum of all the executable sections of the passed PE
    
    @param peBaseAddr Pointer to the base image address
    @param realBase The real base address mapped in by the loader
    @param proc Pointer to the EPROCESS for the PE
    @param apc Pointer to an APC state storage location
    @return Simple checksum of the executable sections of the PE
*/
uint32 peChecksumExecSections(uint8 *peBaseAddr, void *realBase, PEPROCESS proc, PKAPC_STATE apc, PHYSICAL_ADDRESS *physArr);

/**
    Returns a simple checksum of all the executable sections of the passed PE using a different physical mapping
    
    @param peBaseAddr Pointer to the base image address
    @param realBase The real base address mapped in by the loader
    @param proc Pointer to the EPROCESS for the PE
    @param apc Pointer to an APC state storage location
    @param physArr Array of physical addresses to use instead of what is in the paging structures
    @return Simple checksum of the executable sections of the PE
*/
uint32 peChecksumBkupExecSections(uint8 *peBaseAddr, void *realBase, PEPROCESS proc, PKAPC_STATE apc, PHYSICAL_ADDRESS *physArr);

#endif  // _MORE_PE_H
```

```c
/**
	@file
	Library to parse & measure PE files
		
	@date 11/14/2011
***************************************************************/
#include "ntifs.h"
#include "Wdm.h"
#include "ntddk.h"
#include "stdint.h"
#include "pe.h"
#include "paging.h"
#include "vmx/procmon.h"

uint32 peGetNumberOfRelocs(uint8 *peBaseAddr, void *realBase, PEPROCESS proc, PKAPC_STATE apc)
{
    ImageDosHeader *dosHeader = NULL;
    ImageNtHeaders *ntHeaders = NULL;
    ImageSectionHeader *sectionHeader = NULL;
    ImageBaseRelocation *relocationPtr = NULL, *bkupRPtr = NULL;
    uint32 numRelocs = 0;
    PageTableEntry *pte = NULL;
    PHYSICAL_ADDRESS phys = {0};
    
    uint16 i, j = 0, execSectionCount = 0, numSections = 0;
    
    dosHeader = (ImageDosHeader *) peBaseAddr;
    ntHeaders = (ImageNtHeaders *) ((uint8 *) peBaseAddr + dosHeader->e_lfanew);
    numSections = ntHeaders->FileHeader.NumberOfSections;
    sectionHeader = (ImageSectionHeader *) &ntHeaders[1];
    
    for (i = 0; i < numSections; i++)
    {
        if(strncmp(sectionHeader[i].Name, ".reloc", 8) == 0)
            break;
    }
    if(strncmp(sectionHeader[i].Name, ".reloc", 8) != 0)
            return 0;
    /*DbgPrint("Found %.08s RVA: %x Characteristics: %x", sectionHeader[i].Name, 
                                                        sectionHeader[i].VirtualAddress,
                                                        sectionHeader[i].Characteristics);*/

    //KeStackAttachProcess(proc, apc);
    pte = pagingMapInPte(targetCR3, (uint8 *) (((uint32) realBase) +
                                sectionHeader[i].VirtualAddress));
    if (pte == NULL)
        return 0;
    phys.LowPart = pte->address << 12;
    pagingMapOutEntry(pte);

    relocationPtr = (ImageBaseRelocation *) MmMapIoSpace(phys,
            PAGE_SIZE,
            0);
    bkupRPtr = relocationPtr;        
    /*DbgPrint("%p + %x = %x", realBase, sectionHeader[i].VirtualAddress, (((uint32) realBase) +
                                sectionHeader[i].VirtualAddress));*/
    i = 0;
    do
    {       
        //DbgPrint("RP: %x %x\r\n", relocationPtr->VirtualAddress, relocationPtr->SizeOfBlock); 
        numRelocs += (relocationPtr->SizeOfBlock - sizeof(*relocationPtr)) / sizeof(uint16);
        relocationPtr = (ImageBaseRelocation *) ((uint8 *) relocationPtr + relocationPtr->SizeOfBlock);
        i++;
    } while(relocationPtr->SizeOfBlock != 0);
    MmUnmapIoSpace(bkupRPtr, PAGE_SIZE);
    //KeUnstackDetachProcess(apc);
   //DbgPrint("I %d\r\n", i);
   
    // Size of the table (minus the header) divided by the size of each entry
    // FIXME Figure out why this is the case
    return numRelocs - (i);
}

static uint32 peCalculateRelocDiff(uint8 *peBaseAddr, void *realBase)
{
    ImageDosHeader *dosHeader = NULL;
    ImageNtHeaders *ntHeaders = NULL;
    uint16 *ptr = (uint16 *) peBaseAddr;
    uint32 imageBase = 0x01000000;
    
    dosHeader = (ImageDosHeader *) peBaseAddr;
    ntHeaders = (ImageNtHeaders *) ((uint8 *) peBaseAddr + dosHeader->e_lfanew);
    // Uncomment for a driver
    //imageBase = ntHeaders->OptionalHeader.ImageBase;
    
    if(((uint32) realBase) > imageBase)
        return ((uint32) realBase) - imageBase;
    return imageBase - ((uint32) realBase);
}

uint32 peGetImageSize(uint8 *peBaseAddr)
{
    ImageDosHeader *dosHeader = NULL;
    ImageNtHeaders *ntHeaders = NULL;
    uint16 *ptr = (uint16 *) peBaseAddr;
    
    dosHeader = (ImageDosHeader *) peBaseAddr;
    ntHeaders = (ImageNtHeaders *) ((uint8 *) peBaseAddr + dosHeader->e_lfanew);

    return ntHeaders->OptionalHeader.SizeOfImage;
}

uint8 * peMapInImageHeader(PHYSICAL_ADDRESS physAddr)
{
    uint8 *pePtr = NULL;
    uint32 imageSize = 0;

    pePtr = MmMapIoSpace(physAddr, PAGE_SIZE, 0);
    if (pePtr == NULL || *pePtr != 'M' || *(pePtr + 1) != 'Z')
    {
        DbgPrint("Invalid physical address!");
        if (pePtr != NULL)
            MmUnmapIoSpace(pePtr, PAGE_SIZE);
        return NULL;
    }
    
    return pePtr;
}

void peMapOutImageHeader(uint8 *peBaseAddr)
{
    MmUnmapIoSpace(peBaseAddr, PAGE_SIZE);
}

uint16 peGetNumExecSections(uint8 *peBaseAddr)
{
    ImageDosHeader *dosHeader = NULL;
    ImageNtHeaders *ntHeaders = NULL;
    ImageSectionHeader *sectionHeader = NULL;
    
    uint16 i, execSectionCount = 0, numSections = 0;
    
    dosHeader = (ImageDosHeader *) peBaseAddr;
    ntHeaders = (ImageNtHeaders *) ((uint8 *) peBaseAddr + dosHeader->e_lfanew);
    numSections = ntHeaders->FileHeader.NumberOfSections;

    sectionHeader = (ImageSectionHeader *) (&ntHeaders[1]);
    
    for (i = 0; i < numSections; i++)
    {
        if (sectionHeader[i].Characteristics & IMAGE_SCN_MEM_EXECUTE &&
            !(strcmp("INIT", sectionHeader[i].Name) == 0)) execSectionCount++;
    }
    
    return execSectionCount;
}

void peGetExecSections(uint8 *peBaseAddr, SectionData *sections)
{
    ImageDosHeader *dosHeader = NULL;
    ImageNtHeaders *ntHeaders = NULL;
    ImageSectionHeader *sectionHeader = NULL;
    
    uint16 i, j = 0, execSectionCount = 0, numSections = 0;
    
    dosHeader = (ImageDosHeader *) peBaseAddr;
    ntHeaders = (ImageNtHeaders *) ((uint8 *) peBaseAddr + dosHeader->e_lfanew);
    numSections = ntHeaders->FileHeader.NumberOfSections;
    sectionHeader = (ImageSectionHeader *) &ntHeaders[1];
    
    for (i = 0; i < numSections; i++)
    {
        if (sectionHeader[i].Characteristics & IMAGE_SCN_MEM_EXECUTE &&
                            !(strcmp("INIT", sectionHeader[i].Name) == 0))
        {
            sections[j].VirtualAddress = sectionHeader[i].VirtualAddress;
            sections[j].Size = sectionHeader[i].Misc.VirtualSize;
            //DbgPrint("Section %.8s is executable", sectionHeader[i].Name);
            j++;
        }
    }
}

void pePrintSections(uint8 *peBaseAddr)
{
    ImageDosHeader *dosHeader = NULL;
    ImageNtHeaders *ntHeaders = NULL;
    ImageSectionHeader *sectionHeader = NULL;
    
    uint16 i, j = 0, execSectionCount = 0, numSections = 0;
    
    dosHeader = (ImageDosHeader *) peBaseAddr;
    ntHeaders = (ImageNtHeaders *) ((uint8 *) peBaseAddr + dosHeader->e_lfanew);
    numSections = ntHeaders->FileHeader.NumberOfSections;
    sectionHeader = (ImageSectionHeader *) &ntHeaders[1];
    
    for (i = 0; i < numSections; i++)
    {
        DbgPrint("Section %d: %.8s VA: %x Size %x", i + 1, sectionHeader[i].Name,
                sectionHeader[i].VirtualAddress, sectionHeader[i].Misc.VirtualSize);
    }
}

uint32 peChecksumExecSections(uint8 *peBaseAddr, 
                              void *realBase, 
                              PEPROCESS proc, 
                              PKAPC_STATE apc, 
                              PHYSICAL_ADDRESS *physArr)
{
    uint16 numExecSections = peGetNumExecSections(peBaseAddr);
    uint32 checksum = 0, k, i, j, 
                        numRelocs = peGetNumberOfRelocs(peBaseAddr, realBase, proc, apc), 
                        relocDelta = peCalculateRelocDiff(peBaseAddr, realBase);
    uint8 *dataPtr = NULL;
    PHYSICAL_ADDRESS phys = {0};
    SectionData *execSections = (SectionData *) MmAllocateNonCachedMemory(
                                                numExecSections * sizeof(SectionData));
    peGetExecSections(peBaseAddr, execSections);
    
    //DbgPrint("Found %d relocations, delta of: %x\r\n", numRelocs, relocDelta);
    
    for (i = 0; i < numExecSections; i++)
    {   
        uint32 numpages = execSections[i].Size / 0x1000, size = execSections[i].Size;
        if (numpages * 0x1000 < execSections[i].Size)
            numpages++;
        for (k = 0; k < numpages; k++)
        {
            KeStackAttachProcess(proc, apc); 
            dataPtr = (uint8 *) MmMapIoSpace(MmGetPhysicalAddress((void *)(((uint32) realBase) +
                        execSections[i].VirtualAddress + (0x1000 * k))),
                        0x1000, 0);
            phys = MmGetPhysicalAddress((void *) dataPtr);

            for (j = 0; j < min(size, 0x1000); j++)
            {
                checksum += dataPtr[j];
            }
            MmUnmapIoSpace((void *) dataPtr, 0x1000);
            size -= 0x1000;
            KeUnstackDetachProcess(apc);
        }
    }
    
    // Subtract the relocations from the checksum
    // TODO Fix incase of lower load address
    checksum += numRelocs * (relocDelta & 0x000000FF);
    checksum += numRelocs * ((relocDelta & 0x0000FF00) >> 8);
    checksum += numRelocs * ((relocDelta & 0x00FF0000) >> 16);
    checksum += numRelocs * ((relocDelta & 0xFF000000) >> 24);
    
    
    MmFreeNonCachedMemory((void *) execSections, numExecSections * sizeof(SectionData));
    return checksum;
}

uint32 peChecksumBkupExecSections(uint8 *peBaseAddr, 
                                  void *realBase, 
                                  PEPROCESS proc, 
                                  PKAPC_STATE apc, 
                                  PHYSICAL_ADDRESS *physArr)
{
    uint16 numExecSections = peGetNumExecSections(peBaseAddr);
    uint32 checksum = 0, k, i, j, 
                        numRelocs = peGetNumberOfRelocs(peBaseAddr, realBase, proc, apc), 
                        relocDelta = peCalculateRelocDiff(peBaseAddr, realBase);
    uint8 *dataPtr = NULL;
    PHYSICAL_ADDRESS phys = {0};
    SectionData *execSections = (SectionData *) MmAllocateNonCachedMemory(
                                                numExecSections * sizeof(SectionData));
    peGetExecSections(peBaseAddr, execSections);
    
    //DbgPrint("Found %d relocations, delta of: %x\r\n", numRelocs, relocDelta);
    
    for (i = 0; i < numExecSections; i++)
    {   
        uint32 numpages = execSections[i].Size / 0x1000, size = execSections[i].Size;
        if (numpages * 0x1000 < execSections[i].Size)
            numpages++;
        for (k = 0; k < numpages; k++)
        {
            dataPtr = (uint8 *) MmMapIoSpace(physArr[(execSections[i].VirtualAddress / PAGE_SIZE) + k],
                        min(size, 0x1000), 0);
            for (j = 0; j < min(size, 0x1000); j++)
            {
                checksum += dataPtr[j];
            }
            MmUnmapIoSpace((void *) dataPtr, min(size, 0x1000));
            size -= 0x1000;
        }
    }
    
    // Subtract the relocations from the checksum
    // TODO Fix incase of lower load address
    checksum += numRelocs * (relocDelta & 0x000000FF);
    checksum += numRelocs * ((relocDelta & 0x0000FF00) >> 8);
    checksum += numRelocs * ((relocDelta & 0x00FF0000) >> 16);
    checksum += numRelocs * ((relocDelta & 0xFF000000) >> 24);
    
    
    MmFreeNonCachedMemory((void *) execSections, numExecSections * sizeof(SectionData));
    return checksum;
}
```



```js
org 0       ; Usamos "org 0" para que las Direcciones Virtuales Relativas (RVAs) sean sencillas.
            ; Esto significa que cuando queremos una Dirección Virtual Absoluta tenemos que
            ; añadir IMAGE_BASE a la RVA (o lo que sea la base de esa sección)

IMAGE_BASE equ 0x400000                                 ; Dirección base de la imagen en memoria (donde se cargará el ejecutable)
SECT_ALIGN equ 0x1000                                   ; Alineación de las secciones en memoria virtual (4096 bytes)
FILE_ALIGN equ 0x200                                    ; Alineación de las secciones en el archivo (512 bytes)

; --- Encabezado MS-DOS ---
msdos_header:
.magic      db 'MZ'                                     ; Marca de identificación del ejecutable MS-DOS (Magic Number)
.cblp       dw 0x0090                                   ; Bytes en la última página del archivo
.cp         dw 0x0003                                   ; Páginas en el archivo
.crlc       dw 0x0000                                   ; Reubicaciones
.cparhdr    dw 0x0004                                   ; Tamaño de la cabecera en párrafos (16 bytes)
.minalloc   dw 0x0000                                   ; Mínimo de párrafos extra necesarios
.maxalloc   dw 0xFFFF                                   ; Máximo de párrafos extra necesarios
.ss         dw 0x0000                                   ; Valor inicial (relativo) de SS (Segmento de Stack)
.sp         dw 0x00B8                                   ; Valor inicial de SP (Puntero de Stack)
.csum       dw 0x0000                                   ; Checksum (Suma de comprobación)
.ip         dw 0x0000                                   ; Valor inicial de IP (Puntero de Instrucción)
.cs         dw 0x0000                                   ; Valor inicial (relativo) de CS (Segmento de Código)
.lfarlc     dw 0x0040                                   ; Dirección del archivo de la tabla de reubicación
.ovno       dw 0x0000                                   ; Número de overlay
.res        dw 0,0,0,0                                  ; Palabras reservadas
.oemid      dw 0x0000                                   ; Identificador OEM
.oeminfo    dw 0x0000                                   ; Información OEM
.res2       times 10 dw 0                               ; Palabras reservadas
.lfanew     dd pe_header                                ; Dirección relativa de la cabecera PE (Portable Executable)

bits 16                                                 ; Cambiamos al modo de 16 bits para el código de MS-DOS
msdos_program:
.entry      push cs                                     ; Guardamos el segmento de código actual en el stack
            pop ds                                      ; Copiamos el segmento de código al segmento de datos
            mov dx, .message - .entry                   ; Calculamos la dirección del mensaje de error
            mov ah, 0x09                                ; Función de DOS para mostrar una cadena terminada en '$'
            int 0x21                                    ; Llamada a la interrupción de DOS
            mov ax, 0x4C01                              ; Función de DOS para terminar el programa con código de error
            int 0x21                                    ; Llamada a la interrupción de DOS
.message    db "This program cannot be run in DOS mode.", 0xD, 0xD, 0xA, '$'
            times 0x80 + msdos_header - $ db 0x00       ; Rellenamos el resto del espacio con ceros


; --- Cabecera PE (Portable Executable) ---
pe_header:
.magic      db 'PE', 0, 0                               ; Marca de identificación del ejecutable PE
.machine    dw 0x8664                                   ; Tipo de máquina: x86-64 (AMD64)
.nsections  dw 3                                        ; Número de secciones en el archivo (código, datos, bss)
.timestamp  dd 0                                        ; Marca de tiempo del archivo (valor predeterminado: 0)
.symtable   dd 0                                        ; Puntero a la tabla de símbolos (obsoleto)
.nsymbols   dd 0                                        ; Número de símbolos (obsoleto)
.opthdrsize dw opt_header.end - opt_header              ; Tamaño de la cabecera opcional
.chrctrstcs dw 0x0022                                   ; Características del archivo:
                                                        ; 0x0002 = IMAGE_FILE_EXECUTABLE_IMAGE (es un ejecutable)
                                                        ; 0x0020 = IMAGE_FILE_LARGE_ADDRESS_AWARE (soporta direcciones > 2GB)
opt_header:
    .magic          dw 0x020B                           ; Magic Number: PE32+ (para ejecutables de 64 bits)
    .linkver        db 0, 0
    .codesize       dd code_section_end - code_section  ; Tamaño de la sección de código
    .datasize       dd data_section_end - data_section  ; Tamaño de la sección de datos inicializados
    .bsssize        dd bss_section_end - bss_section    ; Tamaño de la sección BSS (datos no inicializados)
    .entry          dd main                             ; Dirección relativa del punto de entrada del programa (función main)
    .codebase       dd code_section                     ; Dirección relativa de la sección de código
    .imagebase      dq IMAGE_BASE                       ; Dirección base de la imagen en memoria (0x400000 = 4MB)
    .sectalign      dd SECT_ALIGN                       ; Alineación de las secciones en memoria virtual (4096 bytes)
    .filealign      dd FILE_ALIGN                       ; Alineación de las secciones en el archivo (512 bytes)
    .osver          dw 6, 0                             ; Versión mínima del sistema operativo (Windows Vista)
    .imgver         dw 0, 0                             ; Versión de la imagen
    .subsysver      dw 6, 0                             ; Versión del subsistema (Windows Vista)
    .win32ver       dd 0                                ; Versión Win32
    .sizeimage      dd image_end                        ; Tamaño total de la imagen (alineado a SECT_ALIGN)
    .sizehdrs       dd headers_end                      ; Tamaño de las cabeceras (alineado a FILE_ALIGN)
    .checksum       dd 0                                ; Checksum (suma de verificación) 
    .subsystem      dw 3                                ; Tipo de subsistema: Windows CUI (3 consola) (2 oara gui)
    .dllchars       dw 0x8140                           ; Características de DLL (opcional), 0x0040 = La DLL se puede reubicar en el momento de la carga
                                                        ; 0x0100 = imagen compatible con bit NX compatible
                                                        ; 0x8000 = Terminal server aware
    .stkresv        dq 0x100000                         ; Tamaño reservado para el stack (1MB)
    .stkcommit      dq 0x1000                           ; Tamaño comprometido(commit) para el stack (4KB)
    .heapresv       dq 0x100000                         ; Tamaño reservado para el heap (1MB)
    .heapcommit     dq 0x1000                           ; Tamaño comprometido para el heap (4KB)
    .loaderflgs     dd 0                                ; Flags del cargador
    .nrvasize       dd (.end - .edata)/8                ; Número de entradas en el Data Directory (IMPORT TABLE y IAT)
    .edata          dd 0, 0                             ; Tabla de exportación (no usada en este ejemplo)
    .idata          dd import_table                     ; Dirección relativa de la tabla de importación
                    dd import_table.end - import_table  ; Tamaño de la tabla de importación
    .res            dd 0, 0                             ; Tabla de recursos (no usada en este ejemplo)
    .exn            dd 0, 0                             ; Tabla de excepciones (no usada en este ejemplo)
    .sec            dd 0, 0                             ; Tabla de seguridad (no usada en este ejemplo)
    .reloc          dd 0, 0                             ; Tabla de reubicaciones (no usada en este ejemplo, pero importante para ejecutables robustos)
    .debug          dd 0, 0                             ; Tabla de depuración (no usada en este ejemplo)
    .arch           dd 0, 0                             ; Datos específicos de la arquitectura (no usada en este ejemplo)
    .gp             dd 0, 0                             ; Puntero global (no usada en este ejemplo)
    .tls            dd 0, 0                             ; Tabla TLS (Thread Local Storage - no usada en este ejemplo)
    .lconfig        dd 0, 0                             ; Tabla de configuración de carga (no usada en este ejemplo)
    .bimport        dd 0, 0                             ; Tabla de importación enlazada (no usada en este ejemplo)
    .iat            dd iat                              ; Dirección relativa de la tabla de direcciones de importación (IAT) de Kernel32.dll
                    dd iat.end - iat                    ; Tamaño de la tabla de direcciones de importación (IAT) de Kernel32.dll
    .dimport        dd 0, 0                             ; Descriptor de importación retardada (no usada en este ejemplo)
    .com            dd 0, 0                             ; Descriptor de tiempo de ejecución COM (no usada en este ejemplo)
    .resvd          dd 0, 0                             ; Reservado
.end:

; --- Encabezados de Sección ---
code_section_header:
.name           db ".text",0,0,0                        ; Nombre de la sección: .text (código)
.vsize          dd code_section_end - code_section      ; Tamaño virtual de la sección
.vaddr          dd code_section                         ; Dirección virtual de la sección
.psize          dd code_section_end - code_section      ; Tamaño físico de la sección en el archivo
.paddr          dd code_section                         ; Dirección física de la sección en el archivo
.preloc         dd 0                                    ; Puntero a la tabla de reubicaciones (no usada)
.plines         dd 0                                    ; Puntero a la tabla de números de línea (no usada)
.nreloc         dw 0                                    ; Número de entradas de reubicación
.nlines         dw 0                                    ; Número de entradas de número de línea
.chars          dd 0xE0000020                           ; Características de la sección:
                                                        ; 0x00000020 = IMAGE_SCN_CNT_CODE
                                                        ; 0x20000000 = IMAGE_SCN_MEM_EXECUTE
                                                        ; 0x40000000 = IMAGE_SCN_MEM_READ
                                                        ; 0x80000000 = IMAGE_SCN_MEM_WRITE

data_section_header:
.name           db ".data",0,0,0                        ; Nombre de la sección: .data (datos)
.vsize          dd data_section_end - data_section      ; Tamaño virtual de la sección
.vaddr          dd data_section                         ; Dirección virtual de la sección
.psize          dd data_section_end - data_section      ; Tamaño físico de la sección en el archivo
.paddr          dd data_section                         ; Dirección física de la sección en el archivo
.preloc         dd 0                                    ; Puntero a la tabla de reubicaciones (no usada)
.plines         dd 0                                    ; Puntero a la tabla de números de línea (no usada)
.nreloc         dw 0                                    ; Número de entradas de reubicación
.nlines         dw 0                                    ; Número de entradas de número de línea
.chars          dd 0xC0000040                           ; Características de la sección:
                                                        ; 0x00000040 = IMAGE_SCN_CNT_INITIALIZED_DATA
                                                        ; 0x40000000 = IMAGE_SCN_MEM_READ
                                                        ; 0x80000000 = IMAGE_SCN_MEM_WRITE

bss_section_header:
.name           db ".bss",0,0,0,0                       ; Nombre de la sección: .bss (datos no inicializados)
.vsize          dd bss_section_end - bss_section        ; Tamaño virtual de la sección
.vaddr          dd bss_section                          ; Dirección virtual de la sección
.psize          dd 0 ;1024                              ; Tamaño físico de la sección en el archivo (0 porque no ocupa espacio en disco)
.paddr          dd 0                                    ; Dirección física de la sección en el archivo (0 porque no ocupa espacio en disco)
.preloc         dd 0                                    ; Puntero a la tabla de reubicaciones (no usada)
.plines         dd 0                                    ; Puntero a la tabla de números de línea (no usada)
.nreloc         dw 0                                    ; Número de entradas de reubicación
.nlines         dw 0                                    ; Número de entradas de número de línea
.chars          dd 0xC0000080                           ; Características de la sección:
                                                        ; 0x80 = IMAGE_SCN_CNT_UNINITIALIZED_DATA (contiene datos no inicializados)
                                                        ; 0x40000000 = IMAGE_SCN_MEM_READ (se puede leer)
                                                        ; 0x80000000 = IMAGE_SCN_MEM_WRITE (se puede escribir)

.end            align FILE_ALIGN                        ; Alineamos al tamaño de alineación de archivos
headers_end:    align SECT_ALIGN                        ; Alineamos al tamaño de alineación de secciones

; --- Tablas de Importación ---
code_section:                                           ; Marca el inicio de la sección de código
import_table:                                           ; Tabla de Directorio de Importación (Import Directory Table)

    dd ilt                                              ; RVA a la ILT (Import Lookup Table) para Kernel32.dll
    dd 0                                                ; TimeDateStamp (Marca de tiempo)
    dd 0                                                ; ForwarderChain
    dd names.kernel32_dll                               ; RVA al nombre de la DLL (Kernel32.dll)
    dd iat                                              ; RVA a la IAT (Import Address Table) para Kernel32.dll

    dd ilt_user32                                       ; RVA a la ILT (Import Lookup Table) para User32.dll
    dd 0                                                ; TimeDateStamp (Marca de tiempo)
    dd 0                                                ; ForwarderChain
    dd names.user32_dll                                 ; RVA al nombre de la DLL (User32.dll)
    dd iat_user32                                       ; RVA a la IAT (Import Address Table) para User32.dll

    dd 0, 0, 0, 0, 0                                    ; Null terminator para la tabla de directorio de importación
.end            align 8                                 ; Marca el final de la tabla de importación


                                                        ; Import Lookup Table (ILT) para Kernel32.dll
ilt:
    .ExitProcess    dq names.ExitProcess                ; Dirección de la función ExitProcess
    .CreateFileA    dq names.CreateFileA                ; Dirección de la función CreateFileA
    .WriteFile      dq names.WriteFile                  ; Dirección de la función WriteFile
    .null           dq 0                                ; Terminador null
    .end            align 8

                                                        ; Import Address Table (IAT) para Kernel32.dll
iat:
    dq names.ExitProcess                                ; Marcador de posición para la dirección de ExitProcess
    dq names.CreateFileA                                ; Marcador de posición para la dirección de CreateFileA
    dq names.WriteFile                                  ; Marcador de posición para la dirección de WriteFile
.end            align 8

                                                        ; Import Lookup Table (ILT) para User32.dll
ilt_user32:
    dq names.MessageBoxA                                ; Dirección de la función MessageBoxA
    dq 0                                                ; Terminador nullr
.end            align 8

                                                        ; Import Address Table (IAT) para User32.dll
iat_user32:
    dq names.MessageBoxA                                ; Marcador de posición para la dirección de MessageBoxA
.end            align 8

names:
    .kernel32_dll db "kernel32.dll", 0                  ; Nombre de la DLL Kernel32.dll
    .ExitProcess db 0, 0, "ExitProcess", 0              ; Nombre de la función ExitProcess
    .CreateFileA db 0, 0, "CreateFileA", 0              ; Nombre de la función CreateFileA
    .WriteFile db 0, 0, "WriteFile", 0                  ; Nombre de la función WriteFile

    .user32_dll db "user32.dll", 0
    .MessageBoxA db 0, 0, "MessageBoxA", 0              ; Nombre de la función MessageBoxA
.end            align 8

bits 64                                                 ; Cambiamos al modo de 64 bits para el código principal

; --- Código Principal ---
main:
    sub rsp, 40                                         ; Reservamos espacio en el stack (shadow space) para la llamada a MessageBoxA

                                                        ; MessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType);
    xor rcx, rcx                                        ; hWnd = NULL
    lea rdx, [rel message]                              ; lpText
    lea r8, [rel caption]                               ; lpCaption
    xor r9, r9                                          ; uType = MB_OK
    call qword [rel iat_user32]                         ; Call MessageBoxA through the IAT

                                                        ; ExitProcess(UINT uExitCode);
    xor ecx, ecx                                        ; uExitCode = 0
    call qword [rel iat]                                ; Llamamos a ExitProcess a través de la IAT para terminar el programa


align FILE_ALIGN                                        ; Alineamos al tamaño de alineación de archivos
code_section_end:                                       ; Marca el final de la sección de código

align SECT_ALIGN                                        ; Alineamos al tamaño de alineación de secciones
data_section:                                           ; Marca el inicio de la sección de datos
    message db "Hello, World!", 0                       ; Mensaje a mostrar
    caption db "Message", 0                             ; Título de la ventana

align FILE_ALIGN                                        ; Alineamos al tamaño de alineación de archivos
data_section_end:                                       ; Marca el final de la sección de datos

align SECT_ALIGN                                        ; Alineamos al tamaño de alineación de secciones
bss_section:                                            ; Marca el inicio de la sección BSS
    buffer resb 1024                                    ; Reserva de 1024 bytes para el buffer (no ocupa espacio en disco)
align FILE_ALIGN                                        ; Alineamos al tamaño de alineación de archivos
bss_section_end:                                        ; Marca el final de la sección BSS

align SECT_ALIGN                                        ; Alineamos al tamaño de alineación de secciones
image_end:                                              ; Marca el final de la imagen

```