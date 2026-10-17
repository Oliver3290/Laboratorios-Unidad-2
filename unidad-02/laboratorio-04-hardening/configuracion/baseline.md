# Baseline de seguridad para PostgreSQL 16

## Propósito

Esta línea base reúne los controles que se deben revisar para reducir la exposición de PostgreSQL. Distingue los resultados observados durante el laboratorio de las medidas propuestas. Las recomendaciones son conceptuales: no se modificó la configuración del servidor institucional.

## 1. Actividad 1 — Identificar la superficie de ataque

| Elemento | Estado actual observado | ¿Es necesario? | Riesgo o análisis |
|---|---|---|---|
| Puerto PostgreSQL | `5432` | Sí, si es el puerto usado por el servicio | Si está accesible desde redes que no lo necesitan, aumenta la superficie de ataque. |
| Interfaces de escucha | `listen_addresses = '*'` | Deben escucharse únicamente las interfaces necesarias | El asterisco indica escucha en todas las interfaces disponibles; puede exponer el servicio más de lo requerido. |
| Conexiones remotas | Se observó una conexión con dirección del servidor `172.18.0.4` y puerto `5432`; no se confirmó la lista completa de clientes | Solo las conexiones autorizadas | Una conexión remota no autorizada puede facilitar intentos de acceso o consumo de recursos. |
| Usuarios administrativos | Se consultó `pg_roles`; falta documentar y clasificar cada rol en la tabla de roles | Deben existir solo los necesarios | Los privilegios administrativos innecesarios aumentan el impacto de una cuenta comprometida. |
| SSL/TLS | La conexión actual mostró `ssl = false`; versión y cipher aparecen como `NULL` | Debe utilizarse TLS para conexiones que lo requieran, especialmente por redes no confiables | La conexión comprobada no está cifrada mediante TLS. Esto no demuestra por sí solo que TLS esté deshabilitado globalmente en el servidor. |
| Métodos de autenticación | `password_encryption = scram-sha-256` | Sí, debe preferirse un método moderno compatible | El parámetro indica el método predeterminado para almacenar nuevas contraseñas, no demuestra que todas las contraseñas existentes estén almacenadas con SCRAM. |

### Pregunta: ¿Por qué conocer la superficie de ataque debe preceder al hardening?

Porque primero se necesita saber qué servicios, interfaces, cuentas y conexiones están expuestos. Sin esa revisión, se podrían aplicar cambios innecesarios o dejar sin corregir los riesgos principales. La inspección también permite establecer una línea base para comparar el estado actual con el estado propuesto.

## 2. Actividad 2 — Identificar los archivos de configuración

| Elemento | Ruta o estado |
|---|---|
| `config_file` | Pendiente: registrar el resultado de `SHOW config_file;` |
| `hba_file` | Pendiente: registrar el resultado de `SHOW hba_file;` |
| `ident_file` | Pendiente: registrar el resultado de `SHOW ident_file;` |
| `data_directory` | Pendiente: registrar el resultado de `SHOW data_directory;` |
| `log_directory` | Pendiente: registrar el resultado de `SHOW log_directory;` |
| `log_connections` | Pendiente: registrar el resultado de `SHOW log_connections;` |
| `log_disconnections` | Pendiente: registrar el resultado de `SHOW log_disconnections;` |

### ¿Por qué es importante conocer la ubicación física de estos archivos?

Porque permite identificar dónde están los datos, la configuración, las reglas de autenticación y los registros. Conocer sus rutas facilita revisar permisos, respaldarlos de forma segura, investigar incidentes y evitar que usuarios no autorizados los lean o modifiquen. Las rutas deben obtenerse del servidor real; no se deben inventar.

## 3. Actividad 3 — Revisar `listen_addresses`

- **Configuración encontrada:** `*`.
- **Interfaces necesarias:** pendientes de confirmar con el administrador del servicio y la arquitectura de red.
- **Interfaces innecesarias:** pendientes de identificar; no es posible determinarlas solo con el valor `*`.

### Comparación de arquitecturas

La arquitectura que mantiene PostgreSQL detrás de un firewall y dentro de una red privada reduce mejor la exposición que una arquitectura en la que el servicio puede recibir conexiones desde Internet. El acceso debe limitarse a las redes y equipos que realmente necesitan conectarse. El servidor no debe exponerse directamente a Internet solo porque se utilicen contraseñas fuertes.

## 4. Actividad 4 — Revisar `pg_hba.conf`

