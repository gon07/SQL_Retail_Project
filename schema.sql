-- SCHEMA.SQL - Sistema de Gestión de Ventas

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS tienda;
USE tienda;

-- TABLA: clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLA: categorias
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);


-- TABLA: productos
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- TABLA: pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente', 'Pagado', 'Enviado', 'Cancelado') DEFAULT 'Pendiente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- TABLA: detalle_pedido
CREATE TABLE detalle_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),

    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (producto_id) REFERENCES productos(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE (pedido_id, producto_id) -- evita duplicados en el mismo pedido
);

-- TABLA: pagos
CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    metodo ENUM('Tarjeta', 'Efectivo', 'Transferencia') NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ÍNDICES (optimización)
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_detalle_pedido_pedido ON detalle_pedido(pedido_id);
CREATE INDEX idx_detalle_pedido_producto ON detalle_pedido(producto_id);
CREATE INDEX idx_pagos_pedido ON pagos(pedido_id);