https://edc.intel.com/content/www/us/en/secure/design/confidential/products-and-solutions/processors-and-chipsets/tiger-lake/11th-generation-intel-core-processor-family-specification-update/identification-information/

| Processor               | CPUID     | Extended Family<br><br>[27:20] | Extended Model<br><br>[19:16] | Processor Type<br><br>[13:12] | Family Code<br><br>[11:8] | Model Number<br><br>[7:4] | Stepping ID<br><br>[3:0] |
| ----------------------- | --------- | ------------------------------ | ----------------------------- | ----------------------------- | ------------------------- | ------------------------- | ------------------------ |
| UP3/UP4/H35             | 000806C1h | 0x0                            | 0x8                           | 0x0                           | 0x6                       | 0xc                       | 0x1                      |
| H81                     | 000806D1h | 0x0                            | 0x8                           | 0x0                           | 0x6                       | 0xd                       | 0x1                      |
| UP3-Refresh/H35-Refresh | 000806C2h | 0x0                            | 0x8                           | 0x0                           | 0x6                       | 0xc                       | 0x2                      |

```c

    { // Tiger Lake
        .arch = Tiger_Lake,
        .core = 0x1,  // H

        .extended_model  = 0x8,
        .model           = 0xc,

        .extended_family = 0x0,
        .family          = 0x6
        // 	Family 6 Model ¿141/140?
    }, { // Tiger Lake
        .arch = Tiger_Lake,
        .core = 0x2,  // U

        .extended_model  = 0x8,
        .model           = 0xc,

        .extended_family = 0x0,
        .family          = 0x6
        // Family 6 Model 140
    }, { // Tiger Lake
        .arch = Tiger_Lake,
        .core = 0x1,  // H81

        .extended_model  = 0x8,
        .model           = 0xd,

        .extended_family = 0x0,
        .family          = 0x6
        // Family 6 Model 141
    },
```