La consulta a `pg_hba_file_rules` devolvió `ERROR: permission denied for view pg_hba_file_rules` (SQLSTATE `42501`). Por lo tanto, **no fue posible confirmar las reglas reales**.

Al revisar las reglas, se debe documentar:
- Reglas locales.
- Reglas para IPv4 e IPv6.
- Bases de datos y usuarios afectados.
- Direcciones o redes permitidas.
- Método de autenticación.
- Presencia de rangos excesivamente amplios como `0.0.0.0/0` o `::/0`.

### ¿Qué significa cada elemento que debe revisarse?

- **Tipo:** define si la regla es local o usa conexión por host.
- **Base de datos:** determina a qué base o grupo de bases se aplica.
- **Usuario:** determina qué usuarios o grupos de roles coinciden.
- **Dirección:** identifica el origen de red permitido.
- **Método:** establece cómo se autentica la conexión.

No se puede afirmar que el servidor tenga una regla amplia solo porque la consulta no tuvo permisos. La revisión real queda pendiente de una cuenta autorizada.

## 5. Actividad 5 — Analizar una regla permisiva

Regla conceptual analizada:

```text
host    all    all    0.0.0.0/0    scram-sha-256
```

| Pregunta | Respuesta |
|---|---|
| ¿Qué bases de datos permite? | `all`: coincide con todas las bases de datos a las que aplica esa regla. |
| ¿Qué usuarios permite? | `all`: coincide con todos los usuarios de base de datos a los que aplica la regla. |
| ¿Qué direcciones de origen permite? | `0.0.0.0/0`: todo el espacio de direcciones IPv4. |
| ¿Qué método utiliza? | `scram-sha-256`. |
| ¿Por qué puede representar exposición innecesaria? | Porque permite intentar conexiones desde cualquier origen IPv4 y no limita la regla a una base de datos o cuenta específica. La autenticación sigue siendo necesaria, pero la exposición de red es demasiado amplia. |
| ¿Qué información se necesita para restringirla? | La base de datos, el usuario, la IP o subred real de origen y el método de autenticación compatible. |

| Campo solicitado | Resultado |
|---|---|
| Regla actual | Regla conceptual del enunciado; no confirmada en el servidor real. |
| Problema | Permite todas las bases de datos y usuarios coincidentes desde cualquier IPv4. |
| Origen que realmente necesita acceso | Debe confirmarse con el responsable del sistema. |
| Base de datos | Debe identificarse la base requerida por la aplicación. |
| Usuario | Debe identificarse la cuenta específica que necesita conectarse. |
| Regla propuesta | Ejemplo conceptual: `host basedatos_app app_user 10.10.10.0/24 scram-sha-256`. Sustituir base, usuario y red por valores reales autorizados. |

## 6. Actividad 6 — Aplicar mínimo privilegio a conexiones

Ejemplo conceptual de regla más específica:

```text
host    basedatos_app    app_user    10.10.10.0/24    scram-sha-256
```

Esta regla restringe cuatro elementos: base de datos, usuario, origen y método de autenticación. Los valores del ejemplo no deben copiarse como si fueran los valores reales del laboratorio. La regla definitiva debe basarse en las necesidades reales y ser revisada por una persona autorizada.

**Principio:** una regla de acceso debe ser tan específica como sea razonablemente posible.

## 7. Actividad 7 — Revisar autenticación

Resultado observado de `SHOW password_encryption;`: `scram-sha-256`.

### ¿Qué diferencia existe entre autenticación y autorización?

La autenticación comprueba quién intenta conectarse. La autorización determina qué puede hacer esa identidad después de conectarse, según sus roles y privilegios.

### ¿Qué protege `scram-sha-256`?

Es un mecanismo de autenticación basado en un intercambio de desafío-respuesta y un verificador de contraseña, diseñado para evitar enviar la contraseña directamente como texto durante la autenticación. También es el método recomendado frente a opciones heredadas cuando los clientes lo permiten.

### ¿Por qué una contraseña almacenada mediante un mecanismo de autenticación no debe confundirse con cifrado reversible?

Porque un verificador de contraseña no está diseñado para descifrarse y recuperar la contraseña original. El cifrado reversible permite recuperar el dato usando una clave; un hash o verificador se utiliza para comprobar una contraseña sin almacenarla como texto legible.

### ¿Qué sucede si una cuenta tiene permisos excesivos aunque utilice una contraseña fuerte?

