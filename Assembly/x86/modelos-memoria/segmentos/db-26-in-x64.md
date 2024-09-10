https://board.flatassembler.net/topic.php?p=216136#216136
```ruby
En realidad, no son iguales en 
push dword [es:fs:ebx] o 
push dword [fs:es:ebx]. 
¿El comportamiento es el mismo para todos los chips x64?
```
Esa es una pregunta interesante. Aunque estaba bastante seguro de la respuesta, decidí comprobarlo dos veces, así que fui a mi biblioteca y consulté los manuales de ``AMD x86-64 de 2002``. **Indican que estos prefijos se ignoran**. Como todas las encarnaciones posteriores de ``x64`` se basaron en esta especificación original con muy pocas desviaciones, supongo que esto debería ser igual para todas ellas.


Si su intención era simplemente modificar la base [[FS]] para fines de prueba, y su CPU no es demasiado antigua, pruebe la instrucción ``WRFSBASE`` en su lugar (no es privilegiada como [[WRMSR]]).
```ruby
include 'win64ax.inc'

.data
  msg db 'Oh?',0

.code
  start:

        rdfsbase rbx    ; save original FS base

        lea rax,[msg]
        wrfsbase rax

        fs ds mov dword [0],'Hi!'

        wrfsbase rbx    ; restore original FS base

        invoke  MessageBox,HWND_DESKTOP,msg,invoke GetCommandLine,MB_OK
        invoke  ExitProcess,0

.end start    
```

``rd/wrfsbase`` requiere que el ``bit 16`` de [[CR4]] esté habilitado, de lo contrario genera ``#UD`` si se ejecuta desde un lugar distinto de ring0 de manera similar a ``rd/``[[WRMSR]] ejecutado desde un lugar distinto de ring0
Desafortunadamente, ``mov`` desde ``cr4`` genera ``#GP(0)`` si se ejecuta desde cualquier otro lugar que no sea ``ring0``, por lo que no hay una manera fácil de determinar [[CR4]] desde el modo de usuario. Triste

Pero volvamos a la pregunta de ``l4m2``
Los prefijos de anulación de segmento son prefijos del grupo 2 y cuando se usan más de ellos para 1 instrucción, solo se usa el primero o el último (no recuerdo exactamente si el primero o el último), por eso los resultados de ``l4m2`` fueron diferentes (los usó en modo heredado o ``submodo`` de compatibilidad porque la instrucción ``push dword`` es imposible en modo de ``64 bits``, puede ``push`` solo ``qword`` o ``word`` en modo de ``64 bits``, pero no ``dword``)
En modo de ``64 bits``, los prefijos [[CS]], [[DS]], [[ES]], [[SS]] se ignoran (pero usar demasiados prefijos y generar una instrucción demasiado larga puede llevar a ``#UD``) y solo [[FS]] y se tratan los prefijos [[GS]]
Además, en su segunda publicación en este hilo, intenta destruir la base [[FS]], lo que puede provocar que se dañe por completo la ejecución del programa y generar violaciones de acceso en cualquier intento de acceder a cualquier memoria a la que haga referencia [[FS]].
``Tomasz`` publicó la forma correcta y en su ejemplo se restableció la base [[FS]], pero mientras tanto, la ejecución del programa puede interrumpirse antes de restaurar la base [[FS]] y nuevamente podría ocurrir una violación de acceso (que podría evitarse deshabilitando las interrupciones mediante la instrucción [[CLI]] - nuevamente instrucción privilegiada para ``ring0`` o generando [[IRQL]] escribiendo [[CR8]] - nuevamente instrucción privilegiada para ``ring0``)