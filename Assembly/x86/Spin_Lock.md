https://www.codeproject.com/Articles/784/User-Level-Spin-Locks
"El concepto de exclusión mutua es crucial en el desarrollo de sistemas operativos. Se refiere a la garantía de que un solo hilo puede acceder a un recurso en particular a la vez. La exclusión mutua es necesaria cuando un recurso no se presta al acceso compartido o cuando compartirlo daría como resultado un resultado impredecible... Si un hilo lee una ubicación de memoria mientras otro escribe en ella, el primer hilo recibirá datos impredecibles... El mismo error podría ocurrir en un sistema de un solo procesador si el sistema operativo realizara un cambio de contexto mientras los dos hilos están accediendo a este recurso no compartible o sección crítica... El área de mayor preocupación son las interrupciones. El núcleo (o un hilo) podría estar actualizando una estructura de datos global cuando ocurre una interrupción cuya rutina de manejo de interrupciones también modifica la estructura"

## 1. ¿Qué es un Spin Lock?

Un Spin Lock es un mecanismo de sincronización entre procesos o tareas como un [[Mutex]], un ``Semáforo`` o una ``Sección Crítica`` (Win32). Los ``Spin Locks`` se utilizan a menudo en núcleos de sistemas operativos multiprocesador simétricos. Porque **a veces** es más eficiente sondear constantemente la disponibilidad de un bloqueo en lugar de...

1. Interrumpir el hilo (hacer el cambio de contexto), programar otro hilo.
2. Mantener y modificar las estructuras de mantenimiento adicionales ("quién" es el propietario del objeto de sincronización o el bloqueo, cuánto tiempo, ha transcurrido el intervalo de tiempo de espera,...)
3. Hacer el trabajo adicional (de llamadas a funciones de C o incluso de rutinas de ensamblador) para un mecanismo justo de primero en entrar, primero en salir.

Comparado con la estructura [[CRITICAL_SECTION]] de Win32 y sus funciones, y ciertamente con cualquier otro mecanismo de sincronización como ``mutexes`` y semáforos avanzados, un ``Spin Lock`` es ciertamente menos justo (no hay protección -en esta versión de todos modos- contra la "inanición" teórica de un hilo que está esperando eternamente a que se desbloquee el recurso).

Además, es más "inseguro" para sus programas: si un hilo que mantiene el bloqueo muere inesperadamente (sin liberar el bloqueo), el ``Spin Lock`` presentado no tiene forma de saberlo, por lo tanto, sus hilos que esperan el recurso tampoco podrán recuperarse y, por lo tanto, "girar eternamente", consumiendo ciclos de ``CPU``.

Pero si se usa con mucho cuidado, un ``Spin Lock`` es en ciertas situaciones mucho más rápido que cualquier otro mecanismo de sincronización que su sistema operativo tenga para ofrecer (a menos que también proporcione ``Spin Locks`` accesibles para el usuario, por supuesto). Estas clases (una versión no reentrante y una reentrante de un ``SPIN LOCK`` DE NIVEL DE USUARIO) se construyeron porque son un mecanismo de sincronización "semiportátil". para subprocesos o tareas dentro del mismo proceso o espacio de direcciones. Puede utilizar este mecanismo de bloqueo en software que se ejecuta sobre un sistema operativo y también en un sistema sin sistema operativo donde tiene que proteger colas, búferes, listas, estructuras, etc. contra rutinas de interrupción, que pueden dejar sus datos compartidos en un estado inconsistente. Esta situación tiene muchas similitudes con un problema de sincronización de subprocesos (condición de carrera) para una sección crítica de un programa multiproceso estándar de Win32.

Todo lo que tienes que hacer es trasladar una (1) función a tu plataforma de CPU específica. (La implementación [[i80386]] tiene solo 4 instrucciones de longitud).