Si la cuenta se roba o se utiliza indebidamente, sus privilegios excesivos permiten realizar acciones de mayor impacto. Una contraseña fuerte no sustituye el principio de mínimo privilegio.

## 8. Actividad 8 — Revisar usuarios y privilegios

Se ejecutó una consulta a `pg_roles`, pero se debe completar la clasificación a partir de sus resultados. No se deben inventar nombres ni privilegios.

| Rol | LOGIN | SUPERUSER | CREATEROLE | CREATEDB | Función |
|---|---|---|---|---|---|
| Completar con el resultado real |  |  |  |  | DBA, aplicación, consulta u otra función justificada |

Al revisar la salida, identificar:
- Roles con `SUPERUSER`.
- Roles con `LOGIN`.
- Roles con `CREATEROLE`.
- Roles con `CREATEDB`.
- Roles usados por aplicaciones.
- Cuentas posiblemente innecesarias, que deberán confirmarse antes de proponer cambios.

### ¿Por qué no debería utilizarse una cuenta `SUPERUSER` como cuenta normal de una aplicación?

Porque puede realizar prácticamente cualquier operación administrativa y saltarse controles de permisos. Si la aplicación tiene una vulnerabilidad o sus credenciales se filtran, el atacante podría obtener control amplio de la base de datos. La aplicación debe usar una cuenta separada con solo los permisos que necesita.

## 9. Actividad 9 — Separar cuentas administrativas y de aplicación

| Cuenta | Propósito | LOGIN | Privilegios propuestos |
|---|---|---|---|
| DBA | Administración y mantenimiento | Sí | Administrativos, solo para personal autorizado y tareas necesarias |
| APP | Conexión utilizada por el software | Sí | Mínimos para las operaciones que requiere la aplicación |
| CONSULTA | Consultas autorizadas | Sí | Solo lectura sobre objetos expresamente permitidos |

### ¿Qué riesgo existe si la aplicación se conecta utilizando una cuenta administrativa?

Una vulnerabilidad de la aplicación podría permitir al atacante borrar o modificar datos, crear roles, cambiar configuraciones o ejecutar otras operaciones de alto impacto. Separar cuentas limita el daño potencial.

## 10. Actividad 10 — Revisar extensiones

Consulta utilizada:

```sql
SELECT extname, extversion
FROM pg_extension
ORDER BY extname;
```

| Revisión | Resultado |
|---|---|
| Extensiones instaladas | Pendiente de registrar la salida real de la consulta |
| Extensiones necesarias | Determinar según el propósito de la base de datos |
| Extensiones instaladas para prácticas | Identificar a partir del historial y uso del entorno |
| Funcionalidad innecesaria | Proponer revisión; no asumir que una extensión es insegura solo por estar instalada |

El hardening consiste en mantener habilitada únicamente la funcionalidad necesaria. Antes de retirar una extensión, se deben verificar dependencias y obtener autorización.

## 11. Actividad 11 — Revisar configuración relacionada con conexiones

Registrar los resultados reales de estas consultas:

```sql
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
```

| Parámetro | Función |
|---|---|
| `max_connections` | Límite máximo de conexiones simultáneas al servidor. |
| `superuser_reserved_connections` | Número de conexiones reservadas para superusuarios, para ayudar a conservar una vía administrativa cuando se agotan las demás conexiones. |
| `statement_timeout` | Tiempo máximo permitido para ejecutar una sentencia antes de que PostgreSQL la cancele. |
| `idle_in_transaction_session_timeout` | Tiempo máximo que una sesión puede permanecer inactiva dentro de una transacción abierta antes de que PostgreSQL la cierre. |

### ¿Por qué mantener conexiones indefinidamente abiertas puede representar un problema de disponibilidad o consumo de recursos?

Cada conexión utiliza recursos del servidor. Muchas conexiones abiertas o transacciones abandonadas pueden consumir memoria y otros recursos, bloquear operaciones y reducir la capacidad de atender a usuarios legítimos. Los límites y tiempos de espera deben ajustarse al uso real de la aplicación.

## 12. Actividad 12 — Revisar permisos del sistema operativo

Rutas por obtener mediante `SHOW data_directory;`, `SHOW config_file;` y `SHOW hba_file;`. La inspección de permisos desde la terminal del servidor no se ha confirmado.

| Elemento que se debe revisar | Qué registrar |
|---|---|
| Propietario | Cuenta propietaria de cada archivo o directorio |
| Grupo | Grupo asignado |
| Permisos | Quién puede leer, escribir o ejecutar |
| Lectura por otros usuarios | Confirmar que usuarios no autorizados no puedan leer datos o archivos sensibles |
| Directorio de datos | Confirmar que esté protegido y accesible solo por las cuentas necesarias |

