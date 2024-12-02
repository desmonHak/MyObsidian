Si quiero añadir en mi proyecto [strcuts_data_C](https://github.com/desmonHak/strcuts_data_C) la libreria [DebugLibC](https://github.com/desmonHak/DebugLibC) es necesario agregarla como submódulo de la siguiente manera:
```bash
git submodule add https://github.com/desmonHak/DebugLibC.git DebugLibC
```

deberá incoarlo antes si nunca lo hizo:
```bash
git submodule init
```

Esto añadirá un submódulo desconectado de su rama, lo que puede ocasionar errores si se intenta modificar ese submódulo y subir cambios remotos, la solución se encuentra en [[error-al-actualizar-submodulos]], se puede evitar añadiendo lo siguiente en el archivos de submódulos:
```ruby
[submodule "DebugLibC"]
    path = DebugLibC
    url = https://github.com/desmonHak/DebugLibC.git
    branch = main
```
donde en `branch` se indica la rama que usar

forma alternativa:
```bash
git submodule add -b main https://github.com/desmonHak/DebugLibC.git DebugLibC
git submodule update --init --recursive
```
**`-b main`**: Especifica que quieres seguir la rama `main`.

En caso de que ya existe como ocurre aquí
![[Pasted image 20241130223848.png]]

solo es necesario eliminarlo del índice de la siguiente manera:
```bash
git rm --cached DebugLibC
```
aunque después deberá eliminar la existe si desea agregar el nuevo submódulo:
```bash
rm -rf DebugLibC
```

# Usar submódulos que contienen submódulos
yo tengo mi proyecto CCN en ``C:\Users\desmon0xff\Desktop\files\Shared\CCN`` ahora, quiero que mi librería ``DebugLibC`` sea un submódulo así que use: 
```bash
git submodule add https://github.com/desmonHak/DebugLibC.git DebugLibC
``` 
pero la librería ``DebugLibC`` depende del submódulo ``colors-C-C-plus-plus`` que tiene esta librería misma, por alguna razón no se descargo, como puedo solucionarlo?
## solución:
Cuando añades un submódulo en Git, solo se clona el repositorio especificado, pero los submódulos de ese repositorio no se descargan automáticamente. Esto se debe a que cada submódulo también debe inicializarse y actualizarse manualmente.

Para resolver este problema y asegurarte de que los submódulos anidados se descarguen correctamente, sigue estos pasos
### 1. **Clonar submódulos anidados**

Después de añadir `DebugLibC` como submódulo, inicializa y actualiza los submódulos de este repositorio principal, así como los anidados:
```bash
# Desde el directorio raíz de tu proyecto CCN 
git submodule update --init --recursive 
# prorbar un --remote a ver que hace?
```
Esto inicializa y descarga todos los submódulos, incluidos los submódulos dentro de `DebugLibC` (como `colors-C-C-plus-plus`).

salida:
```bash
C:\Users\desmon0xff\Desktop\files\Shared\CCN>git submodule add https://github.com/desmonHak/DebugLibC.git DebugLibC
Cloning into 'C:/Users/desmon0xff/Desktop/files/Shared/CCN/DebugLibC'...
remote: Enumerating objects: 56, done.
remote: Counting objects: 100% (56/56), done.
remote: Compressing objects: 100% (45/45), done.
remote: Total 56 (delta 26), reused 26 (delta 11), pack-reused 0 (from 0)
Receiving objects: 100% (56/56), 59.68 KiB | 144.00 KiB/s, done.
Resolving deltas: 100% (26/26), done.
warning: in the working copy of '.gitmodules', LF will be replaced by CRLF the next time Git touches it

C:\Users\desmon0xff\Desktop\files\Shared\CCN>git submodule update --init --recursive
Submodule 'colors-C-C-plus-plus' (https://github.com/desmonHak/colors-C-C-plus-plus) registered for path 'DebugLibC/colors-C-C-plus-plus'
Cloning into 'C:/Users/desmon0xff/Desktop/files/Shared/CCN/DebugLibC/colors-C-C-plus-plus'...
Submodule path 'DebugLibC/colors-C-C-plus-plus': checked out '53fbeaa6c32ee7b208df153b84549a5f687f96a3'

C:\Users\desmon0xff\Desktop\files\Shared\CCN>
```

### 2. **Verificar la estructura**
Asegúrate de que la estructura de directorios sea correcta y que el submódulo `colors-C-C-plus-plus` se haya descargado dentro de `DebugLibC`. Puedes verificarlo navegando a la carpeta del submódulo y verificando su contenido:
```bash
cd DebugLibC 
ls
```
Si el submódulo `colors-C-C-plus-plus` está presente, todo está funcionando.

### 3. **Añadir configuración al repositorio principal**
Si trabajas con un equipo o necesitas que otros usuarios inicialicen correctamente los submódulos al clonar tu repositorio, indícales que usen el flag `--recurse-submodules` cuando clonen el repositorio principal:
```bash
git clone --recurse-submodules https://github.com/tuusuario/tu-repositorio.git
```
Esto asegura que todos los submódulos se clonen automáticamente.

### 4. **Actualizar submódulos manualmente**
Si los submódulos cambian en el futuro y necesitas actualizarlos, puedes usar el siguiente comando desde el directorio raíz de tu repositorio:
```bash
git submodule update --recursive --remote
```
Esto actualizará todos los submódulos a su última versión remota.
Con estos pasos, deberías solucionar el problema de los submódulos anidados en tu proyecto CCN. 


Si al ejecutar `git submodule add --force https://github.com/desmonHak/strcuts_data_C strcuts_data_C` no se descargan los submódulos de ese submódulo, es posible que el submódulo en cuestión tenga submódulos anidados que no están siendo descargados automáticamente. Git, por defecto, no descarga los submódulos de los submódulos cuando se añade un submódulo. Para solucionar esto, sigue estos pasos:
### **Pasos para actualizar los submódulos de los submódulos:**

1. **Inicializa el submódulo y sus submódulos:** Después de añadir el submódulo, debes inicializar y actualizar no solo el submódulo principal, sino también sus submódulos. Para ello, usa el siguiente comando:
```bash
git submodule update --init --recursive
```
Este comando asegura que todos los submódulos, incluyendo los submódulos de los submódulos (submódulos anidados), se descarguen correctamente.
2. **Verifica que los submódulos estén inicializados:** Puedes verificar que todos los submódulos (y submódulos anidados) están correctamente inicializados ejecutando:
```bash
git submodule status
```
   Esto debería mostrarte todos los submódulos y su estado (si están inicializados y qué versión están usando).
   
3. **Si los submódulos de submódulos siguen sin descargarse, asegúrate de que los archivos `.gitmodules` estén correctamente configurados:** Si el submódulo principal (`strcuts_data_C`) tiene submódulos, debería haber una sección en su propio archivo `.gitmodules`. Revisa que el archivo `.gitmodules` del submódulo principal contenga las rutas y URLs correctas para sus submódulos.
Ejemplo de lo que debe contener el `.gitmodules`:

```ruby
[submodule "nested-submodule"]     
	path = nested-submodule     
	url = https://github.com/usuario/nested-submodule.git
```
Si no está presente, edítalo manualmente para agregar la URL y la ruta del submódulo anidado.

4. **Actualizar submódulos de submódulos manualmente (si es necesario):** Si el submódulo no se actualiza de manera automática, puedes actualizarlo manualmente. Primero, entra en el directorio del submódulo y luego inicializa sus submódulos:
```bash
cd strcuts_data_C 
git submodule update --init --recursive
```

Después, vuelve al directorio principal y verifica el estado nuevamente:
```bash
cd .. 
git submodule status
```

5. **Asegúrate de que tu configuración de submódulos está correcta:** Verifica si tienes configurado el manejo de submódulos recursivos correctamente. Puedes hacerlo con el siguiente comando:
```bash
git config --global submodule.recurse true
```

Esto garantiza que Git maneje submódulos anidados de forma automática.

### **Resumen:**
Para descargar los submódulos de un submódulo:
1. Usa `git submodule update --init --recursive` después de añadir el submódulo principal.
2. Verifica que el archivo `.gitmodules` esté configurado correctamente.
3. Si es necesario, inicializa y actualiza los submódulos de manera manual dentro de los submódulos.
4. Asegúrate de tener la configuración `submodule.recurse true`.

Estos pasos deberían permitirte descargar todos los submódulos, incluidos los submódulos anidados.
# Añadir multiples submodulos

como puedo hacer que todos los submodulos sigan sus ramas main:
```c
C:.
├───.dist
├───.vscode
└───structs_data_C
    ├───.vscode
    ├───DebugLibC
    │   └───colors-C-C-plus-plus
    │       └───.vscode
    ├───examples
    └───img
```
``colors-C-C-plus-plus``, ``DebugLibC`` y ``structs_data_C``  son submódulos.

Para asegurarte de que todos tus submódulos sigan siempre la rama `main`, puedes hacer lo siguiente:
### 1. **Actualizar las configuraciones en `.gitmodules`**

Cada submódulo tiene una entrada en el archivo `.gitmodules`, que contiene información sobre su ubicación y rama. Debes asegurarte de que todos los submódulos apunten a la rama `main`.

1. Abre el archivo `.gitmodules` en la raíz de tu proyecto. Este archivo debería tener entradas para cada submódulo, algo como esto:
```bash
[submodule "structs_data_C"]
    path = structs_data_C
    url = https://github.com/desmonHak/structs_data_C.git
    branch = main

[submodule "DebugLibC"]
    path = structs_data_C/DebugLibC
    url = https://github.com/desmonHak/DebugLibC.git
    branch = main

[submodule "colors-C-C-plus-plus"]
    path = structs_data_C/DebugLibC/colors-C-C-plus-plus
    url = https://github.com/desmonHak/colors-C-C-plus-plus.git
    branch = main
```
2. Si no hay una línea con `branch = main` para cada submódulo, añádela para que todos los submódulos sigan la rama `main`. Deberías tener algo similar a lo que se muestra arriba.

### 2. **Configurar el submódulo para seguir siempre la rama `main`**
Una vez que hayas actualizado `.gitmodules`, puedes configurar los submódulos localmente para que sigan siempre la rama `main` con el siguiente comando:
```bash
git submodule update --remote --merge
```

Este comando actualizará los submódulos y los mantendrá en la última versión de la rama `main` de cada uno. También fusionará los cambios si es necesario.

Si deseas asegurarte de que se descargue siempre la rama `main` en lugar de cualquier otro commit específico, puedes ejecutar lo siguiente:

bash

Copiar código

`git submodule foreach 'git checkout main'`

Este comando hará que todos los submódulos cambien a la rama `main`, si no están ya en ella.

### 3. **Hacer que el submódulo siempre siga la rama `main`**

En los submódulos, Git puede recordar el commit exacto en el que se encuentran (en lugar de la rama). Para hacer que el submódulo siempre siga la rama `main`, debes agregar una configuración adicional en el repositorio principal para que los submódulos no se "desconecten" de la rama al hacer un `git pull`.

1. Asegúrate de que la rama `main` esté configurada para ser la predeterminada para cada submódulo:

bash

Copiar código

`git submodule foreach 'git fetch origin main && git checkout main && git pull origin main'`

Este comando actualizará cada submódulo, descargará los últimos cambios y se asegurará de que esté en la rama `main` de cada uno.

### 4. **Asegúrate de que los cambios se reflejen en el repositorio principal**

Finalmente, asegúrate de que las actualizaciones de los submódulos (si han cambiado a la rama `main`) se reflejan en el repositorio principal:

1. Confirma y añade los cambios en el archivo `.gitmodules`:

bash

Copiar código

`git add .gitmodules git commit -m "Update .gitmodules to track main branch for all submodules"`

2. Luego, para cada submódulo que haya cambiado, confirma el nuevo commit que apunta a la rama `main`:

bash

Copiar código

`git submodule update --remote git add <submodule_path> git commit -m "Update submodule to latest commit on main"`

Finalmente, empuja los cambios:

bash

Copiar código

`git push --recurse-submodules=on-demand`

### 5. **Verificar que todo esté actualizado**

Verifica que los submódulos estén apuntando correctamente a las últimas versiones de la rama `main`:

bash

Copiar código

`git submodule status`

Esto debería mostrarte los hashes de commit más recientes de la rama `main` para cada submódulo.

### Resumen de pasos

1. Asegúrate de que cada submódulo en `.gitmodules` tenga `branch = main`.
2. Actualiza los submódulos usando `git submodule update --remote --merge`.
3. Cambia a la rama `main` en cada submódulo usando `git submodule foreach 'git checkout main'`.
4. Haz un `git submodule update --remote` para obtener las últimas actualizaciones de los submódulos.
5. Confirma los cambios en el repositorio principal y empuja los cambios.

Con estos pasos, todos tus submódulos estarán configurados para seguir la rama `main` y se actualizarán automáticamente.