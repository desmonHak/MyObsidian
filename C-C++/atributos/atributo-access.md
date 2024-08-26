`access (access-mode, ref-index)`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-access-function-attribute)

`access (access-mode, ref-index, size-index)`

El atributo `access` permite la detección de accesos inválidos o inseguros por parte de las funciones a las que se aplican o sus invocadores, así como accesos de sólo escritura a objetos de los que nunca se lee. Estos accesos pueden diagnosticarse mediante advertencias como ``-Wstringop-overflow``, ``-Wuninitialized``, ``-Wunused`` y otras.

El atributo `access` especifica que una función a cuyos argumentos ``by-reference`` se aplica el atributo accede al objeto referenciado según ``access-mode``. El argumento ``access-mode`` es obligatorio y debe ser uno de los cuatro siguientes: `read_only`, `read_write`, `write_only`, o `none`. Los otros dos son argumentos posicionales.


El argumento posicional opcional ``size-index`` denota un argumento de función de tipo entero que especifica el tamaño máximo del acceso. El tamaño es el número de elementos del tipo referenciado por ``ref-index``, o el número de bytes cuando el tipo de puntero es `void*`. Cuando no se especifica el argumento ``size-index``, el argumento puntero debe ser nulo o apuntar a un espacio que esté adecuadamente alineado y sea grande para al menos un objeto del tipo referenciado (esto implica que un puntero pasado no es un argumento válido). El tamaño real del acceso puede ser menor, pero no mayor.

El modo de acceso `read_only` especifica que el puntero al que se aplica se utiliza para leer el objeto referenciado pero no para escribir en él. A menos que el argumento que especifica el tamaño del acceso denotado por ``size-index`` sea cero, el objeto referenciado debe ser inicializado. El modo implica una garantía mayor que el calificador `const` que, cuando se desecha un puntero, no impide que el objeto apuntado sea modificado. Ejemplos del uso del modo de acceso `read_only` son el argumento de la función `puts`, o el segundo y tercer argumento de la función `memcpy`.
```c
__attribute__ ((access(read_only, 1))) 
	int puts (const char*);

__attribute__ ((access(read_only, 2, 3)))
	void* memcpy (void*, const void*, size_t);
```

El modo de acceso ``read_write`` se aplica a los argumentos de los tipos de puntero sin el calificador ``const``. Especifica que el puntero al que se aplica se utiliza tanto para leer como para escribir el objeto al que se hace referencia. A menos que el argumento que especifica el tamaño del acceso indicado por ``size-index`` sea cero, el objeto al que hace referencia el puntero debe inicializarse. Un ejemplo del uso del modo de acceso ``read_write`` es el primer argumento de la función ``strcat``.

```c
__attribute__ ((access(read_write, 1), access(read_only, 2)))
	char* strcat (char*, const char*);
```
El modo de acceso ``write_only`` se aplica a los argumentos de los tipos de puntero sin el calificador ``const``. Especifica que el puntero al que se aplica se utiliza para escribir en el objeto referenciado, pero no para leerlo. No es necesario inicializar el objeto al que hace referencia el puntero. Un ejemplo del uso del modo de acceso ``write_only`` es el primer argumento de la función ``strcpy`` o los dos primeros argumentos de la función ``fgets``.

```c
__attribute__ ((access(write_only, 1), access (read_only, 2)))
	char* strcpy (char*, const char*);

__attribute__ ((access(write_only, 1, 2), access (read_write, 3)))
	int fgets (char*, int, FILE*);
```
El modo de acceso ``none`` especifica que el puntero al que se aplica no se utiliza para acceder al objeto referenciado. A menos que el puntero sea nulo, el objeto al que se apunta debe existir y tener al menos el tamaño indicado por el argumento ``size-index``. Cuando se omite el argumento ``size-index`` opcional para un argumento de tipo ``void*``, se ignora el argumento puntero real. No es necesario inicializar el objeto referenciado. El modo está pensado para utilizarse como un medio para ayudar a validar el tamaño de objeto esperado, por ejemplo, en funciones que llaman a ``__builtin_object_size``. Consulte Comprobación del tamaño de objetos.

Tenga en cuenta que el atributo de acceso simplemente especifica cómo se puede acceder a un objeto al que se hace referencia mediante el argumento puntero; no implica que se producirá un acceso. Además, el atributo de acceso no implica que el atributo sea ``nonnull``; puede ser adecuado agregar ambos atributos en la declaración de una función que manipula incondicionalmente un búfer a través de un argumento puntero. Consulte el atributo ``nonnull`` para obtener más información y advertencias.