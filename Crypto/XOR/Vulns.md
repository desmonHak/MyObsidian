https://www.reddit.com/r/cryptography/comments/1f24anj/debating_about_xor_encryption/?tl=es-es

# Debatiendo sobre encriptación XOR

Estaba debatiendo con un amigo sobre la viabilidad de un algoritmo de encriptación basado en XOR.

Por lo que entiendo, la debilidad de este enfoque es la clave, que necesita ser extendida a la longitud del archivo.

La idea era extender la clave mediante un hash (o similar) y no mediante una simple repetición, ya que esto haría el análisis estadístico impracticable.

También se pueden implementar la sustitución y otros pasos básicos para hacer el algoritmo más seguro.

Mi pregunta es cuáles podrían ser los fallos de este enfoque, ya que no soy un experto en este campo (ni tampoco mi amigo).

Gracias de antemano



De lo que entiendo, la debilidad de tal enfoque es la clave, que necesita ser extendida a la longitud del archivo.  
La idea era extender la clave mediante un hash (o similar) y no por simple repetición, ya que esto haría el análisis estadístico impracticable.

Estás cerca de redescubrir [los cifrados de bloque](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation), que son usados por [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) y otros esquemas de encriptación. La operación XOR tiene algunas propiedades muy interesantes que la hacen invaluable para la encriptación moderna.

Así que, en respuesta a la pregunta de "¿es esto factible?" --- absolutamente. En términos de fallas, tienes que ser muy, muy cuidadoso con cómo extiendes tu clave.

Sí, y para continuar con esa idea, es asombroso lo cerca que se está de crear un PRNG cuando se construye para propósitos de extensión de claves. Tan cerca, de hecho, que necesito aprender qué separa un PRNG de un CSPRNG. ¿Pasar las pruebas Dieharder y NIST?

Pruebas/reducciones de seguridad y detalles de implementación como ser robusto ante la comprometimiento de todas menos una fuente de entropía. También cosas normales de criptografía de ingeniería como resistencia a canales laterales y velocidad.

> Tan cerca que necesito aprender qué separa un PRNG de un CSPRNG.

A menudo, poder recuperar el estado del RNG rápidamente al recibir el par (semilla, número actual de bits producidos) es una propiedad _deseable_ de un PRNG. Eso permite reproducir rápidamente los resultados de Montecarlo de un experimento para verificarlos, por ejemplo.

Para un CSPRNG, eso es un objetivo específico a evitar, por ejemplo, solo es bueno si hacer eso es básicamente imposible. El objetivo de un CSPRNG es hacer que sea lo más imposible posible recuperar su estado o su salida futura, incluso con grandes cantidades de su salida anterior. También debería poder convertir una "fuente de entropía de baja calidad" en una de alta calidad muy rápidamente.

Los PRNG a menudo quieren ser literalmente lo más rápidos posible, mientras pasan la mayor cantidad posible de pruebas locas. Los CSPRNG quieren ser extremadamente rápidos, pero no _demasiado_ rápidos; ser extremadamente rápido significa que el algoritmo es mucho más probable que sea simple o rastreable.

> También debería poder convertir una "fuente de entropía de baja calidad" en una de alta calidad muy rápidamente.

¿Un buen ejemplo de esto sería aceptar "contraseña" como entrada pero usar `SHA3_512("password")` como clave?

edit: Pregunto porque "entropía" es un tema complicado con mucha gente LOL

Relacionado pero diferente.

Un CSPRNG quiere recopilar datos variables (como el muestreo del comportamiento del sistema) repetidamente y mezclarlos en su reserva de entropía (material semilla). Usar la función de mezcla (hash o algoritmo dedicado de extracción de entropía) en las muestras le permite tomar datos estructurados sesgados (baja densidad de entropía) y le devuelve un valor con distribución uniforme (de apariencia aleatoria), ¡pero la salida no tendrá más entropía que la entrada! Y el CSPRNG quiere que la salida tenga una entropía superior a un mínimo. Es por esto que el CSPRNG sigue recopilando entradas hasta que estima que la aleatoriedad impredecible acumulada excede el umbral, típicamente ~128 bits de entropía estimada (no se puede crear entropía con matemáticas, se NECESITAN más muestras). Luego permite solicitar datos aleatorios, momento en el que copia y una vez más mezcla el contenido del grupo (a menudo usando un cifrado de flujo con el contenido del grupo como clave secreta - ¡un cifrado de flujo permite que sea rápido!) para darle un valor aleatorio, sin que sea posible saber qué hay en el grupo. Un CSPRNG necesita protegerse contra todo tipo de ataques, por lo que REALMENTE necesita ser aleatorio e irreversible impredecible.