Cuando investigué por primera vez estos problemas de sincronización para sistemas sin SO integrado, me encontré con mecanismos de bloqueo de software como el algoritmo de Peterson([[Petersons_Algorithm]]) (para proteger una sección crítica contra la corrupción de datos por parte de 2 procesos o tareas en competencia) y el algoritmo ``Bakery`` de ``Lamport``([[Lamports_Bakery_Algorithm]]) (para proteger una sección crítica contra la corrupción de datos por parte de N procesos o tareas en competencia). Ambas soluciones (y sus derivados) parten del supuesto de que las lecturas y escrituras son "atómicas". Esto simplemente significa que las lecturas y escrituras ocurren en una secuencia no interrumpible de instrucciones (de ``CPU``) (o preferiblemente solo una instrucción de ``CPU``), lo que no es el caso para la mayoría de las plataformas de hardware; solo observa la cantidad de instrucciones de procesador ([[i80386]]) necesarias para almacenar o escribir un valor en una variable.

Esta explicación nos lleva a la forma estándar de evitar la corrupción de datos en el mundo sin sistema operativo, cuando la memoria se comparte entre rutinas de interrupción y una parte "normal" (no controlada por interrupciones) del programa (lo que generalmente se conoce como el "bucle principal"):

=> Deshabilitar temporalmente las interrupciones desde dentro del bucle principal al recuperar datos del búfer compartido.

Bastante "poco convincente", como dicen, porque esta solución puede (en casos extremos) provocar la "pérdida de eventos", si la función de "recuperación" en el bucle principal tarda demasiado en completarse.

La solución aquí es encontrar una instrucción específica del procesador que sea segura para [[SMP]] y se ejecute en una secuencia no interrumpible. Como ejemplo, la instrucción [[SWAP]] es la más utilizada. Esta idea simple pero ingeniosa también se conoce en la literatura como el método "[[Test_And_Set]]".

## 2. El algoritmo

El algoritmo de hardware para un semáforo binario que utiliza el método de prueba y configuración:

```c
wait(s)
{
   do
   {
      set s = 0; 
      if (s == 0 && previous value of s == 1)
      {
         break; // Nosotros obtuvimos la cerradura
      }
   }
   while (true);
}

signal(s)
{
    set s = 1; // liberar el bloqueo
}
```

Solo para poner el punto sobre la í:

Esto no es nada nuevo; puedes encontrarlo en cualquier buen libro de texto que explique los aspectos internos de un sistema operativo.

## 3. Implementación de Spin Lock:
### 3.1 Spin Lock no reentrante
```c
// ¡¡ESTA CERRADURA NO ES REENTRANTE!!
class CPP_SpinLock
{
public:    // constructor en línea
    // destructor NO virtual en línea
    inline CPP_SpinLock() : m_s(1) {}
    inline ~CPP_SpinLock() {}    
    
    // entrar en la cerradura, spinlocks (con/sin Sleep)
    // Cuando mutex ya está bloqueado
    inline void Enter(void)
    {
        int prev_s;
        do
        {
            prev_s = TestAndSet(&m_s, 0);
            if (m_s == 0 && prev_s == 1)
            {
                break;
            }
			// anulamos el intervalo de tiempo actual (solo se puede 
			// usar cuando el sistema operativo está disponible y 
			// NO queremos 'spin')
            // HWSleep(0);
        }
        while (true);
    }
	// Intenta ingresar al bloqueo, devuelve 0
	// cuando el mutex ya está bloqueado,
	// devuelve != 0 si tiene éxito
    inline int TryEnter(void)
    {
        int prev_s = TestAndSet(&m_s, 0);
        if (m_s == 0 && prev_s == 1)
        {
            return 1;
        }
        return 0;
    }
	// Abandona o desbloquea el mutex
	// (solo debe ser llamado por el propietario del bloqueo)
    inline void Leave(void)
    {
        TestAndSet(&m_s, 1);
    }
    
    protected:
	// establece el valor BIT y retorna el valor anterior
	// value.in 1 operación atómica ininterrumpible
    int TestAndSet(int* pTargetAddress, int nValue);
    
    private:
    int m_s;
};

// This part is Platform dependent!
[[ifdef]] WIN32
inline int CPP_SpinLock::TestAndSet(int* pTargetAddress, 
                                              int nValue)
{
    __asm
    {
        mov edx, dword ptr [pTargetAddress]
        mov eax, nValue
        lock xchg eax, dword ptr [edx]
    }
    // mov = 1 CPU cycle
    // lock = 1 CPU cycle
    // xchg = 3 CPU cycles
}
[[endif]] // WIN32
```

