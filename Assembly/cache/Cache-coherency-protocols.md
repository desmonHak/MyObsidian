https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29

Examples of coherency protocols for cache memory are listed here. For simplicity, all "**miss**" Read and Write status transactions which obviously come from state "**I**" (or miss of Tag), in the diagrams are not shown. They are shown directly on the new state. Many of the following protocols have only historical value. At the moment the main protocols used are the R-MESI type / MESIF protocols and the HRT-ST-MESI (MOESI type) or a subset or an extension of these.

## Cache coherency problem

[[edit](https://en.wikipedia.org/w/index.php?title=Cache_coherency_protocols_(examples)&action=edit&section=1 "Edit section: Cache coherency problem")]

In systems as [Multiprocessor system](https://en.wikipedia.org/wiki/Multiprocessor_system_architecture#Symmetric_multiprocessor_system "Multiprocessor system architecture"), [multi-core](https://en.wikipedia.org/wiki/Multi-core_processor "Multi-core processor") and [NUMA system](https://en.wikipedia.org/wiki/Non-uniform_memory_access "Non-uniform memory access"), where a dedicated cache for each _processor_, _core_ or _node_ is used, a consistency problem may occur when a same data is stored in more than one cache. This problem arises when a data is modified in one cache. This problem can be solved in two ways:

1. Invalidate all the copies on other caches (broadcast-invalidate)
2. Update all the copies on other caches (write-broadcasting), while the memory may be updated (write through) or not updated (write-back).

Note: Coherency generally applies only to data (as operands) and not to instructions (see [Self-Modifying Code](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_policy)).

The schemes can be classified based on:

- Snoopy scheme vs Directory scheme and vs Shared caches
- Write through vs Write-back (ownership-based) protocol
- Update vs Invalidation protocol
- Intervention vs not Intervention
- Dirty-sharing vs not-dirty-sharing protocol (MOESI vs MESI)

Three approaches are adopted to maintain the coherency of data.

- **Bus watching or Snooping** – generally used for bus-based [SMP – Symmetric Multiprocessor System](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#SMP_%E2%80%93_Symmetric_multiprocessor_system)/[multi-core](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Multi-core_Systems) systems
- **Directory-based – Message-passing** – may be used in all systems but typically in [NUMA system](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cc-NUMA_cache_coherency) and in large [multi-core](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Multi-core_Systems) systems
- **Shared cache** – generally used in [multi-core](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Multi-core_Systems) systems

## Snoopy coherency protocol
Protocol used in bus-based systems like a SMP systems

### SMP – symmetric multiprocessor systems

> Systems operating under a single OS ([Operating System](https://en.wikipedia.org/wiki/Operating_system "Operating system")) with two or more homogeneous processors and with a centralized shared [Main Memory](https://en.wikipedia.org/wiki/Main_memory "Main memory")

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/SMP_-_Symmetric_Multiprocessor_System.svg/400px-SMP_-_Symmetric_Multiprocessor_System.svg.png)](https://en.wikipedia.org/wiki/File:SMP_-_Symmetric_Multiprocessor_System.svg)

SMP – Symmetric Multiprocessor System

Each processor has its own cache that acts as a bridge between processor and [Main Memory](https://en.wikipedia.org/wiki/Main_memory "Main memory"). The connection is made using a [System Bus](https://en.wikipedia.org/wiki/System_bus "System bus") or a [Crossbar](https://en.wikipedia.org/wiki/Crossbar_switch "Crossbar switch") ("xbar") or a mix of two previously approach, bus for address and crossbar for Data (Data crossbar).[[1]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Data_Crossbar-1)[[2]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-2)[[3]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-3)

The bottleneck of these systems is the traffic and the Memory bandwidth. Bandwidth can be increasing by using large data bus path, data crossbar, [memory interleaving](https://en.wikipedia.org/wiki/Memory_interleaving "Memory interleaving") (multi-bank parallel access) and _[out of order](https://en.wikipedia.org/wiki/Out-of-order_execution "Out-of-order execution")_ data transaction. The traffic can be reduced by using a cache that acts as a _"filter"_ versus the shared memory, that is the cache is an essential element for shared-memory in SMP systems.

In multiprocessor systems with separate caches that share a common memory, a same datum can be stored in more than one cache. A data consistency problem may occur when data is modified in one cache only.  
The protocols to maintain the coherency for multiple processors are called **cache-coherency protocols**.

Usually in SMP the coherency is based on the _**"Bus watching"**_ or _**"[Snoopy](https://en.wikipedia.org/wiki/Bus_sniffing "Bus sniffing")"**_ (after the Peanuts' character _[Snoopy](https://en.wikipedia.org/wiki/Snoopy "Snoopy")_ ) approach.  
In a snooping system, all the caches monitor (or snoop) the bus transactions to intercept the data and determine if they have a copy on its cache.

Various [cache-coherency protocols](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Various_Coherency_Protocols) are used to maintain data coherency between caches.[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)

These protocols are generally classified based only on the cache states (from 3 to 5 and 7 or more) and the transactions between them, but this could create some confusion.

This definition is incomplete because it lacks important and essential information as the actions that these produce. These actions can be invoked by the processor or the bus controller (e.g. intervention, invalidation, broadcasting, etc.). The type of actions are implementation dependent. The states and transaction rules do not capture everything about a protocol. For instance protocol MESI with shared-intervention on unmodified data and MESI without intervention are different (see below). At the same time, some protocols with different states can be practically the same. For instance, the 4-state MESI [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) and 5-state MERSI (R-MESI) IBM / MESIF-Intel protocols are only different implementations of the same functionality (see below).

The most common protocols are the 4-state **MESI** and the 5-state **MOESI**, each letter standing for one of the possible states of the cache. Other protocols use some proper subset of these but with different implementations along with their different but equivalent terminology. The terms MESI, MOESI or any subset of them generally refer to a _class_ of protocols instead of a specific one.

### Cache states

The states MESI and MOESI are often and more commonly called by different names.

- **M**=_Modified_ or **D**=_Dirty_ or **DE**=_Dirty-Exclusive_ or **EM**=_Exclusive Modified_
    - modified in one cache only – write-back required at replacement.
    - data is stored only in one cache but the data in memory is not updated (invalid, not clean).
- **O**=_Owner_ or **SD**=_Shared Dirty_ or **SM**=_Shared Modified_ or **T**=_Tagged_
    - modified, potentially shared, owned, write-back required at replacement.
    - data may be stored in more than a cache but the data in memory is not updated (invalid, not clean). Only one cache is the "owner", other caches are set "Valid" (S/V/SC). On bus read request, the data is supplied by the "owner" instead of the memory.
- **E**=_Exclusive_ or **R**=_Reserved_ or **VE**=_Valid-Exclusive_ or **EC**=_Exclusive Clean_ or **Me**=_Exclusive_
    - clean, in one cache only.
    - Data is stored only in one cache and _clean_ in memory.
- **S**=_Shared_ or **V**=_Valid_ or **SC**=_Shared Clean_
    - shared or valid
    - Data potentially shared with other caches. The data can be clean or dirty. The term "clean" in SC is misleading because can be also dirty (see [Dragon protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Dragon_(Xerox)_protocol)).
- **I**=_Invalid_.
    - Cache line invalid. If the cache line is not present (no tag matching) it is considered equivalent to invalid, therefore invalid data means data present but invalid or not present in cache.

Special states:

- **F**=_Forward_ or **R**=_Recent_
    - Additional states of [MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MESI_Protocol) protocol
    - Last data read. It is a special "Valid" state that is the "Owner" for _non modified shared data_, used in some extended MESI protocols (MERSI or R-MESI IBM,[[5]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MERSI-5)[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6) MESIF – Intel[[7]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Intel_QuickPath-7)[[8]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESIF2-8)). The R/F state is used to allow "intervention" when the value is clean but shared among many caches. This cache is responsible for intervention (_**shared intervention**_ ). On bus read request, the data is supplied by this cache instead of the memory. MERSI and MESIF are the same protocol with different terminology (**F** instead of **R**). Some time **R** is referred as "_shared last_ " (**SL**).[[9]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-POWER4_protocol-9)[[10]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-10)
    - The state **R** = Recent is used not only in **MERSI** = **R-MESI** protocol but in several other protocols. This state can be used in combination with other states. For instance **[RT-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#RT-MESI_protocol)**, **HR-MESI**, **HRT-MESI**, **[HRT-ST-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol)**.[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6)[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12) All protocols that use this state will be refereed as **R-MESI type**.
- **H**=_Hover_ – **H-MESI** (additional state of MESI protocol)[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)
    - The Hover (**H**) state allows a cache line to maintain an address Tag in the directory even though the corresponding value in the cache entry is an invalid copy. If the correspondent value happens on the bus (address Tag matching) due a valid "Read" or "Write" operation, the entry is updated with a valid copy and its state is changed in **S**.
    - This state can be used in combination with other states. For instance **HR-MESI**, **HT-MESI**, **HRT-MESI**, **[HRT-ST-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol)**.[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6)[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12)

### Various coherency protocols

| **Protocols**                                                                                           |                                                                                                                                                                                                                                                                                                                                                                                      |
| ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| SI protocol                                                                                             | Write Through                                                                                                                                                                                                                                                                                                                                                                        |
| MSI protocol                                                                                            | [Synapse protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Synapse_protocol)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                               |
| MEI protocol                                                                                            | IBM [PowerPC 750](https://en.wikipedia.org/wiki/PowerPC_7xx "PowerPC 7xx"),[[13]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-PowerPC-13) MPC7400[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6)                                                                                               |
| MES protocol                                                                                            | [Firefly protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Firefly_(DEC)_protocol)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                         |
| [MESI protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MESI_protocol)   | Pentium II,[[14]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESI-14) PowerPC, Intel Harpertown (Xeon 5400)                                                                                                                                                                                                                                    |
| MOSI protocol                                                                                           | [Berkeley protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Berkeley_protocol)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                             |
| [MOESI protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MOESI_protocol) | [AMD64](https://en.wikipedia.org/wiki/AMD64 "AMD64"),[[15]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-AMD64-15) MOESI,[[16]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MOESI_Sweazey-16) T-MESI IBM[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12) |

| Terminology used                                                                                                                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Illinois protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol)                                       | D-VE-S-I (= extended MESI)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)[[17]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-17)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| [Write-once or Write-first](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-once_(or_write-first)_protocol)            | D-R-V-I (= MESI) [[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)[[18]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Goodman-18)[[19]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Write_Once-19)                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| [Berkeley protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Berkeley_protocol)                                       | D-SD-V-I (= MOSI)  [[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| [Synapse protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Synapse_protocol)                                         | D-V-I (= MSI)    [[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| [Firefly protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Firefly_(DEC)_protocol)                                   | D-VE-S (= MES) DEC[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| [Dragon protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Dragon_(Xerox)_protocol)                                   | D-SD (SM ?)-SC-VE (= MOES) Xerox[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| [Bull HN ISI protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI_protocol)                                 | D-SD-R-V-I (= MOESI)[[20]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Bull_HN_ISI-20)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| [MERSI (IBM) / MESIF (Intel) protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) | - R=Recent – IBM [PowerPC G4](https://en.wikipedia.org/wiki/PowerPC_G4 "PowerPC G4"), MPC7400[[5]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MERSI-5)[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6)<br>- F=Forward – Intel[[7]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Intel_QuickPath-7) Intel Nehalem[[21]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Shanghai_%E2%80%93_Nehalem-EP-21)[[22]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Nehalem2-22)[[23]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Nehalem-23) |
| [HRT-ST-MESI protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol)                                 | H=Hover, R=Recent,T=Tagged, ST=Shared-Tagged – IBM[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12)<br><br>– Note: The main terminologies are SD-D-R-V-I and MOESI and so they will be used both.                                                                                                                                                                                                                                                                                                                                                                                                                    |
| [POWER4 IBM protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#POWER4_IBM_protocol)                                   | Mu-T-Me-M-S-SL-I  ( L2 seven states)[[9]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-POWER4_protocol-9)<br><br>- **Mu**=_Unsolicited Modified – Modified Exclusive_ – (**D**/**M**) (*)<br>- **T**=_Tagged – Modified Owner not Exclusive_ (**SD**/**O**)<br>- **M**=_Modified Exclusive_ – (**D**)<br>- **Me**=_Valid Exclusive_ – (**R**/**E**)<br>- **S**=_Shared_ – (**V**)<br>- **SL**=_Shared Last – Sourced local_ – (**Shared Owner Local**)<br>- **I**=_Invalid_ – (**I**)<br><br>(*) Special state – Asking for a reservation for load and store doubleword (for 64-bit implementations).                                                                                                                                  |

### Snoopy coherency operations
- Bus Transactions
- Data Characteristics
- Cache Operations

#### Bus transactions
The main operations are:

- [_Write Through_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Through)
- [_Write-Back_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-Back_(or_Copy_Back))
- [_Write Allocate_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate)
- [_Write-no-Allocate_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate)
- _Cache Intervention_
    - _Shared Intervention_
    - _Dirty Intervention_
- _Invalidation_
- _Write-broadcast_
- _Intervention-broadcasting_

**Write Through**
- The cache line is updated both in cache and in MM or only in MM (_write no-allocate_).
- Simple to implement, high bandwidth consuming. It is better for single write.

**Write-Back**
- Data is written only in cache. Data is Write-Back to MM only when the data is replaced in cache or when required by other caches (see [Write policy](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_policy)).
- It is better for multi-write on the same cache line.
- Intermediate solution: _Write Through_ for the first write, _Write-Back_ for the next ([Write-once](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-once_(or_write-first)_protocol) and [Bull HN ISI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI_protocol)[[20]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Bull_HN_ISI-20) protocols).

**Write Allocate**
- On miss the data is read from the "owner" or from MM, then the data is written in cache (updating-partial write) (see [Write policy](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_policy)).

**Write-no-Allocate**
- On miss the data is written only in MM without to involve the cache, or as in [Bull HN ISI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI_protocol) protocol, in the "owner" that is in **D** or **SD** cache (owner updating), if they are, else in MM.
- Write-no-Allocate usually is associated with Write Through.
- **Cache Intervention**

(or shortly "_intervention_ ")
– **Shared Intervention** – shared-clean intervention (on unmodified data)
– On _Read Miss_ the data is supplied by the owner **E** or **R**/**F** or also **S** instead of the MM (see protocols [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) , IBM R-MESI type and Intel MESIF).
– **Dirty Intervention** (on modified data)
– On _Read Miss_ the data is supplied by the **M** (D) or **O** (SD) owner or by **E** (R) (*) instead of MM (e.g. MOESI protocol, RT-MESI, …).

(*) – Not for **E** (R) in the original proposal MOESI protocol[[16]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MOESI_Sweazey-16) and in some other implementations MOESI-Type.

– "_Intervention_ " is better compared to the "_not intervention_ " because _**cache-to-cache**_ transactions are much more faster than a MM access, and in addition it save memory bandwidth (memory traffic reduction). Extended MESI [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) and [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) are therefore much better than the MOESI protocol (see [MESI vs MOESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MESI_vs_MOESI) below)

- **Invalidation**

– On _Write Hit_ with **S** (V) or **O** (SD) (shared) state, a bus transaction is sent to invalidate all the copies on the other caches (_Write-invalidate_).

- **Write-broadcast** (Write-update)

– On _Write Hit_ with **S** (V) or **O** (SD) (shared) state, a write is forward to other caches to update their copies (e.g. Intel Nehalem[[22]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Nehalem2-22) [Dragon protocol](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Dragon_(Xerox)_protocol), [Firefly](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Firefly_(DEC)_protocol) (DEC).

– Note – The updating operation on the other caches some time is called also _**Snarfing**_. The caches snoop the bus and if there is a hit in a cache, this cache _snarfs_ the data that transits on the bus and update its cache. Also the updating of the **H** in ([H-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#H-MESI)) state can be defined as _snarfing_. In the first case this happens in a write broadcast operation, on the second case both in read and write operations.

- **Intervention-broadcasting**
– On an Intervention transaction, a cache with **H** state ([H-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#H-MESI)) updates its invalid copy with the value sent on the bus and its state is changed in **S**.[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6)
- **Write invalidate vs broadcast**

– Write Invalidate is better when multiple writes, typically partial write, are done by a processor before that the cache line is read by another processor.

– Write-broadcast (updating) is better when there is a single producer and many consumers of data, but it is worse when a cache is filled with data that will be not next read again (bus traffic increasing, [cache interference](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Snoopy_and_processor_activity_interference) increasing).

- Invalidation is the common solution.

#### Data characteristics
There are three characteristics of cached data:
- _Validity_
- _Exclusiveness_
- _Ownership_
- **Validity**

– Any not invalid cache line, that is MOES / D-SD-R-V.
- **Exclusiveness**

– Data valid only in one cache (data not shared) in **M** (D) or **E** (R) state, with MM not clean in case of **M** (D) and clean in case of **E** (R).
- **Ownership**

– The cache that is responsible to supply the request data instead of a MM (Intervention) – Depending on the protocol, cache who must make the intervention can be **S**-**E**-**M** in MESI [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol), or **R**/**F**-**E**-**M** in [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) or **M** (D) or **O** (SD) or also **E** (R) (*) in MOESI-type protocols, (e.g. [AMD64](https://en.wikipedia.org/wiki/AMD64 "AMD64"),[[16]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MOESI_Sweazey-16) [Bull HN ISI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI_protocol)[[20]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Bull_HN_ISI-20) – see "Read Miss" operation below).
(*) – Implementation depending.

Note: Not to confuse the more restrictive "owner" definition in MOESI protocol with this more general definition.

#### Cache operations
The cache operations are:
- _Read Hit_
- _Read Miss_
- _Write Hit_
- _Write Miss_
- **Read Hit**

– Data is read from cache. The state is unchanged

– **Warning**: since this is an obvious operation, afterwards it will not be more considered, also in state transaction diagrams.

- **Read Miss**

– The data read request is sent to the bus

– There are several situations:

- **Data stored only in MM**

– The data is read from MM.

– The cache is set **E** (R) or **S** (V)

– **E** (R) if a special bus line ("_Shared line_ ") is used to detect "_no data sharing_ ". Used in all protocols having **E** (R) state except for [Write-Once](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-once_(or_write-first)_protocol) and [Bull HN ISI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI) protocols (see "Write Hit" below).

- **Data stored in MM and in one or more caches in S** (V) **state or in R/F in [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) protocols**.

– There are three situations:

1. – [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) protocol – a network priority is used to temporary and arbitrary assign the ownership to a **S** copy.  
    - Data is supplied by the selected cache. Requesting cache is set **S** (**shared intervention** with MM clean).
2. – [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) protocols – a copy is in **R**/**F** state (**shared owner**)  
    – The data is supplied by the **R**/**F** cache. Sending cache is changed in **S** and the requesting cache is set **R**/**F** (in read miss the "ownership" is always taken by the last requesting cache) – **shared intervention**.
3. – In all the other cases the data is supplied by the memory and the requesting cache is set **S** (V).

- **Data stored in MM and only in one cache in E** (R) **state**.
1. – Data is supplied by a **E** (R) cache or by the MM, depending on the protocol.  
    – From **E** (R) in extended MESI (e.g. [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol), Pentium (R) II [[14]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESI-14)), [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) and from same MOESI implementation (e.g. [AMD64](https://en.wikipedia.org/wiki/AMD64 "AMD64"))  
    – The requesting cache is set **S** (V), or **R**/**F** in [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) protocols and **E** (R) cache is changed in **S** (V) or in **I** in MEI protocol.
2. – In all the other cases the data is supplied by the MM.

- **Data modified in one or more caches with MM not clean**

- **Protocol MOESI type – Data stored in M** (D) **or in O** (SD) **and the other caches in S** (V)

– Data is sent to the requesting cache from the "owner" **M** (D) or **O** (SD). The requesting cache is set **S** (V) while **M** (D) is changed in **O** (SD).

– The MM is not updated.

- **Protocols MESI type and MEI – Data stored in M** (D) **and the other caches in S** (V) state

– There are two solutions:

1. – Data is sent from the **M** (D) cache to the requesting cache and also to MM (e.g. [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol), Pentium (R) II [[14]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESI-14))
2. – The operation is made in two steps: the requesting transaction is stopped, the data is sent from the **M** (D) cache to MM then the wait transaction can proceed and the data is read from MM (e.g. MESI and MSI [Synapse](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Synapse) protocol).

– All cache are set **S** (V)

- **Write Hit**

– The data is written in cache

– There are several situations:

- **Cache in S** (V) **or R/F or O** (SD) (sharing)

– **Write invalidate**

– Copy back

– The data is written in cache and an invalidating transaction is sent to the bus to invalidate all the other caches

– The cache is set **M** (D)

– Write Through ([Write-Once](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-once_(or_write-first)_protocol), [Bull HN ISI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI))

– Data is written in cache and in MM invalidating all the other caches. The cache is set **R** (E)

– **Write broadcasting** (e.g. [Firefly](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Firefly_(DEC)_protocol), [Dragon](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Dragon_(Xerox)_protocol))

- The data is written in cache and a broadcasting transaction is sent to the bus to update all the other caches having a copy

– The cache is set **M** (D) if the "shared line" is off, otherwise is set **O** (SD). All the other copies are set **S** (V)

- **Cache in E** (R) **or M** (D) **state** (exclusiveness)

– The write can take place locally without any other action. The state is set (or remains) **M** (D)

- **Write Miss**

– **Write Allocate**

– Read with Intent to Modified operation ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

– Like a Read miss operation plus an invalidate command, then the cache is written (updated)

– The requesting cache is set **M** (D), all the other caches are invalidated

– Write broadcasting (e.g. [Firefly](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Firefly_(DEC)_protocol), [Dragon](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Dragon_(Xerox)_protocol))

– Like with a Read Miss. If "shared line" is "off" the data is written in cache and set **M** (D), otherwise like with a Write Hit – Write Broadcasting

– **Write-no-Allocate**

– The data is sent to MM, or like in [Bull HN ISI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bull_HN_ISI_protocol) protocol, only to the **D** (M) or **SD** (O) cache if they are, bypassing the cache.

## Coherency protocols

– **warning** – For simplicity all Read and Write "miss" state transactions that obviously came from **I** state (or Tag miss), in the diagrams are not depicted. They are depicted directly on the new state.

– Note – Many of the following protocols have only historical value. At the present the main protocols used are [R-MESI type / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) and [HRT-ST-MES](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol) (MOESI type) or a subset of this.

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/MESI_State_Transaction_Diagram.svg/350px-MESI_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:MESI_State_Transaction_Diagram.svg)

MESI Protocol – State Transaction Diagram

### MESI protocol

  States MESI = D-R-V-I

– Use of a bus "shared line" to detect "shared" copy in the other caches

- **Processor operations**

- Read Miss

There are two alternative implementations: standard MESI (not intervention) and extended MESI (with intervention)

1 – MESI "no Intervention" (e.g. PowerPC 604 [[24]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESI-OP-24))

– If there is a **M** copy in a cache, the transaction is stopped and wait until the **M** cache updates the MM, then the transaction can continue and the data is read from MM. Both caches are set **S**

– else the data is read from MM. If the "shared line" is "on" the cache is set **S** else **E**

2 – MESI "Intervention" from **M** and **E** (e.g. Pentium (R) II [[14]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESI-14))

– If there is a **M** or **E** copy (exclusiveness) in a cache, the data is supplied to the requesting cache from **M** or from **E** (Intervention). If the sending cache is **M** the data is also written at the same time in MM (copy back). All caches are set **S**

– else the data is read from MM. If the "shared line" is "on" the cache is set **S** else **E**

- Write Hit

– If the cache is **M** or **E** (exclusiveness), the write can take place locally without any other action

– else the data is written in cache and an invalidating transaction is sent to the bus to invalidate all the other caches

– The cache is set **M**

- Write Miss

– [RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate) operation is sent to the bus. The operation is made in two step: a "Read Miss" with "invalidate" command to invalidate all the other caches, then like with a "Write Hit" with the state **M** (see [Cache operation-Write Miss](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Cache_Operations)).

- **Bus transactions**

- Bus Read

– if **M** and "no Intervention" the data is sent to MM (Copy Back)

– if **M** and "Intervention" the data is sent to requesting cache and to MM (Copy Back)

– if **E** (*) and "Intervention" the data sent to requesting cache

– The state is changed (or remains) in **S**

- Bus Read – ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

– As like with "Bus read"

– The cache is set "Invalid" (**I**)

- Bus Invalidate Transaction

The cache is set "Invalid" (**I**)

- **Operations**

– _Write Allocate_

– _Intervention_: from M – E (*)

– _Write Invalidate_

– _Copy-Back_: M replacement

(*) – extended MESI

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/MOESI_State_Transaction_Diagram.svg/350px-MOESI_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:MOESI_State_Transaction_Diagram.svg)

MOESI Protocol – State Transaction Diagram

### MOESI protocol

  States MEOSI = D-R-SD-V-I = T-MESI IBM[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12)

– Use of bus "shared line" to detect "shared" copy on the other caches

- **Processor operations**

- Read Miss

– If there is a **M** or **O** or **E** (*) copy in another cache the data is supplied by this cache (intervention). The requesting cache is set **S** , **M** is changed to **O** and **E** to **S**

– else the data is read from MM.

– If "shared line" is "on" the requesting cache is set **S** else **E**

- Write Hit

– If the cache is **M** or **E** (exclusiveness), the write can take place locally without any other action

– else **O** or **S** (sharing) an "Invalidation" transaction is sent on the bus to invalidate all the other caches.

– The cache is set (or remains) **M**

- Write Miss

– A [RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate) operation is sent to the bus

– Data is supplied from the "owner" or from MM as with Read Miss, then cache is written (updated)

– The cache is set **M** and all the other caches are set **I**

- **Bus transactions**

- Bus Read

– If the cache is **M** or **O** or **E** (*) the data is sent to requesting cache (intervention). If the cache is **E** the state is changed in **S**, else is set (or remains) **O**

– else the state is changed or remains in **S**

- Bus Read – ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

– If the cache is **M** or **O** or **E** (*) the data is sent to the bus (Intervention)

– The cache is set "Invalid" (**I**)

- Bus Invalidate Transaction

– The cache is set "Invalid" (**I**)

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Illinois_State_Transaction_Diagram.svg/350px-Illinois_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Illinois_State_Transaction_Diagram.svg)

Illinois State Transaction Diagram

- **Operations**
- _Write Allocate_
- _Intervention_: from M-O-E (*)
- _Write Invalidate_
- _Copy-Back_: M-O replacement

– (*) implementation depending for **E**

————————————————————————————————————————

### Illinois protocol

  States MESI = D-R-V-I[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)

– Characteristics:

– It is an extension of MESI protocol

– Use of a network priority for **shared intervention** (intervention on shared data)

– Differences from MESI: in addition to **E** and **M**, intervention also from **S** (see [Read Miss – point 1](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Cache_Operations))

- **Operations**

- _Write Allocate_

- _Intervention_: from M-E-S

- _Write Invalidate_

- _Copy-Back_: M replacement

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Write-Once_State_Transaction_Diagram.svg/350px-Write-Once_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Write-Once_State_Transaction_Diagram.svg)

Write-Once Protocol – State Transaction Diagram

### Write-once (or write-first) protocol

  States D-R-V-I (MESI) [[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)[[18]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Goodman-18)[[19]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Write_Once-19)

– Characteristics:

– No use of "shared line" (protocol for standard or unmodifiable bus)

– Write Through on first Write Hit in state **V**, then Copy Back

- **Processor operations**

- Read Miss

– If there is a **D** copy in another cache, the data is supplied by this cache (intervention) and in the same time it is written also in MM (Copy-Back).

– else the data is read from MM

– all caches are set **V**

- Write Hit

– If the cache is **D** or **R** (exclusiveness), the write can take place locally without any other action and the state is set (or remains) **D**

– else **V** (first Write Hit) the data is written in cache and in MM (Write Through) invalidating all the other caches (Write-Invalidate). – The cache is set **R**

- Write Miss

– Like a Read Miss but with "invalidate" command ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate)) plus a Write Hit in **D** state (updating). The cache is set **D** and all the other caches are set "Invalid" (**I**)

– Note – Write Through is performed only in "Write Miss". It is point out that in this case a bus transaction in any case is needed to invalidate the other caches and therefore it can be taken advantage of this fact to update also the MM. In "Write Hit" instead no more transaction is needed so a "Write Through" it would become a useless operation in case that the cache were updated again.

- **Bus transactions**

- Bus Read

– If the cache is **D** the data is sent to requesting cache (intervention) and to MM (copy-back). The cache is set **V**

– else the state is changed or remains in **V**

- Bus Read – ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

– If the cache is **D** the data is sent to the bus (Intervention)

– The cache is set "Invalid" (**I**)

- Bus Invalidate Transaction

– The cache is set "Invalid" (**I**)

- **Operations**
- _Write Allocate_
- _Intervention_: from D
- _Write Through_: first write hit in **V** state
- _Write Invalidate_
- _Copy-Back_: D replacement

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Bull_HN_ISI_State_Transaction_Diagram.svg/350px-Bull_HN_ISI_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Bull_HN_ISI_State_Transaction_Diagram.svg)

Bull HN ISI Protocol – State Transaction Diagram

### Bull HN ISI protocol

(Bull-Honeywell Italia)

  States D-SD-R-V-I (MOESI)  
  Patented protocol (F. Zulian)[[20]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Bull_HN_ISI-20)

– Characteristics:

– MOESI extension of the [Write-Once](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-once_(or_write-first)_protocol) protocol

- Write-no-allocate on miss with **D** or **SD** updating

- No use of [RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate)

- No use of "shared line"

- **Processor operations**

- Read Miss

- Like with MOESI with "Shared Line" "on" and intervention only from the "owner" **D** or **SD** but not from **R**

- Write Hit

- If the cache is **D** or **R**, like with MOESI, the write can take place locally without any other action. The cache is set (or remains) **D**

- If **SD** or **V** (first write), like with [Write-Once](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write-once_(or_write-first)_protocol), the data is written in cache and in MM (Write Through) invalidating all the other caches (Write-Invalidate) – The cache is set **R**

- Write Miss

- The data is sent to the bus bypassing the cache (Write-no-allocate)

- If there is an "owner" copy **D** or **SD**, the "owner" is updated (see [Write-no-Allocate – owner updating](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Bus_Transactions)) while the other caches are invalidated. The "owner" is set (or remains) **D**. The memory remains "dirty"

- else the data is sent to MM invalidating all the other caches (Write-Invalidate)

- **Bus transactions**

- Bus Read

- Like with MOESI with intervention only from "owner" **D** or **SD**

- Bus Read (Write Update / Write Invalidate)

- If the cache is **D** or **SD**, the cache is updated, else is set "Invalid" (**I**)

- **Operations**
- _Write-no-allocate_: on miss
- _Write update_: on miss
- _Write Through_: for the first write, then copy back
- _Write Update / Write Invalidate_
- _Intervention_: from SD-D
- _Copy-Back_: D replacement or SD replacement with invalidate

Obs. - This is the only protocol that has O-E (SD-R) transactions and it is also the only one that makes use of the Write-no-allocated on miss.

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Synapse_Protocol_-_State_Transaction_Diagram.svg/350px-Synapse_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Synapse_Protocol_-_State_Transaction_Diagram.svg)

Synapse Protocol – State Transaction Diagram

### Synapse protocol

  States D-V-I (MSI)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)

- Characteristics:

- The characteristic of this protocol is ti have a single-bit tag with each cache line in MM, indicating that a cache have the line in **D** state.

- This bit prevents a possible race condition if the **D** cache does not respond quickly enough to inhibit the MM from responding before being updating.

- The data comes always from MM

- No use of "shared line"

- **Processor operations**

- Read Miss

- If there is a **D** copy in another cache, the read transaction is rejected (no acknowledgement). The **D** copy is written back to MM and changes its state in **V**, then the requesting cache resends a new read transaction and the data is read from MM.

- else the data is read from MM.

- The cache is set **V**

- Write Hit

- If the cache is **D** , the write can take place locally without any other action.

- else **V**, like with Read Miss does, including a data transfer from memory with in addition an invalidate command ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate)). This is done only to invalidate the other **V** copies because this protocol does not support an invalidation transaction.

- The cache is set **D**. All the other caches copy are set "Invalid" (**I**)

- Write Miss ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

- Like with Read Miss, but with invalidate command. The cache line comes from MM, then the cache is written (updated). The cache is set **D**. All the other caches are set "Invalid" (**I**).

- **Bus transactions**

- Bus Read

- If the cache is **D**, the data is sent to MM (Copy Back). The cache is set **V**

- else the state remains in **V**

- Bus Read ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

- If the cache is **D** the data is sent to MM (Copy Back)

- The cache (**D** or **V**) is set "Invalid" (**I**)

- **Operations**
- _Write Allocate_
- _Intervention_: no intervention
- _Write Invalidate_: ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))
- _No Invalidate transaction_
- _Copy-Back_: D replacement

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Berkeley_Protocol_-_State_Transaction_Diagram.svg/350px-Berkeley_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Berkeley_Protocol_-_State_Transaction_Diagram.svg)

Berkeley Protocol – State Transaction Diagram

### Berkeley protocol

  States D-SD-V-I (MOSI)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)

- Characteristics:

- As with MOESI without **E** state

- No use of "shared line"

- **Processor operations**

- Read Miss

- The data is supplied by the "owner", that is from **D** or from **SD** else from MM. **D** is changed in **SD**

- The cache is set **V**

- Write Hit

- If the cache is **D** (exclusiveness), the write can take place locally without any other action

- else (**SD** or **V**), an "Invalidation" transaction is sent on the bus to invalidate the other caches.

- The cache is set (or remains) **D**

- Write Miss

- [RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate) operation is sent to the bus

- Like with Read Miss, the data comes from the "owner", **D** or **SD** or from MM, then the cache is updated

- The cache is set **D**. all the other caches are set **I**

- **Bus transactions**

- Bus Read

- If the cache is **D** or **SD** the data is sent to requesting cache (intervention). The cache is set (or remains) in **SD**

- else the cache remains in **V**

- Bus Read – ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

- If the cache is **D** or **SD** the data is sent to the bus (Intervention)

- The cache is set "Invalid" (**I**)

- Bus Invalidate Transaction

- The cache is set "Invalid" (**I**)

- **Operations**
- _Write Allocate_
- _Intervention_: from D-SD
- _Write Invalidate_
- _Copy-Back_: D-SD replacement

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Firefly_Protocol_-_State_Transaction_Diagram.svg/350px-Firefly_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Firefly_Protocol_-_State_Transaction_Diagram.svg)

Firefly Protocol – State Transaction Diagram

### Firefly (DEC) protocol

  States D-VE-S (MES)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)

- Characteristics:

- No "Invalid" state

- "Write-broadcasting"+"Write Through"

- Use of "shared line"

- "Write-broadcasting" avoid the necessity of "Invalid" state

- Simultaneous intervention from all caches (shared and dirty intervention – on not modified that modified data)

- This protocol requires a synchronous bus

- **Processor operations**

- Read Miss

- Any other cache is the "owner", that is all the other caches with a copy supplied simultaneously the date on the bus (simultaneous intervention – the bus timing is fixed so that they all respond in the same cycle), otherwise the data is supplied from MM.

- If there is a cache **D**, the data is sent simultaneously also to MM (Copy Back)

- If there are copies in the other caches, the "Shared line" is set "on"

- If "Shared line" is "on" all the caches are set **S** else the requesting cache is set **VE**.

- Write Hit

- If the cache is **D** or **VE** (exclusiveness), the write can take place locally without any other action and the cache is set **D**

- else **S**, a "Write-broadcasting" is sent to the bus to update all the other caches and the MM (Write Through)

- If there is a copy in another cache, the "Shared line" is set "on". If "Shared line" is set "off" the cache is set **VE** else all caches are set **S**

- Write Miss

- The operation is made in two steps. Read Miss then Write Hit.

- If the data comes from a cache (Shared Line "on") a "Write-broadcasting" is sent to the bus to update all the other caches and the MM (Write Through). All the caches are set **S**

- else the cache is set **D**

- **Bus transactions**

- Bus Read

- If hit (**D** or **VE** or **S**) the data is sent to the bus (intervention) and in case of **D** the data is written also in MM. The cache is set **S**

- Bus Read

- If hit (**D** or **VE** or **S**) the data is sent to the bus (Intervention).

- All the caches are set **S**

- Write Broadcasting

- The cache is updated with new data. The state remains **S**

- **Operations**
- _Write Allocate_
- _Intervention_: from D-VE-S (from all "valid" caches)
- _Write-broadcasting – Write through_
- _Copy-Back_: D replacement and on any transaction with a cache D

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Dragon_Protocol_-_State_Transaction_Diagram.svg/350px-Dragon_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:Dragon_Protocol_-_State_Transaction_Diagram.svg)

Dragon Protocol – State Transaction Diagram

### Dragon (Xerox) protocol

  States D-SD-VE-SC (MOES)[[4]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Various_protocols-4)

Note – the state **SC**, despite the term "clean", can be "clean" or "dirty" as the **S** state of the other protocols. **SC** and **S** are equivalents

- Characteristics:

- No "Invalid" state

- "Write-broadcasting" (no "Write Through")

- Use of "shared line"

- "Write-broadcasting" avoid the necessity of "Invalid" state

- **Processor operations**

- Read Miss

- The data is supplied by the "owner", that is from **D** or from **SD** else from MM. **D** is changed in **SD**

- If "shared line" is "on" the cache is set **SC** else **VE**

- Write Hit

- If the cache is **D** or **VE** (exclusiveness), the write can take place locally without any other action. The cache is set (or remains) **D**

- else **SD** or **SC** (sharing) the data is written in cache and a "Write-broadcasting" is sent to the bus to update all the other caches – The MM is not updated (no Write through)

- If there is a copy in another cache, the "Shared line" is set "on"

- If the "Shared Line" is "on" the cache is set **SD**, else **D**. All the other caches possible copy are set **SC**

- Write Miss

- Like with Read Miss, the data comes from the "owner", **D** or **SD** or from MM, then the cache is updated

- If there is a copy in another cache, the "Shared line" is set "on".

- If the "Shared Line" is "on" the updated data is broadcast to the other caches and the state is set **SD**. All the other caches are set **SC**

- else the cache is **D**

- **Bus transactions**

- Bus Read

- If the cache is **D** or **SD** the data is sent to requesting cache (intervention). The cache is set (or remains) **SD**

- else the cache remains **SC**

- Bus Read

- If the cache is **D** or **SD** the data is sent to the bus (Intervention)

- The cache is set **SC**

- Write Broadcasting

- The cache is updated with new data. The cache remains **SC**

- **Operations**
- _Write Allocate_
- _Intervention_: from D-SD (but not from VE)
- _Write-broadcasting_
- _Copy-Back_: D-SD replacement

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/MERSI-MESIF_Protocol_-_State_Transaction_Diagram.svg/350px-MERSI-MESIF_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:MERSI-MESIF_Protocol_-_State_Transaction_Diagram.svg)

MERSI – MESIF Protocol – State Transaction Diagram

### MERSI (IBM) / MESIF (Intel) protocol

  States MERSI or R-MESI  
  States MESIF  
  Patented protocols – IBM (1997)[[6]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-R-MESI-6) – Intel (2002)[[8]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-MESIF2-8)

- MERSI and MESIF are the same identical protocol (only the name state is different ,**F** instead of **R**)

- Characteristics:

- The same functionality of [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) protocol

- A new state **R** (Recent) / **F** (Forward) is the "_owner_ " for "shared-clean" data (with MM updated).

- The "shared ownership" (on clean data) is not assigned by a network priority like with [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol), but it is always assigned to the last cache with Read Miss, setting its state **R**/**F**

- The "ownership" is temporary loosed in case of **R**/**F** replacement. The "ownership" is reassigned again to the next Read Miss with caches "shared clean"

- Use of the "shared line"

- **Operations**
- _Write Allocate_
- _Intervention_: from M-E-R/F
- _Write Invalidate_
- _Copy-Back_: M replacement

————————————————————————————————————————

### MESI vs MOESI

[MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MESI_protocol) and [MOESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MOESI_protocol) are the most popular protocols

It is common opinion that MOESI is an extension of MESI protocol and therefore it is more sophisticate and more performant. This is true only if compared with standard MESI, that is MESI with "not sharing intervention". MESI with "sharing intervention", as _**MESI [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) like or the equivalent 5-state protocols [MERSI / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) , are much more performant than the MOESI protocol**_.

In MOESI, cache-to-cache operations is made only on modified data. Instead in MESI [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) type and [MERSI / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) protocols, the cache-to-cache operations are always performed both with clean that with modified data. In case of modified data, the intervention is made by the "owner" M, but the ownership is not loosed because it is migrated in another cache (R/F cache in [MERSI / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) or a selected cache as [Illinois](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Illinois_protocol) type). The only difference is that the MM must be updated. But also in MOESI this transaction should be done later in case of replacement, if no other modification occurs meanwhile. However this it is a smaller limit compared to the memory transactions due to the not-intervention, as in case of clean data for MOESI protocol. (see e.g. "Performance evaluation between MOESI (Shanghai) and MESIF Nehalem-EP"[[21]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-Shanghai_%E2%80%93_Nehalem-EP-21))

The most advance systems use only [R-MESI / MESIF](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) protocol or the more complete [RT-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#RT-MESI_protocol), [HRT-ST-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol) and [POWER4 IBM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#POWER4_IBM_protocol) protocols that are an enhanced merging of MESI and MOESI protocols

Note: Cache-to-cache is an efficient approach in multiprocessor/multicore systems direct connected between them, but less in [Remote cache](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Remote_Cache) as in [NUMA systems](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cc-NUMA_cache_coherency) where a standard [MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MESI) is preferable. Example in [POWER4 IBM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#POWER4_IBM_protocol) protocol "shared intervention" is made only "local" and not between remote module.

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/RT-MESI_Protocol_-_State_Transaction_Diagram.svg/350px-RT-MESI_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:RT-MESI_Protocol_-_State_Transaction_Diagram.svg)

RT-MESI Protocol – State Transaction Diagram

### RT-MESI protocol
  States RT-MESI  
  IBM patented protocol[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12)

- Characteristics:

- MESI and MOESI merging

- Shared Intervention + Dirty Intervention (both on clean and dirty data)

- Same functionality of [R-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#MERSI_(IBM)_/_MESIF_(Intel)_protocol) protocol with a new state **T**=Tagged, equivalent to **O** state

- "Dirty-Owner" migration

- The "owner" (both Shared or Dirty) is always the last requesting cache (the new "owner" ([LRU](https://en.wikipedia.org/wiki/Least_Recently_Used "Least Recently Used")) has less probability to be deallocated soon compared to the old one)

- The "owners" are **T**, **M**, **E**, **R** (all except **S**)

- Use of the "shared line"

**Processor operations**

- Read Miss

- If there is a **M** or **T** (dirty-ownership) copy in another cache, the data is supplied by this cache (dirty intervention). The requesting cache is set **T** and the previous **M** or **T** are changed in **S**

- If there is a **E** or **R** (shared-ownership) copy in another cache, the data is supplied by this cache (shared intervention). The requesting data is set **R** and **E** or **R** are changed in **S**

- else the data is read from MM and the cache is set **R**.

- Write Hit

- If the cache is **M** or **E** (exclusiveness), the write can take place locally without any other action

- else **T** or **R** or **S** (sharing) an "Invalidation" transaction is sent on the bus to invalidate all the other caches.

- The cache is set (or remains) **M** and all the other caches are set **I**

- Write Miss

- [RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate) operation is sent to the bus

- Data is supplied from the "owner" or from the MM as with Read Miss, then the data is written (updated) in cache.

- The cache is set **M** and all the other caches are set **I**

- **Bus transactions**

- Bus Read

- If the cache is **T** or **M** or **R** or **E** the data is sent to requesting cache (intervention).

- The cache is set (or remains) in **S**

- Bus Read – ([RWITM](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Write_Allocate))

- If the cache is **T** or **M** or **R** or **E** the data is sent to requesting cache (intervention)

- The cache is set "Invalid" (**I**)

- Bus Invalidate Transaction

- The cache is set "Invalid" (**I**)

- **Operations**
- _Write Allocate_
- _Intervention_: from T-M-R-E
- _Write Invalidate_
- _Copy-Back_: T-M replacement

————————————————————————————————————————

### RT-ST-MESI protocol
It is an improvement of [RT-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#RT-MESI_protocol) protocol[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12) and it is a subset of [HRT-ST-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol) protocol[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)

**ST** = Shared-Tagged

- Use of the "Shared-Tagged" state allows to maintain intervention after deallocation of a Tagged cache line

- In case of **T** replacement (cache line deallocation), the data needs to be written back to MM and so to lose the "ownership". To avoid this, a new state **ST** can be used. In Read Miss the previous **T** is set **ST** instead of **S**. **ST** is the candidate to replace the ownership in case of **T** deallocation. The **T** "Copy back" transaction is stopped (no MM updating) by the **ST** cache that changes its state in **T**. In case of a new read from another cache, this last is set **T**, the previous **T** is changed in **ST** and the previous **ST** is changed in **S**.

An additional improvement can be obtained using more than a **ST** state, **ST1**, **ST2**, … **STn**.

- In Read Miss, **T** is changed in **ST1** and all the indices of the others **STi** are increased by "1.

- In case of **T** deallocation, **ST1** stops the "Copy Back" transaction, changes its state in **T** and all the indices of the others **STi** are decrease by "1".

- In case of a deallocation, for instance **STk**, the chain will be interrupted and all the **STi** with index greater of "k" are automatically loosen in term of **ST** and will be considered _de facto_ only as simple **S** states also if they are set as **ST**. All this because only **ST1** intervenes to block and to replace itself with **T**. For instance if we have a situation type **T**, **ST1**, **ST3**, **ST4** with **ST2** replaced, if **T** will be replaced the new situation will be **T**, **ST2**, **ST3** without any **ST1**.

————————————————————————————————————————

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/HRT-ST-MESI_Protocol_-_State_Transaction_Diagram.svg/350px-HRT-ST-MESI_Protocol_-_State_Transaction_Diagram.svg.png)](https://en.wikipedia.org/wiki/File:HRT-ST-MESI_Protocol_-_State_Transaction_Diagram.svg)

HRT-ST-MESI Protocol – State Transaction Diagram

### HRT-ST-MESI protocol

IBM patented full HRT-ST-MESI protocol[[11]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-HRT-MESI-11)[[12]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-RT-MESI-12)

- **I** state = Invalid Tag (*) – Invalid Data  
- **H** state = Valid Tag – Invalid Data

- **I** state is set at the cache initialization and its state changes only after a processor Read or Write miss. After it will not return more in this state.

- **H** has the same functionality of **I** state but in addition with the ability to capture any bus transaction that match the Tag of the directory and to update the data cache.

- After the first utilization **I** is replaced by **H** in its functions

- The main features are :

- Write Back

- Intervention both in sharing-clean and dirty data – from T-M-R-E

- Reserve states of the Tagged (Shared-Tagged)

- Invalid **H** state (Hover) auto-updating

(*) – Note: The Tag for definition is always valid, but until the first updating of the cache line it is considered invalid in order to avoid to update the cache also when this line has been not still required and used.

————————————————————————————————————————

### POWER4 IBM protocol

  States M-T-Me-S-I -Mu-SL = RT-MESI+Mu[[9]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-POWER4_protocol-9)

- Use of the "shared line"

- Used in [multi-core/module systems](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Multi-core_Systems) – multi L2 cache [[9]](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_note-POWER4_protocol-9)
- This protocol is equivalent to the [RT-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#RT-MESI_protocol) protocol for system with multi L2 cache on [multi-module systems](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#Multi-core_Systems)

- **SL** - "Shared Last" equivalent to **R** on **[RT-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#RT-MESI_protocol)**
- **Me** - "Valid Exclusive" = **E**
- **Mu** – unsolicited modified state

- special state – asking for a reservation for load and store doubleword (for 64-bit implementations)

- "Shared intervention" from **SL** is done only between L2 caches of the same module
- "Dirty intervention" from **T** is done only between L2 caches of the same module
- **Operations**

- _Write Allocate_

- _Intervention_: from M-T-VE-SL = M-O-E-SL

- _Write Invalidate_

- _Copy-Back_: M-T replacement

- Note : T and SL – Intervention only on the locale module

————————————————————————————————————————

## General considerations on the protocols
Under some conditions the most efficient and complete protocol turns out to be the [HRT-ST-MESI](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#HRT-ST-MESI_protocol) protocol.

- Write Back

- Intervention both with dirty than shared-clean data

- Reserve states of the Tagged state (Shared-Tagged)

- Invalid **H** (Hover) state auto-updating

## References
1. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Data_Crossbar_1-0 "Jump up")** [US patent 5701413](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=US5701413), "Multi-processor system with shared memory"
2. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-2 "Jump up")** [EP patent 0923032A1](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=EP0923032A1), "Method for transferring data in a multiprocessor computer system with crossbar interconnecting unit"
3. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-3 "Jump up")** ["Specification and Verification of the PowerScale Bus Arbitration Protocol: An Industrial Experiment with LOTOS, Chap. 2, Pag. 4"](ftp://ftp.inrialpes.fr/pub/vasy/publications/cadp/Chehaibar-Garavel-et-al-96.pdf) (PDF).
4. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-3) [_**e**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-4) [_**f**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-5) [_**g**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-6) [_**h**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-7) [_**i**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-8) [_**j**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-9) [_**k**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-10) [_**l**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-11) [_**m**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-12) [_**n**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-13) [_**o**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-14) [_**p**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Various_protocols_4-15) , Archibald, James; Baer, Jean-Loup (1986). ["Cache coherence protocols: evaluation using a multiprocessor simulation model"](http://ctho.org/toread/forclass/18-742/3/p273-archibald.pdf) (PDF). _ACM Transactions on Computer Systems_. **4** (4). Association for Computing Machinery (ACM): 273–298. [doi](https://en.wikipedia.org/wiki/Doi_(identifier) "Doi (identifier)"):[10.1145/6513.6514](https://doi.org/10.1145%2F6513.6514). [ISSN](https://en.wikipedia.org/wiki/ISSN_(identifier) "ISSN (identifier)") [0734-2071](https://search.worldcat.org/issn/0734-2071). [S2CID](https://en.wikipedia.org/wiki/S2CID_(identifier) "S2CID (identifier)") [713808](https://api.semanticscholar.org/CorpusID:713808).
5. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MERSI_5-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MERSI_5-1) [""MPC7400 RISC Microprocessor User's Manual""](http://pccomponents.com/datasheets/MOT-MPC7400.PDF) (PDF).
6. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-3) [_**e**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-4) [_**f**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-5) [_**g**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-R-MESI_6-6) [US Patent 5996049](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=US5996049), "Cache-coherency protocol with recently read state for data and instructions"
7. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Intel_QuickPath_7-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Intel_QuickPath_7-1) [""An Introduction to the Intel® QuickPath Interconnect""](http://www.intel.ie/content/dam/doc/white-paper/quick-path-interconnect-introduction-paper.pdf) (PDF).
8. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESIF2_8-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESIF2_8-1) [US Patent 6922756](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=US6922756), "Forward state for use in cache coherency in a multiprocessor system"
9. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-POWER4_protocol_9-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-POWER4_protocol_9-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-POWER4_protocol_9-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-POWER4_protocol_9-3) ["POWER4 System Microarchitecture"](https://web.archive.org/web/20131107140531/http://www.cc.gatech.edu/~bader/COURSES/UNM/ece637-Fall2003/papers/TDF02.pdf) (PDF). _cc.gatech.edu_. 2008-10-08. Archived from [the original](http://www.cc.gatech.edu/~bader/COURSES/UNM/ece637-Fall2003/papers/TDF02.pdf) (PDF) on 2013-11-07.
10. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-10 "Jump up")** ["IBM PowerPC 476FP L2 Cache Core Databook"](https://www-01.ibm.com/chips/techlib/techlib.nsf/techdocs/8D5342097498C81A852575C50078D867/$file/L2CacheController_v1.5_ext_Pub.pdf)
11. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-3) [_**e**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-4) [_**f**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-5) [_**g**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-HRT-MESI_11-6) [US Patent 6275908](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=US6275908), "Cache Coherency Protocol Including an HR State"
12. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-3) [_**e**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-4) [_**f**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-5) [_**g**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-6) [_**h**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-RT-MESI_12-7) [US Patent 6334172](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=US6334172), "Cache Coherency Protocol with Tagged State for Modified Values"
13. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-PowerPC_13-0 "Jump up")** [""MPC750UM/D 12/2001 Rev. 1 MPC750 RISC Microprocessor Family User's Manual""](http://www.freescale.com/files/32bit/doc/ref_manual/MPC750UM.pdf) (PDF).
14. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESI_14-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESI_14-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESI_14-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESI_14-3) Shanley, T. (1998). [_Pentium Pro and Pentium II System Architecture_](https://books.google.com/books?id=MLJClvCYh34C&pg=PA160). Mindshare PC System Architecture Series. Addison-Wesley. p. 160. [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier) "ISBN (identifier)") [978-0-201-30973-7](https://en.wikipedia.org/wiki/Special:BookSources/978-0-201-30973-7 "Special:BookSources/978-0-201-30973-7").
15. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-AMD64_15-0 "Jump up")** [_AMD64 Architecture Programmer's Manual_](https://archive.org/details/24593APMV21). Vol. 2: System Programming. AMD. May 2013 – via Internet Archive.
16. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MOESI_Sweazey_16-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MOESI_Sweazey_16-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MOESI_Sweazey_16-2) Sweazey, P.; Smith, A. J. (1986). ["A class of compatible cache consistency protocols and their support by the IEEE futurebus"](http://pdf.aminer.org/000/419/524/a_class_of_compatible_cache_consistency_protocols_and_their_support.pdf) (PDF). _ACM SIGARCH Computer Architecture News_. **14** (2). Association for Computing Machinery (ACM): 414–423. [doi](https://en.wikipedia.org/wiki/Doi_(identifier) "Doi (identifier)"):[10.1145/17356.17404](https://doi.org/10.1145%2F17356.17404). [ISSN](https://en.wikipedia.org/wiki/ISSN_(identifier) "ISSN (identifier)") [0163-5964](https://search.worldcat.org/issn/0163-5964). [S2CID](https://en.wikipedia.org/wiki/S2CID_(identifier) "S2CID (identifier)") [9713683](https://api.semanticscholar.org/CorpusID:9713683).
17. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-17 "Jump up")** Papamarcos, Mark S.; Patel, Janak H. (1984). ["A low-overhead coherence solution for multiprocessors with private cache memories"](https://www.researchgate.net/publication/220771512). _Proceedings of the 11th annual international symposium on Computer architecture - ISCA '84_. New York, New York, USA: ACM Press. pp. 348–354. [doi](https://en.wikipedia.org/wiki/Doi_(identifier) "Doi (identifier)"):[10.1145/800015.808204](https://doi.org/10.1145%2F800015.808204). [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier) "ISBN (identifier)") [0818605383](https://en.wikipedia.org/wiki/Special:BookSources/0818605383 "Special:BookSources/0818605383").
18. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Goodman_18-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Goodman_18-1) Goodman, James R. (1983). ["Using cache memory to reduce processor-memory traffic"](http://courses.cs.vt.edu/cs5204/fall11-kafura/Papers/TransactionalMemory/Goodman-SnoopyProtocol.pdf) (PDF). _Proceedings of the 10th annual international symposium on Computer architecture - ISCA '83_. New York, New York, USA: ACM Press. pp. 124–131. [doi](https://en.wikipedia.org/wiki/Doi_(identifier) "Doi (identifier)"):[10.1145/800046.801647](https://doi.org/10.1145%2F800046.801647). [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier) "ISBN (identifier)") [0897911016](https://en.wikipedia.org/wiki/Special:BookSources/0897911016 "Special:BookSources/0897911016").
19. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Write_Once_19-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Write_Once_19-1) Hwang, K. (2011). [_Advanced Computer Architecture, 2E_](https://books.google.com/books?id=m4VFXr6qjroC&pg=PA301). McGraw-Hill computer science series. McGraw Hill Education. p. 301. [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier) "ISBN (identifier)") [978-0-07-070210-3](https://en.wikipedia.org/wiki/Special:BookSources/978-0-07-070210-3 "Special:BookSources/978-0-07-070210-3").
20. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Bull_HN_ISI_20-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Bull_HN_ISI_20-1) [_**c**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Bull_HN_ISI_20-2) [_**d**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Bull_HN_ISI_20-3) [EP patent 0396940B1](https://worldwide.espacenet.com/textdoc?DB=EPODOC&IDX=EP0396940B1), Ferruccio Zulian, "Cache memory and related consistency protocol"
21. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Shanghai_%E2%80%93_Nehalem-EP_21-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Shanghai_%E2%80%93_Nehalem-EP_21-1) Hackenberg, Daniel; Molka, Daniel; Nagel, Wolfgang E. (2009-12-12). ["Comparing cache architectures and coherency protocols on x86-64 multicore SMP systems"](http://people.freebsd.org/~lstewart/articles/cache-performance-x86-2009.pdf) (PDF). _Proceedings of the 42nd Annual IEEE/ACM International Symposium on Microarchitecture_. New York, NY, USA: ACM. pp. 413–422. [doi](https://en.wikipedia.org/wiki/Doi_(identifier) "Doi (identifier)"):[10.1145/1669112.1669165](https://doi.org/10.1145%2F1669112.1669165). [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier) "ISBN (identifier)") [9781605587981](https://en.wikipedia.org/wiki/Special:BookSources/9781605587981 "Special:BookSources/9781605587981").
22. ^ [Jump up to:_**a**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Nehalem2_22-0) [_**b**_](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Nehalem2_22-1) Rolf, Trent (2009), [_Cache Organization and Memory Management of the Intel Nehalem Computer Architecture_](http://gec.di.uminho.pt/Discip/MInf/cpd1011/PAC/material/nehalemPaper.pdf) (PDF)
23. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-Nehalem_23-0 "Jump up")** David Kanter (2007-08-28), ["The Common System Interface: Intel's Future Interconnect"](http://www.realworldtech.com/common-system-interface/5/), _Real World Tech_: 5, retrieved 2012-08-12
24. **[^](https://en.wikipedia.org/wiki/Cache_coherency_protocols_%28examples%29#cite_ref-MESI-OP_24-0 "Jump up")** ["Optimizing the MESI Cache Coherence Protocol for Multithreaded Applications on Small Symmetric Multiprocessor Systems"](http://tibrewala.net/papers/mesi98/). _Neal Tibrewala's Resume_. 2003-12-12. [Archived](https://web.archive.org/web/20161022140749/http://tibrewala.net/papers/mesi98/) from the original on 2016-10-22.