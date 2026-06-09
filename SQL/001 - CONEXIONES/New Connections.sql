SELECT
	i.Id_incidencia										AS [Incidencia],
    agencias.dbo.converthtml(i.I_asumpte)				AS [Titulo],
	p.P_nom												AS [Proyecto],
	be_wsi.WSI_Nombre									AS [API],
	be_iws.Int_Nombre									AS [INTEGRADOR],
	i.FecCre											AS [FECHA]
FROM 
				agencias.dbo.INCIDENCIA						i
	INNER JOIN	agencias.dbo.PROJECTE						p		ON p.P_codi = i.P_Codi
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_WSIntegraciones	be_wsi  ON be_wsi.Id_WSIntegraciones = i.Id_WSIntegraciones
    LEFT JOIN	BD_BookingEngine.dbo.Tbl_IntegradorWS		be_iws  ON be_iws.Id_Int = i.Id_Int
WHERE
	1 = 1
	AND i.P_Codi = 12772
	--AND i.i_data > '2023'
ORDER BY
	[API],
	[INCIDENCIA] ASC
