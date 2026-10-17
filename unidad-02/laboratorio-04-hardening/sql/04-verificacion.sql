SHOW ssl;

SHOW ssl_min_protocol_version;

SELECT
    pid,
    usename,
    client_addr,
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();

SELECT
    current_user,
    session_user,
    current_database(),
    inet_server_addr(),
    inet_server_port();

SHOW port;
SHOW listen_addresses;

SHOW password_encryption;
