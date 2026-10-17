# Comparación de configuración y cambios propuestos

## Propósito

Este archivo registra la comparación solicitada en la actividad 16, los resultados de las evidencias disponibles y los cambios recomendados. Los cambios de la columna **Después propuesto** son recomendaciones, no modificaciones aplicadas al servidor.

## 1. Actividad 16 — Comparar configuración antes y después

| Control | Antes | Después propuesto | Justificación |
|---|---|---|---|
| `listen_addresses` | Se observó `*` | Limitar a las interfaces privadas que realmente necesiten aceptar conexiones | Reduce la exposición innecesaria del servicio. |
| `pg_hba.conf` | La consulta a `pg_hba_file_rules` falló por permisos (`42501`) | Solicitar revisión con una cuenta autorizada y restringir reglas por base, usuario, origen y método | No se pueden validar las reglas reales desde la sesión actual. |
| Método de autenticación | `password_encryption = scram-sha-256` | Mantener SCRAM si los clientes son compatibles y revisar los métodos definidos en `pg_hba.conf` | El parámetro establece el valor predeterminado para nuevas contraseñas; no demuestra cómo están almacenadas todas las existentes. |
| Usuarios administrativos | Se consultó `pg_roles`; falta completar la clasificación de roles | Identificar y justificar cada rol privilegiado; limitar el uso de cuentas administrativas | Reduce el impacto de credenciales comprometidas. |
| Cuentas de aplicación | No se confirmó si están separadas | Usar una cuenta de aplicación dedicada con permisos mínimos | Evita que la aplicación opere como administrador. |
| Puerto | Se observó `5432` | Mantener el puerto documentado y limitarlo mediante firewall a orígenes autorizados | Evita acceso de red innecesario. |
| TLS | La sesión actual mostró `ssl = false`, `version = NULL` y `cipher = NULL` | Revisar la configuración del servidor y del cliente y habilitar/verificar TLS donde corresponda | La sesión observada no está cifrada con TLS; no demuestra por sí sola el estado TLS de todas las conexiones. |
| Permisos SO | No se verificaron desde la terminal del servidor | Revisar propietario, grupo y permisos de archivos de configuración y datos | Evita acceso directo no autorizado a archivos sensibles. |
| Extensiones | Falta registrar la salida de `pg_extension` | Revisar cuáles son necesarias y conservar solo las aprobadas | Reduce funcionalidad innecesaria sin asumir que toda extensión es insegura. |
| Conexiones | Faltan los valores de los parámetros de conexión | Documentar y revisar `max_connections`, `superuser_reserved_connections`, `statement_timeout` e `idle_in_transaction_session_timeout` | Ayuda a reducir agotamiento de recursos y sesiones abandonadas. |

## 2. Resultados de las verificaciones realizadas

| Evidencia | Consulta o revisión | Resultado | Interpretación |
|---|---|---|---|
| `01-superficie-ataque.png` | Inspección inicial y datos del servidor | Evidencia inicial capturada; los datos detallados deben contrastarse con la salida guardada | Sirve como punto de partida para documentar la superficie de ataque. |
| `02-listen-addresses.png` | `SHOW listen_addresses;` | `*` | PostgreSQL escucha en todas las interfaces disponibles según este parámetro. Se debe confirmar cuáles son necesarias. |
| `03-pg-hba.png` | Consulta a `pg_hba_file_rules` | `ERROR: permission denied for view pg_hba_file_rules`, SQLSTATE `42501` | No se pudieron revisar las reglas reales. No se debe afirmar que una regla permisiva exista en el servidor. |
| `04-roles.png` | Consulta a `pg_roles` | La consulta devolvió filas | La lista debe analizarse para identificar `LOGIN`, `SUPERUSER`, `CREATEROLE`, `CREATEDB` y la función de cada rol. |
| `05-tls.png` | `pg_stat_ssl` para el PID actual | `ssl = false`; `version` y `cipher` en `NULL` | La conexión actual no utiliza TLS. No prueba por sí sola que TLS esté deshabilitado para todas las conexiones. |
| `06-verificacion.png` | Identidad y dirección de la sesión | Se observó `current_user`, `session_user`, la base de datos, `inet_server_addr = 172.18.0.4` y `inet_server_port = 5432` | Registra la identidad de la sesión y la dirección/puerto del servidor vistos desde la conexión. |

