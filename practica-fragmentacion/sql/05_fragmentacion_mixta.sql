
-- SECCIÓN PARA NODO: pg-campus Públicos - Quevedo

DROP TABLE IF EXISTS clientes_pub_quevedo;

CREATE TABLE clientes_pub_quevedo (
                                      cliente_id  INTEGER     PRIMARY KEY,
                                      nombre      VARCHAR(80) NOT NULL,
                                      ciudad      VARCHAR(40) NOT NULL
);

-- SECCIÓN PARA NODO: pg-ventanas Públicos - Babahoyo o Ventanas

DROP TABLE IF EXISTS clientes_pub_otros;

CREATE TABLE clientes_pub_otros (
                                    cliente_id  INTEGER     PRIMARY KEY,
                                    nombre      VARCHAR(80) NOT NULL,
                                    ciudad      VARCHAR(40) NOT NULL
);

-- SECCIÓN PARA NODO: pg-babahoyo contacto - Quevedo y Otros

DROP TABLE IF EXISTS clientes_con_quevedo;
DROP TABLE IF EXISTS clientes_con_otros;

CREATE TABLE clientes_con_quevedo (
                                      cliente_id  INTEGER      PRIMARY KEY,
                                      email       VARCHAR(120) NOT NULL,
                                      telefono    VARCHAR(20)
);

CREATE TABLE clientes_con_otros (
                                    cliente_id  INTEGER      PRIMARY KEY,
                                    email       VARCHAR(120) NOT NULL,
                                    telefono    VARCHAR(20)
);