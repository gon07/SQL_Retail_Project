-- TRIGGERS.SQL - Triggers
-- Sistema de Gestión de Ventas

USE tienda;

DELIMITER //

-- 1. Reducir stock al crear detalle de pedido
CREATE TRIGGER trg_reducir_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
END //

-- 2. Evitar stock negativo
CREATE TRIGGER trg_validar_stock
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    SELECT stock INTO v_stock
    FROM productos
    WHERE id = NEW.producto_id;

    IF v_stock < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: stock insuficiente';
    END IF;
END //

-- 3. Restaurar stock al eliminar detalle
CREATE TRIGGER trg_restaurar_stock
AFTER DELETE ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock + OLD.cantidad
    WHERE id = OLD.producto_id;
END //


-- 4. Actualizar stock al modificar detalle
CREATE TRIGGER trg_actualizar_stock_update
AFTER UPDATE ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock + OLD.cantidad - NEW.cantidad
    WHERE id = NEW.producto_id;
END //


-- 5. Cambiar estado del pedido a 'Pagado'
-- cuando el total de pagos cubre el total del pedido
CREATE TRIGGER trg_actualizar_estado_pago
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    DECLARE total_pedido DECIMAL(10,2);
    DECLARE total_pagado DECIMAL(10,2);

    -- Total del pedido
    SELECT SUM(cantidad * precio_unitario)
    INTO total_pedido
    FROM detalle_pedido
    WHERE pedido_id = NEW.pedido_id;

    -- Total pagado
    SELECT SUM(monto)
    INTO total_pagado
    FROM pagos
    WHERE pedido_id = NEW.pedido_id;

    -- Comparación
    IF total_pagado >= total_pedido THEN
        UPDATE pedidos
        SET estado = 'Pagado'
        WHERE id = NEW.pedido_id;
    END IF;
END //

DELIMITER ;
