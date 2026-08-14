-- CONSULTA 1
-- Vista base del proyecto

SELECT
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

    -- CONSULTA 2
-- Clientes sin ventas

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- CONSULTA 3
-- Productos sin ventas

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
LEFT JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- CONSULTA 4
-- Consolidado por canal
-- Criterio utilizado:
-- cantidad <= 2 = Online
-- cantidad > 2 = Presencial

SELECT
    canal,
    SUM(total_venta) AS total_por_canal
FROM
(
    SELECT
        'Online' AS canal,
        (cantidad * precio_unitario) AS total_venta
    FROM ventas
    WHERE cantidad <= 2

    UNION ALL

    SELECT
        'Presencial' AS canal,
        (cantidad * precio_unitario) AS total_venta
    FROM ventas
    WHERE cantidad > 2
) AS ventas_por_canal
GROUP BY canal;