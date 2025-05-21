### Declaración de elementos

Las declaraciones de los elementos siguen la siguiente sintaxis:

```dtd
<!ELEMENT nombreElemento (contenido)>
```

en la que "``nombreElemento``" es el nombre del elemento, y "(``contenido``)" una expresión que describe el contenido del elemento.

Para definir el contenido del elemento se pueden utilizar los términos ``EMPTY``, (``#PCDATA``) o ``ANY`` o escribir expresiones más complejas:

- **``EMPTY``**: significa que el elemento es vacío, es decir, que no puede tener contenido. Los elementos vacíos pueden escribirse con etiquetas de apertura y cierre sin nada entre ellos, ni siquiera espacios, o con una etiqueta vacía. EMPTY debe escribirse sin paréntesis.

```dtd
<!DOCTYPE ejemplo [
	<!ELEMENT ejemplo EMPTY>
]>
```

----
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo></ejemplo>
```
----
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo />
```
----
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo>Esto es un ejemplo</ejemplo>                     <!-- ERROR: contiene texto -->
```
----
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><a></a></ejemplo>                                <!-- ERROR: contiene un elemento <a> -->
```
----

- **(``#PCDATA``)**: significa que el elemento puede contener texto. ``#PCDATA`` debe escribirse entre paréntesis.

```dtd
<!DOCTYPE ejemplo [
	<!ELEMENT ejemplo (#PCDATA)>
]>
```

----
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")    
```xml
<ejemplo />
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo>Esto es un ejemplo</ejemplo>
```
----
- **``ANY``**: significa que el elemento puede contener cualquier cosa (texto y otros elementos). ``ANY`` debe escribirse sin paréntesis.

```dtd
<!DOCTYPE ejemplo [
	<!ELEMENT ejemplo ANY>
	<!ELEMENT a ANY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo>Esto es <a>un ejemplo</a></ejemplo>
```
---
Para indicar que un elemento puede o debe contener otros elementos se deben indicar los elementos, utilizando los conectores y modificadores siguientes:
- **``,`` (coma)**: significa que el elemento contiene los elementos en el orden indicado.
```dtd
<!DOCTYPE ejemplo [
      <!ELEMENT ejemplo (a, b)>
      <!ELEMENT a EMPTY>
      <!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a/><b/></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><a/><b/><c/></ejemplo>                        <!-- ERROR: contiene un elemento <c /> -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><a /></ejemplo>                                  <!-- ERROR: falta el elemento <b /> -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><b /><a /></ejemplo>                             <!-- ERROR: el orden no es correcto -->
    ```
---
- **``|`` (o lógico)**: significa que el elemento contiene uno de los dos elementos.
```dtd
<!DOCTYPE ejemplo [
	<!ELEMENT ejemplo (a | b)>
	<!ELEMENT a EMPTY>
	<!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a/></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><b/></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><a/><b/></ejemplo>                              <!-- ERROR: están los dos elementos -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo></ejemplo>                                        <!-- ERROR: no hay ningún elemento -->
```
---
- **``?``**: significa que el elemento puede aparecer o no, pero sólo una vez.
```dtd
<!DOCTYPE ejemplo [
      <!ELEMENT ejemplo (a, b?)>
      <!ELEMENT a EMPTY>
      <!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a /></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a /><b /></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><b/></ejemplo>                                  <!-- ERROR: falta el elemento <a/> -->
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><b /><b /></ejemplo>                             <!-- ERROR: el elemento <b /> aparece dos veces -->
```
---
- *****``:`` significa que el elemento puede no aparecer o aparecer una o más veces.
```dtd
<!DOCTYPE ejemplo [
      <!ELEMENT ejemplo (a*, b)>
      <!ELEMENT a EMPTY>
      <!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><b/></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a/><b/></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a/><a/><b/></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><b/><a/></ejemplo>                             <!-- ERROR: el elemento <a/> aparece después de <b/> -->
```
---
- **``+``**: significa que el elemento tiene que aparecer una o más veces (no puede no aparecer).
```dtd
<!DOCTYPE ejemplo [
      <!ELEMENT ejemplo (a+, b)>
      <!ELEMENT a EMPTY>
      <!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a/><b/></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a/><a/><b/></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto") 
```xml
<ejemplo><b /></ejemplo>                                  <!-- ERROR: falta el elemento <a /> -->
```
---
- **``()``**: permite agrupar expresiones.
```dtd
<!DOCTYPE ejemplo [
	<!ELEMENT ejemplo (a, (a|b))>
	<!ELEMENT a EMPTY>
	<!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a /><a /></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a /><b /></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><a /></ejemplo>                                  <!-- ERROR: falta el elemento <a /> o <b /> -->
    ```
---
```dtd
<!DOCTYPE ejemplo [
      <!ELEMENT ejemplo ((a, b)|(b, a))>
      <!ELEMENT a EMPTY>
      <!ELEMENT b EMPTY>
]>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><a /><b /></ejemplo>
```
---
![Correcto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-oksi.svg "Correcto")
```xml
<ejemplo><b /><a /></ejemplo>
```
---
![Incorrecto](https://www.mclibre.org/consultar/xml/varios/iconos/icono-okno.svg "Incorrecto")
```xml
<ejemplo><a /><a /></ejemplo>                             <!-- ERROR: sólo admite <a /><b /> o <b /><a /> -->
```
---
