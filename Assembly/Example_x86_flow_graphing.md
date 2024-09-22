Seleccionar el codigo desde el que generar el diagrama, y usar el atajo `ctrl + alt + f` despues de crearlo para poder generar el grafico. 
![[1726494639918.canvas|1726494639918]]
```c
	cmp [ebp+var_8], 1
	jz loc_401027
	
	cmp [ebp+var_8], 2
	jz loc_40103D
	
	cmp [ebp+var_8], 3
	jz loc_401053
	
	jmp loc_401058
	
loc_401027
	Code for case 1
	jmp loc_401058
	
loc_40103D
	Code for case 2
	jmp loc_401058
	
loc_401053
	Code for case 3
	
loc_401058
	Program end
```