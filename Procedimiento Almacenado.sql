-- Realizado por Edwin Oswaldo Torres Rincón
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AlimentarDimensionesYHechos`()
BEGIN
	-- Retirar modo seguro para hacer prorcedimientos sin Where
    SET SQL_SAFE_UPDATES = 0;

    -- Truncar las tablas de dimensiones y hechos
    DELETE FROM BI.tbHechos;
    DELETE FROM BI.dimCliente;
    DELETE FROM BI.dimFecha;
    DELETE FROM BI.dimProducto;
    
    -- Reiniciar los Id's
    ALTER TABLE BI.tbHechos AUTO_INCREMENT = 1;
    ALTER TABLE BI.dimCliente AUTO_INCREMENT = 1;
    ALTER TABLE BI.dimProducto AUTO_INCREMENT = 1;
    ALTER TABLE BI.dimFecha AUTO_INCREMENT = 1;

    -- Insertar datos en la Dimensión Cliente
    INSERT INTO BI.dimCliente (Cliente_ID)
    SELECT DISTINCT Cliente_ID
    FROM BI.tbSatisfaccionCliente;

    -- Actualizar las calificaciones en la Dimensión Cliente
    UPDATE BI.dimCliente AS p
    JOIN (
        SELECT 
            Cliente_ID,
            SUM(CASE WHEN Calificación = 1 THEN 1 ELSE 0 END) AS Calificacion_1,
            SUM(CASE WHEN Calificación = 2 THEN 1 ELSE 0 END) AS Calificacion_2,
            SUM(CASE WHEN Calificación = 3 THEN 1 ELSE 0 END) AS Calificacion_3,
            SUM(CASE WHEN Calificación = 4 THEN 1 ELSE 0 END) AS Calificacion_4,
            SUM(CASE WHEN Calificación = 5 THEN 1 ELSE 0 END) AS Calificacion_5
        FROM 
            BI.tbSatisfaccionCliente
        GROUP BY 
            Cliente_ID
    ) AS nuevasCalificaciones ON p.Cliente_ID = nuevasCalificaciones.Cliente_ID
    SET 
        p.Calificacion_1 = nuevasCalificaciones.Calificacion_1,
        p.Calificacion_2 = nuevasCalificaciones.Calificacion_2,
        p.Calificacion_3 = nuevasCalificaciones.Calificacion_3,
        p.Calificacion_4 = nuevasCalificaciones.Calificacion_4,
        p.Calificacion_5 = nuevasCalificaciones.Calificacion_5;

    -- Insertar datos en la Dimensión Fecha 
    INSERT INTO BI.dimFecha (Fecha, Año, Mes, Día)
    SELECT DISTINCT
        Fecha,
        YEAR(Fecha) AS Año,
        MONTH(Fecha) AS Mes,
        DAY(Fecha) AS Día
    FROM 
        BI.tbVentas;

    -- Insertar datos en la Dimensión Producto
    INSERT INTO BI.dimProducto (Producto, Categoría, Inventario_Inicial, Inventario_Final, Stock_Mínimo)
    SELECT DISTINCT 
        Producto,
        Categoría,
        Inventario_Inicial,
        Inventario_Final,
        Stock_Mínimo
    FROM 
        BI.tbInventarios;

    -- Actualizar las calificaciones en la Dimensión Producto
    UPDATE BI.dimProducto AS p
    JOIN (
        SELECT 
            inv.Producto,
            SUM(CASE WHEN s.Calificación = 1 THEN 1 ELSE 0 END) AS Calificacion_1,
            SUM(CASE WHEN s.Calificación = 2 THEN 1 ELSE 0 END) AS Calificacion_2,
            SUM(CASE WHEN s.Calificación = 3 THEN 1 ELSE 0 END) AS Calificacion_3,
            SUM(CASE WHEN s.Calificación = 4 THEN 1 ELSE 0 END) AS Calificacion_4,
            SUM(CASE WHEN s.Calificación = 5 THEN 1 ELSE 0 END) AS Calificacion_5
        FROM 
            BI.tbSatisfaccionCliente s
        JOIN 
            BI.tbInventarios inv ON s.Producto = inv.Producto
        GROUP BY 
            inv.Producto
    ) AS nuevasCalificaciones ON p.Producto = nuevasCalificaciones.Producto
    SET 
        p.Calificacion_1 = nuevasCalificaciones.Calificacion_1,
        p.Calificacion_2 = nuevasCalificaciones.Calificacion_2,
        p.Calificacion_3 = nuevasCalificaciones.Calificacion_3,
        p.Calificacion_4 = nuevasCalificaciones.Calificacion_4,
        p.Calificacion_5 = nuevasCalificaciones.Calificacion_5;

    -- Insertar datos en la tabla de hechos para las ventas (sin datos de Cliente_ID)
    INSERT INTO BI.tbHechos (Fecha_Id, Producto_Id, Cliente_ID, Cantidad_Vendida, Precio_Unitario, Ingresos)
    SELECT
        fecha.Fecha_ID,
        prod.Producto_ID,
        NULL AS Cliente_ID,
        fue.Cantidad_Vendida,
        fue.Precio_Unitario,
        fue.Ingresos
    FROM 
        BI.tbVentas AS fue
    LEFT JOIN 
        BI.dimFecha AS fecha ON fue.Fecha = fecha.Fecha
    LEFT JOIN 
        BI.dimProducto AS prod ON fue.Producto = prod.Producto;

    -- Insertar datos de clientes en la tabla de hechos (sin datos de ventas)
    INSERT INTO BI.tbHechos (Fecha_Id, Producto_Id, Cliente_ID, Cantidad_Vendida, Precio_Unitario, Ingresos)
    SELECT
        NULL AS Fecha_Id,
        NULL AS Producto_Id,
        Cliente_ID,
        NULL AS Cantidad_Vendida,
        NULL AS Precio_Unitario,
        NULL AS Ingresos
    FROM 
        BI.dimCliente;

END$$
DELIMITER ;
