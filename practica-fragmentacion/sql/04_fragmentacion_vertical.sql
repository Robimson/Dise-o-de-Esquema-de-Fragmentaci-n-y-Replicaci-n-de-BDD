
-- SECCIÓN PARA NODO: pg-campus Guarda los datos públicos

DROP TABLE IF EXISTS clientes_publicos;

CREATE TABLE clientes_publicos (
                                   cliente_id  INTEGER     PRIMARY KEY,
                                   nombre      VARCHAR(80) NOT NULL,
                                   ciudad      VARCHAR(40) NOT NULL
);


-- SECCIÓN PARA NODO: pg-babahoyo guarda los datos de contacto

DROP TABLE IF EXISTS clientes_contacto;

CREATE TABLE clientes_contacto (
                                   cliente_id  INTEGER      PRIMARY KEY,
                                   email       VARCHAR(120) NOT NULL,
                                   telefono    VARCHAR(20)
);