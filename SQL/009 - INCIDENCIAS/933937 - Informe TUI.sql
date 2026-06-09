USE BD_Nincoming;


SELECT 
	c.Id_Cli									AS [Id Cliente],
	c.Cli_Nombre								AS [Nombre Cliente],
	c.Cli_Activa								AS [Cliente Activo],
	c.Cli_AccesoWebservice						AS [Acceso WS],
	c.Id_Int									AS [Id Integrador],
	iws.Int_Nombre								AS [Nombre Integrador],
	CASE ccr.Cli_WSRates
		WHEN 1 THEN 1
		ELSE 0
	END											AS [Push JP],
	CASE 
		WHEN (cca.Id_Cca) IS NOT NULL THEN 1
		ELSE 0
	END											AS [PUSH EDF]
FROM 
					Tbl_Cliente							c
	FULL JOIN		Tbl_IntegradorWS					iws	ON c.Id_Int = iws.Id_Int
	FULL JOIN		Tbl_ClienteConfigRates				ccr	ON c.Id_Cli = ccr.Id_Cli
	FULL JOIN		Tbl_ConfiguracionConexionAgencia	cca	ON c.Id_Cli = cca.Id_Cli

WHERE 1 = 1
--	AND c.Cli_Nombre LIKE '%TUI%'
	AND c.id_cli  IN (12630 ,13413 ,13589 ,13590 ,13591 ,16430 ,16508 ,17607 ,65789 ,78438)

ORDER BY
	c.Cli_Activa,
	c.Cli_AccesoWebservice,
	c.Id_Int,
	[Push JP],
	[PUSH EDF]

SELECT
	R.Id_Age		AS [Id Cliente],
	C.Cli_Nombre	AS [Nombre Cliente],
	R.Id_Ifz		AS [Interfaz],
	R.Id_Can		AS [Canal], 
	COUNT (*)		AS [Num Reservas]
FROM
				Tbl_Reserva			R
	INNER JOIN	Tbl_Cliente			C ON R.id_Age = C.id_Cli
WHERE 1 = 1
	AND C.Cli_Nombre LIKE '%TUI%'
	AND R.Feccre > '2023-01-01'
	AND C.Id_Cli NOT IN (78888,79418,55149)
GROUP BY
	R.Id_Age,
	C.Cli_Nombre,
	R.Id_Ifz,
	R.Id_Can