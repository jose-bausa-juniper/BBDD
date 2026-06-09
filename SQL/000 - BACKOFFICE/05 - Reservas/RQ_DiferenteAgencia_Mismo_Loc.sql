USE BD_Nincoming;

DECLARE
@fechahoy DATETIME = GETDATE(),
@fechaayer DATETIME = GETDATE()-365

SELECT
	X.ID_RES,
	COUNT(X.His_Usuario) AS [NUM Usuarios]
FROM
	(
	SELECT 
		RES.[ID_RES],
		H.His_Usuario
	FROM
		(
		SELECT
		R.id_Res AS [ID_RES],
		LR.Id_LRe AS [ID_LR]
		FROM 
						Tbl_Reserva			R
			FULL JOIN	Tbl_LineaReserva	LR	ON LR.Id_Res = R.Id_Res
		WHERE
				1=1
				AND R.Res_Fecha >= GETDATE()-365
				AND R.Res_Estado = 'Ini'
				AND R.Id_Ifz = 'XML'
				AND R.Id_Can = 'WPRO'
				AND LR.Id_LRe IS NULL
		) AS RES INNER JOIN Tbl_Historial AS H ON H.Id_Res = RES.ID_RES
	GROUP BY
		RES.[ID_RES],
		His_Usuario
	) AS X
GROUP BY
	X.ID_RES
HAVING 
	COUNT(His_Usuario)>1 
ORDER BY
	COUNT(His_Usuario) DESC