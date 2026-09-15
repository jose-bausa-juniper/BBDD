SELECT 
	SE.Id_Sex					AS [ID_Sistema_Externo],
	SE.SEx_Nombre				AS [Nombre_Sistema_Externo],
	CASE
		WHEN SE.Sex_ExportacionContratos = 1 AND SE.SEx_importacionReservas = 1
		THEN 'PUSH AND RETRIVE'
		WHEN SE.Sex_ExportacionContratos = 0 AND SE.SEx_importacionReservas = 1
		THEN 'RETRIVE'
	END							AS [Funcionalidad],
	CC.Ctc_Codigo				AS [Tipo_Conexión],
	CC.Coc_Url					AS [URL_Retrive],
	CC.Coc_UrlContratos			AS [URL_Push],
	CC.Coc_User					AS [Usuario_Extranet]
FROM 
				Tbl_ConfiguracionConexion 	CC
	LEFT JOIN	Tbl_SistemaExterno			SE ON SE.Id_SEx = CC.Id_Sex

WHERE
	1 = 1
	AND CC.Coc_Url LIKE '%jet2%'


