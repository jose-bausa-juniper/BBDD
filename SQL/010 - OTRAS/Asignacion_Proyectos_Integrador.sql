WITH PENDING AS(
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
		INNER JOIN		agencias.dbo.TIPO_INCIDENCIA				ti	ON ti.TI_id = i.I_tipus
		INNER JOIN		BD_BookingEngine.dbo.Tbl_WSIntegraciones	wsi	ON wsi.Id_WSIntegraciones = i.Id_WSIntegraciones
		INNER JOIN		BD_BookingEngine.dbo.Tbl_IntegradorWS		iws	ON iws.Id_Int = i.Id_Int
		FULL JOIN		agencias.dbo.PROJECTE						p	ON i.P_Codi = p.P_codi
		LEFT JOIN		agencias.dbo.PROJECTE_MODULO				pm	ON pm.P_codi = p.P_Codi AND i.I_idPM = pm.Id_PM
		LEFT JOIN		agencias.dbo.PROJECTE_ALTRES				pa	ON (pa.PalProyecto = p.P_Codi) AND PalNombre LIKE CONCAT('%',iws.Int_Nombre,'%')

	WHERE 
		1=1
		AND i.A_codi = 18224 
		AND ti.TI_id = 16 -- (16 - Soporte XML)
		AND i.I_estat <> 'C' -- (E - En curso) 
		AND i.I_ConexionAgencia = 0
		AND (i.P_Codi IS NULL) --> Pendiente Asignar proyecto
),

PROYECTS AS (
	SELECT
		p.P_codi,
		p.P_nom,
		pa.PalNombre
	FROM
						agencias.dbo.PROJECTE						p
		INNER JOIN		agencias.dbo.PROJECTE_ALTRES				pa	ON pa.PalProyecto = p.P_Codi
	WHERE
		P_client = 18224 
)

SELECT
	PRO.P_codi,
	PEND.Incidencia,
	PEND.Integrador,
	PRO.PalNombre,
	*
FROM 
				PENDING	PEND
	LEFT JOIN	PROYECTS PRO ON  PRO.PalNombre = PEND.Integrador -- PRO.PalNombre LIKE CONCAT('%',PEND.Integrador,'%') OR  DIFFERENCE (PRO.PalNombre, PEND.Integrador) = 4
WHERE
	1 = 1
	AND PRO.P_codi IS NOT NULL
	--AND P_codi IS 8897
ORDER BY
	PRO.P_codi


