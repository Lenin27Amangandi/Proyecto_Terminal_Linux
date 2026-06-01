-- ==========================================================
-- 1. CREACIÓN DE LA BASE DE DATOS LOCAL (NODO NORTE)
-- ==========================================================
CREATE DATABASE moodcoffee;
USE moodcoffee;

-- ==========================================================
-- 2. CREACIÓN DE TABLAS VACÍAS (ESTRUCTURA ORIGINAL DEL MER)
-- ==========================================================
CREATE TABLE Estado_Animo (
    id_estado INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    CONSTRAINT PK_Estado_Animo PRIMARY KEY (id_estado)
);

CREATE TABLE Cliente (
    id_cliente INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cedula VARCHAR(10) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    correo VARCHAR(150),
    CONSTRAINT PK_Cliente PRIMARY KEY (id_cliente)
);

CREATE TABLE Sede (
    id_sede INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    CONSTRAINT PK_Sede PRIMARY KEY (id_sede)
);

CREATE TABLE Producto (
    id_producto INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50),
    precio DECIMAL(10, 2) NOT NULL,
    id_estado INT NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_Producto_Estado FOREIGN KEY (id_estado) 
        REFERENCES Estado_Animo(id_estado)
);

CREATE TABLE Consumo (
    id_consumo INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    fecha DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_sede INT NOT NULL,
    CONSTRAINT PK_Consumo PRIMARY KEY (id_consumo),
    CONSTRAINT FK_Consumo_Cliente FOREIGN KEY (id_cliente) 
        REFERENCES Cliente(id_cliente),
    CONSTRAINT FK_Consumo_Sede FOREIGN KEY (id_sede) 
        REFERENCES Sede(id_sede)
);

CREATE TABLE Detalle_Consumo (
    id_consumo INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Detail_Consumo PRIMARY KEY (id_consumo, id_producto),
    CONSTRAINT FK_Detail_Consumo FOREIGN KEY (id_consumo) 
        REFERENCES Consumo(id_consumo) ON DELETE CASCADE,
    CONSTRAINT FK_Detail_Producto FOREIGN KEY (id_producto) 
        REFERENCES Producto(id_producto)
);

-- ==========================================================
-- 3. INSERCIÓN DE DATOS REPLICADOS
-- ==========================================================
INSERT INTO Estado_Animo (id_estado, nombre, descripcion) VALUES
(10, 'Estresado', 'Alta carga de trabajo o estudio, requiere relajación'),
(20, 'Feliz', 'Estado de ánimo alegre, ideal para compartir o celebrar'),
(30, 'Cansado', 'Baja energía, requiere un impulso de cafeína'),
(40, 'Productivo', 'Enfocado en trabajar o estudiar, alta concentración');

INSERT INTO Sede (id_sede, nombre, ciudad, direccion) VALUES
(1, 'Sede Norte', 'Quito', 'Av. Amazonas y Gaspar de Villarroel'),
(2, 'Sede Sur', 'Quito', 'Av. Maldonado y El Recreo');

INSERT INTO Producto (id_producto, nombre, descripcion, tipo, precio, id_estado) VALUES
(501, 'Té de Manzanilla', 'Infusión relajante natural', 'Bebida Caliente', 1.50, 10),
(502, 'Muffin de Chocolate', 'Postre con extra de cacao', 'Pastelería', 2.50, 10),
(503, 'Frappé de Oreo', 'Bebida fría dulce con crema', 'Bebida Fría', 3.50, 20),
(504, 'Americano Doble', 'Café negro intenso para despertar', 'Bebida Caliente', 2.00, 30),
(505, 'Capuccino Vainilla', 'Café con leche espumoso y vainilla', 'Bebida Caliente', 2.80, 40);

-- Clientes con nombres comunes que interactúan en la Sede Norte
INSERT INTO Cliente (id_cliente, nombre, apellido, cedula, telefono, correo) VALUES
(2401, 'José', 'Silva', '1700000001', '0990000001', 'jose.silva@mail.com'),
(2403, 'Manuel', 'Castro', '1700000003', '0990000003', 'manuel.castro@mail.com'),
(2405, 'Francisco', 'Reyes', '1700000005', '0990000005', 'francisco.reyes@mail.com'),
(2407, 'Santiago', 'Mendoza', '1700000007', '0990000007', 'santiago.mendoza@mail.com'),
(2409, 'David', 'Espinoza', '1700000009', '0990000009', 'david.espinoza@mail.com'),
(2411, 'Carmen', 'Torres', '1700000011', '0990000011', 'carmen.torres@mail.com'),
(2413, 'Elena', 'Morales', '1700000013', '0990000013', 'elena.morales@mail.com'),
(2415, 'Martha', 'Herrera', '1700000015', '0990000015', 'martha.herrera@mail.com');

-- ==========================================================
-- 4. FRAGMENTACIÓN HORIZONTAL: 15 REGISTROS EN LA SEDE NORTE (id_sede = 1)
-- ==========================================================

-- 1. Consumo de José Silva
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90101, 4.00, '2026-05-31', 2401, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90101, 501, 1, 1.50);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90101, 502, 1, 2.50);

-- 2. Consumo de Manuel Castro
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90102, 3.50, '2026-05-31', 2403, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90102, 503, 1, 3.50);

-- 3. Consumo de Francisco Reyes
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90103, 2.00, '2026-05-31', 2405, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90103, 504, 1, 2.00);

-- 4. Consumo de Santiago Mendoza
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90104, 2.80, '2026-06-01', 2407, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90104, 505, 1, 2.80);

-- 5. Consumo de David Espinoza
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90105, 5.00, '2026-06-01', 2409, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90105, 502, 2, 5.00);

-- 6. Consumo de Carmen Torres
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90106, 7.00, '2026-06-01', 2411, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90106, 503, 2, 7.00);

-- 7. Consumo de Elena Morales
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90107, 2.00, '2026-06-02', 2413, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90107, 504, 1, 2.00);

-- 8. Consumo de Martha Herrera
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90108, 2.80, '2026-06-02', 2415, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90108, 505, 1, 2.80);

-- 9. Segunda visita de José Silva
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90109, 2.80, '2026-06-02', 2401, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90109, 505, 1, 2.80);

-- 10. Segunda visita de Manuel Castro
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90110, 4.00, '2026-06-03', 2403, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90110, 504, 2, 4.00);

-- 11. Segunda visita de Francisco Reyes
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90111, 4.00, '2026-06-03', 2405, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90111, 501, 1, 1.50);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90111, 502, 1, 2.50);

-- 12. Segunda visita de Santiago Mendoza
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90112, 3.50, '2026-06-03', 2407, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90112, 503, 1, 3.50);

-- 13. Segunda visita de David Espinoza
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90113, 2.00, '2026-06-04', 2409, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90113, 504, 1, 2.00);

-- 14. Segunda visita de Carmen Torres
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90114, 2.80, '2026-06-04', 2411, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90114, 505, 1, 2.80);

-- 15. Segunda visita de Elena Morales
INSERT INTO Consumo (id_consumo, total, fecha, id_cliente, id_sede) VALUES (90115, 1.50, '2026-06-04', 2413, 1);
INSERT INTO Detalle_Consumo (id_consumo, id_producto, cantidad, subtotal) VALUES (90115, 501, 1, 1.50);
