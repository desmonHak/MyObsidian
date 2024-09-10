### Interpretación de tus resultados:

Vea tambien [[sched_setaffinity - Establecer y obtener mascara de afinidad de un subproceso]], [[lscpu]], [[time]]
- **./afinidad.elf 0 1 100000000:**
    - `6,33s user`, `6,34s system`, `199% cpu`, `6,337 total`
    - Utilizó aproximadamente 6.33 segundos de CPU en modo usuario, 6.34 segundos en modo kernel, y dado que el uso de CPU fue del 199%, significa que utilizó más de un núcleo de CPU. El tiempo total fue de 6.337 segundos.

- **./afinidad.elf 0 0 100000000:**
    - `5,28s user`, `5,72s system`, `99% cpu`, `11,005 total`
    - En este caso, aunque el tiempo en modo usuario y sistema es similar, el porcentaje de uso de CPU es solo del 99%, lo que significa que utilizó un solo núcleo, lo que resultó en un tiempo total mucho mayor (11 segundos).

- **./afinidad.elf 0 2 100000000:**
    - `5,33s user`, `5,55s system`, `199% cpu`, `5,450 total`
    - Nuevamente, utilizó múltiples núcleos (199% CPU), lo que redujo el tiempo total de ejecución a 5.45 segundos.

- **./afinidad.elf 0 8 100000000:**
    - `5,31s user`, `5,62s system`, `199% cpu`, `5,465 total`
    - Similar al caso anterior, usó múltiples núcleos, y el tiempo total fue similar (5.465 segundos).