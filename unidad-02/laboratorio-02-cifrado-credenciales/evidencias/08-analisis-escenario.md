# Evidencia 8
## Considerar la situacion
Una empresa almacena los siguientes elementos:

nombre

correo electrónico

contraseña

RFC

información financiera

claves criptográficas

La base de datos utiliza usuarios y roles correctamente.

Sin embargo:

las contraseñas están almacenadas en texto claro

el RFC está almacenado en texto claro

las conexiones utilizan una configuración sin validación adecuada del servidor

las claves criptográficas aparecen en archivos SQL

los respaldos se almacenan sin protección adicional

## Pregunta 1. ¿Cuáles son los principales riesgos?

Robo de contraseñas, exposición de datos personales y financieros, robo de claves, interceptación de información y filtración de respaldos.

## Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?

- **Nombre y correo:** control de acceso.
- **Contraseña:** hash con `bcrypt` o `Argon2`.
- **RFC:** cifrado con `pgp_sym_encrypt()`.
- **Información financiera:** cifrado.
- **Claves criptográficas:** gestor de secretos.
- **Conexiones:** TLS con `verify-full`.
- **Respaldos:** cifrado y control de acceso.

## Pregunta 3. ¿Cuál de los problemas consideras más crítico y por qué?

La exposición de las claves criptográficas, porque podrían utilizarse para descifrar información confidencial.

## Pregunta 4. ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?

No. Los permisos limitan el acceso, pero también se necesitan contraseñas protegidas, cifrado de datos, conexiones seguras y respaldos protegidos.