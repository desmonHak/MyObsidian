// gcc -ffreestanding -c basic.c -o basic.o
// objdump -d basic.o
//secto MBR -> ld -o basic.bin -Ttext 0x0 --oformat binary basic.o

// ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary
/*
Note that, now, we tell the linker that the origin of our code once we load it into
memory will be 0x1000, so it knows to offset local address references from this origin,
just like we use [org 0x7c00] in our boot sector, because that is where BIOS loads and
then begins to exectute it.
*/


void main () {
    // Create a pointer to a char , and point it to the first text cell of
    // video memory (i.e. the top - left of the screen )
    char * video_memory = ( char *) 0xb8000 ;
    // At the address pointed to by video_memory , store the character ’X’
    // (i.e. display ’X’ in the top - left of the screen ).
    *video_memory = 'X';
}