## 3. Cambios propuestos y responsables

| Prioridad | Acción propuesta | Quién debe realizarla | Estado |
|---|---|---|---|
| Alta | Revisar `pg_hba.conf` con permisos autorizados y documentar todas las reglas | Administrador de PostgreSQL | Pendiente |
| Alta | Confirmar si TLS debe utilizarse y revisar servidor, certificados y cliente | Administrador de PostgreSQL | Pendiente |
| Alta | Evaluar y restringir `listen_addresses` y el acceso de red al puerto `5432` | Administrador de PostgreSQL y responsable de red | Pendiente |
| Alta | Revisar roles privilegiados y separar cuentas de aplicación | Administrador de PostgreSQL y responsable de la aplicación | Pendiente |
| Media | Registrar los valores de parámetros de conexión y evaluar límites/tiempos de espera | Administrador de PostgreSQL | Pendiente |
| Media | Revisar extensiones instaladas y justificar su necesidad | Administrador de PostgreSQL | Pendiente |
| Media | Revisar permisos de archivos y directorio de datos desde el sistema operativo | Administrador del servidor | Pendiente |
| Media | Documentar firewall, actualizaciones y proceso de revisión periódica | Responsable de infraestructura | Pendiente |

## 4. Política de firewall conceptual (actividad 14)

No se modificó el firewall institucional. Para el escenario planteado en el laboratorio, la política conceptual es:

| Origen | Destino | Puerto | Acción |
|---|---|---:|---|
| `10.10.10.0/24` (red DBA) | PostgreSQL (`10.10.10.20`) | `5432` | Permitir |
| Cualquier otro origen | PostgreSQL (`10.10.10.20`) | `5432` | Denegar |

El firewall controla qué tráfico de red llega al servidor. `pg_hba.conf` controla qué conexiones de PostgreSQL se aceptan según base de datos, usuario, dirección y método de autenticación. Ambos controles son complementarios, no equivalentes.

## 5. Regla permisiva y regla restringida (actividades 5 y 6)

Regla conceptual permisiva:

```text
host    all    all    0.0.0.0/0    scram-sha-256
```

- `all` para base de datos: coincide con todas las bases de datos a las que aplica la regla.
- `all` para usuario: coincide con todos los usuarios a los que aplica la regla.
- `0.0.0.0/0`: permite coincidencia desde cualquier dirección IPv4.
- `scram-sha-256`: método de autenticación.

Ejemplo conceptual más restringido:

```text
host    basedatos_app    app_user    10.10.10.0/24    scram-sha-256
```

Los nombres y la red del ejemplo deben sustituirse por los valores reales autorizados. La consulta al archivo real no pudo completarse por falta de permisos, así que ninguno de estos ejemplos debe presentarse como una regla encontrada en el servidor.

## 6. Estado de los cambios

No se realizaron modificaciones administrativas al servidor. Este documento registra el estado observado y las recomendaciones para que las revise el responsable autorizado. Los resultados no disponibles deben completarse a partir de consultas y evidencias reales; no se deben rellenar con suposiciones.

### Datos pendientes de completar

- Rutas reales de `config_file`, `hba_file`, `ident_file`, `data_directory` y `log_directory`.
- Valores de `log_connections` y `log_disconnections`.
- Salida completa de roles para clasificar cada cuenta.
- Salida de extensiones instaladas.
- Valores de los cuatro parámetros relacionados con conexiones.
- Permisos de archivos y directorios revisados desde el sistema operativo.
- Salida de `SHOW ssl;` y `SHOW ssl_min_protocol_version;`, si aún no está registrada.
- Redes autorizadas y política real del firewall, si el administrador puede proporcionarlas.
