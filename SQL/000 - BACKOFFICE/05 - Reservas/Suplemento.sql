USE BD_Nincoming

SELECT 
	TOP 5 
	R.Id_Res,
	R.Res_Localizador,
	R.id_Can,
	R.Id_Ifz,
	R.Id_Age,
	LR.Id_LRe,
	RAES.*  
FROM 
				Tbl_Reserva						R
	INNER JOIN	Tbl_LineaReserva				LR		ON LR.id_Res = R.Id_Res
	INNER JOIN	Tbl_ReservaAlojaExtSuplemento	RAES	ON RAES.Id_Lre = LR.Id_LRe

ORDER BY 1 DESC

SELECT 
	TOP 5 
	R.Id_Res,
	R.Res_Localizador,
	R.id_Can,
	R.Id_Ifz,
	R.Id_Age,
	R.Id_CAg,
	LR.Id_LRe,
	RA.Id_Alo,
	RA.RAl_JPCode,
	RAS.* 
FROM 
				Tbl_Reserva						R
	INNER JOIN	Tbl_LineaReserva				LR		ON LR.id_Res = R.Id_Res
	INNER JOIN	Tbl_ReservaAlojamiento			RA		ON RA.Id_Lre = LR.Id_LRe
	INNER JOIN	Tbl_ReservaAlojaSuplemento		RAS		ON RAS.Id_Lre = LR.Id_LRe

ORDER BY 1 DESC