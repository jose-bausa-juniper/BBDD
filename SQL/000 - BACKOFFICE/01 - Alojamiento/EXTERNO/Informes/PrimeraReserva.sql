USE BD_Nincoming;

SELECT 
	
	Distinct(R.Id_Res),
	R.id_res,
	R.Res_Fecha,
	COUNT (*)
FROM 

				Tbl_ReservaAlojamientoExterno		RAE	
	INNER JOIN	Tbl_LineaReserva					LR		ON LR.Id_LRe = RAE.Id_LRe
	INNER JOIN	Tbl_Reserva							R		ON R.Id_Res = LR.Id_Res
WHERE
		1 = 1
	AND	RAE.RAE_tipoProducto = 'DY20'
	--AND R.Feccre BETWEEN '2024-02-01' AND '2024-03-01'
	AND R.Res_Estado IN ('Con','Pag')

GROUP BY
	R.Id_Res,
	R.Res_Fecha

ORDER BY
	R.Res_Fecha

--HAVING COUNT(DISTINCT (R.Id_Res))>=1