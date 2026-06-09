--SELECT * FROM TBL_Parametro WHERE PAR_Codigo like '%CambiarEstadoReservaValidandoImportePendiente%'

--UPDATE Tbl_Parametro SET Par_Valor = 0 WHERE Id_Par = 16539

/*AFECTADAS*/
SELECT 
	C.Id_Cli,
	C.Cli_Nombre,
	C.Cli_TipoPago,
	R.Id_Res,
	R.Res_Localizador,
	R.Res_Estado,
	R.Res_Estados,
	R.Res_Caducidad,
	H.His_Texto
FROM  
				TBl_Reserva				R
	LEFT JOIN	TBl_Cliente				C  ON C.id_Cli = R.Id_Age
	LEFT JOIN   TBL_HISTORIAL			H  ON H.ID_RES = R.ID_RES
WHERE
	1 = 1
	AND R.Res_FechaUltimaModificacion >= '2026-01-12 10:12:22.743' 
	--AND C.Cli_TipoPago = 'B'
	--AND R.Res_tipopago = 'C'
	AND (H.His_Texto LIKE '%La diferencia de cobro total:%'
	OR H.His_Texto LIKE '%El estado de reserva se cambió a CON debido a que la cantidad pagada%')


/*AUTO CANCELADAS*/
SELECT 
	C.Id_Cli,
	C.Cli_Nombre,
	C.Cli_TipoPago,
	R.Id_Res,
	R.Res_Localizador,
	R.Res_Estado,
	R.Res_Estados,
	R.Res_Caducidad
FROM  
				TBl_Reserva				R
	LEFT JOIN	TBl_Cliente				C  ON C.id_Cli = R.Id_Age
	LEFT JOIN   TBL_HISTORIAL			H  ON H.ID_RES = R.ID_RES
WHERE
	1 = 1
	AND R.Res_FechaUltimaModificacion >= '2026-01-12 10:12:22.743'
	AND C.Cli_TipoPago = 'C' 
	AND R.res_tipopago = 'C'
	AND H.His_Texto LIKE '%El estado de reserva se cambió a CON debido a que la cantidad pagada%'
	AND R.Res_Estados = 16
	AND R.res_Estado = 'CAN'


/*AFECTADAS*/
SELECT 
	C.Id_Cli,
	C.Cli_Nombre,
	C.Cli_TipoPago,
	R.Id_Res,
	R.Res_Localizador,
	R.Res_Estado,
	R.Res_Estados,
	R.Res_Caducidad
FROM  
				TBl_Reserva				R
	LEFT JOIN	TBl_Cliente				C  ON C.id_Cli = R.Id_Age
	LEFT JOIN   TBL_HISTORIAL			H  ON H.ID_RES = R.ID_RES
WHERE
	1 = 1
	AND R.Res_FechaUltimaModificacion >= '2026-01-12 10:12:22.743' 
	AND C.Cli_TipoPago = 'C'
	AND R.Res_tipopago = 'C'
	AND H.His_Texto LIKE '%El estado de reserva se cambió a CON debido a que la cantidad pagada%'
	AND R.Res_Caducidad IS NOT NULL
	AND R.Res_Estado = 'Con'



