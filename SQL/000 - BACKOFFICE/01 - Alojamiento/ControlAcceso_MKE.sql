USE BD_Nincoming

SELECT 
	MKE.MkE_Desc,
	CC.CCL_EnviarAutoFactura,
	C.Cli_FacPropia,
	C.id_Cli,
	CASE 
		WHEN C.Cli_Nombre IS NULL THEN 'Todos'
		ELSE C.Cli_Nombre
	END													AS [CLIENTE],
	CASE
		WHEN GA.GRA_Nombre IS NULL THEN 'Todos'
		ELSE GA.GRA_Nombre
	END													AS [GRUPO AGENCIA],
	CASE
		WHEN M.Mer_Nombre IS NULL THEN 'Todos'
		ELSE M.Mer_Nombre
	END													AS [MERCADO],
	CASE
		WHEN P.pai_Nombre IS NULL THEN 'Todos'
		ELSE P.pai_Nombre
	END													AS [PAIS],
	CASE
		WHEN GP.GPa_Nombre IS NULL THEN 'Todos'
		ELSE GP.GPa_Nombre
	END													AS [GRUPO PAIS],
	CASE CAE.CAE_denegar
		WHEN 0 THEN 'PERMITIDO'
		WHEN 1 THEN	'DENEGADO'
	END													AS [ACCESO]
FROM 
				Tbl_MarkupEspecial			MKE
	LEFT JOIN	Tbl_ControlAcceso			CA	ON CA.CAc_Tipo = 'Mrk' AND CA.CAc_Codigo = MKE.Id_MkE
	LEFT JOIN	Tbl_ControlAccesoExtendido	CAE	ON CAE.Id_CAc = CA.Id_CAc
	LEFT JOIN	Tbl_Cliente					C	ON C.Id_Cli = CA.Id_Cli
	LEFT JOIN	Tbl_ClienteConfiguracion	CC	ON CC.Id_Cli = C.Id_Cli
	LEFT JOIN	Tbl_GrupoAgencia			GA	ON GA.Id_GRA = CA.Id_Gra 
	LEFT JOIN	Tbl_Mercado					M	ON M.Id_Mer = CA.Id_Mer
	LEFT JOIN	Tbl_Paises					p	ON P.id_pai	= CAE.Id_Pai
	LEFT JOIN	Tbl_GrupoPais				GP	ON GP.id_GPa = CAE.Id_GPa
WHERE 
	1 = 1
	AND CCL_EnviarAutoFactura = 0 
	AND C.Cli_Activa = 1 
	AND C.Cli_FacPropia = 1
	AND MKE.Mke_Activo = 1
	--AND C.Cli_Nombre LIKE '%azul%' 
	--AND MkE_Desc = 'AZULMARINO'





