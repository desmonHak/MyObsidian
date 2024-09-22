para obtener información de la VM puede usar el siguiente comando:
```c
VBoxManage showvminfo "Win10(64)"
```
*en lugar de poner `"Win10(64)"` ponga el nombre de su VM, puede listarlas como se muestra aquí, [[Listar_maquinas_vm]]*

Ejemplo salida:
```c
C:\Users\desmon0xff>VBoxManage showvminfo "Win10(64)"
Name:                        Win10(64)
Encryption:                  disabled
Groups:                      /
Platform Architecture:       x86
Guest OS:                    Windows 10 (64-bit)
UUID:                        9cd73e7b-9ce4-4ff3-9d7a-8b6b792e44a5
Config file:                 D:\VM's\Win10(64)\Win10(64).vbox
Snapshot folder:             D:\VM's\Win10(64)\Snapshots
Log folder:                  D:\VM's\Win10(64)\Logs
Hardware UUID:               9cd73e7b-9ce4-4ff3-9d7a-8b6b792e44a5
Memory size:                 8192MB
Page Fusion:                 disabled
VRAM size:                   256MB
CPU exec cap:                100%
CPUProfile:                  Intel Core i7-6700K
Chipset:                     piix3
Firmware:                    BIOS
Number of CPUs:              4
HPET:                        disabled
PAE:                         enabled
Long Mode:                   enabled
Triple Fault Reset:          disabled
APIC:                        enabled
X2APIC:                      disabled
Nested VT-x/AMD-V:           enabled
CPUID overrides:             None
Hardware Virtualization:     enabled
Nested Paging:               enabled
Large Pages:                 enabled
VT-x VPID:                   enabled
VT-x Unrestricted Exec.:     enabled
AMD-V Virt. Vmsave/Vmload:   enabled
CPUID Portability Level:     0
Boot menu mode:              message and menu
Boot Device 1:               Floppy
Boot Device 2:               DVD
Boot Device 3:               HardDisk
Boot Device 4:               Not Assigned
ACPI:                        enabled
IOAPIC:                      enabled
BIOS APIC mode:              APIC
Time offset:                 0ms
BIOS NVRAM File:             D:\VM's\Win10(64)\Win10(64).nvram
RTC:                         UTC
IOMMU:                       None
Paravirt. Provider:          KVM
Effective Paravirt. Prov.:   KVM
State:                       powered off (since 2024-09-15T14:45:05.456000000)
Graphics Controller:         VBoxSVGA
Monitor count:               1
3D Acceleration:             enabled
Teleporter Enabled:          disabled
Teleporter Port:             0
Teleporter Address:
Teleporter Password:
Tracing Enabled:             disabled
Allow Tracing to Access VM:  disabled
Tracing Configuration:
Autostart Enabled:           disabled
Autostart Delay:             0
Default Frontend:
VM process priority:         default
Storage Controllers:
#0: 'SATA', Type: IntelAhci, Instance: 0, Ports: 2 (max 30), Bootable
  Port 0, Unit 0: UUID: 8a0d45e8-9ea0-4fd3-bf46-441b1d3b832a
    Location: "D:\VM's\Win10(64)\Win10(64).vdi"
  Port 1, Unit 0: UUID: 80735523-6f60-4717-a87e-208e46f3c4d7
    Location: "C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso"
NIC 1:                       MAC: 080027363FBE, Attachment: Bridged Interface 'Intel(R) Wi-Fi 6E AX211 160MHz', Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: allow-all, Bandwidth group: none
NIC 2:                       disabled
NIC 3:                       disabled
NIC 4:                       disabled
NIC 5:                       disabled
NIC 6:                       disabled
NIC 7:                       disabled
NIC 8:                       disabled
Pointing Device:             USB Tablet
Keyboard Device:             PS/2 Keyboard
UART 1:                      disabled
UART 2:                      disabled
UART 3:                      disabled
UART 4:                      disabled
LPT 1:                       disabled
LPT 2:                       disabled
Audio:                       enabled (Driver: Default, Controller: HDA, Codec: STAC9221)
Audio playback:              enabled
Audio capture:               disabled
Clipboard Mode:              Bidirectional
Clipboard file transfers:    disabled
Drag and drop Mode:          Bidirectional
VRDE:                        disabled
OHCI USB:                    disabled
EHCI USB:                    disabled
xHCI USB:                    enabled
USB Device Filters:          <none>
Bandwidth groups:            <none>
Shared folders:

Name: 'Carpeta_host_VMware', Host path: 'C:\Users\desmon0xff\Desktop\files\Carpeta_host_VMware' (machine mapping), writable, auto-mount

Recording status:            stopped
Recording enabled:           no
Recording screens:           1
 Screen 0:
    Enabled:                 yes
    ID:                      0
    Record video:            yes
    Record audio:            no
    Destination:             File
    File:                    D:\VM's\Win10(64)\Win10(64)-screen0.webm
    Options:                 vc_enabled=true,ac_enabled=false,ac_profile=med
    Video dimensions:        1024x768
    Video rate:              512kbps
    Video FPS:               25fps
* Guest:
Configured memory balloon:   0MB
```