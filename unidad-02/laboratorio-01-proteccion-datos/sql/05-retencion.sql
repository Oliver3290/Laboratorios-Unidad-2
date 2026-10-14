SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

SELECT
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2;

SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 2;

SELECT
    CASE
        WHEN edad BETWEEN 18 AND 40 THEN '18-40'
        ELSE '41+'
    END AS rango_edad,
    LEFT(codigo_postal, 1) AS macroregion,
    COUNT(*) AS total
FROM clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 2;

UPDATE clientes 
SET fecha_alta = CURRENT_DATE - INTERVAL '6 years' 
WHERE id IN (SELECT id FROM clientes LIMIT 2);

SELECT *
FROM clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';

CREATE TABLE IF NOT EXISTS clientes_depurados_backup AS
SELECT * 
FROM clientes 
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';

CREATE TABLE IF NOT EXISTS bitacora_retencion (
    id SERIAL PRIMARY KEY,
    fecha_ejecucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario TEXT DEFAULT CURRENT_USER,
    registros_afectados INT,
    folio_aprobacion TEXT,
    motivo TEXT
);

INSERT INTO bitacora_retencion (registros_afectados, folio_aprobacion, motivo)
SELECT 
    COUNT(*), 
    'APROB-DPO-2026-001', 
    'Cumplimiento de política de retención a 5 años'
FROM clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';

SELECT * FROM bitacora_retencion;