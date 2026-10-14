# Laboratorio 01 — Protección de datos
Oliver Coronel Caro 4-4
# Actividad 1 — Clasificación de los datos
## Matriz de Clasificación de Datos `tabla: clientes`

| Campo | ¿Identifica directamente? | ¿Puede contribuir a identificar? | ¿Requiere protección? | Justificación |
| :--- | :---: | :---: | :---: | :--- |
| `id` | No | Sí | Sí | Es una clave primaria sintética interna. No identifica al individuo en la vida real por sí solo, pero relaciona todos sus registros en la base de datos. |
| `nombre` | **Sí** | Sí | **Sí** | Es un identificador personal directo (PII) que revela directamente la identidad del titular. |
| `correo` | **Sí** | Sí | **Sí** | Es una dirección de contacto unívoca que frecuentemente contiene el nombre o identidad de la persona. |
| `telefono` | **Sí** | Sí | **Sí** | Dato de contacto directo asociado a una línea telefónica única de la persona. |
| `rfc` | **Sí** | Sí | **Sí** | Clave única de registro fiscal oficial que vincula de forma inequívoca a una persona física. |
| `edad` | No | Sí | Sí | Cuasi-identificador demográfico. Por sí solo no identifica, pero reduce el grupo de búsqueda. |
| `ciudad` | No | Sí | Sí | Cuasi-identificador geográfico de carácter general. |
| `codigo_postal` | No | Sí | Sí | Cuasi-identificador de ubicación que acota geográficamente el entorno de residencia del usuario. |
| `fecha_alta` | No | Sí | No / Baja | Metadato operativo del sistema. Aporta contexto temporal del registro pero no revela la identidad por sí mismo. |

### Preguntas y Respuestas

1. ¿Qué campos identifican directamente a una persona?
nombre, correo, telefono y rfc.

2. ¿Qué campos no identifican por sí solos pero podrían contribuir a hacerlo?
id, edad, ciudad, codigo_postal y fecha_alta.

3. ¿Qué combinación de campos podría incrementar el riesgo de reidentificación?
La combinación de codigo_postal + edad + ciudad + fecha_alta.

4. ¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?
No. Campos como el correo, teléfono o RFC son datos personales de identificación que exigen protección, pero no entran en la clasificación legal de datos sensibles (como estado de salud, religión, ideología o datos biométricos).

# Actividad 2 — Enmascaramiento (masking)
### Preguntas y Respuestas — Actividad 2

1. ¿Qué información continúa existiendo en la tabla original?
Toda la información real y completa de los clientes (correo, teléfono y RFC) intacta y sin alteración.

2. ¿Qué información puede visualizar el usuario soporte?
El ID, nombre y los datos sensibles (correo, teléfono y RFC) parcialmente enmascarados con asteriscos a través de la vista.

3. ¿Por qué no es suficiente ocultar los datos únicamente en la aplicación?
Porque si alguien accede directamente a la base de datos o mediante inyección SQL, se evade la seguridad de la aplicación y los datos reales quedarían totalmente expuestos.

4. ¿Qué ocurriría si soporte tuviera acceso directo a clientes?
Podría consultar y extraer la información personal confidencial de los usuarios, violando el principio de mínimo privilegio y las políticas de privacidad.

# Actividad 3 — Seudonimización (pseudonymization)
En esta actividad se implementó la técnica de seudonimización mediante la creación de dos esquemas: pii y analitica. Se generó una tabla de mapeo en pii donde se asignó un token UUID único a cada ID de cliente utilizando la extensión pgcrypto. Luego, se creó la tabla analitica.clientes vinculando únicamente el token sintético con variables demográficas y de registro (edad, ciudad, código postal y fecha de alta). De esta manera, el equipo de analítica puede estudiar los datos sin tener acceso a identificadores directos como nombre, correo, teléfono o RFC.

# Actividad 4 — Separación de funciones
### Preguntas y Respuestas — Actividad 3

1. ¿Qué ocurriría si analista pudiera consultar también pii.mapa_cliente?
Podría realizar un cruce de datos (JOIN) entre la tabla analítica y el mapa de tokens para obtener el ID original del cliente, lo que permitiría reidentificar a las personas y anular la protección.

2. ¿Qué principio de seguridad se está aplicando al separar ambos accesos?
El Principio de Mínimo Privilegio y la Separación de Funciones (Separation of Duties).

3. ¿Por qué la seudonimización no equivale a anonimización?
Porque la seudonimización es un proceso reversible donde aún existe una relación que permite reidentificar al usuario mediante una clave o tabla externa, mientras que la anonimización es irreversible.

4. ¿Qué información permite volver a relacionar el token con una persona?
La tabla de correspondencia o mapa de tokens (`pii.mapa_cliente`), la cual vincula cada identificador sintético (`UUID`) con el identificador original (`cliente_id`).

# Actividad 6 — Análisis del riesgo de reidentificación

