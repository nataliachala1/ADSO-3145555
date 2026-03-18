--liquibase formatted sql

-- ============================================================
-- CHANGELOG: 003-modificar-columnas.sql
-- Descripción: Evolución del esquema de la BD Pedidos
-- Autor: dev
-- ============================================================

--changeset dev:7 labels:modificar-columnas context:evolucion
--comment: Agregar columna telefono a cliente
ALTER TABLE cliente ADD COLUMN telefono VARCHAR(20);

--changeset dev:8 labels:modificar-columnas context:evolucion
--comment: Agregar columna descripcion a producto
ALTER TABLE producto ADD COLUMN descripcion VARCHAR(200);

--changeset dev:9 labels:modificar-columnas context:evolucion
--comment: Agregar columna estado al pedido (pendiente, enviado, entregado)
ALTER TABLE pedido ADD COLUMN estado VARCHAR(20) DEFAULT 'pendiente';

--changeset dev:10 labels:modificar-columnas context:evolucion
--comment: Agregar columna stock a producto
ALTER TABLE producto ADD COLUMN stock INT DEFAULT 0;