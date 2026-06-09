USE BD_Nincoming

SELECT 
	C.Cli_Nombre,
	CET.id_Cli,
	CEC_FechaInicio,
	CEC_FechaFinal,
	CONVERT(TIME (0), CEC_FechaFinal - CEC_FechaInicio,0) AS Time,
	CEC_Clase,
	CEC_Tipo
	--CAST(DECOMPRESS(CEC_InformacionBin) AS XML)
FROM
					Tbl_ControlEnvioTarifario	CET
	LEFT JOIN		Tbl_Cliente					C ON C.Id_Cli = CET.id_Cli
WHERE
	1 = 1
	--AND CET.id_Cli = 79796
	--AND CEC_Clase = 'Push-Extra'
	AND	CET.Feccre > CONVERT(DATE, GETDATE() -1)
ORDER BY
	Time DESC,
	CEC_FechaInicio

