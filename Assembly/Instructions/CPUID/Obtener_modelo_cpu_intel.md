Datos de ejemplos de dumpeado de [[CPUID]]:
http://instlatx64.atw.hu

Familias de CPU's en Intel:
[[Family_3]]
[[Family_4]]
[[Family_5]]
[[Family_6]]
[[Family_11]]
[[Family_15]]

Según Intel:
```c
if (Family_ID == 0x06) || (Family_ID == 0x0f) then
	Model_number = ((Extended_Model_ID << 4) + Model_ID)
else
	Model_number = Model_ID
```

```c
[[define]] get_model_number(Family_ID, Model_ID, Extended_Model_ID) ((Family_ID == 0x06) || (Family_ID == 0x0f)) ? ((Extended_Model_ID << 4) + Model_ID) : Model_ID
```

`Family_ID`, `Model_ID`, `Extended_Model_ID` se obtiene en la pagina numero 1 de la instrucción `cpuid` [[CPUID(1)]].

Tipos de microarquitecturas en Intel:
```c
typedef enum micro_arch {
    // Family 15
    Netburst,

    // Family 11
    Knights_Ferry,
    Knights_Corner,

    // Big Cores (Client) (Family 6)
    Meteor_Lake,
    Raptor_Lake,
    Alder_Lake,
    Rocket_Lake,
    Tiger_Lake,
    CLIENT_arch(Ice_Lake),
    Comet_Lake,
    Amber_Lake,
    Whiskey_Lake,
    Cannon_Lake,
    Coffee_Lake,
    Kaby_Lake,
    CLIENT_arch(Skylake),
    CLIENT_arch(Broadwell),
    CLIENT_arch(Haswell),
    CLIENT_arch(Sandy_Bridge),
    CLIENT_arch(Westmere),
    CLIENT_arch(Nehalem),
    CLIENT_arch(Penryn),
    CLIENT_arch(Core),
    Modified_Pentium_M,
    Pentium_M,
    CLIENT_arch(P6),

    // Big Cores (Server) (Family 6)
    Diamond_Rapids,
    Granite_Rapids,
    Emerald_Rapids,
    Sapphire_Rapids,
    SERVER_arch(Ice_Lake),
    Cooper_Lake,
    Cascade_Lake,
    SERVER_arch(Skylake),
    SERVER_arch(Broadwell),
    SERVER_arch(Haswell),
    SERVER_arch(Sandy_Bridge),
    SERVER_arch(Westmere),
    SERVER_arch(Nehalem),
    SERVER_arch(Penryn),
    SERVER_arch(P6),

    // Small Cores (Family 6)
    Tremont,
    Goldmont_Plus,
    Goldmont,
    Airmont,
    Silvermont,
    Saltwell,
    Bonnell,

    // MIC Architecture (Family 6)
    Knights_Mill,
    Knights_Landing,

    // Family 5
    Lakemont,
    P5,

    // Family 4
    i80486,

    // Family 3
    i80386
} micro_arch;
```

