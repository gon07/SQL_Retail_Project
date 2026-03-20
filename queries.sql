-- QUERIES.SQL - Consultas 
-- Sistema de Gestión de Ventas

USE tienda;

-- 1. Total gastado por cliente
SELECT 
    c.id,
    c.nombre,
    SUM(p.monto) AS total_gastado
FROM clientes c
JOIN pedidos pe ON c.id = pe.cliente_id
JOIN pagos p ON pe.id = p.pedido_id
GROUP BY c.id, c.nombre
ORDER BY total_gastado DESC;

-- 2. Productos más vendidos
SELECT 
    pr.id,
    pr.nombre,
    SUM(dp.cantidad) AS total_vendido
FROM detalle_pedido dp
JOIN productos pr ON dp.producto_id = pr.id
GROUP BY pr.id, pr.nombre
ORDER BY total_vendido DESC;

-- 3. Total por pedido
SELECT 
    pe.id AS pedido_id,
    SUM(dp.cantidad * dp.precio_unitario) AS total_pedido
FROM pedidos pe
JOIN detalle_pedido dp ON pe.id = dp.pedido_id
GROUP BY pe.id
ORDER BY total_pedido DESC;

-- 4. Clientes sin pedidos
SELECT 
    c.id,
    c.nombre
FROM clientes c
LEFT JOIN pedidos pe ON c.id = pe.cliente_id
WHERE pe.id IS NULL;

-- 5. Productos con bajo stock (< 20)
SELECT 
    id,
    nombre,
    stock
FROM productos
WHERE stock < 20
ORDER BY stock ASC;

-- 6. Pedidos con información de cliente
SELECT 
    pe.id,
    c.nombre AS cliente,
    pe.fecha,
    pe.estado
FROM pedidos pe
JOIN clientes c ON pe.cliente_id = c.id
ORDER BY pe.fecha DESC;

-- 7. Ingresos por mes
SELECT 
    DATE_FORMAT(fecha, '%Y-%m') AS mes,
    SUM(monto) AS total_ingresos
FROM pagos
GROUP BY mes
ORDER BY mes;

-- 8. Producto más caro por categoría
SELECT 
    c.nombre AS categoria,
    p.nombre AS producto,
    p.precio
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.precio = (
    SELECT MAX(p2.precio)
    FROM productos p2
    WHERE p2.categoria_id = p.categoria_id
);

-- 9. Promedio de gasto por cliente
SELECT 
    c.nombre,
    AVG(p.monto) AS promedio_pago
FROM clientes c
JOIN pedidos pe ON c.id = pe.cliente_id
JOIN pagos p ON pe.id = p.pedido_id
GROUP BY c.nombre;

-- 10. Pedidos sin pago
SELECT 
    pe.id,
    pe.estado,
    pe.fecha
FROM pedidos pe
LEFT JOIN pagos p ON pe.id = p.pedido_id
WHERE p.id IS NULL;


-- 11. Cantidad de pedidos por estado
SELECT 
    estado,
    COUNT(*) AS cantidad
FROM pedidos
GROUP BY estado;


-- 12. Top 3 clientes que más gastaron
SELECT 
    c.nombre,
    SUM(p.monto) AS total
FROM clientes c
JOIN pedidos pe ON c.id = pe.cliente_id
JOIN pagos p ON pe.id = p.pedido_id
GROUP BY c.nombre
ORDER BY total DESC
LIMIT 3;


-- 13. Total vendido por categoría
SELECT 
    c.nombre AS categoria,
    SUM(dp.cantidad * dp.precio_unitario) AS total_vendido
FROM detalle_pedido dp
JOIN productos p ON dp.producto_id = p.id
JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.nombre
ORDER BY total_vendido DESC;


-- 14. Último pedido de cada cliente
SELECT 
    c.nombre,
    MAX(pe.fecha) AS ultimo_pedido
FROM clientes c
JOIN pedidos pe ON c.id = pe.cliente_id
GROUP BY c.nombre;


-- 15. Detalle completo de ventas
SELECT 
    pe.id AS pedido_id,
    c.nombre AS cliente,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal
FROM detalle_pedido dp
JOIN pedidos pe ON dp.pedido_id = pe.id
JOIN clientes c ON pe.cliente_id = c.id
JOIN productos pr ON dp.producto_id = pr.id
ORDER BY pe.id;