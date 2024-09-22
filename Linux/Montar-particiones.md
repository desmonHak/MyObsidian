https://blog.angelinux-slack.net/montar-una-particion-en-linux-y-que-lo-haga-en-cada-arranque/
https://fortinux.gitbooks.io/humble_tips/content/capitulo_3_resolver_problemas_en_linux/tutorial_montar_particiones_ntfs_en_gnulinux_ubuntu.html

En el caso de tener otro disco duro y querer que cada vez que inicie Linux lo tengamos montado en nuestros sistema de archivos, podemos realizar los siguientes pasos.

Primero, debemos saber su identificador único ([[UUID]]), ya que si lo montamos solo por nombre de dispositivo, éste puede cambiar y ya no funcionaría. Para ello, vamos a repasar la nomenclatura de los dispositivos. Hace muchos años, los discos duros se detectaban como `hd`. Las memorias como `sd`. Ahora, los discos duros y memorias se identifican como `sd`. Para el primer dispositivo se le asigna una `a`, para el segundo una `b`, y así.
Entonces el primer dispositivo sería `sda`, para el segundo `sdb`.
Para la primera partición del dispositivo se le asigna un 1, para el segundo un 2, y así.
Para poder ver los dispositivos que tenemos actualmente en nuestro Linux podemos ejecutar el siguiente comando.
```bash
sudo fdisk -l
```
![[Pasted image 20240910195610.png]]
En mi ejemplo podemos ver que se detectaron dos dispositivos los cuales son `sda` y `sdb`.
Para `sdb` tengo 4 particiones y van de `sdb1` a `sdb4`.
Ahora, mi intención en montar la partición de `sda` a mi sistema operativo.
Para ello, se necesita ver el identificador único ([[UUID]]) de ese dispositivo ya que si cambio de orden los discos duros entonces va a cambiar su nomenclatura.
Si esto pasa, entonces va a montar de manera incorrecta los dispositivos o bien no lo hará.
El identificador único no va a cambiar, por lo que es la opción más segura.
Para ver los identificadores utilizamos el siguiente comando:
```bash
sudo blkid
```
![[Pasted image 20240910195659.png]]Entonces, si el dispositivo que quiero montar es `sda`, sólo reviso el [[UUID]] de ese dispositivo y copio ese texto.
Ahora, vamos a editar el archivo `fstab`, recomiendo hacer un respaldo antes de su contenido.
```bash
sudo nano /etc/fstab
```
Y agregamos su respectiva entrada en la parte inferior.
![[Pasted image 20240910195800.png]]
Lo que se debe agregar es
`File system`: el [[UUID]] que copiamos anteriormente.
`Dir`: es la carpeta a donde se va a montar (debe existir, si no, lo creamos en un momento).
`Type`: el sistema de archivos de la partición que queremos montar. Con el comando [[blkid]] nos indicaba su `type`, en éste caso es [[ext4]].
`Options`: Las opciones de montaje. Se listan a continuación las más comunes.

- `auto` – El sistema de archivos será montado automáticamente durante el arranque, o cuando la orden `mount -a se` invoque.
- `noauto` – El sistema de archivos no será montado automáticamente, solo cuando se le ordene manualmente.
- `exec` – Permite la ejecución de binarios residentes en el sistema de archivos.
- `noexec` – No permite la ejecución de binarios que se encuentren en el sistema de archivos.
- `ro` – Monta el sistema de archivos en modo sólo lectura.
- `rw` – Monta el sistema de archivos en modo lectura-escritura.
- `user` – Permite a cualquier usuario montar el sistema de archivos. Esta opción incluye `noexec`, `nosuid`, `nodev`, a menos que se indique lo contrario.
- `users` – Permite que cualquier usuario perteneciente al grupo `users` montar el sistema de archivos.
- `nouser` – Solo el usuario `root` puede montar el sistema de archivos.
- `owner` – Permite al propietario del dispositivo montarlo.
- `sync` – Todo el `I/O` se debe hacer de forma sincrónica.
- `async` – Todo el `I/O` se debe hacer de forma asíncrona.
- `dev` – Intérprete de los dispositivos especiales o de bloque del sistema de archivos.
- `nodev` – Impide la interpretación de los dispositivos especiales o de bloques del sistema de archivos.
- `suid` – Permite las operaciones de `suid`, y `sgid` bits. Se utiliza principalmente para permitir a los usuarios comunes ejecutar binarios con privilegios concedidos temporalmente con el fin de realizar una tarea específica.
- `nosuid` – Bloquea el funcionamiento de `suid`, y `sgid` bits
- `noatime` – No actualiza el `inode` con el tiempo de acceso al `filesystem`. Puede aumentar las prestaciones (véase opciones `atime`).  
    `nodiratime` – No actualiza el `inode` de los directorios con el tiempo de acceso al `filesystem`. Puede aumentar las prestaciones (véase opciones `atime`).
