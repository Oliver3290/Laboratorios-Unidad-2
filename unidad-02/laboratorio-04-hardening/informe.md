# Laboratorio 04 — Hardening
# 25.Actividad 19 — Construcción de una línea base

## Baseline de seguridad para PostgreSQL 16

La siguiente propuesta establece las medidas que deberían aplicarse para mejorar la seguridad de un servidor PostgreSQL 16. Los cambios deben realizarse de manera controlada, considerando los permisos disponibles, los servicios que dependen de la base de datos y la continuidad del sistema.

### 1. Red

- **Interfaces autorizadas:** configurar `listen_addresses` para escuchar únicamente en las interfaces que necesiten recibir conexiones. Evitar el uso de `'*'` cuando no sea necesario.
- **Puerto:** utilizar el puerto 5432, salvo que exista una razón documentada para cambiarlo.
- **Firewall:** permitir conexiones únicamente desde los equipos y redes autorizados.
- **Redes permitidas:** definir las direcciones IP o subredes que realmente necesiten acceder al servidor. Evitar accesos generales desde cualquier origen.

### 2. Autenticación

- **Método:** utilizar `scram-sha-256` para las nuevas credenciales, siempre que los clientes sean compatibles.
- **Políticas de credenciales:** utilizar contraseñas largas, únicas y difíciles de adivinar. Evitar compartir credenciales entre usuarios y cambiarlas cuando exista sospecha de exposición.
- **Cuentas administrativas:** limitar las cuentas administrativas a las personas que realmente necesiten esos privilegios. No utilizar cuentas de administración para las operaciones normales de una aplicación.

### 3. Autorización

- **Roles:** crear roles de acuerdo con las funciones de cada usuario, por ejemplo, administración, aplicación y consulta.
- **Privilegios:** aplicar el principio de mínimo privilegio, otorgando únicamente los permisos necesarios para cada actividad.
- **Cuentas de aplicación:** utilizar una cuenta exclusiva para cada aplicación, con permisos limitados a las tablas y operaciones que necesite. No otorgarle `SUPERUSER`.

### 4. Configuración

- **Parámetros relevantes:** revisar `listen_addresses`, `port`, `password_encryption`, `ssl`, `statement_timeout` e `idle_in_transaction_session_timeout`.
- **Extensiones:** mantener únicamente las extensiones necesarias y autorizadas para el funcionamiento del sistema.
- **Conexiones:** establecer límites adecuados mediante `max_connections` y revisar las conexiones abiertas para evitar consumos innecesarios de recursos.

### 5. Sistema operativo

- **Propietario de archivos:** los archivos de PostgreSQL deben pertenecer a la cuenta de servicio autorizada para administrar el motor.
- **Permisos:** restringir la lectura, escritura y ejecución de los archivos de configuración, credenciales y datos a los usuarios que realmente los necesiten.
- **Protección del directorio de datos:** impedir que usuarios no autorizados del sistema operativo puedan leer o modificar el directorio de datos. Los permisos deben comprobarse en el sistema operativo, no solamente mediante los privilegios de PostgreSQL.

### 6. Cifrado

- **TLS:** habilitar y configurar TLS para proteger las conexiones remotas, utilizando certificados válidos y verificando la identidad del servidor cuando corresponda.
- **Protección de credenciales:** almacenar las contraseñas mediante algoritmos de hash seguros, como SCRAM, y evitar guardarlas en texto plano.
- **Protección de información sensible:** limitar el acceso a los datos sensibles y, cuando sea necesario, utilizar cifrado para protegerlos. Las claves deben almacenarse y administrarse de forma segura.

### 7. Mantenimiento

- **Actualización:** mantener PostgreSQL y el sistema operativo actualizados mediante un proceso controlado, con respaldos y pruebas previas cuando corresponda.
- **Revisión periódica:** revisar usuarios, roles, privilegios, reglas de acceso, conexiones, extensiones, registros y configuración de seguridad.
- **Documentación:** registrar la configuración aprobada, los cambios realizados, las personas responsables y las evidencias de las revisiones.

Esta línea base es una propuesta de seguridad. No significa que todos estos controles ya estén configurados en el servidor revisado.

---

# Informe

## 1. ¿Cuál era la principal superficie de ataque?

La principal superficie de ataque estaba relacionada con los puntos mediante los cuales se podía acceder al servidor PostgreSQL, como las interfaces de red, el puerto de conexión, las reglas de autenticación y las cuentas con acceso. Estos elementos determinan desde dónde se puede intentar una conexión y qué controles se aplican para permitirla.

## 2. ¿Qué configuración representaba el mayor riesgo?

La configuración que representaba un riesgo importante era `listen_addresses='*'`, porque permite que PostgreSQL escuche en todas las interfaces disponibles. Si además existieran reglas de acceso demasiado permisivas o un firewall abierto, aumentaría la exposición del servicio.

En la revisión realizada, el valor observado de `listen_addresses` fue `*`. Sin embargo, para determinar el riesgo real también deben revisarse el firewall, las reglas de `pg_hba.conf` y las redes desde las que se puede acceder.

## 3. ¿Qué cambio produjo la mayor reducción de exposición?

Una medida de alto impacto sería limitar las interfaces de escucha y permitir conexiones únicamente desde las redes necesarias, junto con reglas restrictivas en el firewall y `pg_hba.conf`. Esto reduce la cantidad de equipos que pueden intentar conectarse al servidor.

No se puede afirmar que este cambio ya se haya aplicado ni medir su reducción real sin evidencia de la configuración anterior y posterior.

## 4. ¿Qué diferencia existe entre firewall y `pg_hba.conf`?

