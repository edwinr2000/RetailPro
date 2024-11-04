/*Realizado por Edwin Oswaldo Torres Rincón SGBD -> MySQL*/

/*Creación de dimensiones*/

--dimCliente
CREATE TABLE `dimcliente` (
  `Cliente_ID` int NOT NULL,
  `Calificacion_1` int DEFAULT NULL,
  `Calificacion_2` int DEFAULT NULL,
  `Calificacion_3` int DEFAULT NULL,
  `Calificacion_4` int DEFAULT NULL,
  `Calificacion_5` int DEFAULT NULL,
  PRIMARY KEY (`Cliente_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--dimFecha
CREATE TABLE `dimfecha` (
  `Fecha_ID` int NOT NULL AUTO_INCREMENT,
  `Fecha` date DEFAULT NULL,
  `Año` int DEFAULT NULL,
  `Mes` int DEFAULT NULL,
  `Día` int DEFAULT NULL,
  PRIMARY KEY (`Fecha_ID`),
  UNIQUE KEY `Fecha` (`Fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--dimProducto
CREATE TABLE `dimproducto` (
  `Producto_ID` int NOT NULL AUTO_INCREMENT,
  `Producto` varchar(100) DEFAULT NULL,
  `Categoría` varchar(100) DEFAULT NULL,
  `Inventario_Inicial` int DEFAULT NULL,
  `Inventario_Final` int DEFAULT NULL,
  `Stock_Mínimo` int DEFAULT NULL,
  `Calificacion_1` int DEFAULT '0',
  `Calificacion_2` int DEFAULT '0',
  `Calificacion_3` int DEFAULT '0',
  `Calificacion_4` int DEFAULT '0',
  `Calificacion_5` int DEFAULT '0',
  PRIMARY KEY (`Producto_ID`),
  UNIQUE KEY `Producto` (`Producto`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


/*Creación tabla de hechos*/
--tbHechos
CREATE TABLE `tbhechos` (
  `Hecho_ID` int NOT NULL AUTO_INCREMENT,
  `Fecha_ID` int DEFAULT NULL,
  `Producto_ID` int DEFAULT NULL,
  `Cliente_ID` int DEFAULT NULL,
  `Cantidad_Vendida` int DEFAULT NULL,
  `Precio_Unitario` decimal(10,2) DEFAULT NULL,
  `Ingresos` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Hecho_ID`),
  KEY `Fecha_ID` (`Fecha_ID`),
  KEY `Producto_ID` (`Producto_ID`),
  KEY `Cliente_ID` (`Cliente_ID`),
  CONSTRAINT `tbhechos_ibfk_1` FOREIGN KEY (`Fecha_ID`) REFERENCES `dimfecha` (`Fecha_ID`),
  CONSTRAINT `tbhechos_ibfk_2` FOREIGN KEY (`Producto_ID`) REFERENCES `dimproducto` (`Producto_ID`),
  CONSTRAINT `tbhechos_ibfk_3` FOREIGN KEY (`Cliente_ID`) REFERENCES `dimcliente` (`Cliente_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

