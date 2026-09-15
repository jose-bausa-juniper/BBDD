SELECT
    PA.PalProyecto,
    PA.Id_Pal,
    PA.PalNombre,
    CASE PA.PAlEstado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END					                AS [Estado Complemento],
    I.Id_incidencia,
    I.I_asumpte,
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
    LEFT JOIN   agencias.dbo.PROJECTE_ALTRES    PA      ON ((PA.PalProyecto = I.P_Codi AND PA.PalNombre = REPLACE(I.I_asumpte,'Soporte XML - ','')))
WHERE
    1 = 1
    AND PA.PalProyecto IN (SELECT P_codi FROM agencias.dbo.PROJECTE WHERE P_client = 18224)
    AND PA.PalEstado <> 2
    AND I.A_codi = 18224
    AND I.I_tipus = 16
    AND I.I_ConexionAgencia = 0
    --AND I_estat <> 'C'

    --AND (I_estat <> 'C' AND PA.PalCancelado = 0)    
    --AND (I_estat <> 'C' AND PA.PalCancelado = 1)
    --AND (I_estat = 'C' AND PA.PalCancelado = 0)
    
    --AND PalNombre like '%extranet%'

ORDER BY
    PA.PalProyecto,
    PA.Id_Pal,
    I.Id_incidencia