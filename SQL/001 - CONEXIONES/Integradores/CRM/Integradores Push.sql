WITH
PUSHES_JP AS (
SELECT 
	C.Id_Cli			AS [Id_Agencia],
	C.Cli_Nombre		AS [Agencia],
	IWS.Int_Nombre		AS [Integrador],
	'PUSH_JP'			AS [Tipo]
FROM 
				Tbl_Cliente									C 
	INNER JOIN	Tbl_ClienteConfigRates						CCR		ON C.Id_Cli = CCR.Id_Cli
	FULL JOIN	Tbl_ClienteConfigRatesNIdiomasExportacion	CCRNIE	ON CCR.id_Ccr = CCRNIE.id_Ccr
	LEFT JOIN	Tbl_IntegradorWS							IWS		ON C.id_int = IWS.id_int
WHERE 
	1 = 1
	AND CCR.Cli_WSRates = 1
	AND C.Id_Int IS NOT NULL
GROUP BY
	C.Id_Cli,
	C.Cli_Nombre,
	C.Cli_Activa,
	IWS.Int_Nombre,
	CCR.Cli_WSRates,
	CCR.Cli_WSRatesTipo
),
PUSHES_EDF AS (
SELECT 
	c.id_cli		AS [Id_Agencia],
	c.Cli_Nombre	AS [Agencia],
	iws.Int_Nombre	AS [Integrador],
	'PUSH_EDF'		AS [Tipo]
FROM 
				Tbl_Cliente							c 
	INNER JOIN	Tbl_ConfiguracionConexionAgencia	cca	ON c.Id_Cli = cca.Id_Cli
	INNER JOIN	Tbl_IntegradorWS					iws ON c.id_int = iws.id_int
	FULL JOIN	Tbl_ConfiguracionEjecucionAgencia	cea ON cca.Id_Cca = cea.Id_Cca
WHERE 
	1 = 1
	AND cca.Cca_Activo = 1
),
FLATFILES AS (
SELECT 
	C.Id_Cli		AS [Id_Agencia],
	C.Cli_Nombre	AS [Agencia],
	IWS.Int_Nombre	AS [Integrador],
	'FLAT FILE'		AS [Tipo]
FROM 
				Tbl_Cliente							C
	INNER JOIN	Tbl_ClienteFlatFileConfiguracion	CFFC	ON CFFC.Id_Cli = C.Id_Cli
	INNER JOIN	Tbl_IntegradorWS					IWS		ON C.id_int = IWS.id_int
WHERE 
	1 = 1
)



SELECT DISTINCT [Integrador], [Tipo]
FROM (
    SELECT * FROM PUSHES_JP
    UNION ALL
    SELECT * FROM PUSHES_EDF
    UNION ALL
    SELECT * FROM FLATFILES
) t
ORDER BY [Tipo], [Integrador];