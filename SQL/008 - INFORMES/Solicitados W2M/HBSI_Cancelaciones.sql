USE BD_Nincoming
SELECT
	COUNT(H1.His_Texto) AS [COUNT],
	X.[R.Res_Fecha],
	X.[R.id_Res],
	X.[R.Res_Localizador],
	X.[R.Res_Estado],
	X.[LR.Id_LRe],
	X.[LR.LRe_CupoAsignado],
	X.[LR.LRe_Cancelada],
	X.[LR.LRe_ExtLocalizador],
	X.[LR.LRe_finiViaje],
	X.[LR.LRe_FechaConGastos],
	X.[LR.LRe_GastosCancelacionCoste],
	X.[LR.LRe_PrecioReserva],
	X.[H.His_Texto]
	,X.[H.His_Fecha]
	,H1.His_Texto
	,H1.His_Usuario
	
FROM
	(
	SELECT
		R.Res_Fecha						AS [R.Res_Fecha],
		R.id_Res						AS [R.id_Res],
		R.Res_Localizador				AS [R.Res_Localizador],
		R.Res_Estado					AS [R.Res_Estado],
		LR.Id_LRe						AS [LR.Id_LRe],
		LR.LRe_CupoAsignado				AS [LR.LRe_CupoAsignado],
		LR.LRe_Cancelada				AS [LR.LRe_Cancelada],
		LR.LRe_ExtLocalizador			AS [LR.LRe_ExtLocalizador],
		LR.LRe_finiViaje				AS [LR.LRe_finiViaje],
		LR.LRe_FechaConGastos			AS [LR.LRe_FechaConGastos],
		LR.LRe_GastosCancelacionCoste	AS [LR.LRe_GastosCancelacionCoste],
		LR.LRe_PrecioReserva			AS [LR.LRe_PrecioReserva],
		MAX(H.His_Fecha)				AS [H.His_Fecha],
		H.His_Texto						AS [H.His_Texto]
	FROM			TBL_Reserva			R
		INNER JOIN	Tbl_LineaReserva	LR	ON LR.id_Res = R.id_Res
		INNER JOIN	TBl_historial		H	ON (H.Id_LRe = LR.Id_LRe AND H.His_texto LIKE '%Error al liberar cupo: System.Exception%')
	WHERE
		1 = 1
		AND LR.LRe_Tipo = 'HSI'
		AND H.His_Fecha > '2024-12-17'
		--AND LR.LRe_CupoAsignado = 1
		
	GROUP BY
		R.Res_Fecha,
		R.id_Res,
		R.Res_Localizador,
		R.Res_Estado,
		LR.Id_LRe,
		LR.LRe_CupoAsignado,
		LR.LRe_Cancelada,
		LR.LRe_ExtLocalizador,
		LR.LRe_finiViaje,
		LR.LRe_FechaConGastos,
		LR.LRe_PrecioReserva,
		LR.LRe_GastosCancelacionCoste,
		H.His_Texto
	)								AS X
	INNER JOIN	TBl_historial		AS H1	ON H1.Id_LRe = X.[LR.Id_LRe] AND H1.His_Texto LIKE '%Linea de reserva creada:%' --OR H1.His_Usuario  LIKE '%Cata%'
	WHERE 
		1 = 1
		--AND (H1.His_Texto LIKE '%la línea de reserva no está sincronizada con el proveedor externo%' OR H1.His_Texto LIKE'%esta acción no ha actualizado la reserva externa en el proveedor%')
		--AND	X.[LR.LRe_FechaConGastos] > GETDATE()
		--AND 	X.[LR.LRe_Cancelada] = 0
GROUP BY
	X.[R.Res_Fecha],
	X.[R.id_Res],
	X.[R.Res_Localizador],
	X.[R.Res_Estado],
	X.[LR.Id_LRe],
	X.[LR.LRe_CupoAsignado],
	X.[LR.LRe_Cancelada],
	X.[LR.LRe_ExtLocalizador],
	X.[LR.LRe_finiViaje],
	X.[LR.LRe_FechaConGastos],
	X.[LR.LRe_GastosCancelacionCoste],
	X.[LR.LRe_PrecioReserva],
	X.[H.His_Texto]
	,X.[H.His_Fecha]
	,H1.His_Texto
	,H1.His_Usuario

HAVING 
	COUNT(H1.His_Texto) > 0
ORDER BY
	X.[LR.LRe_FechaConGastos] ASC