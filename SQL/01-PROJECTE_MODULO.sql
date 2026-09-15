SELECT 
    P.P_nom,
    PM.P_codi,
    PM.MOD_id,
    PM.Id_PM,
    PM.PM_TextoAdicional,
    CASE    PM.PM_estado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END					    AS [Estado Modulo],
    I.Id_incidencia,
    I.I_asumpte,
    I.P_Codi,
    I.MOD_id,
    I.I_idPM,
    CASE i.I_estat 
            WHEN 'N' THEN 'Nueva'
            WHEN 'E' THEN 'En curso'
            WHEN 'C' THEN 'Cerrada'
            WHEN '5' THEN 'Pend Proveedor'
            WHEN '4' THEN 'Pend Juniper'
            WHEN '3' THEN 'Pend Cliente' 
            ELSE i.I_estat
    END                                 AS [Estado Incidencia]
FROM
                agencias.dbo.INCIDENCIA         I
    LEFT JOIN   agencias.dbo.PROJECTE           P   ON P.P_codi = I.P_Codi                
    LEFT JOIN   agencias.dbo.PROJECTE_MODULO    PM  ON (PM.P_codi = I.P_Codi AND PM.MOD_id = I.MOD_id AND PM.Id_PM = I.I_idPM)
WHERE 
    1 = 1
    AND PM.P_codi IN (SELECT P_codi FROM agencias.dbo.PROJECTE WHERE P_client = 18224)
    AND PM.MOD_id = 306 
    AND PM.PM_Estado <> 2
    AND I.A_codi = 18224
    AND I.I_tipus = 16
    AND I.I_ConexionAgencia = 0
    AND I.I_estat <> 'C'

    --AND (I_estat <> 'C' AND PM.PM_cancelado = 0)    
    --AND (I_estat <> 'C' AND PM.PM_cancelado = 1)
    --AND (I_estat = 'C' AND PM.PM_cancelado = 0)
    --AND PM_Estado = 3

ORDER BY
    PM.P_codi,
    PM.Id_PM,
    I.Id_incidencia

-- SELECT
-- P_codi,
-- Id_PM,
-- PM.PM_NombreSubModulo,
-- PM.PM_TextoAdicional,
-- M.MOD_nombre_ES
-- FROM agencias.dbo.PROJECTE_MODULO PM
-- LEFT JOIN agencias.dbo.MODULO M ON M.MOD_id = PM.MOD_id
-- WHERE 1 = 1 AND P_codi IN (SELECT P_codi FROM agencias.dbo.PROJECTE WHERE P_client = 18224) AND PM_Estado = 3 AND PM_NombreSubModulo NOT LIKE '%Conexión a definir%'