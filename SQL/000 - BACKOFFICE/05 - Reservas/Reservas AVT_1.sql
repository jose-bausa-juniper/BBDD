SELECT
R.Id_Res,
R.Res_Localizador,
R.Res_Estado,
LR.LRe_CupoAsignado,
LR.Lre_Disponible,
LR.Id_LRe,
LR.LRe_ExtLocalizador				AS [LOC AVANTIO],
LR.Lre_localizadorExternoCliente	AS [LOC CLIENTE]
--* 
FROM Tbl_Reserva R
INNER JOIN Tbl_LineaReserva LR ON LR.Id_Res = R.id_Res
INNER JOIN Tbl_ReservaAlojamientoExterno RAE ON RAE.Id_LRe = LR.Id_LRe

WHERE
1 = 1
AND RAE.RAE_tipoProducto = 'AVT'
AND LR.LRe_ExtLocalizador IS NULL
--AND	R.Id_Res = 22642637

GROUP BY
	R.Id_Res,
	R.Res_Localizador,
	R.Res_Estado,
	LR.LRe_CupoAsignado,
	LR.Lre_Disponible,
	LR.Id_LRe,
	LR.LRe_ExtLocalizador,
	LR.Lre_localizadorExternoCliente

ORDER BY
	[LOC AVANTIO] DESC
	