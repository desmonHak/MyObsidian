Generalmente, un programa utilizará las funciones proporcionadas sin que el desarrollador tenga que implementar toda la funcionalidad. Incluso si su función está incluida en una biblioteca proporcionada por un tercero, utilizará internamente funciones API proporcionadas por el sistema operativo. Por supuesto, muchos programas se desarrollan utilizando funciones API directas, como el malware.

De todos modos, a menos que enlace estáticamente la biblioteca que contiene las funciones que utiliza, importe la DLL y obtenga y llame a la dirección de las funciones necesarias. Para esto, sin duda necesitarás algunas cosas básicas como [[PE]] y una tabla de importación, así que vamos a suponer que estás familiarizado con ello.

Las API utilizadas también se usan en el análisis estático porque podemos predecir cómo funcionará el malware a través de las funciones que importa. Por supuesto, si el malware está empaquetado, puede interferir con este análisis estático utilizando las funciones ``LoadLibrary()`` y ``GetProcAddress()`` para obtener las direcciones de las API a utilizar durante la ejecución.

Esta sección describe cómo encontrar la dirección de una función API sin siquiera las dos funciones anteriores, es decir, sin ninguna llamada a la API. Este enfoque parece ser usado frecuentemente en shellcode, y un mecanismo similar fue usado en el protector llamado PEspin.

El campo [[Ldr]] del [[PEB]] es un puntero a la estructura [[PEB#^0195c6|PEB_LDR_DATA]] que se encuentra en el offset ``0xC`` del [[PEB]]. Esta estructura proporciona información sobre el módulo cargado. En detalle, el campo ``0x1C`` indica un ``InInitializationOrderModuleList``, es decir, una lista (``_LIST_ENTRY``) configurada en el orden de módulo inicializado como PEB-> ``Ldr.InInitializationOrderModuleList.Flink``. Para tu información, cada estructura de la lista es ``_LDR_MODULE``, el primer campo es ``NextModule``, e indica la siguiente lista. El campo situado en el offset ``0x8`` es la ``BaseAddress`` del módulo y el offset ``0x20`` es un puntero al nombre del módulo almacenado como cadena Unicode.

Ahora analicemos las rutinas relacionadas sucesivamente, utilizando el resumen anterior.

```c
MOV EAX, DWORD PTR FS:[0x30]  
// EAX contiene la dirección de la PEB
MOV EAX, DWORD PTR DS:[EAX+0x0C]  
// EAX contiene la dirección de la estructura 
MOV ESI, DWORD PTR DS:[EAX+0x1C]  
// ESI es la dirección de PEB-> Ldr.InInitializationOrderModuleList.Flink.  
MOV EAX, PTR DS:[ESI+0x20]  
// EAX contiene la dirección del nombre del módulo en forma de su cadena Unicode. Puedes usar este nombre para comparar y encontrar la DLL que quiera.  
MOV ESI, PTR DS:[ESI]  
MOV EAX, PTR DS:[ESI+0x20]  
//  tu información, si ESI es PEB-> Ldr.InInitializationOrderModuleList.Flink, la dirección contiene un valor que apunta al siguiente _LDR_MODULE de la lista. Así, cuando se usa como arriba, ESI apuntará al nuevo módulo. A continuación, añada 0x20 para obtener la dirección del nombre del nuevo módulo. En otras palabras, puede guardar la dirección y hacer un bucle a través de la lista para obtener el nombre..
```

Consulta el offset de los miembros del [[PEB]] [[PEB#^ab1f70@|aqui]].
De esta forma podemos obtener el nombre de la DLL que queremos, y si el nombre es el mismo, necesitamos obtener la ``BaseAddress``. Esto se puede obtener con la siguiente instrucción:

```c
MOV EAX, PTR DS:[ESI+0x8]
; Si el ESI es PEB-> Ldr.InInitializationOrderModuleList.Flink, la BaseAddress es el offset 0x8. Como referencia, el offset 0x20 era un puntero a una cadena que representaba un nombre.
```

Ahora que tienes la ``BaseAddress`` del módulo, busca la tabla Export, y encuentra el nombre de la función API que encuentras en la tabla ``AddressOfNames``, y finalmente la dirección de la función API en la tabla ``AddressOfFunctions``. Y cuando la dirección de tipo RVA se convierte en tipo VA, se obtiene la dirección de la función API.

## Resumen sobre Estructuras

- TEB 
```c
	0x30 : PEB
```

- PEB
```c
	0x0C : PEB_LDR_DATA
```

- PEB_LDR_DATA
```c
	0x0C : ?? ( InLoadOrderModuleList )
	0x14 : ?? ( InMemoryOrderModuleList )
	0x1C : LDR_MODULE ( InInitializationOrderModuleList )
```

^69e479

En primer lugar, voy a explicar sobre la base de [[ntrtl#^d1a615|InInitializationOrderModuleList]] que es el más utilizado.

- [[#^69e479|LDR_MODULE]] ( [[ntrtl#^d1a615|InInitializationOrderModuleList]] ) ( ntdll.dll -> kernelbase.dll -> kernel32.dll ): ^9b8c82
```c
0x00 : Módulo siguiente
0x04 : Módulo anterior
0x08 : ImgBase
0x0C : EP
0x10 : Tamaño de Img
0x20 : Nombre
```

Offset ``0x30`` en [[TEB]] significa [[PEB]]. ``0x0C`` en [[PEB]] significa estructura [[PEB#^0195c6|PEB_LDR_DATA]]. ``0x1C`` en la estructura [[PEB#^0195c6|PEB_LDR_DATA]] apunta a  [[ntrtl#^d1a615|InInitializationOrderModuleList]].

Para ser precisos, cierta estructura se enlaza en listas enlazadas para propósitos específicos. No he podido encontrar el nombre y la estructura completa sobre cada una de las estructuras enlazadas por la lista enlazada, pero simplemente la llamaré [[ntwmi#^3d0768|LDR_MODULE]].

La primera es típicamente usada pero los offsets ``0x0C`` y ``0x14`` de [[PEB#^0195c6|PEB_LDR_DATA]] también pueden ser usados. Empecemos con ``0x0C``, [[ntpsapi#^ba4f49|InLoadOrderModuleList]]. Esta estructura está marcada con un signo de interrogación porque su nombre es desconocido.

- ?? ( [[ntpsapi#^ba4f49|InLoadOrderModuleList]] ) ( Binario -> ntdll.dll -> kernel32.dll -> kernelbase.dll )
```c
0x00 : Módulo siguiente
0x04 : Módulo anterior
0x18 : ImgBase
0x1C : EP
0x20 : Tamaño de Img
0x30 : Nombre
```

Este es un orden de carga a diferencia del anterior, por lo que se puede ver que el binario es el primero.

A continuación veremos ``0x14``, [[ntpsapi#^ba4f49|InMemoryOrderModuleList]].
- ?? ( [[ntpsapi#^ba4f49|InMemoryOrderModuleList]] )  ( Binary -> ntdll.dll -> kernel32.dll -> kernelbase.dll )
```c
0x00 : Módulo siguiente
0x04 : Módulo anterior
0x10 : ImgBase  
0x14 : EP  
0x18 : Tamaño de Img
0x20 : Path
```

El orden es el mismo que antes. Sin embargo, la diferencia es que el valor de 0x20 no es el nombre simple, sino el nombre de la ruta del módulo.