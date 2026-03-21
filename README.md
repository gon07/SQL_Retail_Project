# 🛒 Sistema de Gestión de Ventas (SQL)

Proyecto de base de datos relacional aplicados a un **caso real** de negocio (retail / e-commerce básico).

---

## 📌 Objetivos del proyecto

- Modelar una base de datos en **3FN (Tercera Forma Normal)**
- Implementar relaciones con **claves foráneas**
- Realizar consultas con:
  - JOINs
  - GROUP BY
  - Subqueries
- Uso de:
  - Vistas (VIEW)
  - Stored Procedures
  - Triggers
- Simular lógica real de negocio (ventas, stock, pagos)

---

## 🧱 Estructura del proyecto


sql-retail-project/
	- schema.sql: Definición de la base de datos
	- data.sql: Datos de prueba
	- queries.sql: Consultas SQL intermedias
	- procedures.sql: Stored Procedures
	- triggers.sql: Triggers
	- der.png: Diagrama Entidad-Relación (DER)	
	- README.md: Documentación

---

## 🗄️ Modelo de datos

### Entidades principales:

- **clientes**
- **productos**
- **categorias**
- **pedidos**
- **detalle_pedido**
- **pagos**

---

## 🔗 Relaciones

- Un cliente → muchos pedidos
- Un pedido → muchos productos (detalle_pedido)
- Un producto → pertenece a una categoría
- Un pedido → puede tener uno o más pagos

---

---

# 🧩 Diagrama Entidad-Relación (DER)

El archivo `der.png` incluido en el proyecto representa gráficamente:

- Entidades
- Atributos
- Claves primarias y foráneas
- Relaciones entre tablas

Puede ser generado con herramientas como:
- MySQL Workbench
- draw.io
- dbdiagram.io

---

## ⚙️ Funcionalidades implementadas

### 📊 Consultas
- Total gastado por cliente
- Productos más vendidos
- Ingresos mensuales
- Clientes sin compras
- Pedidos sin pago
- Top clientes

---

### ⚡ Stored Procedures

- `sp_registrar_pedido` → crea pedidos con validación de stock
- `sp_registrar_pago` → registra pagos y actualiza estado
- `sp_total_pedido` → calcula total de un pedido
- `sp_pedidos_cliente` → lista pedidos por cliente
- `sp_actualizar_stock` → modifica stock manualmente

---

### 🔄 Triggers

- Reducción automática de stock
- Validación de stock antes de insertar
- Restauración de stock al eliminar
- Ajuste de stock al actualizar
- Actualización automática del estado del pedido

---

## 🚀 Cómo ejecutar el proyecto

1. Crear base de datos:
SOURCE schema.sql;

Insertar datos:
SOURCE data.sql;

Ejecutar lógica adicional:
SOURCE procedures.sql;
SOURCE triggers.sql;

Probar consultas:
SOURCE queries.sql;

🧪 Ejemplo de uso
CALL sp_registrar_pedido(1, 2, 3);
CALL sp_registrar_pago(1, 75.00, 'Tarjeta');


🛠️ Tecnologías
MySQL / MariaDB
SQL estándar

📌 Autor
Gonzalo Lara
