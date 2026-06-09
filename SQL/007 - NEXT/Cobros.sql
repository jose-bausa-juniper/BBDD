USE BD_Nincoming
SELECT 
	C.Cob_FormaPago,
	C.Id_Cob,
	R.Id_Res,
	RE.Rex_PlatformBookingReference,
	C.Cob_Concepto
FROM 
					Tbl_Cobros				C
	INNER JOIN		Tbl_CobrosLinea			CL ON C.Id_Cob = CL.id_Cob
	INNER JOIN		Tbl_LineaReserva		LR ON CL.id_Lre = LR.Id_LRe
	INNER JOIN		Tbl_Reserva				R  ON LR.Id_Res = R.Id_Res
	INNER JOIN		Tbl_ReservaExtendida	RE ON RE.Id_Res = R.Id_Res
WHERE
	1 = 1
	AND R.Id_Ifz = 'XML'
	AND R.Id_Can = 'WPRO'
	AND R.Id_Res = 25240861
	--AND C.Feccre >= CONVERT (DATE, GETDATE()-7)
	AND RE.Rex_PlatformBookingReference IS NOT NULL
	--AND C.Cob_concepto LIKE 'WSJP#CFG-%'
ORDER BY 
	C.Cob_Concepto DESC