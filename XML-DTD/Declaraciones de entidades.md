### Declaración de entidades

Una entidad consiste en un nombre y su valor (son similares a las constantes en los lenguajes de programación). Con algunas excepciones, el procesador XML sustituye las referencias a entidades por sus valores antes de procesar el documento. Una vez definida la entidad, se puede utilizar en el documento escribiendo una referencia a la entidad, que empieza con el carácter "``&``", sigue con el nombre de la entidad y termina con "``;``". (es decir, ``&nombreEntidad;``)

Las entidades pueden ser internas o externas y tanto unas como otras pueden ser generales o paramétricas.

Las declaraciones de entidades internas (generales) siguen la siguiente sintaxis:

```xml
<!ENTITY nombreEntidad "valorEntidad">
```

En las declaraciones de entidades externas (generales) se distinguen dos casos:

- La entidad hace referencia a un fichero de texto y en ese caso la entidad se sustituye por el contenido del archivo.
    
    La entidad puede ser una entidad de sistema, con la siguiente sintaxis:
    
    ```xml
    <!ENTITY nombreEntidad SYSTEM "uri">
    ```
    
    o puede ser una entidad pública, con la siguiente sintaxis:
    
    ```xml
    <!ENTITY nombreEntidad PUBLIC "fpi" "uri">
    ```
    
- La entidad hace referencia a un fichero que no es de texto (por ejemplo, una imagen) y en ese caso la entidad no se sustituye por el contenido del archivo.
    
    La entidad puede ser una entidad de sistema, con la siguiente sintaxis:
    
    ```xml
    <!ENTITY nombreEntidad SYSTEM "uri" NDATA tipo>
    ```
    
    o puede ser una entidad pública, con la siguiente sintaxis:
    
    ```xml
    <!ENTITY nombreEntidad PUBLIC "fpi" "uri" NDATA tipo>
    ```
    

En todos estos casos:

- "nombreEntidad" es el nombre de la entidad.
- "valorEntidad" es el valor de la entidad.
- "uri" es el camino (absoluto o relativo) hasta un archivo.
- "tipo" es el tipo de archivo (gif, jpg, etc).
- "fpi" es un identificador público formal (Formal Public Identifier).

Las declaraciones de entidades paramétricas siguen la mismas sintaxis que las generales, pero llevan el carácter "%" antes del nombre de la entidad. Por ejemplo:

```xml
<!ENTITY % nombreEntidad "valorEntidad">
```

```xml
<!ENTITY % nombreEntidad SYSTEM "uri">
```

```xml
<!ENTITY % nombreEntidad SYSTEM "uri" NDATA tipo>
```

---

La diferencia entre entidades generales y paramétricas es que las entidades paramétricas se sustituyen por su valor en todo el documento (incluso en la propia declaración de tipo de documento) mientras que las generales no se sustituyen en la declaración de tipo de documento.