### 3.2 Spin Lock reentrante
```c
// ¡ESTE BLOQUEO ES REENTRANTE!
// Gracias a George V. Reilly por señalar
// las fallas en la primera implementación ineficiente.
// Aquí está el segundo intento.
// NB PNumber se usa como el número de tarea, subproceso o
// proceso; en Windows, debe
// pasarle GetCurrentThreadId().
// Para sistemas integrados, debe pasarle los números de tarea (o interrupción) asignados.
class CPP_SpinLock_Reentrant_Hopefully_Less_Clumsy
{
public:

    inline 
      CPP_SpinLock_Reentrant_Hopefully_Less_Clumsy()  
      m_nLockCount(0), 
      m_nOwner(0xffffffff) {};

    inline 
      ~CPP_SpinLock_Reentrant_Hopefully_Less_Clumsy() {};

    inline void Enter(unsigned int PNumber)
    {
        if (PNumber == m_nOwner)
        {
            m_nLockCount++;
            return;
        }
        m_RealCS.Enter();
        m_nOwner = PNumber;
        m_nLockCount++;
        return;
    }

    inline int TryEnter(unsigned int PNumber)
    {
        if (PNumber == m_nOwner) // we own it
        {
            m_nLockCount++;
            return 1;
        }
        if (m_RealCS.TryEnter())
        {
            m_nOwner = PNumber;
            m_nLockCount++;
            return 1;
        }
        return 0;
    }

    inline void Leave(unsigned int PNumber)
    {
        assert(PNumber == m_nOwner);
        m_nLockCount--;
        if (m_nLockCount == 0)
        {
            m_nOwner = 0xffffffff;
            m_RealCS.Leave();
        }
    }

protected:

private:
    CPP_SpinLock m_RealCS;
    unsigned int m_nLockCount;
    unsigned int m_nOwner;
};
```
## 4. Spin Lock Uso

### 4.1 ¿Cuándo debería usar un Spin Lock?
Solo cuando tenga sentido no hacer un cambio de contexto en caso de que haya un recurso bloqueado:
- El tiempo que el hilo tiene que esperar es menor que la cantidad de tiempo para hacer el cambio de contexto. (¡Esto solo es cierto para sistemas operativos [[SMP]] que se ejecutan en hardware [[SMP]]! Si no hay un paralelismo real y tiene un sistema operativo preventivo, debería preferir **siempre** un cambio de contexto. ¿Qué hilo liberará el recurso de todos modos en un sistema de un solo procesador?)
- La probabilidad de un conflicto de recursos (= la probabilidad de tener que esperar realmente el bloqueo) en la sección crítica es muy pequeña o el tiempo de espera promedio es menor que el tiempo que necesita el sistema operativo para hacer el cambio de contexto.
- La sección crítica en sí es muy pequeña y la cantidad de comprobaciones es muy alta.
- No tiene otro mecanismo de sincronización porque no tiene un sistema operativo.
### 4.2 Beneficios de usar un Spin Lock:
Depende de la situación, por supuesto (como veremos en un par de pruebas): **velocidad**. Una verificación de la Sección Crítica de NT (y el recurso está "libre"; tienes una "luz verde") requiere aproximadamente 6 ciclos de CPU. (No he comprobado esto; también depende del tipo de CPU, pero recuerdo haberlo leído en alguna parte. N.B.: Siempre puedes hacer más pruebas tú mismo si lo deseas...).

## ## 5. Las pruebas
El sistema de prueba es un PII dual de 350 MHz (2 CPU), 256 MB de RAM y ejecuta Windows 2000 Advanced Server Edition.

Dependiendo de la situación, la versión NOT-REENTRANT es aproximadamente de 1 a 5 veces más rápida (y recuerda que a veces también es más lenta y desperdicia recursos) que la versión `EnterCriticalSection`/`LeaveCriticalSection`, que es el mecanismo de sincronización Win32 más rápido. Sin embargo, la versión REENTRANT es mucho (más de 2 veces) más lenta y solo se proporciona para programadores de sistemas integrados sin SO. Estoy seguro de que la implementación puede ser mucho más rápida al usar más "ensamblador", pero eso disminuiría la portabilidad (un mejor algoritmo reentrante también funcionaría). Entonces, si no necesitas reentrada, ¡no uses la versión reentrante!

