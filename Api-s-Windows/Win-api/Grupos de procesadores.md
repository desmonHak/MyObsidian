[https://learn.microsoft.com/es-es/windows/win32/procthread/processor-groups](https://learn.microsoft.com/es-es/windows/win32/procthread/processor-groups)

Las versiones de 64 bits de Windows 7 y Windows Server 2008 R2 y las versiones posteriores de Windows admiten más de 64 procesadores lógicos en un solo equipo. Esta funcionalidad no está disponible en las versiones de 32 bits de Windows.

Los sistemas con más de un procesador físico o los sistemas con procesadores físicos que tienen varios núcleos proporcionan al sistema operativo varios procesadores lógicos. Un _procesador lógico_ es un motor informático lógico desde la perspectiva del sistema operativo, la aplicación o el controlador. Un _núcleo_ es una unidad de procesador, que puede constar de uno o varios procesadores lógicos. Un _procesador físico_ puede constar de uno o varios núcleos. Un procesador físico es lo mismo que un paquete de procesador, un socket o una CPU.

La compatibilidad con sistemas que tienen más de 64 procesadores lógicos se basa en el concepto de un _grupo de procesadores_, que es un conjunto estático de hasta 64 procesadores lógicos que se tratan como una sola entidad de programación. Los grupos de procesadores se numeran a partir de 0. Los sistemas con menos de 64 procesadores lógicos siempre tienen un solo grupo, el Grupo 0.

**Windows Server 2008, Windows Vista, Windows Server 2003 y Windows XP:** Los grupos de procesadores no se admiten.

Cuando se inicia el sistema, el sistema operativo crea los grupos de procesadores y les asigna procesadores lógicos. Si el sistema puede agregar procesadores en caliente, el sistema operativo deja espacio en los grupos para los procesadores que puedan llegar mientras se ejecuta el sistema. El sistema operativo minimiza el número de grupos de un sistema. Por ejemplo, un sistema con 128 procesadores lógicos tendrá dos grupos de procesadores con 64 procesadores en cada grupo, no cuatro grupos con 32 procesadores lógicos en cada grupo.

Para mejorar el rendimiento, el sistema operativo tiene en cuenta la ubicación física al asignar los procesadores lógicos a los grupos. Todos los procesadores lógicos de un núcleo y todos los núcleos de un procesador físico se asignan al mismo grupo, si es posible. Los procesadores físicos que están físicamente próximos se asignan al mismo grupo. Un nodo NUMA se asigna a un único grupo, a menos que la capacidad del nodo supere el tamaño máximo del grupo. Para obtener más información, consulte [Soporte técnico de NUMA](https://learn.microsoft.com/es-es/windows/win32/procthread/numa-support).

En los sistemas con 64 o menos procesadores, las aplicaciones existentes funcionarán correctamente sin modificaciones. Las aplicaciones que no llamen a ninguna función que utilice máscaras de afinidad de procesador o números de procesador funcionarán correctamente en todos los sistemas, independientemente del número de procesadores. Para funcionar correctamente en sistemas con más de 64 procesadores lógicos, es posible que los siguientes tipos de aplicaciones requieran modificaciones:

- Las aplicaciones que administran, mantienen o muestran información por procesador para todo el sistema deben modificarse para admitir más de 64 procesadores lógicos. Un ejemplo de esta aplicación es el Administrador de tareas de Windows, que muestra la carga de trabajo de cada procesador del sistema.
- Las aplicaciones para las que el rendimiento es crítico y que se pueden escalar eficazmente a partir de 64 procesadores lógicos deben modificarse para ejecutarse en dichos sistemas. Por ejemplo, las aplicaciones de base de datos pueden beneficiarse de las modificaciones.
- Si una aplicación usa un archivo DLL que tiene estructuras de datos por procesador y el archivo DLL no se ha modificado para admitir más de 64 procesadores lógicos, todos los subprocesos de la aplicación que llaman a funciones exportadas por el archivo DLL deben asignarse al mismo grupo.

De forma predeterminada, una aplicación está restringida a un único grupo, que debe proporcionar una amplia capacidad de procesamiento para la aplicación típica. El sistema operativo asigna inicialmente cada proceso a un único grupo de manera equilibrada entre los grupos del sistema. Un proceso inicia su ejecución asignado a un grupo. El primer subproceso de un proceso se ejecuta inicialmente en el grupo al que se asigna el proceso. Cada subproceso que se acaba de crear se asigna al mismo grupo que el subproceso que lo ha creado.

Una aplicación que requiere el uso de varios grupos para que pueda ejecutarse en más de 64 procesadores debe determinar explícitamente dónde se ejecutan sus subprocesos y es responsable de establecer las afinidades de procesador de los subprocesos en los grupos deseados. La marca [INHERIT_PARENT_AFFINITY](https://learn.microsoft.com/es-es/windows/win32/procthread/process-creation-flags) se puede usar para especificar un proceso primario (que puede ser distinto del proceso actual) desde el que se genera la afinidad para un nuevo proceso. Si el proceso se ejecuta en un único grupo, puede leer y modificar su afinidad utilizando [**GetProcessAffinityMask**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-getprocessaffinitymask) y[**SetProcessAffinityMask**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-setprocessaffinitymask) mientras permanece en el mismo grupo; si se modifica la afinidad de proceso, la nueva afinidad se aplica a sus subprocesos.

La afinidad de un subproceso se puede especificar al crearlo utilizando el atributo extendido [**PROC_THREAD_ATTRIBUTE_GROUP_AFFINITY**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-updateprocthreadattribute) con la función [**CreateRemoteThreadEx**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-createremotethreadex). Una vez creado el subproceso, se puede cambiar su afinidad llamando a [**SetThreadAffinityMask**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-setthreadaffinitymask) o [**SetThreadGroupAffinity**](https://learn.microsoft.com/es-es/windows/win32/api/processtopologyapi/nf-processtopologyapi-setthreadgroupaffinity). Si se asigna un subproceso a un grupo diferente del proceso, la afinidad del proceso se actualiza para incluir la afinidad del subproceso y el proceso se convierte en un proceso de varios grupos. Se deben realizar cambios de afinidad adicionales para subprocesos individuales; no se puede modificar la afinidad de un proceso de varios grupos utilizando [**SetProcessAffinityMask**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-setprocessaffinitymask). La función [**GetProcessGroupAffinity**](https://learn.microsoft.com/es-es/windows/win32/api/processtopologyapi/nf-processtopologyapi-getprocessgroupaffinity) recupera el conjunto de grupos a los que se asignan un proceso y sus subprocesos.

Para especificar afinidad para todos los procesos asociados a un objeto de trabajo, use la función [**SetInformationJobObject**](https://learn.microsoft.com/es-es/windows/win32/api/jobapi2/nf-jobapi2-setinformationjobobject) con la clase de información **JobObjectGroupInformation** o **JobObjectGroupInformationEx**.

Un procesador lógico se identifica mediante su número de grupo y su número de procesador relativo al grupo. Esto se representa mediante una estructura [**PROCESSOR_NUMBER**](https://learn.microsoft.com/es-es/windows/desktop/api/WinNT/ns-winnt-processor_number). Los números de procesador numérico usados por las funciones heredadas son relativos al grupo.

Para ver un análisis de los cambios de arquitectura del sistema operativo para admitir más de 64 procesadores, consulte las notas del producto [Sistemas admitidos que tienen más de 64 procesadores](https://plexuk.co.uk/?p=400).

Para ver una lista de las nuevas funciones y estructuras que admiten grupos de procesadores, consulte [Novedades de procesos y subprocesos](https://learn.microsoft.com/es-es/windows/win32/procthread/what-s-new-in-processes-and-threads).

[](https://learn.microsoft.com/es-es/windows/win32/procthread/processor-groups#behavior-starting-with-windows-11-and-windows-server-2022)

### Comportamiento a partir de Windows 11 y Windows Server 2022

 Nota

A partir de Windows 11 y Windows Server 2022, ya no se da caso de que las aplicaciones estén restringidas de forma predeterminada a un único grupo de procesadores. En su lugar, los procesos y sus subprocesos tienen afinidades de procesador que, de forma predeterminada, abarcan todos los procesadores del sistema, en varios grupos de máquinas con más de 64 procesadores.

Para que las aplicaciones aprovechen automáticamente todos los procesadores de una máquina con más de 64 procesadores, a partir de Windows 11 y Windows Server 2022, el sistema operativo ha cambiado para que los procesos y sus subprocesos abarquen todos los procesadores del sistema, en todos los grupos de procesadores, de forma predeterminada. Esto significa que las aplicaciones ya no necesitan establecer explícitamente las afinidades de sus subprocesos para poder acceder a varios grupos de procesadores.

Por motivos de compatibilidad, el sistema operativo usa un nuevo concepto de **grupo principal** para los procesos y los subprocesos. A cada proceso se le asigna un grupo principal al crearse y, de forma predeterminada, el grupo principal de todos sus subprocesos es el mismo. El procesador ideal de cada subproceso se encuentra en el grupo principal del subproceso, por lo que los subprocesos se programarán preferentemente en los procesadores de su grupo principal, pero pueden estar programados para los procesadores de cualquier otro grupo. Las API de afinidad que no son compatibles con grupos o que operan en un único grupo usan implícitamente el grupo principal como grupo de procesadores de procesos o subprocesos; para obtener más información sobre los nuevos comportamientos, consulte las secciones Comentarios para:

- [**GetProcessAffinityMask**](https://learn.microsoft.com/es-es/windows/win32/api/winbase/nf-winbase-getprocessaffinitymask) 
- [**GetProcessGroupAffinity**](https://learn.microsoft.com/es-es/windows/win32/api/processtopologyapi/nf-processtopologyapi-getprocessgroupaffinity)
- [**GetThreadGroupAffinity**](https://learn.microsoft.com/es-es/windows/win32/api/processtoologyapi/nf-processtopologyapi-getthreadgroupaffinity)
- [[GetThreadAffinityMask - Establecer afinidad de hilos]]
- [**SetThreadGroupAffinity**](https://learn.microsoft.com/es-es/windows/win32/api/processtopologyapi/nf-processtopologyapi-setthreadgroupaffinity)
- [**SetProcessAffinityMask**](https://learn.microsoft.com/es-es/windows/win32/api/winbase/nf-winbase-setprocessaffinitymask) -> [[SetProcessAffinityMask - Cambiar afinidad de un proceso]]
- [**SetThreadAffinityMask**](https://learn.microsoft.com/es-es/windows/win32/api/winbase/nf-winbase-setthreadaffinitymask) -> [[SetThreadAffinityMask - Cambiar afinidad de un subproceso]]
- [**SetThreadIdealProcessor**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreadidealprocessor) -> [[SetThreadIdealProcessor - Cambiar afinidad ideal para el hilo en los nucleos]]
- [**SetThreadIdealProcessorEx**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreadidealprocessorex)
- [[SetThreadGroupAffinity - Cambiar afinidad de grupo de núcleos para subproceso]]


Las aplicaciones pueden usar [**conjuntos de CPU**](https://learn.microsoft.com/es-es/windows/win32/procthread/cpu-sets) para administrar eficazmente la afinidad de un proceso o subproceso en varios grupos de procesadores.

[](https://learn.microsoft.com/es-es/windows/win32/procthread/processor-groups#related-topics)

## Temas relacionados

[Varios procesadores](https://learn.microsoft.com/es-es/windows/win32/procthread/multiple-processors)

[Compatibilidad NUMA](https://learn.microsoft.com/es-es/windows/win32/procthread/numa-support)
