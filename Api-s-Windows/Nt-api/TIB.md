recurso: [Estructura del TIB](https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_NT_TIB)

```c
struct _EXCEPTION_REGISTRATION_RECORD { 
	struct _EXCEPTION_REGISTRATION_RECORD* Next; 
	void* Handler; 
};
```

Función para imprimir la lista enlazada de _EXCEPTION_REGISTRATION_RECORD:
```c
void print_exception_list(struct _EXCEPTION_REGISTRATION_RECORD* exceptionList) {
    int index = 0;
    while (exceptionList != NULL) {
        printf("      ExceptionList[%d]:\n", index);
        printf("      Next: %p\n", exceptionList->Next);
        printf("      Handler: %p\n", exceptionList->Handler);
        exceptionList = exceptionList->Next;
        index++;
    }
}
```

```c
//0x38 bytes (sizeof) 
struct _NT_TIB { 
	struct _EXCEPTION_REGISTRATION_RECORD* ExceptionList; //0x0 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_EXCEPTION_REGISTRATION_RECORD
	VOID* StackBase;                                      //0x8 
	VOID* StackLimit;                                     //0x10 
	VOID* SubSystemTib;                                   //0x18 
	union { 
		VOID* FiberData;                                  //0x20 
		ULONG Version;                                    //0x20 
	}; 
	VOID* ArbitraryUserPointer;                           //0x28 
	struct _NT_TIB* Self;                                 //0x30 
	// https://www.vergiliusproject.com/kernels/x64/windows-11/23h2/_NT_TIB
};
```
Función para imprimir los campos de la estructura _NT_TIB:
```c
void print_nt_tib(struct _NT_TIB* tib) {
    printf("    ExceptionList:\n");
    print_exception_list(tib->ExceptionList);
    printf("    StackBase: %p\n", tib->StackBase);
    printf("    StackLimit: %p\n", tib->StackLimit);
    printf("    SubSystemTib: %p\n", tib->SubSystemTib);

    // Verificación del campo de unión
    if (tib->FiberData != NULL) {
        printf("    FiberData: %p\n", tib->FiberData);
    } else {
        printf("    Version: %lu\n", tib->Version);
    }
    printf("    ArbitraryUserPointer: %p\n", tib->ArbitraryUserPointer);
    printf("    Self: %p\n", tib->Self);
}
```
