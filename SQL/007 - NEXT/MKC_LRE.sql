SELECT
	R.Res_Localizador,
	R.Id_Res,
	LR.Id_LRe,
	Lrx_PorcentajeComisionExterna,
	R.Res_Fecha,
	H.His_Texto
FROM 
				Tbl_LineaReservaExtendido	LRE
	INNER JOIN	Tbl_LineaReserva			LR	ON LR.Id_LRe = LRE.Id_LRe
	INNER JOIN	Tbl_Reserva					R	ON R.Id_Res = LR.Id_Res
	INNER JOIN	Tbl_Historial				H	ON H.Id_Res = R.Id_Res 
WHERE 
	1 = 1
	AND R.Id_Can = 'WPRO'
	AND R.Res_Fecha > GETDATE () - 1
	AND Lrx_PorcentajeComisionExterna IS NOT NULL
	AND H.His_Texto LIKE '%Línea de reserva con un markup cliente%'
ORDER BY
	R.Id_Res DESC