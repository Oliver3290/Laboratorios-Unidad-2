CREATE ROLE anaalista NOLOGIN;

GRANT USAGE ON SCHEMA analitica TO anaalista;
GRANT SELECT ON analitica.clientes TO anaalista;

REVOKE ALL ON TABLE pii.mapa_cliente FROM anaalista;
REVOKE ALL ON TABLE public.clientes FROM anaalista;

GRANT anaalista TO CURRENT_USER;

SET ROLE anaalista;

SELECT * FROM analitica.clientes;

SELECT * FROM pii.mapa_cliente;

SELECT * FROM public.clientes;

RESET ROLE;