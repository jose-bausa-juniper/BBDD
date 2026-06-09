SELECT
C.Cli_Nombre,
C.Cli_TipoPago,
R.Id_Res,
R.Id_Ifz,
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
INNER JOIN Tbl_Cliente C ON C.Id_Cli = R.Id_Age

WHERE
1 = 1
AND RAE.RAE_tipoProducto = 'AVT'
AND LR.LRe_ExtLocalizador IS NOT NULL
AND Res_Estado = 'Pag'
AND LRe_CupoAsignado = 0
--AND	R.Id_Res = 22642637

GROUP BY
	C.Cli_Nombre,
	C.Cli_TipoPago,
	R.Id_Res,
	R.Id_Ifz,
	R.Res_Localizador,
	R.Res_Estado,
	LR.LRe_CupoAsignado,
	LR.Lre_Disponible,
	LR.Id_LRe,
	LR.LRe_ExtLocalizador,
	LR.Lre_localizadorExternoCliente

ORDER BY
	R.Id_Ifz,
	C.Cli_TipoPago,
	R.Res_Estado DESC,
	LR.LRe_CupoAsignado

	