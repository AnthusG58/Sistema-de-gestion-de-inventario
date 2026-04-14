-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS `tienda_db`;
USE `tienda_db`;

-- 2. LIMPIEZA DE TABLAS (En orden inverso a sus relaciones para evitar errores de FK)
DROP TABLE IF EXISTS `detalles_venta`;
DROP TABLE IF EXISTS `ventas`;
DROP TABLE IF EXISTS `empleados`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `productos`;
DROP TABLE IF EXISTS `categorias`;

-- 3. CREACIÓN DE TABLAS INDEPENDIENTES O MAESTRAS

-- Tabla: categorias
CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla: roles
CREATE TABLE `roles` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 4. CREACIÓN DE TABLAS CON RELACIONES (LLAVES FORÁNEAS)

-- Tabla: productos
CREATE TABLE `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `fecha_caducidad` date DEFAULT NULL,
  `id_categoria` int NOT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla: empleados
CREATE TABLE `empleados` (
  `id_empleado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `id_rol` int NOT NULL,
  PRIMARY KEY (`id_empleado`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla: ventas
CREATE TABLE `ventas` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `fecha_venta` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_empleado` int NOT NULL,
  `total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `id_empleado` (`id_empleado`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla: detalles_venta
CREATE TABLE `detalles_venta` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_venta` int NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_venta` (`id_venta`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalles_venta_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`) ON DELETE CASCADE,
  CONSTRAINT `detalles_venta_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 5. INSERCIÓN DE DATOS

-- Datos para categorias
INSERT INTO `categorias` VALUES 
(1,'Lácteos','Leche, quesos, yogures y derivados'),
(2,'Bebidas','Jugos, refrescos, aguas y licores'),
(3,'Snacks','Papas, galletas, chocolates y dulces'),
(4,'Limpieza','Detergentes, jabones y artículos para el hogar'),
(5,'Cuidado Personal','Shampoo, desodorantes, pasta dental'),
(6,'Carnes y Embutidos','Res, pollo, cerdo, salchichas'),
(7,'Panadería','Pan fresco, pasteles y postres'),
(8,'Frutas y Verduras','Productos agrícolas frescos'),
(9,'Congelados','Helados, comidas listas y vegetales congelados'),
(10,'Mascotas','Alimento y accesorios para animales');

-- Datos para productos
INSERT INTO `productos` VALUES 
(1,'Leche Entera 1L','Leche pasteurizada clásica',1.20,50,'2026-05-15',1),
(2,'Queso Mozzarella 500g','Ideal para pizzas',3.50,30,'2026-06-10',1),
(3,'Yogur Natural 1L','Sin azúcar añadido',2.10,40,'2026-05-20',1),
(4,'Mantequilla con Sal 200g','Mantequilla tradicional',1.80,25,'2026-08-01',1),
(5,'Crema de Leche 250ml','Para repostería y cocina',1.50,35,'2026-06-15',1),
(6,'Queso Fresco 400g','Queso de mesa suave',2.80,20,'2026-04-30',1),
(7,'Leche Deslactosada 1L','Fácil digestión',1.30,45,'2026-05-15',1),
(8,'Yogur de Fresa 1L','Con trozos de fruta',2.30,30,'2026-05-25',1),
(9,'Queso Parmesano 150g','Rallado en polvo',4.00,15,'2026-12-01',1),
(10,'Leche Condensada 395g','Lata dulce para postres',2.50,60,'2027-01-10',1),
(11,'Agua Mineral 500ml','Agua con gas',0.80,100,'2027-05-01',2),
(12,'Agua Purificada 1L','Agua sin gas',1.00,120,'2027-05-01',2),
(13,'Coca Cola 2L','Gaseosa sabor original',2.20,80,'2026-11-20',2),
(14,'Jugo de Naranja 1L','100% natural',1.80,40,'2026-08-15',2),
(15,'Cerveza Lager 330ml','Cerveza rubia clásica',1.50,200,'2027-02-10',2),
(16,'Vino Tinto 750ml','Cabernet Sauvignon',8.50,30,'2030-12-31',2),
(17,'Té Helado de Limón 500ml','Bebida refrescante',1.20,60,'2026-09-05',2),
(18,'Bebida Energizante 250ml','Alto en cafeína',2.00,50,'2027-03-15',2),
(19,'Gaseosa de Limón 2L','Sabor lima-limón',2.00,70,'2026-10-10',2),
(20,'Café Frío 250ml','Café con leche listo para tomar',1.90,35,'2026-07-20',2),
(21,'Papas Fritas Clásicas 150g','Snack salado',1.50,80,'2026-09-10',3),
(22,'Nachos con Queso 200g','Tortillas de maíz',2.00,60,'2026-08-25',3),
(23,'Galletas de Chocolate 120g','Rellenas de crema',1.30,90,'2026-11-05',3),
(24,'Maní Salado 100g','Maní tostado',1.00,100,'2026-12-15',3),
(25,'Gomitas de Oso 150g','Sabores frutales',1.20,75,'2027-01-20',3),
(26,'Barra de Chocolate 100g','Cacao al 70%',2.50,40,'2027-03-10',3),
(27,'Palomitas de Maíz 90g','Para microondas',1.10,85,'2026-10-30',3),
(28,'Galletas Saladas 200g','Ideales para dips',1.40,70,'2026-09-15',3),
(29,'Chicles de Menta','Paquete de 12 unidades',0.80,150,'2027-05-01',3),
(30,'Pistachos 100g','Pistachos tostados',3.50,30,'2026-11-20',3),
(31,'Detergente Líquido 3L','Para ropa de color',6.50,40,NULL,4),
(32,'Suavizante de Telas 1L','Aroma floral',3.20,50,NULL,4),
(33,'Cloro 1L','Desinfectante multiusos',1.50,80,NULL,4),
(34,'Limpiador de Pisos 2L','Aroma lavanda',2.80,60,NULL,4),
(35,'Lavavajillas Líquido 500ml','Arranque grasa',2.00,70,NULL,4),
(36,'Esponjas de Cocina','Paquete de 3 unidades',1.50,100,NULL,4),
(37,'Escoba de Cerdas Suaves','Para interiores',4.50,30,NULL,4),
(38,'Trapeador de Algodón','Súper absorbente',5.00,25,NULL,4),
(39,'Bolsas de Basura 50L','Paquete de 20',2.50,90,NULL,4),
(40,'Ambientador en Spray','Aroma bosque',3.00,45,NULL,4),
(41,'Shampoo Anticaspa 400ml','Cuidado diario',5.50,40,'2028-01-10',5),
(42,'Acondicionador 400ml','Cabello seco',5.50,35,'2028-01-10',5),
(43,'Jabón de Tocador 3un','Aroma avena',2.50,80,'2029-05-01',5),
(44,'Pasta Dental 150g','Protección anticaries',2.20,100,'2027-11-15',5),
(45,'Cepillo Dental','Cerdas medias',1.80,120,NULL,5),
(46,'Desodorante en Spray 150ml','Protección 48h',4.00,60,'2027-08-20',5),
(47,'Crema Corporal 400ml','Piel seca',6.50,30,'2027-06-30',5),
(48,'Espuma de Afeitar 200ml','Para piel sensible',3.80,45,'2028-02-15',5),
(49,'Papel Higiénico','Paquete de 4 rollos',2.00,150,NULL,5),
(50,'Toallas Femeninas','Paquete de 10 unidades',2.50,80,'2028-10-01',5),
(51,'Pechuga de Pollo 1kg','Fresca sin hueso',6.50,25,'2026-03-30',6),
(52,'Carne Molida de Res 500g','Especial 90/10',4.50,20,'2026-03-28',6),
(53,'Chuleta de Cerdo 1kg','Corte grueso',7.00,15,'2026-03-29',6),
(54,'Salchichas de Pavo 500g','Paquete de 10',3.20,40,'2026-04-15',6),
(55,'Tocino Ahumado 250g','En rebanadas',4.80,30,'2026-05-01',6),
(56,'Chorizo de Cerdo 400g','Sabor tradicional',3.50,35,'2026-04-20',6),
(57,'Jamón de Pierna 250g','Rebanado',2.80,45,'2026-04-10',6),
(58,'Salami 200g','Curado especial',4.20,25,'2026-06-15',6),
(59,'Alitas de Pollo 1kg','Listas para freír',5.00,30,'2026-03-31',6),
(60,'Lomo Fino de Res 1kg','Corte premium',12.00,10,'2026-03-28',6),
(61,'Pan de Molde Blanco','Rebanado',2.20,40,'2026-04-05',7),
(62,'Pan Integral','Con semillas',2.50,35,'2026-04-03',7),
(63,'Baguette Francés','Recién horneado',1.00,50,'2026-03-25',7),
(64,'Croissant de Mantequilla','Unidad',0.80,60,'2026-03-25',7),
(65,'Pastel de Chocolate','Porción individual',2.50,20,'2026-03-27',7),
(66,'Tortillas de Harina','Paquete de 12',1.80,45,'2026-04-15',7),
(67,'Empanada de Queso','Lista para comer',1.20,30,'2026-03-26',7),
(68,'Magdalenas','Paquete de 6',2.00,40,'2026-04-10',7),
(69,'Pan para Hamburguesa','Paquete de 4',1.50,55,'2026-04-08',7),
(70,'Masa para Pizza','Base precocida',3.00,25,'2026-04-20',7),
(71,'Manzanas Rojas 1kg','Dulces y crujientes',2.50,50,'2026-04-10',8),
(72,'Plátanos 1kg','Maduros',1.20,60,'2026-03-30',8),
(73,'Tomate Riñón 1kg','Para ensaladas',1.50,45,'2026-04-05',8),
(74,'Cebolla Blanca 1kg','Fresca',1.00,55,'2026-04-15',8),
(75,'Lechuga Crespa','Unidad',0.80,30,'2026-03-28',8),
(76,'Zanahorias 1kg','Limpia',1.20,40,'2026-04-12',8),
(77,'Limones 1kg','Jugo abundante',2.00,50,'2026-04-20',8),
(78,'Aguacate Hass 1kg','Mantequilloso',4.50,25,'2026-03-31',8),
(79,'Papas Cholas 2kg','Para cocinar',2.50,80,'2026-04-25',8),
(80,'Naranjas para Jugo 2kg','Dulces',3.00,60,'2026-04-15',8),
(81,'Helado de Vainilla 1L','Cremoso',4.50,20,'2026-12-30',9),
(82,'Papas Fritas Congeladas 1kg','Corte recto',3.80,35,'2027-02-15',9),
(83,'Pizza Congelada','Sabor Pepperoni',5.50,25,'2026-10-20',9),
(84,'Vegetales Mixtos 500g','Zanahoria, arveja, maíz',2.50,40,'2027-01-10',9),
(85,'Nuggets de Pollo 500g','Prefritos',4.00,30,'2026-11-05',9),
(86,'Hamburguesas de Res','Caja de 4 unidades',6.00,20,'2026-09-15',9),
(87,'Frutillas Congeladas 500g','Para batidos',3.50,25,'2027-03-01',9),
(88,'Camarones Pelados 400g','Precocidos',8.50,15,'2026-08-20',9),
(89,'Masa Hojaldre 500g','Para repostería',3.00,20,'2026-12-01',9),
(90,'Helado de Chocolate 1L','Con chispas',4.50,20,'2026-12-30',9),
(91,'Croquetas para Perro Adulto 3kg','Sabor carne',12.00,40,'2027-05-20',10),
(92,'Alimento Húmedo Gato 85g','Pouch sabor salmón',1.00,100,'2027-08-15',10),
(93,'Arena para Gatos 5kg','Aglutinante sin olor',8.50,30,NULL,10),
(94,'Croquetas para Cachorro 1.5kg','Con DHA',7.50,25,'2027-06-10',10),
(95,'Snacks para Perro 200g','Huesitos limpiadientes',3.50,50,'2027-01-25',10),
(96,'Collar Antipulgas','Talla única',15.00,20,'2028-01-01',10),
(97,'Juguete de Goma','Hueso resistente',4.00,35,NULL,10),
(98,'Correa para Paseo','Largo 1.5m',6.00,25,NULL,10),
(99,'Shampoo para Perros 500ml','Aroma avena',5.50,30,'2028-06-15',10),
(100,'Rascador para Gatos','Cartón corrugado',8.00,15,NULL,10);

-- Finalizado