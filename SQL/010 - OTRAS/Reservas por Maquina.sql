SELECT 
	MAX(R.id_Res) AS [MAX_ID_RES],
	R.Id_Can,
	R.Id_Ifz,
	R.Res_Estado,
	LR.LRe_modulo,
	LR.LRe_CupoAsignado,
	LR.LRe_Tipo,
	H.His_Servidor,
	COUNT (*) AS [COUNT]
FROM 
				Tbl_Reserva			R
	RIGHT JOIN	Tbl_LineaReserva	LR	ON LR.id_Res = R.id_Res
	INNER JOIN	TBL_Historial		H	ON H.Id_Res = R.Id_Res
WHERE 
	1 = 1
	AND (LR.LRe_modulo = 'Servicio')
	AND R.Id_Can = 'WPRO'
	AND R.Id_Ifz = 'WEB'
	AND R.Feccre > '2025-04-01'
	AND H.His_Servidor = 'ESPMIONOWS243'
	AND H.His_Texto = '<text><es>Creación reserva</es><en>Booking created</en></text>'
GROUP BY
	R.Id_Can,
	R.Id_Ifz,
	R.Res_Estado,
	LR.LRe_modulo,
	LR.LRe_CupoAsignado,
	LR.LRe_Tipo,
	H.His_Servidor,
	H.His_Texto