1. ¿Qué identificadores directos fueron eliminados?
Se eliminaron el nombre, correo electrónico, teléfono, RFC y el identificador único (`id`) de cada cliente.

2. ¿Qué cuasi-identificadores permanecen?
Permanece el rango de edad (`rango_edad`) y la región derivada del código postal (`region`).

3. ¿Qué combinaciones de atributos podrían reducir el anonimato?
La combinación simultánea del rango de edad con una región muy específica, especialmente si se cruza con fuentes externas de datos públicas como padrones o censos.

4. ¿Qué sucede cuando un grupo contiene pocos registros?
Aumenta drásticamente el riesgo de reidentificación por aislamiento (singling out), permitiendo deducir la identidad de un individuo específico dentro del grupo.

5. ¿Qué atributos deberían generalizarse?
Atributos con alta precisión o variabilidad, como la edad exacta, fechas detalladas y el código postal completo.

6. ¿Qué información debería suprimirse?
Aquellas filas o grupos resultantes cuya cantidad de registros sea menor al umbral de seguridad definido (como grupos con menos de 5 registros).

7. ¿Es correcto afirmar que el conjunto de datos es “100 % anónimo”? ¿Por qué?
No, porque el anonimato absoluto no existe. Siempre persiste un riesgo residual de reidentificación si se combina la información con nuevas bases de datos externas o si cambian los contextos de acceso.

# 19.1 Clasificación - Explicar qué datos requieren protección y por qué.
En la práctica identificamos tres tipos de datos que requieren protección. Primero, los identificadores directos como nombre, correo, teléfono y RFC, los cuales requieren máxima protección porque permiten identificar directamente a un usuario, exponiéndolo a fraudes o suplantación de identidad; para estos aplicamos enmascaramiento, seudonimización y control de acceso estricto con el rol anaalista. Segundo, los cuasi-identificadores como la edad y el código postal, que requieren protección porque al combinarse entre sí o con bases externas pueden reidentificar a una persona; para solucionarlo utilizamos generalización y supresión con k-anonimato. Por último, los datos históricos con más de 5 años de antigüedad deben resguardarse y depurarse para cumplir con las políticas de retención, reducir la superficie de ataque y evitar guardar información innecesaria, lo cual respaldamos mediante tablas de seguridad y bitácoras de auditoría.

# 19.2 Enmascaramiento 
Se ocultaron los datos personales e identificadores directos de los clientes (nombre, correo, teléfono, RFC e ID original), además de la precisión exacta de la edad y del código postal. Esto se hizo para el rol de usuario analista y el área de dirección, quienes únicamente requerían consultar información estadística agregada y no la identidad individual de cada cliente. La razón de ocultarlo fue reducir el riesgo de reidentificación, proteger la privacidad de las personas ante posibles filtraciones y aplicar el principio de mínimo privilegio. Los mecanismos utilizados fueron el control de acceso basado en roles (RBAC) para denegar el acceso a la tabla base public.clientes y al mapa de tokens (pii.mapa_cliente), combinado con técnicas de seudonimización, enmascaramiento en vistas, generalización de datos por rangos o regiones y supresión de grupos reducidos mediante $k$-anonimato (HAVING COUNT(*) >= k).

# 19.3 Seudonimización
Cómo se generaron los tokens: Se sustituyeron los identificadores reales (como el ID original o el RFC) por valores alfanuméricos aleatorios o tokens únicos mediante scripts de seudonimización, permitiendo referenciar al cliente sin exponer su identidad real.

Dónde está el mapa de correspondencia: Se guardó en una tabla de alta seguridad aislada dentro de un esquema restringido, específicamente en pii.mapa_cliente.

Quién debe acceder a él: Únicamente administradores de base de datos (DBA), oficiales de seguridad/protección de datos (DPO) o procesos del sistema autorizados para reidentificación justificada.

Por qué se separaron los permisos: Para aplicar el principio de mínimo privilegio y la separación de funciones. De esta forma, si la cuenta de un analista (como anaalista) o una app de reportes se ven comprometidas, un atacante no podrá cruzar los tokens con la tabla de correspondencia para descubrir a quién pertenecen los datos.

# 19.4 Anonimización
Qué identificadores fueron eliminados: Se eliminaron todos los identificadores directos, como el nombre completo, correo electrónico, número de teléfono, RFC y el id original de cada cliente.

Qué atributos fueron generalizados: Se generalizó la edad (agrupándola en rangos como '18-30' o '18-40') y el código postal (reducido a sus primeros dígitos para mostrar solo la región o macroregión en lugar de la ubicación exacta).

Qué grupos fueron suprimidos: Se suprimieron las combinaciones o grupos pequeños que no alcanzaron el umbral mínimo establecido en la regla de $k$-anonimato (por ejemplo, aquellos con menos de 2 registros filtrados con HAVING COUNT(*) >= 2).