El firewall controla el tráfico de red que puede llegar al servidor, por ejemplo, permitiendo conexiones al puerto 5432 únicamente desde una subred autorizada.

Por su parte, `pg_hba.conf` determina qué conexiones a PostgreSQL se permiten según el tipo de conexión, la base de datos, el usuario, la dirección de origen y el método de autenticación.

Ambos controles se complementan: el firewall limita el acceso a la red y `pg_hba.conf` establece las condiciones de acceso al motor de base de datos.

## 5. ¿Qué diferencia existe entre autenticación y autorización?

La autenticación permite comprobar la identidad de quien intenta conectarse. Por ejemplo, PostgreSQL puede verificar las credenciales de un usuario.

La autorización determina qué acciones puede realizar ese usuario después de conectarse, como consultar tablas, insertar registros o modificar información.

Por lo tanto, comprobar la identidad de un usuario no significa que deba tener acceso a todos los datos o funciones del sistema.

## 6. ¿Por qué una cuenta de aplicación no debe ser `SUPERUSER`?

Porque una cuenta con `SUPERUSER` tiene privilegios administrativos muy amplios. Si una aplicación sufre una vulnerabilidad o sus credenciales son robadas, un atacante podría aprovechar esos privilegios para realizar cambios graves en la base de datos.

La aplicación debe utilizar una cuenta con permisos limitados a las operaciones que necesita. Así se reduce el impacto de posibles errores o ataques.

## 7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?

Cambiar el puerto puede dificultar algunos intentos automatizados que buscan el puerto predeterminado, pero no elimina las vulnerabilidades ni sustituye los controles de seguridad.

Un atacante puede descubrir el puerto mediante otras técnicas. Por eso es más importante restringir el acceso por red, configurar correctamente la autenticación, limitar los privilegios y mantener el servidor actualizado.

## 8. ¿Por qué `listen_addresses='*'` puede ser innecesario?

Porque hace que PostgreSQL escuche en todas las interfaces disponibles, aunque algunas no necesiten aceptar conexiones de base de datos.

Si el servidor solo debe recibir conexiones desde una interfaz privada, escuchar en todas las interfaces aumenta innecesariamente su exposición. La configuración debe ajustarse a la arquitectura real del sistema y a las conexiones que requiere.

## 9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?

El sistema operativo protege los archivos, el directorio de datos, las configuraciones, los certificados y otros recursos del servidor. También controla qué usuarios pueden leer, modificar o ejecutar archivos.

Aunque PostgreSQL tenga usuarios y permisos bien configurados, una cuenta del sistema operativo con acceso directo a los archivos podría comprometer la información. Por eso, la seguridad de la base de datos depende también de los permisos y controles del sistema operativo.

## 10. ¿Qué controles deberían revisarse periódicamente?

Se deberían revisar los siguientes controles:

- Interfaces de escucha y puerto de PostgreSQL.
- Reglas del firewall y de `pg_hba.conf`.
- Métodos de autenticación y políticas de contraseñas.
- Usuarios, roles, privilegios y cuentas administrativas.
- Privilegios asignados a las cuentas de aplicación.
- Estado de TLS y protección de las conexiones.
- Permisos del directorio de datos y de los archivos de configuración.
- Extensiones instaladas y su necesidad.
- Número de conexiones, conexiones inactivas y límites configurados.
- Registros de actividad y errores de autenticación.
- Actualizaciones de PostgreSQL y del sistema operativo.
- Respaldos y procedimientos de recuperación.
- Documentación de cambios y resultados de las revisiones.

Estas revisiones ayudan a detectar configuraciones inseguras, cuentas innecesarias y cambios que puedan aumentar el riesgo.

---

# 31. Reflexión

Si recibiera la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción, primero revisaría su exposición de red y las reglas que permiten el acceso. Antes de cambiar la configuración, identificaría qué aplicaciones y usuarios dependen del servidor, qué conexiones necesitan y qué impacto podría tener una modificación.

Elegiría esta revisión como primera prioridad porque permite identificar si el servicio está accesible desde redes que no deberían utilizarlo. Por ejemplo, si PostgreSQL escucha en todas las interfaces y acepta conexiones desde redes demasiado amplias, podría estar expuesto a intentos de acceso innecesarios.

Después de identificar las conexiones legítimas, propondría restringir las interfaces, las redes permitidas y las reglas del firewall y `pg_hba.conf`. Haría los cambios de manera gradual, con autorización, respaldos y pruebas previas, para no interrumpir las aplicaciones que utilizan la base de datos.

También revisaría las cuentas administrativas y de aplicación. Las contraseñas seguras son importantes, pero no son suficientes si una cuenta tiene privilegios excesivos. Cada usuario debe contar únicamente con los permisos que necesita, y las cuentas de aplicación no deben tener `SUPERUSER`.

En cuanto a la autenticación, verificaría que se utilicen métodos seguros y que las credenciales estén protegidas. También comprobaría el cifrado de las conexiones remotas mediante TLS y los permisos del sistema operativo sobre los archivos y el directorio de datos.

Consideraría la disponibilidad y la continuidad como parte de todo el proceso. Un cambio de seguridad mal aplicado puede impedir que una aplicación se conecte o afectar las operaciones normales. Por eso, documentaría la configuración inicial, realizaría pruebas, conservaría un plan de reversión y verificaría que las conexiones autorizadas sigan funcionando.

En conclusión, comenzaría por evaluar y reducir la exposición de red porque permite identificar quién puede intentar acceder al servidor y ayuda a priorizar los riesgos. Después fortalecería la autenticación, los privilegios, el cifrado, los permisos del sistema operativo y el mantenimiento. De esta manera, la seguridad mejoraría sin poner innecesariamente en riesgo la disponibilidad y la continuidad del servicio.