### ¿Por qué no es suficiente proteger PostgreSQL mediante `GRANT` y `REVOKE` si cualquier usuario del sistema operativo puede leer archivos sensibles?

Porque los permisos de la base de datos controlan el acceso a través de PostgreSQL, pero los permisos del sistema operativo controlan el acceso directo a archivos. Si una persona puede leer archivos de datos, configuraciones o credenciales desde el sistema operativo, puede evadir parte de las protecciones que se aplican dentro de la base de datos.

## 13. Actividad 13 — Revisar exposición de red

| Dato solicitado | Resultado |
|---|---|
| Dirección del servidor observada en la sesión | `172.18.0.4` |
| Puerto | `5432` |
| `listen_addresses` | `*` |
| ¿Está expuesto fuera de la interfaz necesaria? | No se puede determinar por completo solo con estos datos. Se necesita revisar interfaces, escucha efectiva, rutas y firewall desde un equipo autorizado. |

El resultado de `listen_addresses = '*'` indica que PostgreSQL está configurado para escuchar en todas las interfaces disponibles, pero no demuestra por sí solo que el puerto sea accesible desde Internet. La accesibilidad también depende de la red y del firewall.

## 14. Actividad 14 — Diseñar una política de firewall

El ejercicio indica que no se debe modificar el firewall institucional. La siguiente tabla es conceptual.

| Origen | Destino | Puerto | Acción |
|---|---|---:|---|
| `10.10.10.0/24` (red DBA) | PostgreSQL (`10.10.10.20`) | `5432` | Permitir |
| Cualquier otro origen | PostgreSQL (`10.10.10.20`) | `5432` | Denegar |

### ¿Por qué `pg_hba.conf` y el firewall no son controles equivalentes?

El firewall limita qué tráfico de red puede llegar al servidor, según reglas como origen, destino y puerto. `pg_hba.conf` decide qué conexiones a PostgreSQL se aceptan según tipo de conexión, base de datos, usuario, dirección y método de autenticación. Son capas complementarias: permitir tráfico en el firewall no concede acceso a una base de datos, y una regla en `pg_hba.conf` no sustituye la restricción de red.

## 15. Actividad 15 — Revisar TLS

| Dato | Resultado observado |
|---|---|
| Conexión actual con TLS | No |
| `ssl` en `pg_stat_ssl` para la sesión actual | `false` |
| Versión | `NULL` |
| Cipher | `NULL` |
| `SHOW ssl` y `SHOW ssl_min_protocol_version` | Registrar la salida real si aún no se guardó |

### Relación con LAB-02

LAB-02 trató el cifrado y TLS; LAB-04 revisa cómo están integrados en la configuración del servidor y de los clientes. No basta con conocer TLS: hay que comprobar la conexión real. La sesión comprobada no utiliza TLS, pero esto no demuestra por sí solo que el servidor tenga TLS deshabilitado para todas las conexiones. La corrección debe realizarla el administrador, verificando certificados, configuración del servidor y parámetros del cliente.

## 16. Actividad 16 — Comparar configuración antes y después

| Control | Antes | Después propuesto | Justificación |
|---|---|---|---|
| `listen_addresses` | `*` | Limitar a las interfaces privadas necesarias | Reducir exposición. |
| `pg_hba.conf` | No se pudo leer la vista por permisos | Revisar reglas reales y restringir base, usuario, origen y método | Evitar reglas demasiado amplias. |
| Método de autenticación | `password_encryption = scram-sha-256` | Mantener SCRAM cuando los clientes lo permitan y verificar reglas reales | Fortalecer autenticación; el parámetro no prueba todos los hashes existentes. |
| Usuarios administrativos | Consulta de roles ejecutada; clasificación pendiente | Revisar roles y conservar solo privilegios administrativos justificados | Reducir impacto de cuentas comprometidas. |
| Cuentas de aplicación | No se confirmó separación | Crear o utilizar una cuenta dedicada de mínimo privilegio, previa autorización | Evitar usar cuentas administrativas desde la aplicación. |
| Puerto | `5432` | Mantenerlo si corresponde, pero limitar su acceso en el firewall | El puerto por sí solo no debe quedar expuesto a cualquier origen. |
| TLS | Sesión actual con `ssl = false` | Configurar y comprobar TLS en servidor y cliente cuando corresponda | Proteger confidencialidad e integridad en tránsito. |
| Permisos SO | No verificados | Revisar propietario y permisos de configuración y datos | Impedir lectura o modificación directa no autorizada. |
| Extensiones | Pendiente de registrar la salida | Mantener solo extensiones necesarias y aprobadas | Reducir funcionalidad innecesaria. |
| Conexiones | Valores pendientes de documentar | Revisar límites y tiempos de espera según el uso | Evitar agotamiento de recursos y transacciones abandonadas. |

