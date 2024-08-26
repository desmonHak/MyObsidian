Aprende a aplicar un formato básico a tus notas, utilizando Markdown. Para una sintaxis de formato más avanzada, consulta Sintaxis de formato avanzada.

## Párrafos
Para crear párrafos, utiliza una línea en blanco para separar una o varias líneas de texto.
```
Esto es un párrafo.

Esto es otro párrafo.
```

Múltiples espacios en blanco adyacentes dentro y entre párrafos se colapsan en un solo espacio cuando se muestra una nota en la vista de lectura y en los sitios de Obsidian Publish.

```
Múltiples          espacios          adyacentes



y múltiples líneas nuevas entre párrafos.
```
Múltiples espacios adyacentes

y múltiples líneas nuevas entre párrafos.

Si desea agregar varios espacios, puede agregar ``&nbsp;`` (espacio en blanco) y ``<br>`` (nueva línea) a su nota.

## Encabezamientos 
Para crear un encabezado, agregue hasta seis símbolos ``#`` antes del texto del encabezado. El número de símbolos ``#`` determina el tamaño del título. 
```
# Este es un encabezado 1 
## Este es un encabezado 2 
### Este es un encabezado 3 
#### Este es un encabezado 4 
##### Este es un encabezado 5 
###### Este es un encabezado 6
```
# This is a heading 1

## This is a heading 2

### This is a heading 3

#### This is a heading 4

##### This is a heading 5

###### This is a heading 6

## Negrita, cursiva, resaltados

