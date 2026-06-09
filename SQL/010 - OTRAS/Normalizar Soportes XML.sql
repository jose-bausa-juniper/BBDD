SELECT 
    a_i.Id_incidencia															                                                                                                AS [Incidencia],
    agencias.dbo.converthtml(a_i.I_asumpte)									                                                                                                    AS [Asunto],
    be_iws.Int_Nombre															                                                                                                AS [Integrador], 
    be_wsi.WSI_Nombre															                                                                                                AS [WebService],
	CONCAT ('Soporte XML - [',be_wsi.WSI_Nombre,'] - [',be_iws.Int_Nombre,']')			                                                                                        AS [Nuevo Asunto],
    CONCAT ('UPDATE agencias.dbo.INCIDENCIA SET I_asumpte = ''Soporte XML - [',be_wsi.WSI_Nombre,'] - [',be_iws.Int_Nombre,']''',' WHERE Id_incidencia = ', a_i.Id_incidencia)	AS [UPDATE]


FROM 
                agencias.dbo.INCIDENCIA                     a_i
    LEFT JOIN   agencias.dbo.TIPO_INCIDENCIA                a_ti    ON a_ti.TI_id=a_i.I_tipus 
    LEFT JOIN   BD_BookingEngine.dbo.Tbl_WSIntegraciones    be_wsi  ON be_wsi.Id_WSIntegraciones=a_i.Id_WSIntegraciones
    LEFT JOIN   BD_BookingEngine.dbo.Tbl_IntegradorWS       be_iws  ON be_iws.Id_Int=a_i.Id_Int
WHERE	
	1 = 1
    AND a_ti.TI_id = 16 -- (16 - Soporte XML)
    AND a_i.A_codi = 18224 
    AND a_i.I_estat <> 'C' -- (E - En curso) 
    AND a_i.I_ConexionAgencia = 0 