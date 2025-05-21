https://vishalchovatiya.com/posts/coroutine-in-c-language/

"¿Cómo funciona internamente una corrutina?".

## Prólogo
Si eres principiante absoluto, revisa los prerrequisitos a continuación. Y si no lo eres, ¡mejor que sepas qué omitir!

1. [¡Cómo se convierte un programa en C a ensamblador!](https://vishalchovatiya.com/posts/how-c-program-convert-into-assembly/)
2. [Disposición de memoria de un programa en C](https://vishalchovatiya.com/posts/how-c-program-stored-in-ram-memory/)

**Nota:** Las API de cambio de contexto `getcontext`, `setcontext`, `makecontext` y `swapcontext` quedaron obsoletas en POSIX.1-2004 y se eliminaron en POSIX.1-2008 debido a problemas de portabilidad. Por lo tanto, no las uses. Aquí las he usado con fines demostrativos.

## Fundamentos de las corrutinas

### ¿Qué es una corrutina?

- Una corrutina es una función/subrutina (para ser más precisos, una subrutina cooperativa) que puede suspenderse y reanudarse.
- En otras palabras, se puede considerar una corrutina como una solución intermedia entre una función normal y un hilo. Una vez llamada, la función/subrutina se ejecuta hasta el final. Por otro lado, un hilo puede bloquearse mediante primitivas de sincronización (como mutex, semáforos, etc.) o suspenderse por el programador del sistema operativo. Sin embargo, no se puede decidir sobre la suspensión o la reanudación, ya que esto lo hace el programador del sistema operativo.
- Por otro lado, una corrutina puede suspenderse en un punto predefinido y reanudarse posteriormente según las necesidades del programador. De esta manera, el programador tendrá control total del flujo de ejecución, con una sobrecarga mínima en comparación con un hilo. - Una corrutina también se conoce como subprocesos nativos, fibras (en Windows), subprocesos ligeros, subprocesos verdes (en Java), etc.

### ¿Por qué necesitamos corrutinas?
- Como suelo hacer, antes de aprender algo nuevo, deberías plantearte esta pregunta. Pero, déjame responderla:
- Las corrutinas pueden proporcionar un alto nivel de concurrencia con muy poca sobrecarga, ya que no requieren la intervención del sistema operativo en la programación. En un entorno de hilos, la sobrecarga de programación del sistema operativo es responsabilidad del usuario.
- Una corrutina puede suspenderse en un punto predeterminado, lo que también evita el bloqueo en estructuras de datos compartidas. Nunca le pedirías a tu código que cambie a otra corrutina en medio de una sección crítica.
- Con los hilos, cada hilo necesita su propia pila con almacenamiento local y otras funciones. Por lo tanto, el uso de memoria aumenta linealmente con el número de hilos. Mientras que con las co-rutinas, la cantidad de rutinas que tienes no tiene una relación directa con el uso de memoria.
- Para la mayoría de los casos de uso, la corrutina es una opción más óptima, ya que es más rápida en comparación con los hilos.
- Y si aún no estás convencido, espera mi publicación sobre [Corrutina de C++20](https://vishalchovatiya.com/posts/cpp20-coroutine-under-the-hood/).
## Teoría de la API de Cambio de Contexto concisa

- Antes de profundizar en la implementación de una corrutina en C, necesitamos comprender las siguientes funciones/API fundamentales para el cambio de contexto. Por supuesto, como siempre, con menos teoría concisa y más ejemplos de código.
1. `setcontext`
2. `getcontext`
3. `makecontext`
4. `swapcontext`
- Si ya está familiarizado con [`setjmp`/`longjmp`](https://vishalchovatiya.com/posts/error-handling-setjmp-longjmp/), es posible que le resulte fácil comprender estas funciones. Puede considerarlas como una versión avanzada de [`setjmp`/`longjmp`](https://vishalchovatiya.com/posts/error-handling-setjmp-longjmp/). La única diferencia es que [`setjmp`/`longjmp`](https://vishalchovatiya.com/posts/error-handling-setjmp-longjmp/) solo permite un único salto no local en la pila. Mientras que estas API permiten la creación de múltiples hilos de control cooperativos, cada uno con su propia pila o punto de entrada.

### Estructura de datos para almacenar el contexto de ejecución

- La estructura de tipo `ucontext_t`, definida como se muestra a continuación, se utiliza para almacenar el contexto de ejecución.
- Las cuatro funciones de flujo de control (`setcontext`, `getcontext`, `makecontext` y `swapcontext`) operan en esta estructura.
```c
typedef struct {
    ucontext_t *uc_link;    
    stack_t     uc_stack;
    mcontext_t  uc_mcontext;
    sigset_t    uc_sigmask;
    ...
} ucontext_t;
```
- `uc_link` apunta al contexto que se reanudará al finalizar el contexto actual, si este se creó con `makecontext` (un contexto secundario).
- ``uc_stack`` es la pila utilizada por el contexto.
- ``uc_mcontext`` almacena el estado de ejecución, incluyendo todos los registros y banderas de la CPU, el puntero de trama/base (indica la trama de ejecución actual), el puntero de instrucción (el contador de programa), el registro de enlace (almacena la dirección de retorno) y el puntero de pila (indica el límite actual de la pila o el final de la trama actual). `mcontext_t` es un tipo opaco (https://en.wikipedia.org/wiki/Opaque_data_type).
- `uc_sigmask` se utiliza para almacenar el conjunto de señales bloqueadas en el contexto. Este no es el tema central de hoy.

### `int setcontext(const ucontext_t *ucp)`
- Esta función transfiere el control al contexto en `ucp`. La ejecución continúa desde el punto donde se almacenó el contexto en `ucp`. `setcontext` no retorna.

### `int getcontext(ucontext_t *ucp)`
- Guarda el contexto actual en `ucp`. Esta función retorna en dos casos posibles:
1. después de la llamada inicial,
2. o cuando un hilo cambia al contexto en `ucp` mediante `setcontext` o `swapcontext`. - La función `getcontext` no proporciona un valor de retorno para distinguir los casos (su valor de retorno se usa únicamente para señalar errores), por lo que el programador debe usar una variable de bandera explícita, que no debe ser una variable de registro y debe declararse `volátil` para evitar la propagación constante u otras optimizaciones del compilador.

## [Ejemplo 1]: Comprensión del cambio de contexto con las funciones `setcontext` y `getcontext`

- Ahora que hemos leído bastante teoría, vamos a darle sentido.
- Considere el siguiente programa que implementa un bucle infinito que imprime "Hola mundo" cada segundo.
```c
#include <stdio.h>
#include <ucontext.h>
#include <unistd.h>
#include <stdlib.h>

int main( ) {
    ucontext_t ctx = {0};

    getcontext(&ctx);   // Loop start
    puts("Hello world");
    sleep(1);
    setcontext(&ctx);   // Loop end 

    return EXIT_SUCCESS;
}
```

- Aquí, `getcontext` retorna con ambos casos posibles, como mencionamos anteriormente, es decir:
1. después de la llamada inicial,
2. cuando un hilo cambia al contexto mediante `setcontext`.
- Creo que el resto se explica por sí solo.

## [Example 2]: Understanding Control Flow With `makecontext` & `swapcontext` Functions

```c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <signal.h>
#include <ucontext.h>

void assign(uint32_t *var, uint32_t val) { 
    *var = val; 
}

int main( ) {
    uint32_t var = 0;
    ucontext_t ctx = {0}, back = {0};

    getcontext(&ctx);

    ctx.uc_stack.ss_sp = calloc(1, MINSIGSTKSZ);
    ctx.uc_stack.ss_size = MINSIGSTKSZ;
    ctx.uc_stack.ss_flags = 0;

    ctx.uc_link = &back; // Will get back to main as `swapcontext` call will populate `back` with current context
    // ctx.uc_link = 0;  // Will exit directly after `swapcontext` call

    makecontext(&ctx, (void (*)())assign, 2, &var, 100);
    swapcontext(&back, &ctx);    // Calling `assign` by switching context

    printf("var = %d\n", var);

    return EXIT_SUCCESS;
}
```

- Aquí, la función `makecontext` configura un hilo de control alternativo en `ctx`. Y cuando se realiza un salto con `ctx` usando `swapcontext`, la ejecución comenzará en `assign`, con los argumentos respectivos según lo especificado.
- Cuando `assign` termina, el control se cambiará a `ctx.uc_link`. Este apunta a `back` y se completará con `swapcontext` antes del salto/cambio de contexto.
- Si `ctx.uc_link` se establece en 0, entonces el contexto de ejecución actual se considera el contexto principal y el hilo saldrá cuando el contexto `assign` finalice.
- Antes de realizar una llamada a `makecontext`, la aplicación/desarrollador debe asegurarse de que el contexto que se está modificando tenga una pila preasignada. Y `argc` coincide con el número de argumentos de tipo `int` pasados ​​a `func`. De lo contrario, el comportamiento no está definido.
## Corrutina en lenguaje C

- Inicialmente, creé un solo archivo para mostrar el ejemplo. Pero luego me di cuenta de que sería demasiado para abarcarlo en un solo archivo. Por lo tanto, dividí la implementación y el ejemplo de uso en archivos separados para que el ejemplo sea más comprensible y fácil de entender.

### Implementación de corrutina en C

- Aquí está la corrutina más simple en lenguaje C:

#### coroutine.h
```c
#pragma once

#include <stdint.h>
#include <stdlib.h>
#include <ucontext.h>
#include <stdbool.h>

typedef struct coro_t_ coro_t;
typedef int (*coro_function_t)(coro_t *coro);

/* 
    Coroutine handler
*/
struct coro_t_ {
    coro_function_t     function;           // Actual co-routine function
    ucontext_t          suspend_context;    // Stores context previous to coroutine jump
    ucontext_t          resume_context;     // Stores coroutine context
    int                 yield_value;        // Coroutine return/yield value
    bool                is_coro_finished;   // To indicate the current coroutine status
};

/* 
    Coroutine APIs for users
*/
coro_t *coro_new(coro_function_t function);
int coro_resume(coro_t *coro);    
void coro_yield(coro_t *coro, int value);
void coro_free(coro_t *coro);

```

- Por ahora, simplemente ignore las API de corrutinas.
- El punto principal a considerar es el manejador de corrutinas, que tiene el siguiente campo:
	- `function`: Contiene la dirección de la función de corrutina proporcionada por el usuario.
	- `suspend_context`: Se utiliza para suspender la función de corrutina.
	- `resume_context`: Contiene el contexto de la función de corrutina.
	- `yield_value`: Almacena el valor de retorno entre el punto de suspensión intermedio y el valor de retorno final.
	- `is_coro_finished`: Un indicador para verificar el estado de la vida útil de la corrutina.

#### coroutine.c
```c
#include <signal.h>
#include "coroutine.h"

static void _coro_entry_point(coro_t *coro) {
    int return_value = coro->function(coro);
    coro->is_coro_finished = true;
    coro_yield(coro, return_value);
}

coro_t *coro_new(coro_function_t function) {
    coro_t *coro = calloc(1, sizeof(*coro));

    coro->is_coro_finished = false;
    coro->function = function;
    coro->resume_context.uc_stack.ss_sp = calloc(1, MINSIGSTKSZ);
    coro->resume_context.uc_stack.ss_size = MINSIGSTKSZ;
    coro->resume_context.uc_link = 0;

    getcontext(&coro->resume_context);
    makecontext(&coro->resume_context, (void (*)())_coro_entry_point, 1, coro);
    return coro;
}

int coro_resume(coro_t *coro) {    
    if (coro->is_coro_finished) return -1;
    swapcontext(&coro->suspend_context, &coro->resume_context);
    return coro->yield_value;
}

void coro_yield(coro_t *coro, int value) {
    coro->yield_value = value;
    swapcontext(&coro->resume_context, &coro->suspend_context);
}

void coro_free(coro_t *coro) {
    free(coro->resume_context.uc_stack.ss_sp);
    free(coro);
}

```

Las API más utilizadas para corrutinas son `coro_resume` y `coro_yield`, que retrasan el trabajo de suspensión y reanudación.

Si ya has revisado los ejemplos de API de cambio de contexto anteriores, no creo que haya mucho que explicar sobre `coro_resume` y `coro_yield`. Simplemente `coro_yield` salta a `coro_resume` y viceversa. Excepto por la primera llamada a `coro_resume`, que salta a `_coro_entry_point`.

La función ``coro_new`` asigna memoria para el controlador y la pila, y luego rellena los miembros del controlador. Nuevamente, `getcontext` y `makecontext` deberían estar claros a estas alturas. Si no es así, vuelve a leer la sección anterior sobre ejemplos de API de cambio de contexto.
- Si realmente comprendes la implementación de la API de corrutinas anterior, la pregunta obvia sería: ¿por qué necesitamos `_coro_entry_point`? ¿Por qué no podemos acceder directamente a la función de corrutina?
- En ese caso, mi argumento sería: "¿Cómo se asegura la duración de la corrutina?".
- Esto técnicamente significa que el número de llamadas a `coro_resume` debe ser similar/válido al número de llamadas a `coro_yield` más uno (para el retorno real).
- De lo contrario, no se puede realizar un seguimiento de los rendimientos. El comportamiento se volverá indefinido.
- Sin embargo, se necesita la función `_coro_entry_point`; de lo contrario, no se puede deducir que la ejecución de la corrutina ha finalizado por completo. Y la siguiente llamada a `coro_resume` ya no es válida.

#### Duración de la corrutina
- Con la implementación anterior, **usando el controlador de corrutina**, solo debería poder ejecutar la función de corrutina completamente una vez durante la vida del programa/aplicación.
- Si desea volver a llamar a la función de corrutina, deberá crear un nuevo controlador de corrutina. El resto del proceso se mantendrá igual.

### Ejemplo de uso de corrutina

#### coroutine_example.c
```c
#include <stdio.h>
#include <assert.h>
#include "coroutine.h"

int hello_world(coro_t *coro) {    
    puts("Hello");
    coro_yield(coro, 1);    // Suspension point that returns the value `1`
    puts("World");
    return 2;
}

int main() {
    coro_t *coro = coro_new(hello_world);
    assert(coro_resume(coro) == 1);     // Verifying return value
    assert(coro_resume(coro) == 2);     // Verifying return value
    assert(coro_resume(coro) == -1);    // Invalid call
    coro_free(coro);
    return EXIT_SUCCESS;
}
```

El caso de uso es bastante sencillo:

Primero, se crea un controlador de corrutina.

Luego, se inicia/reanuda la función de corrutina con la ayuda del mismo controlador.

Y, siempre que la función de corrutina encuentre una llamada a `coro_yield`, suspenderá la ejecución y devolverá el valor pasado en el segundo argumento de `coro_yield`.

Y cuando la ejecución de la función de corrutina finalice por completo, la llamada a `coro_resume` devolverá -1 para indicar que el objeto del controlador de corrutina ya no es válido y su vida útil ha expirado.

Como puede ver, `coro_resume` es un contenedor de nuestra corrutina `hello_world`, que la ejecuta por partes (obviamente mediante cambio de contexto).

#### Compilación
- He probado este ejemplo en WSL con gcc 9.3.0 y glibc 2.31.
```c
$ gcc -I./ coroutine_example.c coroutine.c  -o myapp && ./myapp 
Hello
World
```

## Palabras de despedida

Como ven, no hay magia si se entiende "Cómo la CPU ejecuta el código...". Glibc, por cierto, proporcionaba un amplio conjunto de API de cambio de contexto. Y, desde la perspectiva de los desarrolladores de bajo nivel, se trata simplemente de llamadas a funciones de cambio de contexto bien organizadas y difíciles de organizar y mantener (si se usan sin formato). Mi intención aquí era sentar las bases para la corrutina de C++20. Porque creo que, si se ve el código desde la perspectiva de la CPU y el compilador, todo se vuelve fácil de entender en C++. Nos vemos la próxima vez con mi publicación sobre la [Corrutina de C++20](https://vishalchovatiya.com/posts/cpp20-coroutine-under-the-hood/).