Hay microarquitecturas que tienen variantes para servidores y otras para cliente, por ejemplo la arquitectura ``Ice_Lake`` tiene una variante para servidor y otra para servidores. En este caso se usa las macros `CLIENT_arch()` y `SERVER_arch()` para expandir el nombre de la arquitectura a identificadores únicos añadiendo `_s` para las micro arquitecturas para servidores y añadiendo `_c` para microarquitecturas de clientes. 
`CLIENT_arch(Skylake)` == `Skylake_c` y `SERVER_arch(Skylake)` == `Skylake_s.
    ``Netburst`` vea [[Netburst]]
    ``Knights_Ferry`` vea [[Knights_Ferry]]
    ``Knights_Corner`` vea [[Knights_Corner]]
    ``Meteor_Lake`` vea [[Meteor_Lake]]
    ``Raptor_Lake`` vea [[Raptor_Lake]]
    ``Alder_Lake`` vea [[Alder_Lake]]
    ``Rocket_Lake`` vea [[Rocket_Lake]]
    ``Tiger_Lake`` vea [[Tiger_Lake]]
    ``Comet_Lake`` vea [[Comet_Lake]]
    ``Amber_Lake`` vea [[Amber_Lake]]
    ``Whiskey_Lake`` vea [[Whiskey_Lake]]
    ``Cannon_Lake`` vea [[Cannon_Lake]]
    ``Coffee_Lake`` vea [[Coffee_Lake]]
    ``Kaby_Lake`` vea [[Kaby_Lake]]
    ``CLIENT_arch(Ice_Lake) == Ice_Lake_c`` vea [[Ice_Lake(Client)]] 
    ``CLIENT_arch(Skylake) == Skylake_c`` vea [[Skylake(Client)]]
    ``CLIENT_arch(Broadwell) == Broadwell_c`` vea [[Broadwell(Client)]]
    ``CLIENT_arch(Haswell) == Haswell_c`` vea [[Haswell(Client)]]
    ``CLIENT_arch(Sandy_Bridge) == Sandy_Bridge_c`` vea [[Sandy_Bridge(Client)]]
    ``CLIENT_arch(Westmere) == Westmere_c`` vea [[Westmere(Client)]]
    ``CLIENT_arch(Nehalem) == Nehalem_c`` vea [[Nehalem(Client)]]
    ``CLIENT_arch(Penryn) == Penryn_c`` vea [[Penryn(Client)]]
    ``CLIENT_arch(Core) == Core_c`` vea [[Core(Client)]]
    ``CLIENT_arch(P6) == P6_c`` vea [[P6(Client)]]
    ``SERVER_arch(Ice_Lake) == Ice_Lake_s`` vea [[Ice_Lake(Server)]]
    ``SERVER_arch(Skylake) == Skylake_s`` vea [[Skylake(Server)]]
    ``SERVER_arch(Broadwell) == Broadwell_s`` vea [[Broadwell(Server)]]
    ``SERVER_arch(Haswell) == Haswell_s`` vea [[Haswell(Server)]]
    ``SERVER_arch(Sandy_Bridge) == Sandy_Bridge_s`` vea [[Sandy_Bridge(Server)]]
    ``SERVER_arch(Westmere) == Westmere_s`` vea [[Westmere(Server)]]
    ``SERVER_arch(Nehalem) == Nehalem_s`` vea [[Nehalem(Server)]]
    ``SERVER_arch(Penryn) == Penryn_s`` vea [[Penryn(Server)]]
    ``SERVER_arch(P6) == P6_s`` vea [[P6(Server)]]
    ``Modified_Pentium_M`` vea [[Modified_Pentium_M]]
    ``Pentium_M`` vea [[Pentium_M]]
    ``Diamond_Rapids`` vea [[Diamond_Rapids]]
    ``Granite_Rapids`` vea [[Granite_Rapids]]
    ``Emerald_Rapids`` vea [[Emerald_Rapids]]
    ``Sapphire_Rapids`` vea [[Sapphire_Rapids]]
    ``Cooper_Lake`` vea [[Cooper_Lake]]
    ``Cascade_Lake`` vea [[Cascade_Lake]]
    ``Tremont`` vea [[Tremont]]
    ``Goldmont_Plus`` vea [[Goldmont_Plus]]
    ``Goldmont`` vea [[Goldmont]]
    ``Airmont`` vea [[Airmont]]
    ``Silvermont`` vea [[Silvermont]]
    ``Saltwell`` vea [[Saltwell]]
    ``Bonnell`` vea [[Bonnell]]
    ``Knights_Mill`` vea [[Knights_Mill]]
    ``Knights_Landing`` vea [[Knights_Landing]]
    ``Lakemont`` vea [[Lakemont]]
    ``P5`` vea [[P5]]
    ``i80486`` vea [[i80486]]
    ``i80386`` vea [[i80386]]

Con la siguiente macro se definirá un array con los string's de las distintas arquitecturas:
```c
[[define]] string_arch(name) [[name]]
```
Ejemplo: ``string_arch(hola)`` == ``"hola"``

Definición del array:
```c
static char* micro_arch_strings[] = {
    string_arch(Netburst),
    string_arch(Knights_Ferry),
    string_arch(Knights_Corner),
    string_arch(Meteor_Lake),
    string_arch(Raptor_Lake),
    string_arch(Alder_Lake),
    string_arch(Rocket_Lake),
    string_arch(Tiger_Lake),
    string_arch(Ice_Lake_c),
    string_arch(Comet_Lake),
    string_arch(Amber_Lake),
    string_arch(Whiskey_Lake),
    string_arch(Cannon_Lake),
    string_arch(Coffee_Lake),
    string_arch(Kaby_Lake),
    string_arch(Skylake_c),
    string_arch(Broadwell_c),
    string_arch(Haswell_c),
    string_arch(Sandy_Bridge_c),
    string_arch(Westmere_c),
    string_arch(Nehalem_c),
    string_arch(Penryn_c),
    string_arch(Core_c),
    string_arch(Modified_Pentium_M),
    string_arch(Pentium_M),
    string_arch(P6_c),
    string_arch(Diamond_Rapids),
    string_arch(Granite_Rapids),
    string_arch(Emerald_Rapids),
    string_arch(Sapphire_Rapids),
    string_arch(Ice_Lake_c),
    string_arch(Cooper_Lake),
    string_arch(Cascade_Lake),
    string_arch(Skylake_s),
    string_arch(Broadwell_s),
    string_arch(Haswell_s),
    string_arch(Sandy_Bridge_s),
    string_arch(Westmere_s),
    string_arch(Nehalem_s),
    string_arch(Penryn_s),
    string_arch(P6_s),
    string_arch(Tremont),
    string_arch(Goldmont_Plus),
    string_arch(Goldmont),
    string_arch(Airmont),
    string_arch(Silvermont),
    string_arch(Saltwell),
    string_arch(Bonnell),
    string_arch(Knights_Mill),
    string_arch(Knights_Landing),
    string_arch(Lakemont),
    string_arch(P5),
    string_arch(i80486),
    string_arch(i80386),

    "Not Defined"
};
```

El string `"Not Defined"` se usa para indicar que la microarquitectura que se esta solicitando no se define en el array, la función `get_micro_arch_strings` es la que dará el string acorde a la microarquitectura introducida:
```c
char* get_micro_arch_strings(micro_arch this_arch) {
    if (this_arch < i80386) return micro_arch_strings[this_arch];
    else return micro_arch_strings[i80386+1];
}
```

La siguiente estructura se usa para definir el modelo de ``CPU`` de forma redundante:
```c
typedef struct cpu_model {
    uint32_t arch;
    uint8_t  core;

    uint8_t  extended_model:4;
    uint8_t           model:4;

    uint8_t extended_family:4;
    uint8_t          family:4;
} cpu_model;
```
- ``arch`` (microarquitectura), se a de indicar valores del ``enum`` `micro_arch`, se uso un campo de `32bits` por que existe al parecer modelos de CPU's que tienen distintas microarquitecturas pero se rigen bajo el mismo modelo, modelo extendido y familia. 

	Por ejemplo, el modelo 142 de la [[Family_6]] (``Family 6 Model 142``) Existe en 3's microarquitecturas distintas, [[Comet_Lake]], [[Amber_Lake]] y [[Whiskey_Lake]]:
```c
{ // Comet Lake && Amber Lake && Whiskey Lake
        .arch = Comet_Lake << 16 | Amber_Lake << 8 | Whiskey_Lake , 
        .core = 0,  /*
                     * IF (Comet Lake)   THEN Core = U
                     * IF (Amber Lake)   THEN Core = Y
                     * IF (Whiskey Lake) THEN Core = U
                     */

        .extended_model  = 0x8,
        .model           = 0xe,

        .extended_family = 0x0,
        .family          = 0x6
        // 		Family 6 Model 142
    },
```
En este caso se incluyo las crees microarquitecturas en el mismo modeló, ocupando [[Comet_Lake]] el ``3 byte``,  [[Amber_Lake]] ocupando el ``byte 2``, y [[Whiskey_Lake]] el ``byte 1``