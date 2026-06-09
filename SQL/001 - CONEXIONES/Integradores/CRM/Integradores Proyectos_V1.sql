USE BD_BookingEngine
DECLARE
	@idcliente INT = 18224

SELECT 
	i.Id_incidencia							AS [Incidencia],
	wsi.WSI_Nombre							AS [WebService],
	iws.Int_Nombre							AS [Integrador], 
	agencias.dbo.converthtml(i.I_asumpte)	AS [Titulo],
	ti.TI_Nombre_ES							AS [Tipo Incidencia],
	i.I_pasoLive							AS [Live],
	p.P_Codi								AS [Id_Proyecto],
	p.P_nom									AS [Proyecto],
	pa.PalNombre							AS [Proyecto_Modulo],
	pm.MOD_id								AS [Id_Sub_Modulo],
	pm.PM_TextoAdicional					AS [Proyecto_Sub_Modulo]
FROM 
					agencias.dbo.INCIDENCIA						i
	LEFT JOIN		agencias.dbo.TIPO_INCIDENCIA				ti	ON ti.TI_id = i.I_tipus
	LEFT JOIN		BD_BookingEngine.dbo.Tbl_WSIntegraciones	wsi	ON wsi.Id_WSIntegraciones = i.Id_WSIntegraciones
	LEFT JOIN		BD_BookingEngine.dbo.Tbl_IntegradorWS		iws	ON iws.Id_Int = i.Id_Int
	LEFT JOIN		agencias.dbo.PROJECTE						p	ON i.P_Codi = p.P_codi
	LEFT JOIN		agencias.dbo.PROJECTE_MODULO				pm	ON pm.P_codi = p.P_Codi AND i.I_idPM = pm.Id_PM
	LEFT JOIN		agencias.dbo.PROJECTE_ALTRES				pa	ON (pa.PalProyecto = p.P_Codi) AND (PalNombre = iws.Int_Nombre)

WHERE 
	1=1
	AND i.A_codi = @idcliente 
	AND ti.TI_id = 16 -- (16 - Soporte XML)
	AND i.I_estat <> 'C' -- (E - En curso) 
	AND i.I_ConexionAgencia = 0
	--    AND i.Id_incidencia = 713916

	--AND (i.P_Codi IS NOT NULL AND i.P_Codi <> 12772) --> Correctos
	--AND (i.P_Codi IS NULL) --> Pendiente Asignar proyecto
	--AND (i.P_Codi = 12772) --> Pendiente Firma
ORDER BY 
	i.Id_Int DESC