USE BD_NIncoming
--Reservas gestionables, es decir, con fecha de gastos a futuro, se le debe reclamar a la agencia el pago, en caso de no pagar, se debe cancelar la reserva antes de la fecha de gastos:
SELECT 
	R.Res_Localizador,
	R.Id_Res,
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
	C.cli_PrepagoReservaEntranEnGastos,
	CC.CCl_PrepagoQUOenWS,
	H.His_Usuario,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada,
	R.Id_Adm,
	A.Adm_Nombre,
	'Reservas gestionables - Gastos y CheckIn a Futuro'
FROM 
	            	Tbl_reserva         			R
	INNER JOIN  	Tbl_Historial           		H	ON H.Id_Res = R.Id_Res
	INNER JOIN  	Tbl_Cliente            		C	ON C.Id_Cli = R.Id_Age
	INNER JOIN  	Tbl_ClienteConfiguracion	CC 	ON CC.Id_Cli = C.Id_Cli
	INNER JOIN  	Tbl_LineaReserva  			LR  	ON LR.Id_Res = R.id_Res
	LEFT JOIN	Tbl_Administrador			A	ON A.Id_Adm = R.Id_Adm
WHERE 
	1 = 1
	AND (R.Res_Fecha BETWEEN '2025-05-01' AND CONVERT (DATE, GETDATE()))
	AND LR.LRe_FechaConGastos >= GETDATE()
	AND R.Res_Estado = 'Con'
	AND R.Id_Ifz <> 'CLC'
	--AND R.Id_Can = 'WPRO'
	AND C.Cli_TipoPago <> 'C'
	AND R.Res_Caducidad IS NULL
	AND LR.LRe_CupoAsignado = 1
	AND LR.LRe_Cancelada = 0
	AND H.His_Texto LIKE '%<text><es>Fecha de caducidad eliminada debido a que la fecha de pago de la agencia%'
GROUP BY
	R.Res_Localizador,
	R.Id_Res,
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
	C.cli_PrepagoReservaEntranEnGastos,
	CC.CCl_PrepagoQUOenWS,
	H.His_Usuario,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada,
	R.Id_Adm,
	A.Adm_Nombre
ORDER BY
	R.Res_FechaInicioViaje DESC

--Reservas gestionables, es decir, con fecha de gastos a pasado, pero fecha de check-in a futuro por si se le puede reclamar a la agencia el pago, en caso contrario, cancelar y seguir procedimiento habitual:
SELECT 
	R.Res_Localizador,
	R.Id_Res,
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
	C.cli_PrepagoReservaEntranEnGastos,
	CC.CCl_PrepagoQUOenWS,
	H.His_Usuario,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada,
	R.Id_Adm,
	A.Adm_Nombre,
	'Reservas gestionables - Gastos en Pasado y CheckIn a Futuro'
FROM 
	            	Tbl_reserva         			R
	INNER JOIN  	Tbl_Historial           		H	ON H.Id_Res = R.Id_Res
	INNER JOIN  	Tbl_Cliente            		C	ON C.Id_Cli = R.Id_Age
	INNER JOIN  	Tbl_ClienteConfiguracion	CC 	ON CC.Id_Cli = C.Id_Cli
	INNER JOIN  	Tbl_LineaReserva  			LR  	ON LR.Id_Res = R.id_Res
	LEFT JOIN	Tbl_Administrador			A	ON A.Id_Adm = R.Id_Adm
WHERE 
	1 = 1
	AND (R.Res_Fecha BETWEEN '2025-05-01' AND CONVERT (DATE, GETDATE()))
	AND (LR.LRe_FechaConGastos <= GETDATE() AND R.Res_FechaInicioViaje >= CONVERT (DATE, GETDATE())) AND R.Res_Estado = 'Con'	AND C.Cli_TipoPago <> 'C'
	AND R.Res_Caducidad IS NULL
	--AND R.Id_Can = 'WPRO'
	AND R.Id_Ifz <> 'CLC'
	AND LR.LRe_CupoAsignado = 1
	AND LR.LRe_Cancelada = 0
	AND H.His_Texto LIKE '%<text><es>Fecha de caducidad eliminada debido a que la fecha de pago de la agencia%'
GROUP BY
	R.Res_Localizador,
	R.Id_Res,
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
	C.cli_PrepagoReservaEntranEnGastos,
	CC.CCl_PrepagoQUOenWS,
	H.His_Usuario,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada,
	R.Id_Adm,
	A.Adm_Nombre
ORDER BY
	R.Res_FechaInicioViaje DESC

--Reservas impactadas, es decir, entrada en gastos  y el check-in es a pasado:
SELECT 
	R.Res_Localizador,
	R.Id_Res,
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
	C.cli_PrepagoReservaEntranEnGastos,
	CC.CCl_PrepagoQUOenWS,
	H.His_Usuario,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada,
	R.Id_Adm,
	A.Adm_Nombre
	'Impactada - Gastos y CheckIn en Pasado'
FROM 
				Tbl_reserva         			R
	INNER JOIN  	Tbl_Historial           		H	ON H.Id_Res = R.Id_Res
	INNER JOIN  	Tbl_Cliente            		C	ON C.Id_Cli = R.Id_Age
	INNER JOIN  	Tbl_ClienteConfiguracion	CC 	ON CC.Id_Cli = C.Id_Cli
	INNER JOIN  	Tbl_LineaReserva  			LR  	ON LR.Id_Res = R.id_Res
	LEFT JOIN	Tbl_Administrador			A	ON A.Id_Adm = R.Id_Adm
WHERE 
	1 = 1
	AND (R.Res_Fecha BETWEEN '2025-05-01' AND CONVERT (DATE, GETDATE()))
	AND (LR.LRe_FechaConGastos <= GETDATE() AND R.Res_FechaInicioViaje < CONVERT (DATE, GETDATE())) AND R.Res_Estado = 'Con' AND C.Cli_TipoPago <> 'C'
	AND R.Res_Caducidad IS NULL
	AND R.Id_Ifz <> 'CLC'
	--AND R.Id_Can = 'WPRO'
	AND LR.LRe_CupoAsignado = 1
	AND LR.LRe_Cancelada = 0
	AND H.His_Texto LIKE '%<text><es>Fecha de caducidad eliminada debido a que la fecha de pago de la agencia%'
GROUP BY
	R.Res_Localizador,
	R.Id_Res,
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
	C.cli_PrepagoReservaEntranEnGastos,
	CC.CCl_PrepagoQUOenWS,
	H.His_Usuario,
	H.His_Texto,
	LR.LRe_CupoAsignado,
	LR.LRe_Cancelada,
	R.Id_Adm,
	A.Adm_Nombre
ORDER BY 
	R.Res_FechaInicioViaje DESC


--