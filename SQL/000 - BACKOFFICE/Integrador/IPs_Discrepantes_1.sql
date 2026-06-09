---------------------AGENCIAS INDICADAS----------------------
------------------TIENEN LAS SIGUIENTES IPS------------------
----|LOGIN				AGENCIA								|
----|eroski59186.tec	AZULMARINO VIAJES W2M SA (CENTRAL)	|
----|AZULMC1XML			AZULMARINO CENTRAL					|
----|APIJUNVCNC			VIAJES CIBELES						|
----|TSVACAPIJUN		THE SPHERE VAC						|
----------------NINGUNA DE LAS IPS INDICADAS----------------
SELECT 
	CAG.Id_CAg																		AS [ID_AGENTE],
	CAG.CAg_Nombre																	AS [NOMBRE_AGENTE],
	CAG.CAg_Login																	AS [LOGIN_AGENTE],
	C.Id_Cli																		AS [ID_AGENCIA],
	C.Cli_Nombre																	AS [NOMBRE_AGENCIA],
	C.Id_Int																		AS [ID_INTEGRADOR],
	IWS.Int_Nombre																	AS [NOMBRE_INTEGRADOR],
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP/256/256/256) % 256) + '.' + 
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP/256/256) % 256) + '.' + 
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP/256) % 256) + '.' + 
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP) % 256)							AS [IP_AGENCIA]
FROM 
				Tbl_cliente			C
	INNER JOIN	Tbl_ClienteAgente	CAG	ON CAG.Id_Cli = C.Id_Cli
	INNER JOIN	Tbl_IntegradorWS	IWS	ON IWS.Id_Int = C.Id_Int
	FULL JOIN	Tbl_ListaIPs		LIP ON C.id_cli = LIP.LIP_IdUsuario 
WHERE 
	1 = 1
	AND CAG.CAg_Login IN ('eroski59186.tec','AZULMC1XML','APIJUNVCNC','TSVACAPIJUN')
	AND LIP.LIP_TipoUsuario = 'Cli'
GROUP BY
	CAG.Id_CAg,
	CAG.CAg_Nombre,
	CAG.CAg_Login,
	C.Id_Cli,
	C.Cli_Nombre,
	C.Id_Int,
	IWS.Int_Nombre,
	LIP_DirIP

--------IPS PROPORCIONADAS--------
-------ESTAN REGISTRADAS EN-------
----|IP					Entorno	|
----|40.119.148.62		PROD	|
----|20.123.135.198		PRE		|
----|51.124.243.70		PRE		|
----|20.93.154.50		PRE		|
----|20.4.20.214		PRE		|
----|20.4.20.226		PRE		|
-------EN NINGUNA DE LAS AGENCIAS INDICADAS-------

SELECT
	CASE
		WHEN (CLI.Id_Cli IS NOT NULL)	THEN 'CLI'
		WHEN (IWS.Id_Int IS NOT NULL)	THEN 'INT'
		WHEN (WSA.Id_Aws IS NOT NULL)	THEN 'WSA'			
	END																				AS [TYPE],
	CASE
		WHEN (CLI.Id_Cli IS NOT NULL)	THEN CLI.Id_Cli
		WHEN (IWS.Id_Int IS NOT NULL)	THEN IWS.Id_Int
		WHEN (WSA.Id_Aws IS NOT NULL)	THEN WSA.Id_Aws			
	END																				AS [ID],
	CASE
		WHEN (CLI.Id_Cli IS NOT NULL)	THEN CLI.Cli_Nombre
		WHEN (IWS.Id_Int IS NOT NULL)	THEN IWS.Int_Nombre
		WHEN (WSA.Id_Aws IS NOT NULL)	THEN WSA.Aws_Nombre
	END																				AS [NOMBRE],
	LIP.LIP_Descripcion,
	IWS1.Int_Nombre																	AS [INTEGRADOR],
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP/256/256/256) % 256) + '.' + 
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP/256/256) % 256) + '.' + 
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP/256) % 256) + '.' + 
	CONVERT(VARCHAR(MAX),CONVERT(BIGINT,LIP_DirIP) % 256)							AS [IP_AGENCIA]
FROM
				Tbl_ListaIPs		LIP
	LEFT JOIN	Tbl_IntegradorWS	IWS		ON (LIP.LIP_TipoUsuario = 'Int' AND LIP.LIP_IdUsuario = IWS.Id_Int)
	LEFT JOIN	Tbl_Cliente			CLI		ON (LIP.LIP_TipoUsuario = 'Cli' AND LIP.LIP_IdUsuario = CLI.Id_Cli)
	LEFT JOIN	Tbl_AdministradorWS	WSA		ON (LIP.LIP_TipoUsuario = 'WSA' AND LIP.LIP_IdUsuario = WSA.Id_Aws)
	LEFT JOIN	Tbl_IntegradorWS	IWS1	ON (IWS1.Id_Int = CLI.Id_Int)
WHERE 
	1 = 1
	AND LIP.LIP_DirIP IN (678925374,343640006,863826758,341678642,335811798,335811810)
	AND LIP.LIP_IdUsuario IS NOT NULL
	AND LIP.LIP_TipoUsuario = 'CLI'
	AND IWS1.Int_Nombre <> 'W2M (World 2 Meet)'
	--AND CLI.Id_Cli IN (59186,18104,80372,80189)
ORDER BY
	[INTEGRADOR],
	[IP_AGENCIA],
	[ID]
