[https://learn.microsoft.com/es-es/windows/win32/procthread/process-security-and-access-rights](https://learn.microsoft.com/es-es/windows/win32/procthread/process-security-and-access-rights)
 modelo de seguridad de Microsoft Windows permite controlar el acceso a los objetos de proceso. Para obtener más información sobre la seguridad, consulte [Modelo de control de acceso](https://learn.microsoft.com/es-es/windows/win32/secauthz/access-control-model).

Cuando un usuario inicia sesión, el sistema recopila un conjunto de datos que identifica de forma única al usuario durante el proceso de autenticación y lo almacena en un [token de acceso](https://learn.microsoft.com/es-es/windows/win32/secauthz/access-tokens). Este token de acceso describe el contexto de seguridad de todos los procesos asociados al usuario. El contexto de seguridad de un proceso es el conjunto de credenciales dadas al proceso o a la cuenta de usuario que creó el proceso.

Puede usar un token para especificar el contexto de seguridad actual de un proceso mediante la función [**CreateProcessWithTokenW**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-createprocesswithtokenw) . Puede especificar un [descriptor de seguridad](https://learn.microsoft.com/es-es/windows/win32/secauthz/security-descriptors) para un proceso al llamar a la función [**CreateProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessa), [**CreateProcessAsUser**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessasusera) o [**CreateProcessWithLogonW**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-createprocesswithlogonw) . Si especifica **NULL**, el proceso obtiene un descriptor de seguridad predeterminado. Las ACL del descriptor de seguridad predeterminado de un proceso proceden del token principal o de suplantación del creador.

Para recuperar el descriptor de seguridad de un proceso, llame a la función [**GetSecurityInfo**](https://learn.microsoft.com/es-es/windows/win32/api/aclapi/nf-aclapi-getsecurityinfo) . Para cambiar el descriptor de seguridad de un proceso, llame a la función [**SetSecurityInfo**](https://learn.microsoft.com/es-es/windows/win32/api/aclapi/nf-aclapi-setsecurityinfo) .

Los derechos de acceso válidos para los objetos de proceso incluyen los [derechos de acceso estándar](https://learn.microsoft.com/es-es/windows/win32/secauthz/standard-access-rights) y algunos derechos de acceso específicos del proceso. En la tabla siguiente se enumeran los derechos de acceso estándar usados por todos los objetos.

|Valor|Significado|
|---|---|
|**DELETE** (0x00010000L)|Necesario para eliminar el objeto.|
|**READ_CONTROL** (0x00020000L)|Se requiere para leer información en el descriptor de seguridad del objeto, no incluida la información de SACL. Para leer o escribir sacl, debe solicitar el derecho de acceso **ACCESS_SYSTEM_SECURITY** . Para obtener más información, consulte [Derecho de acceso SACL](https://learn.microsoft.com/es-es/windows/win32/secauthz/sacl-access-right).|
|**SYNCHRONIZE** (0x00100000L)|Derecho a utilizar el objeto para la sincronización. Esto permite que un subproceso espere hasta que el objeto esté en estado señalado.|
|**WRITE_DAC** (0x00040000L)|Necesario para modificar la DACL en el descriptor de seguridad del objeto.|
|**WRITE_OWNER** (0x00080000L)|Necesario para cambiar el propietario en el descriptor de seguridad del objeto.|

En la tabla siguiente se enumeran los derechos de acceso específicos del proceso.

|Valor|Significado|
|---|---|
|**PROCESS_ALL_ACCESS** (STANDARD_RIGHTS_REQUIRED (0x000F00000L) \| SYNCHRONIZE (0x00100000L) \| 0xFFFF)|Todos los derechos de acceso posibles para un objeto de proceso. **Windows Server 2003 y Windows XP:** El tamaño de la **marca de PROCESS_ALL_ACCESS** aumentó en Windows Server 2008 y Windows Vista. Si una aplicación compilada para Windows Server 2008 y Windows Vista se ejecuta en Windows Server 2003 o Windows XP, la **marca de PROCESS_ALL_ACCESS** es demasiado grande y la función que especifica esta marca produce un error con **ERROR_ACCESS_DENIED**. Para evitar este problema, especifique el conjunto mínimo de derechos de acceso necesarios para la operación. Si **se** debe usar PROCESS_ALL_ACCESS, establezca _WIN32_WINNT en el sistema operativo mínimo de destino de la aplicación (por ejemplo, `#define _WIN32_WINNT _WIN32_WINNT_WINXP`). Para obtener más información, vea [Uso de los encabezados de Windows](https://learn.microsoft.com/es-es/windows/win32/winprog/using-the-windows-headers).|
|**PROCESS_CREATE_PROCESS** (0x0080)|Necesario para usar este proceso como proceso primario con [**PROC_THREAD_ATTRIBUTE_PARENT_PROCESS**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-updateprocthreadattribute).|
|**PROCESS_CREATE_THREAD** (0x0002)|Necesario para crear un subproceso en el proceso.|
|**PROCESS_DUP_HANDLE** (0x0040)|Necesario para duplicar un identificador mediante [**DuplicateHandle**](https://learn.microsoft.com/es-es/windows/win32/api/handleapi/nf-handleapi-duplicatehandle).|
|**PROCESS_QUERY_INFORMATION** (0x0400)|Necesario para recuperar cierta información sobre un proceso, como su token, el código de salida y la clase priority (consulte [**OpenProcessToken**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocesstoken)).|
|**PROCESS_QUERY_LIMITED_INFORMATION** (0x1000)|Necesario para recuperar cierta información sobre un proceso (vea [**GetExitCodeProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-getexitcodeprocess), [**GetPriorityClass**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-getpriorityclass), [**IsProcessInJob**](https://learn.microsoft.com/es-es/windows/win32/api/jobapi/nf-jobapi-isprocessinjob), [**QueryFullProcessImageName**](https://learn.microsoft.com/es-es/windows/desktop/api/WinBase/nf-winbase-queryfullprocessimagenamea)). Se concede automáticamente un identificador que tenga el derecho de acceso **PROCESS_QUERY_INFORMATION****PROCESS_QUERY_LIMITED_INFORMATION**. **Windows Server 2003 y Windows XP:** Este derecho de acceso no se admite.|
|**PROCESS_SET_INFORMATION** (0x0200)|Necesario para establecer cierta información sobre un proceso, como su clase de prioridad (consulte [**SetPriorityClass**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-setpriorityclass)).|
|**PROCESS_SET_QUOTA** (0x0100)|Necesario para establecer límites de memoria mediante [**SetProcessWorkingSetSize**](https://learn.microsoft.com/es-es/windows/desktop/api/memoryapi/nf-memoryapi-setprocessworkingsetsize).|
|**PROCESS_SUSPEND_RESUME** (0x0800)|Necesario para suspender o reanudar un proceso.|
|**PROCESS_TERMINATE** (0x0001)|Necesario para finalizar un proceso mediante [**TerminateProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-terminateprocess).|
|**PROCESS_VM_OPERATION** (0x0008)|Necesario para realizar una operación en el espacio de direcciones de un proceso (consulte [**VirtualProtectEx**](https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-virtualprotectex) y [**WriteProcessMemory**](https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory)).|
|**PROCESS_VM_READ** (0x0010)|Necesario para leer la memoria en un proceso mediante [**ReadProcessMemory**](https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-readprocessmemory).|
|**PROCESS_VM_WRITE** (0x0020)|Necesario para escribir en memoria en un proceso mediante [**WriteProcessMemory**](https://learn.microsoft.com/es-es/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory).|
|**SYNCHRONIZE** (0x00100000L)|Necesario para esperar a que el proceso finalice mediante las [funciones de espera](https://learn.microsoft.com/es-es/windows/win32/sync/wait-functions).|

Para abrir un identificador a otro proceso y obtener derechos de acceso completo, debe habilitar el privilegio **SeDebugPrivilege** . Para obtener más información, consulte [Cambio de privilegios en un token](https://learn.microsoft.com/es-es/windows/win32/secbp/changing-privileges-in-a-token).

El identificador devuelto por la función [**CreateProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessa) tiene **PROCESS_ALL_ACCESS** acceso al objeto de proceso. Al llamar a la función [**OpenProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess) , el sistema comprueba los [derechos de acceso](https://learn.microsoft.com/es-es/windows/win32/secauthz/access-rights-and-access-masks) solicitados en la DACL en el descriptor de seguridad del proceso. Cuando se llama a la función [**GetCurrentProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentprocess) , el sistema devuelve un pseudohandle con el acceso máximo que permite la DACL al autor de la llamada.

Puede solicitar el derecho de acceso **ACCESS_SYSTEM_SECURITY** a un objeto de proceso si desea leer o escribir la SACL del objeto. Para obtener más información, consulte [Access-Control Lists (ACL)](https://learn.microsoft.com/es-es/windows/win32/secauthz/access-control-lists) y [SACL Access Right](https://learn.microsoft.com/es-es/windows/win32/secauthz/sacl-access-right).

 Advertencia
Un proceso que tenga algunos de los derechos de acceso indicados aquí puede usarlos para obtener otros derechos de acceso. Por ejemplo, si el proceso A tiene un identificador para procesar B con **PROCESS_DUP_HANDLE** acceso, puede duplicar el pseudo handle para el proceso B. Esto crea un identificador que tiene acceso máximo al proceso B. Para obtener más información sobre los pseudo handles, consulte [**GetCurrentProcess**](https://learn.microsoft.com/es-es/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentprocess).

## Procesos protegidos

Windows Vista presenta _procesos protegidos_ para mejorar la compatibilidad con Digital Rights Management. El sistema restringe el acceso a procesos protegidos y a los subprocesos de procesos protegidos.

No se permiten los siguientes derechos de acceso estándar desde un proceso a un proceso protegido:

- **DELETE**
- **READ_CONTROL**
- **WRITE_DAC**
- **WRITE_OWNER**

No se permiten los siguientes derechos de acceso específicos de un proceso a un proceso protegido:

- **PROCESS_ALL_ACCESS**
- **PROCESS_CREATE_PROCESS**
- **PROCESS_CREATE_THREAD**
- **PROCESS_DUP_HANDLE**
- **PROCESS_QUERY_INFORMATION**
- **PROCESS_SET_INFORMATION**
- **PROCESS_SET_QUOTA**
- **PROCESS_VM_OPERATION**
- **PROCESS_VM_READ**
- **PROCESS_VM_WRITE**

El **PROCESS_QUERY_LIMITED_INFORMATION** derecho se introdujo para proporcionar acceso a un subconjunto de la información disponible a través de **PROCESS_QUERY_INFORMATION**.