Las contraseñas hash quieren protegerse contra las conjeturas, usando los hash para ocultar la contraseña. Normalmente también son algoritmos intencionadamente lentos (PBKDF2, Scrypt, Argon2 - esto "emula" la adición de más entropía a la contraseña, a través de la complejidad computacional), y también quieren un valor de entrada aleatorio adicional (sal) para asegurarse de que no se pueda ver qué usuarios tienen la misma contraseña (previene las tablas rainbow). Cuando se usa para la autenticación de contraseñas, realmente no importa si el hash parece aleatorio, solo que no se pueda revertir, por lo que muchos algoritmos le dan algo que parece $params$salt$hash. El usuario quiere suficiente entropía en su contraseña junto con suficiente ralentización del KDF para que los ataques sean imprácticos. Muchas contraseñas de ~40-60 bits usadas en servicios online están protegidas de esta manera porque adivinarlas es demasiado costoso, aunque el cifrado plano de 40 bits (como el antiguo WEP) es trivial de romper.

A veces también se quiere derivar claves de cifrado de una contraseña (función de derivación de claves, KDF, usando la contraseña como semilla / material clave) como para cifrar y desbloquear una base de datos de contraseñas, aquí es donde se quiere específicamente esa alta entropía en la salida que también quiere un CSPRNG (porque algunos algoritmos requieren aleatoriedad uniforme), Y la sal es absolutamente crítica en el uso de KDF para evitar la reutilización de claves.


Quizás te interese el modo CTR (contador). [Wikipedia](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_(CTR)).



Puedes tomar un cifrado de bloque, alimentarlo con una clave personalizada, y luego hacer que cifre

A0 = (1 + Nonce)  
A1 = (2 + A0)  
A2 = (3 + A1)

etc.

Considera la secuencia resultante de bloques cifrados como un flujo de bits y hazles una operación XOR con tu texto plano.

Y/o simplemente usa un cifrado de flujo ya hecho como ChaCha20. Está haciendo lo mismo a alto nivel: usar un proceso no reversible similar al hashing para generar un flujo de bits que luego se puede usar con XOR.