Qué riesgo de reidentificación permanece: Permanece un riesgo residual por vinculación (linkage attack), ya que si un atacante cruza el rango de edad y la macroregión con fuentes externas públicas (como un censo o padrón), o si tiene conocimiento previo del usuario, podría llegar a deducir su identidad.

# 19.5 Retención
Qué criterio se utilizó: Un criterio temporal de antigüedad de 5 años basado en la fecha de alta del cliente (fecha_alta < CURRENT_DATE - INTERVAL '5 years'), alineado con normativas legales, fiscales y políticas internas de conservación de datos.

Qué información debería conservarse: Los registros de clientes activos, la información con menos de 5 años de antigüedad y las bitácoras de auditoría que documentan los procesos de depuración realizador.

Qué información podría eliminarse: Los registros de clientes antiguos que hayan superado el plazo de 5 años y que ya no tengan relaciones comerciales activas ni requerimientos legales vigentes.

Qué controles deberían existir antes de eliminarla: Generación de un respaldo previo de los datos (como la tabla clientes_depurados_backup), aprobación formal por escrito del Oficial de Protección de Datos (DPO) o área legal, y el registro obligatorio de la acción en una bitácora de auditoría auditable (bitacora_retencion).

# 19.6 Conclusiones
Para un área de soporte: Enmascaramiento de datos (o Tokenización). Permite a los agentes validar la identidad o buscar a un cliente usando un token o mostrando solo fragmentos del dato (por ejemplo, los últimos 4 dígitos del teléfono o correo parcialmente oculto), sin exponer la información personal completa.

Para un área de analítica: Seudonimización y Generalización (con $k$-anonimato). Sustituye los nombres por tokens e identifica clientes por rangos (como grupos de edad o macroregiones). De esta forma, el área puede analizar tendencias y patrones de negocio sin necesidad de conocer la identidad real del usuario.

Para publicar estadísticas: Anonimización total (con supresión estricta). Elimina cualquier identificador directo y agrupa los datos en conjuntos grandes donde sea matemáticamente imposible reidentificar a un individuo ($k$-anonimato alto o privacidad diferencial), eliminando grupos pequeños que puedan revelar casos aislados.

Por qué no sustituyen al control de acceso: Porque las técnicas de privacidad (enmascaramiento, seudonimización o anonimización) se encargan de cómo se presentan los datos, mientras que el control de acceso (RBAC) define quién tiene permiso para conectarse y ejecutar acciones. Sin control de acceso, cualquier usuario o atacante podría brincarse las vistas protegidas y consultar directamente las tablas base donde se encuentra la información original.

# 20. Preguntas de reflexión
¿Cuál es la diferencia entre enmascaramiento y seudonimización? El enmascaramiento oculta parcialmente un dato para su visualización (ej. j***@gmail.com), mientras que la seudonimización reemplaza el identificador por un código o token aleatorio que mantiene consistencia y permite reversibilidad mediante un mapa seguro.

¿Por qué la seudonimización no significa anonimización? Porque es reversible. Si se obtiene acceso a la tabla de correspondencia o clave de mapeo, es posible volver a identificar a la persona original. La anonimización es un proceso irreversible.

¿Por qué eliminar nombre y RFC no garantiza que un conjunto de datos sea anónimo? Porque permanecen los cuasi-identificadores (como fecha de nacimiento, código postal o género) que, al cruzarse entre sí o con fuentes de datos externas, permiten reidentificar a una persona (linkage attack).

¿Qué función tienen los cuasi-identificadores? Son atributos que por sí solos no identifican a un sujeto, pero que al combinarse reducen el grupo de búsqueda hasta señalar de forma única a un individuo.

¿Por qué es importante separar el mapa de seudonimización? Evita que una vulnerabilidad o acceso no autorizado en la base de datos analítica comprometa de inmediato las identidades reales, manteniendo las equivalencias en un esquema aislado (pii.mapa_cliente).

¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa? El principio de mínimo privilegio y la separación de funciones, asegurando que el analista solo acceda a los datos indispensables para su tarea sin poder reidentificar usuarios.

¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla? Funciona como una capa de abstracción y filtro: permite ocultar columnas sensibles, aplicar máscaras o generalizaciones en tiempo real y revocar permisos sobre la tabla base subyacente.

¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado? La protección para visualización controla cómo se muestra la información (formato/enmascaramiento), mientras que el control de acceso (RBAC) determina quién tiene autorización para consultar o manipular los objetos en la base de datos.

¿Por qué la retención forma parte de la protección de datos? Garantiza el cumplimiento del principio de limitación del plazo de conservación, asegurando que la información personal no se conserve más tiempo del legalmente necesario.

¿Qué riesgo existe si una organización conserva información indefinidamente? Incrementa innecesariamente la superficie de ataque, aumenta el impacto ante un robo o filtración de datos y genera incumplimiento normativo sujeto a sanciones legales.
