listar procesos con el comando:
```c
!process 0 0
```

salida ejemplo:
```c
0: kd> !process 0 0
**** NT ACTIVE PROCESS DUMP ****
PROCESS ffffab84c187a040
    SessionId: none  Cid: 0004    Peb: 00000000  ParentCid: 0000
    DirBase: 001aa000  ObjectTable: ffffc08118458e40  HandleCount: 2991.
    Image: System

PROCESS ffffab84c19c9040
    SessionId: none  Cid: 006c    Peb: 00000000  ParentCid: 0004
    DirBase: 00515000  ObjectTable: ffffc081184385c0  HandleCount:   0.
    Image: Registry

PROCESS ffffab84c4705040
    SessionId: none  Cid: 0168    Peb: f403134000  ParentCid: 0004
    DirBase: 106646000  ObjectTable: ffffc0811893f180  HandleCount:  53.
    Image: smss.exe

PROCESS ffffab84c76bd080
    SessionId: 0  Cid: 01d0    Peb: 358c764000  ParentCid: 01c0
    DirBase: 13c331000  ObjectTable: ffffc0811b9f4980  HandleCount: 527.
    Image: csrss.exe

PROCESS ffffab84c4f19080
    SessionId: 0  Cid: 021c    Peb: 1917f6d000  ParentCid: 01c0
    DirBase: 144b8f000  ObjectTable: ffffc0811b9f4180  HandleCount: 168.
    Image: wininit.exe

PROCESS ffffab84c4f1e140
    SessionId: 1  Cid: 0224    Peb: 5d19c25000  ParentCid: 0214
    DirBase: 144bee000  ObjectTable: ffffc0811b9f4340  HandleCount: 373.
    Image: csrss.exe

PROCESS ffffab84c771b080
    SessionId: 1  Cid: 0280    Peb: 3af2d45000  ParentCid: 0214
    DirBase: 13af7b000  ObjectTable: ffffc08118ec74c0  HandleCount: 281.
    Image: winlogon.exe

PROCESS ffffab84c8bbd080
    SessionId: 0  Cid: 02b0    Peb: a05fbea000  ParentCid: 021c
    DirBase: 1430a1000  ObjectTable: ffffc0811b9f3500  HandleCount: 614.
    Image: services.exe

PROCESS ffffab84c4da9080
    SessionId: 0  Cid: 02cc    Peb: 4d0ee56000  ParentCid: 021c
    DirBase: 143089000  ObjectTable: ffffc0811b9f3e80  HandleCount: 1418.
    Image: lsass.exe

PROCESS ffffab84c7a08240
    SessionId: 0  Cid: 0344    Peb: 3ad85c6000  ParentCid: 02b0
    DirBase: 1402cd000  ObjectTable: ffffc0811bb72b00  HandleCount: 1397.
    Image: svchost.exe

PROCESS ffffab84c7a0e140
    SessionId: 1  Cid: 035c    Peb: 7c7a96f000  ParentCid: 0280
    DirBase: 1449dd000  ObjectTable: ffffc0811bb72340  HandleCount:  36.
    Image: fontdrvhost.exe

PROCESS ffffab84c7a10140
    SessionId: 0  Cid: 0364    Peb: 8feb340000  ParentCid: 021c
    DirBase: 1448ad000  ObjectTable: ffffc0811bb72640  HandleCount:  36.
    Image: fontdrvhost.exe

PROCESS ffffab84cad1f2c0
    SessionId: 0  Cid: 03c0    Peb: 47418f4000  ParentCid: 02b0
    DirBase: 1453ca000  ObjectTable: ffffc0811bb71080  HandleCount: 1165.
    Image: svchost.exe

PROCESS ffffab84c4fd7240
    SessionId: 0  Cid: 03f0    Peb: f034e76000  ParentCid: 02b0
    DirBase: 147709000  ObjectTable: ffffc0811bb71840  HandleCount: 266.
    Image: svchost.exe

PROCESS ffffab84c8d62080
    SessionId: 1  Cid: 01c0    Peb: f235ae6000  ParentCid: 0280
    DirBase: 1440b8000  ObjectTable: 00000000  HandleCount:   0.
    Image: LogonUI.exe

PROCESS ffffab84c8d64080
    SessionId: 1  Cid: 0228    Peb: 269b50c000  ParentCid: 0280
    DirBase: 144021000  ObjectTable: ffffc0811bd30500  HandleCount: 1139.
    Image: dwm.exe

PROCESS ffffab84c84cf300
    SessionId: 0  Cid: 0444    Peb: 29c46fb000  ParentCid: 02b0
    DirBase: 1499d4000  ObjectTable: ffffc0811bd30840  HandleCount: 112.
    Image: svchost.exe

PROCESS ffffab84c84d12c0
    SessionId: 0  Cid: 044c    Peb: 18bc0a4000  ParentCid: 02b0
    DirBase: 149968000  ObjectTable: ffffc0811bd30e80  HandleCount: 152.
    Image: svchost.exe

PROCESS ffffab84c84d4300
    SessionId: 0  Cid: 0460    Peb: 461f74e000  ParentCid: 02b0
    DirBase: 147545000  ObjectTable: ffffc0811bd30d00  HandleCount: 394.
    Image: svchost.exe

PROCESS ffffab84c4c30280
    SessionId: 0  Cid: 04b8    Peb: 2765406000  ParentCid: 02b0
    DirBase: 145d69000  ObjectTable: ffffc0811be45b00  HandleCount: 218.
    Image: svchost.exe

PROCESS ffffab84c4c33300
    SessionId: 0  Cid: 04c4    Peb: ab607a9000  ParentCid: 02b0
    DirBase: 145d51000  ObjectTable: ffffc0811be44200  HandleCount: 252.
    Image: svchost.exe

PROCESS ffffab84c4c382c0
    SessionId: 0  Cid: 04d4    Peb: 5983abf000  ParentCid: 02b0
    DirBase: 145aaf000  ObjectTable: ffffc0811be45340  HandleCount: 137.
    Image: svchost.exe

PROCESS ffffab84c7d59300
    SessionId: 0  Cid: 0524    Peb: 388d109000  ParentCid: 02b0
    DirBase: 142175000  ObjectTable: ffffc0811be449c0  HandleCount: 221.
    Image: svchost.exe

PROCESS ffffab84c90a8300
    SessionId: 0  Cid: 0550    Peb: b43cbf6000  ParentCid: 02b0
    DirBase: 1466bf000  ObjectTable: ffffc0811be45e00  HandleCount: 119.
    Image: svchost.exe

PROCESS ffffab84c90b4240
    SessionId: 0  Cid: 057c    Peb: 4023b19000  ParentCid: 02b0
    DirBase: 1447c0000  ObjectTable: ffffc0811be446c0  HandleCount: 178.
    Image: svchost.exe

PROCESS ffffab84c7a24300
    SessionId: 0  Cid: 05bc    Peb: 26661c9000  ParentCid: 02b0
    DirBase: 14904b000  ObjectTable: ffffc0811be457c0  HandleCount: 385.
    Image: svchost.exe

PROCESS ffffab84c7a30240
    SessionId: 0  Cid: 05f4    Peb: bf34123000  ParentCid: 02b0
    DirBase: 149b03000  ObjectTable: ffffc0811bf83b40  HandleCount: 411.
    Image: svchost.exe

PROCESS ffffab84c7aa9080
    SessionId: 0  Cid: 0664    Peb: 3728597000  ParentCid: 02b0
    DirBase: 13a5dc000  ObjectTable: ffffc0811bf83d00  HandleCount: 437.
    Image: svchost.exe

PROCESS ffffab84c798b240
    SessionId: 0  Cid: 069c    Peb: bd68888000  ParentCid: 02b0
    DirBase: 14f4fb000  ObjectTable: ffffc0811bf83380  HandleCount: 175.
    Image: VBoxService.exe

PROCESS ffffab84c87eb240
    SessionId: 0  Cid: 06f0    Peb: 989d2d3000  ParentCid: 02b0
    DirBase: 14d87d000  ObjectTable: ffffc0811bf84180  HandleCount: 331.
    Image: svchost.exe

PROCESS ffffab84c4e442c0
    SessionId: 0  Cid: 0704    Peb: f430f8a000  ParentCid: 02b0
    DirBase: 15172d000  ObjectTable: ffffc0811bf83e80  HandleCount: 165.
    Image: svchost.exe

PROCESS ffffab84c4e46280
    SessionId: 0  Cid: 0710    Peb: b48d642000  ParentCid: 02b0
    DirBase: 14da59000  ObjectTable: ffffc0811bf83200  HandleCount: 262.
    Image: svchost.exe

PROCESS ffffab84c4e4d240
    SessionId: 0  Cid: 0728    Peb: c936d47000  ParentCid: 02b0
    DirBase: 14ab53000  ObjectTable: ffffc0811bf847c0  HandleCount: 175.
    Image: svchost.exe

PROCESS ffffab84c87e8300
    SessionId: 0  Cid: 07a4    Peb: 6d56711000  ParentCid: 02b0
    DirBase: 14c70b000  ObjectTable: ffffc0811bf83080  HandleCount: 179.
    Image: svchost.exe

PROCESS ffffab84c7984040
    SessionId: none  Cid: 07bc    Peb: 00000000  ParentCid: 0004
    DirBase: 14bff2000  ObjectTable: ffffc0811be45180  HandleCount:   0.
    Image: MemCompression

PROCESS ffffab84c4e4b080
    SessionId: 0  Cid: 07f0    Peb: 90db5a6000  ParentCid: 02b0
    DirBase: 14c799000  ObjectTable: ffffc0811bf83500  HandleCount: 169.
    Image: svchost.exe

PROCESS ffffab84c79c0080
    SessionId: 0  Cid: 0700    Peb: 4bded88000  ParentCid: 02b0
    DirBase: 14e875000  ObjectTable: ffffc0811c1c6980  HandleCount: 151.
    Image: svchost.exe

PROCESS ffffab84c1885080
    SessionId: 0  Cid: 0724    Peb: 1163cb0000  ParentCid: 02b0
    DirBase: 15167d000  ObjectTable: ffffc0811c1c6800  HandleCount: 179.
    Image: svchost.exe

PROCESS ffffab84c7471300
    SessionId: 0  Cid: 0838    Peb: 30341db000  ParentCid: 02b0
    DirBase: 14ca43000  ObjectTable: ffffc0811c1c6b00  HandleCount: 270.
    Image: svchost.exe

PROCESS ffffab84c7ed2240
    SessionId: 0  Cid: 08bc    Peb: cc65393000  ParentCid: 02b0
    DirBase: 14f93a000  ObjectTable: ffffc0811c1c7dc0  HandleCount: 310.
    Image: svchost.exe

PROCESS ffffab84c4f58300
    SessionId: 0  Cid: 08f4    Peb: 8e90d5e000  ParentCid: 02b0
    DirBase: 15219a000  ObjectTable: ffffc0811c1c61c0  HandleCount: 334.
    Image: svchost.exe

PROCESS ffffab84c7287300
    SessionId: 0  Cid: 0944    Peb: c18ed7f000  ParentCid: 02b0
    DirBase: 14e6c2000  ObjectTable: ffffc0811c1c59c0  HandleCount: 209.
    Image: svchost.exe

PROCESS ffffab84c7289300
    SessionId: 0  Cid: 094c    Peb: e8a2cc7000  ParentCid: 02b0
    DirBase: 14e670000  ObjectTable: ffffc0811c1c6c80  HandleCount: 375.
    Image: svchost.exe

PROCESS ffffab84c4f70240
    SessionId: 0  Cid: 0990    Peb: ea458fe000  ParentCid: 02b0
    DirBase: 14ecd2000  ObjectTable: ffffc0811c1c6e40  HandleCount: 189.
    Image: svchost.exe

PROCESS ffffab84ca4e3240
    SessionId: 0  Cid: 09e8    Peb: 33cb80b000  ParentCid: 02b0
    DirBase: 14cb8c000  ObjectTable: ffffc0811c1c7ac0  HandleCount: 209.
    Image: svchost.exe

PROCESS ffffab84c8aa10c0
    SessionId: 0  Cid: 0a18    Peb: 00c62000  ParentCid: 02b0
    DirBase: 153f74000  ObjectTable: ffffc0811c1c7140  HandleCount: 427.
    Image: spoolsv.exe

PROCESS ffffab84c8ab4300
    SessionId: 0  Cid: 0a30    Peb: 6ac8aec000  ParentCid: 02b0
    DirBase: 14e7b2000  ObjectTable: ffffc0811c1c7900  HandleCount: 424.
    Image: svchost.exe

PROCESS ffffab84c8ac0300
    SessionId: 0  Cid: 0a54    Peb: 4ef6540000  ParentCid: 02b0
    DirBase: 155f96000  ObjectTable: ffffc0811c1c7c40  HandleCount: 185.
    Image: svchost.exe

PROCESS ffffab84c857c300
    SessionId: 0  Cid: 0b1c    Peb: 2562d89000  ParentCid: 02b0
    DirBase: 14d713000  ObjectTable: ffffc0811c1c8580  HandleCount: 215.
    Image: svchost.exe

PROCESS ffffab84c857d080
    SessionId: 0  Cid: 0b24    Peb: 6aad134000  ParentCid: 02b0
    DirBase: 158201000  ObjectTable: ffffc0811c1c8bc0  HandleCount: 523.
    Image: svchost.exe

PROCESS ffffab84c8580300
    SessionId: 0  Cid: 0b2c    Peb: bd047c9000  ParentCid: 02b0
    DirBase: 14094e000  ObjectTable: ffffc0811c1c8400  HandleCount: 331.
    Image: svchost.exe

PROCESS ffffab84c8584240
    SessionId: 0  Cid: 0b3c    Peb: 71e6947000  ParentCid: 02b0
    DirBase: 1582c7000  ObjectTable: ffffc0811c1c8d80  HandleCount: 391.
    Image: svchost.exe

PROCESS ffffab84c899f2c0
    SessionId: 0  Cid: 0b74    Peb: 9148e45000  ParentCid: 02b0
    DirBase: 14aa7e000  ObjectTable: ffffc0811c1c8280  HandleCount: 133.
    Image: svchost.exe

PROCESS ffffab84c8f06240
    SessionId: 0  Cid: 0b90    Peb: 1ff460c000  ParentCid: 02b0
    DirBase: 154628000  ObjectTable: ffffc0811c8c5e80  HandleCount: 209.
    Image: svchost.exe

PROCESS ffffab84c8f09280
    SessionId: 0  Cid: 0b98    Peb: 23eec36000  ParentCid: 02b0
    DirBase: 1581d3000  ObjectTable: ffffc0811c8c5200  HandleCount: 128.
    Image: svchost.exe

PROCESS ffffab84c8f0a080
    SessionId: 0  Cid: 0ba0    Peb: 2c7e122000  ParentCid: 02b0
    DirBase: 1528e4000  ObjectTable: ffffc0811c8c5380  HandleCount: 628.
    Image: MsMpEng.exe

PROCESS ffffab84c8f15240
    SessionId: 0  Cid: 0bb4    Peb: da61114000  ParentCid: 02b0
    DirBase: 14d993000  ObjectTable: ffffc0811c8c7900  HandleCount: 387.
    Image: svchost.exe

PROCESS ffffab84c8999080
    SessionId: 0  Cid: 0be8    Peb: 66e8ab2000  ParentCid: 02b0
    DirBase: 1510a6000  ObjectTable: ffffc0811c8c5d00  HandleCount: 364.
    Image: svchost.exe

PROCESS ffffab84cccc4300
    SessionId: 0  Cid: 0920    Peb: 38ed11b000  ParentCid: 02b0
    DirBase: 15c179000  ObjectTable: ffffc0811c8c59c0  HandleCount: 107.
    Image: svchost.exe

PROCESS ffffab84c9b2b240
    SessionId: 0  Cid: 0c1c    Peb: 3b53741000  ParentCid: 02b0
    DirBase: 15cb8f000  ObjectTable: ffffc0811c8c6980  HandleCount: 377.
    Image: svchost.exe

PROCESS ffffab84c8da7240
    SessionId: 0  Cid: 0ea4    Peb: 456dfc0000  ParentCid: 02b0
    DirBase: 1633a9000  ObjectTable: ffffc0811c8c7ac0  HandleCount: 535.
    Image: svchost.exe

PROCESS ffffab84c844a080
    SessionId: 0  Cid: 0b54    Peb: 8935ef1000  ParentCid: 02b0
    DirBase: 17a75c000  ObjectTable: ffffc0811c8c8740  HandleCount: 181.
    Image: NisSrv.exe

PROCESS ffffab84c9026080
    SessionId: 1  Cid: 0fb0    Peb: 3e7e6cd000  ParentCid: 08bc
    DirBase: 1095da000  ObjectTable: ffffc0811d78c980  HandleCount: 591.
    Image: sihost.exe

PROCESS ffffab84c97e7080
    SessionId: 1  Cid: 0f64    Peb: 5f5a68b000  ParentCid: 02b0
    DirBase: 10a6c5000  ObjectTable: ffffc0811bd31640  HandleCount: 307.
    Image: svchost.exe

PROCESS ffffab84c99eb080
    SessionId: 1  Cid: 03fc    Peb: 73f595f000  ParentCid: 02b0
    DirBase: 10be77000  ObjectTable: ffffc0811c8c5080  HandleCount: 415.
    Image: svchost.exe

PROCESS ffffab84c753b080
    SessionId: 0  Cid: 05a0    Peb: 4cc941a000  ParentCid: 02b0
    DirBase: 174f94000  ObjectTable: ffffc0811d78ed80  HandleCount: 295.
    Image: svchost.exe

PROCESS ffffab84cb24e080
    SessionId: 0  Cid: 0740    Peb: 009c1000  ParentCid: 05f4
    DirBase: 10895a000  ObjectTable: ffffc0811c1c7480  HandleCount: 206.
    Image: MicrosoftEdgeUpdate.exe

PROCESS ffffab84c8428080
    SessionId: 1  Cid: 0f44    Peb: 4dba94d000  ParentCid: 0280
    DirBase: 10c1ca000  ObjectTable: 00000000  HandleCount:   0.
    Image: userinit.exe

PROCESS ffffab84c842f340
    SessionId: 1  Cid: 0da8    Peb: 278c3e0000  ParentCid: 05f4
    DirBase: 10d1fd000  ObjectTable: ffffc0811e3fa480  HandleCount: 317.
    Image: taskhostw.exe

PROCESS ffffab84c7a90080
    SessionId: 0  Cid: 07e8    Peb: eee3e98000  ParentCid: 02b0
    DirBase: 10d8da000  ObjectTable: ffffc0811e3f9b00  HandleCount: 201.
    Image: svchost.exe

PROCESS ffffab84c7742080
    SessionId: 1  Cid: 06e0    Peb: 006d0000  ParentCid: 0f44
    DirBase: 10c365000  ObjectTable: ffffc0811e3fa780  HandleCount: 2240.
    Image: explorer.exe

PROCESS ffffab84c4e892c0
    SessionId: 0  Cid: 023c    Peb: 32f2ba5000  ParentCid: 02b0
    DirBase: 10fa03000  ObjectTable: ffffc0811e3f8a00  HandleCount: 312.
    Image: svchost.exe

PROCESS ffffab84c75e3280
    SessionId: 0  Cid: 0548    Peb: 8e98837000  ParentCid: 02b0
    DirBase: 1113bd000  ObjectTable: ffffc0811e3f9340  HandleCount: 169.
    Image: svchost.exe

PROCESS ffffab84c4d09080
    SessionId: 0  Cid: 0ecc    Peb: 24da23d000  ParentCid: 02b0
    DirBase: 1134ba000  ObjectTable: ffffc0811e3f8200  HandleCount: 339.
    Image: svchost.exe

PROCESS ffffab84c4d112c0
    SessionId: 1  Cid: 08ac    Peb: a6f20ce000  ParentCid: 0548
    DirBase: 1111ea000  ObjectTable: ffffc0811e3fa600  HandleCount: 426.
    Image: ctfmon.exe

PROCESS ffffab84c4b68080
    SessionId: 0  Cid: 102c    Peb: 00b27000  ParentCid: 0740
    DirBase: 113ee3000  ObjectTable: ffffc0811e3f94c0  HandleCount: 192.
    Image: MicrosoftEdgeUpdate.exe

PROCESS ffffab84c7bd3300
    SessionId: 0  Cid: 1204    Peb: 0047b000  ParentCid: 02b0
    DirBase: 126aa8000  ObjectTable: ffffc0811e3fb100  HandleCount: 514.
    Image: MicrosoftEdgeUpdate.exe

PROCESS ffffab84c7bd5240
    SessionId: 0  Cid: 1210    Peb: d8687af000  ParentCid: 02b0
    DirBase: 11feab000  ObjectTable: 00000000  HandleCount:   0.
    Image: svchost.exe

PROCESS ffffab84c48d6080
    SessionId: 0  Cid: 1218    Peb: f61f344000  ParentCid: 02b0
    DirBase: 142c76000  ObjectTable: ffffc0811e3f83c0  HandleCount: 118.
    Image: svchost.exe

PROCESS ffffab84c4a04280
    SessionId: 0  Cid: 1308    Peb: f741880000  ParentCid: 02b0
    DirBase: 126d8a000  ObjectTable: ffffc0811d748140  HandleCount: 122.
    Image: svchost.exe

PROCESS ffffab84c4a0b280
    SessionId: 0  Cid: 1320    Peb: 7d9a1c0000  ParentCid: 02b0
    DirBase: 132904000  ObjectTable: ffffc0811d7482c0  HandleCount: 238.
    Image: svchost.exe

PROCESS ffffab84c7cd5340
    SessionId: 1  Cid: 13c8    Peb: ba4cba2000  ParentCid: 02b0
    DirBase: 126c8a000  ObjectTable: ffffc0811e3fd980  HandleCount: 318.
    Image: svchost.exe

PROCESS ffffab84c79c7080
    SessionId: 1  Cid: 1408    Peb: 3084055000  ParentCid: 0344
    DirBase: 16929f000  ObjectTable: ffffc0811e3fe180  HandleCount: 639.
    Image: StartMenuExperienceHost.exe

PROCESS ffffab84c7450240
    SessionId: 0  Cid: 1430    Peb: 3c8e9da000  ParentCid: 02b0
    DirBase: 13952e000  ObjectTable: ffffc0811e3fc6c0  HandleCount: 408.
    Image: svchost.exe

PROCESS ffffab84c79db080
    SessionId: 0  Cid: 14a0    Peb: 1040153000  ParentCid: 0344
    DirBase: 13e3e4000  ObjectTable: ffffc0811e3fe300  HandleCount: 404.
    Image: MoUsoCoreWorker.exe

PROCESS ffffab84c9e57340
    SessionId: 1  Cid: 1524    Peb: 654a40d000  ParentCid: 0344
    DirBase: 11ea1f000  ObjectTable: ffffc0811e3fc240  HandleCount: 312.
    Image: RuntimeBroker.exe

PROCESS ffffab84c7404240
    SessionId: 0  Cid: 1568    Peb: 2f16da7000  ParentCid: 02b0
    DirBase: 16ad11000  ObjectTable: ffffc0811e3fa300  HandleCount: 708.
    Image: svchost.exe

PROCESS ffffab84c74020c0
    SessionId: 1  Cid: 15c8    Peb: dcd0353000  ParentCid: 0344
    DirBase: 183098000  ObjectTable: ffffc0811e3fc880  HandleCount: 1196.
    Image: SearchApp.exe

PROCESS ffffab84c76ea340
    SessionId: 1  Cid: 1670    Peb: 1bf7399000  ParentCid: 0344
    DirBase: 170d72000  ObjectTable: ffffc0811e3fc540  HandleCount: 504.
    Image: RuntimeBroker.exe

PROCESS ffffab84c48a3240
    SessionId: 0  Cid: 16d8    Peb: 6b18317000  ParentCid: 02b0
    DirBase: 1869a9000  ObjectTable: ffffc0811e3fcb80  HandleCount: 706.
    Image: SearchIndexer.exe

PROCESS ffffab84c4892080
    SessionId: 0  Cid: 16e8    Peb: bfae8d3000  ParentCid: 02b0
    DirBase: 165afe000  ObjectTable: ffffc0811e3fb280  HandleCount: 180.
    Image: svchost.exe

PROCESS ffffab84c8fb30c0
    SessionId: 0  Cid: 18b8    Peb: 1f4c562000  ParentCid: 02b0
    DirBase: 1a1847000  ObjectTable: ffffc0811e3fec40  HandleCount: 164.
    Image: svchost.exe

PROCESS ffffab84c97e6080
    SessionId: 1  Cid: 1988    Peb: 855b997000  ParentCid: 0344
    DirBase: 19f11b000  ObjectTable: ffffc0811bd309c0  HandleCount: 1242.
    Image: SearchApp.exe

PROCESS ffffab84c77cf080
    SessionId: 0  Cid: 199c    Peb: f8d1864000  ParentCid: 1204
    DirBase: 144437000  ObjectTable: ffffc0811e3faac0  HandleCount: 103.
    Image: MicrosoftEdge_X64_128.0.2739.67.exe

PROCESS ffffab84c73a8080
    SessionId: 0  Cid: 19b8    Peb: 9d87fd8000  ParentCid: 02b0
    DirBase: 19523b000  ObjectTable: ffffc0811e3ff740  HandleCount: 271.
    Image: svchost.exe

PROCESS ffffab84c978a340
    SessionId: 1  Cid: 1b44    Peb: a728300000  ParentCid: 0344
    DirBase: 1ace4c000  ObjectTable: ffffc0811e3ff8c0  HandleCount: 457.
    Image: smartscreen.exe

PROCESS ffffab84c86ce080
    SessionId: 0  Cid: 1b74    Peb: f829451000  ParentCid: 199c
    DirBase: 19b534000  ObjectTable: ffffc0811d78e400  HandleCount: 161.
    Image: setup.exe

PROCESS ffffab84c4355080
    SessionId: 0  Cid: 1788    Peb: e6d4608000  ParentCid: 1b74
    DirBase: 05d15000  ObjectTable: ffffc0811eef66c0  HandleCount:  79.
    Image: setup.exe

PROCESS ffffab84c9614080
    SessionId: 1  Cid: 190c    Peb: 1d7ef8000  ParentCid: 06e0
    DirBase: 18812a000  ObjectTable: ffffc0811eef7b00  HandleCount: 174.
    Image: SecurityHealthSystray.exe

PROCESS ffffab84ca669280
    SessionId: 0  Cid: 1b10    Peb: 2ea1949000  ParentCid: 02b0
    DirBase: 1b28b9000  ObjectTable: ffffc0811eef63c0  HandleCount: 403.
    Image: SecurityHealthService.exe

PROCESS ffffab84ca66d080
    SessionId: 1  Cid: 110c    Peb: 7c6f9ed000  ParentCid: 06e0
    DirBase: 1c0a63000  ObjectTable: ffffc0811eef6d00  HandleCount: 260.
    Image: VBoxTray.exe

PROCESS ffffab84c962c080
    SessionId: 1  Cid: 1ba0    Peb: fc40e50000  ParentCid: 0344
    DirBase: 1b9b50000  ObjectTable: ffffc0811eef7680  HandleCount: 234.
    Image: dllhost.exe

PROCESS ffffab84c976f0c0
    SessionId: 1  Cid: 1ba4    Peb: a70259b000  ParentCid: 06e0
    DirBase: 1ae708000  ObjectTable: ffffc0811eef8dc0  HandleCount: 1333.
    Image: msedge.exe

PROCESS ffffab84cb25b0c0
    SessionId: 1  Cid: 1c1c    Peb: 04ced000  ParentCid: 06e0
    DirBase: 1bd1e6000  ObjectTable: ffffc0811eef9100  HandleCount: 732.
    Image: OneDrive.exe

PROCESS ffffab84c977e340
    SessionId: 1  Cid: 1c4c    Peb: d0e5da9000  ParentCid: 0344
    DirBase: 1c40cb000  ObjectTable: ffffc0811eef8600  HandleCount: 295.
    Image: RuntimeBroker.exe

PROCESS ffffab84c4f12080
    SessionId: 1  Cid: 1f0c    Peb: 52d426a000  ParentCid: 1ba4
    DirBase: 1cfeef000  ObjectTable: ffffc0811eef71c0  HandleCount: 149.
    Image: msedge.exe

PROCESS ffffab84c7f4d0c0
    SessionId: 0  Cid: 1f6c    Peb: 8108ad1000  ParentCid: 16d8
    DirBase: 1dffd3000  ObjectTable: ffffc0811eef8ac0  HandleCount: 358.
    Image: SearchProtocolHost.exe

PROCESS ffffab84c7fc40c0
    SessionId: 1  Cid: 1f98    Peb: 1af5021000  ParentCid: 06e0
    DirBase: 1e0f91000  ObjectTable: ffffc0811eef8940  HandleCount: 599.
    Image: Taskmgr.exe

PROCESS ffffab84c97bc300
    SessionId: 1  Cid: 1d50    Peb: 504c818000  ParentCid: 1ba4
    DirBase: 1d08ba000  ObjectTable: ffffc0811eef7340  HandleCount: 291.
    Image: msedge.exe

PROCESS ffffab84c9854080
    SessionId: 1  Cid: 1e10    Peb: 45b946f000  ParentCid: 1ba4
    DirBase: 1e28ab000  ObjectTable: ffffc0811eef6a00  HandleCount: 343.
    Image: msedge.exe

PROCESS ffffab84c7f69080
    SessionId: 1  Cid: 1db4    Peb: 9cafb44000  ParentCid: 1ba4
    DirBase: 1e9c11000  ObjectTable: ffffc0811eef6540  HandleCount: 179.
    Image: msedge.exe

PROCESS ffffab84ca276080
    SessionId: 1  Cid: 1e7c    Peb: 75715b1000  ParentCid: 1ba4
    DirBase: 1de996000  ObjectTable: ffffc0811d747800  HandleCount: 494.
    Image: msedge.exe

PROCESS ffffab84ca274080
    SessionId: 1  Cid: 1e74    Peb: 5d0a5d7000  ParentCid: 1ba4
    DirBase: 1f87c7000  ObjectTable: ffffc0811eefbe40  HandleCount: 201.
    Image: msedge.exe

PROCESS ffffab84ca273080
    SessionId: 0  Cid: 204c    Peb: 953d3a2000  ParentCid: 02b0
    DirBase: 1f548b000  ObjectTable: ffffc0811eefbb40  HandleCount: 509.
    Image: svchost.exe

PROCESS ffffab84c4b31080
    SessionId: 0  Cid: 2080    Peb: ee08bb2000  ParentCid: 02b0
    DirBase: 1f9cb0000  ObjectTable: ffffc0811eefbcc0  HandleCount: 283.
    Image: svchost.exe

PROCESS ffffab84ca43d080
    SessionId: 0  Cid: 2088    Peb: 3c93cc000  ParentCid: 02b0
    DirBase: 1f76d5000  ObjectTable: ffffc0811eefc300  HandleCount: 477.
    Image: svchost.exe

PROCESS ffffab84ca437080
    SessionId: 0  Cid: 2294    Peb: e7217c7000  ParentCid: 02b0
    DirBase: 1f8cd3000  ObjectTable: ffffc081209f8040  HandleCount: 219.
    Image: svchost.exe

PROCESS ffffab84c96460c0
    SessionId: 0  Cid: 0f14    Peb: b3926a9000  ParentCid: 02b0
    DirBase: 07178000  ObjectTable: ffffc0812147a600  HandleCount: 105.
    Image: SgrmBroker.exe

PROCESS ffffab84c8d78080
    SessionId: 1  Cid: 1438    Peb: f65e517000  ParentCid: 02b0
    DirBase: 13cd7d000  ObjectTable: ffffc0812147c880  HandleCount: 251.
    Image: svchost.exe

PROCESS ffffab84c98c0080
    SessionId: 0  Cid: 2110    Peb: edd952f000  ParentCid: 02b0
    DirBase: 190d9000  ObjectTable: ffffc0812147a300  HandleCount: 217.
    Image: svchost.exe

PROCESS ffffab84c9246080
    SessionId: 1  Cid: 22f4    Peb: 5973d6b000  ParentCid: 0344
    DirBase: 24b76000  ObjectTable: ffffc081224d1d80  HandleCount: 521.
    Image: TextInputHost.exe

PROCESS ffffab84c78e6080
    SessionId: 1  Cid: 2040    Peb: d2bf962000  ParentCid: 0344
    DirBase: 18eeb000  ObjectTable: ffffc081224d5a80  HandleCount: 372.
    Image: ApplicationFrameHost.exe

PROCESS ffffab84c97c8080
    SessionId: 1  Cid: 17d8    Peb: a8ce76e000  ParentCid: 0344
    DirBase: 32ab4000  ObjectTable: ffffc081224d4640  HandleCount: 1291.
    Image: SystemSettings.exe

PROCESS ffffab84c7547080
    SessionId: 0  Cid: 1450    Peb: 476b490000  ParentCid: 02b0
    DirBase: 3ec3c000  ObjectTable: ffffc081224d1900  HandleCount: 137.
    Image: svchost.exe

PROCESS ffffab84c9788080
    SessionId: 1  Cid: 03b8    Peb: 92d59c3000  ParentCid: 0344
    DirBase: 44b8d000  ObjectTable: ffffc081224d7840  HandleCount: 148.
    Image: UserOOBEBroker.exe

PROCESS ffffab84c7cde080
    SessionId: 0  Cid: 02ac    Peb: 352bef3000  ParentCid: 02b0
    DirBase: 18c6af000  ObjectTable: 00000000  HandleCount:   0.
    Image: svchost.exe

PROCESS ffffab84c4831080
    SessionId: 0  Cid: 0cac    Peb: c1f2b2f000  ParentCid: 0344
    DirBase: 2a120000  ObjectTable: ffffc081237d2380  HandleCount: 179.
    Image: WmiPrvSE.exe

PROCESS ffffab84c926a080
    SessionId: 0  Cid: 17d4    Peb: 7291c41000  ParentCid: 02b0
    DirBase: 25166000  ObjectTable: ffffc081237d4900  HandleCount: 142.
    Image: TrustedInstaller.exe

PROCESS ffffab84ca436080
    SessionId: 0  Cid: 2368    Peb: 6e0f666000  ParentCid: 0344
    DirBase: 61b14000  ObjectTable: ffffc081237d4140  HandleCount: 628.
    Image: TiWorker.exe

PROCESS ffffab84cc010100
    SessionId: 1  Cid: 1058    Peb: b8626a5000  ParentCid: 17d8
    DirBase: a3f2b000  ObjectTable: 00000000  HandleCount:   0.
    Image: SystemSettingsAdminFlows.exe

PROCESS ffffab84c97bb080
    SessionId: 0  Cid: 07f8    Peb: f4cd4b2000  ParentCid: 14a0
    DirBase: 7f78c000  ObjectTable: ffffc081237cf640  HandleCount: 146.
    Image: wuauclt.exe

PROCESS ffffab84c7e82080
    SessionId: 1  Cid: 0ea0    Peb: 6e65995000  ParentCid: 0344
    DirBase: 14369000  ObjectTable: ffffc08124dd4380  HandleCount: 675.
    Image: backgroundTaskHost.exe

PROCESS ffffab84cb3570c0
    SessionId: 1  Cid: 105c    Peb: 7fee5bc000  ParentCid: 0344
    DirBase: 1588c6000  ObjectTable: ffffc08124dd1c80  HandleCount: 333.
    Image: HxTsr.exe

PROCESS ffffab84c8fd2080
    SessionId: 0  Cid: 1354    Peb: 6e85490000  ParentCid: 08f4
    DirBase: 2092b6000  ObjectTable: ffffc08124dd3580  HandleCount: 169.
    Image: audiodg.exe

PROCESS ffffab84c4b60080
    SessionId: 1  Cid: 1754    Peb: 1ed8fd2000  ParentCid: 0344
    DirBase: 1898b9000  ObjectTable: ffffc081237cb7c0  HandleCount: 180.
    Image: RuntimeBroker.exe

PROCESS ffffab84c4b2f2c0
    SessionId: 0  Cid: 1260    Peb: cb46676000  ParentCid: 0344
    DirBase: 1768eb000  ObjectTable: ffffc08124dd4840  HandleCount: 178.
    Image: WmiPrvSE.exe

PROCESS ffffab84c87e4080
    SessionId: 0  Cid: 1188    Peb: dd65eb0000  ParentCid: 16d8
    DirBase: 61995000  ObjectTable: ffffc08124dd7700  HandleCount: 142.
    Image: SearchFilterHost.exe

PROCESS ffffab84c7a97080
    SessionId: 1  Cid: 0370    Peb: 4f2f7f6000  ParentCid: 0344
    DirBase: 2012cc000  ObjectTable: ffffc081237cd880  HandleCount: 234.
    Image: RuntimeBroker.exe
```