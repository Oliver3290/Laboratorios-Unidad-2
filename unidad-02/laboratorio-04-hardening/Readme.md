# LAB-04 — Hardening y configuración segura de PostgreSQL

## Objetivo

Revisar la configuración de seguridad de PostgreSQL 16 para identificar posibles riesgos relacionados con la red, la autenticación, los privilegios, las conexiones, el cifrado y los permisos del sistema operativo. A partir de los hallazgos, proponer una línea base de seguridad que reduzca la exposición del servidor sin afectar la disponibilidad del servicio.

## Entorno

- **Sistema gestor:** PostgreSQL 16.
- **Herramienta de trabajo:** pgAdmin y consultas SQL.
- **Puerto observado:** 5432.
- **Dirección del servidor observada en la sesión:** 172.18.0.4.
- **Método de almacenamiento de nuevas contraseñas configurado por defecto:** `scram-sha-256`.
- **Permisos disponibles:** cuenta proporcionada para la práctica, sin privilegios de superusuario confirmados.

## Superficie de ataque inicial

La superficie de ataque incluye las interfaces de red donde escucha PostgreSQL, el puerto de conexión, las reglas de acceso de `pg_hba.conf`, los métodos de autenticación, las cuentas de usuario, los privilegios asignados y las conexiones que pueden establecerse con el servidor.

Durante la revisión se observó que `listen_addresses` tenía el valor `*`, lo que indica que PostgreSQL escucha en todas las interfaces disponibles. Este comportamiento debe evaluarse junto con las reglas del firewall y de autenticación para determinar la exposición efectiva.

También se comprobó que el puerto utilizado era 5432 y que la conexión consultada no estaba cifrada mediante TLS.

## Hallazgos

1. El parámetro `listen_addresses` devolvió `*`, por lo que se recomienda comprobar si todas las interfaces necesitan aceptar conexiones.
2. El parámetro `password_encryption` devolvió `scram-sha-256`, que establece el método predeterminado para almacenar nuevas contraseñas.
3. El puerto observado fue 5432, que corresponde al puerto predeterminado de PostgreSQL.
4. La consulta de `pg_stat_ssl` para la sesión actual devolvió `ssl=false`, por lo que esa conexión no estaba utilizando TLS.
5. La consulta de `pg_hba_file_rules` devolvió un error de permisos. Por este motivo, no se pudo confirmar el contenido de las reglas mediante esa consulta.
6. Se consultaron los roles del servidor mediante `pg_roles`, pero se necesita revisar sus resultados para determinar qué cuentas tienen privilegios elevados.
7. La configuración del firewall, los permisos del sistema operativo y las demás reglas de acceso deben verificarse con las evidencias correspondientes.

Los hallazgos anteriores describen únicamente los resultados observados. Los aspectos pendientes no se consideran vulnerabilidades confirmadas sin una revisión adicional.

## Cambios realizados

Durante la práctica se realizaron consultas de revisión para obtener información sobre la configuración y el estado de seguridad de PostgreSQL.

Entre los valores observados se encuentran:

- `listen_addresses = '*'`
- `port = 5432`
- `password_encryption = 'scram-sha-256'`
- La sesión consultada mostró `ssl = false`.

No se documentan modificaciones administrativas confirmadas en la configuración del servidor. Las medidas de hardening identificadas se mantienen como propuestas hasta contar con evidencia de su aplicación.

## Justificación de los cambios

Las medidas propuestas buscan reducir el acceso innecesario al servidor y limitar las consecuencias de un posible compromiso.

- Restringir `listen_addresses` a las interfaces necesarias reduciría la exposición de red.
- Limitar las conexiones mediante el firewall y `pg_hba.conf` permitiría aceptar únicamente los accesos autorizados.
- Utilizar `scram-sha-256` ayuda a proteger las credenciales almacenadas para las nuevas contraseñas.
- Aplicar el principio de mínimo privilegio reduce el riesgo asociado a cuentas con permisos excesivos.
- Configurar TLS protege la comunicación entre los clientes y PostgreSQL cuando las conexiones requieren cifrado.
- Restringir los permisos del sistema operativo ayuda a proteger los archivos de configuración y el directorio de datos.
- Revisar las conexiones, las extensiones y los registros permite detectar configuraciones innecesarias o actividades sospechosas.

Antes de aplicar cambios en producción, deben evaluarse sus efectos sobre las aplicaciones, la disponibilidad y la continuidad del servicio.

## Verificación

La verificación se realizó mediante consultas SQL en PostgreSQL y la revisión de sus resultados.

| Elemento | Resultado observado |
|---|---|
| `listen_addresses` | `*` |
| Puerto | `5432` |
| `password_encryption` | `scram-sha-256` |
| TLS en la sesión consultada | No activo (`ssl=false`) |
| Lectura de `pg_hba_file_rules` | Denegada por permisos |
| Consulta de roles | Ejecutada; pendiente analizar los privilegios de cada cuenta |

Para completar la verificación se recomienda revisar las reglas de acceso con autorización, comprobar los privilegios de los roles, confirmar la configuración global de TLS y verificar los permisos del sistema operativo. Los cambios de configuración deberán comprobarse mediante evidencias antes de considerarlos aplicados.

## Checklist de hardening

- [ ] Limitar las interfaces de escucha a las necesarias.
- [ ] Revisar las redes permitidas en el firewall.
- [ ] Revisar las reglas de `pg_hba.conf`.
- [ ] Utilizar métodos de autenticación seguros.
- [ ] Comprobar la política de contraseñas.
- [ ] Revisar las cuentas con privilegios de superusuario.
- [ ] Aplicar el principio de mínimo privilegio.
- [ ] Utilizar cuentas específicas para las aplicaciones.
- [ ] Revisar las extensiones instaladas.
- [ ] Configurar límites de conexiones y tiempos de espera.
- [ ] Verificar TLS para las conexiones remotas.
- [ ] Restringir los permisos del directorio de datos.
- [ ] Proteger los archivos de configuración y las credenciales.
- [ ] Mantener PostgreSQL y el sistema operativo actualizados.
- [ ] Revisar registros, respaldos y documentación periódicamente.

## Conclusiones

La práctica permitió identificar parámetros importantes de la configuración de PostgreSQL 16 y reconocer que la seguridad no depende únicamente de las contraseñas. También es necesario controlar las interfaces de red, las reglas de acceso, los privilegios de los usuarios, el cifrado de las conexiones y los permisos del sistema operativo.

Entre los resultados observados destaca que PostgreSQL escucha en todas las interfaces disponibles y que la sesión revisada no utilizaba TLS. Estos puntos requieren una evaluación adicional para determinar las medidas adecuadas sin interrumpir el servicio.

Como conclusión, una configuración segura debe aplicar el principio de mínimo privilegio, reducir la exposición de red, proteger las credenciales y los datos, y mantener revisiones periódicas. Las modificaciones deben documentarse y verificarse para distinguir entre las medidas propuestas y las que realmente se hayan implementado.