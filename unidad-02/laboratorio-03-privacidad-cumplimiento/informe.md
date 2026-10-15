# Laboratorio 03 — Privacidad y cumplimiento
## Verificación final
#### Privacidad

**¿Qué diferencia existe entre seguridad de la información y privacidad?**

La seguridad protege la información contra accesos no autorizados, mientras que la privacidad establece cómo deben recopilarse, utilizarse y conservarse los datos personales.

#### Finalidad

**¿Por qué una organización no debería utilizar automáticamente todos los datos que posee para cualquier propósito?**

Porque los datos deben utilizarse para finalidades justificadas y compatibles con las que se informaron a los titulares. Usarlos para otros propósitos podría afectar su privacidad.

#### Minimización

**¿Por qué almacenar más información no necesariamente es mejor?**

Porque aumenta el riesgo de filtraciones, el costo de almacenamiento y la posibilidad de utilizar indebidamente datos que no son necesarios.

#### ARCO

**¿Qué implicaciones técnicas tienen los derechos de acceso, rectificación, cancelación y oposición?**

Se necesitan mecanismos para localizar los datos de una persona, corregirlos, gestionar su eliminación cuando corresponda y limitar u oponerse a determinados usos de su información.

#### Retención

**¿Por qué la conservación indefinida puede representar un riesgo?**

Porque los datos pueden quedar expuestos durante más tiempo, incluso cuando ya no son necesarios, aumentando el riesgo de filtraciones y usos indebidos.

#### Gobierno

**¿Quién debería decidir qué datos pueden utilizarse y para qué finalidad?**

Las áreas responsables del negocio, privacidad y legal deben definir las finalidades y condiciones de uso, con participación de las áreas técnicas.

#### DBA

**¿Cuál es la responsabilidad del DBA y cuáles decisiones deben involucrar a otras áreas?**

El DBA debe administrar la base de datos, configurar permisos, proteger la información, mantener respaldos y registrar actividades relevantes. Las decisiones sobre finalidades, periodos de retención y cumplimiento legal deben involucrar también a las áreas de privacidad, legal y administración.

# Informe final
# 1. Introducción

En esta práctica se analizó cómo proteger la privacidad de los clientes dentro de una base de datos. Se identificaron riesgos relacionados con el acceso excesivo a la información, el uso de datos para finalidades diferentes, la conservación indefinida y el manejo de copias con información real. El objetivo es proponer medidas técnicas y administrativas para proteger los datos personales.

# 2. Inventario de datos

Se identificaron los siguientes campos en la tabla `clientes`:

| **Dato** | **Clasificación** | **Protección recomendada** |
|---|---|---|
| id | Identificador del registro | Control de acceso |
| nombre | Dato personal | Acceso restringido |
| correo | Dato personal | Acceso restringido y protección contra exposición |
| telefono | Dato personal | Acceso restringido |
| rfc | Dato personal de identificación fiscal | Acceso muy restringido y cifrado cuando corresponda |
| edad | Dato personal si se relaciona con una persona | Limitar su uso y preferir rangos de edad |
| ciudad | Dato personal cuando se relaciona con un cliente | Utilizar datos agregados para analítica |
| codigo_postal | Dato personal cuando permite relacionar información con una persona | Limitar el acceso y su uso |
| fecha_alta | Dato que puede relacionarse con una persona | Acceso según la función |
| direccion | Dato personal de ubicación | Acceso restringido |
| fecha_nacimiento | Dato personal | Acceso restringido y justificación de su necesidad |
| ocupacion | Dato personal | Recopilar solo si es necesario |
| salario | Dato personal de carácter económico | Acceso muy restringido |
| estado_civil | Dato personal | Recopilar solo si existe una finalidad justificada |

# 3. Finalidades

Los datos deben utilizarse para propósitos específicos y justificados.

