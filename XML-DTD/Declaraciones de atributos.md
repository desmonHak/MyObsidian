Una declaración de atributos sigue la siguiente sintaxis:

```dtd
<!ATTLIST nombreElemento nombreAtributo tipoAtributo valorInicialAtributo >
```

en la que:
- "``nombreElemento``" es el nombre del elemento para el que se define un atributo.
- "``nombreAtributo``" es el nombre del atributo.
- "``tipoAtributo``" es el tipo de datos.
- "``valorInicialAtributo``" es el valor predeterminado del atributo (aunque también puede indicar otras cosas).

Para definir varios atributos de un mismo elemento, se puede utilizar una o varias declaraciones de atributos. Los siguientes ejemplos son equivalentes:

```dtd
<!ATTLIST nombreElemento nombreAtributo1 tipoAtributo1 valorInicialAtributo1>
<!ATTLIST nombreElemento nombreAtributo2 tipoAtributo2 valorInicialAtributo2>
```

```dtd
<!ATTLIST nombreElemento
  nombreAtributo1 tipoAtributo1 valorInicialAtributo1
  nombreAtributo2 tipoAtributo2 valorInicialAtributo2
>
```

---

Los tipos de atributos son los siguientes:

- **CDATA**: el atributo contiene caracteres (sin restricciones).
 
```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color CDATA #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="amarillo" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="azul marino #000080" />
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo />                           <!-- ERROR: falta el atributo "color", obligatorio debido al #REQUIRED -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo sabor="dulce" />             <!-- ERROR: el atributo "sabor" no está definido -->
```

- **NMTOKEN**: el atributo sólo contiene letras, dígitos, y los caracteres punto ".", guion "-", subrayado "_" y dos puntos ":".

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color NMTOKEN #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="azul-marino" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="1" />
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo color="azul marino" />                   <!-- ERROR: hay un espacio en blanco -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo color="#F0F0F0" />                       <!-- ERROR: contiene el carácter # -->
```
---

- **NMTOKENS**: el atributo sólo contiene letras, dígitos, y los caracteres punto ".", guion "-", subrayado "_", dos puntos ":" (como el tipo NMTOKEN) y también espacios en blanco.



```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color NMTOKENS #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="1" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="azul marino" />
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo color="2*2" />                           <!-- ERROR: hay un asterisco -->
```
---
- **valores**: el atributo sólo puede contener uno de los términos de una lista. La lista se escribe entre paréntesis, con los términos separados por una barra vertical "|".

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color (azul|blanco|rojo) #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="azul" />
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo color="verde" />                         <!-- ERROR: "verde" no está en la lista de valores -->
```
---
- **ID**: el valor del atributo (no el nombre) debe ser único y no se puede repetir en otros elementos o atributos.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo (libro*)>
  <!ELEMENT libro (#PCDATA) >
  <!ATTLIST libro codigo ID #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <libro codigo="L2">Los preceptos de Ptah-Hotep</libro>
</ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo>
  <libro codigo="1">Poema de Gilgamesh</libro>            <!-- ERROR: el valor de un atributo de tipo ID no puede empezar con un número -->
  <libro codigo="L2">Los preceptos de Ptah-Hotep</libro>
</ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <libro codigo="L1">Los preceptos de Ptah-Hotep</libro>  <!-- ERROR: no se puede repetir un atributo de tipo ID -->
</ejemplo>
```

---
- **IDREF**: el valor del atributo debe coincidir con el valor del atributo ID de otro elemento.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo ((libro|prestamo)*)>
  <!ELEMENT libro (#PCDATA) >
  <!ATTLIST libro codigo ID #REQUIRED>
  <!ELEMENT prestamo (#PCDATA) >
  <!ATTLIST prestamo libro IDREF #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <prestamo libro="L1">Numa Nigerio</prestamo>
</ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <prestamo libro="L2">Numa Nigerio</prestamo>            <!-- ERROR: el valor "L2" no es ID de ningún elemento -->
</ejemplo>
```

---
- **IDREFS**: el valor del atributo es una serie de valores separados por espacios que coinciden con el valor del atributo ID de otros elementos.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo ((libro|prestamo)*)>
  <!ELEMENT libro (#PCDATA) >
  <!ATTLIST libro codigo ID #REQUIRED>
  <!ELEMENT prestamo (#PCDATA) >
  <!ATTLIST prestamo libro IDREFS #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <libro codigo="L2">Los preceptos de Ptah-Hotep</libro>
  <prestamo libro="L1 L2">Numa Nigerio</prestamo>
</ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <libro codigo="L2">Los preceptos de Ptah-Hotep</libro>
  <prestamo libro="L1">Numa Nigerio</prestamo>
</ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo>
  <libro codigo="L1">Poema de Gilgamesh</libro>
  <libro codigo="L2">Los preceptos de Ptah-Hotep</libro>
  <prestamo libro="L3">Numa Nigerio</prestamo>            <!-- ERROR: el valor "L3" no es ID de ningún elemento -->
</ejemplo>
```

- **ENTITY**: el valor del atributo es alguna entidad definida en la DTD.
- **ENTITIES**: el valor del atributo es alguna de las entidades de una lista de entidades definida en la DTD.
- **NOTATION**: el valor del atributo es alguna notación definida en la DTD.

---

Los valores iniciales de los atributos son los siguientes:

- **#REQUIRED**: el atributo es obligatorio, aunque no se especifica ningún valor predeterminado.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color CDATA #REQUIRED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="amarillo" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="azul marino #000080" />
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo />                                       <!-- ERROR: falta el atributo "color" -->
```

---
- **#IMPLIED**: el atributo no es obligatorio y no se especifica ningún valor predeterminado.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color CDATA #IMPLIED>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="amarillo" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="azul marino #000080" />
```
---
- **#FIXED valor**: el atributo tiene un valor fijo.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color CDATA #FIXED "verde">
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="verde" />
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo color="" />                              <!-- ERROR: el atributo "color" no tiene el valor "verde" -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo color="amarillo" />                      <!-- ERROR: el atributo "color" no tiene el valor "verde" -->
```

---
- **valor**: el atributo tiene un valor predeterminado.

```dtd
<!DOCTYPE ejemplo [
  <!ELEMENT ejemplo EMPTY>
  <!ATTLIST ejemplo color CDATA "verde">
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="amarillo" />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo color="verde" />
```