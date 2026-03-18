--liquibase formatted sql

-- ============================================================
-- CHANGELOG: 002-insertar-datos.sql
-- Descripción: Datos de ejemplo para la BD Pedidos
-- Autor: dev
-- ============================================================

--changeset dev:4 labels:insertar-datos context:base
--comment: Insertar clientes de ejemplo
INSERT INTO cliente (nombre, correo) VALUES ('Carlos Rodríguez', 'carlos@email.com');
INSERT INTO cliente (nombre, correo) VALUES ('Laura Martínez',   'laura@email.com');
INSERT INTO cliente (nombre, correo) VALUES ('Pedro Gómez',      'pedro@email.com');

--changeset dev:5 labels:insertar-datos context:base
--comment: Insertar productos de ejemplo
INSERT INTO producto (nombre, precio) VALUES ('Laptop',       1200.00);
INSERT INTO producto (nombre, precio) VALUES ('Mouse',          25.99);
INSERT INTO producto (nombre, precio) VALUES ('Teclado',        45.50);
INSERT INTO producto (nombre, precio) VALUES ('Monitor',       350.00);

--changeset dev:6 labels:insertar-datos context:base
--comment: Insertar pedidos de ejemplo
INSERT INTO pedido (cliente_id, producto_id, cantidad) VALUES (1, 1, 1);
INSERT INTO pedido (cliente_id, producto_id, cantidad) VALUES (2, 2, 3);
INSERT INTO pedido (cliente_id, producto_id, cantidad) VALUES (3, 3, 2);
INSERT INTO pedido (cliente_id, producto_id, cantidad) VALUES (1, 4, 1);