USE BD_Nincoming;

SELECT 
	R.id_res,
	R.Res_Fecha,
	R.Res_Estado,
	R.Id_Age

FROM 
				Tbl_Reserva							R
	--INNER JOIN	Tbl_LineaReserva					LR		ON LR.Id_Res = R.Id_Res

WHERE
		1 = 1
	AND R.Feccre BETWEEN '2023-09-16' AND '2024-04-17'
	AND R.Id_Can = 'WPRO'
	AND R.Id_Ifz = 'xml'

GROUP BY
	R.id_res,
	R.Res_Fecha,
	R.Res_Estado,
	R.Id_Age

ORDER BY
	R.Res_Fecha DESC