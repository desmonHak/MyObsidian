
Cambiar ``"<VM name>"`` por el nombre de la maquina vitual en la que sustituir el nombre de la ``CPU``. vea [[Listar_maquinas_vm]] para poder ver que maquinas puede mofidicar.
```c
VBoxManage modifyvm "<VM name>" --cpu-profile "Intel Xeon X5482 3.20GHz"  
VBoxManage modifyvm "<VM name>" --cpu-profile "Intel Core i7-2635QM"  
VBoxManage modifyvm "<VM name>" --cpu-profile "Intel Core i7-3960X"  
VBoxManage modifyvm "<VM name>" --cpu-profile "Intel Core i5-3570"  
VBoxManage modifyvm "<VM name>" --cpu-profile "Intel Core i7-5600U"  
VBoxManage modifyvm "<VM name>" --cpu-profile "Intel Core i7-6700K"
```