SELECT
    Id_BDD,
    SUBSTRING(
    BDD_Nombre,
    2,
    CHARINDEX(']', BDD_Nombre) - CHARINDEX('[', BDD_Nombre) - 1
    ) AS [Server],
    SUBSTRING(
    BDD_Nombre,
    2,  -- empieza en el segundo carácter
    CHARINDEX('.', BDD_Nombre) - 2  -- ajusta la longitud para compensar el inicio en 2
    ) AS [DataBase],
    SUBSTRING(
    BDD_Log,
    2,
    CHARINDEX(']', BDD_Log) - CHARINDEX('[', BDD_Log) - 1
    ) AS [DWServer],
    SUBSTRING(
    BDD_Log,
    2,  -- empieza en el segundo carácter
    CHARINDEX('.', BDD_Log) - 2  -- ajusta la longitud para compensar el inicio en 2
    ) AS [DWDataBase]
    
 FROM BD_BookingEngine.dbo.Tbl_BaseDatos 

 WHERE 
    1 = 1
    AND BDD_CliProduccion = 1
    AND BDD_Log IS NOT NULL 
    AND BDD_Log <> ''
    AND Id_BDD IN (107)
ORDER BY
    Id_BDD ASC