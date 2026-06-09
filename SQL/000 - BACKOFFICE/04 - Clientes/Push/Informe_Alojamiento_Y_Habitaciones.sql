SELECT
	C.Id_Cli										AS [CLI],
	C.Cli_Nombre									AS [NOMBRE CLIENTE],
	CASE CEAH.Ceh_tipo
		WHEN 2 THEN 'JP'
		WHEN 0 THEN 'EDF'
	END												AS [TIPO],
	MAX(CEAH.Ceh_Log)								AS [LOG_COMPRIMIDO],
	CAST(DECOMPRESS (MAX(CEAH.Ceh_Log))AS XML)		AS [LOG],
	MAX(CEAH.FecCre)								AS [FECHA COMPLETA]
FROM
				BD_Nincoming_HIS.dbo.Tbl_ConfiguracionEjecucionAgenciaHistorial		CEAH
	INNER JOIN	BD_Nincoming.dbo.Tbl_Cliente										C		ON C.Id_Cli = CEAH.Id_Cli
WHERE
	1 = 1
	AND CEAH.Ceh_Tipo IN (0,2) /*  0 -> EDF ; 2 -> JP  */
	AND C.Id_Cli <> -1
	AND CONVERT (DATE, CEAH.FecCre) > CONVERT (DATE, (GETDATE()-7))
GROUP BY
	C.Id_Cli,
	C.Cli_Nombre,
	CEAH.Ceh_tipo
ORDER BY
	[CLI],
	[TIPO]