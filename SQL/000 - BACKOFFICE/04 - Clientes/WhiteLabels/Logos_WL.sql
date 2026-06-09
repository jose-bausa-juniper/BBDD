SELECT
	C.Id_Cli																									AS [ID Cliente],
	C.Cli_Nombre																								AS [Nombre Cliente],
	--C.Cli_ImgLogo,
	CONCAT('https://backdmc.w2m.travel/',C.Cli_ImgLogo)															AS [Imagen Logo],
	--CA.Nombre,
	CONCAT('https://b2dmc.w2m.travel/images/documentosPaq/AgeFiles_',CA.IdCliente,'/LogoCliente/',CA.Nombre)	AS [Logo de la agencia]
FROM
				BD_Nincoming.dbo.Tbl_Cliente			C
	LEFT JOIN	BD_Nincoming.dbo.Tbl_ClienteAdjuntos	CA ON CA.IdCliente = C.Id_Cli
WHERE
	C.ID_Cli IN (77951,78140,11367,78844,79503,79682,79832,80701)


