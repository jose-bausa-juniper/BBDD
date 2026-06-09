USE BD_Nincoming

SELECT
	R.id_Can,
	R.Id_Ifz,
	R.Res_Estado,
	LR.LRe_CupoAsignado,
	R.Res_Localizador,
	R.id_res,
	LR.Id_LRe,
	R.Res_Fecha,
	R.Res_FechaInicioViaje,
	LR.LRE_IdSustituyente,
	LR.LRe_FechaConGastos
FROM
				Tbl_Reserva			R
	INNER JOIN	Tbl_LineaReserva	LR ON LR.id_Res = R.id_Res
WHERE
	1 = 1
	AND R.Id_Ifz = 'XML'
	AND R.id_Can = 'WPRO'
	AND R.Res_Estado IN ('PAG')
	AND LR.LRe_CupoAsignado = 0
	AND LR.LRe_ExtLocalizador is null
	AND LR.LRE_IdSustituyente is null
	AND LR.LRe_FechaConGastos <= R.Res_Fecha
	--AND R.Res_Localizador = '1ZH7JJ'
ORDER BY 
	R.Res_FechaInicioViaje ASC