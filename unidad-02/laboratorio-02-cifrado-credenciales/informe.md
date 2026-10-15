# Laboratorio 02 — Cifrado y credenciales

## 18. Verificación Final

**1. ¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves para contraseñas?**

Debe protegerse mediante un hash como `bcrypt` o `Argon2`, no mediante cifrado reversible.

**2. ¿Qué diferencia existe entre enmascaramiento, seudonimización y cifrado?**

El enmascaramiento oculta parte de los datos; la seudonimización sustituye datos identificables por otros valores; y el cifrado transforma los datos para que solo puedan leerse con la clave correcta.

**3. ¿Qué problema resuelve TLS?**

Protege la información que viaja por la red mediante cifrado y ayuda a verificar la identidad del servidor.

**4. ¿Dónde debería almacenarse una clave criptográfica en un entorno real?**

En un gestor de secretos o un sistema seguro de gestión de claves (KMS o HSM).

**5. ¿Es correcto subir una contraseña o clave real a GitLab aunque el repositorio sea privado?**

No, porque podría quedar expuesta a personas no autorizadas. Debe almacenarse en un gestor de secretos o en variables protegidas.

# 1. Introducción

En esta práctica se abordaron diferentes medidas de seguridad para proteger una base de datos PostgreSQL. El objetivo fue comprender cómo proteger las contraseñas, cifrar información sensible, verificar el uso de TLS y manejar correctamente las claves de cifrado.

# 2. Protección de credenciales

El texto claro es información que se puede leer directamente, por lo que no es recomendable almacenar contraseñas de esta manera. Un hash transforma una contraseña en un valor que no se puede recuperar directamente al original y se utiliza para verificarla. Por otro lado, el cifrado permite proteger la información y recuperarla utilizando una clave. En PostgreSQL se pueden utilizar funciones como `crypt()` para contraseñas y `pgp_sym_encrypt()` para cifrar datos.

# 3. Protección de datos sensibles

Se revisó la protección de información sensible mediante el cifrado. Este método permite evitar que personas no autorizadas puedan leer datos privados. También se identificó la importancia de proteger las contraseñas mediante hashes y no almacenarlas directamente en la base de datos.

# 4. TLS

TLS permite proteger la comunicación entre el cliente y el servidor, evitando que la información transmitida pueda ser leída fácilmente por terceros. En PostgreSQL se consultó la vista `pg_stat_ssl` para verificar el estado de la conexión. El resultado obtenido mostró que la sesión utilizada en pgAdmin tenía `ssl = false`, por lo que no estaba usando TLS. Se intentó realizar una conexión desde otra terminal, pero no fue posible establecerla debido a problemas de resolución del nombre del servidor y de conectividad.

# 5. Gestión de claves

Las claves de cifrado no deben almacenarse junto con los scripts porque una persona que obtenga acceso al código también podría obtener las claves y acceder a la información protegida. Lo recomendable es utilizar un gestor de secretos o un servicio especializado para almacenar las claves, limitar los permisos de acceso y renovarlas cuando sea necesario.

# 6. Resultados

Se identificaron diferentes mecanismos de protección para una base de datos PostgreSQL. Se comprendió la diferencia entre hashing y cifrado, se revisó el uso de funciones de `pgcrypto` y se consultó el estado TLS de la conexión. También se reconoció la importancia de separar las claves de cifrado del código fuente y de verificar que las conexiones estén protegidas.

# 7. Problemas encontrados

Durante la práctica se presentaron dificultades para conectarse desde una terminal al servidor PostgreSQL. Primero, el nombre del servidor no pudo resolverse y, posteriormente, la conexión mediante la dirección IP presentó un tiempo de espera agotado. Además, la consulta de `pg_stat_ssl` mostró que la conexión de pgAdmin no utilizaba TLS. Por ello, no se pudo confirmar una conexión TLS exitosa desde la terminal.

# 8. Conclusiones

Aprendí que la seguridad de una base de datos requiere varias medidas, como almacenar las contraseñas mediante hashes seguros, cifrar los datos sensibles, proteger las conexiones con TLS y mantener las claves fuera del código fuente. En un entorno productivo configuraría TLS con certificados válidos, utilizaría `sslmode=verify-full` en los clientes, administraría las claves mediante un gestor de secretos y limitaría los permisos de los usuarios. También realizaría pruebas de conexión y revisiones periódicas para detectar posibles problemas de seguridad.

# Preguntas de reflexión

**1. ¿Por qué una contraseña no debe almacenarse como texto claro?**

Porque cualquier persona que tenga acceso a la base de datos podría leer las contraseñas y utilizarlas para acceder a las cuentas de los usuarios.

**2. ¿Por qué un hash no es equivalente a un cifrado?**

Porque un hash es un proceso de una sola vía que permite verificar una contraseña, mientras que el cifrado permite recuperar la información original utilizando una clave.

**3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?**

Porque el cifrado protege la información, pero el control de acceso determina quién puede consultar o modificar los datos. Se necesitan ambos mecanismos para mejorar la seguridad.

**4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**

Porque TLS protege la información durante la comunicación entre el cliente y el servidor, mientras que la autorización controla qué acciones puede realizar cada usuario dentro de la base de datos.

**5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**

Podría perder el acceso a la información cifrada si no cuenta con una copia segura de la clave o un mecanismo de recuperación. Por eso es importante respaldar y administrar correctamente las claves.

**6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**

Una persona que obtenga la clave podría utilizarla para descifrar información protegida. Se debe considerar comprometida, revocarla o reemplazarla y revisar si hubo accesos no autorizados.

**7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**

Porque otras personas con acceso al repositorio podrían ver los secretos y estos pueden permanecer en el historial de Git aunque se eliminen del código actual. Es mejor utilizar un gestor de secretos.

**8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**

La información almacenada se protege mediante mecanismos como el cifrado de archivos, discos o columnas. La información transmitida se protege mediante protocolos como TLS, que cifran la comunicación entre sistemas.

**9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**

Porque, aunque se utilice un algoritmo seguro, una clave expuesta, perdida o mal administrada puede permitir el acceso a la información o impedir su recuperación.

**10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**

Implementaría el cifrado de los respaldos, el almacenamiento de las claves en un gestor de secretos, el acceso restringido y la conservación de copias en una ubicación separada. También realizaría pruebas periódicas para comprobar que los respaldos puedan restaurarse correctamente.