## 17. Actividad 17 — Checklist de hardening

| # | Control | Verificado | Evidencia o estado |
|---:|---|---|---|
| 1 | Puerto documentado | Sí | Resultado de verificación: puerto `5432`. |
| 2 | Interfaces de escucha justificadas | Parcial | `listen_addresses = '*'`; falta justificar las interfaces necesarias. |
| 3 | `pg_hba.conf` revisado | No | Consulta falló con permiso denegado a `pg_hba_file_rules`. |
| 4 | Redes autorizadas restringidas | Pendiente | Falta revisar reglas reales y firewall. |
| 5 | Autenticación segura | Parcial | `password_encryption = scram-sha-256`; no prueba todos los hashes existentes. |
| 6 | Superusuarios identificados | Parcial | Se consultó `pg_roles`; falta clasificar la salida. |
| 7 | Cuentas de aplicación separadas | Pendiente | No se confirmó la arquitectura de cuentas. |
| 8 | Privilegios mínimos | Pendiente | Falta revisar permisos por cuenta. |
| 9 | Extensiones revisadas | Pendiente | Registrar y analizar la salida de `pg_extension`. |
| 10 | TLS verificado | Parcial / no en esta sesión | `ssl = false`, versión y cipher `NULL` para la sesión actual. |
| 11 | Configuración protegida | Pendiente | Revisar permisos del sistema operativo. |
| 12 | Directorio de datos protegido | Pendiente | Revisar propietario y permisos en el servidor. |
| 13 | Firewall documentado | Pendiente | Se diseñó una política conceptual; no se modificó el firewall. |
| 14 | Actualizaciones documentadas | Pendiente | Confirmar versión, parches y procedimiento de mantenimiento. |
| 15 | Configuración registrada | Parcial | Se documentaron resultados disponibles y limitaciones. |

## 18. Actividad 18 — Caso integral

Escenario del enunciado: PostgreSQL acepta conexiones desde cualquier IPv4, escucha en todas las interfaces, el firewall permite el puerto 5432 desde cualquier origen, `pg_hba.conf` permite `all/all` desde `0.0.0.0/0`, y una aplicación usa una cuenta administrativa. El responsable considera suficientes las contraseñas fuertes.

| # | Problema | Riesgo | Control propuesto |
|---:|---|---|---|
| 1 | Aceptar conexiones desde cualquier IPv4 | Intentos de conexión desde orígenes no necesarios | Limitar el acceso a redes autorizadas. |
| 2 | Escuchar en todas las interfaces | Exposición por interfaces que no requieren el servicio | Restringir `listen_addresses` a interfaces necesarias. |
| 3 | Firewall abierto a cualquier origen en el puerto 5432 | El servicio puede recibir tráfico no requerido | Permitir solo las redes de origen autorizadas. |
| 4 | Regla `pg_hba.conf` con `all/all` | Todas las bases y usuarios coincidentes quedan contemplados por la regla | Especificar base y usuario necesarios. |
| 5 | Uso de `0.0.0.0/0` | Rango de origen demasiado amplio | Sustituirlo por la subred autorizada. |
| 6 | Aplicación con cuenta administrativa | Una vulnerabilidad podría permitir acciones de alto impacto | Usar una cuenta de aplicación con mínimo privilegio. |
| 7 | No separar cuentas por función | Se dificulta limitar el daño y auditar responsabilidades | Separar DBA, APP y CONSULTA. |
| 8 | Confiar solo en contraseñas fuertes | No evita exposición de red, abuso de privilegios o errores de configuración | Aplicar controles en varias capas. |
| 9 | No verificar TLS | Datos de conexión podrían viajar sin protección criptográfica | Configurar y verificar TLS en el servidor y cliente. |
| 10 | No revisar permisos del sistema operativo | Usuarios del sistema podrían acceder directamente a archivos sensibles | Restringir propietario y permisos de archivos y directorios. |
| 11 | No revisar registros ni conexiones | Actividad anómala podría pasar inadvertida | Habilitar y revisar registros y monitoreo según la política del sistema. |
| 12 | No revisar extensiones y parámetros | Funcionalidad o recursos innecesarios pueden aumentar el riesgo | Revisar extensiones, límites y tiempos de espera. |

