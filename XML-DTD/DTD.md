https://www.mclibre.org/consultar/xml/lecciones/xml-dtd.html

[[XML-DTD/Ejemplo1|Ejemplo1]]
## Referencia a una [[DTD]] en un documento XML

La [[DTD]] que debe utilizar el procesador ``XML`` para validar el documento ``XML`` se indica mediante la etiqueta ``DOCTYPE``. La [[DTD]] puede estar incluida en el propio documento, ser un documento externo o combinarse ambas.

- La [[DTD]] puede incluirse en el propio documento, con la siguiente sintaxis:
```dtd
<!DOCTYPE nombre [
     ... declaraciones ...
]>
```
   
- La [[DTD]] puede estar en un documento externo y, si sólo va a ser utilizada por una única aplicación, la sintaxis es la siguiente:
```dtd
<!DOCTYPE nombre SYSTEM "uri">
```

Se puede combinar una [[DTD]] externa con una [[DTD]] interna, con la siguiente sintaxis:

```dtd
<!DOCTYPE nombre SYSTEM "uri" [
	... declaraciones ...
]>
```

- La [[DTD]] puede estar en un documento externo y, si va a ser utilizada por varias aplicaciones, la sintaxis es la siguiente:
```dtd
<!DOCTYPE nombre PUBLIC "fpi" "uri">
```

Se puede combinar una [[DTD]] externa con una [[DTD]] interna, con la siguiente sintaxis:
```dtd
<!DOCTYPE nombre PUBLIC "fpi" "uri" [
	... declaraciones ...
]>
```

En todos estos casos:

- "``nombre``" es el nombre del tipo de documento ``XML``, que debe coincidir con el nombre del elemento raíz del documento ``XML``.
- "``uri``" es el camino (absoluto o relativo) hasta la [[DTD]].
- "``fpi``" es un identificador público formal (``Formal Public Identifier``).

---
## Declaraciones

Las [[DTD]]s describen la estructura de los documentos ``XML`` mediante declaraciones. Hay cuatro tipos de declaraciones:

- [Declaraciones de entidades](https://www.mclibre.org/consultar/xml/lecciones/xml-dtd.html#ddiv-declaracion-entidades), [[Declaraciones de entidades]]
- [Declaraciones de notaciones](https://www.mclibre.org/consultar/xml/lecciones/xml-dtd.html#ddiv-declaracion-notaciones), [[Declaraciones de notaciones]]
- [Declaraciones de elementos](https://www.mclibre.org/consultar/xml/lecciones/xml-dtd.html#ddiv-declaracion-elementos), [[Declaración de elementos]], que indican los elementos permitidos en un documento y su contenido (que puede ser simplemente texto u otros elementos).
- [Declaraciones de atributos](https://www.mclibre.org/consultar/xml/lecciones/xml-dtd.html#ddiv-declaracion-atributos), , que indican los atributos permitidos en cada elemento y el tipo o valores permitidos de cada elemento.