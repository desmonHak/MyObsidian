FILE_INPUT=boot.asm
FILE_OUTPUT=code.bin
FORMAT=bin
NASM=nasm
HEXDUMP=hexdump

boot: boot.asm
	@cls
	$(NASM) -f $(FORMAT) $< -o $(FILE_OUTPUT)
	$(HEXDUMP) $(FILE_OUTPUT)