### ¿Es suficiente tener contraseñas fuertes?

No. Las contraseñas fuertes mejoran la autenticación, pero no resuelven por sí solas los demás riesgos.

- **Autenticación:** usar mecanismos modernos como SCRAM y proteger las credenciales.
- **Autorización:** asignar a cada cuenta solo los permisos necesarios.
- **Red:** limitar las interfaces, redes y orígenes que pueden llegar al servicio.
- **Configuración:** evitar reglas demasiado amplias y revisar parámetros y extensiones.
- **Sistema operativo:** proteger los archivos de datos, configuración y registros con permisos adecuados.
- **Monitoreo:** registrar y revisar conexiones y eventos relevantes para detectar comportamientos anómalos.

La seguridad depende de la combinación de estos controles, no de una sola medida.

## 19. Actividad 19 — Construcción de una línea base para PostgreSQL 16

Esta es una propuesta de baseline; no significa que los cambios se hayan aplicado al servidor institucional.

### Red

- **Interfaces autorizadas:** escuchar únicamente en interfaces privadas necesarias para los clientes autorizados.
- **Puerto:** documentar el puerto real; en este laboratorio se observó `5432`.
- **Firewall:** permitir el puerto solo desde las redes autorizadas y denegar los demás orígenes.
- **Redes permitidas:** mantener una lista aprobada de redes y equipos; evitar rangos universales como `0.0.0.0/0` salvo justificación formal excepcional.

### Autenticación

- **Método:** preferir `scram-sha-256` si el entorno y los clientes son compatibles.
- **Políticas de credenciales:** usar contraseñas únicas y fuertes, protegerlas y cambiarlas según la política institucional y ante sospecha de exposición.
- **Cuentas administrativas:** limitar su uso a personal autorizado y tareas administrativas.

### Autorización

- **Roles:** documentar la función de cada rol y revisar `LOGIN`, `SUPERUSER`, `CREATEROLE` y `CREATEDB`.
- **Privilegios:** aplicar mínimo privilegio y revisar periódicamente los permisos.
- **Cuentas de aplicación:** separar la cuenta de la aplicación de las cuentas DBA y de consulta.

### Configuración

- **Parámetros relevantes:** revisar `listen_addresses`, `port`, `ssl`, `password_encryption`, `max_connections`, `superuser_reserved_connections`, `statement_timeout` e `idle_in_transaction_session_timeout`.
- **Extensiones:** mantener solo las necesarias y aprobadas.
- **Conexiones:** ajustar límites y tiempos de espera según las necesidades reales de la aplicación.

### Sistema operativo

- **Propietario de archivos:** confirmar que los archivos y directorios de PostgreSQL pertenezcan a la cuenta de servicio adecuada.
- **Permisos:** permitir lectura o modificación únicamente a usuarios autorizados.
- **Directorio de datos:** protegerlo frente al acceso directo de otras cuentas del sistema operativo.

### Cifrado

- **TLS:** verificar la configuración del servidor y de los clientes y comprobar que las conexiones que lo requieren realmente lo utilicen.
- **Protección de credenciales:** no almacenar contraseñas en texto claro; preferir mecanismos adecuados de verificación de contraseñas.
- **Información sensible:** protegerla con permisos y controles de acceso; usar cifrado cuando corresponda al tipo de dato y a los requisitos del sistema.

### Mantenimiento

- **Actualizaciones:** documentar versión, parches y procedimiento autorizado de actualización.
- **Revisión periódica:** revisar roles, reglas de acceso, extensiones, conexiones, registros y permisos.
- **Documentación:** mantener un registro de configuración, evidencias, responsables, excepciones y cambios aprobados.

## Limitaciones conocidas de esta ejecución

- `pg_hba_file_rules` no pudo consultarse por falta de permisos.
- La conexión observada no utiliza TLS (`ssl = false`); versión y cipher son `NULL` en esa sesión.
- `listen_addresses` devolvió `*`.
- `password_encryption` devolvió `scram-sha-256`, que describe el valor predeterminado para nuevas contraseñas.
- Faltan resultados de varias consultas y revisiones del sistema operativo. Deben completarse con datos reales, sin inventarlos.
- No se realizaron cambios administrativos al servidor institucional.