- `relatime` – Actualiza en el `inode` solo los tiempos relativos a modificaciones o cambios de los archivos. Los tiempos de acceso vienen actualizados solo si el último acceso es anterior respecto al de la última modificación. (Similar a `noatime`, pero no interfiere con programas como mutt u otras aplicaciones que deben conocer si un archivo ha sido leido después de la última modificación). Puede aumentar las prestaciones (véase opciones atime).
- `discard` – Emite las órdenes [[TRIM]] para dispositivos de bloques subyacentes cuando se liberan los bloques. Recomendado para usar si el sistema de archivos se encuentra en un `SSD`.
- `flush` – La opción vfat permite eliminar datos con más frecuencia, de modo que los cuadros de diálogo de copia o las barras de progreso se mantenga hasta que se hayan escrito todos los datos.
- `nofail` – Monta el dispositivo cuando está presente, pero ignora su ausencia. Esto evita que se cometan errores durante el arranque para los medios extraíbles.
- `defaults` – Asigna las opciones de montaje predeterminadas que serán utilizadas para el sistema de archivos. Las opciones predeterminadas para `ext4` son: `rw`, `suid`, `dev`, `exec`, `auto`, `nouser`, `async`

# Como montar una partición [[NTFS]]
Listamos discos duros con `fdisk`:
```bash
➜  ~ sudo fdisk -l  
[sudo] contraseña para desmon:
Disco /dev/loop7: 74,27 MiB, 77881344 bytes, 152112 sectores  
Unidades: sectores de 1 * 512 = 512 bytes  
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes  
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes  
  
  
Disco /dev/nvme0n1: 931,51 GiB, 1000204886016 bytes, 1953525168 sectores  
Disk model: KINGSTON SNV2S1000G                        
Unidades: sectores de 1 * 512 = 512 bytes  
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes  
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes  
Tipo de etiqueta de disco: gpt  
Identificador del disco: 67FC5478-1A8B-44C5-A1D3-B41F2C6D661B  
  
Dispositivo      Comienzo      Final   Sectores Tamaño Tipo  
/dev/nvme0n1p1       2048     206847     204800   100M Sistema EFI  
/dev/nvme0n1p2     206848     239615      32768    16M Reservado para Microsoft  
/dev/nvme0n1p3     239616 1022886924 1022647309 487,6G Datos básicos de Microsoft  
/dev/nvme0n1p4 1022887936 1023999999    1112064   543M Entorno de recuperación de Windows  
/dev/nvme0n1p5 1024000000 1414625279  390625280 186,3G Sistema de ficheros de Linux  
  
  
Disco /dev/sda: 931,51 GiB, 1000204886016 bytes, 1953525168 sectores  
Disk model: ST1000DM010-2EP1  
Unidades: sectores de 1 * 512 = 512 bytes  
Tamaño de sector (lógico/físico): 512 bytes / 4096 bytes  
Tamaño de E/S (mínimo/óptimo): 4096 bytes / 4096 bytes  
Tipo de etiqueta de disco: gpt  
Identificador del disco: 4B38032C-2007-11EF-92E7-74563C49563E  
  
Dispositivo Comienzo      Final   Sectores Tamaño Tipo  
/dev/sda1       2048     264191     262144   128M Reservado para Microsoft  
/dev/sda2     264192 1953523711 1953259520 931,4G Espacios de almacenamiento de Microsoft
```
Ubicamos la partición que deseamos montar, en este caso la mía es `/dev/nvme0n1p3` vemos el [[UUID]] que tiene la patricio:
```bash
➜  ~ sudo blkid   
/dev/nvme0n1p5: UUID="90d5f8cc-68ec-4433-ad75-9c52757b9d19" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="0cd427af-2d0c-4ff2-8e21-658319583410"
/dev/loop1: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop29: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop19: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/nvme0n1p3: BLOCK_SIZE="512" UUID="AEEC9AD9EC9A9B63" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="0d96528a-0d94-4685-899b-a3f0c799e496"
/dev/nvme0n1p1: UUID="A096-3F35" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="EFI system partition" PARTUUID="3b505454-447b-400a-807a-b2eee89fcec8"
/dev/nvme0n1p4: BLOCK_SIZE="512" UUID="1874D47C74D45DD6" TYPE="ntfs" PARTUUID="604def7d-4ee8-479e-b65e-62b65942ad45"
/dev/nvme0n1p2: PARTLABEL="Microsoft reserved partition" PARTUUID="4f7436dc-bdd4-4c0f-a911-b06bbede77e1"
/dev/loop27: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/sdd2: PARTLABEL="Grupo de almacenamiento" PARTUUID="4b38032f-2007-11ef-92e7-74563c49563e"
/dev/sdd1: PARTUUID="4b380326-2007-11ef-92e7-74563c49563e"
/dev/loop17: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop8: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop25: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/sdb2: PARTLABEL="Grupo de almacenamiento" PARTUUID="4b380330-2007-11ef-92e7-74563c49563e"
/dev/sdb1: PARTUUID="4b38032a-2007-11ef-92e7-74563c49563e"
/dev/loop15: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop6: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop23: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop13: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop4: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop21: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop11: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop2: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop0: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop28: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop18: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop9: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop26: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/sdc1: LABEL="Disk" BLOCK_SIZE="512" UUID="1C7C07307C0703EC" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="1b23e271-54c2-43ef-a998-ab045e6738b5"
/dev/loop16: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop7: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop24: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/sda2: PARTLABEL="Grupo de almacenamiento" PARTUUID="4b380331-2007-11ef-92e7-74563c49563e"
/dev/sda1: PARTUUID="4b38032d-2007-11ef-92e7-74563c49563e"
/dev/loop14: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop5: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop22: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop12: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop3: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop20: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop10: BLOCK_SIZE="131072" TYPE="squashfs"

```

