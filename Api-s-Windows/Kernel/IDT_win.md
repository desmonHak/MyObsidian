https://scorpiosoftware.net/2023/03/07/levels-of-kernel-debugging/
[[IDT]] Obtenido mediante ``WinGDB``, la lista de rutinas de servicio de interrupción ([[ISR]]) con el comando ``!idt`` en mi máquina virtual, se muestra algo como lo siguiente (truncado):
```c
1: kd> !idt

Dumping IDT: ffffbe006ffb3000

00:	fffff80575c03a00 nt!KiDivideErrorFault
01:	fffff80575c03d40 nt!KiDebugTrapOrFault	Stack = 0xFFFFBE006F98F000
02:	fffff80575c04240 nt!KiNmiInterrupt	Stack = 0xFFFFBE006F9A4000
03:	fffff80575c04700 nt!KiBreakpointTrap
04:	fffff80575c04a40 nt!KiOverflowTrap
05:	fffff80575c04d80 nt!KiBoundFault
06:	fffff80575c052c0 nt!KiInvalidOpcodeFault
07:	fffff80575c057c0 nt!KiNpxNotAvailableFault
08:	fffff80575c05ac0 nt!KiDoubleFaultAbort	Stack = 0xFFFFBE006F996000
09:	fffff80575c05dc0 nt!KiNpxSegmentOverrunAbort
0a:	fffff80575c060c0 nt!KiInvalidTssFault
0b:	fffff80575c063c0 nt!KiSegmentNotPresentFault
0c:	fffff80575c06780 nt!KiStackFault
0d:	fffff80575c06ac0 nt!KiGeneralProtectionFault
0e:	fffff80575c06e00 nt!KiPageFault
10:	fffff80575c07440 nt!KiFloatingErrorFault
11:	fffff80575c07800 nt!KiAlignmentFault
12:	fffff80575c07b40 nt!KiMcheckAbort	Stack = 0xFFFFBE006F99D000
13:	fffff80575c08640 nt!KiXmmException
14:	fffff80575c08a00 nt!KiVirtualizationException
15:	fffff80575c08f00 nt!KiControlProtectionFault
1f:	fffff80575bfd040 nt!KiApcInterrupt
20:	fffff80575bfec20 nt!KiSwInterrupt
29:	fffff80575c09400 nt!KiRaiseSecurityCheckFailure
2c:	fffff80575c09740 nt!KiRaiseAssertion
2d:	fffff80575c09a80 nt!KiDebugServiceTrap
2f:	fffff80575bff1e0 nt!KiDpcInterrupt
30:	fffff80575bfd5e0 nt!KiHvInterrupt
31:	fffff80575bfd8c0 nt!KiVmbusInterrupt0
32:	fffff80575bfdba0 nt!KiVmbusInterrupt1
33:	fffff80575bfde80 nt!KiVmbusInterrupt2
34:	fffff80575bfe160 nt!KiVmbusInterrupt3
35:	fffff80575bfb908 nt!HalpInterruptCmciService (KINTERRUPT fffff805764f3d40)

36:	fffff80575bfb910 nt!HalpInterruptCmciService (KINTERRUPT fffff805764f3e60)

60:	fffff80575bfba60 0xfffff8057b481e60 (KINTERRUPT ffffbe0070265500)

70:	fffff80575bfbae0 0xfffff8057a562790 (KINTERRUPT ffffbe0070265b40)

	                 0xfffff80579a43c30 (KINTERRUPT ffffbe0070265780)

80:	fffff80575bfbb60 0xfffff8057a103230 (KINTERRUPT ffffbe0070265c80)

	                 0xfffff8057d172760 (KINTERRUPT ffffbe0070265640)

90:	fffff80575bfbbe0 0xfffff8057d018890 (KINTERRUPT ffffbe0070265a00)

a0:	fffff80575bfbc60 0xfffff8057d016790 (KINTERRUPT ffffbe00702658c0)

b0:	fffff80575bfbce0 0xfffff80579c45d30 (KINTERRUPT ffffbe0070265dc0)

ce:	fffff80575bfbdd0 nt!HalpIommuInterruptRoutine (KINTERRUPT ffffa687e7099480)

d1:	fffff80575bfbde8 nt!HalpTimerClockInterrupt (KINTERRUPT ffffa687e70996c0)

d2:	fffff80575bfbdf0 nt!HalpTimerClockIpiRoutine (KINTERRUPT ffffa687e70995a0)

d7:	fffff80575bfbe18 nt!HalpInterruptRebootService (KINTERRUPT ffffa687e7099000)

d8:	fffff80575bfbe20 nt!HalpInterruptStubService (KINTERRUPT fffff805764f40a0)

df:	fffff80575bfbe58 nt!HalpInterruptSpuriousService (KINTERRUPT fffff805764f3f80)

e1:	fffff80575bff6d0 nt!KiIpiInterrupt
e2:	fffff80575bfbe70 nt!HalpInterruptLocalErrorService (KINTERRUPT ffffa687e7099120)

e3:	fffff80575bfbe78 nt!HalpInterruptDeferredRecoveryService (KINTERRUPT ffffa687e7099360)

fd:	fffff80575bfbf48 nt!HalpTimerProfileInterrupt (KINTERRUPT ffffa687e70997e0)

fe:	fffff80575bfbf50 nt!HalpPerfInterrupt (KINTERRUPT ffffa687e7099240)
```
Faltan algunas cosas, como el controlador de interrupciones del teclado. Esto se debe a que ciertas cosas se manejan "internamente", ya que la máquina virtual está "iluminada", lo que significa que "sabe" que es una máquina virtual. Normalmente, esto es algo bueno: se obtiene un buen soporte para copiar y pegar entre la máquina virtual y el host, interacción fluida con el mouse y el teclado, etc. Pero significa que no es lo mismo que otra máquina física.