- **Operación:** administrar las cuentas y atender las solicitudes de los clientes.
- **Facturación:** utilizar los datos fiscales necesarios para emitir comprobantes.
- **Analítica:** generar estadísticas mediante información agregada o anonimizada.
- **Marketing:** utilizar datos para promociones únicamente cuando exista una finalidad permitida y se cumplan los requisitos aplicables.
- **Auditoría:** revisar accesos, modificaciones y actividades relevantes para la seguridad.

No todos los departamentos necesitan consultar la información completa de los clientes.

# 4. Minimización

Se deben recopilar y conservar únicamente los datos necesarios para cada finalidad. Por ejemplo, analítica puede utilizar ciudad y rangos de edad sin conocer los nombres, correos, teléfonos o RFC.

Los campos como salario, ocupación, estado civil y fecha de nacimiento deberían eliminarse del diseño inicial si no existe una necesidad concreta que justifique su recopilación. También se deben limitar las copias de la base de datos utilizadas por los desarrolladores y preferir datos ficticios para las pruebas.

# 5. Control de acceso

Los permisos deben asignarse según las funciones de cada área, aplicando el principio de mínimo privilegio.

| **Rol** | **Acceso propuesto** |
|---|---|
| Atención al cliente | Nombre, correo, teléfono y datos necesarios para atender solicitudes |
| Facturación | Nombre y datos fiscales necesarios |
| Analítica | Vistas con datos agregados o anonimizados |
| Marketing | Información mínima necesaria para campañas autorizadas |
| DBA | Permisos administrativos necesarios para mantener y proteger la base de datos |
| Dirección | Reportes e indicadores necesarios para tomar decisiones |
| Auditoría | Registros de actividad y evidencias necesarias para las revisiones |

Se pueden utilizar roles de PostgreSQL, vistas con información limitada y registros de auditoría para controlar y revisar los accesos.

# 6. Derechos ARCO

Los derechos de acceso, rectificación, cancelación y oposición tienen implicaciones técnicas para la administración de los datos personales.

- **Acceso:** permitir localizar y entregar los datos correspondientes al titular después de verificar su identidad.
- **Rectificación:** actualizar datos incorrectos y registrar quién realizó el cambio.
- **Cancelación:** identificar los datos relacionados, revisar sus dependencias y gestionar su eliminación o bloqueo cuando corresponda.
- **Oposición:** limitar o detener determinados usos de los datos cuando proceda.

También se deben revisar respaldos, réplicas, reportes, exportaciones y sistemas externos para conocer dónde existen copias de la información.

# 7. Retención

La organización debe establecer periodos de conservación según la finalidad de los datos, las necesidades operativas y las obligaciones legales aplicables.

No se deben conservar todos los datos indefinidamente solo porque podrían ser útiles en el futuro. Cuando la información deje de ser necesaria y no exista una razón válida para conservarla, se debe eliminar o anonimizar de manera segura.

La política de retención debe documentar los plazos, los responsables y los procedimientos para gestionar los datos al finalizar cada periodo.

# 8. Gobierno de datos

La responsabilidad debe distribuirse entre las áreas técnicas y administrativas.

| **Actividad** | **Responsable principal** | **Apoyo** |
|---|---|---|
| Definir finalidades de uso | Área responsable del servicio | Privacidad y área legal |
| Clasificar los datos | Responsable de datos | Privacidad y DBA |
| Configurar permisos | DBA | Seguridad informática |
| Definir periodos de retención | Área responsable del servicio | Legal, privacidad y DBA |
| Proteger copias de desarrollo | Desarrollo y seguridad informática | DBA |
| Atender solicitudes ARCO | Área responsable de privacidad | Atención al cliente, legal y DBA |
| Revisar auditorías | Seguridad informática o auditoría | DBA |
| Autorizar campañas promocionales | Área responsable de marketing | Privacidad y área legal |

El DBA es responsable de implementar y mantener los controles técnicos, pero no debe decidir por sí solo todas las finalidades de uso ni las obligaciones legales.

# 9. Evaluación integral

