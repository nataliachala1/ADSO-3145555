--liquibase formatted sql

-- ============================================================
-- CHANGELOG: 001-crear-tablas.sql
-- Descripción: Creación de tablas para la BD Pedidos
-- Autor: dev
-- ============================================================

--changeset dev:1 labels:crear-tablas context:base
--comment: Crear tabla cliente
CREATE TABLE cliente (
    id      SERIAL PRIMARY KEY,
    nombre  VARCHAR(100) NOT NULL,
    correo  VARCHAR(100) UNIQUE NOT NULL
);

--changeset dev:2 labels:crear-tablas context:base
--comment: Crear tabla producto
CREATE TABLE producto (
    id      SERIAL PRIMARY KEY,
    nombre  VARCHAR(100) NOT NULL,
    precio  NUMERIC(10,2) NOT NULL
);

--changeset dev:3 labels:crear-tablas context:base
--comment: Crear tabla pedido (depende de cliente y producto)
CREATE TABLE pedido (
    id          SERIAL PRIMARY KEY,
    cliente_id  INT,
    producto_id INT,
    cantidad    INT NOT NULL,
    fecha       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(id),

    CONSTRAINT fk_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto(id)
);