El formato de texto también se puede aplicar usando [Atajos de edición](https://help.obsidian.md/Editing+and+formatting/Editing+shortcuts).

| Style             | Syntax                | Example                                  | Output                                 |
| ----------------- | --------------------- | ---------------------------------------- | -------------------------------------- |
| negrita           | `** **` o `__ __`     | `**Texto en negrita**`                   | **Texto en negrita**                   |
| cursiva           | `**` o `__`           | `*Texto en cursiva*`                     | _Texto en cursiva_                     |
| Tachado           | `~~ ~~`               | `~~Texto tachado~~`                      | ~~Texto tachado~~                      |
| Texto resaltado   | `== ==`               | `==Texto resaltado==`                    | ==Texto resaltado==                    |
| Negrita y cursiva | `** **` y `_ _`       | `**Bold text and _nested italic_ text**` | **Bold text and _nested italic_ text** |
| Negrita y cursiva | `*** ***` o `___ ___` | `***Texto en negrita y cursiva***`       | **Texto en negrita y cursiva**         |

Se puede forzar el formato para que se muestre en texto sin formato agregando una barra invertida ``\`` delante. 

**Esta línea no estará en negrita**
``\*\*Esta línea no estará en negrita\*\* ``

*Esta línea estará en cursiva y mostrará los asteriscos* 
``\**Esta línea estará en cursiva y mostrará los asteriscos*\*``

Obsidian admite dos formatos para [enlaces internos](https://help.obsidian.md/Linking+notes+and+files/Internal+links) entre notas: 
- Wikilink: ``[[Tres leyes del movimiento]] `` [[Tres leyes del movimiento]]
- Markdown: ``[Tres leyes del movimiento](Three%20laws%20of%20motion.md)`` [Tres leyes del movimiento](Tres%20leyes%20del%20movimiento.md)

  
## Enlaces externos
Si desea vincular a una URL externa, puede crear un vínculo en línea rodeando el texto del vínculo entre corchetes (``[ ]``) y luego la URL entre paréntesis (``( )``). 
``[Ayuda de obsidiana](https://help.obsidian.md) ``
[Ayuda de obsidiana](https://help.obsidian.md) 

También puede crear enlaces externos a archivos en otras bóvedas, vinculándolos a un [URI de Obsidian](https://help.obsidian.md/Extending+Obsidian/Obsidian+URI).
``[Nota](obsidiana://open?vault=MainVault&file=Note.md) ``

### Escapar de espacios en blanco en enlaces 
Si su URL contiene espacios en blanco, debe escaparlos reemplazándolos con ``%20``.
``[Mi nota](obsidiana://open?vault=MainVault&file=My%20Note.md) ``

También puede escapar de la URL envolviéndola entre corchetes angulares (``< >``).
``[Mi nota](<obsidiana://open?vault=MainVault&file=Mi nota.md>)``

## Imágenes externas 
Puede agregar imágenes con URL externas agregando un! símbolo antes de un enlace externo. 
``![Engelbart](https://history-computer.com/ModernComputer/Basis/images/Engelbart.jpg)`` 

![Engelbart](https://history-computer.com/ModernComputer/Basis/images/Engelbart.jpg)

Puede cambiar las dimensiones de la imagen agregando`` |640x480`` al destino del enlace, donde 640 es el ancho y 480 es el alto.

```
![Engelbart|100x145](https://history-computer.com/ModernComputer/Basis/images/Engelbart.jpg)
```

![Engelbart|100x145](https://history-computer.com/ModernComputer/Basis/images/Engelbart.jpg)

Si solo especifica el ancho, la imagen se escala según su relación de aspecto original. Por ejemplo: 

```
![Engelbart|100](https://history-computer.com/ModernComputer/Basis/images/Engelbart.jpg)
```

![Engelbart|100](https://history-computer.com/ModernComputer/Basis/images/Engelbart.jpg) 
Consejo Si desea agregar una imagen desde dentro de su bóveda, también puede incrustar una imagen en una nota.

## Citas
Puede citar texto agregando un símbolo ``>`` antes del texto. 

```
> Los seres humanos se enfrentan a problemas cada vez más complejos y urgentes, y su eficacia para abordarlos es una cuestión fundamental para la estabilidad y el progreso continuo de la sociedad. 
\- Doug Engelbart, 1961 
```
> Los seres humanos enfrentan problemas cada vez más complejos y urgentes, y su eficacia para abordarlos es una cuestión crítica para la estabilidad y el progreso continuo de la sociedad. 
> \ -Doug Engelbart, 1961


Puede convertir su cotización en una leyenda agregando [!info] como la primera línea de una cotización:
> [!info] > Here's a callout block. > It supports **Markdown**, [[Internal link|Wikilinks]], and [[Embed files|embeds]]! > ![[Engelbart.jpg]]

Puedes crear una lista desordenada agregando `-`, `*` o `+` antes del texto.

```md
- Primer elemento de la lista 
- Segundo elemento de la lista 
- Tercer elemento de la lista
```

- Primer elemento de la lista
- Segundo elemento de la lista
- Tercer elemento de la lista

Para crear una lista ordenada, comience cada línea con un número seguido de un símbolo `.` .
```md 
1. Primer elemento de la lista 
2. Segundo elemento de la lista 
3. Tercer elemento de la lista 
``` 
1. Primer elemento de la lista 
2. Segundo elemento de la lista 
3. Tercer elemento de la lista

### Listas de tareas 
Para crear una lista de tareas, comience cada elemento de la lista con un guión y un espacio seguido de `[ ]`. 
```md 
- [x] Esta es una tarea completada. 
- [ ] Esta es una tarea incompleta. 
``` 
- [x] Esta es una tarea completada.
- [ ] Esta es una tarea incompleta. 

> [!Tip]
> Puede utilizar cualquier carácter dentro de los corchetes para marcarlo como completo.
> 
> ```md
> - [x] Milk
> - [?] Eggs
> - [-] Eggs
> ```
> 
> - [x] Milk
> - [x] Eggs
> - [x] Eggs

### Listas de anidamiento

Todos los tipos de listas se pueden anidar en Obsidian.

Para crear una lista anidada, aplique sangría a uno o más elementos de la lista:

```md
1. Primer elemento de la lista
	1. Elemento de lista anidada ordenada
2. Segundo elemento de la lista
	- Elemento de lista anidada desordenado
```

1. Primer elemento de la lista
	1. Elemento de lista anidada ordenada
2. Segundo elemento de la lista
	 - Elemento de lista anidada desordenado

De manera similar, puede crear una lista de tareas anidada sangrando uno o más elementos de la lista:

```md
- [] Elemento de tarea 1
	- [ ] Subtarea 1
- [ ] Elemento de tarea 2
	- [ ] Subtarea 1
```

- [ ] Elemento de tarea 1
	- [ ] Subtarea 1
- [ ] Elemento de tarea 2
	- [ ] Subtarea 1

Utilice `Tab` o `Shift+Tab` para sangrar o quitar la sangría de uno o más elementos de la lista seleccionados para facilitar la organización.

## Regla horizontal

Puedes usar tres o más estrellas `***`, guiones `---` o guiones bajos `___` en su propia línea para agregar una barra horizontal. También puedes separar símbolos usando espacios.

```md
***
****
* * *
---
----
- - -
___
____
_ _ _
```

---

## Código

Puede formatear el código tanto en línea dentro de una oración como en su propio bloque.

### Código en línea

Puede formatear el código dentro de una oración usando comillas invertidas simples.

```md
El texto dentro de las `comillas invertidas` en una línea tendrá formato como código.
```

El texto dentro de `comillas invertidas` en una línea tendrá formato como código.

Si desea poner comillas invertidas en un bloque de código en línea, rodéelo con comillas invertidas dobles como esta: ``código en línea con una comillas invertida ` dentro``. 


### Bloques de código

Para formatear un bloque de código, rodee el código con triples comillas invertidas.

````
```
cd ~/Escritorio
```
````

```md
cd ~/Escritorio
```

También puedes crear un bloque de código sangrando el texto usando `Tab` o 4 espacios en blanco.

```md
 cd ~/Escritorio
```

Puede agregar resaltado de sintaxis a un bloque de código agregando un código de idioma después del primer conjunto de comillas invertidas.

````md
```js
function fancyAlert(arg) { 
	if(arg) { 
		$.facebox({div:'#foo'}) 
	} 
}
```
````

```js
function fancyAlert(arg) { 
	if(arg) { 
		$.facebox({div:'#foo'}) 
	} 
}
```

Obsidian usa Prism para resaltar la sintaxis. Para obtener más información, 
consulte [Idiomas admitidos](https://prismjs.com/#supported-languages).

https://prismjs.com/#supported-languages

## Notas al pie

Puedes agregar notas al pie[1](https://publish.obsidian.md/#fn-1-824845dbb5916463) a tus notas usando la siguiente sintaxis:

```md
Esta es una simple nota al pie[^1].

[^1]: Este es el texto referenciado.
[^2]: Agrega 2 espacios al comienzo de cada nueva línea.
 Esto le permite escribir notas a pie de página que abarquen varias líneas.
[^nota]: Las notas al pie con nombre todavía aparecen como números, pero pueden facilitar la identificación y vinculación de referencias.
```

[^nota]: Las notas al pie con nombre todavía aparecen como números, pero pueden facilitar la identificación y vinculación de referencias.

También puedes insertar notas a pie de página en una oración. Tenga en cuenta que el símbolo de intercalación sale de los corchetes.

```md
También puede utilizar notas a pie de página en línea. ^[Esta es una nota al pie en línea.]
```

## Comentarios 
Puede agregar comentarios ajustando el texto con `%%`. Los comentarios solo son visibles en la vista de edición. 
```md 
Este es un comentario %%inline%%. 
%% 
Este es un comentario en bloque. 

Los comentarios en bloque pueden abarcar varias líneas. 
%% 
```

%% 
Este es un comentario en bloque. 
Los comentarios en bloque pueden abarcar varias líneas. 
%% 

[[Sintaxis de formato avanzada]]