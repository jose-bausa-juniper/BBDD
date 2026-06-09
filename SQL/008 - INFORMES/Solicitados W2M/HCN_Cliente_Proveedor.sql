USE BD_Nincoming;

---------------------------------------------------------------

-- SELECT 
--     c.Id_Cli,
--     c.Cli_Nombre,
--     c.Id_GRA,
--     ga.GRA_Nombre,
--     c.Id_int,
--     iws.Int_Nombre,
--     CASE 
--         WHEN pnc.Id_Per = 128 
--         THEN 'ShowHCN' 
--     END AS [Per_Nombre]
-- FROM 
--     Tbl_Cliente c
--     INNER JOIN Tbl_IntegradorWS iws ON iws.Id_Int = c.Id_Int
--     INNER JOIN Tbl_GrupoAgencia ga ON ga.Id_GRA = c.Id_GRA
--     INNER JOIN Tbl_PerNCli pnc ON pnc.Id_Cli = c.Id_Cli
-- WHERE 1=1
--     AND c.Cli_Activa = 1
--     AND c.Cli_AccesoWebservice = 1
--     AND pnc.Id_Per = 128

---------------------------------------------------------------

SELECT
    DISTINCT(RAE_tipoProducto) AS [Tipo Producto],
    COUNT (*) AS [Nº Reservas],
    CASE RAE_OrigenLocalizadorHotel 
        WHEN 0 THEN 'Desconocido'
        WHEN 1 THEN 'Mantenimiento Reserva'
        WHEN 2 THEN 'Extranet'
        WHEN 3 THEN 'Notificación Proveedor'
        WHEN 4 THEN 'API - Confirmación'
        WHEN 5 THEN 'API - Post Confirmación'
        WHEN 6 THEN 'Importación Masiva'
    END AS [Origen],
    MAX (id_res) AS [Ultima Res]
FROM
    Tbl_ReservaAlojamientoExterno
WHERE 1=1
    AND RAE_tipoProducto IN (
                            SELECT
                                CASE
                                    WHEN tpd.id_TPD IS NULL THEN tp.TPr_Tipo
                                    ELSE tpd.id_TPD
                                END 'Modulo'
                            FROM 
                                Tbl_TipoProducto tp
                                FULL JOIN Tbl_TipoProductoDesglosado tpd ON tp.TPr_Tipo=tpd.TPr_Tipo
                            WHERE 1=1
                                AND (tp.TPr_Visible = 1  OR tp.TPr_Visible IS NULL)
                                AND (tpd.TPd_Visible = 1 OR tpd.TPd_Visible IS NULL)
                                AND (tp.TPr_ModuleType = 'Alojamiento')
                                AND (tp.TPr_Tipo NOT IN ('A','AGN'))
    )
    AND Feccre>'2024'
    AND RAE_OrigenLocalizadorHotel IN (4,5)
GROUP BY
    RAE_tipoProducto,
    RAE_OrigenLocalizadorHotel
ORDER BY
    [Tipo Producto], [Origen] DESC
