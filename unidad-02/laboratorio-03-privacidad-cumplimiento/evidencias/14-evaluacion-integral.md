# Evidencia 14
## Diferenciar controles técnicos y administrativos
| **Medida** | **Técnico** | **Administrativo** |
|---|:---:|:---:|
| Crear roles de PostgreSQL | X | |
| Política de retención | | X |
| Cifrado de datos | X | |
| Procedimiento para solicitudes ARCO | | X |
| Vista con información limitada | X | |
| Clasificación de información | | X |
| Registro de auditoría | X | |
| Política de control de acceso | | X |

## Escenario integral
| **Problema** | **Principio afectado** | **Riesgo** | **Control propuesto** |
|---|---|---|---|
| Analítica tiene acceso directo a toda la tabla `clientes` | Mínimo privilegio | Exposición de datos personales innecesarios | Crear roles y vistas con información limitada para analítica |
| Analítica puede consultar nombres, correos, teléfonos y RFC | Minimización de datos | Uso indebido o filtración de información personal | Proporcionar únicamente estadísticas agregadas |
| Los datos se conservan desde hace 12 años | Limitación del plazo de conservación | Acumulación innecesaria de información personal | Revisar los periodos de retención y eliminar o anonimizar datos que ya no sean necesarios |
| No existe una política documentada de retención | Responsabilidad y rendición de cuentas | Conservación indefinida de datos sin justificación | Crear y documentar una política de retención |
| Los desarrolladores reciben copias completas de la base de datos | Mínimo privilegio | Acceso excesivo a información de clientes | Entregar únicamente los datos necesarios para las pruebas |
| Las copias de desarrollo contienen información real | Privacidad desde el diseño | Filtración de datos personales fuera del entorno productivo | Utilizar datos ficticios o anonimizar los datos antes de copiarlos |
| Marketing utiliza los correos para campañas promocionales sin una finalidad documentada | Limitación de la finalidad | Uso de datos para propósitos no informados o no autorizados | Verificar la finalidad permitida y los requisitos de consentimiento aplicables |
| No existe documentación clara sobre la finalidad de cada dato | Transparencia y limitación de la finalidad | Uso de información sin justificación clara | Documentar la finalidad de cada campo y su responsable |
| No se especifica quién puede acceder a los datos personales | Control de acceso y confidencialidad | Accesos no autorizados o abuso de privilegios | Definir permisos por roles y revisar periódicamente los accesos |
| No se menciona un mecanismo de auditoría de consultas | Responsabilidad y trazabilidad | Dificultad para detectar e investigar accesos indebidos | Registrar y revisar los accesos y las operaciones relevantes |
| Se conservan datos personales sin evaluar si siguen siendo necesarios | Minimización de datos | Mayor impacto en caso de una filtración | Revisar periódicamente los datos almacenados y eliminar los innecesarios |
| No se especifican controles de protección para las copias de desarrollo | Seguridad y confidencialidad | Robo, pérdida o divulgación de información | Restringir el acceso, cifrar las copias y establecer procedimientos seguros de eliminación |

