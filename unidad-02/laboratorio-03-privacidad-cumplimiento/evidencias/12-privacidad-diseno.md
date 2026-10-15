# Evidencia 12
## Privacidad por diseño
### 1. ¿Qué problemas identificas?

Se recopilan demasiados datos personales sin una finalidad definida. Esto aumenta el riesgo de filtraciones, accesos no autorizados y uso indebido de la información. Además, guardar datos innecesarios genera mayores responsabilidades para la organización.

### 2. ¿Qué principio de privacidad se está ignorando?

El principio de minimización de datos, porque solo deben recopilarse los datos necesarios para cumplir una finalidad específica.

### 3. ¿Qué preguntas realizarías antes de aprobar el diseño?

- ¿Para qué se utilizará cada dato?
- ¿Es realmente necesario solicitarlo?
- ¿Quién tendrá acceso a la información?
- ¿Cuánto tiempo se conservarán los datos?
- ¿Cómo se protegerán?
- ¿Existe una obligación legal o una finalidad válida para recopilarlos?

### 4. ¿Qué datos eliminarías?

Eliminaría inicialmente los campos `salario`, `ocupacion`, `estado_civil` y `fecha_nacimiento` si no existe una finalidad concreta que justifique recopilarlos. También evitaría solicitar `direccion` y `telefono` cuando no sean necesarios para el servicio.

### 5. ¿Qué datos requerirían una justificación adicional?

El RFC, la fecha de nacimiento, el salario, la ocupación, el estado civil y la dirección requieren una justificación clara, porque pueden revelar información sensible para la privacidad o permitir identificar y localizar a una persona.

### 6. ¿Cómo aplicarías privacidad por defecto?

Diseñaría la aplicación para solicitar únicamente los datos indispensables, limitaría los permisos según las funciones de cada usuario, establecería periodos de retención y protegería la información mediante controles de acceso y cifrado. Los campos adicionales solo se habilitarían cuando exista una necesidad justificada.