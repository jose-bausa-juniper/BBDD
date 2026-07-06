USE BD_Nincoming
SELECT 

	R.Id_Res,
	R.Res_Localizador,
	R.Res_FechaInicioViaje,
	R.Res_FechaUltimaModificacion,
	LR.Id_LRe,
	LR.Lre_UltimaModificacion,
	LRA.lra_FacturadaExterna,
	RFE.Rfe_NumeroFactura,
	RFE.Rfe_URL
FROM			TBL_Reserva					R
	INNER JOIN	Tbl_LineaReserva			LR	ON LR.Id_Res = R.Id_Res
	LEFT JOIN	Tbl_lineaReservaAccounting  LRA	ON LRA.Id_lre = LR.Id_LRe
	LEFT JOIN	Tbl_ReservaFacturaExterna	RFE	ON RFE.Id_Res = R.Id_Res

WHERE 
	1 = 1
	AND LRA.lra_FacturadaExterna BETWEEN '2026-06-10' AND '2026-06-16'
	AND LRA.lra_FacturadaExterna IS NOT NULL
	AND RFE.Rfe_URL IS NULL
	--AND R.id_Res = 29489362
ORDER BY
	LRA.lra_FacturadaExterna ASC