| **Riesgo identificado** | **Impacto posible** | **Control propuesto** |
|---|---|---|
| Analítica accede a toda la tabla | Exposición innecesaria de datos personales | Crear vistas limitadas |
| Retención de datos durante 12 años sin política documentada | Conservación excesiva | Definir plazos y revisar los datos almacenados |
| Copias reales en desarrollo | Filtración de información de clientes | Utilizar datos ficticios o anonimizados |
| Marketing utiliza correos sin una finalidad documentada | Uso no autorizado de datos | Verificar las finalidades y requisitos aplicables |
| Accesos excesivos de empleados | Consulta indebida de información | Aplicar mínimo privilegio |
| No existe documentación de finalidades | Uso de datos sin justificación clara | Crear un inventario de datos y finalidades |
| Falta de trazabilidad | Dificultad para investigar incidentes | Registrar accesos y modificaciones relevantes |
| Copias en respaldos y sistemas externos | La eliminación puede quedar incompleta | Crear un procedimiento que contemple todo el ciclo de vida de los datos |

# 10. Conclusiones

Aprendí que la privacidad y la seguridad están relacionadas, pero no son lo mismo. La seguridad busca proteger la información contra accesos y modificaciones no autorizados, mientras que la privacidad también determina cómo deben recopilarse, utilizarse y conservarse los datos personales.

Una buena administración de bases de datos requiere limitar los permisos, recopilar solo la información necesaria, definir periodos de retención y mantener registros de las actividades importantes. También es necesario que las áreas técnicas, legales y administrativas trabajen juntas para que las decisiones sobre los datos sean justificadas y seguras.

## Preguntas de reflexión

**1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?** No, porque la seguridad protege los datos contra accesos no autorizados, mientras que la privacidad también establece cómo se recopilan, utilizan, comparten y conservan. Una base de datos puede ser segura técnicamente, pero utilizar información personal sin una finalidad justificada.

**2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?** Porque limita el acceso de cada usuario únicamente a los datos que necesita para realizar sus actividades. Así se reduce el riesgo de consultar, modificar o compartir información personal sin autorización.

**3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?** Porque el DBA es responsable de administrar técnicamente la base de datos, pero la finalidad debe definirse con participación del propietario de los datos, el responsable de privacidad y el área jurídica, considerando las necesidades del negocio y los requisitos legales.

**4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?** Porque estas copias pueden contener información personal y confidencial que los desarrolladores no necesitan para programar o realizar pruebas. Es preferible utilizar datos ficticios, anonimizados o limitados a lo necesario.

**5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?** Porque puede contener información real y quedar almacenada en equipos, servidores o entornos con menos controles de seguridad. Si se filtra, podría exponer datos personales de los usuarios.

**6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?** Porque los datos no deben conservarse indefinidamente sin una razón válida. Se deben establecer periodos de conservación y procedimientos para eliminar, bloquear o anonimizar la información cuando ya no sea necesaria, respetando las obligaciones legales aplicables.

**7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?** La privacidad por diseño consiste en considerar la protección de los datos desde la creación del sistema. En las bases de datos implica recopilar solo la información necesaria, definir permisos adecuados, proteger los datos personales y establecer reglas de conservación desde el inicio.

**8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?** Implementaría control de acceso por roles, mínimo privilegio, contraseñas seguras, cifrado de datos y conexiones, respaldos protegidos, registros de auditoría, copias de desarrollo anonimizadas, actualizaciones de seguridad y revisiones periódicas de permisos.

**9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?** Debería conocer dónde se encuentran los datos de la persona, qué tablas y sistemas los contienen, quién puede acceder a ellos, cómo consultarlos o modificarlos y qué respaldos, réplicas o exportaciones podrían estar involucrados. También debe conocer los procedimientos para apoyar solicitudes de acceso, rectificación, cancelación u oposición.

**10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?** El DBA administra las bases de datos e implementa controles técnicos; el responsable de privacidad coordina las medidas para proteger los datos y atender las solicitudes correspondientes; el área jurídica interpreta las obligaciones legales y asesora sobre su cumplimiento; y el propietario de los datos define las necesidades del negocio y las finalidades del tratamiento junto con las áreas responsables, procurando que estén justificadas y documentadas.

