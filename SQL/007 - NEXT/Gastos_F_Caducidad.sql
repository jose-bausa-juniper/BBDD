SELECT 
	R.Res_Localizador,
	LR.Id_LRe,
	R.Res_Estado,
	R.Res_Fecha,
	R.Res_FechaInicioViaje,
	LR.LRe_FechaConGastos,
	R.Res_Caducidad,
	R.Id_Can,
	R.Id_Ifz,
	R.Id_Age,
	C.Cli_Nombre,
	C.Cli_TipoPago,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada
FROM 
				tbl_reserva			R
	INNER JOIN	Tbl_Historial		H	ON H.Id_Res = R.Id_Res
	INNER JOIN	Tbl_Cliente			C	ON C.Id_Cli = R.Id_Age
	INNER JOIN	Tbl_LineaReserva	LR	ON LR.Id_Res = R.id_Res
WHERE 
	1 = 1
	AND (R.Res_Fecha BETWEEN '2024-01-01' AND CONVERT (DATE, GETDATE()))
	--AND LR.LRe_FechaConGastos >= GETDATE()
	--AND (LR.LRe_FechaConGastos <= GETDATE() AND R.Res_FechaInicioViaje >= CONVERT (DATE, GETDATE()))
	--AND (LR.LRe_FechaConGastos <= GETDATE() AND R.Res_FechaInicioViaje < CONVERT (DATE, GETDATE()))
	AND R.Res_Estado = 'Con'
	AND C.Cli_TipoPago <> 'C'
	AND R.Res_Caducidad IS NULL
	AND	LR.LRe_CupoAsignado = 1
	AND LR.LRe_Cancelada = 0
	AND H.His_Texto LIKE '%<text><es>Fecha de caducidad eliminada debido a que la fecha de pago de la agencia%'
GROUP BY
	R.Res_Localizador,
	LR.Id_LRe,
	R.Res_Estado,
	R.Res_Fecha,
	R.Res_FechaInicioViaje,
	LR.LRe_FechaConGastos,
	R.Res_Caducidad,
	R.Id_Can,
	R.Id_Ifz,
	R.Id_Age,
	C.Cli_Nombre,
	C.Cli_TipoPago,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada
ORDER BY 
	R.Res_FechaInicioViaje DESC