DECLARE @Anio INT = 2026;
DECLARE @Mes INT = 8;
DECLARE @PrimerDiaMes DATE = DATEFROMPARTS(@Anio, @Mes, 1);
DECLARE @UltimoDiaMes DATE = EOMONTH(@PrimerDiaMes);
-- SET @PrimerDiaMes = '01-01-2017'
-- SET @UltimoDiaMes = GETDATE() 

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
    TI.TI_id                AS ID_TIPO,
    TI.TI_Nombre_ES         AS TIPO,
    I.P_codi                AS ID_PROYECTO,         
    P.P_nom                 AS PROYECTO,
    I.MOD_id                AS ID_MOD_FAC,
    M.MOD_nombre_ES         AS MOD_FAC,
    PM.Id_PM                AS ID_PM_FAC,
    PM.PM_TextoAdicional    AS PM_FAC_DET,
    PMS.MOD_id              AS ID_MOD_SEG,
    M1.MOD_nombre_ES        AS MOD_SEG,
    PM1.Id_PM               AS ID_PM_SEG,   
    PM1.PM_TextoAdicional   AS PM_SEG_DET
FROM
                agencias.dbo.INCIDENCIA                     I
	LEFT JOIN	agencias.dbo.TIPO_INCIDENCIA			    TI	ON TI.TI_id = I.I_tipus            
    LEFT JOIN   agencias.dbo.USUARI                         U   ON U.Id_usuari = I.Id_usuari
    LEFT JOIN   agencias.dbo.USUARI                         U1  ON U1.Id_usuari = I.I_responsableTicket                
	LEFT JOIN	agencias.dbo.PROJECTE                       P	ON P.P_codi = I.P_Codi
    LEFT JOIN   agencias.dbo.Tbl_ProyectoModuloSeguimiento  PMS ON PMS.Id_Incidencia = I.Id_incidencia
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO                PM  ON (PM.Id_PM = I.I_idPM AND PM.P_codi = I.P_Codi)
    LEFT JOIN	agencias.dbo.MODULO                         M   ON M.MOD_ID = I.MOD_id
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO                PM1 ON (PM1.Id_PM = PMS.Id_PM AND PM1.P_codi = I.P_Codi)
    LEFT JOIN	agencias.dbo.MODULO                         M1  ON PMS.MOD_id = M1.MOD_ID
    LEFT JOIN   agencias.dbo.PROJECTE_ALTRES                PA  ON (PA.PalProyecto = I.P_Codi AND (REPLACE(REPLACE(RIGHT(I.I_asumpte, CHARINDEX('[', REVERSE(I.I_asumpte))),'[', ''),']', '') = PA.PalNombre))
WHERE
    1 = 1
    AND I.A_codi = 18224 
    AND I.I_ConexionAgencia = 0
    AND i.I_tipus = 16
    AND I.I_estat <> 'C'
    AND (I.FecCre BETWEEN @PrimerDiaMes AND @UltimoDiaMes)
ORDER BY 
    I.Id_incidencia DESC

