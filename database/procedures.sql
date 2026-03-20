-- PROCEDURES.SQL - Stored Procedures
-- Sistema de Gestión de Ventas

USE tienda;

DELIMITER //

-- 1. Registrar un pedido completo
CREATE PROCEDURE sp_registrar_pedido(
    IN p_cliente_id INT,
    IN p_producto_id INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_pedido_id INT;

    -- Obtener precio y stock
    SELECT precio, stock INTO v_precio, v_stock
    FROM productos
    WHERE id = p_producto_id;

    -- Validar stock
    IF v_stock < p_cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    -- Crear pedido
    INSERT INTO pedidos (cliente_id, estado)
    VALUES (p_cliente_id, 'Pendiente');

    SET v_pedido_id = LAST_INSERT_ID();

    -- Insertar detalle
    INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
    VALUES (v_pedido_id, p_producto_id, p_cantidad, v_precio);

END //

-- 2. Registrar pago
CREATE PROCEDURE sp_registrar_pago(
    IN p_pedido_id INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo VARCHAR(50)
)
BEGIN
    INSERT INTO pagos (pedido_id, monto, metodo)
    VALUES (p_pedido_id, p_monto, p_metodo);

    -- Actualizar estado del pedido
    UPDATE pedidos
    SET estado = 'Pagado'
    WHERE id = p_pedido_id;
END //

-- 3. Obtener total de un pedido
CREATE PROCEDURE sp_total_pedido(
    IN p_pedido_id INT
)
BEGIN
    SELECT 
        p_pedido_id AS pedido_id,
        SUM(cantidad * precio_unitario) AS total
    FROM detalle_pedido
    WHERE pedido_id = p_pedido_id
    GROUP BY pedido_id;
END //

-- 4. Listar pedidos de un cliente
CREATE PROCEDURE sp_pedidos_cliente(
    IN p_cliente_id INT
)
BEGIN
    SELECT 
        pe.id,
        pe.fecha,
        pe.estado,
        SUM(dp.cantidad * dp.precio_unitario) AS total
    FROM pedidos pe
    JOIN detalle_pedido dp ON pe.id = dp.pedido_id
    WHERE pe.cliente_id = p_cliente_id
    GROUP BY pe.id
    ORDER BY pe.fecha DESC;
END //

-- 5. Actualizar stock manualmente
CREATE PROCEDURE sp_actualizar_stock(
    IN p_producto_id INT,
    IN p_nuevo_stock INT
)
BEGIN
    UPDATE productos
    SET stock = p_nuevo_stock
    WHERE id = p_producto_id;
END //

DELIMITER ;