En todas las pruebas, cuanto mayor sea el número, mejor será el rendimiento. En estas pruebas no se puede encontrar ninguna prueba absoluta. Solo sirven para reflexionar sobre las cosas. Dejemos que prevalezca el sentido común.

Prueba 1:
Este código de prueba generará muchas colisiones en la sección crítica, por lo que surgirán otras diferencias cuando las colisiones sean escasas.
```c
double value = 0;
double prevvalue = 0;
bool stop = false;

CPP_SpinLock theTestMutex;
CRITICAL_SECTION theCS;

void IncreaseValue(unsigned int PNumber)
{
    theTestMutex.Enter();
    // EnterCriticalSection(&theCS);
    prevvalue = value;
    value++;
    if (prevvalue != value-1)
    {
        MessageBox(NULL, "Oh Oh Oh!", 0, MB_OKCANCEL);
    }
    theTestMutex.Leave();
    // LeaveCriticalSection(&theCS);
}

DWORD WINAPI ThreadProc( LPVOID lpParameter )
{
    while (!stop)
    {
        IncreaseValue((unsigned int) lpParameter);
    }
    return 0;
}

int main(int argc, char* argv[])
{
    HANDLE hThread1 = NULL;
    HANDLE hThread2 = NULL;
    DWORD dwThreadID1 = 0;
    DWORD dwThreadID2 = 0;

    InitializeCriticalSection(&theCS);

    hThread1 = ::CreateThread(NULL, 0, 
      ThreadProc, (void*) 0, 0, &dwThreadID1);
    hThread2 = ::CreateThread(NULL, 0, ThreadProc, 
      (void*) 1, 0, &dwThreadID2);

    WaitForSingleObject(hThread1, 10000);

    stop = true;

    WaitForSingleObject(hThread1, INFINITE);
    WaitForSingleObject(hThread2, INFINITE);

    CloseHandle(hThread1);
    CloseHandle(hThread2);

    DeleteCriticalSection(&theCS);

    cerr << "\nNumber Increases:" 
             << value << "\n";

    return 0;
}
```
```c
Using the CRITICAL_SECTION
Run1 output: Number Increases:1.2227e+006
Run2 output: Number Increases:1.29654e+006
Run3 output: Number Increases: 1.23221e+006
Run4 output: Number Increases: 1.15439e+006

Using the Spin Lock 
Run1 output: Number Increases: 8.43261e+006
Run2 output: Number Increases: 9.13226e+006
Run3 output: Number Increases: 8.1077e+006
Run4 output: Number Increases: 7.93513e+006
```

Esto sin duda probaría mi punto, pero no se alegren todavía. Las diferencias de rendimiento son más sutiles que eso.

### 5.2 Prueba 2:

