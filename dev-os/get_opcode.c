/*
Options:
 -b, --one-byte-octal      one-byte octal display
 -c, --one-byte-char       one-byte character display
 -C, --canonical           canonical hex+ASCII display
 -d, --two-bytes-decimal   two-byte decimal display
 -o, --two-bytes-octal     two-byte octal display
 -x, --two-bytes-hex       two-byte hexadecimal display
 -L, --color[=<mode>]      interpret color formatting specifiers
                             colors are enabled by default
 -e, --format <format>     format string to be used for displaying data
 -f, --format-file <file>  file that contains format strings
 -n, --length <length>     interpret only length bytes of input
 -s, --skip <offset>       skip offset bytes from the beginning
 -v, --no-squeezing        output identical lines

 -h, --help                display this help
 -V, --version             display version

For more details see hexdump(1).*/

// gcc -Wall get_opcode.c -o get_opcode.exe
// .\get_opcode.exe "xor al, al"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

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

#define NAME_FILE_INPUT ".get_opcode.asm"
#define NAME_FILE_OUTPUT ".get_opcode.bin"
#define FORMAT "bin "


int main(int argc, char **argv){
    char * command = NULL;

    command = concatenacion("", "nasm -f ");

    char *_format = FORMAT;
    command = concatenacion(command, _format);
    //"nasm -f {} {} -o {}".format(_format, nameFileInput, nameFileOutput)
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