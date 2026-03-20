-- DATA.SQL - Datos de prueba
-- Sistema de Gestión de Ventas

USE tienda;

-- CATEGORÍAS
INSERT INTO categorias (nombre) VALUES
('Electrónica'),
('Ropa'),
('Hogar'),
('Deportes');

-- PRODUCTOS
INSERT INTO productos (nombre, precio, stock, categoria_id) VALUES
('Notebook Lenovo', 1500.00, 10, 1),
('Mouse Logitech', 25.50, 100, 1),
('Teclado Mecánico', 80.00, 50, 1),
('Remera Básica', 15.00, 200, 2),
('Zapatillas Running', 120.00, 30, 4),
('Silla de Oficina', 200.00, 20, 3),
('Lámpara LED', 35.00, 60, 3),
('Pelota de Fútbol', 25.00, 40, 4);

-- CLIENTES
INSERT INTO clientes (nombre, email, telefono) VALUES
('Carlos Gómez', 'carlos@mail.com', '111111111'),
('Lucía Fernández', 'lucia@mail.com', '222222222'),
('Martín Rodríguez', 'martin@mail.com', '333333333'),
('Sofía Martínez', 'sofia@mail.com', '444444444'),
('Diego Sánchez', 'diego@mail.com', '555555555');

-- PEDIDOS
INSERT INTO pedidos (cliente_id, estado, fecha) VALUES
(1, 'Pagado', '2026-01-10 10:00:00'),
(2, 'Pendiente', '2026-01-11 12:30:00'),
(3, 'Enviado', '2026-01-12 15:45:00'),
(1, 'Pagado', '2026-02-01 09:20:00'),
(4, 'Cancelado', '2026-02-05 18:10:00');

-- DETALLE DE PEDIDOS
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
-- Pedido 1
(1, 1, 1, 1500.00),
(1, 2, 2, 25.50),

-- Pedido 2
(2, 4, 3, 15.00),

-- Pedido 3
(3, 5, 1, 120.00),
(3, 8, 2, 25.00),

-- Pedido 4
(4, 3, 1, 80.00),
(4, 7, 2, 35.00),

-- Pedido 5
(5, 6, 1, 200.00);

-- PAGOS
INSERT INTO pagos (pedido_id, monto, metodo, fecha) VALUES
(1, 1551.00, 'Tarjeta', '2026-01-10 10:05:00'),
(3, 170.00, 'Transferencia', '2026-01-12 16:00:00'),
(4, 150.00, 'Efectivo', '2026-02-01 09:30:00');
