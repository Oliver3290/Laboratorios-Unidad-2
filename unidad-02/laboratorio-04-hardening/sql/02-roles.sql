SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;

SELECT
    rolname,
    rolsuper,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
WHERE rolsuper = true
   OR rolcreaterole = true
   OR rolcreatedb = true
ORDER BY rolname;

SELECT
    rolname,
    rolsuper,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
WHERE rolcanlogin = true
ORDER BY rolname;

