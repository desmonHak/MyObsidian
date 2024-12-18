https://stackoverflow.com/questions/45270994/why-is-the-x86-cr1-control-register-reserved
https://www.pagetable.com/?p=364
A partir de la ``CPU i386``, los procesadores ``Intel`` han expuesto ``registros de control`` para **permitir al kernel configurar el procesador** y especificar características de la **tarea/proceso/hilo** que se está ejecutando en ese momento. Según el Manual de [Intel Systems Programming Manual](https://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-system-programming-manual-325384.html) (``section 2-13``) el registro de control [[CR1]] está «``Reservado``». Es decir, el kernel manipulando el registro de control [[CR1]] resulta en un comportamiento indefinido. Como indican los artículos, también existen los registros de control [[CR2]], [[CR3]], [[CR4]] y [[CR8]], aunque no están reservados.

¿Por qué está reservado [[CR1]]? Es extraño que Intel introdujera un registro de control reservado, y después empezara a añadir registros de control no reservados en lugar de simplemente añadir funcionalidad a [[CR1]], ya que hacerlo no causaría ninguna ruptura de retrocompatibilidad (ese es el objetivo de mantenerlo reservado). http://www.pagetable.com/?p=364 especula que [[CR1]] se mantuvo reservado para tener un segundo registro disponible para la configuración de la arquitectura, pero como menciona el artículo, [[CR4]] se utilizó en su lugar cuando se introdujo el ``i486.``


El Manual _[intel® 64 and IA-32 Architectures Software Developer’s Manual](https://software.intel.com/en-us/articles/intel-sdm)_ dice [[CR1]] - Reservado. Así que [[CR1]] no se utiliza y está reservado a ``Intel + AMD`` para uso futuro. Dado que está reservado, el acceso a [[CR1]] lanza una excepción:

Los intentos de referenciar [[CR1]], [[CR5]], [[CR6]], [[CR7]], y [[CR9]]-[[CR15]] resultan en excepciones de opcode indefinido (``#UD``).

Por qué no han utilizado [[CR1]] cuando han utilizado [[CR2]] es una incógnita. ``X86`` es irregular y, de hecho, Intel no ha dicho nada. Este artículo [¿Por qué no hay CR1 - y por qué los registros de control son un desastre de todos modos?](https://www.pagetable.com/?p=364)? tiene algo de historia, pero realmente a menos que Intel diga algo oficial, y no lo han hecho, no hay respuesta.
