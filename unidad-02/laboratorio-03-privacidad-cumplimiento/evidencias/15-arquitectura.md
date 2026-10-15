# Evidencia 15
## Propuesta de arquitectura de datos protegidos
# Propuesta conceptual de arquitectura con privacidad

## 1. Arquitectura propuesta

```text
                    BASE DE DATOS
                          |
          +---------------+---------------+
          |               |               |
          v               v               v
      OPERACIÓN        ANALÍTICA       AUDITORÍA
          |               |               |
          v               v               v
    Datos necesarios   Datos agregados  Registros de
    para el servicio   y anonimizados   actividades
          |               |               |
          v               v               v
    Acceso limitado   Sin datos        Acceso restringido
    por roles          identificables   y trazabilidad
          |               |               |
          +---------------+---------------+
                          |
                          v
                 CONTROLES DE PRIVACIDAD
                          |
          +---------------+---------------+
          |               |               |
          v               v               v
       Retención      Eliminación     Solicitudes
       limitada       segura          de titulares
```

## 2. Controles propuestos

| **Control** | **Decisión técnica** |
|---|---|
| Acceso | Crear roles de PostgreSQL y asignar permisos según las funciones de cada área. |
| Minimización | Permitir que cada área consulte únicamente los campos necesarios para su trabajo. |
| Protección de información sensible | Cifrar los datos sensibles, restringir su acceso y evitar exponerlos en consultas innecesarias. |
| Retención | Definir periodos de conservación según la finalidad y las obligaciones aplicables. |
| Trazabilidad | Registrar accesos y modificaciones importantes para identificar quién realizó cada operación y cuándo. |
| Eliminación | Establecer procedimientos para eliminar o anonimizar datos cuando ya no sean necesarios, considerando respaldos y sistemas relacionados. |
| Atención de solicitudes | Crear un procedimiento para localizar, corregir, consultar o gestionar solicitudes de eliminación de datos personales. |

## 3. Funciones de cada área

- **Operación:** consulta los datos necesarios para atender a los clientes y administrar sus registros.
- **Analítica:** utiliza información agregada o anonimizada para generar estadísticas sin acceder directamente a todos los datos personales.
- **Auditoría:** consulta registros de actividad para revisar accesos, cambios y posibles incidentes de seguridad.

## 4. Conclusión

Esta arquitectura busca separar la información según su finalidad y limitar el acceso de cada área. De esta manera, se reduce la exposición de datos personales, se facilita el cumplimiento de las políticas de retención y se mejora la trazabilidad. Además, se aplican los principios de minimización, mínimo privilegio y privacidad desde el diseño.

