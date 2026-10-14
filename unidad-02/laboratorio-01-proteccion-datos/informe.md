# Laboratorio 01 — Protección de datos
# Actividad 1 — Clasificación de los datos
## Matriz de Clasificación de Datos (`tabla: clientes`)

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