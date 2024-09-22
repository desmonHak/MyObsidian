Ejemplo simplificado de cómo se podría usar [[NtSetInformationProcess]] para establecer la afinidad de un proceso:
```c
NTSTATUS Status;
DWORD_PTR AffinityMask = 0x0001; // Ejemplo: afinidad al primer procesador

Status = NtSetInformationProcess(
    ProcessHandle,
    ProcessAffinityMask,
    &AffinityMask,
    sizeof(AffinityMask)
);

if (!NT_SUCCESS(Status)) {
    // Manejar el error
}
```