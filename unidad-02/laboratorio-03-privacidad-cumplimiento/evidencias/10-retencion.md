# Evidencia 10
## Derecho de oposición
**¿Es necesario eliminar inmediatamente todos sus datos de la base?**

No, porque la solicitud se refiere a una finalidad específica y no necesariamente a todos los usos de los datos.

**1. ¿Qué información podría necesitar mantenerse?**

Los datos necesarios para cumplir obligaciones legales, fiscales o administrativas, así como los registros de operaciones que deban conservarse.

**2. ¿Qué información podría dejar de utilizarse para determinada finalidad?**

Los datos que se utilizan para actividades secundarias, como publicidad personalizada o análisis comerciales, cuando ya no esté permitido utilizarlos para esa finalidad.

**3. ¿Qué mecanismos técnicos podrían separar finalidades?**

Se pueden utilizar permisos por roles, vistas de SQL, restricciones de acceso, controles de consentimiento y sistemas separados para cada finalidad.

**4. ¿Por qué la decisión final no debe ser tomada únicamente por el DBA?**

Porque el DBA conoce la parte técnica, pero la decisión también puede involucrar obligaciones legales, políticas de privacidad y necesidades del negocio. Por eso, deben participar las áreas responsables de privacidad, legal y administración.

## Política de retención
#### Pregunta 1. ¿Es compatible con el principio de minimización?

No, porque este principio establece que solo deben recopilarse y conservarse los datos necesarios para una finalidad específica. Guardarlos indefinidamente sin una justificación no cumple con este principio.

#### Pregunta 2. ¿Qué riesgos genera conservar información innecesaria?

Aumenta el riesgo de filtraciones, accesos no autorizados, robo de identidad y uso indebido de los datos. Además, incrementa los costos de almacenamiento y las responsabilidades de la organización.

#### Pregunta 3. ¿Qué debería determinar la organización antes de establecer un periodo de retención?

Debe determinar la finalidad de los datos, el tiempo durante el cual son necesarios, las obligaciones legales aplicables y si existe alguna razón válida para conservarlos por más tiempo.

#### Pregunta 4. ¿Qué información debería documentarse para justificar el periodo seleccionado?

Debe documentarse la finalidad del tratamiento, los tipos de datos conservados, el periodo de retención, las razones de su elección, las obligaciones legales relacionadas y el procedimiento para eliminar o anonimizar los datos cuando dejen de ser necesarios.