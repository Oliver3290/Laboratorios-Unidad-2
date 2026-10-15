SELECT
    id,
    nombre,
    correo,
    telefono,
    rfc,
    edad,
    ciudad,
    codigo_postal,
    fecha_alta
FROM clientes
WHERE id = 1;

UPDATE clientes
SET correo = 'nuevo-correo@example.com'
WHERE id = 1;

UPDATE clientes
SET correo = 'nuevo-correo@example.com'
WHERE id = 1;

SELECT
    id,
    nombre,
    correo
FROM clientes
WHERE id = 1;

