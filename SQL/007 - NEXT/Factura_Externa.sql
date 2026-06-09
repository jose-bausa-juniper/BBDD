USE BD_Nincoming
SELECT 
	R.Id_Res,
	R.Res_Localizador,
	R.Res_FechaUltimaModificacion,
	LR.Id_LRe,
	LRA.Id_lra,
	LR.Lre_UltimaModificacion,
	LRA.lra_FacturadaExterna,
	RFE.Id_Rfe,
	RFE.Rfe_NumeroFactura,
	RFE.Rfe_URL
FROM			TBL_Reserva					R
	INNER JOIN	Tbl_LineaReserva			LR	ON LR.Id_Res = R.Id_Res
	INNER JOIN	Tbl_lineaReservaAccounting  LRA	ON LRA.Id_lre = LR.Id_LRe
	INNER JOIN	Tbl_ReservaFacturaExterna	RFE	ON RFE.Id_Res = R.Id_Res

WHERE 
	1 = 1
	AND R.Res_Localizador = '43CQQ2'