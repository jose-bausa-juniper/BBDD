USE BD_BookingEngine
DECLARE
@idcliente INT = 18224

SELECT 
    i.Id_incidencia										AS [Incidencia],
    agencias.dbo.converthtml(i.I_asumpte)				AS [Titulo],
    iws.Int_Nombre										AS [Integrador], 
    wsi.WSI_Nombre										AS [WebService],
    i.I_pasoLive										AS [Live],
    i.P_codi											AS [ID Proyecto],
	i.MOD_id,
	i.I_idPM,
    pm.PM_TextoAdicional								AS [Nombre Sub_Modulo],
    p.P_nom                                             AS [Proyecto],
    CONVERT(date,i.FecCre)								AS [Fecha Inicio],
    CASE 
        WHEN i.P_codi is NULL
        THEN 'Pendiente Revisar'
        ELSE 'Asignado'
    END                                                 AS [Contrato]
FROM 
                agencias.dbo.INCIDENCIA                     i
    INNER JOIN  agencias.dbo.TIPO_INCIDENCIA                ti		ON ti.TI_id = i.I_tipus 
    INNER JOIN  BD_BookingEngine.dbo.Tbl_WSIntegraciones    wsi		ON wsi.Id_WSIntegraciones = i.Id_WSIntegraciones
    INNER JOIN  BD_BookingEngine.dbo.Tbl_IntegradorWS       iws		ON iws.Id_Int = i.Id_Int
    FULL JOIN   agencias.dbo.PROJECTE                       p       ON p.P_codi = i.P_Codi
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO				pm		ON pm.P_codi = p.P_Codi AND i.I_idPM = pm.Id_PM

WHERE 1=1
AND ti.TI_id = 16 -- (16 - Soporte XML)
AND i.A_codi = @idcliente 
AND i.I_estat = 'E' -- (E - En curso) 
AND i.I_ConexionAgencia = 0
AND (i.P_Codi IS NULL OR i.P_Codi = 12772)

ORDER BY 
	iws.Int_Nombre,
	wsi.WSI_Nombre,
	i.I_pasoLive,
	i.Id_incidencia,
	i.P_codi
