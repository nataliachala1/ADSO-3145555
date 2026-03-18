CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


INSERT INTO TypeDocument (name, code, description) VALUES
('Cédula de Ciudadanía','CC','Documento nacional colombiano'),
('Tarjeta de Identidad','TI','Documento para menores'),
('Cédula de Extranjería','CE','Documento para extranjeros'),
('Pasaporte','PASS','Documento internacional'),
('Registro Civil','RC','Documento de nacimiento'),
('NIT','NIT','Número de identificación tributaria'),
('Permiso Especial','PEP','Permiso temporal'),
('Documento Nacional','DN','Documento general'),
('Licencia','LIC','Licencia oficial'),
('Otro','OT','Otros documentos');

INSERT INTO Person 
(type_document_id, document_number, first_name, last_name, email, phone)
VALUES
((SELECT id FROM TypeDocument LIMIT 1),'1001','Juan','Perez','juan@mail.com','3001111111'),
((SELECT id FROM TypeDocument LIMIT 1),'1002','Maria','Gomez','maria@mail.com','3002222222'),
((SELECT id FROM TypeDocument LIMIT 1),'1003','Carlos','Lopez','carlos@mail.com','3003333333'),
((SELECT id FROM TypeDocument LIMIT 1),'1004','Ana','Martinez','ana@mail.com','3004444444'),
((SELECT id FROM TypeDocument LIMIT 1),'1005','Luis','Ramirez','luis@mail.com','3005555555'),
((SELECT id FROM TypeDocument LIMIT 1),'1006','Sofia','Torres','sofia@mail.com','3006666666'),
((SELECT id FROM TypeDocument LIMIT 1),'1007','Pedro','Diaz','pedro@mail.com','3007777777'),
((SELECT id FROM TypeDocument LIMIT 1),'1008','Laura','Castro','laura@mail.com','3008888888'),
((SELECT id FROM TypeDocument LIMIT 1),'1009','Diego','Rojas','diego@mail.com','3009999999'),
((SELECT id FROM TypeDocument LIMIT 1),'1010','Camila','Vargas','camila@mail.com','3010000000');

INSERT INTO Supplier (name, ruc, email, phone, address, contact) VALUES
('Proveedor Cafe','900111','prove1@mail.com','3101111111','Bogotá','Carlos Ruiz'),
('Proveedor Leche','900112','prove2@mail.com','3102222222','Medellín','Ana Lopez'),
('Proveedor Azucar','900113','prove3@mail.com','3103333333','Cali','Pedro Diaz'),
('Proveedor Pan','900114','prove4@mail.com','3104444444','Barranquilla','Laura Castro'),
('Proveedor Chocolate','900115','prove5@mail.com','3105555555','Cartagena','Mario Diaz'),
('Proveedor Harina','900116','prove6@mail.com','3106666666','Pasto','Sofia Ruiz'),
('Proveedor Frutas','900117','prove7@mail.com','3107777777','Bucaramanga','Juan Rojas'),
('Proveedor Galletas','900118','prove8@mail.com','3108888888','Manizales','Luis Perez'),
('Proveedor Queso','900119','prove9@mail.com','3109999999','Neiva','Maria Torres'),
('Proveedor Miel','900120','prove10@mail.com','3110000000','Ibagué','Pedro Ramirez');

INSERT INTO Category (name, description) VALUES
('Bebidas','Productos líquidos'),
('Café','Bebidas a base de café'),
('Postres','Dulces'),
('Panadería','Productos de pan'),
('Snacks','Comida rápida'),
('Jugos','Bebidas naturales'),
('Lácteos','Productos de leche'),
('Helados','Postres fríos'),
('Tés','Infusiones'),
('Otros','Productos varios');

INSERT INTO Product (category_id, supplier_id, name, price, cost, unit, sku)
VALUES
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Café Americano',5000,2000,'unit','SKU001'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Capuccino',7000,3000,'unit','SKU002'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Latte',6500,2800,'unit','SKU003'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Mocaccino',7500,3200,'unit','SKU004'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Té Verde',4000,1500,'unit','SKU005'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Jugo Naranja',4500,1800,'unit','SKU006'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Croissant',3500,1500,'unit','SKU007'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Cheesecake',9000,4500,'unit','SKU008'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Brownie',6000,2500,'unit','SKU009'),
((SELECT id FROM Category LIMIT 1),(SELECT id FROM Supplier LIMIT 1),'Helado',5000,2000,'unit','SKU010');

