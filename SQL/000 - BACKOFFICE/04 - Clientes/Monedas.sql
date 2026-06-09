SELECT
C.Id_Cli, C.Cli_Nombre, CC.CCl_MonedasOperacionCliente,
GA.Id_GRA, GA.GRA_Nombre, GC.Mon_Siglas,
M.Id_Mer, M.Mer_Nombre, MC.Mon_Siglas
FROM
				Tbl_Cliente						C
	INNER JOIN	Tbl_ClienteConfiguracion		CC	ON CC.Id_Cli = C.Id_Cli
	INNER JOIN	Tbl_GrupoAgencia				GA	ON GA.Id_GRA = C.Id_GRA
	INNER JOIN	Tbl_Mercado						M	ON M.Id_Mer = GA.Id_Mer
	LEFT JOIN	Tbl_GraNCur						GC	ON GC.Id_Gra = GA.Id_GRA
	LEFT JOIN	Tbl_MerNCur						MC	ON MC.Id_Mer = M.Id_Mer
WHERE
	1 = 1
	AND CC.CCl_MonedasOperacionCliente IS NULL
	AND GC.Mon_Siglas IS NULL
