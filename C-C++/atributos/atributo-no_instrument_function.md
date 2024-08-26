`no_instrument_function`[](https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005finstrument_005ffunction-function-attribute)

Si se proporciona alguna de las funciones ``-finstrument-functions``, ``-p`` o ``-pg``, se generan llamadas a funciones de creación de perfiles en la entrada y salida de la mayoría de las funciones compiladas por el usuario. Las funciones con este atributo no están instrumentadas de esta manera.

revisa [[crear-instrumentos(-finstrument-functions)]]

### ¿Cuándo usar `no_instrument_function`?

- **Funciones críticas de bajo nivel**: Si tienes funciones que son llamadas muy frecuentemente, añadir instrumentación podría afectar el rendimiento.

- **Funciones de inicialización o desinicialización**: Estas funciones podrían ejecutarse antes o después de que los mecanismos de instrumentación estén completamente preparados, lo que podría causar errores si se instrumentan.

- **Funciones que interactúan directamente con el hardware**: Instrumentar estas funciones podría interferir con la comunicación directa con dispositivos.

Ejemplo:
```c
#include <stdio.h>
#include <unistd.h>  // Para usar write()
void __cyg_profile_func_enter(void *this_fn, void *call_site) __attribute__((no_instrument_function));
void __cyg_profile_func_exit(void *this_fn, void *call_site) __attribute__((no_instrument_function));

int foo()
{
    printf("Inside foo!\n");
}

int boo()
{
    printf("Inside boo!\n");
}


void __attribute__((no_instrument_function)) pointer_to_hex(char *buffer, void *ptr) {
    static const char hex_digits[] = "0123456789abcdef";
    uintptr_t value = (uintptr_t)ptr;
    for (int i = sizeof(void*) * 2 - 1; i >= 0; i--) {
        buffer[i] = hex_digits[value & 0xF];
        value >>= 4;
    }
    buffer[sizeof(void*) * 2] = '\0';
}

// Implementación de funciones de instrumentación sin printf ni snprintf
void __cyg_profile_func_enter(void *this_fn, void *call_site) {
    //printf("Function Entry : %p %p \n", this_fn, call_site);
    char buffer[128];
    char this_fn_hex[sizeof(void*) * 2 + 1];
    char call_site_hex[sizeof(void*) * 2 + 1];

    pointer_to_hex(this_fn_hex, this_fn);
    pointer_to_hex(call_site_hex, call_site);

    strcpy(buffer, "Function Entry : ");
    strcat(buffer, this_fn_hex);
    strcat(buffer, " ");
    strcat(buffer, call_site_hex);
    strcat(buffer, "\n");

    write(STDOUT_FILENO, buffer, strlen(buffer));
}

void __cyg_profile_func_exit(void *this_fn, void *call_site) {
    //printf("Function Exit : %p %p \n", this_fn, call_site);
    char buffer[128];
    char this_fn_hex[sizeof(void*) * 2 + 1];
    char call_site_hex[sizeof(void*) * 2 + 1];

    pointer_to_hex(this_fn_hex, this_fn);
    pointer_to_hex(call_site_hex, call_site);

    strcpy(buffer, "Function Exit : ");
    strcat(buffer, this_fn_hex);
    strcat(buffer, " ");
    strcat(buffer, call_site_hex);
    strcat(buffer, "\n");

    write(STDOUT_FILENO, buffer, strlen(buffer));
}


int main()
{
    foo();
    boo();
    return 0;
}
```
![[Pasted image 20240826023059.png]]
No se puede usar ``printf`` directamente en las funciones instrumento ``__cyg_profile_func_enter`` y ``__cyg_profile_func_exit`` pues en caso de hacerse, ``printf`` al llamar a la funciones instrumento generara un bucle infinito de llamadas entre ``printf-funciones instrumentos``  hasta acabar con la memoria y en una falla de segmentación:
![[Pasted image 20240826023539.png]]

Una vez se añade las funciones de instrumentación y se indica de forma global o local las funciones a instrumentalizar, todas las funciones compiladas mas no linkadas en run time, llamaran a las funciones instrumento:
![[Pasted image 20240826023132.png]]