En mi caso la partición tiene los siguientes valores:
```bash
/dev/nvme0n1p3: BLOCK_SIZE="512" UUID="AEEC9AD9EC9A9B63" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="0d96528a-0d94-4685-899b-a3f0c799e496"  
```

Donde el [[UUID]] es `AEEC9AD9EC9A9B63`, con este editamos el archivo  `/etc/fstab`:
```bash
sudo nano /etc/fstab -l
```

Añadiremos la partición con el [[UUID]] que obtuvimos:
```bash
 1 # /etc/fstab: static file system information.
 2 #
 3 # Use 'blkid' to print the universally unique identifier for a
 4 # device; this may be used with UUID= as a more robust way to name devices
 5 # that works even if disks are added and removed. See fstab(5).
 6 #
 7 # <file system> <mount point>   <type>  <options>       <dump>  <pass>
 8 # / was on /dev/nvme0n1p5 during curtin installation
 9 /dev/disk/by-uuid/90d5f8cc-68ec-4433-ad75-9c52757b9d19 / ext4 defaults 0 1
10 # /boot/efi was on /dev/nvme0n1p1 during curtin installation
11 /dev/disk/by-uuid/A096-3F35 /boot/efi vfat defaults 0 1
12 /swap.img       none    swap    sw      0       0
13 UUID=AEEC9AD9EC9A9B63 /media/win_partition ntfs-3g rw,exec,auto,suid,async,dev,user,umask=002,fmask=002,dmask=002 0 0
14
15
```

Para esto tuvimos que crear previamente la carpeta donde se montara la partición, en mi caso la monte en `/media/win_partition` usando:
```
sudo mkdir /media/win_partition
```

### Descripción de `UUID=AEEC9AD9EC9A9B63 /media/win_partition ntfs-3g rw,exec,auto,suid,async,dev,user,umask=002,fmask=002,dmask=002 0 0`

- **`umask=002`**: Permite que el propietario y el grupo tengan permisos completos (lectura/escritura/ejecución para directorios) y otros usuarios solo tengan permisos de lectura.
- **`fmask=002`**: Establece los permisos de los archivos a lectura/escritura para el propietario y el grupo.
- **`dmask=002`**: Establece los permisos de los directorios a lectura/escritura/ejecución para el propietario y el grupo.
- **`ntfs-3g`**: El controlador de [[NTFS]] de Linux que permite montar particiones [[NTFS]] con soporte para lectura y escritura.
- **`rw`**: Permite lectura y escritura.
- **`exec`**: Permite ejecutar binarios desde la partición.
- **`auto`**: La partición se monta automáticamente al arrancar el sistema.
- **`suid`**: Permite que los archivos mantengan el bit [[SUID]].
- **`async`**: Las operaciones de entrada/salida se realizan de manera asíncrona (mejora el rendimiento).
- **`dev`**: Permite el acceso a dispositivos dentro del sistema de archivos (correcto si tienes dispositivos en esta partición).
- **`user`**: Permite que los usuarios no privilegiados monten la partición.
- **`umask=000`**: Configura permisos abiertos para todos los usuarios (0 = permisos de lectura/escritura/ejecución para todos). **Este valor podría ser inseguro**. Si no quieres que todos los usuarios tengan acceso completo, podrías usar algo más restrictivo, como `umask=022`, que otorga permisos de escritura solo al propietario.

