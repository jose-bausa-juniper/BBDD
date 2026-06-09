USE BD_BookingEngine;
SELECT
	INCI.MOD_id																	AS [MOD_id],
	CONCAT(INCI.Id_incidencia,' - ',agencias.dbo.converthtml(INCI.I_asumpte))	AS [ID_INCI],
	INCI.Id_incidencia															,
	agencias.dbo.converthtml(INCI.I_asumpte)									AS [I_asumpte]
FROM
	(SELECT
		MIN(Id_incidencia)	AS [Id_incidencia],
		MOD_id				AS [MOD_id]
	FROM
		agencias.dbo.INCIDENCIA
	WHERE
		A_codi = 18224
	GROUP BY
		MOD_id
	) AS MIN_INCI_X_MOD
	INNER JOIN agencias.dbo.INCIDENCIA INCI ON INCI.Id_incidencia = MIN_INCI_X_MOD.Id_incidencia