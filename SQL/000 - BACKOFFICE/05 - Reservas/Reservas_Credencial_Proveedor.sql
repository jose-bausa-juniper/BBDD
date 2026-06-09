SELECT
	TOP 10
	R.Res_Localizador,
	R.Id_Res,
	LR.Id_LRe,
	RAE.Id_RAC,
	RAE.RAE_tipoProducto,
	PIC.Id_Cre,
	PIC.CRE_Nombre

FROM
				Tbl_Reserva									R
	INNER JOIN	Tbl_LineaReserva							LR		ON LR.Id_Res = R.Id_Res
	INNER JOIN	Tbl_ReservaAlojamientoExterno				RAE		ON RAE.Id_LRe = LR.Id_LRe
	INNER JOIN	Tbl_ReservaAlojamientoExternoCredenciales	RAEC	ON RAEC.Id_RAC = RAE.Id_RAC
	INNER JOIN	Tbl_ParametroIntegracionCredencial			PIC		ON PIC.Id_CRE = RAEC.Id_Cre
WHERE
	RAE.RAE_tipoProducto = 'EXR'
ORDER BY
	1 DESC