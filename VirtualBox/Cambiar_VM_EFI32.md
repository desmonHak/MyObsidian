https://github.com/ranma42/TigerOnVBox/blob/master/Explanation.md
Mac OS X 10.4 solo puede arrancar desde un [[EFI]] de ``32 bits``. Por este motivo, si la máquina virtual está configurada como Versión: Mac OS X (``64 bits``), su cargador de arranque debe configurarse como de ``32 bits`` con el comando:
```c
VBoxManage modifyvm Tiger --firmware efi32
```