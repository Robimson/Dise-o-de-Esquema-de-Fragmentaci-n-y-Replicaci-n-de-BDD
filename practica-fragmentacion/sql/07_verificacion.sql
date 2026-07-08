
-- 1) COMPLETITUD

SELECT COUNT(*) AS filas_globales_pedidos FROM pedidos_global;

-- 2) RECONSTRUCCIÓN

SELECT sede, SUM(monto) AS total_ventas
FROM pedidos_global
GROUP BY sede
ORDER BY total_ventas DESC;

-- 3) DISYUNCIÓN (Horizontal)

SELECT pedido_id, COUNT(*) AS veces
FROM pedidos_global
GROUP BY pedido_id
HAVING COUNT(*) > 1;