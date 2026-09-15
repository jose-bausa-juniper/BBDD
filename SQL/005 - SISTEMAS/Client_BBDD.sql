-- Consulta del catalogo de clientes para el Dashboard Juniper.
-- La usa actualizar_clientes.ps1 (la carga de este mismo archivo, no la
-- dupliques ahi). El panel la lee en el navegador (clientes.csv) para
-- poblar el selector de cliente de la cabecera: al elegir uno, se usa
-- su A_codi para filtrar Incidencias (ver incidencias.sql, parametro
-- @A_codi) y su DWServer/DWDataBase para conectar a la BBDD de Logs de
-- ese cliente (ver logs_conexion.ps1).
--
-- >>> AQUI <<< Cambia "TU_TABLA_CLIENTES" por la tabla/vista real que
-- tiene, por cada cliente, su A_codi, A_nom y los datos de conexion a
-- su BBDD de Logs (DWServer/DWDataBase). Si esos datos de conexion
-- viven en una tabla distinta a la de clientes, anade aqui el JOIN que
-- haga falta - lo importante es que la consulta final devuelva
-- exactamente estas 4 columnas, una fila por cliente.

SELECT
    A.A_codi                                                                        AS [A_codi],
    A.A_nom                                                                         AS [A_nom],
    BD.Id_BDD                                                                       AS [Id_BDD],
    SUBSTRING(
    BD.BDD_Nombre,
    2,
    CHARINDEX(']', BD.BDD_Nombre) - CHARINDEX('[', BD.BDD_Nombre) - 1
    )                                                                               AS [Server],
    SUBSTRING(
    BD.BDD_Nombre,
    2,
    CHARINDEX('.', BD.BDD_Nombre) - 2
    )                                                                               AS [DataBase],
    CASE 
        WHEN (BDD_Log IS NULL OR BDD_Log = '' OR Id_BDD = 197) 
        THEN    SUBSTRING  (
                BD.BDD_Nombre,
                2,
                CHARINDEX(']', BD.BDD_Nombre) - CHARINDEX('[', BD.BDD_Nombre) - 1
                )
        ELSE    SUBSTRING(
                BD.BDD_Log,
                2,
                CHARINDEX(']', BD.BDD_Log) - CHARINDEX('[', BD.BDD_Log) - 1
                )
    END                                                                             AS [DWServer],
    CASE 
        WHEN (BDD_Log IS NULL OR BDD_Log = '' OR Id_BDD = 197) 
        THEN    SUBSTRING(
                BD.BDD_Nombre,
                2,
                CHARINDEX('.', BD.BDD_Nombre) - 2
                )
        ELSE    SUBSTRING(
                BD.BDD_Log,
                2,
                CHARINDEX('.', BD.BDD_Log) - 2
                )                                                                               
    END                                                                             AS [DWDataBase],
    BDBI.Cli_Url                                                                    AS [URL_BI_SAAS]
 FROM 
            agencias.dbo.AGENCIA                A  
 LEFT JOIN  BD_BookingEngine.dbo.Tbl_BaseDatos  BD ON BD.A_Codi = A.A_Codi
 LEFT JOIN  BD_ConfigBI.dbo.Tbl_Cliente         BDBI ON BDBI.cli_idBE = BD.Id_BDD
 WHERE 
    1 = 1
    AND BDD_CliProduccion = 1
    --AND BDBI.Cli_Url IS NOT NULL
ORDER BY
    A.A_nom ASC

