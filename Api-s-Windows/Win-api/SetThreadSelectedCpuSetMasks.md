Para usar [[SetProcessAffinityMask]] en un sistema con más de 64 cores, como uno con 128 cores, necesitas tener en cuenta que Windows divide los procesadores en grupos de hasta 64 cores cada uno. En un sistema de 128 cores, tendrías 2 grupos de procesadores.Desafortunadamente, [[SetProcessAffinityMask]] está limitado a trabajar con un solo grupo de procesadores a la vez. Para manejar sistemas con múltiples grupos, debes usar funciones más nuevas. Aquí te presento algunas opciones:

1. Usar [[SetThreadGroupAffinity]]:  
    Esta función te permite establecer la afinidad para un hilo específico en un grupo de procesadores particular. Tendrías que llamarla para cada hilo de tu proceso.
```c
GROUP_AFFINITY groupAffinity;
groupAffinity.Mask = 0xFFFFFFFFFFFFFFFF; // Todos los cores en el grupo
groupAffinity.Group = 0; // Primer grupo
SetThreadGroupAffinity(GetCurrentThread(), &groupAffinity, NULL);
```

2. Usar [[SetThreadSelectedCpuSetMasks]]:  
    Esta función, introducida en Windows 11 y Windows Server 2022, te permite establecer la afinidad de un hilo a través de múltiples grupos de procesadores[](https://stackoverflow.com/questions/76317127/windows-11-thread-affinities-spanning-multiple-processor-groups-explicitly).
```c
GROUP_AFFINITY affinities[2];
affinities[0].Mask = 0xFFFFFFFFFFFFFFFF; // Todos los cores en el grupo 0
affinities[0].Group = 0;
affinities[1].Mask = 0xFFFFFFFFFFFFFFFF; // Todos los cores en el grupo 1
affinities[1].Group = 1;

SetThreadSelectedCpuSetMasks(GetCurrentThread(), affinities, 2, 0);
```

3. Usar SetInformationJobObject:  
    Si quieres establecer la afinidad para todos los procesos asociados a un objeto de trabajo, puedes usar esta función con la clase de información JobObjectGroupInformation o JobObjectGroupInformationEx[](https://learn.microsoft.com/es-es/windows/win32/procthread/processor-groups).

Es importante notar que a partir de Windows 11 y Windows Server 2022, los procesos y sus hilos tienen afinidades de procesador que, por defecto, abarcan todos los procesadores del sistema, incluso en máquinas con más de 64 procesadores[](https://learn.microsoft.com/es-es/windows/win32/procthread/processor-groups). Esto significa que, en muchos casos, no necesitarás establecer explícitamente la afinidad a menos que quieras restringir la ejecución a un subconjunto específico de cores.Si necesitas un control más fino sobre la afinidad en sistemas con múltiples grupos de procesadores, considera usar estas funciones más nuevas en lugar de SetProcessAffinityMask.

Share

Rewrite