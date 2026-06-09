USE BD_BookingEngine;
--WITH INCIDENCIAS AS (

SELECT 
    be_iws.Int_Nombre                                   AS [Integrador], 
    a_i.Id_incidencia                                   AS [Incidencia],
	a_i.I_estat											AS [Estado],
    agencias.dbo.converthtml(a_i.I_asumpte)             AS [Titulo],
    be_wsi.WSI_Nombre                                   AS [WebService],
    a_i.I_pasoLive                                      AS [Live],
	u.U_nom												AS [Responsable],
	CONVERT (DATE, a_i.FecCre)							AS [Fecha Creación],
	a_i.incPresupuestoAceptado							AS [Presupuesto_Aceptado],
	a_i.I_porContrato									AS [Marcada_Contrato],
	p.P_codi											AS [Id_Proyecto],
	p.P_nom												AS [Proyecto]
FROM 
                agencias.dbo.INCIDENCIA                     a_i
    LEFT JOIN	agencias.dbo.TIPO_INCIDENCIA				a_ti    ON a_ti.TI_id = a_i.I_tipus 
    LEFT JOIN	BD_BookingEngine.dbo.Tbl_WSIntegraciones    be_wsi  ON be_wsi.Id_WSIntegraciones = a_i.Id_WSIntegraciones
    LEFT JOIN	BD_BookingEngine.dbo.Tbl_IntegradorWS       be_iws  ON be_iws.Id_Int = a_i.Id_Int
	LEFT JOIN	agencias.dbo.PROJECTE                       p		ON p.P_codi = a_i.P_Codi 
	LEFT JOIN	agencias.dbo.USUARI							u		ON u.Id_usuari = a_i.Id_usuari
	WHERE	
		1 = 1
	AND a_ti.TI_id = 16 -- (16 - Soporte XML)
	AND a_i.A_codi = 18224 
	--AND a_i.I_estat <> 'C' -- (E - En curso) 
	AND a_i.I_ConexionAgencia = 0
	AND be_iws.Int_Nombre IS NOT NULL
ORDER BY 
	p.P_codi,
	be_iws.Int_Nombre,
	be_wsi.WSI_Nombre,
	a_i.I_pasoLive,
	a_i.Id_incidencia


	--) SELECT DISTINCT (Integrador) FROM INCIDENCIAS