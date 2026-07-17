--Consulta 1
USE Ventas_Tech_DB;
GO

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

--Consulta 2
SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--Consulta 3
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

--Consulta 4
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE
        WHEN SUM(cantidad * precio_unitario) >
        (
            SELECT AVG(total_mes)
            FROM
            (
                SELECT SUM(cantidad * precio_unitario) AS total_mes
                FROM ventas
                GROUP BY MONTH(fecha_venta)
            ) AS promedio
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM ventas
GROUP BY MONTH(fecha_venta);

--comentarios
-- Hallazgos
-- 1. Durante marzo se registraron 10 pedidos.
-- 2. La facturación total del mes fue de 6444.00.
-- 3. Algunos clientes realizaron más de un pedido, lo que indica clientes recurrentes