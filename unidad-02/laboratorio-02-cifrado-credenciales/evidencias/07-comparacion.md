# Evidencia 7
## Completar la tabla

| **Situación**                                 | **Mecanismo apropiado**              | **¿Qué protege?** |
| --------------------------------------------- | ------------------------------------ | ----------------- |
| Contraseña de usuario                         | Hash con `bcrypt` y salt             | Protege las contraseñas evitando almacenarlas en texto plano. |
| RFC almacenado en una tabla                   | Cifrado simétrico con `pgp_sym_encrypt()` | Protege la confidencialidad del RFC almacenado. |
| Consulta enviada desde un cliente al servidor | TLS mediante `sslmode=verify-full`   | Protege los datos durante la transmisión y verifica la identidad del servidor. |
| Respaldo de una base de datos                 | Cifrado del archivo de respaldo      | Evita que personas no autorizadas lean los datos del respaldo. |
| Clave criptográfica                           | Gestor de secretos o módulo de seguridad (KMS/HSM) | Protege la clave contra accesos y divulgaciones no autorizados. |