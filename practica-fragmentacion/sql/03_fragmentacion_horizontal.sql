
-- ESTRUCTURA  PARA  LOS NODOS

-- En pg-campus ejecutaremos un DROP antes de crearla para limpiar la tabla centralizada
DROP TABLE IF EXISTS pedidos;

CREATE TABLE pedidos (
                         pedido_id   INTEGER     PRIMARY KEY,
                         cliente_id  INTEGER     NOT NULL,
                         producto_id INTEGER     NOT NULL,
                         fecha       DATE        NOT NULL,
                         monto       NUMERIC(8,2) NOT NULL,
                         sede        VARCHAR(20) NOT NULL
);


-- INSERTAREMOS SOLO LOS PEDIDOS DE CADA SEDE

-- 1. REGISTROS PARA EL NODO: pg-campus
-- INSERT INTO pedidos VALUES (1, 1, 1, '2026-03-01', 0.75, 'Campus');
-- INSERT INTO pedidos VALUES (3, 3, 2, '2026-03-02', 1.00, 'Campus');
-- INSERT INTO pedidos VALUES (7, 1, 3, '2026-03-04', 2.50, 'Campus');

-- 2. REGISTROS PARA EL NODO: pg-babahoyo
-- INSERT INTO pedidos VALUES (2, 2, 3, '2026-03-01', 2.50, 'Babahoyo');
-- INSERT INTO pedidos VALUES (6, 6, 1, '2026-03-03', 0.75, 'Babahoyo');
-- INSERT INTO pedidos VALUES (8, 2, 2, '2026-03-04', 1.00, 'Babahoyo');

-- 3. REGISTROS PARA EL NODO: pg-ventanas
-- INSERT INTO pedidos VALUES (4, 4, 4, '2026-03-02', 1.25, 'Ventanas');
-- INSERT INTO pedidos VALUES (5, 5, 5, '2026-03-03', 1.00, 'Ventanas');