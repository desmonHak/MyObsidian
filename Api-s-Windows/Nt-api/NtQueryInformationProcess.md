```c

/*
 * @implemented
 */
NTSTATUS
NTAPI
NtQueryInformationProcess(
    _In_ HANDLE ProcessHandle,
    _In_ PROCESSINFOCLASS ProcessInformationClass,
    _Out_ PVOID ProcessInformation,
    _In_ ULONG ProcessInformationLength,
    _Out_opt_ PULONG ReturnLength)
{
    PEPROCESS Process;
    KPROCESSOR_MODE PreviousMode = ExGetPreviousMode();
    NTSTATUS Status;
    ULONG Length = 0;
    HANDLE DebugPort = 0;
    PPROCESS_BASIC_INFORMATION ProcessBasicInfo = (PPROCESS_BASIC_INFORMATION)ProcessInformation;
    
    PKERNEL_USER_TIMES ProcessTime = (PKERNEL_USER_TIMES)ProcessInformation;
    ULONG UserTime, KernelTime;
    PPROCESS_PRIORITY_CLASS PsPriorityClass = (PPROCESS_PRIORITY_CLASS)ProcessInformation;
    
    ULONG HandleCount;
    PPROCESS_SESSION_INFORMATION SessionInfo = (PPROCESS_SESSION_INFORMATION)ProcessInformation;
    
    PVM_COUNTERS VmCounters = (PVM_COUNTERS)ProcessInformation;
    PIO_COUNTERS IoCounters = (PIO_COUNTERS)ProcessInformation;
    PQUOTA_LIMITS QuotaLimits = (PQUOTA_LIMITS)ProcessInformation;
    PUNICODE_STRING ImageName;
    ULONG Cookie, ExecuteOptions = 0;
    ULONG_PTR Wow64 = 0;
    PROCESS_VALUES ProcessValues;
    ULONG Flags;
    PAGED_CODE();
 
    /* Verify Information Class validity */
    Status = DefaultQueryInfoBufferCheck(ProcessInformationClass,
                                         PsProcessInfoClass,
                                         RTL_NUMBER_OF(PsProcessInfoClass),
                                         ICIF_PROBE_READ,
                                         ProcessInformation,
                                         ProcessInformationLength,
                                         ReturnLength,
                                         NULL,
                                         PreviousMode);
    if (!NT_SUCCESS(Status))
    {
        DPRINT1("NtQueryInformationProcess(): Information verification class failed! (Status -> 0x%lx, ProcessInformationClass -> %lx)\n", Status, ProcessInformationClass);
        return Status;
    }
 
    if (((ProcessInformationClass == ProcessCookie) ||
         (ProcessInformationClass == ProcessImageInformation)) &&
        (ProcessHandle != NtCurrentProcess()))
    {
        /*
         * Retrieving the process cookie is only allowed for the calling process
         * itself! XP only allows NtCurrentProcess() as process handles even if
         * a real handle actually represents the current process.
         */
        return STATUS_INVALID_PARAMETER;
    }
 
    /* Check the information class */
    switch (ProcessInformationClass)
    {
        /* Basic process information */
        case ProcessBasicInformation:
 
            if (ProcessInformationLength != sizeof(PROCESS_BASIC_INFORMATION))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set return length */
            Length = sizeof(PROCESS_BASIC_INFORMATION);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Protect writes with SEH */
            _SEH2_TRY
            {
                /* Write all the information from the EPROCESS/KPROCESS */
                ProcessBasicInfo->ExitStatus = Process->ExitStatus;
                ProcessBasicInfo->PebBaseAddress = Process->Peb;
                ProcessBasicInfo->AffinityMask = Process->Pcb.Affinity;
                ProcessBasicInfo->UniqueProcessId = (ULONG_PTR)Process->
                                                    UniqueProcessId;
                ProcessBasicInfo->InheritedFromUniqueProcessId =
                    (ULONG_PTR)Process->InheritedFromUniqueProcessId;
                ProcessBasicInfo->BasePriority = Process->Pcb.BasePriority;
 
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Process quota limits */
        case ProcessQuotaLimits:
 
            if (ProcessInformationLength != sizeof(QUOTA_LIMITS))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            Length = sizeof(QUOTA_LIMITS);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Indicate success */
            Status = STATUS_SUCCESS;
 
            _SEH2_TRY
            {
                /* Set max/min working set sizes */
                QuotaLimits->MaximumWorkingSetSize =
                        Process->Vm.MaximumWorkingSetSize << PAGE_SHIFT;
                QuotaLimits->MinimumWorkingSetSize =
                        Process->Vm.MinimumWorkingSetSize << PAGE_SHIFT;
 
                /* Set default time limits */
                QuotaLimits->TimeLimit.LowPart = MAXULONG;
                QuotaLimits->TimeLimit.HighPart = MAXULONG;
 
                /* Is quota block a default one? */
                if (Process->QuotaBlock == &PspDefaultQuotaBlock)
                {
                    /* Set default pools and pagefile limits */
                    QuotaLimits->PagedPoolLimit = (SIZE_T)-1;
                    QuotaLimits->NonPagedPoolLimit = (SIZE_T)-1;
                    QuotaLimits->PagefileLimit = (SIZE_T)-1;
                }
                else
                {
                    /* Get limits from non-default quota block */
                    QuotaLimits->PagedPoolLimit =
                        Process->QuotaBlock->QuotaEntry[PsPagedPool].Limit;
                    QuotaLimits->NonPagedPoolLimit =
                        Process->QuotaBlock->QuotaEntry[PsNonPagedPool].Limit;
                    QuotaLimits->PagefileLimit =
                        Process->QuotaBlock->QuotaEntry[PsPageFile].Limit;
                }
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessIoCounters:
 
            if (ProcessInformationLength != sizeof(IO_COUNTERS))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            Length = sizeof(IO_COUNTERS);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Query IO counters from the process */
            KeQueryValuesProcess(&Process->Pcb, &ProcessValues);
 
            _SEH2_TRY
            {
                RtlCopyMemory(IoCounters, &ProcessValues.IoInfo, sizeof(IO_COUNTERS));
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Ignore exception */
            }
            _SEH2_END;
 
            /* Set status to success in any case */
            Status = STATUS_SUCCESS;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Timing */
        case ProcessTimes:
 
            /* Set the return length */
            if (ProcessInformationLength != sizeof(KERNEL_USER_TIMES))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            Length = sizeof(KERNEL_USER_TIMES);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Protect writes with SEH */
            _SEH2_TRY
            {
                /* Copy time information from EPROCESS/KPROCESS */
                KernelTime = KeQueryRuntimeProcess(&Process->Pcb, &UserTime);
                ProcessTime->CreateTime = Process->CreateTime;
                ProcessTime->UserTime.QuadPart = (LONGLONG)UserTime * KeMaximumIncrement;
                ProcessTime->KernelTime.QuadPart = (LONGLONG)KernelTime * KeMaximumIncrement;
                ProcessTime->ExitTime = Process->ExitTime;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Process Debug Port */
        case ProcessDebugPort:
 
            if (ProcessInformationLength != sizeof(HANDLE))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set return length */
            Length = sizeof(HANDLE);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Protect write with SEH */
            _SEH2_TRY
            {
                /* Return whether or not we have a debug port */
                *(PHANDLE)ProcessInformation = (Process->DebugPort ?
                                                (HANDLE)-1 : NULL);
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessHandleCount:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length*/
            Length = sizeof(ULONG);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Count the number of handles this process has */
            HandleCount = ObGetProcessHandleCount(Process);
 
            /* Protect write in SEH */
            _SEH2_TRY
            {
                /* Return the count of handles */
                *(PULONG)ProcessInformation = HandleCount;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Session ID for the process */
        case ProcessSessionInformation:
 
            if (ProcessInformationLength != sizeof(PROCESS_SESSION_INFORMATION))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length*/
            Length = sizeof(PROCESS_SESSION_INFORMATION);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for write safety */
            _SEH2_TRY
            {
                /* Write back the Session ID */
                SessionInfo->SessionId = PsGetProcessSessionId(Process);
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Virtual Memory Statistics */
        case ProcessVmCounters:
 
            /* Validate the input length */
            if ((ProcessInformationLength != sizeof(VM_COUNTERS)) &&
                (ProcessInformationLength != sizeof(VM_COUNTERS_EX)))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for write safety */
            _SEH2_TRY
            {
                /* Return data from EPROCESS */
                VmCounters->PeakVirtualSize = Process->PeakVirtualSize;
                VmCounters->VirtualSize = Process->VirtualSize;
                VmCounters->PageFaultCount = Process->Vm.PageFaultCount;
                VmCounters->PeakWorkingSetSize = Process->Vm.PeakWorkingSetSize;
                VmCounters->WorkingSetSize = Process->Vm.WorkingSetSize;
                VmCounters->QuotaPeakPagedPoolUsage = Process->QuotaPeak[PsPagedPool];
                VmCounters->QuotaPagedPoolUsage = Process->QuotaUsage[PsPagedPool];
                VmCounters->QuotaPeakNonPagedPoolUsage = Process->QuotaPeak[PsNonPagedPool];
                VmCounters->QuotaNonPagedPoolUsage = Process->QuotaUsage[PsNonPagedPool];
                VmCounters->PagefileUsage = Process->QuotaUsage[PsPageFile] << PAGE_SHIFT;
                VmCounters->PeakPagefileUsage = Process->QuotaPeak[PsPageFile] << PAGE_SHIFT;
                //VmCounters->PrivateUsage = Process->CommitCharge << PAGE_SHIFT;
                //
 
                /* Set the return length */
                Length = ProcessInformationLength;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Hard Error Processing Mode */
        case ProcessDefaultHardErrorMode:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length*/
            Length = sizeof(ULONG);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for writing back data */
            _SEH2_TRY
            {
                /* Write the current processing mode */
                *(PULONG)ProcessInformation = Process->
                                              DefaultHardErrorProcessing;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Priority Boosting status */
        case ProcessPriorityBoost:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length */
            Length = sizeof(ULONG);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for writing back data */
            _SEH2_TRY
            {
                /* Return boost status */
                *(PULONG)ProcessInformation = Process->Pcb.DisableBoost ?
                                              TRUE : FALSE;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* DOS Device Map */
        case ProcessDeviceMap:
 
            if (ProcessInformationLength == sizeof(PROCESS_DEVICEMAP_INFORMATION_EX))
            {
                /* Protect read in SEH */
                _SEH2_TRY
                {
                    PPROCESS_DEVICEMAP_INFORMATION_EX DeviceMapEx = ProcessInformation;
 
                    Flags = DeviceMapEx->Flags;
                }
                _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
                {
                    /* Get the exception code */
                    Status = _SEH2_GetExceptionCode();
                    _SEH2_YIELD(break);
                }
                _SEH2_END;
 
                /* Only one flag is supported and it needs LUID mappings */
                if ((Flags & ~PROCESS_LUID_DOSDEVICES_ONLY) != 0 ||
                    !ObIsLUIDDeviceMapsEnabled())
                {
                    Status = STATUS_INVALID_PARAMETER;
                    break;
                }
            }
            else
            {
                /* This has to be the size of the Query union field for x64 compatibility! */
                if (ProcessInformationLength != RTL_FIELD_SIZE(PROCESS_DEVICEMAP_INFORMATION, Query))
                {
                    Status = STATUS_INFO_LENGTH_MISMATCH;
                    break;
                }
 
                /* No flags for standard call */
                Flags = 0;
            }
 
            /* Set the return length */
            Length = ProcessInformationLength;
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Query the device map information */
            Status = ObQueryDeviceMapInformation(Process,
                                                 ProcessInformation,
                                                 Flags);
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Priority class */
        case ProcessPriorityClass:
 
            if (ProcessInformationLength != sizeof(PROCESS_PRIORITY_CLASS))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length*/
            Length = sizeof(PROCESS_PRIORITY_CLASS);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for writing back data */
            _SEH2_TRY
            {
                /* Return current priority class */
                PsPriorityClass->PriorityClass = Process->PriorityClass;
                PsPriorityClass->Foreground = FALSE;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessImageFileName:
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Get the image path */
            Status = SeLocateProcessImageName(Process, &ImageName);
            if (NT_SUCCESS(Status))
            {
                /* Set return length */
                Length = ImageName->MaximumLength +
                         sizeof(OBJECT_NAME_INFORMATION);
 
                /* Make sure it's large enough */
                if (Length <= ProcessInformationLength)
                {
                    /* Enter SEH to protect write */
                    _SEH2_TRY
                    {
                        /* Copy it */
                        RtlCopyMemory(ProcessInformation,
                                      ImageName,
                                      Length);
 
                        /* Update pointer */
                        ((PUNICODE_STRING)ProcessInformation)->Buffer =
                            (PWSTR)((PUNICODE_STRING)ProcessInformation + 1);
                   }
                    _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
                    {
                        /* Get the exception code */
                        Status = _SEH2_GetExceptionCode();
                    }
                    _SEH2_END;
                }
                else
                {
                    /* Buffer too small */
                    Status = STATUS_INFO_LENGTH_MISMATCH;
                }
 
                /* Free the image path */
                ExFreePoolWithTag(ImageName, TAG_SEPA);
            }
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessDebugFlags:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length*/
            Length = sizeof(ULONG);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for writing back data */
            _SEH2_TRY
            {
                /* Return the debug flag state */
                *(PULONG)ProcessInformation = Process->NoDebugInherit ? 0 : 1;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessBreakOnTermination:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length */
            Length = sizeof(ULONG);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Enter SEH for writing back data */
            _SEH2_TRY
            {
                /* Return the BreakOnTermination state */
                *(PULONG)ProcessInformation = Process->BreakOnTermination;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        /* Per-process security cookie */
        case ProcessCookie:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                /* Length size wrong, bail out */
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Get the current process and cookie */
            Process = PsGetCurrentProcess();
            Cookie = Process->Cookie;
            if (!Cookie)
            {
                LARGE_INTEGER SystemTime;
                ULONG NewCookie;
                PKPRCB Prcb;
 
                /* Generate a new cookie */
                KeQuerySystemTime(&SystemTime);
                Prcb = KeGetCurrentPrcb();
                NewCookie = Prcb->KeSystemCalls ^ Prcb->InterruptTime ^
                            SystemTime.u.LowPart ^ SystemTime.u.HighPart;
 
                /* Set the new cookie or return the current one */
                Cookie = InterlockedCompareExchange((LONG*)&Process->Cookie,
                                                    NewCookie,
                                                    Cookie);
                if (!Cookie) Cookie = NewCookie;
 
                /* Set return length */
                Length = sizeof(ULONG);
            }
 
            /* Indicate success */
            Status = STATUS_SUCCESS;
 
            /* Enter SEH to protect write */
            _SEH2_TRY
            {
                /* Write back the cookie */
                *(PULONG)ProcessInformation = Cookie;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
            break;
 
        case ProcessImageInformation:
 
            if (ProcessInformationLength != sizeof(SECTION_IMAGE_INFORMATION))
            {
                /* Break out */
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the length required and validate it */
            Length = sizeof(SECTION_IMAGE_INFORMATION);
 
            /* Enter SEH to protect write */
            _SEH2_TRY
            {
                MmGetImageInformation((PSECTION_IMAGE_INFORMATION)ProcessInformation);
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Indicate success */
            Status = STATUS_SUCCESS;
            break;
 
        case ProcessDebugObjectHandle:
 
            if (ProcessInformationLength != sizeof(HANDLE))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length */
            Length = sizeof(HANDLE);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Get the debug port */
            Status = DbgkOpenProcessDebugPort(Process, PreviousMode, &DebugPort);
 
            /* Let go of the process */
            ObDereferenceObject(Process);
 
            /* Protect write in SEH */
            _SEH2_TRY
            {
                /* Return debug port's handle */
                *(PHANDLE)ProcessInformation = DebugPort;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
            break;
 
        case ProcessHandleTracing:
            DPRINT1("Handle tracing Not implemented: %lx\n", ProcessInformationClass);
            Status = STATUS_NOT_IMPLEMENTED;
            break;
 
        case ProcessLUIDDeviceMapsEnabled:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length */
            Length = sizeof(ULONG);
 
            /* Indicate success */
            Status = STATUS_SUCCESS;
 
            /* Protect write in SEH */
            _SEH2_TRY
            {
                /* Query Ob */
                *(PULONG)ProcessInformation = ObIsLUIDDeviceMapsEnabled();
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
            break;
 
        case ProcessWx86Information:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set the return length */
            Length = sizeof(ULONG);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Protect write in SEH */
            _SEH2_TRY
            {
                /* Return if the flag is set */
                *(PULONG)ProcessInformation = (ULONG)Process->VdmAllowed;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get the exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessWow64Information:
 
            if (ProcessInformationLength != sizeof(ULONG_PTR))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set return length */
            Length = sizeof(ULONG_PTR);
 
            /* Reference the process */
            Status = ObReferenceObjectByHandle(ProcessHandle,
                                               PROCESS_QUERY_INFORMATION,
                                               PsProcessType,
                                               PreviousMode,
                                               (PVOID*)&Process,
                                               NULL);
            if (!NT_SUCCESS(Status)) break;
 
            /* Make sure the process isn't dying */
            if (ExAcquireRundownProtection(&Process->RundownProtect))
            {
                /* Get the WOW64 process structure */
#ifdef _WIN64
                Wow64 = (ULONG_PTR)Process->Wow64Process;
#else
                Wow64 = 0;
#endif
                /* Release the lock */
                ExReleaseRundownProtection(&Process->RundownProtect);
            }
 
            /* Protect write with SEH */
            _SEH2_TRY
            {
                /* Return whether or not we have a debug port */
                *(PULONG_PTR)ProcessInformation = Wow64;
            }
            _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
            {
                /* Get exception code */
                Status = _SEH2_GetExceptionCode();
            }
            _SEH2_END;
 
            /* Dereference the process */
            ObDereferenceObject(Process);
            break;
 
        case ProcessExecuteFlags:
 
            if (ProcessInformationLength != sizeof(ULONG))
            {
                Status = STATUS_INFO_LENGTH_MISMATCH;
                break;
            }
 
            /* Set return length */
            Length = sizeof(ULONG);
 
            if (ProcessHandle != NtCurrentProcess())
            {
                return STATUS_INVALID_PARAMETER;
            }
 
            /* Get the options */
            Status = MmGetExecuteOptions(&ExecuteOptions);
            if (NT_SUCCESS(Status))
            {
                /* Protect write with SEH */
                _SEH2_TRY
                {
                    /* Return them */
                    *(PULONG)ProcessInformation = ExecuteOptions;
                }
                _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
                {
                    /* Get exception code */
                    Status = _SEH2_GetExceptionCode();
                }
                _SEH2_END;
            }
            break;
 
        case ProcessLdtInformation:
            DPRINT1("VDM/16-bit not implemented: %lx\n", ProcessInformationClass);
            Status = STATUS_NOT_IMPLEMENTED;
            break;
 
        case ProcessWorkingSetWatch:
            DPRINT1("WS Watch Not implemented: %lx\n", ProcessInformationClass);
            Status = STATUS_NOT_IMPLEMENTED;
            break;
 
        case ProcessPooledUsageAndLimits:
            DPRINT1("Pool limits Not implemented: %lx\n", ProcessInformationClass);
            Status = STATUS_NOT_IMPLEMENTED;
            break;
 
        /* Not supported by Server 2003 */
        default:
            DPRINT1("Unsupported info class: %lx\n", ProcessInformationClass);
            Status = STATUS_INVALID_INFO_CLASS;
    }
 
    /* Protect write with SEH */
    _SEH2_TRY
    {
        /* Check if caller wanted return length */
        if ((ReturnLength) && (Length)) *ReturnLength = Length;
    }
    _SEH2_EXCEPT(EXCEPTION_EXECUTE_HANDLER)
    {
        /* Get exception code */
        Status = _SEH2_GetExceptionCode();
    }
    _SEH2_END;
 
    return Status;
}
```