Creo que solo es seguro si puedes _garantizar_ que la clave no fue interceptada, ¿no es una variación del bloc de un solo uso en ese sentido?
¡Claro que sí! [Acabo de publicar eso](https://www.reddit.com/r/cryptography/comments/1f24anj/debating_about_xor_encryption/lk3u91f/?utm_source=share&utm_medium=ios_app&utm_name=iossmf&context=3) de hecho 😆


Hay un enorme inconveniente que nadie parece haber mencionado todavía: ¡no se puede **nunca** reutilizar la clave!

Dada la clave K y los textos sin cifrar M1, M2, si se genera M'1 = K xor M1, M'2 = K xor M2 y un atacante intercepta tanto M'1 como M'2, calcular M'1 xor M'2 te dirá mucho sobre los textos sin cifrar. Empeora a medida que se cifran más mensajes con la misma clave. [Esta publicación](https://crypto.stackexchange.com/a/108) proporciona un ejemplo visual muy claro de lo que sucede en la práctica.

Se pone aún peor cuando un atacante tiene tanto M1 como M'1 (¡o puede hacer una conjetura fundamentada de _partes de_ M1!) e intenta descifrar M'2. La clave se recupera trivialmente mediante K = M1 xor M'1, y luego es solo cuestión de M2 = M'2 xor K.




Tú y muchos comentarios aluden a esto, pero para que quede claro cuál es el peligro: no se trata solo de análisis estadístico.

Si tu clave se reutiliza alguna vez, y el atacante descubre el texto plano, puede hacer una operación XOR entre el texto plano y el texto cifrado para recuperar la clave y descifrar otros mensajes donde se haya usado esa clave.

También debes asegurarte de que tu KDF/PRNG sea sólido, porque si se conocen partes de tu mensaje y tu PRNG es predecible, la recuperación de parte de tu clave puede permitir la regeneración del resto.

Hay otros problemas con el "simple XOR" como cifrado, pero ese es uno de los grandes y la razón principal por la que nunca debes reutilizar la clave, y por qué el tamaño de tu clave debe coincidir con el tamaño del mensaje.


i'm really curious who invented this term "xor encryption". it comes up a lot, and it bothers me greatly. xor is a lot of things, but not encryption. whatever scheme you come up with, xor will never be the source of privacy. what some people call "xor encryption" is either an otp or a stream cipher. in both cases, the xor is not essential, and can be easily replaced by other operations, e.g. + mod 2n.


El único cifrado perfecto es el bloc de un solo uso, también conocido como cifrado XOR con una clave **aleatoria** del mismo tamaño que el texto plano. XOR es probablemente el operador binario reversible más sencillo y conocido para el cálculo.

¿Quién lo llama "cifrado XOR" y por qué?

[Simplemente muchísima gente en general](https://en.wikipedia.org/wiki/XOR_cipher)? Es una técnica muy básica



Este algoritmo se llama "one time pad". Tu clave tiene que ser perfectamente aleatoria y nunca reutilizarse (la parte importante). Si es así, podrías proporcionar secreto de información teórica, lo que significa un cifrado perfecto.

Sobre extender la clave usando un algoritmo hash, perderías entropía.


Me encanta el enfoque y ya he construido algo parecido. Creo que el enfoque se acerca lo más posible a una libreta de un solo uso (OTP). Obviamente, el mecanismo de extensión de tu clave no puede contener repeticiones, como has dicho.

En cuanto a tu pregunta sobre fallas, necesitarás evitar los "ataques de texto plano conocido" (KPA). Aquí es donde Oscar adivina que has encriptado un PDF (por ejemplo) y, dado que se conocen los primeros bytes del encabezado del archivo de los PDF, puede aprovechar esto para encontrar la clave. A menudo se utilizan procesos simples de "calentamiento" para evitar los KPA.

Otra característica divertida de XOR es que cuando tienes un texto plano que contiene todos ceros (p0). Cuando haces (p0 xor clave) ¡obtienes la clave! Así que mantente muy cerca de las reglas de OTP, que establecen que nunca se debe reutilizar una clave, y estarás bien. ¡Buena suerte!


  

PRO: Funciona. Es simple. Se ejecuta muy rápido.

CON: Si alguien sabe o descubre lo que estás haciendo, no sería tan difícil decodificar todo lo que codificas, a menos que tengas claves que cambian constantemente.



Supongo que cambiar constantemente la clave sería el camino a seguir, pero ¿no se podría lograr también con salting?

A modo de ejemplo, aquí hay una posible implementación escrita en pseudocódigo.

Sea M_n el nésimo bloque del mensaje.

Sea S la sal, que puede ser secreta o añadirse al propio mensaje.

Sea H_n el nésimo bloque que se XOReará con el mensaje.

Sea C_n el nésimo bloque del mensaje cifrado.

H_1 = hash(contraseña + S)

C_1 = M_1 XOR H_1

H_2 = hash(contraseña + S + C_1)

C_2 = M_2 XOR H_2

En general, continuamos así:

C_n = M_n XOR H_n-1

Con H_n-1 = hash(contraseña + S + C_n-2) para n > 2



O S podría ser un número basado en la codificación de milisegundos que comenzó (más/menos) basado en el byte yésimo del mensaje. Y/o puedes hacer lo que los soviéticos solían hacer en algunos de sus códigos: reorganizar los bloques de datos en el mensaje y codificar al menos uno de ellos de manera diferente.



"entropía de salida ≯ entropía de entrada, base de [aleatoriedad de Kolmogorov](http://www.reallyreallyrandom.com/www/kolmogorov-randomness.pdf) " - Consulta mi pregunta aquí: [https://crypto.stackexchange.com/questions/106932/xor-for-more-trng-data](https://crypto.stackexchange.com/questions/106932/xor-for-more-trng-data)


Claro... Incluso puedes usar algo como PBKDF2 para generar una clave más larga a partir de una contraseña más corta para contrarrestar.

Quiero decir, hay enfoques más simples y más complejos.