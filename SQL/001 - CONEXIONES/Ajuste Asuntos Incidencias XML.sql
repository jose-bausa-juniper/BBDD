SELECT
	i.Id_incidencia										AS [Incidencia],
    agencias.dbo.converthtml(i.I_asumpte)				AS [Titulo],
	CONCAT('Soporte XML - [',be_wsi.WSI_Nombre,'] - [',be_iws.Int_Nombre,']')	AS [Nuevo Titulo],
	--CONCAT('UPDATE agencias.dbo.INCIDENCIA SET I_asumpte = ''Soporte XML - [',be_wsi.WSI_Nombre,'] - [',be_iws.Int_Nombre,']'' WHERE Id_incidencia = ',Id_incidencia),
	--p.P_nom												AS [Proyecto],
	be_wsi.WSI_Nombre									AS [API],
	be_iws.Int_Nombre									AS [Integrador]
FROM 
				agencias.dbo.INCIDENCIA						i
	LEFT JOIN	agencias.dbo.TIPO_INCIDENCIA				ti		ON ti.TI_id = i.I_tipus
--	INNER JOIN	agencias.dbo.PROJECTE						p		ON p.P_codi = i.P_Codi
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_WSIntegraciones	be_wsi  ON be_wsi.Id_WSIntegraciones = i.Id_WSIntegraciones
    LEFT JOIN	BD_BookingEngine.dbo.Tbl_IntegradorWS		be_iws  ON be_iws.Id_Int = i.Id_Int
WHERE
	1 = 1
    AND i.A_codi = 18224 -- W2M
	--AND i.I_estat <> 'C' -- (E - En curso) 
	AND i.I_ConexionAgencia = 0
	AND ti.TI_id = 16 -- (16 - Soporte XML)
	AND i.I_asumpte <> CONCAT('Soporte XML - [',be_wsi.WSI_Nombre,'] - [',be_iws.Int_Nombre,']')
	AND be_wsi.WSI_Nombre IS NOT NULL
	AND be_iws.Int_Nombre IS NOT NULL

ORDER BY
	[API]