INSERT INTO Inventory (product_id, quantity, min_stock, max_stock)
SELECT id, 100, 10, 500 FROM Product LIMIT 10;

INSERT INTO MethodPayment (name, description) VALUES
('Efectivo','Pago en efectivo'),
('Tarjeta Débito','Pago con tarjeta débito'),
('Tarjeta Crédito','Pago con tarjeta crédito'),
('Transferencia','Transferencia bancaria'),
('Nequi','Pago con Nequi'),
('Daviplata','Pago con Daviplata'),
('PayPal','Pago internacional'),
('QR','Pago con código QR'),
('Crédito','Pago a crédito'),
('Otro','Otro método');

INSERT INTO Role (name, description) VALUES
('Admin','Administrador del sistema'),
('Cajero','Gestión de ventas'),
('Mesero','Toma de pedidos'),
('Inventario','Gestión de productos'),
('Supervisor','Supervisa operaciones'),
('Gerente','Gestión general'),
('Contador','Control financiero'),
('Soporte','Soporte técnico'),
('Cliente','Acceso cliente'),
('Invitado','Acceso limitado');

INSERT INTO Users (person_id, username, password)
SELECT id, 'user'||ROW_NUMBER() OVER(), '123456'
FROM Person
LIMIT 10;

INSERT INTO Module (name, description, icon, route) VALUES
('Security','Gestión de seguridad','lock','/security'),
('Inventory','Gestión de inventario','box','/inventory'),
('Sales','Gestión de ventas','cart','/sales'),
('Billing','Facturación','file','/billing'),
('Reports','Reportes','chart','/reports'),
('Customers','Gestión de clientes','users','/customers'),
('Suppliers','Gestión de proveedores','truck','/suppliers'),
('Products','Gestión de productos','tag','/products'),
('Orders','Gestión de pedidos','list','/orders'),
('Dashboard','Panel principal','home','/dashboard');

INSERT INTO View (module_id, name, description, route)
SELECT id,'Vista'||ROW_NUMBER() OVER(),'Vista del módulo','/view'||ROW_NUMBER() OVER()
FROM Module
LIMIT 10;

INSERT INTO UserRole (user_id, role_id)
SELECT u.id, r.id
FROM Users u
JOIN Role r ON TRUE
LIMIT 10;

INSERT INTO RolModule (role_id, module_id, can_create, can_read, can_update, can_delete)
SELECT r.id, m.id, TRUE, TRUE, TRUE, FALSE
FROM Role r
JOIN Module m ON TRUE
LIMIT 10;

INSERT INTO ModuleView (module_id, view_id)
SELECT m.id, v.id
FROM Module m
JOIN View v ON TRUE
LIMIT 10;

INSERT INTO Customer (person_id, loyalty_points, notes)
SELECT id, 0, 'Cliente frecuente'
FROM Person
LIMIT 10;

INSERT INTO "Order" (customer_id, user_id, table_number, subtotal, discount, total)
SELECT 
(SELECT id FROM Customer LIMIT 1),
(SELECT id FROM Users LIMIT 1),
1, 20000, 0, 20000
FROM generate_series(1,10);

INSERT INTO OrderItem (order_id, product_id, quantity, unit_price, subtotal)
SELECT 
(SELECT id FROM "Order" LIMIT 1),
(SELECT id FROM Product LIMIT 1),
2, 5000, 10000
FROM generate_series(1,10);

INSERT INTO Invoice (order_id, customer_id, invoice_number, subtotal, tax_amount, total)
SELECT 
id,
(SELECT id FROM Customer LIMIT 1),
'FAC'||ROW_NUMBER() OVER(),
20000,
3600,
23600
FROM "Order"
LIMIT 10;

INSERT INTO InvoiceItem (invoice_id, product_id, quantity, unit_price, subtotal)
SELECT 
(SELECT id FROM Invoice LIMIT 1),
(SELECT id FROM Product LIMIT 1),
2, 5000, 10000
FROM generate_series(1,10);

INSERT INTO Payment (invoice_id, method_payment_id, amount, reference)
SELECT 
(SELECT id FROM Invoice LIMIT 1),
(SELECT id FROM MethodPayment LIMIT 1),
23600,
'PAY'||ROW_NUMBER() OVER()
FROM generate_series(1,10);