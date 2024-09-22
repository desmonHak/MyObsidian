## CPUID(6): Gestión térmica y energética

##### EAX

| **31                                                           1** | 0      |
| ------------------------------------------------------------------ | ------ |
| **##############################################################** | **DS** |
**DS - Soportes para sensores de temperatura digitales**

##### EBX

| **31                                                           1** | 0           |
| ------------------------------------------------------------------ | ----------- |
| **##############################################################** | ***thcnt*** |
***thcnt - Número de umbrales de interrupción en el sensor de temperatura***

##### ECX

| **31                                                           1** | 0        |
| ------------------------------------------------------------------ | -------- |
| **##############################################################** | ***EC*** |
**EC - [[ECNT]]/[[MCNT]] supported**

```c
 struct {                      // low order
      UINT SensorSupported:1;    // 0
      UINT Reserved1:31;         // 31..1
   } bits;                       // high order
   UINT w;
} EAX6b;

typedef union {
   struct {                      // low order
      UINT InterruptThresholds:4;// 3..0
      UINT Reserved2:26;         // 31..4
   } bits;                       // high order
   UINT w;
} EBX6b;

typedef union {
   struct {                      // low order
      UINT ACNT_MCNT:1;          // 0
      UINT Reserved3:31;         // 31..1
   } bits;                       // high order
   UINT w;
} ECX6b;
```