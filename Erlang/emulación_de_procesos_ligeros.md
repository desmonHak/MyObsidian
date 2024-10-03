La emulación de procesos ligeros como los que implementa Erlang es posible mediante algunas técnicas clave:

1. Uso de corrutinas o fibras: Son unidades de ejecución más ligeras que los hilos del sistema operativo. Se pueden implementar usando bibliotecas como libco o libtask en C.
2. Planificador cooperativo: En lugar de depender del planificador del sistema operativo, se implementa un planificador propio que gestiona la ejecución de las corrutinas.
3. Paso de mensajes: Se implementa un sistema de paso de mensajes entre las corrutinas para permitir la comunicación.
4. Gestión de memoria propia: Cada "proceso" emulado tiene su propia pila y heap gestionados por el runtime.
5. Cambio de contexto ligero: Se implementa un mecanismo eficiente para cambiar entre corrutinas.

Para implementar algo similar en C, podrías:

1. Usar setjmp/longjmp para implementar corrutinas básicas.
2. Implementar una cola de corrutinas listas para ejecutar.
3. Crear un planificador que itere sobre la cola y ejecute cada corrutina por un quantum de tiempo.
4. Implementar funciones para crear nuevas corrutinas y enviar/recibir mensajes entre ellas.
5. Gestionar la memoria de cada corrutina de forma independiente.
6. Implementar mecanismos de supervisión y manejo de errores.

Un ejemplo básico podría ser:
```c
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_COROUTINES 100

typedef struct {
    jmp_buf context;
    int active;
    void (*function)(void*);
    void* arg;
} Coroutine;

Coroutine coroutines[MAX_COROUTINES];
int current_coroutine = -1;

void scheduler() {
    while (1) {
        for (int i = 0; i < MAX_COROUTINES; i++) {
            if (coroutines[i].active) {
                current_coroutine = i;
                if (setjmp(coroutines[i].context) == 0) {
                    coroutines[i].function(coroutines[i].arg);
                }
            }
        }
    }
}

void yield() {
    if (setjmp(coroutines[current_coroutine].context) == 0) {
        longjmp(scheduler_context, 1);
    }
}

// Funciones para crear corrutinas, enviar mensajes, etc.

```

Para emular la ejecución paralela de procesos ligeros en C, como los de Erlang, se pueden utilizar algunas técnicas:

1. Uso de hilos (threads):
    - Crear un hilo para cada "proceso" emulado usando pthreads.
    - Implementar un planificador que alterne la ejecución entre los hilos.
    - Usar mutexes y variables de condición para sincronización.
2. Corrutinas:
    - Implementar corrutinas usando setjmp/longjmp o bibliotecas como libco.
    - Crear un planificador cooperativo que alterne entre corrutinas.
3. Eventos y bucle de eventos:
    - Implementar un bucle de eventos que maneje múltiples "procesos" de forma no bloqueante.
    - Usar select() o poll() para manejar E/S de forma eficiente.
    
4. Fibras (en Windows):
    
    - Usar la API de Fibras de Windows para crear procesos ligeros.