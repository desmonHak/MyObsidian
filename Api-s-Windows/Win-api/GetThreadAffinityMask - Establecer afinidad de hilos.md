```c
PartyError GetThreadAffinityMask(  
    PartyThreadId threadId,  
    uint64_t* threadAffinityMask  
)
```

[GetThreadAffinityMask](https://learn.microsoft.com/en-us/gaming/playfab/features/multiplayer/networking/reference/classes/partymanager/methods/partymanager_getthreadaffinitymask)

### Parameters
**`threadId`**   [PartyThreadId](https://learn.microsoft.com/en-us/gaming/playfab/features/multiplayer/networking/reference/enums/partythreadid)
The type of internal Party library thread for which processor affinity should be retrieved.
**`threadAffinityMask`**   uint64_t*  
_output_
The output affinity mask for this type of Party library thread.


### Return value
PartyError
`c_partyErrorSuccess` if the call succeeded or an error code otherwise. The human-readable form of the error code can be retrieved via [GetErrorMessage()](https://learn.microsoft.com/en-us/gaming/playfab/features/multiplayer/networking/reference/classes/partymanager/methods/partymanager_geterrormessage).


## Remarks
This retrieves the current processor affinity for internal Party library threads of a given type.  
This method does not require [Initialize()](https://learn.microsoft.com/en-us/gaming/playfab/features/multiplayer/networking/reference/classes/partymanager/methods/partymanager_initialize) to have been called first.  
A reported value of `c_anyProcessor` written to `threadAffinityMask` indicates that the thread is free to run on any processor.

## Requirements
**Header:** Party.h