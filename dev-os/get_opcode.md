# Obteniendo un opcode de una instrucion ASM.

Compilar el codigo con:
```batch bach
gcc -Wall get_opcode.c -o get_opcode.exe
```
Codigo: 
```C
[[include]] <stdio.h>
[[include]] <stdlib.h>
[[include]] <string.h>
[[include]] <sys/stat.h>

char *concatenacion(char *texto1, char *texto2)
{
    char *FinallyText = malloc((strlen(texto1) + strlen(texto2) + 1) * sizeof(char));
    for (register int i = 0; i <= strlen(texto1); i++)
    {
        FinallyText[i] = (char)texto1[i];
    }
    for (register int i = strlen(texto1); i <= strlen(texto1) + strlen(texto2); i++)
    {
        FinallyText[i] = texto2[i - strlen(texto1)];
    }

    return FinallyText;
}

[[define]] NAME_FILE_INPUT ".get_opcode.asm"
[[define]] NAME_FILE_OUTPUT ".get_opcode.bin"
[[define]] FORMAT "bin "


int main(int argc, char **argv){
    char * command = NULL;

    command = concatenacion("", "nasm -f ");

    char *_format = FORMAT;
    command = concatenacion(command, _format);
    // nasm -f _format nameFileInput -o nameFileOutput"
    char *nameFileInput = NAME_FILE_INPUT;
    command = concatenacion(command, nameFileInput);

    command = concatenacion(command, " -o ");

    char *nameFileOutput = NAME_FILE_OUTPUT;    
    command = concatenacion(command, nameFileOutput);

    printf("Comand: %s\n", command);
    printf("Code: %s\n", argv[1]);

    FILE *file = fopen(nameFileInput, "w");
    fprintf(file, argv[1]);
    fclose(file);

    system(command);
    free(command);
    command = NULL;

    file = fopen(nameFileOutput, "rb");
    if (!file)
    {
        perror("fopen");
        puts("Error, No se genero el archivo de salida!!!");
        exit(EXIT_FAILURE);
    }
    struct stat sb;
    if (stat((const char*)nameFileOutput, &sb) == -1)
    {
        perror("stat");
        exit(EXIT_FAILURE);
    }


    // reserva memoria dinamica para los datos del archivo
    unsigned char *file_contents = (unsigned char *)malloc(sb.st_size * sizeof(unsigned char));  
    // leer el archivo y almacenar su contenido en file_contents
    fread(file_contents, sb.st_size, 1, file); 
    unsigned char FinDelArchivo = sb.st_size;
    fclose(file);
    file = NULL;

    puts("Opcode generado: \n");
    for (unsigned char i = 0; i < FinDelArchivo; i++){
        printf(" 0x%x ", file_contents[i]);
    }
    puts("\n");

    free(file_contents);
    file_contents = NULL;

    system("del .get_opcode.bin");
    system("del .get_opcode.asm");

    return 0;
}
```
Para Windows:
```batch 
.\get_opcode.exe "xor al, al"
```
para Linux:
```bash
./get_opcode.exe "xor al, al"
```

El código no es nada del otro mundo, es algo hecho rápido y mejorable, pero cumple su función así que por ahora sirve.
El funcionamiento es sencillo, como entrada, recibe por parámetro la instrucción de `ensamblador x86`, lo escribe en un archivo llamado `.get_opcode.asm` y lo compila con `-f bin` generado como salida un archivo binario plano llamado `.get_opcode.bin`, al que accede por lectura binaria e imprime su contenido en formato hexadecimal.