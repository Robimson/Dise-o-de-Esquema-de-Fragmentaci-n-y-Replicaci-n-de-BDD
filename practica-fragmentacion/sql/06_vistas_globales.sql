
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 1. CREACIÓN DE SERVIDORES REMOTOS conexiones internas en Docker

-- Usamos el puerto interno '5432' de la red interna de Docker, no los externos.
CREATE SERVER srv_babahoyo
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'pg-babahoyo', dbname 'cafeteria', port '5432');

CREATE SERVER srv_ventanas
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'pg-ventanas', dbname 'cafeteria', port '5432');


-- 2. MAPEOS DE USUARIO (Credenciales para acceder a los nodos remotos)

CREATE USER MAPPING FOR admin SERVER srv_babahoyo
OPTIONS (user 'admin', password 'admin123');

CREATE USER MAPPING FOR admin SERVER srv_ventanas
OPTIONS (user 'admin', password 'admin123');

-- 3. TABLAS FORÁNEAS representación local de las tablas de otros nodos

-- Tablas de pedidos en Babahoyo y Ventanas para pedidos_global
CREATE FOREIGN TABLE pedidos_babahoyo (
    pedido_id   INTEGER,
    cliente_id  INTEGER,
    producto_id INTEGER,
    fecha       DATE,
    monto       NUMERIC(8,2),
    sede        VARCHAR(20)
) SERVER srv_babahoyo OPTIONS (table_name 'pedidos');

CREATE FOREIGN TABLE pedidos_ventanas (
    pedido_id   INTEGER,
    cliente_id  INTEGER,
    producto_id INTEGER,
    fecha       DATE,
    monto       NUMERIC(8,2),
    sede        VARCHAR(20)
) SERVER srv_ventanas OPTIONS (table_name 'pedidos');

-- Tabla de contactos en Babahoyo para clientes_global
CREATE FOREIGN TABLE clientes_contacto_remota (
    cliente_id  INTEGER,
    email       VARCHAR(120),
    telefono    VARCHAR(20)
) SERVER srv_babahoyo OPTIONS (table_name 'clientes_contacto');

-- 4. VISTAS GLOBALES DE RECONSTRUCCIÓN

-- Vista global para Pedidos reconstrucción Horizontal con UNION ALL
CREATE VIEW pedidos_global AS
SELECT * FROM pedidos
UNION ALL
SELECT * FROM pedidos_babahoyo
UNION ALL
SELECT * FROM pedidos_ventanas;

-- Vista global para Clientes reconstrucción Vertical con JOIN
CREATE VIEW clientes_global AS
SELECT p.cliente_id, p.nombre, p.ciudad, c.email, c.telefono
FROM clientes_publicos p
         JOIN clientes_contacto_remota c USING (cliente_id);