Ahora, cambiamos el código de prueba, por lo que ya no tenemos colisiones en la cerradura:
```c
double value[2];
double prevvalue[2];
bool stop = false;

CPP_SpinLock theTestMutex[2];
CRITICAL_SECTION theCS[2];

void IncreaseValue(unsigned int PNumber)
{
    theTestMutex[PNumber].Enter();
    // EnterCriticalSection(&(theCS[PNumber]));
    prevvalue[PNumber] = value[PNumber];
    (value[PNumber])++;
    if (prevvalue[PNumber] != value[PNumber]-1)
    {
        MessageBox(NULL, "Oh Oh Oh!", 0, MB_OKCANCEL);
    }
    theTestMutex[PNumber].Leave();
    // LeaveCriticalSection(&(theCS[PNumber]));
}

DWORD WINAPI ThreadProc( LPVOID lpParameter )
{
    while (!stop)
    {
        IncreaseValue((unsigned int) lpParameter);
    }
    return 0;
}

int main(int argc, char* argv[])
{
    HANDLE hThread1 = NULL;
    HANDLE hThread2 = NULL;
    DWORD dwThreadID1 = 0;
    DWORD dwThreadID2 = 0;

    InitializeCriticalSection(&(theCS[0]));
    InitializeCriticalSection(&(theCS[1]));

    value[0] = 0;
    prevvalue[0] = 0;
    value[1] = 0;
    prevvalue[1] = 0;

    hThread1 = ::CreateThread(NULL, 0, 
      ThreadProc, (void*) 0, 0, &dwThreadID1);
    hThread2 = ::CreateThread(NULL, 0, ThreadProc, 
      (void*) 1, 0, &dwThreadID2);

    WaitForSingleObject(hThread1, 10000);

    stop = true;

    WaitForSingleObject(hThread1, INFINITE);
    WaitForSingleObject(hThread2, INFINITE);

    CloseHandle(hThread1);
    CloseHandle(hThread2);

    DeleteCriticalSection(&(theCS[0]));
    DeleteCriticalSection(&(theCS[1]));

    cerr << "\nNumber Increases:" 
      << value[0] + value[1] << "\n";

    return 0;
}
```
```c
Using the CRITICAL_SECTION
Run1 output: Number Increases: 1.01325e+007
Run2 output: Number Increases: 1.06665e+007
Run3 output: Number Increases: 1.13035e+007
Run4 output: Number Increases: 1.04613e+007

Using the Spin Lock 
Run1 output: Number Increases: 1.04721e+007
Run2 output: Number Increases: 1.13043e+007
Run3 output: Number Increases: 1.17862e+007
Run4 output: Number Increases: 1.09453e+007
```
En mi opinión, no hay una diferencia significativa, aunque el bloqueo de giro parece hacer un trabajo ligeramente mejor.

5.3 Prueba 3:
```c
double value;
double prevvalue;
bool stop = false;

CPP_SpinLock theTestMutex;
CRITICAL_SECTION theCS;

DWORD WINAPI ThreadProc2( LPVOID lpParameter )
{
    while (!stop)
    {
        // theTestMutex.Enter();
        EnterCriticalSection(&(theCS));
        (value)++;
        // theTestMutex.Leave();
        LeaveCriticalSection(&(theCS));
    }
    return 0;
}

int main(int argc, char* argv[])
{
    HANDLE hThread1 = NULL;
    DWORD dwThreadID1 = 0;

    InitializeCriticalSection(&(theCS));

    value = 0;
    prevvalue = 0;

    hThread1 = ::CreateThread(NULL, 0, 
      ThreadProc2, (void*) 0, 0, &dwThreadID1);

    WaitForSingleObject(hThread1, 10000);

    stop = true;

    WaitForSingleObject(hThread1, INFINITE);

    CloseHandle(hThread1);

    DeleteCriticalSection(&(theCS));

    cerr << "\nNumber Increases:" 
           << value << "\n";

    return 0;
}
```
```c
Using the CRITICAL_SECTION
Run1 output: Number Increases: 4.19735e+007
Run2 output: Number Increases: 4.18007e+007
Run3 output: Number Increases: 4.19747e+007
Run4 output: Number Increases: 4.2017e+007

Using the Spin Lock 
Run1 output: Number Increases: 4.19765e+007
Run2 output: Number Increases: 4.1972e+007
Run3 output: Number Increases: 4.20036e+007
Run4 output: Number Increases: 4.19853e+007
```
Esto tampoco muestra una diferencia "grande" (en mi humilde opinión, no muestra ninguna diferencia en absoluto). Simplemente creo que las Secciones críticas de Win32 tienen una implementación bastante eficiente.

6. Conclusión
Depende del usuario potencial de estos bloqueos giratorios decidir qué aplicación es la más adecuada para ellos.

Los bloqueos giratorios se pueden utilizar en un dispositivo integrado sin un sistema operativo o se pueden utilizar, con cuidado, en una máquina [[SMP]] con un sistema operativo [[SMP]]. El mecanismo se utiliza para aplicar la exclusión mutua para recursos compartidos. No se recomienda utilizar bloqueos giratorios (de bloqueo) en sistemas monoprocesador. La pregunta clave es si el desarrollador permitirá que el programador intervenga en caso de un "recurso compartido" o una "sección crítica" bloqueados. Si se decide "activar" el bloqueo, el desarrollador debe estar seguro de que se obtendrá un mejor rendimiento al no activar el cambio de contexto.