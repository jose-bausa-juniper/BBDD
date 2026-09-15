SELECT 
    I.Id_incidencia         AS ID,
    I.I_asumpte             AS TITULO,
    I.FecCre                AS FECHA,
    CASE i.I_estat 
            WHEN 'N' THEN 'Nueva'
            WHEN 'E' THEN 'En curso'
            WHEN 'C' THEN 'Cerrada'
            WHEN '5' THEN 'Pend Proveedor'
            WHEN '4' THEN 'Pend Juniper'
            WHEN '3' THEN 'Pend Cliente' 
            ELSE i.I_estat
    END                     AS ESTADO,
    I.I_porContrato         AS CONTRATO,
    U.U_nom                 AS ASIGNADO,
    U1.U_nom                AS RESPONSABLE,
	IWS.int_nombre		    AS [Integrador],
    WSI.WSI_Nombre          AS [Webservice],
    P.P_codi                AS ID_PROYECTO,
    CASE    p.p_estat
        WHEN 1 THEN 'Inicio'
        WHEN 2 THEN 'Diseño'
        WHEN 3 THEN 'Implantación'
        WHEN 4 THEN 'Testing'
        WHEN 5 THEN 'Preproducción'
        WHEN 6 THEN 'Producción'
        WHEN 7 THEN 'Acción comercial'
    END						AS [Estado Proyecto],                 
    P.P_nom                 AS PROYECTO,
    PM.MOD_id               AS ID_MOD_FAC,
    CASE    PM.PM_estado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END					    AS [Estado Módulo],
    M.MOD_nombre_ES         AS MOD_FAC,
    PM.Id_PM                AS ID_PM_FAC,
    PM.PM_TextoAdicional    AS PM_FAC_DET,
    PMS.MOD_id              AS ID_MOD_SEG,
    M1.MOD_nombre_ES        AS MOD_SEG,
    PM1.Id_PM               AS ID_PM_SEG,   
    PM1.PM_TextoAdicional   AS PM_SEG_DET,
    PA.PalProyecto,
    PA.Id_Pal,
    PA.PalNombre,
    CASE PA.PAlEstado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END                     AS [Estado Complemento]
FROM
                agencias.dbo.INCIDENCIA                     I
	LEFT JOIN	agencias.dbo.TIPO_INCIDENCIA			    TI	ON TI.TI_id = I.I_tipus            
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_WSIntegraciones	WSI  ON WSI.Id_WSIntegraciones = I.Id_WSIntegraciones
    LEFT JOIN	BD_BookingEngine.dbo.Tbl_IntegradorWS		IWS  ON IWS.Id_Int = I.Id_Int
    LEFT JOIN   agencias.dbo.USUARI                         U   ON U.Id_usuari = I.Id_usuari
    LEFT JOIN   agencias.dbo.USUARI                         U1  ON U1.Id_usuari = I.I_responsableTicket                
	LEFT JOIN	agencias.dbo.PROJECTE                       P	ON P.P_codi = I.P_Codi
    LEFT JOIN   agencias.dbo.Tbl_ProyectoModuloSeguimiento  PMS ON PMS.Id_Incidencia = I.Id_incidencia
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO                PM  ON (PM.PM_Estado <> 2 AND PM.Id_PM = I.I_idPM AND PM.P_codi = I.P_Codi)
    LEFT JOIN	agencias.dbo.MODULO                         M   ON M.MOD_ID = I.MOD_id
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO                PM1 ON (PM.PM_Estado <> 2 AND PM1.Id_PM = PMS.Id_PM AND PM1.P_codi = I.P_Codi)
    LEFT JOIN	agencias.dbo.MODULO                         M1  ON PMS.MOD_id = M1.MOD_ID
    LEFT JOIN   agencias.dbo.PROJECTE_ALTRES                PA  ON (PA.PalEstado <> 2 AND PA.PalProyecto = I.P_Codi AND (REPLACE(I.I_asumpte,'Soporte XML - ','') = PA.PalNombre))
WHERE
    1 = 1
    AND I.A_codi = 18224 
    AND I.I_ConexionAgencia = 0
    AND i.I_tipus = 16
    AND I.I_estat <> 'C'

    --AND I.P_Codi IS NULL
    --AND I.I_idPM IS NULL
    --AND I.MOD_id = 306
    --AND PM.Id_PM IS NULL

    -- AND (
    --     I.P_Codi IS NULL
    --     OR (
    --         I.P_Codi IS NOT NULL
    --         AND I.MOD_id IS NULL
    --         AND PA.Id_Pal IS NULL
    --         )
    --     )

    --AND (WSI.WSI_Nombre LIKE '%Extranet%' OR WSI.WSI_Nombre LIKE '%Inversa%')
    --AND NOT (WSI.WSI_Nombre LIKE '%Extranet%' OR WSI.WSI_Nombre LIKE '%Inversa%')    

ORDER BY 
    I.Id_incidencia DESC,
    WSI.WSI_Nombre DESC,
    I.P_Codi DESC