A la hora de montarse la partición con `sudo mount -a`, podría estar montándose como de solo _Lectura_ a pesar de que se indico que fuera de _Lectura/Escritura_, esto se puede deber a varias razones:
- **Windows no se cerró correctamente**: Si la partición [[NTFS]] está en un estado de "hibernación" o "inicio rápido" de `Windows`, el sistema Linux la montará como solo lectura para evitar corrupción.
- **Permisos [[NTFS]] en archivos del sistema**: Algunos archivos de sistema, como los de la carpeta `System32`, tienen permisos específicos que pueden ser gestionados solo desde Windows.

Algunas de las posibles soluciones son las siguientes:
#### 1. **Apagar correctamente Windows y deshabilitar "Inicio Rápido"**
Si has iniciado Windows recientemente, podría haber dejado la partición en un estado inconsistente o de hibernación. Para solucionarlo:
- Inicia Windows y apágalo completamente (no lo pongas en suspensión o hibernación).
- Asegúrate de desactivar "Inicio rápido", una función que puede dejar el sistema en hibernación parcial. Para hacerlo:
    1. Abre el Panel de Control.
    2. Ve a "Opciones de energía".
    3. Haz clic en "Elegir el comportamiento de los botones de inicio/apagado".
    4. Desmarca "Activar inicio rápido".

#### 2. **Forzar la eliminación de archivos de hibernación**
Si no puedes acceder a Windows o prefieres no hacerlo, puedes forzar el montaje de la partición ignorando los archivos de hibernación con el siguiente comando:
```bash
sudo mount -t ntfs-3g -o remove_hiberfile /dev/nvme0n1p3 /media/win_partition
```

#### 3. **Revisar permisos en Windows**
Para los archivos del sistema, especialmente en carpetas como `System32`, es posible que no puedas cambiar los permisos desde Linux debido a las restricciones impuestas por el propio sistema [[NTFS]].

- Si es estrictamente necesario modificar estos archivos, lo mejor sería hacerlo desde Windows.
- En caso de que no necesites acceso a esos archivos específicos, puedes ignorar los errores en estas carpetas y trabajar con las carpetas y archivos de usuario en la partición [[NTFS]].

#### 4. **Verificar el estado del sistema de archivos**
Puedes verificar si hay errores en la partición [[NTFS]] ejecutando `ntfsfix`, una herramienta que repara particiones [[NTFS]] desde Linux. Asegúrate de que la partición esté desmontada primero:
```bash
sudo umount /media/win_partition
sudo ntfsfix /dev/nvme0n1p3
```
Esto no es un reemplazo completo para `chkdsk` de Windows, pero puede ayudar a corregir algunos problemas.


En caso de que salga lo siguiente:
```bash
➜  ~ sudo umount /media/win_partition && sudo ntfsfix /dev/nvme0n1p3

Mounting volume... Windows is hibernated, refused to mount.
FAILED
Attempting to correct errors... 
Processing $MFT and $MFTMirr...
Reading $MFT... OK
Reading $MFTMirr... OK
Comparing $MFTMirr to $MFT... OK
Processing of $MFT and $MFTMirr completed successfully.
Setting required flags on partition... OK
Going to empty the journal ($LogFile)... OK
Windows is hibernated, refused to mount.
Remount failed: Operation not permitted

```

Esto se deber a la hibernación de Windows:
```bash
Windows is hibernated, refused to mount.
Remount failed: Operation not permitted
```

Puede solucionarlo usando la opción numero 2 que se indico anteriormente.

También se puede solucionar desde Windows de la siguiente manera:
#### 1. **Desactivar la hibernación y el "Inicio rápido" en Windows** (solución recomendada)
Para solucionar el problema de manera efectiva, debes arrancar Windows y asegurarte de desactivar tanto la hibernación como el "Inicio rápido". Aquí te explico cómo hacerlo:

**Paso 1: Desactivar la hibernación**:

1. Inicia Windows.
2. Abre el **Símbolo del sistema** (`CMD`) como administrador.
3. Ejecuta el siguiente comando para desactivar la hibernación:
```batch
powercfg /h off
```
Esto desactivará la hibernación y eliminará el archivo de hibernación (`hiberfil.sys`).

**Paso 2: Desactivar el "Inicio rápido"**:
1. Ve a **Panel de control** > **Opciones de energía**.
2. Haz clic en **Elegir el comportamiento de los botones de encendido**.
3. Selecciona **Cambiar la configuración actualmente no disponible**.
4. Desmarca la casilla **Activar inicio rápido (recomendado)**.
5. Guarda los cambios y apaga completamente Windows (no lo pongas en suspensión ni hibernación).

Después de hacer esto, vuelve a Linux y monta la partición:
```bash
sudo mount -a
```
#### 2. **Reiniciar en Windows y cerrar correctamente**
Si ninguna de las soluciones anteriores es posible, la opción más segura es reiniciar en Windows y asegurarte de hacer un **apagado completo**, no una suspensión ni hibernación.

